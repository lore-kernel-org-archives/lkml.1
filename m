Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYFCFOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYFCFOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 01:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYFCFOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 01:14:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:59784 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYFCFOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 01:14:41 -0400
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 01:14:41 EDT
Date: Tue, 3 Jun 2008 14:02:25 +0900
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH -mm] clean up duplicated alloc/free_thread_info
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080603140620S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reason we duplicate alloc/free_thread_info defines on many
platforms?

Note:

- I don't like __HAVE_ARCH_THREAD_INFO_ALLOCATOR name much. I chose
that name just because we define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR in
the same place.

- frv, m32r, mips, mn10300, and sh uses kmalloc/kfree instead of
__get_free_pages/free_pages. I let them alone but it could remove more
code if __get_free_pages/free_pages works for them.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm] clean up duplicated alloc/free_thread_info

We duplicate alloc/free_thread_info defines on many platforms (the
majority uses __get_free_pages/free_pages). This patch defines common
defines and removes these duplicated
defines. __HAVE_ARCH_THREAD_INFO_ALLOCATOR is introduced for platforms
that do something different.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-alpha/thread_info.h     |    4 +---
 include/asm-arm/thread_info.h       |   13 -------------
 include/asm-blackfin/thread_info.h  |    5 +----
 include/asm-cris/thread_info.h      |    2 ++
 include/asm-frv/thread_info.h       |    2 ++
 include/asm-h8300/thread_info.h     |    5 +----
 include/asm-ia64/thread_info.h      |    2 ++
 include/asm-m32r/thread_info.h      |    2 ++
 include/asm-m68k/thread_info.h      |    8 +-------
 include/asm-m68knommu/thread_info.h |    4 ----
 include/asm-mips/thread_info.h      |    2 ++
 include/asm-mn10300/thread_info.h   |    2 ++
 include/asm-parisc/thread_info.h    |   10 +++-------
 include/asm-powerpc/thread_info.h   |   14 +++-----------
 include/asm-s390/thread_info.h      |    5 +----
 include/asm-sh/thread_info.h        |    2 ++
 include/asm-sparc/thread_info.h     |    2 ++
 include/asm-sparc64/thread_info.h   |   23 ++---------------------
 include/asm-um/thread_info.h        |   16 +---------------
 include/asm-x86/thread_info.h       |    2 ++
 include/asm-xtensa/thread_info.h    |    5 +----
 kernel/fork.c                       |   17 +++++++++++++++++
 22 files changed, 50 insertions(+), 97 deletions(-)

diff --git a/include/asm-alpha/thread_info.h b/include/asm-alpha/thread_info.h
index fb31851..15fda43 100644
--- a/include/asm-alpha/thread_info.h
+++ b/include/asm-alpha/thread_info.h
@@ -50,10 +50,8 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define current_thread_info()  __current_thread_info
 
 /* Thread information allocation.  */
+#define THREAD_SIZE_ORDER 1
 #define THREAD_SIZE (2*PAGE_SIZE)
-#define alloc_thread_info(tsk) \
-  ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
-#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/include/asm-arm/thread_info.h b/include/asm-arm/thread_info.h
index f5a6647..d4be2d6 100644
--- a/include/asm-arm/thread_info.h
+++ b/include/asm-arm/thread_info.h
@@ -97,19 +97,6 @@ static inline struct thread_info *current_thread_info(void)
 	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
 }
 
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, \
-		THREAD_SIZE_ORDER))
-#else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER))
-#endif
-
-#define free_thread_info(info) \
-	free_pages((unsigned long)info, THREAD_SIZE_ORDER);
-
 #define thread_saved_pc(tsk)	\
 	((unsigned long)(pc_pointer(task_thread_info(tsk)->cpu_context.pc)))
 #define thread_saved_fp(tsk)	\
diff --git a/include/asm-blackfin/thread_info.h b/include/asm-blackfin/thread_info.h
index bc2fe5a..6427693 100644
--- a/include/asm-blackfin/thread_info.h
+++ b/include/asm-blackfin/thread_info.h
@@ -42,6 +42,7 @@
 /*
  * Size of kernel stack for each process. This must be a power of 2...
  */
+#define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		8192	/* 2 pages */
 
 #ifndef __ASSEMBLY__
