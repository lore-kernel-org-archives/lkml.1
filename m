Return-Path: <linux-kernel-owner+w=401wt.eu-S934561AbXFFFcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbXFFFcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbXFFFby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:31:54 -0400
Received: from 1wt.eu ([62.212.114.60]:2874 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833AbXFFFby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:31:54 -0400
Date: Wed, 6 Jun 2007 07:30:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>, vatsa@in.ibm.com,
       balbir@in.ibm.com, Nick Piggin <npiggin@suse.de>,
       Bill Davidsen <davidsen@tmr.com>,
       John Kingman <kingman@storagegear.com>,
       Peter Williams <pwil3058@bigpond.net.au>, seuler.shi@gmail.com
Subject: Re: [RFC] Extend Linux to support proportional-share scheduling
Message-ID: <20070606053018.GA4049@1wt.eu>
References: <20070606033330.GB3266@1wt.eu> <5FD5754DDBA0B1499B5A0B4BB5419485013068A4@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FD5754DDBA0B1499B5A0B4BB5419485013068A4@fmsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 09:31:33PM -0700, Li, Tong N wrote:
> Willy,
> 
> These are all good comments. Regarding the cache penalty, I've done some
> measurements using benchmarks like SPEC OMP on an 8-processor SMP and
> the performance with this patch was nearly identical to that with the
> mainline. I'm sure some apps may suffer from the potentially more
> migrations with this design. In the end, I think what we want is to
> balance fairness and performance. This design currently emphasizes on
> fairness, but it could be changed to relax fairness when performance
> does become an issue (which could even be a user-tunable knob depending
> on which aspect the user cares more).

Maybe storing in each task a small list of the 2 or 4 last CPUs used would
help the scheduler in trying to place them. I mean, let's say you have 10
tasks and 8 CPUs. You first assign tasks 1..8 CPUs 1..8 for 1 timeslice.
Then you will give 9..10 a run on CPUs 1..2, and CPUs 3..8 will be usable
for other tasks. It wil be optimal to run tasks 3..8 on them. Then you will
stop some of those because they are "in advance", and run 9..10 and 1..2
again. You'll have to switch 1..2 to another group of CPUs to maintain hot
cache on CPUs 1..2 for tasks 9..10. But another possibility would be to
consider that 9..10 and 1..2 have performed the same amount of work, so
let's 9..10 take some advance and benefit from the hot cache, then try to
place 1..2 there again. But it will mean that 3..8 will now have run 2
timeslices more than others. At this moment, it should be wise to make
them sleep and keep their CPU history for future use.

Maybe on end-user systems, the CPUs history is not that important because
of the often small caches, but on high-end systems with large L2/L3 caches,
I think that we can often keep several tasks in the cache, justifying the
ability to select one of the last CPUs used.

Not an easy thing to do, but probably very complementary to your work IMHO.

Regards,
Willy

