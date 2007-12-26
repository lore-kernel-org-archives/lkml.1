Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbXLZLP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbXLZLP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXLZLGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:46 -0500
Received: from il.qumranet.com ([82.166.9.18]:50465 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbXLZLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:04 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 06/55] KVM: Per-architecture hypercall definitions
Date: Wed, 26 Dec 2007 13:05:11 +0200
Message-Id: <1198667160-22953-7-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Currently kvm provides hypercalls only for x86* architectures. To
provide hypercall infrastructure for other kvm architectures I split
kvm_para.h into a generic header file and architecture specific
definitions.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm_para.h |  105 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_para.h   |  105 +++++---------------------------------------
 2 files changed, 117 insertions(+), 93 deletions(-)
 create mode 100644 include/asm-x86/kvm_para.h

diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
new file mode 100644
index 0000000..c6f3fd8
--- /dev/null
+++ b/include/asm-x86/kvm_para.h
@@ -0,0 +1,105 @@
+#ifndef __X86_KVM_PARA_H
+#define __X86_KVM_PARA_H
+
+/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
+ * should be used to determine that a VM is running under KVM.
+ */
+#define KVM_CPUID_SIGNATURE	0x40000000
+
+/* This CPUID returns a feature bitmap in eax.  Before enabling a particular
+ * paravirtualization, the appropriate feature bit should be checked.
+ */
+#define KVM_CPUID_FEATURES	0x40000001
+
+#ifdef __KERNEL__
+#include <asm/processor.h>
+
+/* This instruction is vmcall.  On non-VT architectures, it will generate a
+ * trap that we will then rewrite to the appropriate instruction.
+ */
+#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
+
+/* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
+ * instruction.  The hypervisor may replace it with something else but only the
+ * instructions are guaranteed to be supported.
+ *
+ * Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
+ * The hypercall number should be placed in rax and the return value will be
+ * placed in rax.  No other registers will be clobbered unless explicited
+ * noted by the particular hypercall.
+ */
+
+static inline long kvm_hypercall0(unsigned int nr)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr));
+	return ret;
+}
+
+static inline long kvm_hypercall1(unsigned int nr, unsigned long p1)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1));
+	return ret;
+}
+
+static inline long kvm_hypercall2(unsigned int nr, unsigned long p1,
+				  unsigned long p2)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2));
+	return ret;
+}
+
+static inline long kvm_hypercall3(unsigned int nr, unsigned long p1,
+				  unsigned long p2, unsigned long p3)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3));
+	return ret;
+}
+
+static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
+				  unsigned long p2, unsigned long p3,
+				  unsigned long p4)
+{
+	long ret;
+	asm volatile(KVM_HYPERCALL
+		     : "=a"(ret)
+		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3), "S"(p4));
+	return ret;
+}
+
+static inline int kvm_para_available(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	char signature[13];
+
+	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
+	memcpy(signature + 0, &ebx, 4);
+	memcpy(signature + 4, &ecx, 4);
+	memcpy(signature + 8, &edx, 4);
+	signature[12] = 0;
+
+	if (strcmp(signature, "KVMKVMKVM") == 0)
+		return 1;
+
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return cpuid_eax(KVM_CPUID_FEATURES);
+}
+
+#endif
+
+#endif
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index cc5dfb4..e4db25f 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -1,110 +1,29 @@
 #ifndef __LINUX_KVM_PARA_H
 #define __LINUX_KVM_PARA_H
 
-/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
- * should be used to determine that a VM is running under KVM.
+/*
+ * This header file provides a method for making a hypercall to the host
+ * Architectures should define:
+ * - kvm_hypercall0, kvm_hypercall1...
+ * - kvm_arch_para_features
+ * - kvm_para_available
  */
-#define KVM_CPUID_SIGNATURE	0x40000000
-
-/* This CPUID returns a feature bitmap in eax.  Before enabling a particular
- * paravirtualization, the appropriate feature bit should be checked.
- */
-#define KVM_CPUID_FEATURES	0x40000001
 
 /* Return values for hypercalls */
 #define KVM_ENOSYS		1000
 
 #ifdef __KERNEL__
-#include <asm/processor.h>
-
-/* This instruction is vmcall.  On non-VT architectures, it will generate a
- * trap that we will then rewrite to the appropriate instruction.
- */
-#define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
-
-/* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
- * instruction.  The hypervisor may replace it with something else but only the
- * instructions are guaranteed to be supported.
- *
- * Up to four arguments may be passed in rbx, rcx, rdx, and rsi respectively.
- * The hypercall number should be placed in rax and the return value will be
- * placed in rax.  No other registers will be clobbered unless explicited
- * noted by the particular hypercall.
+/*
+ * hypercalls use architecture specific
  */
-
-static inline long kvm_hypercall0(unsigned int nr)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL
-		     : "=a"(ret)
-		     : "a"(nr));
-	return ret;
-}
-
-static inline long kvm_hypercall1(unsigned int nr, unsigned long p1)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL
-		     : "=a"(ret)
-		     : "a"(nr), "b"(p1));
-	return ret;
-}
-
-static inline long kvm_hypercall2(unsigned int nr, unsigned long p1,
-				  unsigned long p2)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL
-		     : "=a"(ret)
-		     : "a"(nr), "b"(p1), "c"(p2));
-	return ret;
-}
-
-static inline long kvm_hypercall3(unsigned int nr, unsigned long p1,
-				  unsigned long p2, unsigned long p3)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL
-		     : "=a"(ret)
-		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3));
-	return ret;
-}
-
-static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
-				  unsigned long p2, unsigned long p3,
-				  unsigned long p4)
-{
-	long ret;
-	asm volatile(KVM_HYPERCALL
-		     : "=a"(ret)
-		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3), "S"(p4));
-	return ret;
-}
-
-static inline int kvm_para_available(void)
-{
-	unsigned int eax, ebx, ecx, edx;
-	char signature[13];
-
-	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
-	memcpy(signature + 0, &ebx, 4);
-	memcpy(signature + 4, &ecx, 4);
-	memcpy(signature + 8, &edx, 4);
-	signature[12] = 0;
-
-	if (strcmp(signature, "KVMKVMKVM") == 0)
-		return 1;
-
-	return 0;
-}
+#include <asm/kvm_para.h>
 
 static inline int kvm_para_has_feature(unsigned int feature)
 {
-	if (cpuid_eax(KVM_CPUID_FEATURES) & (1UL << feature))
+	if (kvm_arch_para_features() & (1UL << feature))
 		return 1;
 	return 0;
 }
+#endif /* __KERNEL__ */
+#endif /* __LINUX_KVM_PARA_H */
 
-#endif
-
-#endif
-- 
1.5.3.7