@@ -94,10 +95,6 @@ static inline struct thread_info *current_thread_info(void)
 	return (struct thread_info *)((long)ti & ~((long)THREAD_SIZE-1));
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-				__get_free_pages(GFP_KERNEL, 1))
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), 1)
 #endif				/* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-cris/thread_info.h b/include/asm-cris/thread_info.h
index 784668a..7efe100 100644
--- a/include/asm-cris/thread_info.h
+++ b/include/asm-cris/thread_info.h
@@ -11,6 +11,8 @@
 
 #ifdef __KERNEL__
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
 #include <asm/processor.h>
diff --git a/include/asm-frv/thread_info.h b/include/asm-frv/thread_info.h
index 348b8f1..b7ac6bf 100644
--- a/include/asm-frv/thread_info.h
+++ b/include/asm-frv/thread_info.h
@@ -82,6 +82,8 @@ register struct thread_info *__current_thread_info asm("gr15");
 
 #define current_thread_info() ({ __current_thread_info; })
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk)					\
diff --git a/include/asm-h8300/thread_info.h b/include/asm-h8300/thread_info.h
index 27bb95e..aafd4d3 100644
--- a/include/asm-h8300/thread_info.h
+++ b/include/asm-h8300/thread_info.h
@@ -49,6 +49,7 @@ struct thread_info {
 /*
  * Size of kernel stack for each process. This must be a power of 2...
  */
+#define THREAD_SIZE_ORDER	1
 #define THREAD_SIZE		8192	/* 2 pages */
 
 
@@ -65,10 +66,6 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-				__get_free_pages(GFP_KERNEL, 1))
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), 1)
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/include/asm-ia64/thread_info.h b/include/asm-ia64/thread_info.h
index 2422ac6..7c60fcd 100644
--- a/include/asm-ia64/thread_info.h
+++ b/include/asm-ia64/thread_info.h
@@ -54,6 +54,8 @@ struct thread_info {
 	},					\
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifndef ASM_OFFSETS_C
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *) ((char *) current + IA64_TASK_SIZE))
diff --git a/include/asm-m32r/thread_info.h b/include/asm-m32r/thread_info.h
index 1effcd0..8589d46 100644
--- a/include/asm-m32r/thread_info.h
+++ b/include/asm-m32r/thread_info.h
@@ -94,6 +94,8 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk)					\
diff --git a/include/asm-m68k/thread_info.h b/include/asm-m68k/thread_info.h
index d635a37..abc0027 100644
--- a/include/asm-m68k/thread_info.h
+++ b/include/asm-m68k/thread_info.h
@@ -25,13 +25,7 @@ struct thread_info {
 }
 
 /* THREAD_SIZE should be 8k, so handle differently for 4k and 8k machines */
-#if PAGE_SHIFT == 13 /* 8k machines */
-#define alloc_thread_info(tsk)   ((struct thread_info *)__get_free_pages(GFP_KERNEL,0))
-#define free_thread_info(ti)  free_pages((unsigned long)(ti),0)
-#else /* otherwise assume 4k pages */
-#define alloc_thread_info(tsk)   ((struct thread_info *)__get_free_pages(GFP_KERNEL,1))
-#define free_thread_info(ti)  free_pages((unsigned long)(ti),1)
-#endif /* PAGE_SHIFT == 13 */
+#define THREAD_SIZE_ORDER (13 - PAGE_SHIFT)
 
 #define init_thread_info	(init_task.thread.info)
 #define init_stack		(init_thread_union.stack)
diff --git a/include/asm-m68knommu/thread_info.h b/include/asm-m68knommu/thread_info.h
index 95996d9..0c9bc09 100644
--- a/include/asm-m68knommu/thread_info.h
+++ b/include/asm-m68knommu/thread_info.h
@@ -71,10 +71,6 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-				__get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER))
-#define free_thread_info(ti)	free_pages((unsigned long) (ti), THREAD_SIZE_ORDER)
 #endif /* __ASSEMBLY__ */
 
 #define	PREEMPT_ACTIVE	0x4000000
