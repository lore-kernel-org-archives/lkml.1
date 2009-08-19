Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZHSNDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZHSNDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZHSNDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:03:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50592 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752043AbZHSNCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 45/47] KVM: remove in_range from io devices
Date: Wed, 19 Aug 2009 16:02:41 +0300
Message-Id: <1250686963-8357-46-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

This changes bus accesses to use high-level kvm_io_bus_read/kvm_io_bus_write
functions. in_range now becomes unused so it is removed from device ops in
favor of read/write callbacks performing range checks internally.

This allows aliasing (mostly for in-kernel virtio), as well as better error
handling by making it possible to pass errors up to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c  |   28 +++--------
 arch/x86/kvm/i8254.c      |   49 +++++++++++---------
 arch/x86/kvm/i8259.c      |   20 +++++---
 arch/x86/kvm/lapic.c      |   44 ++++++++----------
 arch/x86/kvm/x86.c        |  110 +++++++++++++--------------------------------
 include/linux/kvm_host.h  |    6 ++-
 virt/kvm/coalesced_mmio.c |   16 +++----
 virt/kvm/ioapic.c         |   22 +++++----
 virt/kvm/iodev.h          |   39 ++++++----------
 virt/kvm/kvm_main.c       |   26 +++++++----
 10 files changed, 152 insertions(+), 208 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 5c766bd..d7aa6bb 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -210,16 +210,6 @@ int kvm_dev_ioctl_check_extension(long ext)
 
 }
 
-static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
-					gpa_t addr, int len, int is_write)
-{
-	struct kvm_io_device *dev;
-
-	dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write);
-
-	return dev;
-}
-
 static int handle_vm_error(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
@@ -231,6 +221,7 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct kvm_mmio_req *p;
 	struct kvm_io_device *mmio_dev;
+	int r;
 
 	p = kvm_get_vcpu_ioreq(vcpu);
 
@@ -247,16 +238,13 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->exit_reason = KVM_EXIT_MMIO;
 	return 0;
 mmio:
-	mmio_dev = vcpu_find_mmio_dev(vcpu, p->addr, p->size, !p->dir);
-	if (mmio_dev) {
-		if (!p->dir)
-			kvm_iodevice_write(mmio_dev, p->addr, p->size,
-						&p->data);
-		else
-			kvm_iodevice_read(mmio_dev, p->addr, p->size,
-						&p->data);
-
-	} else
+	if (p->dir)
+		r = kvm_io_bus_read(&vcpu->kvm->mmio_bus, p->addr,
+				    p->size, &p->data);
+	else
+		r = kvm_io_bus_write(&vcpu->kvm->mmio_bus, p->addr,
+				     p->size, &p->data);
+	if (r)
 		printk(KERN_ERR"kvm: No iodevice found! addr:%lx\n", p->addr);
 	p->state = STATE_IORESP_READY;
 
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4082cdd..8c3ac30 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -358,8 +358,14 @@ static inline struct kvm_pit *speaker_to_pit(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_pit, speaker_dev);
 }
 
