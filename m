Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbXGaJO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbXGaJO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXGaJOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:14:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbXGaJOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:14:17 -0400
Date: Tue, 31 Jul 2007 11:13:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070731091359.GB15136@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <20070731101133.5ae6ac79@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731101133.5ae6ac79@the-village.bc.nu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > code runs under the BKL, and the only other major kernel 
> > infrastructure that has BKL dependencies is the TTY code. Kasper, as 
> > a debugging
> 
> And half the ioctls some of which trigger long code sections.

the tty layer has relatively short BKL latencies, but reiser3 has long 
ones, so those got transposed over to the tty layer, making it all quite 
noticeable to the user.

BKL contention is not a big issue on the desktop _unless_ there's at 
least one workload that creates really long BKL latencies. That 
multiplexes it out to all the other BKL-using subsystems too.

the DRI/DRM BKL use was a problem some time ago, but i think it's now 
using unlocked_ioctl(), correct? All the other ioctls are rare enough to 
not really matter.

with PREEMPT_BKL there's also some sort of random effect of priority 
inversion that makes the actual latencies depend on the scheduler - but 
we dont understand that effect exactly, yet. (hopefully Kasper can help 
us out with that. Peter got rid of his reiser3 partition the moment the 
latencies were traced back to it.)

> For the tty layer I'm waiting for the revoke code to get finished up 
> and move from -mm into Linus tree. At that point the real evil 
> lock_kernel related stuff in the tty layer can switch to using the 
> revoke code for hangup paths and then other bits can be tackled.

oh, wonderful! Alan, you are a true wizard :-) The tty layer is one of 
the very few pieces of kernel code that scares the hell out of me :-)

	Ingo
