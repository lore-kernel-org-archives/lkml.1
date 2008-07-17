Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYGQQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYGQQBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYGQQAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:00:46 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58854 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399AbYGQQAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:00:44 -0400
Message-Id: <20080717160002.908279437@polymtl.ca>
References: <20080717155724.897537670@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 11:57:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@qumranet.com>, kvm@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: [patch 2/4] kvm move VMCS read to system headers
Content-Disposition: inline; filename=kvm-move-vmcs-read-to-system-headers.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 17 Jul 2008 16:00:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VMCS read  will be needed by the kvm-trace probes. Put them in
static inline functions in system-side headers instead of in the C file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: 'Feng(Eric) Liu' <eric.e.liu@intel.com>
CC: Avi Kivity <avi@qumranet.com>
CC: kvm@vger.kernel.org
---
 arch/x86/kvm/vmx.c         |   28 ----------------------------
 include/asm-x86/kvm_host.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 28 deletions(-)

Index: linux-2.6-lttng/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/vmx.c	2008-07-17 11:41:54.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kvm/vmx.c	2008-07-17 11:41:58.000000000 -0400
@@ -388,34 +388,6 @@ static inline void ept_sync_individual_a
 	}
 }
 
-static unsigned long vmcs_readl(unsigned long field)
-{
-	unsigned long value;
-
-	asm volatile (__ex(ASM_VMX_VMREAD_RDX_RAX)
-		      : "=a"(value) : "d"(field) : "cc");
-	return value;
-}
-
-static u16 vmcs_read16(unsigned long field)
-{
-	return vmcs_readl(field);
-}
-
-static u32 vmcs_read32(unsigned long field)
-{
-	return vmcs_readl(field);
-}
-
-static u64 vmcs_read64(unsigned long field)
-{
-#ifdef CONFIG_X86_64
-	return vmcs_readl(field);
-#else
-	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
-#endif
-}
-
 static noinline void vmwrite_error(unsigned long field, unsigned long value)
 {
 	printk(KERN_ERR "vmwrite error: reg %lx value %lx (err %d)\n",
Index: linux-2.6-lttng/include/asm-x86/kvm_host.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/kvm_host.h	2008-07-17 11:41:57.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/kvm_host.h	2008-07-17 11:42:17.000000000 -0400
@@ -719,6 +719,8 @@ asmlinkage void kvm_handle_fault_on_rebo
 	KVM_EX_ENTRY " 666b, 667b \n\t" \
 	".popsection"
 
+#define __ex(x) __kvm_handle_fault_on_reboot(x)
+
 /* VMCS Encodings */
 enum vmcs_field {
 	VIRTUAL_PROCESSOR_ID            = 0x00000000,
@@ -861,4 +863,32 @@ enum vmcs_field {
 	HOST_RIP                        = 0x00006c16,
 };
 
+static inline unsigned long vmcs_readl(unsigned long field)
+{
+	unsigned long value;
+
+	asm volatile (__ex(ASM_VMX_VMREAD_RDX_RAX)
+		      : "=a"(value) : "d"(field) : "cc");
+	return value;
+}
+
+static inline u16 vmcs_read16(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static inline u32 vmcs_read32(unsigned long field)
+{
+	return vmcs_readl(field);
+}
+
+static inline u64 vmcs_read64(unsigned long field)
+{
+#ifdef CONFIG_X86_64
+	return vmcs_readl(field);
+#else
+	return vmcs_readl(field) | ((u64)vmcs_readl(field+1) << 32);
+#endif
+}
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