-static void pit_ioport_write(struct kvm_io_device *this,
-			     gpa_t addr, int len, const void *data)
+static inline int pit_in_range(gpa_t addr)
+{
+	return ((addr >= KVM_PIT_BASE_ADDRESS) &&
+		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
+}
+
+static int pit_ioport_write(struct kvm_io_device *this,
+			    gpa_t addr, int len, const void *data)
 {
 	struct kvm_pit *pit = dev_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
@@ -367,6 +373,8 @@ static void pit_ioport_write(struct kvm_io_device *this,
 	int channel, access;
 	struct kvm_kpit_channel_state *s;
 	u32 val = *(u32 *) data;
+	if (!pit_in_range(addr))
+		return -EOPNOTSUPP;
 
 	val  &= 0xff;
 	addr &= KVM_PIT_CHANNEL_MASK;
@@ -429,16 +437,19 @@ static void pit_ioport_write(struct kvm_io_device *this,
 	}
 
 	mutex_unlock(&pit_state->lock);
+	return 0;
 }
 
-static void pit_ioport_read(struct kvm_io_device *this,
-			    gpa_t addr, int len, void *data)
+static int pit_ioport_read(struct kvm_io_device *this,
+			   gpa_t addr, int len, void *data)
 {
 	struct kvm_pit *pit = dev_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	int ret, count;
 	struct kvm_kpit_channel_state *s;
+	if (!pit_in_range(addr))
+		return -EOPNOTSUPP;
 
 	addr &= KVM_PIT_CHANNEL_MASK;
 	s = &pit_state->channels[addr];
@@ -493,37 +504,36 @@ static void pit_ioport_read(struct kvm_io_device *this,
 	memcpy(data, (char *)&ret, len);
 
 	mutex_unlock(&pit_state->lock);
+	return 0;
 }
 
-static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
-			int len, int is_write)
-{
-	return ((addr >= KVM_PIT_BASE_ADDRESS) &&
-		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
-}
-
-static void speaker_ioport_write(struct kvm_io_device *this,
-				 gpa_t addr, int len, const void *data)
+static int speaker_ioport_write(struct kvm_io_device *this,
+				gpa_t addr, int len, const void *data)
 {
 	struct kvm_pit *pit = speaker_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	u32 val = *(u32 *) data;
+	if (addr != KVM_SPEAKER_BASE_ADDRESS)
+		return -EOPNOTSUPP;
 
 	mutex_lock(&pit_state->lock);
 	pit_state->speaker_data_on = (val >> 1) & 1;
 	pit_set_gate(kvm, 2, val & 1);
 	mutex_unlock(&pit_state->lock);
+	return 0;
 }
 
-static void speaker_ioport_read(struct kvm_io_device *this,
-				gpa_t addr, int len, void *data)
+static int speaker_ioport_read(struct kvm_io_device *this,
+			       gpa_t addr, int len, void *data)
 {
 	struct kvm_pit *pit = speaker_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	unsigned int refresh_clock;
 	int ret;
+	if (addr != KVM_SPEAKER_BASE_ADDRESS)
+		return -EOPNOTSUPP;
 
 	/* Refresh clock toggles at about 15us. We approximate as 2^14ns. */
 	refresh_clock = ((unsigned int)ktime_to_ns(ktime_get()) >> 14) & 1;
@@ -535,12 +545,7 @@ static void speaker_ioport_read(struct kvm_io_device *this,
 		len = sizeof(ret);
 	memcpy(data, (char *)&ret, len);
 	mutex_unlock(&pit_state->lock);
-}
-
-static int speaker_in_range(struct kvm_io_device *this, gpa_t addr,
-			    int len, int is_write)
-{
-	return (addr == KVM_SPEAKER_BASE_ADDRESS);
+	return 0;
 }
 
 void kvm_pit_reset(struct kvm_pit *pit)
@@ -574,13 +579,11 @@ static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 static const struct kvm_io_device_ops pit_dev_ops = {
 	.read     = pit_ioport_read,
 	.write    = pit_ioport_write,
-	.in_range = pit_in_range,
 };
 
 static const struct kvm_io_device_ops speaker_dev_ops = {
 	.read     = speaker_ioport_read,
 	.write    = speaker_ioport_write,
-	.in_range = speaker_in_range,
 };
 
 /* Caller must have writers lock on slots_lock */
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 1851aec..1d1bb75 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -430,8 +430,7 @@ static u32 elcr_ioport_read(void *opaque, u32 addr1)
 	return s->elcr;
 }
 
-static int picdev_in_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int is_write)
+static int picdev_in_range(gpa_t addr)
 {
 	switch (addr) {
 	case 0x20:
@@ -451,16 +450,18 @@ static inline struct kvm_pic *to_pic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_pic, dev);
 }
 
-static void picdev_write(struct kvm_io_device *this,
+static int picdev_write(struct kvm_io_device *this,
 			 gpa_t addr, int len, const void *val)
 {
 	struct kvm_pic *s = to_pic(this);
 	unsigned char data = *(unsigned char *)val;
+	if (!picdev_in_range(addr))
+		return -EOPNOTSUPP;
 
 	if (len != 1) {
 		if (printk_ratelimit())
 			printk(KERN_ERR "PIC: non byte write\n");
-		return;
+		return 0;
 	}
 	pic_lock(s);
 	switch (addr) {
@@ -476,18 +477,21 @@ static void picdev_write(struct kvm_io_device *this,
 		break;
 	}
 	pic_unlock(s);
+	return 0;
 }
 
-static void picdev_read(struct kvm_io_device *this,
-			gpa_t addr, int len, void *val)
+static int picdev_read(struct kvm_io_device *this,
+		       gpa_t addr, int len, void *val)
 {
 	struct kvm_pic *s = to_pic(this);
 	unsigned char data = 0;
+	if (!picdev_in_range(addr))
+		return -EOPNOTSUPP;
 
 	if (len != 1) {
 		if (printk_ratelimit())
 			printk(KERN_ERR "PIC: non byte read\n");
-		return;
+		return 0;
 	}
 	pic_lock(s);
 	switch (addr) {
@@ -504,6 +508,7 @@ static void picdev_read(struct kvm_io_device *this,
 	}
 	*(unsigned char *)val = data;
 	pic_unlock(s);
+	return 0;
 }
 
 /*
@@ -526,7 +531,6 @@ static void pic_irq_request(void *opaque, int level)
 static const struct kvm_io_device_ops picdev_ops = {
 	.read     = picdev_read,
 	.write    = picdev_write,
-	.in_range = picdev_in_range,
 };
 
 struct kvm_pic *kvm_create_pic(struct kvm *kvm)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2e02865..265a765 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -546,18 +546,27 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_lapic, dev);
 }
 
-static void apic_mmio_read(struct kvm_io_device *this,
-			   gpa_t address, int len, void *data)
+static int apic_mmio_in_range(struct kvm_lapic *apic, gpa_t addr)
+{
+	return apic_hw_enabled(apic) &&
+	    addr >= apic->base_address &&
+	    addr < apic->base_address + LAPIC_MMIO_LENGTH;
+}
+
+static int apic_mmio_read(struct kvm_io_device *this,
+			  gpa_t address, int len, void *data)
 {
 	struct kvm_lapic *apic = to_lapic(this);
 	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
+	if (!apic_mmio_in_range(apic, address))
+		return -EOPNOTSUPP;
 
 	if ((alignment + len) > 4) {
 		printk(KERN_ERR "KVM_APIC_READ: alignment error %lx %d",
 		       (unsigned long)address, len);
-		return;
+		return 0;
 	}
 	result = __apic_read(apic, offset & ~0xf);
 
@@ -574,6 +583,7 @@ static void apic_mmio_read(struct kvm_io_device *this,
 		       "should be 1,2, or 4 instead\n", len);
 		break;
 	}
+	return 0;
 }
 
 static void update_divide_count(struct kvm_lapic *apic)
@@ -629,13 +639,15 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 		apic->vcpu->kvm->arch.vapics_in_nmi_mode--;
 }
 
-static void apic_mmio_write(struct kvm_io_device *this,
-			    gpa_t address, int len, const void *data)
+static int apic_mmio_write(struct kvm_io_device *this,
+			   gpa_t address, int len, const void *data)
 {
 	struct kvm_lapic *apic = to_lapic(this);
 	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 val;
+	if (!apic_mmio_in_range(apic, address))
+		return -EOPNOTSUPP;
 
 	/*
 	 * APIC register must be aligned on 128-bits boundary.
@@ -646,7 +658,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 		/* Don't shout loud, $infamous_os would cause only noise. */
 		apic_debug("apic write: bad size=%d %lx\n",
 			   len, (long)address);
-		return;
+		return 0;
 	}
 
 	val = *(u32 *) data;
@@ -729,7 +741,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 		hrtimer_cancel(&apic->lapic_timer.timer);
 		apic_set_reg(apic, APIC_TMICT, val);
 		start_apic_timer(apic);
-		return;
+		return 0;
 
 	case APIC_TDCR:
 		if (val & 4)
@@ -743,22 +755,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 			   offset);
 		break;
 	}
-
-}
-
-static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int size)
-{
-	struct kvm_lapic *apic = to_lapic(this);
-	int ret = 0;
-
-
-	if (apic_hw_enabled(apic) &&
-	    (addr >= apic->base_address) &&
-	    (addr < (apic->base_address + LAPIC_MMIO_LENGTH)))
-		ret = 1;
-
-	return ret;
+	return 0;
 }
 
 void kvm_free_lapic(struct kvm_vcpu *vcpu)
