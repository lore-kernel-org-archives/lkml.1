Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbYHVHNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbYHVHNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYHVHMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:12:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbYHVHMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:12:52 -0400
Date: Fri, 22 Aug 2008 09:12:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080822071209.GZ14110@elte.hu>
References: <48AE0883.6050701@goop.org> <20080822062800.GQ14110@elte.hu> <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020808220006n25d684b1n9db306ddc4f58c4c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Fri, Aug 22, 2008 at 9:28 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> >> RCU can only control the lifetime of allocated memory blocks, which
> >> forces all the call structures to be allocated.  This is expensive
> >> compared to allocating them on the stack, which is the common case for
> >> synchronous calls.
> >>
> >> This patch takes a different approach.  Rather than using RCU, the
> >> queues are managed under rwlocks.  Adding or removing from the queue
> >> requires holding the lock for writing, but multiple CPUs can walk the
> >> queues to process function calls under read locks.  In the common
> >> case, where the structures are stack allocated, the calling CPU need
> >> only wait for its call to be done, take the lock for writing and
> >> remove the call structure.
> >>
> >> Lock contention - particularly write vs read - is reduced by using
> >> multiple queues.
> >
> > hm, is there any authorative data on what is cheaper on a big box, a
> > full-blown MESI cache miss that occurs for every reader in this new
> > fastpath, or a local SLAB/SLUB allocation+free that occurs with the
> > current RCU approach?
> 
> Christoph might have an idea about it.

... thought of that missing Cc: line entry exactly 1.3 seconds after 
having sent the mail :)

Christoph, any preferences/suggestions?

	Ingo
