Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbZFPT5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbZFPT5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbZFPT5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:57:30 -0400
Received: from bar.sig21.net ([80.81.252.164]:34745 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZFPT53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:57:29 -0400
Date: Tue, 16 Jun 2009 21:57:50 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, davej@redhat.com, pavel@ucw.cz,
       linux-acpi@vger.kernel.org, lenb@kernel.org,
       venkatesh.pallipadi@intel.com, arjan@infradead.org, tglx@linutronix.de
Subject: Re: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Message-ID: <20090616195750.GA12814@sig21.net>
References: <20090615232709.GA6059@sig21.net> <200906160216.29537.rjw@sisk.pl> <20090616142217.GA5548@sig21.net> <20090616115540.ceb67a30.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616115540.ceb67a30.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.5 (---)
X-Spam-21-Report: No, score=-3.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.868,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:55:40AM -0700, Andrew Morton wrote:
> On Tue, 16 Jun 2009 16:22:17 +0200
> Johannes Stezenbach <js@sig21.net> wrote:
> 
> > Fix swsusp failure on !SMP
> > 
> > Commit 01599fca6758d2cd133e78f87426fc851c9ea725 introduced
> > a regression which caused a backtrace on suspend and
> > a hang on resume on a Thinkpad T42p (Pentium M CPU).
> > 
> > Signed-off-by: Johannes Stezenbach <js@sig21.net>
> > 
> > 
> > --- linux-2.6.30/kernel/up.c.orig	2009-06-16 15:56:28.000000000 +0200
> > +++ linux-2.6.30/kernel/up.c	2009-06-16 15:57:27.000000000 +0200
> > @@ -10,11 +10,13 @@
> >  int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> >  				int wait)
> >  {
> > +	unsigned long flags;
> > +
> >  	WARN_ON(cpu != 0);
> >  
> > -	local_irq_disable();
> > +	local_irq_save(flags);
> >  	(func)(info);
> > -	local_irq_enable();
> > +	local_irq_restore(flags);
> >  
> >  	return 0;
> >  }
> 
> ok, what's going on here?  The patch implies that someone (presumably
> acpi-cpufreq) is calling smp_call_function_single() with local
> interrupts disabled.  That's a bug on SMP kernels.  And it'll generate
> a trace if it happens:
> 
> 	/* Can deadlock when called with interrupts disabled */
> 	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
> 
> but nobody has reported such a trace AFAIK?

This problem apparently only exists on !SMP kernels...

> Also, prior to 01599fca6758d2cd133e78f87426fc851c9ea725, acpi-cpufreq
> was using work_on_cpu().  If it was calling work_on_cpu() with local
> interrupts disabled then that would have been a bug too, which could
> generate might_sleep() or scheduling-while-atomic warnings.

On !SMP, work_on_cpu() is just a function call:
http://lxr.linux.no/linux+v2.6.30/include/linux/workqueue.h#L261

> Because it is a bug to call the SMP version of
> smp_call_function_single() with local interrupts disabled, I don't
> think we should need to apply the above patch.

and on SMP, smp_call_function_single() also uses
local_irq_save/restore() iff  cpu == this_cpu:
http://lxr.linux.no/linux+v2.6.30/kernel/smp.c#L272

> But I don't know what we _should_ do because I don't know what the bug
> is.  Are you able to get us a copy of that stack trace?

Unfortunately my laptop doesn't have a serial port, and the
stack trace is large and scrolls off the screen, I can only
see the last part of it and I would need to find someone with
a camera to take a picture...


Johannes
