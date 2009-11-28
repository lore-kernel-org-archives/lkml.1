Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZK1CHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZK1CHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 21:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZK1CHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 21:07:30 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53416 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZK1CH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 21:07:29 -0500
Date: Fri, 27 Nov 2009 18:07:39 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091128020739.GA18149@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091123145409.GA29627@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123145409.GA29627@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:54:09PM +0100, Nick Piggin wrote:
> Hi,
> 
> Last time this issue came up that I could see, I don't think
> there were objections to making rwlocks fair, the main
> difficulty seemed to be that we allow reentrant read locks
> (so a write lock waiting must not block arbitrary read lockers).
> 
> Nowadays our rwlock usage is smaller although still quite a
> few, so it would make better sense to do a conversion by
> introducing a new lock type and move them over I guess.
> 
> Anyway, I would like to add some kind of fairness or at least
> anti starvation for writers. We have a customer seeing total
> livelock on tasklist_lock for write locking on a system as small
> as 8 core Opteron.
> 
> This was basically reproduced by several cores executing wait
> with WNOHANG.
> 
> Of course it would always be nice to improve locking so
> contention isn't an issue, but so long as we have rwlocks, we
> could possibly get into a situation where starvation is
> triggered *somehow*. So I'd really like to fix this.
> 
> This particular starvation on tasklist lock I guess is a local
> DoS vulnerability even if the workload is not particularly
> realistic.
> 
> Anyway, I don't have a patch yet. I'm sure it can be done
> without extra atomics in fastpaths. Comments?

The usual trick would be to keep per-fair-rwlock state in per-CPU
variables.  If it is forbidden to read-acquire one nestable fair rwlock
while read-holding another, then this per-CPU state can be a single
pointer and a nesting count.  On the other hand, if it is permitted to
read-acquire one nestable fair rwlock while holding another, then one
can use a small per-CPU array of pointer/count pairs.

Readers check the per-CPU state.  If they already read-hold the lock,
they increment the nesting count, otherwise, they contend directly for
the lock (and set up the per-CPU state).

Same number of atomics on the fastpath as the current implementation.
Too bad about those array access, though!  ;-)

(Though on modern hardware, the array accesses might be a non-event,
performance-wise.)

Hey, you asked!!!  And there are other ways to make this work, including
variations on brlock.

							Thanx, Paul
