Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYHVUxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYHVUxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYHVUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:53:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50356 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYHVUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:53:43 -0400
Date: Fri, 22 Aug 2008 13:53:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080822205339.GK6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com> <48AEC6B2.1080701@linux-foundation.org> <20080822151156.GA6744@linux.vnet.ibm.com> <48AEF3FD.70906@linux-foundation.org> <20080822182915.GG6744@linux.vnet.ibm.com> <48AF0735.60402@linux-foundation.org> <20080822195226.GJ6744@linux.vnet.ibm.com> <48AF1B81.3050806@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AF1B81.3050806@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 03:03:13PM -0500, Christoph Lameter wrote:
> Paul E. McKenney wrote:
> 
> > I was indeed thinking in terms of the free from RCU being specially marked.
> 
> Isnt there some way to shorten the rcu periods significantly? Critical
> sections do not take that long after all.

In theory, yes.  However, the shorter the grace period, the greater the
per-update overhead of grace-period detection -- the general approach
is to use a per-CPU high-resolution timer to force RCU grace period
processing every 100 microseconds or so.  Also, by definition, the RCU
grace period can be no shorter than the longest active RCU read-side
critical section.  Nevertheless, I have designed my current hierarchical
RCU patch with expedited grace periods in mind, though more for the
purpose of reducing latency of long strings of operations that involve
synchronize_rcu() than for cache locality.

> If the RCU periods are much shorter then the chance of cache hotness of the
> objects is increased.

How short does the grace period need to be to significantly increase the
chance of an RCU-protected data element remaining in cache across an RCU
grace period?  The last time I calculated this, the knee of the curve was
at a few tens of milliseconds, but to give you an idea of how long ago
that was, the workload I used was TPC/A.  Which might no longer be very
representative.  ;-)

							Thanx, Paul
