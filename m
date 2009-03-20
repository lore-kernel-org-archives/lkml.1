Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZCTWcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZCTWcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZCTWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:32:07 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35317 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZCTWcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:32:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18884.6416.293431.357565@cargo.ozlabs.ibm.com>
Date: Sat, 21 Mar 2009 09:30:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] perfcounters: record time running and time enabled
 for each counter
In-Reply-To: <1237560631.24626.103.camel@twins>
References: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
	<1237560631.24626.103.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Fri, 2009-03-20 at 23:07 +1100, Paul Mackerras wrote:
> > Impact: new functionality
> > 
> > Currently, if there are more counters enabled than can fit on the CPU,
> > the kernel will multiplex the counters on to the hardware using
> > round-robin scheduling.  That isn't too bad for sampling counters, but
> > for counting counters it means that the value read from a counter
> > represents some unknown fraction of the true count of events that
> > occurred while the counter was enabled.
> > 
> > This remedies the situation by keeping track of how long each counter
> > is enabled for, and how long it is actually on the cpu and counting
> > events.  These times are recorded in nanoseconds using the task clock
> > for per-task counters and the cpu clock for per-cpu counters.
> 
> Can't we do this by simply adding some software counters? A task local
> to each group and a task local on its own.
> 
> Since the solo task local will always be scheduled, you can get the
> sampling fraction by comparing the group task local one to the solo one.

You can get time_running that way but you can't really get
time_enabled accurately in general, since there's no way to enable or
disable two groups simultaneously.  (Yes, in the special case where
you are doing self-monitoring and you have no other counters, you can
use prctl(PR_TASK_PERF_COUNTERS_{EN,DIS}ABLE), but that's not a
general solution.)

The other thing is that the two extra software counters will add
overhead, whereas my patch will add negligible overhead - just some
integer arithmetic and accesses to cache lines which will already be
in exclusive state due to the stores we're already doing to things
such as counter->state.

Paul.
