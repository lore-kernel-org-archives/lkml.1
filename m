Return-Path: <linux-kernel-owner+w=401wt.eu-S1763116AbYEGRtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763116AbYEGRtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYEGRtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:49:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYEGRtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:49:16 -0400
Date: Wed, 7 May 2008 19:49:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507174900.GB13591@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org> <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > There's far more normal mutex fastpath use during an AIM7 run than 
> > any BKL use. So if it's due to any direct fastpath overhead and the 
> > resulting widening of the window for the real slowdown, we should 
> > see a severe slowdown on AIM7 with CONFIG_MUTEX_DEBUG=y. Agreed?
> 
> Not agreed.
> 
> The BKL is special because it is a *single* lock.

ok, indeed my suggestion is wrong and this would not be a good 
comparison.

another idea: my trial-baloon patch should test your theory too, because 
the generic down_trylock() is still the 'fat' version, it does:

        spin_lock_irqsave(&sem->lock, flags);
        count = sem->count - 1;
        if (likely(count >= 0))
                sem->count = count;
        spin_unlock_irqrestore(&sem->lock, flags);

if there is a noticeable performance difference between your 
trial-ballon patch and mine, then the micro-cost of the BKL very much 
matters to this workload. Agreed about that?

but i'd be _hugely_ surprised about it. The tty code's BKL use should i 
think only happen when a task exits and releases the tty - and a task 
exit - even if this is a threaded test (which AIM7 can be - not sure 
which exact parameters Yanmin used) - the costs of thread creation and 
thread exit are just not in the same ballpark as any BKL micro-costs. 
Dunno, maybe i overlooked some high-freq BKL user. (but any such site 
would have shown up before) Even assuming a widening of the critical 
path and some catastrophic domino effect (that does show up as increased 
scheduling) i've never seen a 40% drop like this.

this regression, to me, has "different scheduling behavior" written all 
over it - but that's just an impression. I'm not going to bet against 
you though ;-)

	Ingo
