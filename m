Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbZDGQJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbZDGQJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760227AbZDGQJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:09:35 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:58889 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760221AbZDGQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:09:34 -0400
Date: Tue, 7 Apr 2009 20:09:41 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
	percpu allocator
Message-ID: <20090407160940.GA31956@jurassic.park.msu.ru>
References: <49D2B04D.4070604@kernel.org> <20090401101054.0a4b187d@skybase> <49D3231D.2040403@kernel.org> <20090401103257.12c2517e@skybase> <49D32B96.3060102@kernel.org> <20090401130731.785714c5@skybase> <49D41B79.60708@kernel.org> <20090402072418.GA14071@jurassic.park.msu.ru> <20090402131341.08ef4184@skybase> <49D558CE.9090608@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D558CE.9090608@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 09:31:10AM +0900, Tejun Heo wrote:
> Can STATIC_DEFINE_PER_CPU() be made to work?  It's not pretty but if
> that's the only sensible way to reach uniform static/dynamic handling,
> I suppose we can ignore the slight ugliness.

Well, I've got a workaround that has zero impact on common code (patch
appended).

The idea is that we can effectively discard the "static" specifier
by declaring a dummy variable right before actual per-cpu variable
definition:

#define DEFINE_PER_CPU_SECTION(type, name, section)			\
	__attribute__((__section__(".garbage"), __unused__))		\
		char __dummy__##name;					\
	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
		__weak __typeof__(type) per_cpu__##name

In the "static" case the __dummy__ thing gets optimized away completely,
so the only downside is that the modules with public per-cpu variables
will have unused symbols in the .garbage section.
It's certainly possible to discard that section in the build process
(with objcopy or linker script), but right now there are only three
modules which end up with non-empty .garbage section, namely oprofile,
fs/xfs and net/rds. So I wouldn't bother about it.

That macro should work for s390 as well, except that maybe Martin
doesn't need the "weak" attribute.

Ivan.

---
alpha: fix for static percpu variables

Work around 32-bit GP-relative addressing of local per-cpu variables
in modules. This is needed to make the dynamic per-cpu allocator
work on alpha.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/percpu.h |   74 ++++++---------------------------------
 include/linux/percpu.h          |    2 +
 2 files changed, 13 insertions(+), 63 deletions(-)

diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 3495e8e..28f2fbb 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -1,78 +1,26 @@
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
+	__attribute__((__section__(".garbage"), __unused__))		\
+		char __dummy__##name;					\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+		__weak __typeof__(type) per_cpu__##name
 
-#endif /* SMP */
+#endif /* MODULE && SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
+#include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
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
