Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYIDVV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYIDVV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYIDVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:21:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbYIDVVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:21:49 -0400
Date: Thu, 4 Sep 2008 23:21:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904212130.GA12406@elte.hu>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> <20080904190728.59634020@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org> <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> However, this one is:
> 
> > +	/*
> > +	 * The iteration assumes that expect never goes below zero:
> > +	 */
> > +	BUILD_BUG_ON(QUICK_PIT_ITERATIONS >= 0xff);
> 
> No it doesn't. "expect" is unsigned char and will happily wrap, as 
> will the PIT timer. The fact that it is in "single shot" mode doesn't 
> actually mean that the timer stops, it just affects what happens when 
> it goes down to zero.
> 
> So that BUILD_BUG_ON() is misleading and incorrect.

ah, indeed, that bit of mine is wrong - and the period is programmed to 
0xffff so it should all work out just fine. You code in a way too tricky 
manner ;) I zapped that portion.

In fact ... shouldnt we intentionally include a 'wraparound' event in 
the test? Some of the erratums/instabilities regarding PITs happened 
around wraparounds [of the lsb] - maybe the wraparound of the MSB 
matters too. (Maybe some boards freeze the counter readout until the 
host OS ACKs the PIT irq or something - which we dont do in this 
calibration run so if there's some weirdness there we'd detect it.)

So maybe we should start with an expect value of QUICK_PIT_ITERATIONS/2, 
with a wraparound right in the middle of the measurement?

	Ingo
