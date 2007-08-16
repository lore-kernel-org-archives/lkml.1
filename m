Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbXHPP7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbXHPP7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764306AbXHPP66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:58:58 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57069 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765275AbXHPP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:58:56 -0400
Message-ID: <46C47445.5070403@bull.net>
Date: Thu, 16 Aug 2007 17:59:01 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 4/4]Modify KVM to use the "account modifiers"
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net> <46C4725A.4070607@bull.net> <46C472D2.7000702@bull.net>
In-Reply-To: <46C472D2.7000702@bull.net>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:04:05,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:04:06,
	Serialize complete at 16/08/2007 18:04:06
Content-Type: multipart/mixed;
 boundary="------------070207020105010804060308"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070207020105010804060308
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 4/4] Modify KVM to use the "account modifiers". KVM can now measure time
consumed by a Virtual Machine on a per-cpu basis and modify kernel statistics to
report this value.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------070207020105010804060308
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="kvm_accounting_modifiers"
Content-Disposition: inline;
 filename="kvm_accounting_modifiers"

Index: kvm/drivers/kvm/kvm.h
===================================================================
--- kvm.orig/drivers/kvm/kvm.h	2007-08-16 16:21:42.000000000 +0200
+++ kvm/drivers/kvm/kvm.h	2007-08-16 16:27:00.000000000 +0200
@@ -408,6 +408,10 @@
 	struct file *filp;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	struct account_modifier account_modifier;
+	ktime_t vtime[NR_CPUS];
+#endif
 };
 
 struct descriptor_table {
@@ -589,6 +593,20 @@
 
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+static inline ktime_t kvm_guest_enter(void)
+{
+	return ktime_get();
+}
+
+static inline void kvm_guest_exit(struct kvm *kvm, ktime_t enter)
+{
+	ktime_t delta = ktime_sub(ktime_get(), enter);
+	kvm->vtime[smp_processor_id()] =
+		ktime_add(kvm->vtime[smp_processor_id()], delta);
+}
+#endif
+
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
 {
Index: kvm/drivers/kvm/kvm_main.c
===================================================================
--- kvm.orig/drivers/kvm/kvm_main.c	2007-08-16 16:21:42.000000000 +0200
+++ kvm/drivers/kvm/kvm_main.c	2007-08-16 16:40:28.000000000 +0200
@@ -33,6 +33,7 @@
 #include <linux/file.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
+#include <linux/kernel_stat.h>
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/smp.h>
@@ -57,6 +58,9 @@
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+static __read_mostly struct account_ops kvm_account_ops;
+#endif
 
 #define STAT_OFFSET(x) offsetof(struct kvm_vcpu, stat.x)
 
@@ -285,6 +289,42 @@
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
 
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+static inline
+struct kvm *account_modifier_to_kvm(struct account_modifier *am)
+{
+	return container_of(am, struct kvm, account_modifier);
+}
+
+static cputime_t kvm_account_system_modifier(struct account_modifier *modifier,
+					     struct task_struct *curr,
+					     int hardirq_offset,
+					     cputime_t cputime)
+{
+	struct kvm *kvm = account_modifier_to_kvm(modifier);
+	ktime_t kmsec = ktime_set(0, NSEC_PER_MSEC);
+	cputime_t cmsec = msecs_to_cputime(1);
+	ktime_t vtime = kvm->vtime[smp_processor_id()];
+
+	while ((ktime_to_ns(vtime) >= NSEC_PER_MSEC) &&
+	       (cputime_to_msecs(cputime) >= 1)) {
+		kvm->vtime[smp_processor_id()] = ktime_sub(vtime, kmsec);
+
+		curr->utime = cputime_add(curr->utime, cmsec);
+		curr->gtime = cputime_add(curr->gtime, cmsec);
+
+		kstat_this_cpu.cpustat.guest = cputime64_add(kstat_this_cpu.cpustat.guest,
+						cputime_to_cputime64(cmsec));
+		kstat_this_cpu.cpustat.user = cputime64_add(kstat_this_cpu.cpustat.user,
+						cputime_to_cputime64(cmsec));
+
+		cputime = cputime_sub(cputime, cmsec);
+	}
+
+	return cputime;
+}
+#endif
+
 static struct kvm *kvm_create_vm(void)
 {
 	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
@@ -299,6 +339,15 @@
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
+
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	kvm_account_ops.user_time = NULL;
+	kvm_account_ops.system_time = kvm_account_system_modifier;
+
+	account_modifier_init(&kvm->account_modifier, &kvm_account_ops);
+	account_modifier_register(&kvm->account_modifier);
+#endif
+
 	return kvm;
 }
 
@@ -376,6 +425,9 @@
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	account_modifier_unregister(&kvm->account_modifier);
+#endif
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
 	kvm_free_vcpus(kvm);
Index: kvm/drivers/kvm/svm.c
===================================================================
--- kvm.orig/drivers/kvm/svm.c	2007-08-16 16:21:42.000000000 +0200
+++ kvm/drivers/kvm/svm.c	2007-08-16 16:29:41.000000000 +0200
@@ -1392,6 +1392,9 @@
 	u16 gs_selector;
 	u16 ldt_selector;
 	int r;
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	ktime_t now;
+#endif
 
 again:
 	r = kvm_mmu_reload(vcpu);
@@ -1404,6 +1407,9 @@
 	clgi();
 
 	vcpu->guest_mode = 1;
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	now = kvm_guest_enter();
+#endif
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
@@ -1536,6 +1542,9 @@
 #endif
 		: "cc", "memory" );
 
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	kvm_guest_exit(vcpu->kvm, now);
+#endif
 	vcpu->guest_mode = 0;
 
 	if (vcpu->fpu_active) {
Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c	2007-08-16 16:21:42.000000000 +0200
+++ kvm/drivers/kvm/vmx.c	2007-08-16 16:30:24.000000000 +0200
@@ -2052,6 +2052,9 @@
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u8 fail;
 	int r;
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	ktime_t now;
+#endif
 
 preempted:
 	if (vcpu->guest_debug.enabled)
@@ -2078,6 +2081,9 @@
 	local_irq_disable();
 
 	vcpu->guest_mode = 1;
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	now = kvm_guest_enter();
+#endif
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    vmx_flush_tlb(vcpu);
@@ -2198,6 +2204,9 @@
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+#ifdef CONFIG_ACCOUNT_MODIFIERS
+	kvm_guest_exit(vcpu->kvm, now);
+#endif
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
Index: kvm/drivers/kvm/Kconfig
===================================================================
--- kvm.orig/drivers/kvm/Kconfig	2007-08-16 16:21:42.000000000 +0200
+++ kvm/drivers/kvm/Kconfig	2007-08-16 16:21:44.000000000 +0200
@@ -41,4 +41,10 @@
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
+config ACCOUNT_MODIFIERS
+        bool "Virtual Machine accounting support"
+	depends on KVM
+	---help---
+	  Allows to account CPU time used by the Virtual Machines.
+
 endif # VIRTUALIZATION

--------------070207020105010804060308--
