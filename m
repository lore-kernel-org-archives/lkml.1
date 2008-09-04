Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYIDVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYIDVeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYIDVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:34:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbYIDVeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:34:08 -0400
Date: Thu, 4 Sep 2008 23:33:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904213350.GA15678@elte.hu>
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

> On Thu, 4 Sep 2008, Ingo Molnar wrote:
> > 
> > hm, unless i'm missing something i think here we still have a small 
> > window for an SMI or some virtualization delay to slip in and cause 
> > massive inaccuracy: if the delay happens _after_ the last 
> > pit_expect_msb() and _before_ the external get_cycles() call. Right?
> 
> Yes. I had the extra pit_expect_msb() originally, but decided that 
> basically a single-instruction race for somethign that ran without any 
> MSI for 15ms was a bit pointless.

the race is wider than that i think: all it takes an SMI at the last PIO 
access, so the window should be 1 usec, against a 15000 usecs period. 
That's 1 out of 15,000 boxes coming up with totally incorrect 
calibration.

we also might have a very theoretical race of an SMI taking exactly 65 
msecs so that the whole PIT wraps around and fools the fastpath - the 
chance for that would be around 1:300 - assuming we only have to hit the 
right MSB with a ~200 usecs precision). That assumes equal distribution 
of SMI costs which they certainly dont have - most of them are much less 
than 60 msecs. So i dont think it's an issue in practice - on real hw.

But it's still a possibility unless i'm missing something. We could 
protect against that case by reading the IRQ0-pending bit and making 
sure it's not pending after we have done the closing TSC readout.

> But adding another pit_expect_msb() is certainly not wrong.

ok, i kept that bit.

	Ingo
