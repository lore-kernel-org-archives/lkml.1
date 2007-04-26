Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXDZX1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXDZX1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbXDZX1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:27:37 -0400
Received: from holomorphy.com ([66.93.40.71]:37535 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbXDZX1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:27:35 -0400
Date: Thu, 26 Apr 2007 16:26:41 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20070426232641.GJ19966@holomorphy.com>
References: <20070424212717.GR31925@holomorphy.com> <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com> <20070425094403.GA3290@elte.hu> <20070425115840.GT31925@holomorphy.com> <20070425201309.GA5646@1wt.eu> <1177610268.3360.35.camel@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177610268.3360.35.camel@tongli.jf.intel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 04:58:40AM -0700, William Lee Irwin III wrote:
>>> Adjustments to the lag computation for for arrivals and departures
>>> during execution are among the missing pieces. Some algorithmic devices
>>> are also needed to account for the varying growth rates of lags of tasks
>>> waiting to run, which arise from differing priorities/weights.

On Wed, 2007-04-25 at 22:13 +0200, Willy Tarreau wrote:
>> that was the principle of my proposal of sorting tasks by expected completion
>> time and using +/- credit to compensate for too large/too short slice used.

On Thu, Apr 26, 2007 at 10:57:48AM -0700, Li, Tong N wrote:
> Yeah, it's a good algorithm. It's a variant of earliest deadline first
> (EDF). There are also similar ones in the literature such as earliest
> eligible virtual deadline first (EEVDF) and biased virtual finishing
> time (BVFT). Based on wli's explanation, I think Ingo's approach would
> also fall into this category. With careful design, all such algorithms
> that order tasks based on some notion of time can achieve good fairness.
> There are some subtle differences. Some algorithms of this type can
> achieve a constant lag bound, but some only have a constant positive lag
> bound, but O(N) negative lag bound, meaning some tasks could receive
> much more CPU time than it would under ideal fairness when the number of
> tasks is high.

The algorithm is in a bit of flux, but the virtual deadline computation
is rather readable. You may be able to tell whether cfs is affected by
the negative lag issue better than I. For the most part all I can smoke
out is that it's not apparent to me whether load balancing is done the
way it needs to be.


On Thu, Apr 26, 2007 at 10:57:48AM -0700, Li, Tong N wrote:
> On the other hand, the log(N) complexity of this type of algorithms has
> been a concern in the research community. This motivated O(1)
> round-robin based algorithms such as deficit round-robin (DRR) and
> smoothed round-robin (SRR) in networking, and virtual-time round-robin
> (VTRR), group ratio round-robin (GP3) and grouped distributed queues
> (GDQ) in OS scheduling, as well as the distributed weighted round-robin
> (DWRR) one I posted earlier.

I'm going to make a bold statement: I don't think O(lg(n)) is bad at
all. In real systems there are constraints related to per-task memory
footprints that severely restrict the domain of the performance metric,
rendering O(lg(n)) bounded by a rather reasonable constant.

A larger concern to me is whether this affair actually achieves its
design goals and, to a lesser extent, in what contexts those design
goals are truly crucial or dominant as opposed to others, such as,
say, interactivity. It is clear, regardless of general applicability,
that the predictability of behavior with regard to strict fairness
is going to be useful in certain contexts.

Another concern which is in favor of the virtual deadline design is
that virtual deadlines can very effectively emulate a broad spectrum
of algorithms. For instance, the mainline "O(1) scheduler" can be
emulated using such a queueing mechanism. Even if the particular
policy cfs now implemented is dumped, radically different policies
can be expressed with its queueing mechanism. This has maintainence
implications which are quite beneficial. That said, it's far from
an unqualified endorsement. I'd still like to see much done differently.


-- wli
