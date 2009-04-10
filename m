Return-Path: <linux-kernel-owner+w=401wt.eu-S938964AbZDJRRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938964AbZDJRRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938583AbZDJRQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:16:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57759 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938784AbZDJRP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:15:59 -0400
Date: Fri, 10 Apr 2009 18:14:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
Message-ID: <20090410171415.GA6033@ZenIV.linux.org.uk>
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410170507.GR26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:05:07PM +0100, Al Viro wrote:
> On Fri, Apr 10, 2009 at 05:50:30PM +0100, Al Viro wrote:
> > On Fri, Apr 10, 2009 at 09:21:08AM -0700, Linus Torvalds wrote:
> > > 
> > > Hmm. I certainly personally _much_ prefer this version.
> > > 
> > > It looks like this actually simplifies things for S390 too (no more 
> > > simple_identifier_##var games), and generally just looks better. And 
> > > seeing that the S390 special case is no longer S390-specific is also a 
> > > good sign, imho.
> > 
> > simple_identifier_##var has been debris from back when Ingo forced
> > s390 to use asm-generic/percpu.h; if you look at it, you'll see that
> > a) it hadn't worked (look at the argument list carefully) and
> > b) get_cpu_var() has the working version anyway
> > 
> > Less obvious part is that if it actually *would* work, we'd be screwed -
> > unlike get_cpu_var() this sucker is called for things that are not
> > simple variables; didn't happen for alpha, but did for s390.
> > 
> > IOW, that's just an old piece of junk that got removed now.
> 
> Fsck...  It breaks per_cpu_ptr() :-/  OK, back to square one, then...

... and the reason we didn't step into that one on alpha et.al. is that it
doesn't have HAVE_DYNAMIC_PER_CPU_AREA - only x86 does.  It's *still*
fixable, but we need a different primitive for that one.

diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 3495e8e..1c52a2d 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -3,33 +3,8 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
-/*
- * Determine the real variable name from the name visible in the
- * kernel sources.
- */
-#define per_cpu_var(var) per_cpu__##var
-
 #ifdef CONFIG_SMP
-
-/*
- * per_cpu_offset() is the offset that has to be added to a
- * percpu variable to get to the instance for a certain processor.
- */
-extern unsigned long __per_cpu_offset[NR_CPUS];
-
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
-#ifdef CONFIG_DEBUG_PREEMPT
-#define my_cpu_offset per_cpu_offset(smp_processor_id())
-#else
-#define my_cpu_offset __my_cpu_offset
-#endif
-
-#ifndef MODULE
-#define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
-#define PER_CPU_ATTRIBUTES
-#else
+#ifdef MODULE
 /*
  * To calculate addresses of locally defined variables, GCC uses 32-bit
  * displacement from the GP. Which doesn't work for per cpu variables in
@@ -39,40 +14,15 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
  * ldq instruction with a 'literal' relocation.
  */
 #define SHIFT_PERCPU_PTR(var, offset) ({		\
-	extern int simple_identifier_##var(void);	\
 	unsigned long __ptr, tmp_gp;			\
 	asm (  "br	%1, 1f		  	      \n\
 	1:	ldgp	%1, 0(%1)	    	      \n\
 		ldq %0, per_cpu__" #var"(%1)\t!literal"		\
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
-
-#define PER_CPU_ATTRIBUTES	__used
-
 #endif /* MODULE */
-
-/*
- * A percpu variable may point to a discarded regions. The following are
- * established ways to produce a usable pointer from the percpu variable
- * offset.
- */
-#define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(var, per_cpu_offset(cpu)))
-#define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(var, my_cpu_offset))
-#define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(var, __my_cpu_offset))
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)		(*((void)(cpu), &per_cpu_var(var)))
-#define __get_cpu_var(var)		per_cpu_var(var)
-#define __raw_get_cpu_var(var)		per_cpu_var(var)
-
-#define PER_CPU_ATTRIBUTES
-
 #endif /* SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
+#include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 408d60b..6a71d73 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -13,20 +13,18 @@
  */
 #if defined(__s390x__) && defined(MODULE)
 
-#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
-	extern int simple_identifier_##var(void);	\
+#define SHIFT_PERCPU_PTR(var,offset) (({			\
 	unsigned long *__ptr;				\
 	asm ( "larl %0, %1@GOTENT"		\
-	    : "=a" (__ptr) : "X" (ptr) );		\
-	(typeof(ptr))((*__ptr) + (offset));	}))
+	    : "=a" (__ptr) : "X" (&per_cpu_var(var)) );		\
+	(typeof(&per_cpu_var(var)))((*__ptr) + (offset));	}))
 
 #else
 
-#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
-	extern int simple_identifier_##var(void);		\
+#define SHIFT_PERCPU_PTR(var, offset) (({				\
 	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
-	(typeof(ptr)) (__ptr + (offset)); }))
+	asm ( "" : "=a" (__ptr) : "0" (&per_cpu_var(var)) );			\
+	(typeof(&per_cpu_var(var))) (__ptr + (offset)); }))
 
 #endif
 
diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index aee103b..5ff94d2 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -202,4 +202,6 @@ DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
 #endif	/* !CONFIG_SMP */
 
+#define PERCPU_PTR RELOC_HIDE
+
 #endif /* _ASM_X86_PERCPU_H */
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 00f45ff..4543078 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -42,10 +42,10 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 /*
  * Add a offset to a pointer but keep the pointer as is.
  *
- * Only S390 provides its own means of moving the pointer.
+ * Only S390 and Alpha provide their own means of moving the pointer.
  */
 #ifndef SHIFT_PERCPU_PTR
-#define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+#define SHIFT_PERCPU_PTR(__v, __offset)	RELOC_HIDE((&per_cpu_var(__v)), (__offset))
 #endif
 
 /*
@@ -54,11 +54,11 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
  * offset.
  */
 #define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+	(*SHIFT_PERCPU_PTR(var, per_cpu_offset(cpu)))
 #define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
+	(*SHIFT_PERCPU_PTR(var, my_cpu_offset))
 #define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
+	(*SHIFT_PERCPU_PTR(var, __my_cpu_offset))
 
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ee5615d..11a8a11 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -120,7 +120,7 @@ extern ssize_t __init pcpu_embed_first_chunk(
  * dynamically allocated. Non-atomic access to the current CPU's
  * version should probably be combined with get_cpu()/put_cpu().
  */
-#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
+#define per_cpu_ptr(ptr, cpu)	PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
 extern void *__alloc_reserved_percpu(size_t size, size_t align);
 
