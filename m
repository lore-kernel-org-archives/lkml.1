Return-Path: <linux-kernel-owner+w=401wt.eu-S1763765AbZE3VA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763765AbZE3VA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 17:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZE3VAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 17:00:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbZE3VAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 17:00:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kim Kyuwon <chammoru@gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
Date: Sat, 30 May 2009 23:00:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Kim Kyuwon <q1.kim@samsung.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Kyungmin Park <kyungmin.park@samsung.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com> <200905300135.07103.rjw@sisk.pl> <4d34a0a70905300034q1dee8febl60b5213082e3a5d1@mail.gmail.com>
In-Reply-To: <4d34a0a70905300034q1dee8febl60b5213082e3a5d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905302300.17995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 May 2009, Kim Kyuwon wrote:
> On Sat, May 30, 2009 at 8:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday 25 May 2009, Kim Kyuwon wrote:
> >> Rafael J. Wysocki wrote:
> >> > On Saturday 23 May 2009, Kim Kyuwon wrote:
> >> >> On Sat, May 23, 2009 at 7:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >>> On Saturday 23 May 2009, Kim Kyuwon wrote:
> >> > [--snip--]
> >> >>>> You changed the really important part of Linux, which may affect most
> >> >>>> processor architectures. I think you should be careful. If some of
> >> >>>> architectures can't take care of it (they can implement
> >> >>>> disable_irq_wake correctly in H/W level, will you revert your changes?
> >> >>> No, the changes are not going to be reverted.  In fact things should have been
> >> >>> done like this already much earlier.
> >> >>>
> >> >>> Now, do you have any particular example of a problem related to these changes
> >> >>> or is it only a theoretical issue?
> >> >> I'd CCing you when I'm sending a mail for this particular example of a example.
> >> >> http://markmail.org/thread/fvt7d62arofon5xx
> >> >
> >> > Well, as I said above, reverting the changes that introduced
> >> > [suspend|resume]_device_irqs() is not an option, becuase it was the only sane
> >> > way to achieve the goal they were added for.  So, we need to fix the wake-up
> >> > problem on your platform with the assumption that
> >> > [suspend|resume]_device_irqs() are going to stay.
> >> >
> >> > For starters, would it be possible to teach the 'disable' hook of your
> >> > platform's interrupt controller not to mask the IRQs that have both
> >> > IRQ_WAKEUP and IRQ_SUSPENDED set?  That apparently would work around the
> >> > wake-up interrupts problem.
> >>
> >> Thank you for considering this issue and spending your time. In order to
> >> make your idea work, we need to add a dummy 'set_wake' hook which
> >> returns always zero. Anyway, IMO, I think your idea is good to work
> >> around this problem. But Kevin Hilman(OMAP PM Maintainer) would make
> >> final decision.
> >>
> >> Buy the way, how can you handle the problem that a few interrupt are
> >> discarded in a small window? I can be sure they are discarded, because I
> >> have debugged defects which generate in sleep/resume state hundreds of
> >> times on ARM Processors(PXA310, S3C6410, OMAP3430). Wake-up interrupts
> >> are generated as soon as arch_suspend_enable_irqs() invoked.
> >
> > Sorry for the delayed response.
> >
> > If the wake-up interrupts are not masked, they will be delivered to the drivers
> > as soon as arch_suspend_enable_irqs() has run.  So, if the drivers are able to
> > handle them at this point (ie. before resume_device_irqs() is called), they
> > won't be lost.
> 
> Thank you for your response!
> 
> Your suspend_device_irqs() disables all IRQs(except timer IRQ) while
> entering suspend. i.e. Before invoking resume_device_irqs() or
> resume_noirq callback, all IRQs(except timer IRQ) is in IRQ_DISABLED
> status. Right?
> But if an IRQ is in  IRQ_DISABLED status, its interrupt handler can be

s/can be/can't be/ (as you noticed in the follow-up message).

> invoked. (As you know, all IRQs with IRQ_DISABLE are not handled in
> handle_level_irq function). Thus, even if the wake-up interrupts are
> not masked, the drivers are not able to handle interrupts, because the
> interrupt handler can't be invoked due to IRQ_DISABLED set by
> suspend_device_irqs().

The solution to that may be to add some code that will clear the
IRQ_DISABLE flag for the wake-up interrupt that caused the wake-up to happen
in the early resume code of the platform.

> > The only problem I see is that the drivers may expect their
> > ->resume_noirq() callbacks to be executed first.
> 
> resume_noirq() callbacks are also invoked after arch_suspend_enable_irqs().

Yes, they are, and that may be a problem, because a driver may expect
resume_noirq() to be called before it can handle interrupts from the device.

Best,
Rafael
