Return-Path: <linux-kernel-owner+w=401wt.eu-S934575AbXLRBlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbXLRBlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbXLRBhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:37:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761735AbXLRBhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:37:33 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 11/21] [PATCH] unify thread struct.
Date: Mon, 17 Dec 2007 20:52:34 -0200
Message-Id: <11979320211287-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320163651-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thread_struct is not fundamentally different between architectures, and
this patch puts it in the common header. What's really unique for each of
them is enclosed in ifdefs.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/processor.h    |   44 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |   37 ---------------------------------
 include/asm-x86/processor_64.h |   32 -----------------------------
 3 files changed, 44 insertions(+), 69 deletions(-)

Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -122,6 +122,50 @@ extern void init_scattered_cpuid_feature
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
+struct thread_struct {
+/* cached TLS descriptors. */
+	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
+	unsigned long	sp0;
+	unsigned long	sp;
+#ifdef CONFIG_X86_32
+	unsigned long	sysenter_cs;
+#else
+	unsigned long 	usersp;	/* Copy from PDA */
+	unsigned short	es, ds, fsindex, gsindex;
+#endif
+	unsigned long	ip;
+	unsigned long	fs;
+	unsigned long	gs;
+/* Hardware debugging registers */
+	unsigned long	debugreg0;
+	unsigned long	debugreg1;
+	unsigned long	debugreg2;
+	unsigned long	debugreg3;
+	unsigned long	debugreg6;
+	unsigned long	debugreg7;
+/* fault info */
+	unsigned long	cr2, trap_no, error_code;
+/* floating point info */
+	union i387_union	i387 __attribute__((aligned(16)));;
+#ifdef CONFIG_X86_32
+/* virtual 86 mode info */
+	struct vm86_struct __user *vm86_info;
+	unsigned long		screen_bitmap;
+	unsigned long		v86flags, v86mask, saved_sp0;
+	unsigned int		saved_fs, saved_gs;
+#endif
+/* IO permissions */
+	unsigned long	*io_bitmap_ptr;
+	unsigned long	iopl;
+/* max allowed port in the bitmap, in bytes: */
+	unsigned io_bitmap_max;
+/* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
+	unsigned long	debugctlmsr;
+/* Debug Store - if not 0 points to a DS Save Area configuration;
+ *               goes into MSR_IA32_DS_AREA */
+	unsigned long	ds_area_msr;
+};
+
 static inline unsigned long native_get_debugreg(int regno)
 {
 	unsigned long val = 0; 	/* Damn you, gcc! */
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -176,43 +176,6 @@ typedef struct {
 
 #define ARCH_MIN_TASKALIGN	16
 
-struct thread_struct {
-/* cached TLS descriptors. */
-	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
-	unsigned long	sp0;
-	unsigned long	sysenter_cs;
-	unsigned long	ip;
-	unsigned long	sp;
-	unsigned long	fs;
-	unsigned long	gs;
-/* Hardware debugging registers */
-	unsigned long	debugreg0;
-	unsigned long	debugreg1;
-	unsigned long	debugreg2;
-	unsigned long	debugreg3;
-	unsigned long	debugreg6;
-	unsigned long	debugreg7;
-/* fault info */
-	unsigned long	cr2, trap_no, error_code;
-/* floating point info */
-	union i387_union	i387;
-/* virtual 86 mode info */
-	struct vm86_struct __user * vm86_info;
-	unsigned long		screen_bitmap;
-	unsigned long		v86flags, v86mask, saved_sp0;
-	unsigned int		saved_fs, saved_gs;
-/* IO permissions */
-	unsigned long	*io_bitmap_ptr;
- 	unsigned long	iopl;
-/* max allowed port in the bitmap, in bytes: */
-	unsigned long	io_bitmap_max;
-/* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
-	unsigned long	debugctlmsr;
-/* Debug Store - if not 0 points to a DS Save Area configuration;
- *               goes into MSR_IA32_DS_AREA */
-	unsigned long	ds_area_msr;
-};
-
 #define INIT_THREAD  {							\
 	.sp0 = sizeof(init_stack) + (long)&init_stack,			\
 	.vm86_info = NULL,						\
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -125,38 +125,6 @@ DECLARE_PER_CPU(struct orig_ist, orig_is
 #define ARCH_MIN_MMSTRUCT_ALIGN	0
 #endif
 
-struct thread_struct {
-	unsigned long	sp0;
-	unsigned long	sp;
-	unsigned long 	usersp;	/* Copy from PDA */ 
-	unsigned long	fs;
-	unsigned long	gs;
-	unsigned short	es, ds, fsindex, gsindex;	
-/* Hardware debugging registers */
-	unsigned long	debugreg0;  
-	unsigned long	debugreg1;  
-	unsigned long	debugreg2;  
-	unsigned long	debugreg3;  
-	unsigned long	debugreg6;  
-	unsigned long	debugreg7;  
-/* fault info */
-	unsigned long	cr2, trap_no, error_code;
-/* floating point info */
-	union i387_union	i387  __attribute__((aligned(16)));
-/* IO permissions. the bitmap could be moved into the GDT, that would make
-   switch faster for a limited number of ioperm using tasks. -AK */
-	int		ioperm;
-	unsigned long	*io_bitmap_ptr;
-	unsigned io_bitmap_max;
-/* MSR_IA32_DEBUGCTLMSR value to switch in if TIF_DEBUGCTLMSR is set.  */
-	unsigned long	debugctlmsr;
-/* Debug Store - if not 0 points to a DS Save Area configuration;
- *               goes into MSR_IA32_DS_AREA */
-	unsigned long	ds_area_msr;
-/* cached TLS descriptors. */
-	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
-} __attribute__((aligned(16)));
-
 #define INIT_THREAD  { \
 	.sp0 = (unsigned long)&init_stack + sizeof(init_stack) \
 }
