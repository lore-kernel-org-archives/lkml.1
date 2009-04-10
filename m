Return-Path: <linux-kernel-owner+w=401wt.eu-S935014AbZDJTm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935014AbZDJTm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761459AbZDJTmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:42:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763196AbZDJTmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:42:16 -0400
Date: Fri, 10 Apr 2009 21:40:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Al Viro <viro@ZenIV.linux.org.uk>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] percpu + mutex fixes
Message-ID: <20090410194055.GA21133@elte.hu>
References: <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk> <20090410171415.GA6033@ZenIV.linux.org.uk> <20090410180532.GA4419@jurassic.park.msu.ru> <alpine.LFD.2.00.0904101118470.4583@localhost.localdomain> <49DF935E.8030607@kernel.org> <49DF97D0.9090506@kernel.org> <20090410193444.GA18039@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410193444.GA18039@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Now i understand the rush ...
> 
> Yes, moving the APIs to the generic header should properly expose 
> the wrapped default implementations. I'll test your patch in a 
> minute.

Alpha builds fine with your patch:

  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux
  SYSMAP  System.map

Linus,

If that patch is OK to you too, please pull the latest 
core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

it includes this fix and a pending mutex fixlet.

 Thanks,

	Ingo

------------------>
Heiko Carstens (1):
      mutex: have non-spinning mutexes on s390 by default

Tejun Heo (1):
      percpu: unbreak alpha percpu


 arch/Kconfig                 |    3 ++
 arch/s390/Kconfig            |    1 +
 include/asm-generic/percpu.h |   52 ------------------------------------------
 include/linux/percpu.h       |   52 ++++++++++++++++++++++++++++++++++++++++++
 kernel/mutex.c               |    3 +-
 5 files changed, 58 insertions(+), 53 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index dc81b34..78a35e9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -109,3 +109,6 @@ config HAVE_CLK
 
 config HAVE_DMA_API_DEBUG
 	bool
+
+config HAVE_DEFAULT_NO_SPIN_MUTEXES
+	bool
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dcb667c..2eca5fe 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -82,6 +82,7 @@ config S390
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_FUNCTION_TRACER
+	select HAVE_DEFAULT_NO_SPIN_MUTEXES
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
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
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 5d79781..507cf2b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -148,7 +148,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES) && \
+    !defined(CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES)
 	/*
 	 * Optimistic spinning.
 	 *
