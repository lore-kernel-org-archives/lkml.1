Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYABEnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYABEnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYABEnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:43:41 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42564 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbYABEnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:43:40 -0500
Date: Wed, 2 Jan 2008 10:13:53 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Quentin Barnes <qbarnes@gmail.com>, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] [CFT] Code clarification patch to Kprobes arch code
Message-ID: <20080102044353.GA7027@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <b70efdcb0712310929y1bf871eah2adb531a7ed89673@mail.gmail.com> <20080101151943.GE4434@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101151943.GE4434@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 04:19:43PM +0100, Ingo Molnar wrote:
> 
> * Quentin Barnes <qbarnes@gmail.com> wrote:
> 
> > Since people are discussing some x86 Kprobes code cleanup, I thought I 
> > would contribute a small change as well.  When developing the Kprobes 
> > arch code for ARM, I ran across some code found in x86 and s390 
> > Kprobes arch code which I didn't consider as good as it could be.
> > 
> > Once I figured out what the code was doing, I changed the code for ARM 
> > Kprobes to work the way I felt was more appropriate. I've tested the 
> > code this way in ARM for about a year and would like to push the same 
> > change to the other affected architectures.
> 
> thanks Quentin, it looks good to me and i've applied the x86 bit to 
> x86.git. (find the merged patch attached below)
> 
> small note:
> 
> > @@ -654,12 +655,12 @@ int __kprobes kprobe_exceptions_notify(struct
> > notifier_block *self,
> >  			ret = NOTIFY_STOP;
> 
> your email client apparently line-wrapped this portion of the patch - i 
> fixed it up manually (wasnt a big issue). Please see 
> Documentation/email-clients.txt about how to set up your email client.
> 
> 	Ingo
> 
> -------------------->
> Subject: Code clarification patch to Kprobes arch code
> From: "Quentin Barnes" <qbarnes@gmail.com>
> 
> When developing the Kprobes arch code for ARM, I ran across some code
> found in x86 and s390 Kprobes arch code which I didn't consider as
> good as it could be.
> 
> Once I figured out what the code was doing, I changed the code
> for ARM Kprobes to work the way I felt was more appropriate.
> I've tested the code this way in ARM for about a year and would
> like to push the same change to the other affected architectures.
> 
> The code in question is in kprobe_exceptions_notify() which
> does:
> ====
>           /* kprobe_running() needs smp_processor_id() */
>           preempt_disable();
>           if (kprobe_running() &&
>               kprobe_fault_handler(args->regs, args->trapnr))
>                   ret = NOTIFY_STOP;
>           preempt_enable();
> ====
> 
> For the moment, ignore the code having the preempt_disable()/
> preempt_enable() pair in it.
> 
> The problem is that kprobe_running() needs to call smp_processor_id()
> which will assert if preemption is enabled.  That sanity check by
> smp_processor_id() makes perfect sense since calling it with preemption
> enabled would return an unreliable result.
> 
> But the function kprobe_exceptions_notify() can be called from a
> context where preemption could be enabled.  If that happens, the
> assertion in smp_processor_id() happens and we're dead.  So what
> the original author did (speculation on my part!) is put in the
> preempt_disable()/preempt_enable() pair to simply defeat the check.
> 
> Once I figured out what was going on, I considered this an
> inappropriate approach.  If kprobe_exceptions_notify() is called
> from a preemptible context, we can't be in a kprobe processing
> context at that time anyways since kprobes requires preemption to
> already be disabled, so just check for preemption enabled, and if
> so, blow out before ever calling kprobe_running().  I wrote the ARM
> kprobe code like this:
> ====
>           /* To be potentially processing a kprobe fault and to
>            * trust the result from kprobe_running(), we have
>            * be non-preemptible. */
>           if (!preemptible() && kprobe_running() &&
>               kprobe_fault_handler(args->regs, args->trapnr))
>                   ret = NOTIFY_STOP;
> ====
> 
> The above code has been working fine for ARM Kprobes for a year.
> So I changed the x86 code (2.6.24-rc6) to be the same way and ran
> the Systemtap tests on that kernel.  As on ARM, Systemtap on x86
> comes up with the same test results either way, so it's a neutral
> external functional change (as expected).
> 
> This issue has been discussed previously on linux-arm-kernel and the
> Systemtap mailing lists.  Pointers to the by base for the two
> discussions:
> http://lists.arm.linux.org.uk/lurker/message/20071219.223225.1f5c2a5e.en.html
> http://sourceware.org/ml/systemtap/2007-q1/msg00251.html
> 
> Signed-off-by: Quentin Barnes <qbarnes@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Tested on x86.

Acked-by: Ananth N Mavinakayahanalli <ananth@in.ibm.com>

> ---
>  arch/x86/kernel/kprobes.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> Index: linux-x86.q/arch/x86/kernel/kprobes.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/kprobes.c
> +++ linux-x86.q/arch/x86/kernel/kprobes.c
> @@ -44,6 +44,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/hardirq.h>
>  #include <linux/preempt.h>
>  #include <linux/module.h>
>  #include <linux/kdebug.h>
> @@ -951,12 +952,14 @@ int __kprobes kprobe_exceptions_notify(s
>  			ret = NOTIFY_STOP;
>  		break;
>  	case DIE_GPF:
> -		/* kprobe_running() needs smp_processor_id() */
> -		preempt_disable();
> -		if (kprobe_running() &&
> +		/*
> +		 * To be potentially processing a kprobe fault and to
> +		 * trust the result from kprobe_running(), we have
> +		 * be non-preemptible.
> +		 */
> +		if (!preemptible() && kprobe_running() &&
>  		    kprobe_fault_handler(args->regs, args->trapnr))
>  			ret = NOTIFY_STOP;
> -		preempt_enable();
>  		break;
>  	default:
>  		break;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
