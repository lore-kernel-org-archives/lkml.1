Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbZKEPzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbZKEPzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZKEPzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:55:12 -0500
Received: from www.tglx.de ([62.245.132.106]:49969 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZKEPzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:55:11 -0500
Date: Thu, 5 Nov 2009 16:54:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@googlemail.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
In-Reply-To: <20091105153321.GB24690@redhat.com>
Message-ID: <alpine.LFD.2.00.0911051653170.12138@localhost.localdomain>
References: <6417.1257351084@turing-police.cc.vt.edu> <200911051941.03401.rusty@rustcorp.com.au> <20091105141055.GA17350@redhat.com> <alpine.LFD.2.00.0911051547110.12138@localhost.localdomain> <20091105152241.GA24690@redhat.com>
 <20091105153321.GB24690@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Oleg Nesterov wrote:

> On 11/05, Oleg Nesterov wrote:
> >
> > On 11/05, Thomas Gleixner wrote:
> > >
> > > Hmm, we fixed all this lock madness in mainline already.
> > > clocksource_done_booting() does not longer call
> > > create_workqueue(). How got this code reverted in motm ?
> >
> > I don't understand this code at all. But this is what I see
> > in Linus's tree:
> >
> > 	clocksource_done_booting
> > 	    clocksource_select
> > 	        timekeeping_notify
> > 	            stop_machine
> > 	                 stop_machine_create
> >
> >
> > OTOH, I don't see where native_cpu_up() path calls clocksource_change_rating(),
> > perhaps this was changed in -mm.
> 
> I believe Martin knows the answer:
> 
> On 11/05, Martin Schwidefsky wrote:
> >
> > That is imho caused by this patch snippet from the linux-next.patch from mmotd:
> >
> > diff -puN arch/x86/kernel/tsc.c~linux-next arch/x86/kernel/tsc.c
> > --- a/arch/x86/kernel/tsc.c~linux-next
> > +++ a/arch/x86/kernel/tsc.c
> > @@ -763,14 +763,12 @@ void mark_tsc_unstable(char *reason)
> >  {
> >         if (!tsc_unstable) {
> >                 tsc_unstable = 1;
> > -               printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
> > +               printk("Marking TSC unstable due to %s\n", reason);
> >                 /* Change only the rating, when not registered */
> >                 if (clocksource_tsc.mult)
> > -                       clocksource_mark_unstable(&clocksource_tsc);
> > -               else {
> > -                       clocksource_tsc.flags |= CLOCK_SOURCE_UNSTABLE;
> > +                       clocksource_change_rating(&clocksource_tsc, 0);
> 
>                           ^^^^^^^^^^^^^^^^^^^^^^^^^

Which basically reverts commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16

Thanks,

	tglx