diff --git a/include/asm-mips/thread_info.h b/include/asm-mips/thread_info.h
index b2772df..bb30606 100644
--- a/include/asm-mips/thread_info.h
+++ b/include/asm-mips/thread_info.h
@@ -82,6 +82,8 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define THREAD_SIZE (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_MASK (THREAD_SIZE - 1UL)
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk)					\
 ({								\
diff --git a/include/asm-mn10300/thread_info.h b/include/asm-mn10300/thread_info.h
index e397e71..78a3881 100644
--- a/include/asm-mn10300/thread_info.h
+++ b/include/asm-mn10300/thread_info.h
@@ -112,6 +112,8 @@ static inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(tsk) kzalloc(THREAD_SIZE, GFP_KERNEL)
diff --git a/include/asm-parisc/thread_info.h b/include/asm-parisc/thread_info.h
index 2d9c750..9f81274 100644
--- a/include/asm-parisc/thread_info.h
+++ b/include/asm-parisc/thread_info.h
@@ -34,15 +34,11 @@ struct thread_info {
 
 /* thread information allocation */
 
-#define THREAD_ORDER            2
+#define THREAD_SIZE_ORDER            2
 /* Be sure to hunt all references to this down when you change the size of
  * the kernel stack */
-#define THREAD_SIZE             (PAGE_SIZE << THREAD_ORDER)
-#define THREAD_SHIFT            (PAGE_SHIFT + THREAD_ORDER)
-
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-			__get_free_pages(GFP_KERNEL, THREAD_ORDER))
-#define free_thread_info(ti)    free_pages((unsigned long) (ti), THREAD_ORDER)
+#define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 
 /* how to get the thread information struct from C */
 #define current_thread_info()	((struct thread_info *)mfctl(30))
diff --git a/include/asm-powerpc/thread_info.h b/include/asm-powerpc/thread_info.h
index b705c2a..a9db562 100644
--- a/include/asm-powerpc/thread_info.h
+++ b/include/asm-powerpc/thread_info.h
@@ -66,20 +66,12 @@ struct thread_info {
 
 #if THREAD_SHIFT >= PAGE_SHIFT
 
-#define THREAD_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
-
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)	\
-	((struct thread_info *)__get_free_pages(GFP_KERNEL | \
-		__GFP_ZERO, THREAD_ORDER))
-#else
-#define alloc_thread_info(tsk)	\
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, THREAD_ORDER))
-#endif
-#define free_thread_info(ti)	free_pages((unsigned long)ti, THREAD_ORDER)
+#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
 
 #else /* THREAD_SHIFT < PAGE_SHIFT */
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 extern struct thread_info *alloc_thread_info(struct task_struct *tsk);
 extern void free_thread_info(struct thread_info *ti);
 
diff --git a/include/asm-s390/thread_info.h b/include/asm-s390/thread_info.h
index 99bbed9..91a8f93 100644
--- a/include/asm-s390/thread_info.h
+++ b/include/asm-s390/thread_info.h
@@ -78,10 +78,7 @@ static inline struct thread_info *current_thread_info(void)
 	return (struct thread_info *)((*(unsigned long *) __LC_KERNEL_STACK)-THREAD_SIZE);
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) \
-	__get_free_pages(GFP_KERNEL,THREAD_ORDER))
-#define free_thread_info(ti) free_pages((unsigned long) (ti),THREAD_ORDER)
+#define THREAD_SIZE_ORDER THREAD_ORDER
 
 #endif
 
diff --git a/include/asm-sh/thread_info.h b/include/asm-sh/thread_info.h
index c50e5d3..5131e39 100644
--- a/include/asm-sh/thread_info.h
+++ b/include/asm-sh/thread_info.h
@@ -92,6 +92,8 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 /* thread information allocation */
 #ifdef CONFIG_DEBUG_STACK_USAGE
 #define alloc_thread_info(ti)	kzalloc(THREAD_SIZE, GFP_KERNEL)
diff --git a/include/asm-sparc/thread_info.h b/include/asm-sparc/thread_info.h
index 91b9f58..2cf9db0 100644
--- a/include/asm-sparc/thread_info.h
+++ b/include/asm-sparc/thread_info.h
@@ -86,6 +86,8 @@ register struct thread_info *current_thread_info_reg asm("g6");
 #define THREAD_INFO_ORDER  1
 #endif
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 BTFIXUPDEF_CALL(struct thread_info *, alloc_thread_info, void)
 #define alloc_thread_info(tsk) BTFIXUP_CALL(alloc_thread_info)()
 
diff --git a/include/asm-sparc64/thread_info.h b/include/asm-sparc64/thread_info.h
index e5873e3..d55f7fe 100644
--- a/include/asm-sparc64/thread_info.h
+++ b/include/asm-sparc64/thread_info.h
@@ -150,30 +150,11 @@ register struct thread_info *current_thread_info_reg asm("g6");
 
 /* thread information allocation */
 #if PAGE_SHIFT == 13