@@ -938,7 +935,6 @@ static struct kvm_timer_ops lapic_timer_ops = {
 static const struct kvm_io_device_ops apic_mmio_ops = {
 	.read     = apic_mmio_read,
 	.write    = apic_mmio_write,
-	.in_range = apic_mmio_range,
 };
 
 int kvm_create_lapic(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ce6367..96f0ae7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2333,35 +2333,23 @@ static void kvm_init_msr_list(void)
 	num_msrs_to_save = j;
 }
 
-/*
- * Only apic need an MMIO device hook, so shortcut now..
- */
-static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
-						gpa_t addr, int len,
-						int is_write)
+static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
+			   const void *v)
 {
-	struct kvm_io_device *dev;
+	if (vcpu->arch.apic &&
+	    !kvm_iodevice_write(&vcpu->arch.apic->dev, addr, len, v))
+		return 0;
 
-	if (vcpu->arch.apic) {
-		dev = &vcpu->arch.apic->dev;
-		if (kvm_iodevice_in_range(dev, addr, len, is_write))
-			return dev;
-	}
-	return NULL;
+	return kvm_io_bus_write(&vcpu->kvm->mmio_bus, addr, len, v);
 }
 
-
-static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
-						gpa_t addr, int len,
-						int is_write)
+static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 {
-	struct kvm_io_device *dev;
+	if (vcpu->arch.apic &&
+	    !kvm_iodevice_read(&vcpu->arch.apic->dev, addr, len, v))
+		return 0;
 
-	dev = vcpu_find_pervcpu_dev(vcpu, addr, len, is_write);
-	if (dev == NULL)
-		dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len,
-					  is_write);
-	return dev;
+	return kvm_io_bus_read(&vcpu->kvm->mmio_bus, addr, len, v);
 }
 
 static int kvm_read_guest_virt(gva_t addr, void *val, unsigned int bytes,
@@ -2430,7 +2418,6 @@ static int emulator_read_emulated(unsigned long addr,
 				  unsigned int bytes,
 				  struct kvm_vcpu *vcpu)
 {
-	struct kvm_io_device *mmio_dev;
 	gpa_t                 gpa;
 
 	if (vcpu->mmio_read_completed) {
@@ -2455,13 +2442,8 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
-	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 0);
-	mutex_unlock(&vcpu->kvm->lock);
-	if (mmio_dev) {
-		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
+	if (!vcpu_mmio_read(vcpu, gpa, bytes, val))
 		return X86EMUL_CONTINUE;
-	}
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
@@ -2488,7 +2470,6 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 					   unsigned int bytes,
 					   struct kvm_vcpu *vcpu)
 {
-	struct kvm_io_device *mmio_dev;
 	gpa_t                 gpa;
 
 	gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr);
@@ -2509,13 +2490,8 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
-	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 1);
-	mutex_unlock(&vcpu->kvm->lock);
-	if (mmio_dev) {
-		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
+	if (!vcpu_mmio_write(vcpu, gpa, bytes, val))
 		return X86EMUL_CONTINUE;
-	}
 
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
@@ -2850,48 +2826,40 @@ int complete_pio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void kernel_pio(struct kvm_io_device *pio_dev,
-		       struct kvm_vcpu *vcpu,
-		       void *pd)
+static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 {
 	/* TODO: String I/O for in kernel device */
+	int r;
 
 	if (vcpu->arch.pio.in)
-		kvm_iodevice_read(pio_dev, vcpu->arch.pio.port,
-				  vcpu->arch.pio.size,
-				  pd);
+		r = kvm_io_bus_read(&vcpu->kvm->pio_bus, vcpu->arch.pio.port,
+				    vcpu->arch.pio.size, pd);
 	else
-		kvm_iodevice_write(pio_dev, vcpu->arch.pio.port,
-				   vcpu->arch.pio.size,
-				   pd);
+		r = kvm_io_bus_write(&vcpu->kvm->pio_bus, vcpu->arch.pio.port,
+				     vcpu->arch.pio.size, pd);
+	return r;
 }
 
