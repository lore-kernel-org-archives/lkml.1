Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab0CISKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:10:44 -0500
Received: from www.tglx.de ([62.245.132.106]:45825 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0CISKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:10:41 -0500
Date: Tue, 9 Mar 2010 19:10:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between irq_finalize_oneshot
 and handle_level_irq
In-Reply-To: <5309.1268153945@localhost>
Message-ID: <alpine.LFD.2.00.1003091907500.22855@localhost.localdomain>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>            <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain> <5309.1268153945@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 09 Mar 2010 08:58:11 +0100, Thomas Gleixner said:
> > On Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
> > 
> > > If the kernel has been compiled with preemtion support and handle_level_irq is
> > > called from process context for a oneshot irq there is a race between
> > > irq_finalize_oneshot and handle_level_irq which results in the irq not being
> > > unmasked after its handlers have been run.
> > > 
> > > irq_finalize_oneshot is expected to unmask the irq after the threaded irq
> > > handler has been run. It only does so if IRQ_MASKED is set for the irqs status.
> > > IRQ_MASKED gets set in the lower part of handle_level_irq after handle_IRQ_event
> > > has been called.
> > > handle_IRQ_event will wakeup the oneshot irqs threaded handler and if the
> > > kernel has been build with preemption there is a chance that the threaded irq
> > > handler will finish before execution is returned to handle_level_irq.
> > > As a result irq_finalize_oneshot will not unmask the irq and handle_level_irq
> > > will set the IRQ_MASKED flag. Thus the irq will stay masked and stalls.
> > > 
> > > In case of an race the call-graph would look like this:
> > >  handle_level_irq
> > >  |- mask_ack_irq
> > >  |- handle_IRQ_event
> > >     |- wake_up_process
> > >        |- irq_thread
> > >           |- action->thread_fn
> > >           |- irq_finalize_oneshot # Does not unmask the irq
> > > |- # Set IRQ_MASKED status flag
> > 
> > Errm, a thread _CANNOT_ preempt a hard interrupt handler.
> 
> What stops the thread from concurrently running on another CPU and racing
> that way?  I'm an idiot, use small words. :)

Right it's a valid SMP problem, but I got confused by the lengthy
explanation of a thread preempting an hard interrupt handler. :)

Will have a look after dinner.

Thanks,

	tglx