-#define __THREAD_INFO_ORDER	1
+#define THREAD_SIZE_ORDER	1
 #else /* PAGE_SHIFT == 13 */
-#define __THREAD_INFO_ORDER	0
+#define THREAD_SIZE_ORDER	0
 #endif /* PAGE_SHIFT == 13 */
 
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-({								\
-	struct thread_info *ret;				\
-								\
-	ret = (struct thread_info *)				\
-	  __get_free_pages(GFP_KERNEL, __THREAD_INFO_ORDER);	\
-	if (ret)						\
-		memset(ret, 0, PAGE_SIZE<<__THREAD_INFO_ORDER);	\
-	ret;							\
-})
-#else
-#define alloc_thread_info(tsk) \
-	((struct thread_info *)__get_free_pages(GFP_KERNEL, __THREAD_INFO_ORDER))
-#endif
-
-#define free_thread_info(ti) \
-	free_pages((unsigned long)(ti),__THREAD_INFO_ORDER)
-
 #define __thread_flag_byte_ptr(ti)	\
 	((unsigned char *)(&((ti)->flags)))
 #define __cur_thread_flag_byte_ptr	__thread_flag_byte_ptr(current_thread_info())
diff --git a/include/asm-um/thread_info.h b/include/asm-um/thread_info.h
index 356b83e..e07e728 100644
--- a/include/asm-um/thread_info.h
+++ b/include/asm-um/thread_info.h
@@ -53,21 +53,7 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-#ifdef CONFIG_DEBUG_STACK_USAGE
-
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL | __GFP_ZERO, \
-						 CONFIG_KERNEL_STACK_ORDER))
-#else
-
-/* thread information allocation */
-#define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(GFP_KERNEL, \
-						 CONFIG_KERNEL_STACK_ORDER))
-#endif
-
-#define free_thread_info(ti) \
-	free_pages((unsigned long)(ti),CONFIG_KERNEL_STACK_ORDER)
+#define THREAD_SIZE_ORDER CONFIG_KERNEL_STACK_ORDER
 
 #endif
 
diff --git a/include/asm-x86/thread_info.h b/include/asm-x86/thread_info.h
index 895339d..bb62b54 100644
--- a/include/asm-x86/thread_info.h
+++ b/include/asm-x86/thread_info.h
@@ -151,6 +151,8 @@ struct thread_info {
 #define THREAD_FLAGS GFP_KERNEL
 #endif
 
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
 #define alloc_thread_info(tsk)						\
 	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
 
diff --git a/include/asm-xtensa/thread_info.h b/include/asm-xtensa/thread_info.h
index a2c6406..7e4131d 100644
--- a/include/asm-xtensa/thread_info.h
+++ b/include/asm-xtensa/thread_info.h
@@ -111,10 +111,6 @@ static inline struct thread_info *current_thread_info(void)
 	return ti;
 }
 
-/* thread information allocation */
-#define alloc_thread_info(tsk) ((struct thread_info *) __get_free_pages(GFP_KERNEL,1))
-#define free_thread_info(ti) free_pages((unsigned long) (ti), 1)
-
 #else /* !__ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
@@ -160,6 +156,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 
 #define THREAD_SIZE 8192	//(2*PAGE_SIZE)
+#define THREAD_SIZE_ORDER 1
 
 #endif	/* __KERNEL__ */
 #endif	/* _XTENSA_THREAD_INFO */
diff --git a/kernel/fork.c b/kernel/fork.c
index 12d13d3..dc0b9b2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -94,6 +94,23 @@ int nr_processes(void)
 static struct kmem_cache *task_struct_cachep;
 #endif
 
+#ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+static inline struct thread_info *alloc_thread_info(struct task_struct *tsk)
+{
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
+#else
+	gfp_t mask = GFP_KERNEL;
+#endif
+	return (struct thread_info *)__get_free_pages(mask, THREAD_SIZE_ORDER);
+}
+
+static inline void free_thread_info(struct thread_info *ti)
+{
+	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+}
+#endif
+
 /* SLAB cache for signal_struct structures (tsk->signal) */
 static struct kmem_cache *signal_cachep;
 
-- 
1.5.4.2

