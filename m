Return-Path: <linux-kernel-owner+w=401wt.eu-S939645AbZDJTDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939645AbZDJTDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZDJTDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:03:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:37415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZDJTDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:03:38 -0400
Message-ID: <49DF97D0.9090506@kernel.org>
Date: Fri, 10 Apr 2009 12:02:40 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk> <20090410171415.GA6033@ZenIV.linux.org.uk> <20090410180532.GA4419@jurassic.park.msu.ru> <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain> <49DF935E.8030607@kernel.org>
In-Reply-To: <49DF935E.8030607@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 19:02:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long term, I think what Ivan proposed with a bit of addition so that
combination of DECLARE_PER_CPU() and static DEFINE_PER_CPU() triggers
compile error but I think it's better to do it when converting non-x86
archs to dynamic percpu allocator which is scheduled for the next
merge window.  For the time being, how about just moving the generic
percpu_*() accessors to linux/percpu.h?  asm-generic/percpu.h is meant
to carry generic stuff for low level stuff - declarations, definitions
and pointer offset calculation and so on but not for generic
interface.

I currently can't build or test stuff so the patch is not tested at
all.  Ingo, can you please test whether this would work?

Thanks.
---
 include/asm-generic/percpu.h |   52 -------------------------------------------
 include/linux/percpu.h       |   52 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 00f45ff..b0e63c6 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -80,56 +80,4 @@ extern void setup_per_cpu_areas(void);
 #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
 					__typeof__(type) per_cpu_var(name)
 
-/*
- * Optional methods for optimized non-lvalue per-cpu variable access.
- *
- * @var can be a percpu variable or a field of it and its size should
- * equal char, int or long.  percpu_read() evaluates to a lvalue and
- * all others to void.
- *
- * These operations are guaranteed to be atomic w.r.t. preemption.
- * The generic versions use plain get/put_cpu_var().  Archs are
- * encouraged to implement single-instruction alternatives which don't
- * require preemption protection.
- */
-#ifndef percpu_read
-# define percpu_read(var)						\
-  ({									\
-	typeof(per_cpu_var(var)) __tmp_var__;				\
-	__tmp_var__ = get_cpu_var(var);					\
-	put_cpu_var(var);						\
-	__tmp_var__;							\
-  })
-#endif
-
-#define __percpu_generic_to_op(var, val, op)				\
-do {									\
-	get_cpu_var(var) op val;					\
-	put_cpu_var(var);						\
-} while (0)
-
-#ifndef percpu_write
-# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
-#endif
-
-#ifndef percpu_add
-# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
-#endif
-
-#ifndef percpu_sub
-# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
-#endif
-
-#ifndef percpu_and
-# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
-#endif
-
-#ifndef percpu_or
-# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
-#endif
-
-#ifndef percpu_xor
-# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
-#endif
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ee5615d..cfda2d5 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -168,4 +168,56 @@ static inline void free_percpu(void *p)
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
 						       __alignof__(type))
 
+/*
+ * Optional methods for optimized non-lvalue per-cpu variable access.
+ *
+ * @var can be a percpu variable or a field of it and its size should
+ * equal char, int or long.  percpu_read() evaluates to a lvalue and
+ * all others to void.
+ *
+ * These operations are guaranteed to be atomic w.r.t. preemption.
+ * The generic versions use plain get/put_cpu_var().  Archs are
+ * encouraged to implement single-instruction alternatives which don't
+ * require preemption protection.
+ */
+#ifndef percpu_read
+# define percpu_read(var)						\
+  ({									\
+	typeof(per_cpu_var(var)) __tmp_var__;				\
+	__tmp_var__ = get_cpu_var(var);					\
+	put_cpu_var(var);						\
+	__tmp_var__;							\
+  })
+#endif
+
+#define __percpu_generic_to_op(var, val, op)				\
+do {									\
+	get_cpu_var(var) op val;					\
+	put_cpu_var(var);						\
+} while (0)
+
+#ifndef percpu_write
+# define percpu_write(var, val)		__percpu_generic_to_op(var, (val), =)
+#endif
+
+#ifndef percpu_add
+# define percpu_add(var, val)		__percpu_generic_to_op(var, (val), +=)
+#endif
+
+#ifndef percpu_sub
+# define percpu_sub(var, val)		__percpu_generic_to_op(var, (val), -=)
+#endif
+
+#ifndef percpu_and
+# define percpu_and(var, val)		__percpu_generic_to_op(var, (val), &=)
+#endif
+
+#ifndef percpu_or
+# define percpu_or(var, val)		__percpu_generic_to_op(var, (val), |=)
+#endif
+
+#ifndef percpu_xor
+# define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
+#endif
+
 #endif /* __LINUX_PERCPU_H */
