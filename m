Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZFAJBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZFAJBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZFAJBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:01:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:36542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZFAJB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:01:29 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] alpha: switch to dynamic percpu allocator
Date: Mon,  1 Jun 2009 17:58:27 +0900
Message-Id: <1243846708-805-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243846708-805-1-git-send-email-tj@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 08:58:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alpha implements custom SHIFT_PERCPU_PTR for modules because percpu
area can be located far away from the 4G area where the module text is
located.  The custom SHIFT_PERCPU_PTR forces GOT usage using ldq
instruction with literal relocation; however, the relocation can't be
used with dynamically allocatd percpu variables.  Fortunately, similar
result can be achieved using weak attribute on percpu variable
declarations and definitions, which is allowed with previous changes.

This patch makes alpha use weak attribute instead and switch to
dynamic percpu allocator.

asm/tlbflush.h was getting linux/sched.h via asm/percpu.h which no
longer needs it.  Include linux/sched.h directly in asm/tlbflush.h.

Compile tested.  Generation of litereal relocation verified.

This patch is based on Ivan Kokshaysky's alpha percpu patch.

[ Impact: use dynamic percpu allocator ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig                |    3 -
 arch/alpha/include/asm/percpu.h   |   96 ++++---------------------------------
 arch/alpha/include/asm/tlbflush.h |    1 +
 3 files changed, 10 insertions(+), 90 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 05d8640..9fb8aae 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -70,9 +70,6 @@ config AUTO_IRQ_AFFINITY
 	depends on SMP
 	default y
 
-config HAVE_LEGACY_PER_CPU_AREA
-	def_bool y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 7f0a9c4..2b0c79c 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -1,97 +1,19 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
 
-#include <linux/compiler.h>
-#include <linux/threads.h>
-#include <linux/percpu-defs.h>
-
 /*
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
-#else
-/*
- * To calculate addresses of locally defined variables, GCC uses 32-bit
- * displacement from the GP. Which doesn't work for per cpu variables in
- * modules, as an offset to the kernel per cpu area is way above 4G.
+ * To calculate addresses of locally defined variables, GCC uses
+ * 32-bit displacement from the GP. Which doesn't work for per cpu
+ * variables in modules, as an offset to the kernel per cpu area is
+ * way above 4G.
  *
- * This forces allocation of a GOT entry for per cpu variable using
- * ldq instruction with a 'literal' relocation.
- */
-#define SHIFT_PERCPU_PTR(var, offset) ({		\
-	extern int simple_identifier_##var(void);	\
-	unsigned long __ptr, tmp_gp;			\
-	asm (  "br	%1, 1f		  	      \n\
-	1:	ldgp	%1, 0(%1)	    	      \n\
-		ldq %0, per_cpu__" #var"(%1)\t!literal"		\
-		: "=&r"(__ptr), "=&r"(tmp_gp));		\
-	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
-
-#endif /* MODULE */
-
-/*
- * A percpu variable may point to a discarded regions. The following are
- * established ways to produce a usable pointer from the percpu variable
- * offset.
+ * Use "weak" attribute to force the compiler to generate external
+ * reference.
  */
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
-#endif /* SMP */
-
-#ifdef CONFIG_SMP
-#define PER_CPU_BASE_SECTION ".data.percpu"
-#else
-#define PER_CPU_BASE_SECTION ".data"
-#endif
-
-#ifdef CONFIG_SMP
-
-#ifdef MODULE
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#else
-#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
-#endif
-#define PER_CPU_FIRST_SECTION ".first"
-
-#else
-
-#define PER_CPU_SHARED_ALIGNED_SECTION ""
-#define PER_CPU_FIRST_SECTION ""
-
+#if defined(MODULE) && defined(CONFIG_SMP)
+#define PER_CPU_ATTRIBUTES	__attribute__((weak))
 #endif
 
-#define PER_CPU_ATTRIBUTES
+#include <asm-generic/percpu.h>
 
 #endif /* __ALPHA_PERCPU_H */
diff --git a/arch/alpha/include/asm/tlbflush.h b/arch/alpha/include/asm/tlbflush.h
index 9d87aaa..e89e0c2 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -2,6 +2,7 @@
 #define _ALPHA_TLBFLUSH_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/compiler.h>
 #include <asm/pgalloc.h>
 
-- 
1.6.0.2

