Return-Path: <linux-kernel-owner+w=401wt.eu-S1761097AbZLJQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761097AbZLJQln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbZLJQll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:41:41 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37108 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761053AbZLJQlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:41:40 -0500
Date: Thu, 10 Dec 2009 08:41:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091210164136.GA6756@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain> <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain> <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain> <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> <m1y6lg7q3n.fsf@fess.ebiederm.org> <20091207183226.GA20139@redhat.com> <m1aaxu305x.fsf@fess.ebiederm.org> <20091209153709.GA13192@redhat.com> <20091210062220.GC6720@linux.vnet.ibm.com> <m1my1rnmr8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1my1rnmr8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 02:31:39AM -0800, Eric W. Biederman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > My main concern would be "fork storms", where each CPU in a large
> > system is spawning children in a pgrp that some other CPU is attempting
> > to kill.  The CPUs spawning children might be able to keep ahead of
> > the single CPU, so that the pgrp never is completely killed.
> >
> > Enlisting the aid of the CPUs doing the spawning (e.g., by having them
> > consult a list of signals being sent) prevents this fork-storm scenario.
> 
> We almost have a worst case bound. We can have at most max_thread
> processes.  Unfortunately it appears we don't force an rcu grace
> period anywhere.  So It does appear theoretically possible to fork and
> exit on a bunch of other cpus infinitely extending the rcu interval.

The RCU grace period will still complete in a timely fashion, at least
assuming that each RCU read-side critical section completes in a timely
fashion.  The old Classic implememntations need only a context switch on
each CPU (which should happen at some point upon return to user space,
and the counter-based implementations (SRCU and preemptible RCU) use
pairs of counters to avoid waiting on new RCU read-side critical sections.

Either way, the RCU grace period waits only for the RCU read-side
critical sections that started before it did, not for any later RCU
read-side critical sections.

> Still that is all inside the tasklist_lock, which serializes all of those
> other cpus.  So as long as the cost of queuing signals is less than the
> cost of adding processes to the task lists we won't have a problem.

Agreed, as long as we continue to serialize task creation, we should be OK.

							Thanx, Paul
