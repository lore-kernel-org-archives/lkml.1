Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZJNGD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZJNGD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZJNGDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:58671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbZJNGDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:23 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 16/16] percpu: make accessors check for percpu pointer in sparse
Date: Wed, 14 Oct 2009 15:02:05 +0900
Message-Id: <1255500125-3210-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch made sparse warn about percpu variables being used
directly without going through percpu accessors.  This patch
implements the other half - checking whether non percpu variable is
passed into percpu accessors.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-generic/percpu.h |    6 ++++--
 include/linux/percpu-defs.h  |   20 ++++++++++++++++++--
 include/linux/percpu.h       |    2 ++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index fded453..04f91c2 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -42,8 +42,10 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
  */
 #ifndef SHIFT_PERCPU_PTR
 /* Weird cast keeps both GCC and sparse happy. */
-#define SHIFT_PERCPU_PTR(__p, __offset)				\
-	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
+#define SHIFT_PERCPU_PTR(__p, __offset)	({				\
+	__verify_pcpu_ptr((__p));					\
+	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
+})
 #endif
 
 /*
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 0fa0cb5..1fa36eb 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -19,6 +19,16 @@
 	__attribute__((section(".discard"), unused))
 
 /*
+ * Macro which verifies @ptr is a percpu pointer without evaluating
+ * @ptr.  This is to be used in percpu accessors to verify that the
+ * input parameter is a percpu pointer.
+ */
+#define __verify_pcpu_ptr(ptr)	do {					\
+	void __percpu *__vpp_verify = (typeof(ptr))NULL;		\
+	(void)__vpp_verify;						\
+} while (0)
+
+/*
  * s390 and alpha modules require percpu variables to be defined as
  * weak to force the compiler to generate GOT based external
  * references for them.  This is necessary because percpu sections
@@ -129,10 +139,16 @@
 	__aligned(PAGE_SIZE)
 
 /*
- * Intermodule exports for per-CPU variables.
+ * Intermodule exports for per-CPU variables.  sparse forgets about
+ * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
+ * noop if __CHECKER__.
  */
+#ifndef __CHECKER__
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(var)
-
+#else
+#define EXPORT_PER_CPU_SYMBOL(var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var)
+#endif
 
 #endif /* _LINUX_PERCPU_DEFS_H */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 2c0d31a..42878f0 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -237,6 +237,7 @@ extern void __bad_size_call_parameter(void);
 
 #define __pcpu_size_call_return(stem, variable)				\
 ({	typeof(variable) pscr_ret__;					\
+	__verify_pcpu_ptr(&(variable));					\
 	switch(sizeof(variable)) {					\
 	case 1: pscr_ret__ = stem##1(variable);break;			\
 	case 2: pscr_ret__ = stem##2(variable);break;			\
@@ -250,6 +251,7 @@ extern void __bad_size_call_parameter(void);
 
 #define __pcpu_size_call(stem, variable, ...)				\
 do {									\
+	__verify_pcpu_ptr(&(variable));					\
 	switch(sizeof(variable)) {					\
 		case 1: stem##1(variable, __VA_ARGS__);break;		\
 		case 2: stem##2(variable, __VA_ARGS__);break;		\
-- 
1.6.4.2

