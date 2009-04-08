Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbZDHORX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbZDHORX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933050AbZDHON0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:13:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbZDHONX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:13:23 -0400
Date: Wed, 8 Apr 2009 16:12:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] x86: remove dupilcated #include
Message-ID: <20090408141228.GD12931@elte.hu>
References: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com> <20090408122121.GB18581@elte.hu> <20090408135803.GA21624@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408135803.GA21624@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Apr 08, 2009 at 02:21:21PM +0200, Ingo Molnar wrote:
> > 
> > * Huang Weiyi <weiyi.huang@gmail.com> wrote:
> > 
> > > Remove dupilcated #include in arch/x86/kernel/dumpstack.c.
> > > 
> > > Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> > > ---
> > >  arch/x86/kernel/dumpstack.c |    1 -
> > >  1 files changed, 0 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> > > index 95ea5fa..6d7966d 100644
> > > --- a/arch/x86/kernel/dumpstack.c
> > > +++ b/arch/x86/kernel/dumpstack.c
> > > @@ -15,7 +15,6 @@
> > >  #include <linux/bug.h>
> > >  #include <linux/nmi.h>
> > >  #include <linux/sysfs.h>
> > > -#include <linux/ftrace.h>
> > >  
> > >  #include <asm/stacktrace.h>
> > 
> > Many of those include lines are probably unnecessary. Instead of 
> > these trivial patches causing churn, would you be interested in 
> > doing a comprehensive search to eliminate all the unused ones?
> > That would be a real step forward. (and this holds for your 
> > other patches in this series too.)
> > 
> > The include files section of fault.c might be a good template to 
> > use:
> > 
> > #include <linux/magic.h>		/* STACK_END_MAGIC		*/
> > #include <linux/sched.h>		/* test_thread_flag(), ...	*/
> > #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
> > #include <linux/module.h>		/* search_exception_table	*/
> > #include <linux/bootmem.h>		/* max_low_pfn			*/
> > #include <linux/kprobes.h>		/* __kprobes, ...		*/
> > #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
> > #include <linux/perf_counter.h>		/* perf_swcounter_*(), ...	*/
> > 
> > #include <asm/traps.h>			/* dotraplinkage, ...		*/
> > #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
> > #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
> > 
> > I was able to eliminate half of all include file lines there.
> 
> I assume you are aware that when you minimize the # of include 
> file in the various .c files, then you implicitly add dependency 
> on the includes the individual .h files have.

Yes. Look at the commit -tip that does the above change (also 
attached below):

  a2bcd47: x86/mm: further cleanups of fault.c's include file section

that commit uncovered a masked-until-then dependency bug in one of 
the x86 include files.

More automation to discover include file dependency bugs would be 
nice though, it's hard to get these things right and it all needs a 
strong testing infrastructure.

	Ingo

----------------->
>From a2bcd4731f77cb77ae4b5e4a3d7f5471cf346c33 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 29 Mar 2009 23:47:48 +0200
Subject: [PATCH] x86/mm: further cleanups of fault.c's include file section

Impact: cleanup

Eliminate more than 20 unnecessary #include lines in fault.c

Also fix include file dependency bug in asm/traps.h. (this was
masked before, by implicit inclusion)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <tip-56aea8468746e673a4bf50b6a13d97b2d1cbe1e8@git.kernel.org>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/traps.h |    1 +
 arch/x86/mm/fault.c          |   42 +++++++++---------------------------------
 2 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0d53425..37fb07a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_TRAPS_H
 
 #include <asm/debugreg.h>
+#include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
 #ifdef CONFIG_X86_32
 #define dotraplinkage
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a03b727..24a36a6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -3,40 +3,16 @@
  *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
  *  Copyright (C) 2008-2009, Red Hat Inc., Ingo Molnar
  */
-#include <linux/interrupt.h>
-#include <linux/mmiotrace.h>
-#include <linux/bootmem.h>
-#include <linux/compiler.h>
-#include <linux/highmem.h>
-#include <linux/kprobes.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
-#include <linux/vt_kern.h>
-#include <linux/signal.h>
-#include <linux/kernel.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-#include <linux/errno.h>
-#include <linux/magic.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/mman.h>
-#include <linux/tty.h>
-#include <linux/smp.h>
-#include <linux/mm.h>
-
-#include <asm-generic/sections.h>
-
-#include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
-#include <asm/segment.h>
-#include <asm/system.h>
-#include <asm/proto.h>
-#include <asm/traps.h>
-#include <asm/desc.h>
+#include <linux/magic.h>		/* STACK_END_MAGIC		*/
+#include <linux/sched.h>		/* test_thread_flag(), ...	*/
+#include <linux/kdebug.h>		/* oops_begin/end, ...		*/
+#include <linux/module.h>		/* search_exception_table	*/
+#include <linux/bootmem.h>		/* max_low_pfn			*/
+#include <linux/kprobes.h>		/* __kprobes, ...		*/
+#include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
+
+#include <asm/traps.h>			/* dotraplinkage, ...		*/
+#include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 
 /*
  * Page fault error code bits:
