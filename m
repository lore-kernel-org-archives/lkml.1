Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZBLEIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZBLEIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 23:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZBLEI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 23:08:29 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:34960 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664AbZBLEI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 23:08:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQFANssk0lMQWt2/2dsb2JhbACBbtJLhBsG
Date: Wed, 11 Feb 2009 23:08:24 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212040824.GA12346@Krystal>
References: <20090210222115.GN6742@linux.vnet.ibm.com> <20090211005701.GA550@Krystal> <20090211052828.GQ6742@linux.vnet.ibm.com> <20090211063520.GE8132@Krystal> <20090211153246.GA6694@linux.vnet.ibm.com> <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090212023308.GA21157@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:07:22 up 42 days,  4:05,  4 users,  load average: 0.39, 0.30,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > 
> > [ . . . ]
> > 
> > > > > Hrm, let me present it in a different, more straightfoward way :
> > > > > 
> > > > > In you Promela model (here : http://lkml.org/lkml/2009/2/10/419)
> > > > > 
> > > > > There is a memory barrier here in the updater :
> > > > > 
> > > > > 	do
> > > > > 	:: 1 ->
> > > > > 		if
> > > > > 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > > > 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > > > 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > > > 			skip;
> > > > > 		:: else -> break;
> > > > > 		fi
> > > > > 	od;
> > > > > 	need_mb = 1;
> > > > > 	do
> > > > > 	:: need_mb == 1 -> skip;
> > > > > 	:: need_mb == 0 -> break;
> > > > > 	od;
> > > > > 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > > 
> > > > I believe you were actually looking for a memory barrier here, not?
> > > > I do not believe that your urcu.c has a memory barrier here, please
> > > > see below.
> > > > 
> > > > > 	do
> > > > > 	:: 1 ->
> > > > > 		if
> > > > > 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > > > 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > > > 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > > > 			skip;
> > > > > 		:: else -> break;
> > > > > 		fi;
> > > > > 	od;
> > > > > 
> > > > > However, in your C code of nest_32.c, there is none. So it is at the
> > > > > very least an inconsistency between your code and your model.
> > > > 
> > > > The urcu.c 3a9e6e9df706b8d39af94d2f027210e2e7d4106e lays out as follows:
> > > > 
> > > > synchronize_rcu()
> > > > 
> > > > 	switch_qparity()
> > > > 
> > > > 		force_mb_all_threads()
> > > > 
> > > > 		switch_next_urcu_qparity()  [Just does counter flip]
> > > > 
> > > 
> > > Hrm... there would potentially be a missing mb() here.
> > 
> > K, I added it to the model.
> > 
> > > > 		wait_for_quiescent_state()
> > > > 
> > > > 			Wait for all threads
> > > > 
> > > > 			force_mb_all_threads()
> > > > 				My model does not represent this
> > > > 				memory barrier, because it seemed to
> > > > 				me that it was redundant with the
> > > > 				following one.
> > > > 
> > > 
> > > Yes, this one is redundant.
> > 
> > I left it in for now...
> > 
> > > > 				I added it, no effect.
> > > > 
> > > > 	switch_qparity()
> > > > 
> > > > 		force_mb_all_threads()
> > > > 
> > > > 		switch_next_urcu_qparity()  [Just does counter flip]
> > > > 
> > > 
> > > Same as above, potentially missing mb().
> > 
> > I added it to the model.
> > 
> > > > 		wait_for_quiescent_state()
> > > > 
> > > > 			Wait for all threads
> > > > 
> > > > 			force_mb_all_threads()
> > > > 
> > > > The rcu_nest32.c 6da793208a8f60ea41df60164ded85b4c5c5307d lays out as
> > > > follows:
> > > > 
> > > > synchronize_rcu()
> > > > 
> > > > 	flip_counter_and_wait()
> > > > 
> > > > 		flips counter
> > > > 
> > > > 		smp_mb();
> > > > 
> > > > 		Wait for threads
> > > > 
> > > 
> > > this is the point where I wonder if we should add a mb() to your code.
> > 
> > Might well be, though I would argue for the very end, where I left out
> > the smp_mb().  I clearly need to make another Promela model for this
> > code, but we should probably focus on yours first, given that I don't
> > have any use cases for mine.
> > 
> > > > 	flip_counter_and_wait()
> > > > 
> > > > 		flips counter
> > > > 
> > > > 		smp_mb();
> > > > 
> > > > 		Wait for threads
> > 
> > And I really do have an unlock followed by an smp_mb() at this point.
> > 
> > > > So, if I am reading the code correctly, I have memory barriers
> > > > everywhere you don't and vice versa.  ;-)
> > > > 
> > > 
> > > Exactly. You have mb() between 
> > > flips counter and (next) Wait for threads
> > > 
> > > I have mb() between
> > > (previous) Wait for threads and flips counter
> > > 
> > > Both might be required. Or none. :)
> > 
> > Well, adding in the two to yours still gets Promela failures, please
> > see attached.  Nothing quite like a multi-thousand step failure case,
> > I have to admit!  ;-)
> > 
> > > > The reason that I believe that I do not need a memory barrier between
> > > > the wait-for-threads and the subsequent flip is that the threads we
> > > > are waiting for have to have already committed to the earlier value of
> > > > the counter, and so changing the counter out of order has no effect.
> > > > 
> > > > Does this make sense, or am I confused?
> > > 
> > > So if we remove the mb() as in your code, between the flips counter and
> > > (next) Wait for thread, we are doing these operations in random order at
> > > the write site:
> > 
> > I don't believe that I get to remove and mb()s from my code...
> > 
> > > Sequence 1 - what we expect
> > > A.1 - flip counter
> > > A.2 - read counter
> > > B   - read other threads urcu_active_readers
> > > 
> > > So what happens if the CPU decides to reorder the unrelated
> > > operations? We get :
> > > 
> > > Sequence 2
> > > B   - read other threads urcu_active_readers
> > > A.1 - flip counter
> > > A.2 - read counter
> > > 
> > > Sequence 3
> > > A.1 - flip counter
> > > A.2 - read counter
> > > B   - read other threads urcu_active_readers
> > > 
> > > Sequence 4
> > > A.1 - flip counter
> > > B   - read other threads urcu_active_readers
> > > A.2 - read counter
> > > 
> > > 
> > > Sequence 1, 3 and 4 are OK because the counter flip happens before we
> > > read other thread's urcu_active_readers counts.
> > > 
> > > However, we have to consider Sequence 2 carefully, because we will read
> > > other threads uru_active_readers count before those readers see that we
> > > flipped the counter.
> > > 
> > > The reader side does either :
> > > 
> > > seq. 1
> > > R.1 - read urcu_active_readers
> > > S.2 - read counter
> > > RS.2- write urcu_active_readers, depends on read counter and read
> > >       urcu_active_readers
> > > 
> > > (with R.1 and S.2 in random order)
> > > 
> > > or
> > > 
> > > seq. 2
> > > R.1 - read urcu_active_readers
> > > R.2 - write urcu_active_readers, depends on read urcu_active_readers
> > > 
> > > 
> > > So we could have the following reader+writer sequence :
> > > 
> > > Interleaved writer Sequence 2 and reader seq. 1.
> > > 
> > > Reader:
> > > R.1 - read urcu_active_readers
> > > S.2 - read counter
> > > Writer:
> > > B   - read other threads urcu_active_readers (there are none)
> > > A.1 - flip counter
> > > A.2 - read counter
> > > Reader:
> > > RS.2- write urcu_active_readers, depends on read counter and read
> > >       urcu_active_readers
> > > 
> > > Here, the reader would have updated its counter as belonging to the old
> > > q.s. period, but the writer will later wait for the new period. But
> > > given the writer will eventually do a second flip+wait, the reader in
> > > the other q.s. window will be caught by the second flip.
> > > 
> > > Therefore, we could be tempted to think that those mb() could be
> > > unnecessary, which would lead to a scheme where urcu_active_readers and
> > > urcu_gp_ctr are done in a completely random order one vs the other.
> > > Let's see what it gives :
> > > 
> > > synchronize_rcu()
> > > 
> > >   force_mb_all_threads()  /*
> > >                            * Orders pointer publication and 
> > >                            * (urcu_active_readers/urcu_gp_ctr accesses)
> > >                            */
> > >   switch_qparity()
> > > 
> > >     switch_next_urcu_qparity()  [just does counter flip 0->1]
> > > 
> > >     wait_for_quiescent_state()
> > > 
> > >       wait for all threads in parity 0
> > > 
> > >   switch_qparity()
> > > 
> > >     switch_next_urcu_qparity()  [Just does counter flip 1->0]
> > > 
> > >     wait_for_quiescent_state()
> > > 
> > >       Wait for all threads in parity 1
> > > 
> > >   force_mb_all_threads()  /*
> > >                            * Orders
> > >                            * (urcu_active_readers/urcu_gp_ctr accesses)
> > >                            * and old data removal.
> > >                            */
> > > 
> > > 
> > > 
> > > *but* ! There is a reason why we don't want to do this. If
> > > 
> > >     switch_next_urcu_qparity()  [Just does counter flip 1->0]
> > > 
> > > happens before the end of the previous
> > > 
> > >       Wait for all threads in parity 0
> > > 
> > > We enter in a situation where all newly coming readers will see the
> > > parity bit as 0, although we are still waiting for that parity to end.
> > > We end up in a state when the writer can be blocked forever (no possible
> > > progress) if there are steadily readers subscribed for the data.
> > > 
> > > Basically, to put it differently, we could simply remove the bit
> > > flipping from the writer and wait for *all* readers to exit their
> > > critical section (even the ones simply interested in the new pointer).
> > > But this shares the same problem the version above has, which is that we
> > > end up in a situation where the writer won't progress if there are
> > > always readers in a critical section.
> > > 
> > > The same applies to 
> > > 
> > >     switch_next_urcu_qparity()  [Just does counter flip 0->1]
> > > 
> > >       wait for all threads in parity 0
> > > 
> > > If we don't put a mb() between those two (as I mistakenly did), we can
> > > end up waiting for readers in parity 0 while the parity bit wasn't
> > > flipped yet. oops. Same potential no-progress situation.
> > > 
> > > The ordering of memory reads in the reader for
> > > urcu_active_readers/urcu_gp_ctr accesses does not seem to matter because
> > > the data contains information about which q.s. period parity it is in.
> > > In whichever order those variables are read seems to all work fine.
> > > 
> > > In the end, it's to insure that the writer will always progress that we
> > > have to enforce smp_mb() between *all* switch_next_urcu_qparity and wait
> > > for threads. Mine and yours.
> > > 
> > > Or maybe there is a detail I haven't correctly understood that insures
> > > this already without the mb() in your code ?
> > > 
> > > > (BTW, I do not trust my model yet, as it currently cannot detect the
> > > > failure case I pointed out earlier.  :-/  Here and I thought that the
> > > > point of such models was to detect additional failure cases!!!)
> > > > 
> > > 
> > > Yes, I'll have to dig deeper into it.
> > 
> > Well, as I said, I attached the current model and the error trail.
> 
> And I had bugs in my model that allowed the rcu_read_lock() model
> to nest indefinitely, which overflowed into the top bit, messing
> things up.  :-/
> 
> Attached is a fixed model.  This model validates correctly (woo-hoo!).
> Even better, gives the expected error if you comment out line 180 and
> uncomment line 213, this latter corresponding to the error case I called
> out a few days ago.
> 

