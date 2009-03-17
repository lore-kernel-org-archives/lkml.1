Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZCQQl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZCQQl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZCQQlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:41:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36628 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZCQQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:41:19 -0400
Date: Tue, 17 Mar 2009 17:40:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jesper Krogh <jesper@krogh.cc>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090317164051.GA32245@elte.hu>
References: <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain> <20090317081412.GA24115@elte.hu> <alpine.LFD.2.00.0903170831020.3082@localhost.localdomain> <20090317161322.GA25904@elte.hu> <alpine.LFD.2.00.0903170919310.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903170919310.3082@localhost.localdomain>
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

> On Tue, 17 Mar 2009, Ingo Molnar wrote:
> > 
> > That's the idea of my patch: to use not two endpoints but thousands 
> > of measurement points.
> 
> Umm. Except you don't.
> 
> > By measuring more we can get a more precise result, and we also do 
> > not assume anything about how much time passes between two 
> > measurement points.
> 
> That's fine, but your actual code doesn't _do_ that.
> 
> > My 'delta' algorithm does not assume anything about how much time 
> > passes between two measurement points - it calculates the slope and 
> > keeps a rolling average of that slope.
> 
> No, you keep a very bad measure of "some kind of random average of the 
> last few points", which - if I read things right:
> 
>  - lacks precision (you really need to use 'double' floating point to do 
>    it well, otherwise the rounding errors will kill you). You seem to be 
>    aiming for a 10-bit fixed point thing, which may or may not work if 
>    done cleverly, but:
> 
>  - seems to be based on a rather weak averaging function which certainly 
>    will lose data over time.
> 
> The thing is, the only _accurate_ average is the one done over 
> long time distances. It's very true that your slope thing works 
> very well over such long times, and you'd get accurate measurement 
> if you did it that way, BUT THAT IS NOT WHAT YOU DO. You have a 
> very tight loop, so you get very bad slopes, and then you use a 
> weak averaging function to try to make them better, but it never 
> does.

Hm, the intention there was to have a memory of ~1000 entries via a 
decaying average of 1:1000.

In parallel to that there's also a noise estimator (which too decays 
over time). So basically when observed noise is very low we 
essentially use the data from the last ~1000 measurements. (well, 
not exactly - as the 'memory' of more recent data will be stronger 
than that of older ones.)

Again ... it's a clearly non-working patch so it's not really a 
defendable concept :-)

> Also, there seems to be a fundamental bug in your PIT reading 
> routine. My fast-TSC calibration only looks at the MSB of the PIT 
> read for a very good reason: if you don't use the explicit LATCH 
> command, you may be getting the MSB of one counter value, and then 
> the LSB of another. So your PIT read can easily be off by ~256 PIT 
> cycles. Only by caring only for the MSB can you do an unlatched 
> read!
> 
> That is why pit_expect_msb() looks for the "edge" where the MSB 
> changes, and never actually looks at the LSB.
> 
> This issue may be an additional reason for your problems, although 
> maybe your noise correction will be able to avoid those cases.

indeed. I did check the trace results though via gnuplot yesterday 
(suspectig PIT readout outliers) and there were no outliers.

For any final patch it's still a showstopper issue.

But the source of error and miscalibration is elsewhere.

	Ingo
