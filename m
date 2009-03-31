Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZCaQzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZCaQzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZCaQzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:55:04 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:38289 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZCaQzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:55:01 -0400
Date: Tue, 31 Mar 2009 18:54:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090331185431.72ff1707@skybase>
In-Reply-To: <49CA32F6.2030408@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	<20090316190132.7965a49a@skybase>
	<49C300D8.5080204@kernel.org>
	<49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
	<20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 22:34:46 +0900
Tejun Heo <tj@kernel.org> wrote:

> Martin Schwidefsky wrote:
> > On Wed, 25 Mar 2009 22:21:03 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> Martin Schwidefsky wrote:
> >>>> Martin's original patch should do the trick although it would be
> >>>> slower for static symbols.  I'll merge it and post the tree.
> >>> No, my original patch doesn't work. It will break modules that use
> >>> static per-cpu variables.
> >> Oops.  Even with the default offset adding macros?  Heh... I think it
> >> would be best to wait for your fix then.
> > 
> > We could use HAVE_LEGACY_PER_CPU_AREA for the time being. 
> 
> Eh...  The thing is that the patch kills the legacy default allocator.
> We can move it into arch/s390 for the time being but it would be
> simpler if the constant_p thing or something else could work.  :-) Do
> you think figuring out how to fix it will take long?

I got the dynamic cpu allocator to work with the patch below. Anybody
with an objection against the SHIFT_PERCPU_VAR macro ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

---
Subject: [PATCH] introduce SHIFT_PERCPU_VAR

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Introduce SHIFT_PERCPU_VAR to make it possible to use the dynamic
percpu allocator on s390. The background for the new macro is the
addressing limitation on s390 for local variables in an elf object.

Every variable that the compiler considers to be local to an elf object
has to be addressable with an load-address-relative-long (LARL)
instruction, which has a range of +-4GB. A static per-cpu variable is
allocated in the .data.percpu section. If such a variable is defined in
a module the module loader will relocate this section to some place
which will be outside the +-4GB range. So far we used SHIFT_PERCPU_PTR
to add an indirection over the global offset table via a GOTENT
reloction. The GOT for the module is created by the module loader
and is located right next to the module code. That corrects the problem
with the LARL addressability but GOTENT works only for symbols, not for
dynamically allocated per-cpu memory. If the dynamic percpu allocator
is used on s390 the build breaks.

In order to fix this we need to distinguish the dynamically allocated
per-cpu objects from the per-cpu variables. For the former we can
use a simple RELOC_HIDE, for the later we have to use our GOTENT
indirection.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/alpha/include/asm/percpu.h |    2 ++
 arch/s390/Kconfig               |    3 ---
 arch/s390/include/asm/percpu.h  |   12 ++++++------
 include/asm-generic/percpu.h    |   10 +++++++---
 4 files changed, 15 insertions(+), 12 deletions(-)

diff -urpN linux-next/arch/alpha/include/asm/percpu.h linux-s390/arch/alpha/include/asm/percpu.h
--- linux-next/arch/alpha/include/asm/percpu.h	2009-03-31 15:55:03.000000000 +0200
+++ linux-s390/arch/alpha/include/asm/percpu.h	2009-03-31 15:55:46.000000000 +0200
@@ -47,6 +47,8 @@ extern unsigned long __per_cpu_offset[NR
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
+#define SHIFT_PERCPU_VAR(var, offset) SHIFT_PERCPU_PTR(var, offset)
+
 #define PER_CPU_ATTRIBUTES	__used
 
 #endif /* MODULE */
diff -urpN linux-next/arch/s390/include/asm/percpu.h linux-s390/arch/s390/include/asm/percpu.h
--- linux-next/arch/s390/include/asm/percpu.h	2009-03-31 15:55:03.000000000 +0200
+++ linux-s390/arch/s390/include/asm/percpu.h	2009-03-31 15:55:46.000000000 +0200
@@ -13,19 +13,19 @@
  */
 #if defined(__s390x__) && defined(MODULE)
 
-#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
+#define SHIFT_PERCPU_VAR(ptr,offset) (({		\
 	extern int simple_identifier_##var(void);	\
 	unsigned long *__ptr;				\
-	asm ( "larl %0, %1@GOTENT"		\
+	asm ( "larl %0, %1@GOTENT"			\
 	    : "=a" (__ptr) : "X" (ptr) );		\
 	(typeof(ptr))((*__ptr) + (offset));	}))
 
 #else
 
-#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
-	extern int simple_identifier_##var(void);		\
-	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
+#define SHIFT_PERCPU_VAR(ptr, offset) (({		\
+	extern int simple_identifier_##var(void);	\
+	unsigned long __ptr;				\
+	asm ( "" : "=a" (__ptr) : "0" (ptr) );		\
 	(typeof(ptr)) (__ptr + (offset)); }))
 
 #endif
diff -urpN linux-next/arch/s390/Kconfig linux-s390/arch/s390/Kconfig
--- linux-next/arch/s390/Kconfig	2009-03-31 15:55:10.000000000 +0200
+++ linux-s390/arch/s390/Kconfig	2009-03-31 15:55:36.000000000 +0200
@@ -72,9 +72,6 @@ config PGSTE
 config VIRT_CPU_ACCOUNTING
 	def_bool y
 
-config HAVE_LEGACY_PER_CPU_AREA
-	def_bool y
-
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff -urpN linux-next/include/asm-generic/percpu.h linux-s390/include/asm-generic/percpu.h
--- linux-next/include/asm-generic/percpu.h	2009-03-31 15:55:03.000000000 +0200
+++ linux-s390/include/asm-generic/percpu.h	2009-03-31 15:55:46.000000000 +0200
@@ -48,17 +48,21 @@ extern unsigned long __per_cpu_offset[NR
 #define SHIFT_PERCPU_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
 #endif
 
+#ifndef SHIFT_PERCPU_VAR
+#define SHIFT_PERCPU_VAR(__p, __offset) RELOC_HIDE((__p), (__offset))
+#endif
+
 /*
  * A percpu variable may point to a discarded regions. The following are
  * established ways to produce a usable pointer from the percpu variable
  * offset.
  */
 #define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+	(*SHIFT_PERCPU_VAR(&per_cpu_var(var), per_cpu_offset(cpu)))
 #define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
+	(*SHIFT_PERCPU_VAR(&per_cpu_var(var), my_cpu_offset))
 #define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
+	(*SHIFT_PERCPU_VAR(&per_cpu_var(var), __my_cpu_offset))
 
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
