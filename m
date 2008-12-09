Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYLIUaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYLIUaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYLIUXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbYLIUXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 29/44] KVM: ia64: Define printk function for kvm-intel module
Date: Tue,  9 Dec 2008 22:22:44 +0200
Message-Id: <1228854179-23002-30-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

kvm-intel module is relocated to an isolated address space
with kernel, so it can't call host kernel's printk for debug
purpose. In the module, we implement the printk to output debug
info of vmm.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm_host.h |    4 ++++
 arch/ia64/kvm/Makefile           |    2 +-
 arch/ia64/kvm/kvm-ia64.c         |    8 ++++++++
 arch/ia64/kvm/kvm_lib.c          |   15 +++++++++++++++
 arch/ia64/kvm/vmm.c              |   26 ++++++++++++++++++++++++++
 5 files changed, 54 insertions(+), 1 deletions(-)
 create mode 100644 arch/ia64/kvm/kvm_lib.c

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 678e264..0560f3f 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 #define EXIT_REASON_EXTERNAL_INTERRUPT	6
 #define EXIT_REASON_IPI			7
 #define EXIT_REASON_PTC_G		8
+#define EXIT_REASON_DEBUG		20
 
 /*Define vmm address space and vm data space.*/
 #define KVM_VMM_SIZE (__IA64_UL_CONST(16)<<20)
@@ -126,6 +127,8 @@
 			KVM_MEM_DIRTY_LOG_SIZE) / sizeof(struct kvm_vcpu_data)
 #define KVM_MAX_MEM_SIZE (KVM_P2M_SIZE >> 3 << PAGE_SHIFT)
 
+#define VMM_LOG_LEN 256
+
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/kvm.h>
@@ -437,6 +440,7 @@ struct kvm_vcpu_arch {
 
 	unsigned long opcode;
 	unsigned long cause;
+	char log_buf[VMM_LOG_LEN];
 	union context host;
 	union context guest;
 };
diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
index 92cef66..76464dc 100644
--- a/arch/ia64/kvm/Makefile
+++ b/arch/ia64/kvm/Makefile
@@ -60,7 +60,7 @@ obj-$(CONFIG_KVM) += kvm.o
 
 CFLAGS_vcpu.o += -mfixed-range=f2-f5,f12-f127
 kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o mmio.o \
-	vtlb.o process.o
+	vtlb.o process.o kvm_lib.o
 #Add link memcpy and memset to avoid possible structure assignment error
 kvm-intel-objs += memcpy.o memset.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 70eb829..b4d24e2 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -474,6 +474,13 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
+static int handle_vcpu_debug(struct kvm_vcpu *vcpu,
+				struct kvm_run *kvm_run)
+{
+	printk("VMM: %s", vcpu->arch.log_buf);
+	return 1;
+}
+
 static int (*kvm_vti_exit_handlers[])(struct kvm_vcpu *vcpu,
 		struct kvm_run *kvm_run) = {
 	[EXIT_REASON_VM_PANIC]              = handle_vm_error,
@@ -485,6 +492,7 @@ static int (*kvm_vti_exit_handlers[])(struct kvm_vcpu *vcpu,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]    = handle_external_interrupt,
 	[EXIT_REASON_IPI]		    = handle_ipi,
 	[EXIT_REASON_PTC_G]		    = handle_global_purge,
+	[EXIT_REASON_DEBUG]		    = handle_vcpu_debug,
 
 };
 
diff --git a/arch/ia64/kvm/kvm_lib.c b/arch/ia64/kvm/kvm_lib.c
new file mode 100644
index 0000000..a85cb61
--- /dev/null
+++ b/arch/ia64/kvm/kvm_lib.c
@@ -0,0 +1,15 @@
+/*
+ * kvm_lib.c: Compile some libraries for kvm-intel module.
+ *
+ *	Just include kernel's library, and disable symbols export.
+ * 	Copyright (C) 2008, Intel Corporation.
+ *  	Xiantao Zhang  (xiantao.zhang@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#undef CONFIG_MODULES
+#include "../../../lib/vsprintf.c"
+#include "../../../lib/ctype.c"
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index 2275bf4..9577795 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -62,5 +62,31 @@ void vmm_spin_unlock(spinlock_t *lock)
 {
 	_vmm_raw_spin_unlock(lock);
 }
+
+static void vcpu_debug_exit(struct kvm_vcpu *vcpu)
+{
+	struct exit_ctl_data *p = &vcpu->arch.exit_data;
+	long psr;
+
+	local_irq_save(psr);
+	p->exit_reason = EXIT_REASON_DEBUG;
+	vmm_transition(vcpu);
+	local_irq_restore(psr);
+}
+
+asmlinkage int printk(const char *fmt, ...)
+{
+	struct kvm_vcpu *vcpu = current_vcpu;
+	va_list args;
+	int r;
+
+	memset(vcpu->arch.log_buf, 0, VMM_LOG_LEN);
+	va_start(args, fmt);
+	r = vsnprintf(vcpu->arch.log_buf, VMM_LOG_LEN, fmt, args);
+	va_end(args);
+	vcpu_debug_exit(vcpu);
+	return r;
+}
+
 module_init(kvm_vmm_init)
 module_exit(kvm_vmm_exit)
-- 
1.6.0.3

