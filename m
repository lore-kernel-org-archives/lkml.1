Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZK3VAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZK3VAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZK3VAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:00:07 -0500
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:48603 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752688AbZK3VAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:00:04 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 16:00:04 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=cVL7ZjoOhfWoyQHTWiRlyJmah+GyVkkBCYeJHWkEnUv297MhFiIIecnzShsHdVY9FNbxCYbH5uk38/CS3EOJwEXRjo7c+X6n9SjmUX3L51cMn/4HVySHc8vNMtd9bltkmHbmGi35e+QKG1TrGfl1NegHtMSl27+6Rpef1W6gdNc=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: Y8a02PsVM1mzGBSKgJkm32CO9etXY.3H1r_yAAOMldHfnWLwCgp3bHMBdvhUTfzVEROgAJ347OcHNm4a3ilYGhVJZraUSzpf_7jTWfqWkff3cwEFgayA9AupIq4Ga0jvDobw2KF1jYyKbpbjgb.83n73yH0Hw4psjqFMMhyyVe2JCGWl2U37eK2W4MibPUz6K0ZhLceLlRTvBseQ4QBiZxQ0D_oQNwgWjHyMI5m4sgx33h_s_gwcwlvHfTvIzOo7
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about IRQF_SHARED|IRQF_DISABLED)
Date: Mon, 30 Nov 2009 12:53:28 -0800
User-Agent: KMail/1.9.10
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>, LKML <linux-kernel@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091130144702.14bea0ee@lxorguk.ukuu.org.uk> <20091130150100.GB7028@n2100.arm.linux.org.uk>
In-Reply-To: <20091130150100.GB7028@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200911301253.29325.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 November 2009, Russell King - ARM Linux wrote:
> On Mon, Nov 30, 2009 at 02:47:02PM +0000, Alan Cox wrote:
> > SHARED|DISABLED ought to WARN_ON() and if that doesn't motivate people
> > then return -EINVAL.
> 
> That is an impossibility.  There is hardware out there (AT91) where
> the timer interrupt is shared with other peripherals, and you end
> up with a mixture of irqs-disabled and irqs-enabled handlers sharing
> the same interrupt.

For the record:  AT91 isn't restricted to the system timers hooked
up on irq 0 ... there's also drivers/clocksource/tcb_clksrc.c (not
at the same hardware priority).

But to concur, this is indeed messy.  Both the system timer and
the serial console generally share the same IRQ; both are very
timing-sensitive.  I've seen console character dropouts after
tweaking timer IRQ handling.  And I've never convinced myself
that Linux handles the hardware IRQ priority on those chips as
well as it could.  


> My point is that if we outlaw irqs-disabled shared interrupts, it puts
> Atmel AT91 support into immediate difficulties.

ISTR that those TCB modules don't share IRQs with other peripherals.

Also, that Linux doesn't use them for much else.  I've yet to see a
three-phase motor driver using the TCB's PWM capabilities, for example.

- Dave
