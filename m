Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZFVL6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZFVL6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZFVL5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:57:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZFVL5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:57:51 -0400
Date: Mon, 22 Jun 2009 13:57:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: II.2 - Event knowledge missing
Message-ID: <20090622115734.GN24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2/ Event knowledge missing
>
> There are constraints on events in Intel processors. Different
> constraints do exist on AMD64 processors, especially with
> uncore-releated events.

You raise the issue of uncore events in IV.1, but let us reply here
primarily.

Un-core counters and events seem to be somewhat un-interesting to
us. (Patches from those who find them interesting are welcome of
course!)

So they werent in the first line of PMU features to cherry-pick
from.

The main problem with uncore events is that they are per physical
package, and hence tying a piece of physical metric exposed via them
to a particular workload is hard - unless full-system analysis is
performed. 'Task driven' metrics seem far more useful to performance
analysis (and those are the preferred analysis method of most
user-space developers), as they allow particularized sampling and
allow the tight connection between workload and metric.

If, despite our expecations, uncore events prove to be useful,
popular and required elements of performance analysis, they can be
supported in perfcounters via various levels:

 - a special raw ID range on x86, only to per CPU counters. The
   low-level implementation reserves the uncore PMCs, so overlapping
   allocation (and interaction between the cores via the MSRs) is
   not possible.

 - generic enumeration with full tooling support, time-sharing and
   the whole set of features. The low-level backend would time-share
   the resource between interested CPUs.

There is no limitation in the perfcounters design that somehow makes
uncore events harder to support. The uncore counters _themselves_
are limited to begin with - so rich features cannot be offered on
top of them.

> In your model, those need to be taken care of by the kernel.
> Should the kernel make the wrong decision, there would be no
> work-around for user tools. Take the example I outlined just above
> with Intel fixed counters.

Yes. Why should there be a work-around for user tools if the fix is
for the kernel? We don't try to work around random driver bugs in userspace
either, we simply fix the kernel.

> The current code-base does not have any constrained event support,
> therefore bogus counts may be returned depending on the event
> measured.

Then we'll need to grow some when we run into them :-)
