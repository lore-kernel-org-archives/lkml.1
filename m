Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbXDYL74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbXDYL74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbXDYL74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:59:56 -0400
Received: from holomorphy.com ([66.93.40.71]:36323 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbXDYL7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:59:55 -0400
Date: Wed, 25 Apr 2007 04:58:40 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Li, Tong N" <tong.n.li@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Message-ID: <20070425115840.GT31925@holomorphy.com>
References: <20070424212717.GR31925@holomorphy.com> <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com> <20070425094403.GA3290@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425094403.GA3290@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Li, Tong N <tong.n.li@intel.com> wrote:
>> [...] A corollary of this is that if both threads i and j are 
>> continuously runnable with fixed weights in the time interval, then 
>> the ratio of their CPU time should be equal to the ratio of their 
>> weights. This definition is pretty restrictive since it requires the 
>> properties to hold for any thread in any interval, which is not 
>> feasible. [...]

On Wed, Apr 25, 2007 at 11:44:03AM +0200, Ingo Molnar wrote:
> yes, it's a pretty strong definition, but also note that while it is 
> definitely not easy to implement, the solution is nevertheless feasible 
> in my opinion and there exists a scheduler that implements it: CFS.

The feasibility comment refers to the unimplementability of schedulers
with infinitesimal timeslices/quanta/sched_granularity_ns. It's no
failing of cfs (or any other scheduler) if, say, the ratios are not
exact within a time interval of one nanosecond or one picosecond.

One of the reasons you get the results you do is that what you use for
->fair_key is very close to the definition of lag, which is used as a
metric of fairness. It differs is in a couple of ways, but how it's
computed and used for queueing can be altered to more precisely match.

The basic concept you appear to be trying to implement is a greedy
algorithm: run the task with the largest lag first. As far as I can
tell, this is sound enough, though I have no formal proof. So with the
lag computation and queueing adjusted appropriately, it should work out.

Adjustments to the lag computation for for arrivals and departures
during execution are among the missing pieces. Some algorithmic devices
are also needed to account for the varying growth rates of lags of tasks
waiting to run, which arise from differing priorities/weights.

There are no mysteries.


-- wli
