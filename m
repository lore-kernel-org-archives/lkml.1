Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYKEVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYKEVYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYKEVYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:24:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbYKEVYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:24:45 -0500
Date: Wed, 5 Nov 2008 13:24:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: cl@linux-foundation.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: Git next: Second stage of cpu_alloc patches
Message-Id: <20081105132434.dd359815.akpm@linux-foundation.org>
In-Reply-To: <19f34abd0811051312o1fe733d8g4d0075aa7eefa964@mail.gmail.com>
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
	<20081104195205.fe1bf62b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811050753120.11867@quilx.com>
	<20081105082754.2d41f0d1.akpm@linux-foundation.org>
	<19f34abd0811051312o1fe733d8g4d0075aa7eefa964@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 22:12:04 +0100
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> On Wed, Nov 5, 2008 at 5:27 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > We need to get alpha sorted out too.  Frankly, if we can't get anyone to
> > review/test/ack the alpha genirq conversion then I'd say merge it
> > anyway.  I'll make sure that it at least compiles.
> 
> Sounds like a bad strategy. What are these patches you're talking
> about, and where can I find them?

The cpu_alloc patches broke the alpha build.  The proposed fix is below.

> I mean, isn't "merge anyway" the same as admitting defeat? I thought
> we were going for 100% "review coverage".

alpha development isn't exactly proceeding at a feverish rate lately. 
No blame attached to that - the reasons are pretty obvious.  I expect
that at some stage we'll remove it altogether.

In the meanwhile if alpha (or anything similar) gets in the way of core
kernel development, all we can do is best-effort maintenance of it
while hoping it didn't break too badly.  We cannot stop core kernel
development.




From: Christoph Lameter <cl@linux-foundation.org>

The percpu support for alpha currently expects a percpu variable to be
passed to SHIFT_PERCPU_PTR.  However, SHIFT_PERCPU_PTR takes a pointer
and not a variable.  This breaks code that uses SHIFT_PERCPU_PTR on a
pointer.

Simply switch alpha to use generic cpu.

The purpose of the special percpu code seems to be optmization.  That
could be done by modifying the per_cpu_var() (and related) macros which
indeed take a variable as a parameter.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/percpu.h |   77 ------------------------------
 1 file changed, 1 insertion(+), 76 deletions(-)

diff -puN arch/alpha/include/asm/percpu.h~alpha-use-generic-percpu-support arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h~alpha-use-generic-percpu-support
+++ a/arch/alpha/include/asm/percpu.h
@@ -1,79 +1,4 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
-#include <linux/compiler.h>
-#include <linux/threads.h>
-
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
-/*
- * To calculate addresses of locally defined variables, GCC uses 32-bit
- * displacement from the GP. Which doesn't work for per cpu variables in
- * modules, as an offset to the kernel per cpu area is way above 4G.
- *
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
-#define per_cpu_offset(x) 0
-
-#define PER_CPU_ATTRIBUTES
-
-#endif /* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
-
+#include <asm-generic/percpu.h>
 #endif /* __ALPHA_PERCPU_H */
_

