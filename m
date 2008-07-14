Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYGNVcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYGNVcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbYGNVcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:32:47 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:28739 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbYGNVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:32:47 -0400
Date: Mon, 14 Jul 2008 23:32:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] core/stacktrace changes for v2.6.27
Message-ID: <20080714213232.GB6705@osiris.boeblingen.de.ibm.com>
References: <20080714144420.GA21632@elte.hu> <20080715013543.398c83d9.sfr@canb.auug.org.au> <20080714155617.GA3320@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714155617.GA3320@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 05:56:17PM +0200, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Ingo,
> > 
> > On Mon, 14 Jul 2008 16:44:20 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > Please pull the latest core/stacktrace git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/stacktrace
> > 
> > This presumably needs the patch I posted today against linux-next that 
> > fixes the powerpc allmodconfig build.
> 
> hm - but you sent that against the generic-ipi tree :-)
> 
> but i agree - the patch is below, Linus please apply.
> 
> 	Ingo
> 
> ---------------->
> commit 7798ed0f57b4d137e660fbf5be1e1528e40f89ac
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Jul 14 19:55:03 2008 +1000
> 
>     generic-ipi: powerpc/generic-ipi tree build failure
>     
>     Today's linux-next build (powerpc allmodconfig) failed like this:
>     
>     ERROR: ".save_stack_trace" [tests/backtracetest.ko] undefined!
>     
>     But save_stack_trace is exported in arch/powerpc/kernel/stacktrace.c
>     
>     I couldn't figure it out until I noticed these earlier warnings:
>     
>     arch/powerpc/kernel/stacktrace.c:47: warning: data definition has no type or storage class
>     arch/powerpc/kernel/stacktrace.c:47: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
>     arch/powerpc/kernel/stacktrace.c:47: warning: parameter names (without types) in function declaration
>     
>     I applied the patch below.
>     
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>     Cc: Paul Mackerras <paulus@samba.org>
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Cc: <linuxppc-dev@ozlabs.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/powerpc/kernel/stacktrace.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
> index 9861f17..3cf0d94 100644
> --- a/arch/powerpc/kernel/stacktrace.c
> +++ b/arch/powerpc/kernel/stacktrace.c
> @@ -12,6 +12,7 @@
> 
>  #include <linux/sched.h>
>  #include <linux/stacktrace.h>
> +#include <linux/module.h>
>  #include <asm/ptrace.h>

s390 and probably other architectures will suffer from the same compile bug.
I sent you the patch below against linux-next to fix this problem a couple of
days ago:
http://marc.info/?l=linux-next&m=121577286607960&w=2

Subject: [PATCH] Add module.h include to stacktrace.c.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes this:

  CC      arch/s390/kernel/stacktrace.o
arch/s390/kernel/stacktrace.c:84: warning: data definition has no type or storage class
arch/s390/kernel/stacktrace.c:84: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/s390/kernel/stacktrace.c:84: warning: parameter names (without types) in function declaration
arch/s390/kernel/stacktrace.c:97: warning: data definition has no type or storage class
arch/s390/kernel/stacktrace.c:97: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
arch/s390/kernel/stacktrace.c:97: warning: parameter names (without types) in function declaration

caused by "stacktrace: export save_stack_trace[_tsk]"

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/avr32/kernel/stacktrace.c   |    1 +
 arch/mips/kernel/stacktrace.c    |    1 +
 arch/powerpc/kernel/stacktrace.c |    1 +
 arch/s390/kernel/stacktrace.c    |    1 +
 arch/sh/kernel/stacktrace.c      |    1 +
 5 files changed, 5 insertions(+)

Index: linux-next/arch/s390/kernel/stacktrace.c
===================================================================
--- linux-next.orig/arch/s390/kernel/stacktrace.c
+++ linux-next/arch/s390/kernel/stacktrace.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/kallsyms.h>
+#include <linux/module.h>
 
 static unsigned long save_context_stack(struct stack_trace *trace,
 					unsigned long sp,
Index: linux-next/arch/avr32/kernel/stacktrace.c
===================================================================
--- linux-next.orig/arch/avr32/kernel/stacktrace.c
+++ linux-next/arch/avr32/kernel/stacktrace.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/thread_info.h>
+#include <linux/module.h>
 
 register unsigned long current_frame_pointer asm("r7");
 
Index: linux-next/arch/mips/kernel/stacktrace.c
===================================================================
--- linux-next.orig/arch/mips/kernel/stacktrace.c
+++ linux-next/arch/mips/kernel/stacktrace.c
@@ -7,6 +7,7 @@
  */
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
+#include <linux/module.h
 #include <asm/stacktrace.h>
 
 /*
Index: linux-next/arch/powerpc/kernel/stacktrace.c
===================================================================
--- linux-next.orig/arch/powerpc/kernel/stacktrace.c
+++ linux-next/arch/powerpc/kernel/stacktrace.c
@@ -12,6 +12,7 @@
 
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
+#include <linux/module.h>
 #include <asm/ptrace.h>
 
 /*
Index: linux-next/arch/sh/kernel/stacktrace.c
===================================================================
--- linux-next.orig/arch/sh/kernel/stacktrace.c
+++ linux-next/arch/sh/kernel/stacktrace.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 #include <linux/thread_info.h>
+#include <linux/module.h>
 #include <asm/ptrace.h>
 
 /*
