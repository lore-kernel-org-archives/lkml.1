Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZDJPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZDJPrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZDJPrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:47:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44759 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZDJPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:47:06 -0400
Date: Fri, 10 Apr 2009 16:47:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unbreak alpha percpu
Message-ID: <20090410154704.GN26366@ZenIV.linux.org.uk>
References: <20090410151224.GM26366@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410151224.GM26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 04:12:24PM +0100, Al Viro wrote:
> asm-generic/percpu.h is *NOT* included by every asm/percpu.h out there.
> Namely, alpha can't use it since it needs the var name in
> SHIFT_PERCPU_PTR - &per_cpu_var(var) won't do at all.  So adding stuff
> to asm-generic/percpu.h and expecting it to be picked by everything
> is not going to work.
> 
> Frankly, I'd rather have SHIFT_PERCPU_PTR() calling conventions changed,
> but for now the patch below will do.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Alternative patch (changing SHIFT_PERCPU_PTR() arguments and switching
alpha to asm-generic/percpu.h) would be this (only build-tested, though):

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
 
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 00f45ff..7463700 100644
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
+#define SHIFT_PERCPU_PTR(__v, __offset)	RELOC_HIDE(&per_cpu_var(__v), (__offset))
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
