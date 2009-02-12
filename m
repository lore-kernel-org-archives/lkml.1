Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZBLFrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZBLFrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 00:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZBLFrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 00:47:12 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:50479 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZBLFrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:47:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQFAPhBk0lMQWt2/2dsb2JhbACBbtI4hBsG
Date: Thu, 12 Feb 2009 00:47:07 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212054707.GA15577@Krystal>
References: <20090211063520.GE8132@Krystal> <20090211153246.GA6694@linux.vnet.ibm.com> <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212023707.GA21193@linux.vnet.ibm.com> <20090212041044.GA12612@Krystal> <20090212050909.GB8317@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090212050909.GB8317@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:43:09 up 42 days,  5:41,  7 users,  load average: 0.19, 0.21,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Feb 11, 2009 at 11:10:44PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Wed, Feb 11, 2009 at 06:33:08PM -0800, Paul E. McKenney wrote:
> > > > On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > > > > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > 
> > > [ . . . ]
> > > 
> > > > > > > (BTW, I do not trust my model yet, as it currently cannot detect the
> > > > > > > failure case I pointed out earlier.  :-/  Here and I thought that the
> > > > > > > point of such models was to detect additional failure cases!!!)
> > > > > > > 
> > > > > > 
> > > > > > Yes, I'll have to dig deeper into it.
> > > > > 
> > > > > Well, as I said, I attached the current model and the error trail.
> > > > 
> > > > And I had bugs in my model that allowed the rcu_read_lock() model
> > > > to nest indefinitely, which overflowed into the top bit, messing
> > > > things up.  :-/
> > > > 
> > > > Attached is a fixed model.  This model validates correctly (woo-hoo!).
> > > > Even better, gives the expected error if you comment out line 180 and
> > > > uncomment line 213, this latter corresponding to the error case I called
> > > > out a few days ago.
> > > > 
> > > > I will play with removing models of mb...
> > > 
> > > And commenting out the models of mb between the counter flips and the
> > > test for readers still passes validation, as expected, and as shown in
> > > the attached Promela code.
> > > 
> > 
> > Hrm, in the email I sent you about the memory barrier, I said that it
> > would not make the algorithm incorrect, but that it would cause
> > situations where it would be impossible for the writer to do any
> > progress as long as there are readers active. I think we would have to
> > enhance the model or at least express this through some LTL statement to
> > validate this specific behavior.
> 
> But if the writer fails to make progress, then the counter remains at a
> given value, which causes readers to drain, which allows the writer to
> eventually make progress again.  Right?
> 

Not necessarily. If we don't have the proper memory barriers, we can
have the writer waiting on, say, parity 0 *before* it has performed the
parity switch. Therefore, even newly coming readers will add up to
parity 0.

In your model, this is not detected, because eventually all readers will
execute, and only then the writer will be able to update the data. But
in reality, if we run a very busy 4096-cores machines where there is
always at least one reader active, the the writer will be stuck forever,
and that's really bad.

Mathieu

