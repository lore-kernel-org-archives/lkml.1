Return-Path: <linux-kernel-owner+w=401wt.eu-S937772AbZDJSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937772AbZDJSFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZDJSFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:05:17 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53616 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZDJSFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:05:16 -0400
Date: Fri, 10 Apr 2009 22:05:32 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unbreak alpha percpu
Message-ID: <20090410180532.GA4419@jurassic.park.msu.ru>
References: <20090410151224.GM26366@ZenIV.linux.org.uk> <20090410154704.GN26366@ZenIV.linux.org.uk> <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain> <20090410165030.GQ26366@ZenIV.linux.org.uk> <20090410170507.GR26366@ZenIV.linux.org.uk> <20090410171415.GA6033@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410171415.GA6033@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:14:15PM +0100, Al Viro wrote:
> ... and the reason we didn't step into that one on alpha et.al. is that it
> doesn't have HAVE_DYNAMIC_PER_CPU_AREA - only x86 does.  It's *still*
> fixable, but we need a different primitive for that one.

NACKed, better patch appended, which makes &per_cpu__foo a real pointer
without asm hacks.

Actually, all of this has been discussed on lkml; here is the latest
variant that makes everybody more or less happy, at least there are
no objections from percpu folks and Martin (similar fix should work
for s390 as well).

Ivan.

---
alpha: fix for static percpu variables

Work around 32-bit GP-relative addressing of local per-cpu variables
in modules. This is needed to make the dynamic per-cpu allocator
work on alpha.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/Makefile             |    1 +
 arch/alpha/include/asm/percpu.h |   76 +++++++--------------------------------
 arch/alpha/kernel/module.lds    |    3 ++
 include/linux/percpu.h          |    2 +
 4 files changed, 19 insertions(+), 63 deletions(-)

diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
index 4759fe7..d7b3a3f 100644
--- a/arch/alpha/Makefile
+++ b/arch/alpha/Makefile
@@ -11,6 +11,7 @@
 NM := $(NM) -B
 
 LDFLAGS_vmlinux	:= -static -N #-relax
+LDFLAGS_MODULE += -T $(srctree)/arch/alpha/kernel/module.lds
 CHECKFLAGS	+= -D__alpha__ -m64
 cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
 cflags-y	+= $(call cc-option, -fno-jump-tables)
diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 3495e8e..d49b8d4 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -1,78 +1,28 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
 #include <linux/compiler.h>
-#include <linux/threads.h>
 
-/*
- * Determine the real variable name from the name visible in the
- * kernel sources.
- */
-#define per_cpu_var(var) per_cpu__##var
-
-#ifdef CONFIG_SMP
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
+#if defined(MODULE) && defined(CONFIG_SMP)
 /*
  * To calculate addresses of locally defined variables, GCC uses 32-bit
  * displacement from the GP. Which doesn't work for per cpu variables in
  * modules, as an offset to the kernel per cpu area is way above 4G.
  *
  * This forces allocation of a GOT entry for per cpu variable using
- * ldq instruction with a 'literal' relocation.
+ * "weak" attribute (as the compiler must assume an external reference);
+ * to make this work we have to neutralize possible "static" storage
+ * class specifier with a dummy variable.
  */
-#define SHIFT_PERCPU_PTR(var, offset) ({		\
-	extern int simple_identifier_##var(void);	\
-	unsigned long __ptr, tmp_gp;			\
-	asm (  "br	%1, 1f		  	      \n\
-	1:	ldgp	%1, 0(%1)	    	      \n\
-		ldq %0, per_cpu__" #var"(%1)\t!literal"		\
-		: "=&r"(__ptr), "=&r"(tmp_gp));		\
-	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
-
-#define PER_CPU_ATTRIBUTES	__used
-
-#endif /* MODULE */
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
+#define DEFINE_PER_CPU_SECTION(type, name, section)			\
+	__attribute__((__section__(".discard"), __unused__))		\
+		char __dummy__##name;					\
+	__attribute__((__section__(".discard")))				\
+		char __per_cpu_multiple_def__##name;			\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+		__weak __typeof__(type) per_cpu__##name
 
-#endif /* SMP */
+#endif /* MODULE && SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
+#include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
diff --git a/arch/alpha/kernel/module.lds b/arch/alpha/kernel/module.lds
new file mode 100644
index 0000000..bffc6d3
--- /dev/null
+++ b/arch/alpha/kernel/module.lds
@@ -0,0 +1,3 @@
+SECTIONS {
+  /DISCARD/ : { *(.discard) }
+}
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ee5615d..865f749 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -33,9 +33,11 @@
 
 #endif
 
+#ifndef DEFINE_PER_CPU_SECTION
 #define DEFINE_PER_CPU_SECTION(type, name, section)			\
 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+#endif
 
 #define DEFINE_PER_CPU(type, name)					\
 	DEFINE_PER_CPU_SECTION(type, name, "")
