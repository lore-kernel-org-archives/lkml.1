Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbZK3Rr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbZK3Rr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZK3Rr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:47:58 -0500
Received: from www.tglx.de ([62.245.132.106]:53934 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZK3Rr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:47:57 -0500
Date: Mon, 30 Nov 2009 18:46:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-Reply-To: <20091130143703.GA7028@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0911301834220.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain> <20091130143703.GA7028@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Russell King - ARM Linux wrote:
> On Mon, Nov 30, 2009 at 02:54:54PM +0100, Thomas Gleixner wrote:
> Maybe a "safer" way forward is to go and find all those request_irq()
> sites and add IRQF_DISABLED to them all, wait for regression reports and
> selectively remove the IRQF_DISABLED flags?  We would then be able to
> build up a picture of the problematical drivers that need to be reworked,
> and whether the "run everything with irqs disabled" is even a practical
> proposition.

Well, that's basically the same as removing IRQF_DISABLED, setting the
default to run disabled and provide a new flag IRQF_ENABLE_IRQS which
can be added to drivers when regressions show up. That way you just
have to grep for IRQF_ENABLE_IRQS instead of doing a search for
everything which has it removed. We can keep IRQF_DISABLED around by
setting it to 0 for the transition, so we don't have to touch the
world in the first place.
 
> Now, at the risk of covering old ground, how about we have two separate
> irqaction lists, one for handlers to be called with irqs disabled and
> one for handlers with irqs enabled.  We run the irqs-disabled list
> first, naturally with irqs disabled.  If, at the end of that run (or
> maybe after each handler), IRQs have ended being enabled, print some
> diagnostics.  (We're going to need something like this to ensure that
> drivers interrupt handlers don't enable IRQs themselves.)  Then enable
> IRQs and run the irqs-enabled chain.

Pretty old ground. :) That was discussed 10 years ago and never found
much love, but yes we could do that. Either two list or sorting the
entries. That might avoid the obvious pitfall, but I doubt it'd help
us to fix the drivers which think that they need to do the irqs
enabled dance.

Thanks,

	tglx

