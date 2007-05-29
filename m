Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbXE2Ktb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbXE2Ktb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 06:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbXE2KtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 06:49:24 -0400
Received: from holomorphy.com ([66.93.40.71]:53616 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbXE2KtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 06:49:23 -0400
Date: Tue, 29 May 2007 03:48:05 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: vatsa@in.ibm.com, Kirill Korotaev <dev@sw.ru>,
       Nick Piggin <nickpiggin@yahoo.com.au>, tingy@cs.umass.edu,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       efault@gmx.de, kernel@kolivas.org, linux-kernel@vger.kernel.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070529104805.GC31925@holomorphy.com>
References: <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <4658DF0F.5020208@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4658DF0F.5020208@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> Lag should be considered in lieu of load because lag

On Sun, May 27, 2007 at 11:29:51AM +1000, Peter Williams wrote:
> What's the definition of lag here?

Lag is the deviation of a task's allocated CPU time from the CPU time
it would be granted by the ideal fair scheduling algorithm (generalized
processor sharing; take the limit of RR with per-task timeslices
proportional to load weight as the scale factor approaches zero).
Negative lag reflects receipt of excess CPU time. A close-to-canonical
"fairness metric" is the maximum of the absolute values of the lags of
all the tasks on the system. The "signed minimax pseudonorm" is the
largest lag without taking absolute values; it's a term I devised ad
hoc to describe the proposed algorithm.


William Lee Irwin III wrote:
>> is what the
>> scheduler is trying to minimize;

On Sun, May 27, 2007 at 11:29:51AM +1000, Peter Williams wrote:
> This isn't always the case.  Some may prefer fairness to minimal lag. 
> Others may prefer particular tasks to receive preferential treatment.

This comment does not apply. Generalized processor sharing expresses
preferential treatment via weighting. Various other forms of
preferential treatment require more elaborate idealized models.


>> load is not directly relevant, but
>> appears to have some sort of relationship. Also, instead of pinned,
>> unpinned should be considered.

On Sun, May 27, 2007 at 11:29:51AM +1000, Peter Williams wrote:
> If you have total and pinned you can get unpinned.  It's probably 
> cheaper to maintain data for pinned than unpinned as there's less of it 
> on normal systems.

Regardless of the underlying accounting, I've presented a coherent
algorithm. It may be that there's no demonstrable problem to solve.
On the other hand, if there really is a question as to how to load
balance in the presence of tasks pinned to cpus, I just answered it.


William Lee Irwin III wrote:
>> Using the signed minimax pseudonorm (i.e. the highest
>> signed lag, where positive is higher than all negative regardless of
>> magnitude) on unpinned lags yields a rather natural load balancing
>> algorithm consisting of migrating from highest to lowest signed lag,
>> with progressively longer periods for periodic balancing across
>> progressively higher levels of hierarchy in sched_domains etc. as usual.
>> Basically skip over pinned tasks as far as lag goes.
>> The trick with all that comes when tasks are pinned within a set of
>> cpus (especially crossing sched_domains) instead of to a single cpu.

On Sun, May 27, 2007 at 11:29:51AM +1000, Peter Williams wrote:
> Yes, this makes the cost of maintaining the required data higher which 
> makes keeping pinned data more attractive than unpinned.
> BTW keeping data for sets of CPU affinities could cause problems as the 
> number of possible sets is quite large (being 2 to the power of the 
> number of CPUs).  So you need an algorithm based on pinned data for 
> single CPUs that knows the pinning isn't necessarily exclusive rather 
> than one based on sets of CPUs.  As I understand it (which may be 
> wrong), the mechanism you describe below takes that approach.

Yes, the mechanism I described takes that approach.


William Lee Irwin III wrote:
>> The smpnice affair is better phrased in terms of task weighting. It's
>> simple to honor nice in such an arrangement. First unravel the
>> grouping hierarchy, then weight by nice. This looks like
[...]
>> In such a manner nice numbers obey the principle of least surprise.

On Sun, May 27, 2007 at 11:29:51AM +1000, Peter Williams wrote:
> Is it just me or did you stray from the topic of handling cpu affinity 
> during load balancing to hierarchical load balancing?  I couldn't see 
> anything in the above explanation that would improve the handling of cpu 
> affinity.

There was a second issue raised to which I responded. I didn't stray
per se. I addressed a second topic in the post.


-- wli
