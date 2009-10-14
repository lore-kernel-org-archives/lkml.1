Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZJNGDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZJNGDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZJNGDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:58695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbZJNGDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:45 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/16] percpu: add __percpu for sparse.
Date: Wed, 14 Oct 2009 15:02:04 +0900
Message-Id: <1255500125-3210-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

We have to make __kernel "__attribute__((address_space(0)))" so we can
cast to it.

tj: * put_cpu_var() update.

    * Annotations added to dynamic allocator interface.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/asm-generic/percpu.h |    4 +++-
 include/linux/compiler.h     |    4 +++-
 include/linux/percpu-defs.h  |    2 +-
 include/linux/percpu.h       |   18 +++++++++++-------
 4 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index ca6f049..fded453 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -41,7 +41,9 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
  * Only S390 provides its own means of moving the pointer.
  */
 #ifndef SHIFT_PERCPU_PTR
-#define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+/* Weird cast keeps both GCC and sparse happy. */
+#define SHIFT_PERCPU_PTR(__p, __offset)				\
+	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
 #endif
 
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 04fb513..abba804 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -5,7 +5,7 @@
 
 #ifdef __CHECKER__
 # define __user		__attribute__((noderef, address_space(1)))
-# define __kernel	/* default address space */
+# define __kernel	__attribute__((address_space(0)))
 # define __safe		__attribute__((safe))
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
@@ -15,6 +15,7 @@
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
+# define __percpu	__attribute__((noderef, address_space(3)))
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
@@ -32,6 +33,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __acquire(x) (void)0
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)
+# define __percpu
 #endif
 
 #ifdef __KERNEL__
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index ee99f6c..0fa0cb5 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -12,7 +12,7 @@
  * that section.
  */
 #define __PCPU_ATTRS(sec)						\
-	__attribute__((section(PER_CPU_BASE_SECTION sec)))		\
+	__percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))	\
 	PER_CPU_ATTRIBUTES
 
 #define __PCPU_DUMMY_ATTRS						\
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index f965f83..2c0d31a 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -30,8 +30,12 @@
 	preempt_disable();				\
 	&__get_cpu_var(var); }))
 
+/*
+ * The weird & is necessary because sparse considers (void)(var) to be
+ * a direct dereference of percpu variable (var).
+ */
 #define put_cpu_var(var) do {				\
-	(void)(var);					\
+	(void)&(var);					\
 	preempt_enable();				\
 } while (0)
 
@@ -130,9 +134,9 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
  */
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
-extern void *__alloc_reserved_percpu(size_t size, size_t align);
-extern void *__alloc_percpu(size_t size, size_t align);
-extern void free_percpu(void *__pdata);
+extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
+extern void __percpu *__alloc_percpu(size_t size, size_t align);
+extern void free_percpu(void __percpu *__pdata);
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void __init setup_per_cpu_areas(void);
@@ -142,7 +146,7 @@ extern void __init setup_per_cpu_areas(void);
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void *__alloc_percpu(size_t size, size_t align)
+static inline void __percpu *__alloc_percpu(size_t size, size_t align)
 {
 	/*
 	 * Can't easily make larger alignment work with kmalloc.  WARN
@@ -153,7 +157,7 @@ static inline void *__alloc_percpu(size_t size, size_t align)
 	return kzalloc(size, GFP_KERNEL);
 }
 
-static inline void free_percpu(void *p)
+static inline void free_percpu(void __percpu *p)
 {
 	kfree(p);
 }
@@ -168,7 +172,7 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
 #endif /* CONFIG_SMP */
 
 #define alloc_percpu(type)	\
-	(typeof(type) *)__alloc_percpu(sizeof(type), __alignof__(type))
+	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
 /*
  * Optional methods for optimized non-lvalue per-cpu variable access.
-- 
1.6.4.2

