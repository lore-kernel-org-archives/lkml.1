Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbZLHBjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbZLHBjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 20:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935228AbZLHBi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 20:38:59 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56197 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935177AbZLHBi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 20:38:58 -0500
Date: Mon, 7 Dec 2009 17:39:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091208013900.GU6808@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1259616429.26472.499.camel@laptop> <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> <m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207181816.GF6808@linux.vnet.ibm.com> <m1ocma1kz6.fsf@fess.ebiederm.org> <87ws0y76q7.fsf@basil.nowhere.org> <m1fx7m1ie8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fx7m1ie8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:19:59PM -0800, Eric W. Biederman wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > ebiederm@xmission.com (Eric W. Biederman) writes:
> >
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> >>>
> >>> Is it required that all of the processes see the signal before the
> >>> corresponding interrupt handler returns?  (My guess is "no", which
> >>> enables a trick or two, but thought I should ask.)
> >>
> >> Not that I recall.  I think it is just an I/O completed signal.
> >
> > Wasn't there the sysrq SAK too? That one definitely would need
> > to be careful about synchronicity.
> 
> SAK from sysrq is done through schedule work, I seem to recall the
> locking being impossible otherwise.  There is also send_sig_all and a
> few others from sysrq.  I expect we could legitimately make them
> schedule_work as well if needed.

OK, I will chance it...  Here is one possible trick:

o	Maintain a list of ongoing group-signal operations, protected
	by some suitable lock.  These could be in a per-chain-locked
	hash table, hashed by the signal target (e.g., pgrp).

o	When a task is created, it scans the above list, committing
	suicide (or doing whatever the signal requires) if appropriate.

o	When creating a child task, the parent holds an SRCU across
	creation.  It acquires SRCU before starting creation, and
	releases it when it knows that the child has completed
	scanning the above list.

o	The updater does the following:

	o	Add its request to the above list.

	o	Wait for an SRCU grace period to elapse.

	o	Kill off everything currently in the task list,
		and then wait for each such task to get to a point
		where it can be guaranteed not to spawn additional
		tasks.  (This might be mediated via a reference
		count in the corresponding list element, or by
		rescanning the task list, or any of a number of
		similar tricks.)

		Of course, if the signal is non-fatal, then it is
		necessary only to wait until the child has taken
		the signal.

	o	If it is possible for a given task's children to
		outlive it, despite the fact that the children must
		commit suicide upon finding themselves indicated by the
		list, wait for another SRCU grace period to elapse.
		(This additional SRCU grace period would be required
		for a non-fatal pgrp signal, for example.)

	o	Remove the element from the list.

Does this approach make sense, or am I misunderstanding the problem?

Either way, one additional question...  It seems to me that non-fatal
signals really don't require the above mechanism, because if a task
handles the signal, and then spawns a child, one can argue that the
child came after the signal and should thus be unaffected.  Right?
Or more confusion on my part?

							Thanx, Paul