-static void pio_string_write(struct kvm_io_device *pio_dev,
-			     struct kvm_vcpu *vcpu)
+static int pio_string_write(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pio_request *io = &vcpu->arch.pio;
 	void *pd = vcpu->arch.pio_data;
-	int i;
+	int i, r = 0;
 
 	for (i = 0; i < io->cur_count; i++) {
-		kvm_iodevice_write(pio_dev, io->port,
-				   io->size,
-				   pd);
+		if (kvm_io_bus_write(&vcpu->kvm->pio_bus,
+				     io->port, io->size, pd)) {
+			r = -EOPNOTSUPP;
+			break;
+		}
 		pd += io->size;
 	}
-}
-
-static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
-					       gpa_t addr, int len,
-					       int is_write)
-{
-	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write);
+	return r;
 }
 
 int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  int size, unsigned port)
 {
-	struct kvm_io_device *pio_dev;
 	unsigned long val;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
@@ -2911,11 +2879,7 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	memcpy(vcpu->arch.pio_data, &val, 4);
 
-	mutex_lock(&vcpu->kvm->lock);
-	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
-	mutex_unlock(&vcpu->kvm->lock);
-	if (pio_dev) {
-		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
+	if (!kernel_pio(vcpu, vcpu->arch.pio_data)) {
 		complete_pio(vcpu);
 		return 1;
 	}
@@ -2929,7 +2893,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 {
 	unsigned now, in_page;
 	int ret = 0;
-	struct kvm_io_device *pio_dev;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -2973,12 +2936,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	vcpu->arch.pio.guest_gva = address;
 
-	mutex_lock(&vcpu->kvm->lock);
-	pio_dev = vcpu_find_pio_dev(vcpu, port,
-				    vcpu->arch.pio.cur_count,
-				    !vcpu->arch.pio.in);
-	mutex_unlock(&vcpu->kvm->lock);
-
 	if (!vcpu->arch.pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
@@ -2986,16 +2943,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
-		if (ret == 0 && pio_dev) {
-			pio_string_write(pio_dev, vcpu);
+		if (ret == 0 && !pio_string_write(vcpu)) {
 			complete_pio(vcpu);
 			if (vcpu->arch.pio.count == 0)
 				ret = 1;
 		}
-	} else if (pio_dev)
-		pr_unimpl(vcpu, "no string pio read support yet, "
-		       "port %x size %d count %ld\n",
-			port, size, count);
+	}
+	/* no string PIO read support yet */
 
 	return ret;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 96c8c0b..077e8bb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -60,8 +60,10 @@ struct kvm_io_bus {
 
 void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
-struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
-					  gpa_t addr, int len, int is_write);
+int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr, int len,
+		     const void *val);
+int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len,
+		    void *val);
 void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			       struct kvm_io_device *dev);
 void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 7b7cc9f..0352f81 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -19,18 +19,14 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_coalesced_mmio_dev, dev);
 }
 