> 						Thanx, Paul
> 
> > Mathieu
> > 
> > > 						Thanx, Paul
> > 
> > Content-Description: urcu.spin
> > > /*
> > >  * urcu.spin: Promela code to validate urcu.  See commit number
> > >  *	3a9e6e9df706b8d39af94d2f027210e2e7d4106e of Mathieu Desnoyer's
> > >  *      git archive at git://lttng.org/userspace-rcu.git
> > >  *
> > >  * This program is free software; you can redistribute it and/or modify
> > >  * it under the terms of the GNU General Public License as published by
> > >  * the Free Software Foundation; either version 2 of the License, or
> > >  * (at your option) any later version.
> > >  *
> > >  * This program is distributed in the hope that it will be useful,
> > >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > >  * GNU General Public License for more details.
> > >  *
> > >  * You should have received a copy of the GNU General Public License
> > >  * along with this program; if not, write to the Free Software
> > >  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > >  *
> > >  * Copyright (c) 2009 Paul E. McKenney, IBM Corporation.
> > >  */
> > > 
> > > /* Promela validation variables. */
> > > 
> > > bit removed = 0;  /* Has RCU removal happened, e.g., list_del_rcu()? */
> > > bit free = 0;     /* Has RCU reclamation happened, e.g., kfree()? */
> > > bit need_mb = 0;  /* =1 says need reader mb, =0 for reader response. */
> > > byte reader_progress[4];
> > > 		  /* Count of read-side statement executions. */
> > > 
> > > /* urcu definitions and variables, taken straight from the algorithm. */
> > > 
> > > #define RCU_GP_CTR_BIT (1 << 7)
> > > #define RCU_GP_CTR_NEST_MASK (RCU_GP_CTR_BIT - 1)
> > > 
> > > byte urcu_gp_ctr = 1;
> > > byte urcu_active_readers = 0;
> > > 
> > > /* Model the RCU read-side critical section. */
> > > 
> > > proctype urcu_reader()
> > > {
> > > 	bit done = 0;
> > > 	bit mbok;
> > > 	byte tmp;
> > > 	byte tmp_removed;
> > > 	byte tmp_free;
> > > 
> > > 	/* Absorb any early requests for memory barriers. */
> > > 	do
> > > 	:: need_mb == 1 ->
> > > 		need_mb = 0;
> > > 	:: 1 -> skip;
> > > 	:: 1 -> break;
> > > 	od;
> > > 
> > > 	/*
> > > 	 * Each pass through this loop executes one read-side statement
> > > 	 * from the following code fragment:
> > > 	 *
> > > 	 *	rcu_read_lock(); [0a]
> > > 	 *	rcu_read_lock(); [0b]
> > > 	 *	p = rcu_dereference(global_p); [1]
> > > 	 *	x = p->data; [2]
> > > 	 *	rcu_read_unlock(); [3b]
> > > 	 *	rcu_read_unlock(); [3a]
> > > 	 *
> > > 	 * Because we are modeling a weak-memory machine, these statements
> > > 	 * can be seen in any order, the only restriction being that
> > > 	 * rcu_read_unlock() cannot precede the corresponding rcu_read_lock().
> > > 	 * The placement of the inner rcu_read_lock() and rcu_read_unlock()
> > > 	 * is non-deterministic, the above is but one possible placement.
> > > 	 * Intestingly enough, this model validates all possible placements
> > > 	 * of the inner rcu_read_lock() and rcu_read_unlock() statements,
> > > 	 * with the only constraint being that the rcu_read_lock() must
> > > 	 * precede the rcu_read_unlock().
> > > 	 *
> > > 	 * We also respond to memory-barrier requests, but only if our
> > > 	 * execution happens to be ordered.  If the current state is
> > > 	 * misordered, we ignore memory-barrier requests.
> > > 	 */
> > > 	do
> > > 	:: 1 ->
> > > 		if
> > > 		:: reader_progress[0] < 2 -> /* [0a and 0b] */
> > > 			tmp = urcu_active_readers;
> > > 			if
> > > 			:: (tmp & RCU_GP_CTR_NEST_MASK) == 0 ->
> > > 				tmp = urcu_gp_ctr;
> > > 				do
> > > 				:: (reader_progress[1] +
> > > 				    reader_progress[2] +
> > > 				    reader_progress[3] == 0) && need_mb == 1 ->
> > > 					need_mb = 0;
> > > 				:: 1 -> skip;
> > > 				:: 1 -> break;
> > > 				od;
> > > 				urcu_active_readers = tmp;
> > > 			 :: else ->
> > > 				urcu_active_readers = tmp + 1;
> > > 			fi;
> > > 			reader_progress[0] = reader_progress[0] + 1;
> > > 		:: reader_progress[1] == 0 -> /* [1] */
> > > 			tmp_removed = removed;
> > > 			reader_progress[1] = 1;
> > > 		:: reader_progress[2] == 0 -> /* [2] */
> > > 			tmp_free = free;
> > > 			reader_progress[2] = 1;
> > > 		:: ((reader_progress[0] > reader_progress[3]) &&
> > > 		    (reader_progress[3] < 2)) -> /* [3a and 3b] */
> > > 			tmp = urcu_active_readers - 1;
> > > 			urcu_active_readers = tmp;
> > > 			reader_progress[3] = reader_progress[3] + 1;
> > > 		:: else -> break;
> > > 		fi;
> > > 
> > > 		/* Process memory-barrier requests, if it is safe to do so. */
> > > 		atomic {
> > > 			mbok = 0;
> > > 			tmp = 0;
> > > 			do
> > > 			:: tmp < 4 && reader_progress[tmp] == 0 ->
> > > 				tmp = tmp + 1;
> > > 				break;
> > > 			:: tmp < 4 && reader_progress[tmp] != 0 ->
> > > 				tmp = tmp + 1;
> > > 			:: tmp >= 4 ->
> > > 				done = 1;
> > > 				break;
> > > 			od;
> > > 			do
> > > 			:: tmp < 4 && reader_progress[tmp] == 0 ->
> > > 				tmp = tmp + 1;
> > > 			:: tmp < 4 && reader_progress[tmp] != 0 ->
> > > 				break;
> > > 			:: tmp >= 4 ->
> > > 				mbok = 1;
> > > 				break;
> > > 			od
> > > 
> > > 		}
> > > 
> > > 		if
> > > 		:: mbok == 1 ->
> > > 			/* We get here if mb processing is safe. */
> > > 			do
> > > 			:: need_mb == 1 ->
> > > 				need_mb = 0;
> > > 			:: 1 -> skip;
> > > 			:: 1 -> break;
> > > 			od;
> > > 		:: else -> skip;
> > > 		fi;
> > > 
> > > 		/*
> > > 		 * Check to see if we have modeled the entire RCU read-side
> > > 		 * critical section, and leave if so.
> > > 		 */
> > > 		if
> > > 		:: done == 1 -> break;
> > > 		:: else -> skip;
> > > 		fi
> > > 	od;
> > > 	assert((tmp_free == 0) || (tmp_removed == 1));
> > > 
> > > 	/* Process any late-arriving memory-barrier requests. */
> > > 	do
> > > 	:: need_mb == 1 ->
> > > 		need_mb = 0;
> > > 	:: 1 -> skip;
> > > 	:: 1 -> break;
> > > 	od;
> > > }
> > > 
> > > /* Model the RCU update process. */
> > > 
> > > proctype urcu_updater()
> > > {
> > > 	/* Removal statement, e.g., list_del_rcu(). */
> > > 	removed = 1;
> > > 
> > > 	/* synchronize_rcu(), first counter flip. */
> > > 	need_mb = 1;
> > > 	do
> > > 	:: need_mb == 1 -> skip;
> > > 	:: need_mb == 0 -> break;
> > > 	od;
> > > 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > 	/* need_mb = 1;
> > > 	do
> > > 	:: need_mb == 1 -> skip;
> > > 	:: need_mb == 0 -> break;
> > > 	od; */
> > > 	do
> > > 	:: 1 ->
> > > 		if
> > > 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > 			skip;
> > > 		:: else -> break;
> > > 		fi
> > > 	od;
> > > 	need_mb = 1;
> > > 	do
> > > 	:: need_mb == 1 -> skip;
> > > 	:: need_mb == 0 -> break;
> > > 	od;
> > > 
> > > 	/* Erroneous removal statement, e.g., list_del_rcu(). */
> > > 	/* removed = 1; */
> > > 
> > > 	/* synchronize_rcu(), second counter flip. */
> > > 	need_mb = 1;
> > > 	do
> > > 	:: need_mb == 1 -> skip;
> > > 	:: need_mb == 0 -> break;
> > > 	od;
> > > 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > 	/* need_mb = 1;
> > > 	do
> > > 	:: need_mb == 1 -> skip;
> > > 	:: need_mb == 0 -> break;
> > > 	od; */
> > > 	do
> > > 	:: 1 ->
> > > 		if
> > > 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > 			skip;
> > > 		:: else -> break;
> > > 		fi;
> > > 	od;
> > > 	need_mb = 1;
> > > 	do
> > > 	:: need_mb == 1 -> skip;
> > > 	:: need_mb == 0 -> break;
> > > 	od;
> > > 
> > > 	/* free-up step, e.g., kfree(). */
> > > 	free = 1;
> > > }
> > > 
> > > /*
> > >  * Initialize the array, spawn a reader and an updater.  Because readers
> > >  * are independent of each other, only one reader is needed.
> > >  */
> > > 
> > > init {
> > > 	atomic {
> > > 		reader_progress[0] = 0;
> > > 		reader_progress[1] = 0;
> > > 		reader_progress[2] = 0;
> > > 		reader_progress[3] = 0;
> > > 		run urcu_reader();
> > > 		run urcu_updater();
> > > 	}
> > > }
> > 
> > > _______________________________________________
> > > ltt-dev mailing list
> > > ltt-dev@lists.casi.polymtl.ca
> > > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
