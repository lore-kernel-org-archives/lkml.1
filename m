Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZLRCFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZLRCFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZLRCFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:05:11 -0500
Received: from ozlabs.org ([203.10.76.45]:43257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZLRCFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:05:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] BUILD_BUG_ON improvements
Date: Fri, 18 Dec 2009 12:35:01 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Hollis Blanchard <hollisb@us.ibm.com>,
       Jan Beulich <JBeulich@novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912181235.01742.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b8a7f3cd7e8212e5c572178ff3b5a514861036a5:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git BUILD_BUG_ON

Rusty Russell (3):
      BUILD_BUG_ON: make it handle more cases
      Remove MAYBE_BUILD_BUG_ON
      kernel.h: move BUILD_BUG_ON et al inside __KERNEL__

 include/linux/gfp.h           |    2 +-
 include/linux/kernel.h        |   80 +++++++++++++++++++++++++----------------
 include/linux/kmemcheck.h     |    2 +-
 include/linux/virtio_config.h |    5 ++-
 4 files changed, 55 insertions(+), 34 deletions(-)

commit a7a9f439b8380b930a47a0b17b217f87458844f6
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 18 12:32:55 2009 -0600

    BUILD_BUG_ON: make it handle more cases
    
    BUILD_BUG_ON used to use the optimizer to do code elimination or fail
    at link time; it was changed to first the size of a negative array (a
    nicer compile time error), then (in
    8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.
    
    bitfields: needs a literal constant at parse time, and can't be put under
    	"if (__builtin_constant_p(x))" for example.
    negative array: can handle anything, but if the compiler can't tell it's
    	a constant, silently has no effect.
    link time: breaks link if the compiler can't determine the value, but the
    	linker output is not usually as informative as a compiler error.
    
    If we use the negative-array-size method *and* the link time trick,
    we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
    branches, and maximal ability for the compiler to detect errors at
    build time.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Hollis Blanchard <hollisb@us.ibm.com>

 include/linux/kernel.h |   33 +++++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 6 deletions(-)

commit 7f6d9e683ab862e7b102d65766c131bc6136e6ca
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 18 12:32:57 2009 -0600

    Remove MAYBE_BUILD_BUG_ON
    
    Now BUILD_BUG_ON() can handle optimizable constants, we don't need
    MAYBE_BUILD_BUG_ON any more.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/gfp.h           |    2 +-
 include/linux/kernel.h        |    1 -
 include/linux/kmemcheck.h     |    2 +-
 include/linux/virtio_config.h |    5 ++++-
 4 files changed, 6 insertions(+), 4 deletions(-)

commit 10b483dd7905f59062f7aa2986a1d4c7f5129dc3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Dec 18 12:32:58 2009 -0600

    kernel.h: move BUILD_BUG_ON et al inside __KERNEL__
    
    Recent warning caused by change in BUILD_BUG_ON:
    
    	usr/include/linux/kernel.h:53: userspace cannot call function or variable defined in the kernel
    
    Macros no longer accessible to userspace:
    
    	BUILD_BUG_ON_ZERO, BUILD_BUG_ON_NULL, BUILD_BUG_ON,
    	__FUNCTION__, NUMA_BUILD, REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD.
    
    (The last two were in #ifdef CONFIG anyway, so already useless).
    
    Also, avoid silly re-test of __KERNEL__ immediately below.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

 include/linux/kernel.h |   50 +++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 26 deletions(-)


diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 557bdad..f53e9b8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -220,7 +220,7 @@ static inline enum zone_type gfp_zone(gfp_t flags)
 					 ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
-		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	else {
 #ifdef CONFIG_DEBUG_VM
 		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fc9f5a..57ffaa0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -702,13 +702,59 @@ static inline void ftrace_dump(void) { }
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
-#endif /* __KERNEL__ */
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
+
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @cond: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but
+ * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
+ * to inline functions).  So as a fallback we use the optimizer; if it can't
+ * prove the condition is false, it will cause a link error on the undefined
+ * "__build_bug_on_failed".  This error message can be harder to track down
+ * though, hence the two different methods.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+extern int __build_bug_on_failed;
+#define BUILD_BUG_ON(condition)					\
+	do {							\
+		((void)sizeof(char[1 - 2*!!(condition)]));	\
+		if (condition) __build_bug_on_failed = 1;	\
+	} while(0)
+#endif
+
+/* Trap pasters of __FUNCTION__ at compile-time */
+#define __FUNCTION__ (__func__)
+
+/* This helps us to avoid #ifdef CONFIG_NUMA */
+#ifdef CONFIG_NUMA
+#define NUMA_BUILD 1
+#else
+#define NUMA_BUILD 0
+#endif
+
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
 
+#else /* __KERNEL__ */
 #ifndef __EXPORTED_HEADERS__
-#ifndef __KERNEL__
 #warning Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders
-#endif /* __KERNEL__ */
 #endif /* __EXPORTED_HEADERS__ */
+#endif /* !__KERNEL__ */
 
 #define SI_LOAD_SHIFT	16
 struct sysinfo {
@@ -728,32 +774,4 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
-
-/* Force a compilation error if condition is constant and true */
-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
-
-/* Force a compilation error if condition is true, but also produce a
-   result (of value 0 and type size_t), so the expression can be used
-   e.g. in a structure initializer (or where-ever else comma expressions
-   aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
-#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
-
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
-
-/* This helps us to avoid #ifdef CONFIG_NUMA */
-#ifdef CONFIG_NUMA
-#define NUMA_BUILD 1
-#else
-#define NUMA_BUILD 0
-#endif
-
-/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
-# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
-#endif
-
 #endif
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index e880d4c..136cdcd 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -152,7 +152,7 @@ static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
 									\
 		_n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
-		MAYBE_BUILD_BUG_ON(_n < 0);				\
+		BUILD_BUG_ON(_n < 0);					\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
 	} while (0)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 0093dd7..800617b 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -109,7 +109,10 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
-	MAYBE_BUILD_BUG_ON(fbit >= 32);
+	if (__builtin_constant_p(fbit))
+		BUILD_BUG_ON(fbit >= 32);
+	else
+		BUG_ON(fbit >= 32);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