-static int coalesced_mmio_in_range(struct kvm_io_device *this,
-				   gpa_t addr, int len, int is_write)
+static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
+				   gpa_t addr, int len)
 {
-	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_zone *zone;
 	struct kvm_coalesced_mmio_ring *ring;
 	unsigned avail;
 	int i;
 
-	if (!is_write)
-		return 0;
-
 	/* Are we able to batch it ? */
 
 	/* last is the first free entry
@@ -60,11 +56,13 @@ static int coalesced_mmio_in_range(struct kvm_io_device *this,
 	return 0;
 }
 
-static void coalesced_mmio_write(struct kvm_io_device *this,
-				 gpa_t addr, int len, const void *val)
+static int coalesced_mmio_write(struct kvm_io_device *this,
+				gpa_t addr, int len, const void *val)
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
+	if (!coalesced_mmio_in_range(dev, addr, len))
+		return -EOPNOTSUPP;
 
 	spin_lock(&dev->lock);
 
@@ -76,6 +74,7 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
 	smp_wmb();
 	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(&dev->lock);
+	return 0;
 }
 
 static void coalesced_mmio_destructor(struct kvm_io_device *this)
@@ -87,7 +86,6 @@ static void coalesced_mmio_destructor(struct kvm_io_device *this)
 
 static const struct kvm_io_device_ops coalesced_mmio_ops = {
 	.write      = coalesced_mmio_write,
-	.in_range   = coalesced_mmio_in_range,
 	.destructor = coalesced_mmio_destructor,
 };
 
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 0eca54e..ddf6aa9 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -227,20 +227,19 @@ static inline struct kvm_ioapic *to_ioapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_ioapic, dev);
 }
 
-static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int is_write)
+static inline int ioapic_in_range(struct kvm_ioapic *ioapic, gpa_t addr)
 {
-	struct kvm_ioapic *ioapic = to_ioapic(this);
-
 	return ((addr >= ioapic->base_address &&
 		 (addr < ioapic->base_address + IOAPIC_MEM_LENGTH)));
 }
 
-static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
-			     void *val)
+static int ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
+			    void *val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 result;
+	if (!ioapic_in_range(ioapic, addr))
+		return -EOPNOTSUPP;
 
 	ioapic_debug("addr %lx\n", (unsigned long)addr);
 	ASSERT(!(addr & 0xf));	/* check alignment */
@@ -273,13 +272,16 @@ static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 		printk(KERN_WARNING "ioapic: wrong length %d\n", len);
 	}
 	mutex_unlock(&ioapic->kvm->irq_lock);
