Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZHPJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZHPJay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZHPJae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:30:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbZHPJaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:15 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 47/48] KVM: Break dependency between vcpu index in vcpus array and vcpu_id.
Date: Sun, 16 Aug 2009 12:30:07 +0300
Message-Id: <1250415008-17175-48-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Archs are free to use vcpu_id as they see fit. For x86 it is used as
vcpu's apic id. New ioctl is added to configure boot vcpu id that was
assumed to be 0 till now.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    1 -
 arch/ia64/kvm/Kconfig            |    1 +
 arch/ia64/kvm/kvm-ia64.c         |    8 +---
 arch/ia64/kvm/vcpu.c             |    2 +-
 arch/x86/kvm/Kconfig             |    1 +
 include/linux/kvm.h              |    2 +
 include/linux/kvm_host.h         |    6 +++
 virt/kvm/Kconfig                 |    3 ++
 virt/kvm/kvm_main.c              |   64 +++++++++++++++++++++++---------------
 9 files changed, 55 insertions(+), 33 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 5f43697..9cf1c4b 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -465,7 +465,6 @@ struct kvm_arch {
 	unsigned long	metaphysical_rr4;
 	unsigned long	vmm_init_rr;
 
-	int		online_vcpus;
 	int		is_sn2;
 
 	struct kvm_ioapic *vioapic;
diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
index f922bbb..cbadd8a 100644
--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -25,6 +25,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
+	select KVM_APIC_ARCHITECTURE
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 4082665..d1f7bcd 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -338,7 +338,7 @@ static struct kvm_vcpu *lid_to_vcpu(struct kvm *kvm, unsigned long id,
 	union ia64_lid lid;
 	int i;
 
-	for (i = 0; i < kvm->arch.online_vcpus; i++) {
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
 		if (kvm->vcpus[i]) {
 			lid.val = VCPU_LID(kvm->vcpus[i]);
 			if (lid.id == id && lid.eid == eid)
@@ -412,7 +412,7 @@ static int handle_global_purge(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	call_data.ptc_g_data = p->u.ptc_g_data;
 
-	for (i = 0; i < kvm->arch.online_vcpus; i++) {
+	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
 		if (!kvm->vcpus[i] || kvm->vcpus[i]->arch.mp_state ==
 						KVM_MP_STATE_UNINITIALIZED ||
 					vcpu == kvm->vcpus[i])
@@ -852,8 +852,6 @@ struct  kvm *kvm_arch_create_vm(void)
 
 	kvm_init_vm(kvm);
 
-	kvm->arch.online_vcpus = 0;
-
 	return kvm;
 
 }
@@ -1356,8 +1354,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		goto fail;
 	}
 
-	kvm->arch.online_vcpus++;
-
 	return vcpu;
 fail:
 	return ERR_PTR(r);
diff --git a/arch/ia64/kvm/vcpu.c b/arch/ia64/kvm/vcpu.c
index 61a3320..dce75b7 100644
--- a/arch/ia64/kvm/vcpu.c
+++ b/arch/ia64/kvm/vcpu.c
@@ -831,7 +831,7 @@ static void vcpu_set_itc(struct kvm_vcpu *vcpu, u64 val)
 	kvm = (struct kvm *)KVM_VM_BASE;
 
 	if (kvm_vcpu_is_bsp(vcpu)) {
-		for (i = 0; i < kvm->arch.online_vcpus; i++) {
+		for (i = 0; i < atomic_read(&kvm->online_vcpus); i++) {
 			v = (struct kvm_vcpu *)((char *)vcpu +
 					sizeof(struct kvm_vcpu_data) * i);
 			VMX(v, itc_offset) = itc_offset;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8cd2a4e..7fbedfd 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -27,6 +27,7 @@ config KVM
 	select ANON_INODES
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_EVENTFD
+	select KVM_APIC_ARCHITECTURE
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f1dada0..5037e17 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -430,6 +430,7 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_PIT
 #define KVM_CAP_PIT2 33
 #endif
+#define KVM_CAP_SET_BOOT_CPU_ID 34
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -537,6 +538,7 @@ struct kvm_irqfd {
 #define KVM_DEASSIGN_DEV_IRQ       _IOW(KVMIO, 0x75, struct kvm_assigned_irq)
 #define KVM_IRQFD                  _IOW(KVMIO, 0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		   _IOW(KVMIO, 0x77, struct kvm_pit_config)
+#define KVM_SET_BOOT_CPU_ID        _IO(KVMIO, 0x78)
 
 /*
  * ioctls for vcpu fds
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a5bd429..d3fdf1a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -131,8 +131,12 @@ struct kvm {
 	int nmemslots;
 	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
 					KVM_PRIVATE_MEM_SLOTS];
+#ifdef CONFIG_KVM_APIC_ARCHITECTURE
+	u32 bsp_vcpu_id;
 	struct kvm_vcpu *bsp_vcpu;
+#endif
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
+	atomic_t online_vcpus;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus mmio_bus;
@@ -550,8 +554,10 @@ static inline void kvm_irqfd_release(struct kvm *kvm) {}
 
 #endif /* CONFIG_HAVE_KVM_EVENTFD */
 
+#ifdef CONFIG_KVM_APIC_ARCHITECTURE
 static inline bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->bsp_vcpu == vcpu;
 }
 #endif
+#endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 56c6848..daece36 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -9,3 +9,6 @@ config HAVE_KVM_IRQCHIP
 config HAVE_KVM_EVENTFD
        bool
        select EVENTFD
+
+config KVM_APIC_ARCHITECTURE
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d54ede..25e1f9c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -689,11 +689,6 @@ out:
 }
 #endif
 
-static inline int valid_vcpu(int n)
-{
-	return likely(n >= 0 && n < KVM_MAX_VCPUS);
-}
-
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn)) {
@@ -1714,24 +1709,18 @@ static struct file_operations kvm_vcpu_fops = {
  */
 static int create_vcpu_fd(struct kvm_vcpu *vcpu)
 {
-	int fd = anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, 0);
-	if (fd < 0)
-		kvm_put_kvm(vcpu->kvm);
-	return fd;
+	return anon_inode_getfd("kvm-vcpu", &kvm_vcpu_fops, vcpu, 0);
 }
 
 /*
  * Creates some virtual cpus.  Good luck creating more than one.
  */
-static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
+static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
 
-	if (!valid_vcpu(n))
-		return -EINVAL;
-
-	vcpu = kvm_arch_vcpu_create(kvm, n);
+	vcpu = kvm_arch_vcpu_create(kvm, id);
 	if (IS_ERR(vcpu))
 		return PTR_ERR(vcpu);
 
@@ -1742,25 +1731,38 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 		return r;
 
 	mutex_lock(&kvm->lock);
-	if (kvm->vcpus[n]) {
-		r = -EEXIST;
+	if (atomic_read(&kvm->online_vcpus) == KVM_MAX_VCPUS) {
+		r = -EINVAL;
 		goto vcpu_destroy;
 	}
-	kvm->vcpus[n] = vcpu;
-	if (n == 0)
-		kvm->bsp_vcpu = vcpu;
-	mutex_unlock(&kvm->lock);
+
+	for (r = 0; r < atomic_read(&kvm->online_vcpus); r++)
+		if (kvm->vcpus[r]->vcpu_id == id) {
+			r = -EEXIST;
+			goto vcpu_destroy;
+		}
+
+	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
 
 	/* Now it's all set up, let userspace reach it */
 	kvm_get_kvm(kvm);
 	r = create_vcpu_fd(vcpu);
-	if (r < 0)
-		goto unlink;
+	if (r < 0) {
+		kvm_put_kvm(kvm);
+		goto vcpu_destroy;
+	}
+
+	kvm->vcpus[atomic_read(&kvm->online_vcpus)] = vcpu;
+	smp_wmb();
+	atomic_inc(&kvm->online_vcpus);
+
+#ifdef CONFIG_KVM_APIC_ARCHITECTURE
+	if (kvm->bsp_vcpu_id == id)
+		kvm->bsp_vcpu = vcpu;
+#endif
+	mutex_unlock(&kvm->lock);
 	return r;
 
-unlink:
-	mutex_lock(&kvm->lock);
-	kvm->vcpus[n] = NULL;
 vcpu_destroy:
 	mutex_unlock(&kvm->lock);
 	kvm_arch_vcpu_destroy(vcpu);
@@ -2233,6 +2235,15 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
 		break;
 	}
+#ifdef CONFIG_KVM_APIC_ARCHITECTURE
+	case KVM_SET_BOOT_CPU_ID:
+		r = 0;
+		if (atomic_read(&kvm->online_vcpus) != 0)
+			r = -EBUSY;
+		else
+			kvm->bsp_vcpu_id = arg;
+		break;
+#endif
 	default:
 		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
 	}
@@ -2299,6 +2310,9 @@ static long kvm_dev_ioctl_check_extension_generic(long arg)
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_JOIN_MEMORY_REGIONS_WORKS:
+#ifdef CONFIG_KVM_APIC_ARCHITECTURE
+	case KVM_CAP_SET_BOOT_CPU_ID:
+#endif
 		return 1;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 	case KVM_CAP_IRQ_ROUTING:
-- 
1.6.3.3

