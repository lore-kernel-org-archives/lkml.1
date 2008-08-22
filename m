Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYHVG2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYHVG2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYHVG2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:28:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40981 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbYHVG2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:28:37 -0400
Date: Fri, 22 Aug 2008 08:28:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] smp_call_function: use rwlocks on queues rather
	than rcu
Message-ID: <20080822062800.GQ14110@elte.hu>
References: <48AE0883.6050701@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AE0883.6050701@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> RCU can only control the lifetime of allocated memory blocks, which 
> forces all the call structures to be allocated.  This is expensive 
> compared to allocating them on the stack, which is the common case for 
> synchronous calls.
> 
> This patch takes a different approach.  Rather than using RCU, the 
> queues are managed under rwlocks.  Adding or removing from the queue 
> requires holding the lock for writing, but multiple CPUs can walk the 
> queues to process function calls under read locks.  In the common 
> case, where the structures are stack allocated, the calling CPU need 
> only wait for its call to be done, take the lock for writing and 
> remove the call structure.
> 
> Lock contention - particularly write vs read - is reduced by using 
> multiple queues.

hm, is there any authorative data on what is cheaper on a big box, a 
full-blown MESI cache miss that occurs for every reader in this new 
fastpath, or a local SLAB/SLUB allocation+free that occurs with the 
current RCU approach?

	Ingo
