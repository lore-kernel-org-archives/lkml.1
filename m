Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXLWPCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXLWPCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXLWOwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:35926 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 28/50] KVM: Move x86 msr handling to new files x86.[ch]
Date: Sun, 23 Dec 2007 16:51:13 +0200
Message-Id: <1198421495-31481-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Makefile   |    2 +-
 drivers/kvm/kvm.h      |    4 ++
 drivers/kvm/kvm_main.c |   69 +-------------------------------
 drivers/kvm/x86.c      |  102 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/kvm/x86.h      |   16 +++++++
 5 files changed, 126 insertions(+), 67 deletions(-)
 create mode 100644 drivers/kvm/x86.c
 create mode 100644 drivers/kvm/x86.h

diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
index e5a8f4d..cf18ad4 100644
--- a/drivers/kvm/Makefile
+++ b/drivers/kvm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-kvm-objs := kvm_main.o mmu.o x86_emulate.o i8259.o irq.o lapic.o ioapic.o
+kvm-objs := kvm_main.o x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o ioapic.o
 obj-$(CONFIG_KVM) += kvm.o
 kvm-intel-objs = vmx.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 3eaed4d..9c9c1d7 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -653,6 +653,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_fix_hypercall(struct kvm_vcpu *vcpu);
 
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg);
+__init void kvm_arch_init(void);
+
 static inline void kvm_guest_enter(void)
 {
 	current->flags |= PF_VCPU;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9633fd3..9f7370f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -16,6 +16,7 @@
  */
 
 #include "kvm.h"
+#include "x86.h"
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
 #include "irq.h"
@@ -2508,43 +2509,6 @@ void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
 
 /*
- * List of msr numbers which we expose to userspace through KVM_GET_MSRS
- * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
- *
- * This list is modified at module load time to reflect the
- * capabilities of the host cpu.
- */
-static u32 msrs_to_save[] = {
-	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
-	MSR_K6_STAR,
-#ifdef CONFIG_X86_64
-	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
-#endif
-	MSR_IA32_TIME_STAMP_COUNTER,
-};
-
-static unsigned num_msrs_to_save;
-
-static u32 emulated_msrs[] = {
-	MSR_IA32_MISC_ENABLE,
-};
-
-static __init void kvm_init_msr_list(void)
-{
-	u32 dummy[2];
-	unsigned i, j;
-
-	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
-		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
-			continue;
-		if (j < i)
-			msrs_to_save[j] = msrs_to_save[i];
-		j++;
-	}
-	num_msrs_to_save = j;
-}
-
-/*
  * Adapt set_msr() to msr_io()'s calling convention
  */
 static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
@@ -3356,33 +3320,6 @@ static long kvm_dev_ioctl(struct file *filp,
 			goto out;
 		r = kvm_dev_ioctl_create_vm();
 		break;
-	case KVM_GET_MSR_INDEX_LIST: {
-		struct kvm_msr_list __user *user_msr_list = argp;
-		struct kvm_msr_list msr_list;
-		unsigned n;
-
-		r = -EFAULT;
-		if (copy_from_user(&msr_list, user_msr_list, sizeof msr_list))
-			goto out;
-		n = msr_list.nmsrs;
-		msr_list.nmsrs = num_msrs_to_save + ARRAY_SIZE(emulated_msrs);
-		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
-			goto out;
-		r = -E2BIG;
-		if (n < num_msrs_to_save)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
-				 num_msrs_to_save * sizeof(u32)))
-			goto out;
-		if (copy_to_user(user_msr_list->indices
-				 + num_msrs_to_save * sizeof(u32),
-				 &emulated_msrs,
-				 ARRAY_SIZE(emulated_msrs) * sizeof(u32)))
-			goto out;
-		r = 0;
-		break;
-	}
 	case KVM_CHECK_EXTENSION: {
 		int ext = (long)argp;
 
@@ -3406,7 +3343,7 @@ static long kvm_dev_ioctl(struct file *filp,
 		r = 2 * PAGE_SIZE;
 		break;
 	default:
-		;
+		return kvm_arch_dev_ioctl(filp, ioctl, arg);
 	}
 out:
 	return r;
@@ -3770,7 +3707,7 @@ static __init int kvm_init(void)
 
 	kvm_init_debug();
 
-	kvm_init_msr_list();
+	kvm_arch_init();
 
 	bad_page = alloc_page(GFP_KERNEL);
 
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
new file mode 100644
index 0000000..437902c
--- /dev/null
+++ b/drivers/kvm/x86.c
@@ -0,0 +1,102 @@
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * derived from drivers/kvm/kvm_main.c
+ *
+ * Copyright (C) 2006 Qumranet, Inc.
+ *
+ * Authors:
+ *   Avi Kivity   <avi@qumranet.com>
+ *   Yaniv Kamay  <yaniv@qumranet.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include "x86.h"
+
+#include <asm/uaccess.h>
+
+/*
+ * List of msr numbers which we expose to userspace through KVM_GET_MSRS
+ * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
+ *
+ * This list is modified at module load time to reflect the
+ * capabilities of the host cpu.
+ */
+static u32 msrs_to_save[] = {
+	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
+	MSR_K6_STAR,
+#ifdef CONFIG_X86_64
+	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
+#endif
+	MSR_IA32_TIME_STAMP_COUNTER,
+};
+
+static unsigned num_msrs_to_save;
+
+static u32 emulated_msrs[] = {
+	MSR_IA32_MISC_ENABLE,
+};
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	long r;
+
+	switch (ioctl) {
+	case KVM_GET_MSR_INDEX_LIST: {
+		struct kvm_msr_list __user *user_msr_list = argp;
+		struct kvm_msr_list msr_list;
+		unsigned n;
+
+		r = -EFAULT;
+		if (copy_from_user(&msr_list, user_msr_list, sizeof msr_list))
+			goto out;
+		n = msr_list.nmsrs;
+		msr_list.nmsrs = num_msrs_to_save + ARRAY_SIZE(emulated_msrs);
+		if (copy_to_user(user_msr_list, &msr_list, sizeof msr_list))
+			goto out;
+		r = -E2BIG;
+		if (n < num_msrs_to_save)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
+				 num_msrs_to_save * sizeof(u32)))
+			goto out;
+		if (copy_to_user(user_msr_list->indices
+				 + num_msrs_to_save * sizeof(u32),
+				 &emulated_msrs,
+				 ARRAY_SIZE(emulated_msrs) * sizeof(u32)))
+			goto out;
+		r = 0;
+		break;
+	}
+	default:
+		r = -EINVAL;
+	}
+out:
+	return r;
+}
+
+static __init void kvm_init_msr_list(void)
+{
+	u32 dummy[2];
+	unsigned i, j;
+
+	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
+		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
+			continue;
+		if (j < i)
+			msrs_to_save[j] = msrs_to_save[i];
+		j++;
+	}
+	num_msrs_to_save = j;
+}
+
+__init void kvm_arch_init(void)
+{
+	kvm_init_msr_list();
+}
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
new file mode 100644
index 0000000..1e2f71b
--- /dev/null
+++ b/drivers/kvm/x86.h
@@ -0,0 +1,16 @@
+#/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * This header defines architecture specific interfaces, x86 version
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#ifndef KVM_X86_H
+#define KVM_X86_H
+
+#include "kvm.h"
+
+#endif
-- 
1.5.3.7

