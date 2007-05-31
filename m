Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbXEaJOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbXEaJOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbXEaJOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:14:42 -0400
Received: from holomorphy.com ([66.93.40.71]:48220 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014AbXEaJOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:14:41 -0400
Date: Thu, 31 May 2007 02:15:34 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       efault@gmx.de, linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Peter Williams <pwil3058@bigpond.net.au>, kernel@kolivas.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531091534.GK6909@holomorphy.com>
References: <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com> <20070531032657.GA823@in.ibm.com> <20070531040926.GH6909@holomorphy.com> <20070531054828.GB663@in.ibm.com> <20070531063647.GC15426@holomorphy.com> <20070531083353.GF663@in.ibm.com> <20070531085600.GA9826@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531085600.GA9826@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 02:03:53PM +0530, Srivatsa Vaddagiri wrote:
>> Its ->wait_runtime will drop less significantly, which lets it be
>> inserted in rb-tree much to the left of those 1000 tasks (and which
>> indirectly lets it gain back its fair share during subsequent
>> schedule cycles).
>> Hmm ..is that the theory?

On Thu, May 31, 2007 at 02:26:00PM +0530, Srivatsa Vaddagiri wrote:
> My only concern is the time needed to converge to this fair
> distribution, especially in face of fluctuating workloads. For ex: a
> container who does a fork bomb can have a very adverse impact on
> other container's fair share under this scheme compared to other
> schemes which dedicate separate rb-trees for differnet containers
> (and which also support two level hierarchical scheduling inside the
> core scheduler).
> I am inclined to have the core scheduler support atleast two levels
> of hierarchy (to better isolate each container) and resort to the
> flattening trick for higher levels.

Yes, the larger number of schedulable entities and hence slower
convergence to groupwise weightings is a disadvantage of the flattening.
A hybrid scheme seems reasonable enough. Ideally one would chop the
hierarchy in pieces so that n levels of hierarchy become k levels of n/k
weight-flattened hierarchies for this sort of attack to be most effective
(at least assuming similar branching factors at all levels of hierarchy
and sufficient depth to the hierarchy to make it meaningful) but this is
awkward to do. Peeling off the outermost container or whichever level is
deemed most important in terms of accuracy of aggregate enforcement as
a hierarchical scheduler is a practical compromise.

Hybrid schemes will still incur the difficulties of hierarchical
scheduling, but they're by no means insurmountable. Sadly, only
complete flattening yields the simplifications that make task group
weighting enforcement orthogonal to load balancing and the like. The
scheme I described for global nice number behavior is also not readily
adaptable to hybrid schemes.


-- wli