Great ! :) I added this version to the git repository, hopefully it's ok
with you ?

> I will play with removing models of mb...
> 

OK, I see you already did..

Mathieu

> 							Thanx, Paul

Content-Description: urcu.spin
> /*
>  * urcu.spin: Promela code to validate urcu.  See commit number
>  *	3a9e6e9df706b8d39af94d2f027210e2e7d4106e of Mathieu Desnoyer's
>  *      git archive at git://lttng.org/userspace-rcu.git
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, write to the Free Software
>  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>  *
>  * Copyright (c) 2009 Paul E. McKenney, IBM Corporation.
>  */
> 
> /* Promela validation variables. */
> 
> bit removed = 0;  /* Has RCU removal happened, e.g., list_del_rcu()? */
> bit free = 0;     /* Has RCU reclamation happened, e.g., kfree()? */
> bit need_mb = 0;  /* =1 says need reader mb, =0 for reader response. */
> byte reader_progress[4];
> 		  /* Count of read-side statement executions. */
> 
> /* urcu definitions and variables, taken straight from the algorithm. */
> 
> #define RCU_GP_CTR_BIT (1 << 7)
> #define RCU_GP_CTR_NEST_MASK (RCU_GP_CTR_BIT - 1)
> 
> byte urcu_gp_ctr = 1;
> byte urcu_active_readers = 0;
> 
> /* Model the RCU read-side critical section. */
> 
> proctype urcu_reader()
> {
> 	bit done = 0;
> 	bit mbok;
> 	byte tmp;
> 	byte tmp_removed;
> 	byte tmp_free;
> 
> 	/* Absorb any early requests for memory barriers. */
> 	do
> 	:: need_mb == 1 ->
> 		need_mb = 0;
> 	:: 1 -> skip;
> 	:: 1 -> break;
> 	od;
> 
> 	/*
> 	 * Each pass through this loop executes one read-side statement
> 	 * from the following code fragment:
> 	 *
> 	 *	rcu_read_lock(); [0a]
> 	 *	rcu_read_lock(); [0b]
> 	 *	p = rcu_dereference(global_p); [1]
> 	 *	x = p->data; [2]
> 	 *	rcu_read_unlock(); [3b]
> 	 *	rcu_read_unlock(); [3a]
> 	 *
> 	 * Because we are modeling a weak-memory machine, these statements
> 	 * can be seen in any order, the only restriction being that
> 	 * rcu_read_unlock() cannot precede the corresponding rcu_read_lock().
> 	 * The placement of the inner rcu_read_lock() and rcu_read_unlock()
> 	 * is non-deterministic, the above is but one possible placement.
> 	 * Intestingly enough, this model validates all possible placements
> 	 * of the inner rcu_read_lock() and rcu_read_unlock() statements,
> 	 * with the only constraint being that the rcu_read_lock() must
> 	 * precede the rcu_read_unlock().
> 	 *
> 	 * We also respond to memory-barrier requests, but only if our
> 	 * execution happens to be ordered.  If the current state is
> 	 * misordered, we ignore memory-barrier requests.
> 	 */
> 	do
> 	:: 1 ->
> 		if
> 		:: reader_progress[0] < 2 -> /* [0a and 0b] */
> 			tmp = urcu_active_readers;
> 			if
> 			:: (tmp & RCU_GP_CTR_NEST_MASK) == 0 ->
> 				tmp = urcu_gp_ctr;
> 				do
> 				:: (reader_progress[1] +
> 				    reader_progress[2] +
> 				    reader_progress[3] == 0) && need_mb == 1 ->
> 					need_mb = 0;
> 				:: 1 -> skip;
> 				:: 1 -> break;
> 				od;
> 				urcu_active_readers = tmp;
> 			 :: else ->
> 				urcu_active_readers = tmp + 1;
> 			fi;
> 			reader_progress[0] = reader_progress[0] + 1;
> 		:: reader_progress[1] == 0 -> /* [1] */
> 			tmp_removed = removed;
> 			reader_progress[1] = 1;
> 		:: reader_progress[2] == 0 -> /* [2] */
> 			tmp_free = free;
> 			reader_progress[2] = 1;
> 		:: ((reader_progress[0] > reader_progress[3]) &&
> 		    (reader_progress[3] < 2)) -> /* [3a and 3b] */
> 			tmp = urcu_active_readers - 1;
> 			urcu_active_readers = tmp;
> 			reader_progress[3] = reader_progress[3] + 1;
> 		:: else -> break;
> 		fi;
> 
> 		/* Process memory-barrier requests, if it is safe to do so. */
> 		atomic {
> 			mbok = 0;
> 			tmp = 0;
> 			do
> 			:: tmp < 4 && reader_progress[tmp] == 0 ->
> 				tmp = tmp + 1;
> 				break;
> 			:: tmp < 4 && reader_progress[tmp] != 0 ->
> 				tmp = tmp + 1;
> 			:: tmp >= 4 ->
> 				done = 1;
> 				break;
> 			od;
> 			do
> 			:: tmp < 4 && reader_progress[tmp] == 0 ->
> 				tmp = tmp + 1;
> 			:: tmp < 4 && reader_progress[tmp] != 0 ->
> 				break;
> 			:: tmp >= 4 ->
> 				mbok = 1;
> 				break;
> 			od
> 
> 		}
> 
> 		if
> 		:: mbok == 1 ->
> 			/* We get here if mb processing is safe. */
> 			do
> 			:: need_mb == 1 ->
> 				need_mb = 0;
> 			:: 1 -> skip;
> 			:: 1 -> break;
> 			od;
> 		:: else -> skip;
> 		fi;
> 
> 		/*
> 		 * Check to see if we have modeled the entire RCU read-side
> 		 * critical section, and leave if so.
> 		 */
> 		if
> 		:: done == 1 -> break;
> 		:: else -> skip;
> 		fi
> 	od;
> 	assert((tmp_free == 0) || (tmp_removed == 1));
> 
> 	/* Process any late-arriving memory-barrier requests. */
> 	do
> 	:: need_mb == 1 ->
> 		need_mb = 0;
> 	:: 1 -> skip;
> 	:: 1 -> break;
> 	od;
> }
> 
> /* Model the RCU update process. */
> 
> proctype urcu_updater()
> {
> 	/* Removal statement, e.g., list_del_rcu(). */
> 	removed = 1;
> 
> 	/* synchronize_rcu(), first counter flip. */
> 	need_mb = 1;
> 	do
> 	:: need_mb == 1 -> skip;
> 	:: need_mb == 0 -> break;
> 	od;
> 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> 	need_mb = 1;
> 	do
> 	:: need_mb == 1 -> skip;
> 	:: need_mb == 0 -> break;
> 	od;
> 	do
> 	:: 1 ->
> 		printf("urcu_gp_ctr=%x urcu_active_readers=%x\n", urcu_gp_ctr, urcu_active_readers);
> 		printf("urcu_gp_ctr&0x7f=%x urcu_active_readers&0x7f=%x\n", urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK, urcu_active_readers & ~RCU_GP_CTR_NEST_MASK);
> 		if
> 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> 			skip;
> 		:: else -> break;
> 		fi
> 	od;
> 	need_mb = 1;
> 	do
> 	:: need_mb == 1 -> skip;
> 	:: need_mb == 0 -> break;
> 	od;
> 
> 	/* Erroneous removal statement, e.g., list_del_rcu(). */
> 	/* removed = 1; */
> 
> 	/* synchronize_rcu(), second counter flip. */
> 	need_mb = 1;
> 	do
> 	:: need_mb == 1 -> skip;
> 	:: need_mb == 0 -> break;
> 	od;
> 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> 	need_mb = 1;
> 	do
> 	:: need_mb == 1 -> skip;
> 	:: need_mb == 0 -> break;
> 	od;
> 	do
> 	:: 1 ->
> 		printf("urcu_gp_ctr=%x urcu_active_readers=%x\n", urcu_gp_ctr, urcu_active_readers);
> 		printf("urcu_gp_ctr&0x7f=%x urcu_active_readers&0x7f=%x\n", urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK, urcu_active_readers & ~RCU_GP_CTR_NEST_MASK);
> 		if
> 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> 			skip;
> 		:: else -> break;
> 		fi;
> 	od;
> 	need_mb = 1;
> 	do
> 	:: need_mb == 1 -> skip;
> 	:: need_mb == 0 -> break;
> 	od;
> 
> 	/* free-up step, e.g., kfree(). */
> 	free = 1;
> }
> 
> /*
>  * Initialize the array, spawn a reader and an updater.  Because readers
>  * are independent of each other, only one reader is needed.
>  */
> 
> init {
> 	atomic {
> 		reader_progress[0] = 0;
> 		reader_progress[1] = 0;
> 		reader_progress[2] = 0;
> 		reader_progress[3] = 0;
> 		run urcu_reader();
> 		run urcu_updater();
> 	}
> }


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
