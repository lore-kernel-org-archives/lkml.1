Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYJLMq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYJLMq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYJLMqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:46:49 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:51566 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYJLMqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:46:49 -0400
Date: Sun, 12 Oct 2008 14:46:38 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH/RFC] hardware irq debouncing support
Message-ID: <20081012144638.4dfdbff8@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <200810111101.20885.david-b@pacbell.net>
References: <200809241251.32606.david-b@pacbell.net>
	<200810090234.41243.david-b@pacbell.net>
	<20081009123030.4c9607c1@hskinnemo-gx745.norway.atmel.com>
	<200810111101.20885.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Oct 2008 12:46:22.0741 (UTC) FILETIME=[880AF450:01C92C68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell <david-b@pacbell.net> wrote:
> On Thursday 09 October 2008, Haavard Skinnemoen wrote:
> >
> > On the other hand, lack of debouncing might cause the gpio_keys driver
> > to report 1000 keypresses instead of one when the user pushes a button.
> > That's much more harmful.
> > 
> > So if someone goes and replaces the debounce timer in gpio_keys with
> > this IRQF_DEBOUNCE flag, it might work very well on hardware which
> > happens to use a 30 ms debounce interval, but will break horribly on
> > hardware with shorter debounce intervals.
> 
> Agreed that if you want to _replace_ software debouncing with a flag
> that's a pure hint, it wouldn't work.  But I didn't suggest that...
> 
> Instead, if you just added IRQF_DEBOUNCE to the existing gpio_keys,
> what you'd get is a reduction in useless IRQs received.  Which is
> a behavioral improvement, coming at essentially zero system cost.
> (After discounting the cost of "how to do it" discussions!)

Ok, I see. I didn't realize that gpio_keys doesn't disable the
interrupt while debouncing.

> > Sort of. I'm just wondering how drivers can rely on a feature which
> > provides such vague promises.
> 
> As with madvise(), by just hinting "here's a way to improve
> behavior a bit, if hardware allows".  As you noted, ignoring
> such hints would mean some missed optimizations ... but the
> system would still behave correctly.

Right.

> > Maybe that's better. Just request the interrupt as normal, and then try
> > to enable debouncing. If the actual delay is too short, the driver can
> > set up its own timer.
> 
> So we seem to be thinking about two mechanisms:
> 
>  - I focussed on hinting, as a lightweight way to kick in a
>    common hardware mechanism to improve system behavior;
> 
>  - You focussed on abstracting the whole debouncing problem,
>    leveraging those mechanisms more highly and (implicitly)
>    helping improve much messy software debounce logic.

Yes, you're right.

> Still seems to me there should be no problem having both
> mechanisms, supported by one irq_chip.debounce() hook
> that's a little different from the one in $PATCH.  And I
> think you agreed with that.
> 
> Specifically with respect to the Atmel GPIO modules, the
> hinting would eliminate a few glitches but would not be as
> powerful as on some other hardware.  (As you had observed
> earlier.)  So if I were wearing the same corporate hat you
> are, I'd want Linux to support that second mechanism too!!

I just want a mechanism where you'll end up with the same behaviour
regardless of what the hardware supports, at the cost of a timer if the
hardware doesn't support the requested debounce delay. As an added
benefit, this would eliminate the need for drivers to set up their own
debounce timers. It would also make such "more powerful" hardware
features easier to utilize from generic drivers, wouldn't it?

But you've convinced me that your IRQF_DEBOUNCE hint might be useful
too.

> > I think it's very important to drivers that have to deal with
> > mechanical buttons and switches. In many cases, only the board code
> > knows what kind of switch is hooked up to the interrupt, so the driver
> > just passes on that information from the platform data.
> 
> If the platform setup code knows the hardware debounce will
> be requested, it can adjust its platform_data debounce parameter
> accordingly.

I guess it could, but why would it do that? The debounce delay
shouldn't depend on the mechanism used to implement it, should it?

Or are you thinking about compensating for any delays introduced by
IRQF_DEBOUNCE?

Haavard
