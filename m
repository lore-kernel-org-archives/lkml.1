Return-Path: <linux-kernel-owner+w=401wt.eu-S1760794AbZLJIZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760794AbZLJIZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760782AbZLJIYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:24:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57826 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760790AbZLJIYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:24:54 -0500
Date: Thu, 10 Dec 2009 09:24:52 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: xiyou.wangcong@gmail.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] irq: handle irq0 special only on x86
Message-ID: <20091210082452.GA2420@pengutronix.de>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de> <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com> <20091209.014151.140337246.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20091209.014151.140337246.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Wed, Dec 09, 2009 at 01:41:51AM -0800, David Miller wrote:
> From: Américo Wang <xiyou.wangcong@gmail.com>
> Date: Wed, 9 Dec 2009 17:28:09 +0800
> 
> > 2009/12/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> >> I just noticed this when digging in the irq handling. ,A At least for arm
> >> this doesn't make sense. ,A Not sure if x86 is the only arch this test
> >> is valid for, but probably it is.
> > 
> > No, it is not.
> > 
> > Try grep -Inr 'irq0' arch/*/kernel.
> 
> The edict was sent down long ago that IRQ number zero is
> special across the entire kernel tree.
This doesn't help here.  x86 uses irq0 for timing and AFAIK it's some
kind of catch-it-all interrupt---I don't know the exact details though.

> If IRQ zero can happen, you should offset the IRQ values you publish
> to the rest of the kernel, and translate them back when you process
> them internally.
Even if x86 will do that the problem remains.  After it does an offset
of 1 (say) the code will read as follows after adaption:

	/*
	 * But for 'irqfixup == 2' we also do it for handled interrupts if
	 * they are marked as IRQF_IRQPOLL (or for irq zero, which is the
	 * traditional PC timer interrupt.. Legacy)
	 */
	if (irqfixup < 2)
		return 0;

	if (irq == 1)
		return 1;

So try_misrouted_irq hard codes the value of the timer irq (be it zero
or one) and this is wrong for other archs like ARM where irq0 is used on
some machines, too.  There it's just an ordinary irq.

BTW I don't see a reason to forbid irq0 if you don't need to doubt of
it's validity even in driver code.

So if the resources of a platform device specify:

	struct resource mydevicesresources[] = {
		...
		{
			.start = 0,
			.end = 0,
			.flags = IORESOURCE_IRQ,
		},
		...
	};

I'd like to use the returned value by platform_get_irq for this device.

Note, I fully agree to use 0 for NO_IRQ if you have an int-sized value
that holds either NO_IRQ or a valid irq number.  But in practise I'd not
recommend to use this idiom.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
