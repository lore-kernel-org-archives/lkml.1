Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZK1UDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZK1UDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 15:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZK1UDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 15:03:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50274 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZK1UDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 15:03:42 -0500
Date: Sat, 28 Nov 2009 21:03:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED
	registered with setup_irq
Message-ID: <20091128200344.GA1272@pengutronix.de>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 11:18:00PM +0100, Thomas Gleixner wrote:
> On Fri, 27 Nov 2009, Uwe Kleine-König wrote:
> 
> > IRQF_DISABLED is not guaranteed on shared irqs.  There is already a
> > warning in place for irqs registered with request_irq (introduced in
> > 470c66239ef03).  Move it to __setup_irq, this way it triggers for both
> > request_irq and setup_irq.
> > 
> > One irq that is now warned about is the timer tick on at91 (ARCH=arm).
> 
> And how does that help ? The interrupt is shared between the timer and
> the debug port. There is nothing you can do about that.
> 
> The interupt handlers are called in order of setup. The AT91 timer
> irq is set up first and if that's not the case then it needs to be
> fixed and the only way to catch it is in the affected interrupt
> handler.
Russell already suggests to save (and restore) irqs in the handler
before (and after resp.) calling the clockevent functions.

Should it use the raw_ variants?
 
> Applying your patch does not change the hardware and will just result
> in useless, annoying and confusing dmesg warnings.
My patch wasn't mainly to help in the at91 case.  I just thought that a
warning that is triggered with request_irq and request_threaded_irq
shouldn't be skipped when using setup_irq.

Maybe the warning should only be printed if there's a mismatch between
different actions of the same irq regarding IRQF_DISABLED?!

I will prepare a patch for both (i.e. fixing the at91 ISRs and the
warning about IRQF_DISABLED | IRQF_SHARED) but probably only on Monday.
 
Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
