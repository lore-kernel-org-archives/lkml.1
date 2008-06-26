Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYFZMdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYFZMdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFZM2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:54 -0400
Received: from il.qumranet.com ([212.179.150.194]:32377 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbYFZM2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH 33/50] KVM: kvm_io_device: extend in_range() to manage len and write attribute
Date: Thu, 26 Jun 2008 15:28:15 +0300
Message-Id: <1214483312-9265-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Vivier <Laurent.Vivier@bull.net>

Modify member in_range() of structure kvm_io_device to pass length and the type
of the I/O (write or read).

This modification allows to use kvm_io_device with coalesced MMIO.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/ia64/kvm/kvm-ia64.c |    6 +++---
 arch/x86/kvm/i8254.c     |    6 ++++--
 arch/x86/kvm/i8259.c     |    3 ++-
 arch/x86/kvm/lapic.c     |    3 ++-
 arch/x86/kvm/x86.c       |   28 +++++++++++++++++-----------
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/ioapic.c        |    3 ++-
 virt/kvm/iodev.h         |    8 +++++---
 virt/kvm/kvm_main.c      |    5 +++--
 9 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index adb74f7..b59231b 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -195,11 +195,11 @@ int kvm_dev_ioctl_check_extension(long ext)
 }
 
 static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
-					gpa_t addr)
+					gpa_t addr, int len, int is_write)
 {
 	struct kvm_io_device *dev;
 
-	dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr);
+	dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write);
 
 	return dev;
 }
@@ -231,7 +231,7 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->exit_reason = KVM_EXIT_MMIO;
 	return 0;
 mmio:
-	mmio_dev = vcpu_find_mmio_dev(vcpu, p->addr);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, p->addr, p->size, !p->dir);
 	if (mmio_dev) {
 		if (!p->dir)
 			kvm_iodevice_write(mmio_dev, p->addr, p->size,
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 60074dc..9e3391e 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -460,7 +460,8 @@ static void pit_ioport_read(struct kvm_io_device *this,
 	mutex_unlock(&pit_state->lock);
 }
 
-static int pit_in_range(struct kvm_io_device *this, gpa_t addr)
+static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
+			int len, int is_write)
 {
 	return ((addr >= KVM_PIT_BASE_ADDRESS) &&
 		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
@@ -501,7 +502,8 @@ static void speaker_ioport_read(struct kvm_io_device *this,
 	mutex_unlock(&pit_state->lock);
 }
 
-static int speaker_in_range(struct kvm_io_device *this, gpa_t addr)
+static int speaker_in_range(struct kvm_io_device *this, gpa_t addr,
+			    int len, int is_write)
 {
 	return (addr == KVM_SPEAKER_BASE_ADDRESS);
 }
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index ab29cf2..5857f59 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -346,7 +346,8 @@ static u32 elcr_ioport_read(void *opaque, u32 addr1)
 	return s->elcr;
 }
 
-static int picdev_in_range(struct kvm_io_device *this, gpa_t addr)
+static int picdev_in_range(struct kvm_io_device *this, gpa_t addr,
+			   int len, int is_write)
 {
 	switch (addr) {
 	case 0x20:
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e48d193..180ba73 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -785,7 +785,8 @@ static void apic_mmio_write(struct kvm_io_device *this,
 
 }
 
-static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr)
+static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
+			   int len, int size)
 {
 	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
 	int ret = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51810d8..00333b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1797,13 +1797,14 @@ static void kvm_init_msr_list(void)
  * Only apic need an MMIO device hook, so shortcut now..
  */
 static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
-						gpa_t addr)
+						gpa_t addr, int len,
+						int is_write)
 {
 	struct kvm_io_device *dev;
 
 	if (vcpu->arch.apic) {
 		dev = &vcpu->arch.apic->dev;
-		if (dev->in_range(dev, addr))
+		if (dev->in_range(dev, addr, len, is_write))
 			return dev;
 	}
 	return NULL;
@@ -1811,13 +1812,15 @@ static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 
 
 static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
-						gpa_t addr)
+						gpa_t addr, int len,
+						int is_write)
 {
 	struct kvm_io_device *dev;
 
-	dev = vcpu_find_pervcpu_dev(vcpu, addr);
+	dev = vcpu_find_pervcpu_dev(vcpu, addr, len, is_write);
 	if (dev == NULL)
-		dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr);
+		dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len,
+					  is_write);
 	return dev;
 }
 
@@ -1885,7 +1888,7 @@ mmio:
 	 * Is this MMIO handled locally?
 	 */
 	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 0);
 	if (mmio_dev) {
 		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
 		mutex_unlock(&vcpu->kvm->lock);
@@ -1940,7 +1943,7 @@ mmio:
 	 * Is this MMIO handled locally?
 	 */
 	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 1);
 	if (mmio_dev) {
 		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
 		mutex_unlock(&vcpu->kvm->lock);
@@ -2317,9 +2320,10 @@ static void pio_string_write(struct kvm_io_device *pio_dev,
 }
 
 static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
-					       gpa_t addr)
+					       gpa_t addr, int len,
+					       int is_write)
 {
-	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr);
+	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write);
 }
 
 int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
@@ -2351,7 +2355,7 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	kvm_x86_ops->skip_emulated_instruction(vcpu);
 
-	pio_dev = vcpu_find_pio_dev(vcpu, port);
+	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
 	if (pio_dev) {
 		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
 		complete_pio(vcpu);
@@ -2433,7 +2437,9 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		}
 	}
 
-	pio_dev = vcpu_find_pio_dev(vcpu, port);
+	pio_dev = vcpu_find_pio_dev(vcpu, port,
+				    vcpu->arch.pio.cur_count,
+				    !vcpu->arch.pio.in);
 	if (!vcpu->arch.pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 865dcbc..499ff06 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,8 @@ struct kvm_io_bus {
 
 void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
-struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus, gpa_t addr);
+struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
+					  gpa_t addr, int len, int is_write);
 void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index cb8a20b..9d02136 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -307,7 +307,8 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector)
 			__kvm_ioapic_update_eoi(ioapic, i);
 }
 
-static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr)
+static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
+			   int len, int is_write)
 {
 	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
 
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index c14e642..55e8846 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -27,7 +27,8 @@ struct kvm_io_device {
 		      gpa_t addr,
 		      int len,
 		      const void *val);
-	int (*in_range)(struct kvm_io_device *this, gpa_t addr);
+	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
+			int is_write);
 	void (*destructor)(struct kvm_io_device *this);
 
 	void             *private;
@@ -49,9 +50,10 @@ static inline void kvm_iodevice_write(struct kvm_io_device *dev,
 	dev->write(dev, addr, len, val);
 }
 
-static inline int kvm_iodevice_inrange(struct kvm_io_device *dev, gpa_t addr)
+static inline int kvm_iodevice_inrange(struct kvm_io_device *dev,
+				       gpa_t addr, int len, int is_write)
 {
-	return dev->in_range(dev, addr);
+	return dev->in_range(dev, addr, len, is_write);
 }
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e8f9fda..d602700 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1350,14 +1350,15 @@ void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 	}
 }
 
-struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus, gpa_t addr)
+struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
+					  gpa_t addr, int len, int is_write)
 {
 	int i;
 
 	for (i = 0; i < bus->dev_count; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		if (pos->in_range(pos, addr))
+		if (pos->in_range(pos, addr, len, is_write))
 			return pos;
 	}
 
-- 
1.5.6