+	return 0;
 }
 
-static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
-			      const void *val)
+static int ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
+			     const void *val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 data;
+	if (!ioapic_in_range(ioapic, addr))
+		return -EOPNOTSUPP;
 
 	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
 		     (void*)addr, len, val);
@@ -290,7 +292,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		data = *(u32 *) val;
 	else {
 		printk(KERN_WARNING "ioapic: Unsupported size %d\n", len);
-		return;
+		return 0;
 	}
 
 	addr &= 0xff;
@@ -312,6 +314,7 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 		break;
 	}
 	mutex_unlock(&ioapic->kvm->irq_lock);
+	return 0;
 }
 
 void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
@@ -329,7 +332,6 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
 static const struct kvm_io_device_ops ioapic_mmio_ops = {
 	.read     = ioapic_mmio_read,
 	.write    = ioapic_mmio_write,
-	.in_range = ioapic_in_range,
 };
 
 int kvm_ioapic_init(struct kvm *kvm)
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 06e38b2..12fd3ca 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -17,23 +17,24 @@
 #define __KVM_IODEV_H__
 
 #include <linux/kvm_types.h>
+#include <asm/errno.h>
 
 struct kvm_io_device;
 
 /**
  * kvm_io_device_ops are called under kvm slots_lock.
+ * read and write handlers return 0 if the transaction has been handled,
+ * or non-zero to have it passed to the next device.
  **/
 struct kvm_io_device_ops {
-	void (*read)(struct kvm_io_device *this,
+	int (*read)(struct kvm_io_device *this,
+		    gpa_t addr,
+		    int len,
+		    void *val);
+	int (*write)(struct kvm_io_device *this,
 		     gpa_t addr,
 		     int len,
-		     void *val);
-	void (*write)(struct kvm_io_device *this,
-		      gpa_t addr,
-		      int len,
-		      const void *val);
-	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
-			int is_write);
+		     const void *val);
 	void (*destructor)(struct kvm_io_device *this);
 };
 
@@ -48,26 +49,16 @@ static inline void kvm_iodevice_init(struct kvm_io_device *dev,
 	dev->ops = ops;
 }
 
-static inline void kvm_iodevice_read(struct kvm_io_device *dev,
-				     gpa_t addr,
-				     int len,
-				     void *val)
+static inline int kvm_iodevice_read(struct kvm_io_device *dev,
+				    gpa_t addr, int l, void *v)
 {
-	dev->ops->read(dev, addr, len, val);
+	return dev->ops->read ? dev->ops->read(dev, addr, l, v) : -EOPNOTSUPP;
 }
 
-static inline void kvm_iodevice_write(struct kvm_io_device *dev,
-				      gpa_t addr,
-				      int len,
-				      const void *val)
+static inline int kvm_iodevice_write(struct kvm_io_device *dev,
+				     gpa_t addr, int l, const void *v)
 {
-	dev->ops->write(dev, addr, len, val);
-}
-
-static inline int kvm_iodevice_in_range(struct kvm_io_device *dev,
-					gpa_t addr, int len, int is_write)
-{
-	return dev->ops->in_range(dev, addr, len, is_write);
+	return dev->ops->write ? dev->ops->write(dev, addr, l, v) : -EOPNOTSUPP;
 }
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0edc366..5946065 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2512,19 +2512,25 @@ void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 	}
 }
 
-struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
-					  gpa_t addr, int len, int is_write)
+/* kvm_io_bus_write - called under kvm->slots_lock */
+int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr,
+		     int len, const void *val)
 {
 	int i;
+	for (i = 0; i < bus->dev_count; i++)
+		if (!kvm_iodevice_write(bus->devs[i], addr, len, val))
+			return 0;
+	return -EOPNOTSUPP;
+}
 
-	for (i = 0; i < bus->dev_count; i++) {
-		struct kvm_io_device *pos = bus->devs[i];
-
-		if (kvm_iodevice_in_range(pos, addr, len, is_write))
-			return pos;
-	}
-
-	return NULL;
+/* kvm_io_bus_read - called under kvm->slots_lock */
+int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len, void *val)
+{
+	int i;
+	for (i = 0; i < bus->dev_count; i++)
+		if (!kvm_iodevice_read(bus->devs[i], addr, len, val))
+			return 0;
+	return -EOPNOTSUPP;
 }
 
 void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
-- 
1.6.3.3

