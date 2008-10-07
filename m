Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYJGLnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYJGLnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYJGLnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:43:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38018 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYJGLnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:43:14 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20081007143.793379346@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space
Date: Tue,  7 Oct 2008 13:43:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For simple user space timing it's very useful to be able to do
#include <asm/msr.h> instead of having to cut'n'paste the necessarily
macros into all programs. This used to work with older kernels,
but broke with the paravirt support (I ended up with a bunch of
test programs that broke because of that). But it's very useful
to have rdtscll() available somewhere in user space and asm/msr.h
is a good place to have them.

Provide simple rdtsc/rdtscl() macros for user space too in asm/msr.h. 
Since they are very simple I don't think they are a burden to maintain.

The diff looks bigger than it is because I moved a code block
and diff doesn't handle it very well.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/include/asm-x86/msr.h
===================================================================
--- linux-2.6.27-rc4-misc.orig/include/asm-x86/msr.h
+++ linux-2.6.27-rc4-misc/include/asm-x86/msr.h
@@ -4,23 +4,6 @@
 #include <asm/msr-index.h>
 
 #ifndef __ASSEMBLY__
-# include <linux/types.h>
-#endif
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <asm/asm.h>
-#include <asm/errno.h>
-
-static inline unsigned long long native_read_tscp(unsigned int *aux)
-{
-	unsigned long low, high;
-	asm volatile(".byte 0x0f,0x01,0xf9"
-		     : "=a" (low), "=d" (high), "=c" (*aux));
-	return low | ((u64)high << 32);
-}
-
 /*
  * i386 calling convention returns 64-bit value in edx:eax, while
  * x86_64 returns at rax. Also, the "A" constraint does not really
@@ -29,7 +12,7 @@ static inline unsigned long long native_
  */
 #ifdef CONFIG_X86_64
 #define DECLARE_ARGS(val, low, high)	unsigned low, high
-#define EAX_EDX_VAL(val, low, high)	((low) | ((u64)(high) << 32))
+#define EAX_EDX_VAL(val, low, high)	((low) | ((__u64)(high) << 32))
 #define EAX_EDX_ARGS(val, low, high)	"a" (low), "d" (high)
 #define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
 #else
@@ -39,6 +22,23 @@ static inline unsigned long long native_
 #define EAX_EDX_RET(val, low, high)	"=A" (val)
 #endif
 
+#endif
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm/asm.h>
+#include <asm/errno.h>
+
+static inline unsigned long long native_read_tscp(unsigned int *aux)
+{
+	unsigned long low, high;
+	asm volatile(".byte 0x0f,0x01,0xf9"
+		     : "=a" (low), "=d" (high), "=c" (*aux));
+	return low | ((u64)high << 32);
+}
+
 static inline unsigned long long native_read_msr(unsigned int msr)
 {
 	DECLARE_ARGS(val, low, high);
@@ -217,6 +217,24 @@ static inline int wrmsr_safe_on_cpu(unsi
 }
 #endif  /* CONFIG_SMP */
 #endif /* __ASSEMBLY__ */
+
+#else
+
+/*
+ * Provide simple rdtsc macros for non kernel users. These differ
+ * from the kernel versions by not having barriers and not supporting
+ * paravirtualization.
+ */
+static __always_inline unsigned long long __read_tsc(void)
+{
+	DECLARE_ARGS(val, low, high);
+	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
+	return EAX_EDX_VAL(val, low, high);
+}
+
+#define rdtscl(low) ({ asm volatile("rdtsc" : "=a" (low) :: "d"); })
+#define rdtscll(val) ((val) = __read_tsc())
+
 #endif /* __KERNEL__ */
 
 
