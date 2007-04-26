Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbXDZTV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbXDZTV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031459AbXDZTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:21:26 -0400
Received: from 1wt.eu ([62.212.114.60]:2302 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbXDZTVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:21:25 -0400
Date: Thu, 26 Apr 2007 21:18:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070426191835.GA12740@1wt.eu>
References: <20070424212717.GR31925@holomorphy.com> <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com> <20070425094403.GA3290@elte.hu> <20070425115840.GT31925@holomorphy.com> <20070425201309.GA5646@1wt.eu> <1177610268.3360.35.camel@tongli.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177610268.3360.35.camel@tongli.jf.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:57:48AM -0700, Li, Tong N wrote:
> On Wed, 2007-04-25 at 22:13 +0200, Willy Tarreau wrote:
> > On Wed, Apr 25, 2007 at 04:58:40AM -0700, William Lee Irwin III wrote:
> > 
> > > Adjustments to the lag computation for for arrivals and departures
> > > during execution are among the missing pieces. Some algorithmic devices
> > > are also needed to account for the varying growth rates of lags of tasks
> > > waiting to run, which arise from differing priorities/weights.
> > 
> > that was the principle of my proposal of sorting tasks by expected completion
> > time and using +/- credit to compensate for too large/too short slice used.
> > 
> > Willy
> 
> Yeah, it's a good algorithm. It's a variant of earliest deadline first
> (EDF). There are also similar ones in the literature such as earliest
> eligible virtual deadline first (EEVDF) and biased virtual finishing
> time (BVFT). Based on wli's explanation, I think Ingo's approach would
> also fall into this category. With careful design, all such algorithms
> that order tasks based on some notion of time can achieve good fairness.
> There are some subtle differences. Some algorithms of this type can
> achieve a constant lag bound, but some only have a constant positive lag
> bound, but O(N) negative lag bound,

Anyway, we're working in discrete time, not linear time. Lag is
unavoidable. At best it can be bounded and compensated for. First time
I thought about this algorithm, I was looking at a line drawn using the
Bresenham algorithm. This algorithm is all about error compensation for
a perfect expectation. Too high, too far, too high, too far... I thought
that the line could represent a task progress as a function of time, and
the pixels the periods the task spends on the CPU. On short intervals,
you lose. On large ones, you're very close to the ideal case.

> meaning some tasks could receive
> much more CPU time than it would under ideal fairness when the number of
> tasks is high.

It's not a problem that a task receives much more CPU than it should,
provided that :

  a) it may do so for a short and bound time, typically less than the
     maximum acceptable latency for other tasks

  b) the excess of CPU it received is accounted for so that it is
     deduced from next passes.


> On the other hand, the log(N) complexity of this type of algorithms has
> been a concern in the research community. This motivated O(1)

I've been for O(1) algorithms for a long time, but seeing how dumb the
things you can do in O(1) are compared to O(logN), I definitely switched
my mind. Also, in O(logN), you often have a lot of common operations
still O(1). Eg: you insert in O(logN) in a time-ordered tree, but you
read from it in O(1). But you still have the ability to change its
content in O(logN) if you need.

Last but not least, spending one hundred cycles a few thousand times
a second is nothing compared to electing the wrong task for a full
time-slice.

Willy

