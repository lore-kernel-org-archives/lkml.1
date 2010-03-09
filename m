Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0CIIJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:09:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:51070 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0CIIJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:09:12 -0500
Date: Tue, 9 Mar 2010 16:08:00 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] IRQ: Fix oneshot irq race between
 irq_finalize_oneshot and handle_level_irq
Message-ID: <20100309080800.GC18549@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <1268092679-18070-1-git-send-email-lars@metafoo.de>
 <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003090855250.22855@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Mar 2010 08:08:03.0711 (UTC) FILETIME=[A48EF0F0:01CABF5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 08:58:11AM +0100, Thomas Gleixner wrote:
> On Tue, 9 Mar 2010, Lars-Peter Clausen wrote:
> 
> > If the kernel has been compiled with preemtion support and handle_level_irq is
> > called from process context for a oneshot irq there is a race between
> > irq_finalize_oneshot and handle_level_irq which results in the irq not being
> > unmasked after its handlers have been run.
> > 
> > irq_finalize_oneshot is expected to unmask the irq after the threaded irq
> > handler has been run. It only does so if IRQ_MASKED is set for the irqs status.
> > IRQ_MASKED gets set in the lower part of handle_level_irq after handle_IRQ_event
> > has been called.
> > handle_IRQ_event will wakeup the oneshot irqs threaded handler and if the
> > kernel has been build with preemption there is a chance that the threaded irq
> > handler will finish before execution is returned to handle_level_irq.
> > As a result irq_finalize_oneshot will not unmask the irq and handle_level_irq
> > will set the IRQ_MASKED flag. Thus the irq will stay masked and stalls.
> > 
> > In case of an race the call-graph would look like this:
> >  handle_level_irq
> >  |- mask_ack_irq
> >  |- handle_IRQ_event
> >     |- wake_up_process
> >        |- irq_thread
> >           |- action->thread_fn
> >           |- irq_finalize_oneshot # Does not unmask the irq
> > |- # Set IRQ_MASKED status flag
> 
> Errm, a thread _CANNOT_ preempt a hard interrupt handler.

But on SMP, an irq thread could run on another cpu, right?

Thanks,
Yong

> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
