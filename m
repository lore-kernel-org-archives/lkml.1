Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbZBLX0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbZBLX0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZBLX0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:26:24 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43290 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZBLX0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:26:23 -0500
Date: Thu, 12 Feb 2009 15:26:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212232621.GP6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212023707.GA21193@linux.vnet.ibm.com> <20090212041044.GA12612@Krystal> <20090212050909.GB8317@linux.vnet.ibm.com> <20090212054707.GA15577@Krystal> <20090212161805.GB6759@linux.vnet.ibm.com> <20090212184030.GA2047@Krystal> <20090212202829.GI6759@linux.vnet.ibm.com> <20090212212712.GB6135@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212212712.GB6135@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 04:27:12PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Feb 12, 2009 at 01:40:30PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Thu, Feb 12, 2009 at 12:47:07AM -0500, Mathieu Desnoyers wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Wed, Feb 11, 2009 at 11:10:44PM -0500, Mathieu Desnoyers wrote:
> > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > On Wed, Feb 11, 2009 at 06:33:08PM -0800, Paul E. McKenney wrote:
> > > > > > > > > On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > > > > > > > > > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > > > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > 
> > > > > > > > [ . . . ]
> > > > > > > > 
> > > > > > > > > > > > (BTW, I do not trust my model yet, as it currently cannot detect the
> > > > > > > > > > > > failure case I pointed out earlier.  :-/  Here and I thought that the
> > > > > > > > > > > > point of such models was to detect additional failure cases!!!)
> > > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > Yes, I'll have to dig deeper into it.
> > > > > > > > > > 
> > > > > > > > > > Well, as I said, I attached the current model and the error trail.
> > > > > > > > > 
> > > > > > > > > And I had bugs in my model that allowed the rcu_read_lock() model
> > > > > > > > > to nest indefinitely, which overflowed into the top bit, messing
> > > > > > > > > things up.  :-/
> > > > > > > > > 
> > > > > > > > > Attached is a fixed model.  This model validates correctly (woo-hoo!).
> > > > > > > > > Even better, gives the expected error if you comment out line 180 and
> > > > > > > > > uncomment line 213, this latter corresponding to the error case I called
> > > > > > > > > out a few days ago.
> > > > > > > > > 
> > > > > > > > > I will play with removing models of mb...
> > > > > > > > 
> > > > > > > > And commenting out the models of mb between the counter flips and the
> > > > > > > > test for readers still passes validation, as expected, and as shown in
> > > > > > > > the attached Promela code.
> > > > > > > > 
> > > > > > > 
> > > > > > > Hrm, in the email I sent you about the memory barrier, I said that it
> > > > > > > would not make the algorithm incorrect, but that it would cause
> > > > > > > situations where it would be impossible for the writer to do any
> > > > > > > progress as long as there are readers active. I think we would have to
> > > > > > > enhance the model or at least express this through some LTL statement to
> > > > > > > validate this specific behavior.
> > > > > > 
> > > > > > But if the writer fails to make progress, then the counter remains at a
> > > > > > given value, which causes readers to drain, which allows the writer to
> > > > > > eventually make progress again.  Right?
> > > > > > 
> > > > > 
> > > > > Not necessarily. If we don't have the proper memory barriers, we can
> > > > > have the writer waiting on, say, parity 0 *before* it has performed the
> > > > > parity switch. Therefore, even newly coming readers will add up to
> > > > > parity 0.
> > > > 
> > > > But the write that changes the parity will eventually make it out.
> > > > OK, so your argument is that we at least need a compiler barrier?
> > > 
> > > It all depends on the assumptions we make. I am currently trying to
> > > assume the most aggressive memory ordering I can think of. The model I
> > > think about to represent it is that memory reads/writes are kept local
> > > to the CPU until a memory barrier is encountered. I doubt it exists in
> > > practice, bacause the CPU will eventually have to commit the information
> > > to memory (hrm, are sure about this ?), but if we use that as a starting
> > > point, I think this would cover the entire spectrum of possible memory
> > > barriers issues. Also, it would be easy to verify formally. But maybe am
> > > I going too far ?
> > 
> > I believe that you are going a bit too far.  After all, if you make that
> > assumption, the CPU could just never make anything visible.  After all,
> > the memory barrier doesn't say "make the previous stuff visible now",
> > it instead says "if you make anything after the barrier visible to a
> > given other CPU, then you must also make everything before the barrier
> > visible to that CPU".
> > 
> > > > Regardless, please see attached for a modified version of the Promela
> > > > model that fully models omitting out the memory barrier that my
> > > > rcu_nest32.[hc] implementation omits.  (It is possible to partially
> > > > model removal of other memory barriers via #if 0, but to fully model
> > > > would need to enumerate the permutations as shown on lines 231-257.)
> > > > 
> > > > > In your model, this is not detected, because eventually all readers will
> > > > > execute, and only then the writer will be able to update the data. But
> > > > > in reality, if we run a very busy 4096-cores machines where there is
> > > > > always at least one reader active, the the writer will be stuck forever,
> > > > > and that's really bad.
> > > > 
> > > > Assuming that the reordering is done by the CPU, the write will
> > > > eventually get out -- it is stuck in (say) the store buffer, and the
> > > > cache line will eventually arrive, and then the value will eventually
> > > > be seen by the readers.
> > > 
> > > Do we have guarantees that the data *will necessarily* get out of the
> > > cpu write buffer at some point ?
> > 
> > It has to, given a finite CPU write buffer, interrupts, and the like.
> > The actual CPU designs interact with a cache-coherence protocol, so
> > the stuff lives in the store buffer only for as long as it takes for
> > the corresponding cache line to be owned by this CPU.
> > 
> > > > We might need a -compiler- barrier, but then again, I am not sure that
> > > > we are talking about the same memory barrier -- again, please see
> > > > attached lines 231-257 to see which one that I eliminated.
> > > 
> > > As long as we don't have "progress" validation to check our model, the
> > > fact that it passes the current test does not tell much.
> > 
> > Without agreeing or disagreeing with this statement for the moment,
> > would you be willing to tell me whether or not the memory barrier
> > eliminated by lines 231-257 of the model was the one that you were
> > talking about?  ;-)
> > 
> 
> So we are taking about :
> 
> /* current synchronize_rcu(), first-flip check plus second flip. */
> 
> which does not have any memory barrier anymore. This corresponds to my
> current :
> 
>        /*
>          * Wait for previous parity to be empty of readers.
>          */
>         wait_for_quiescent_state();     /* Wait readers in parity 0 */
> 
>         /*
>          * Must finish waiting for quiescent state for parity 0 before
>          * committing qparity update to memory. Failure to do so could result in
>          * the writer waiting forever while new readers are always accessing
>          * data (no progress).
>          */
>         smp_mc();
> 
>         switch_next_urcu_qparity();     /* 1 -> 0 */
> 
> So the memory barrier is not needed, but a compiler barrier is needed on
> arch with cache coherency, and a cache flush is needed on architectures
> without cache coherency.
> 
> BTW, I think all the three smp_mb() that were in this function can be
> turned into smp_mc().

Verifying this requires merging more code into the interleaving -- it
is necessary to model all permutations of the statements.  Even that
isn't always quite right, as Promela treats each statement as atomic.
(I might be able to pull a trick like I did on the read side, but the
data dependencies are a bit uglier on the update side.)

That said, I did do a crude check by #if-ing out the individual barriers
on the update side.  This is semi-plausible, because the read side is
primarily unordered.  The results are that the final memory barrier
(just before exiting synchronize_rcu()) is absolutely required, as is
at least one of the first two memory barriers.

But I don't trust this analysis -- it is an approximation to an
approximation, which is not what you want for this sort of job.

> Therefore, if we assume memory coherency, only barrier()s would be
> needed between the switch/q.s. wait/switch/q.s. wait.

I must admit that the need to assume that some platforms fail to
implement cache coherence comes as a bit of a nasty shock...

							Thanx, Paul

> Mathieu
> 
> 
> > I might consider eventually adding progress validation to the model,
> > but am currently a bit overdosed on Promela...
> > 
> > > > Also, the original model I sent out has a minor bug that prevents it
> > > > from fully modeling the nested-read-side case.  The patch below fixes this.
> > > 
> > > Ok, merging the fix, thanks,
> > 
> > Thank you!
> > 
> > 							Thanx, Paul
> > 
> > > Mathieu
> > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > ---
> > > > 
> > > >  urcu.spin |    6 +++++-
> > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
> > > > index e5bfff3..611464b 100644
> > > > --- a/formal-model/urcu.spin
> > > > +++ b/formal-model/urcu.spin
> > > > @@ -124,9 +124,13 @@ proctype urcu_reader()
> > > >  				break;
> > > >  			:: tmp < 4 && reader_progress[tmp] != 0 ->
> > > >  				tmp = tmp + 1;
> > > > -			:: tmp >= 4 ->
> > > > +			:: tmp >= 4 &&
> > > > +			   reader_progress[0] == reader_progress[3] ->
> > > >  				done = 1;
> > > >  				break;
> > > > +			:: tmp >= 4 &&
> > > > +			   reader_progress[0] != reader_progress[3] ->
> > > > +			   	break;
> > > >  			od;
> > > >  			do
> > > >  			:: tmp < 4 && reader_progress[tmp] == 0 ->
> > > 
> > > Content-Description: urcu_mbmin.spin
> > > > /*
> > > >  * urcu_mbmin.spin: Promela code to validate urcu.  See commit number
> > > >  *	3a9e6e9df706b8d39af94d2f027210e2e7d4106e of Mathieu Desnoyer's
> > > >  *      git archive at git://lttng.org/userspace-rcu.git, but with
> > > >  *	memory barriers removed.
> > > >  *
> > > >  * This program is free software; you can redistribute it and/or modify
> > > >  * it under the terms of the GNU General Public License as published by
> > > >  * the Free Software Foundation; either version 2 of the License, or
> > > >  * (at your option) any later version.
> > > >  *
> > > >  * This program is distributed in the hope that it will be useful,
> > > >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > >  * GNU General Public License for more details.
> > > >  *
> > > >  * You should have received a copy of the GNU General Public License
> > > >  * along with this program; if not, write to the Free Software
> > > >  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > > >  *
> > > >  * Copyright (c) 2009 Paul E. McKenney, IBM Corporation.
> > > >  */
> > > > 
> > > > /* Promela validation variables. */
> > > > 
> > > > bit removed = 0;  /* Has RCU removal happened, e.g., list_del_rcu()? */
> > > > bit free = 0;     /* Has RCU reclamation happened, e.g., kfree()? */
> > > > bit need_mb = 0;  /* =1 says need reader mb, =0 for reader response. */
> > > > byte reader_progress[4];
> > > > 		  /* Count of read-side statement executions. */
> > > > 
> > > > /* urcu definitions and variables, taken straight from the algorithm. */
> > > > 
> > > > #define RCU_GP_CTR_BIT (1 << 7)
> > > > #define RCU_GP_CTR_NEST_MASK (RCU_GP_CTR_BIT - 1)
> > > > 
> > > > byte urcu_gp_ctr = 1;
> > > > byte urcu_active_readers = 0;
> > > > 
> > > > /* Model the RCU read-side critical section. */
> > > > 
> > > > proctype urcu_reader()
> > > > {
> > > > 	bit done = 0;
> > > > 	bit mbok;
> > > > 	byte tmp;
> > > > 	byte tmp_removed;
> > > > 	byte tmp_free;
> > > > 
> > > > 	/* Absorb any early requests for memory barriers. */
> > > > 	do
> > > > 	:: need_mb == 1 ->
> > > > 		need_mb = 0;
> > > > 	:: 1 -> skip;
> > > > 	:: 1 -> break;
> > > > 	od;
> > > > 
> > > > 	/*
> > > > 	 * Each pass through this loop executes one read-side statement
> > > > 	 * from the following code fragment:
> > > > 	 *
> > > > 	 *	rcu_read_lock(); [0a]
> > > > 	 *	rcu_read_lock(); [0b]
> > > > 	 *	p = rcu_dereference(global_p); [1]
> > > > 	 *	x = p->data; [2]
> > > > 	 *	rcu_read_unlock(); [3b]
> > > > 	 *	rcu_read_unlock(); [3a]
> > > > 	 *
> > > > 	 * Because we are modeling a weak-memory machine, these statements
> > > > 	 * can be seen in any order, the only restriction being that
> > > > 	 * rcu_read_unlock() cannot precede the corresponding rcu_read_lock().
> > > > 	 * The placement of the inner rcu_read_lock() and rcu_read_unlock()
> > > > 	 * is non-deterministic, the above is but one possible placement.
> > > > 	 * Intestingly enough, this model validates all possible placements
> > > > 	 * of the inner rcu_read_lock() and rcu_read_unlock() statements,
> > > > 	 * with the only constraint being that the rcu_read_lock() must
> > > > 	 * precede the rcu_read_unlock().
> > > > 	 *
> > > > 	 * We also respond to memory-barrier requests, but only if our
> > > > 	 * execution happens to be ordered.  If the current state is
> > > > 	 * misordered, we ignore memory-barrier requests.
> > > > 	 */
> > > > 	do
> > > > 	:: 1 ->
> > > > 		if
> > > > 		:: reader_progress[0] < 2 -> /* [0a and 0b] */
> > > > 			tmp = urcu_active_readers;
> > > > 			if
> > > > 			:: (tmp & RCU_GP_CTR_NEST_MASK) == 0 ->
> > > > 				tmp = urcu_gp_ctr;
> > > > 				do
> > > > 				:: (reader_progress[1] +
> > > > 				    reader_progress[2] +
> > > > 				    reader_progress[3] == 0) && need_mb == 1 ->
> > > > 					need_mb = 0;
> > > > 				:: 1 -> skip;
> > > > 				:: 1 -> break;
> > > > 				od;
> > > > 				urcu_active_readers = tmp;
> > > > 			 :: else ->
> > > > 				urcu_active_readers = tmp + 1;
> > > > 			fi;
> > > > 			reader_progress[0] = reader_progress[0] + 1;
> > > > 		:: reader_progress[1] == 0 -> /* [1] */
> > > > 			tmp_removed = removed;
> > > > 			reader_progress[1] = 1;
> > > > 		:: reader_progress[2] == 0 -> /* [2] */
> > > > 			tmp_free = free;
> > > > 			reader_progress[2] = 1;
> > > > 		:: ((reader_progress[0] > reader_progress[3]) &&
> > > > 		    (reader_progress[3] < 2)) -> /* [3a and 3b] */
> > > > 			tmp = urcu_active_readers - 1;
> > > > 			urcu_active_readers = tmp;
> > > > 			reader_progress[3] = reader_progress[3] + 1;
> > > > 		:: else -> break;
> > > > 		fi;
> > > > 
> > > > 		/* Process memory-barrier requests, if it is safe to do so. */
> > > > 		atomic {
> > > > 			mbok = 0;
> > > > 			tmp = 0;
> > > > 			do
> > > > 			:: tmp < 4 && reader_progress[tmp] == 0 ->
> > > > 				tmp = tmp + 1;
> > > > 				break;
> > > > 			:: tmp < 4 && reader_progress[tmp] != 0 ->
> > > > 				tmp = tmp + 1;
> > > > 			:: tmp >= 4 &&
> > > > 			   reader_progress[0] == reader_progress[3] ->
> > > > 				done = 1;
> > > > 				break;
> > > > 			:: tmp >= 4 &&
> > > > 			   reader_progress[0] != reader_progress[3] ->
> > > > 			   	break;
> > > > 			od;
> > > > 			do
> > > > 			:: tmp < 4 && reader_progress[tmp] == 0 ->
> > > > 				tmp = tmp + 1;
> > > > 			:: tmp < 4 && reader_progress[tmp] != 0 ->
> > > > 				break;
> > > > 			:: tmp >= 4 ->
> > > > 				mbok = 1;
> > > > 				break;
> > > > 			od
> > > > 
> > > > 		}
> > > > 
> > > > 		if
> > > > 		:: mbok == 1 ->
> > > > 			/* We get here if mb processing is safe. */
> > > > 			do
> > > > 			:: need_mb == 1 ->
> > > > 				need_mb = 0;
> > > > 			:: 1 -> skip;
> > > > 			:: 1 -> break;
> > > > 			od;
> > > > 		:: else -> skip;
> > > > 		fi;
> > > > 
> > > > 		/*
> > > > 		 * Check to see if we have modeled the entire RCU read-side
> > > > 		 * critical section, and leave if so.
> > > > 		 */
> > > > 		if
> > > > 		:: done == 1 -> break;
> > > > 		:: else -> skip;
> > > > 		fi
> > > > 	od;
> > > > 	assert((tmp_free == 0) || (tmp_removed == 1));
> > > > 
> > > > 	/* Process any late-arriving memory-barrier requests. */
> > > > 	do
> > > > 	:: need_mb == 1 ->
> > > > 		need_mb = 0;
> > > > 	:: 1 -> skip;
> > > > 	:: 1 -> break;
> > > > 	od;
> > > > }
> > > > 
> > > > /* Model the RCU update process. */
> > > > 
> > > > proctype urcu_updater()
> > > > {
> > > > 	byte tmp;
> > > > 
> > > > 	/* prior synchronize_rcu(), second counter flip. */
> > > > 	need_mb = 1; /* mb() A */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > > 	need_mb = 1; /* mb() B */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 	do
> > > > 	:: 1 ->
> > > > 		if
> > > > 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > > 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > > 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > > 			skip;
> > > > 		:: else -> break;
> > > > 		fi
> > > > 	od;
> > > > 	need_mb = 1; /* mb() C absolutely required by analogy with G */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 
> > > > 	/* Removal statement, e.g., list_del_rcu(). */
> > > > 	removed = 1;
> > > > 
> > > > 	/* current synchronize_rcu(), first counter flip. */
> > > > 	need_mb = 1; /* mb() D suggested */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > > 	need_mb = 1;  /* mb() E required if D not present */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 
> > > > 	/* current synchronize_rcu(), first-flip check plus second flip. */
> > > > 	if
> > > > 	:: 1 ->
> > > > 		do
> > > > 		:: 1 ->
> > > > 			if
> > > > 			:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > > 			   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > > 			   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > > 				skip;
> > > > 			:: else -> break;
> > > > 			fi;
> > > > 		od;
> > > > 		urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > > 	:: 1 ->
> > > > 		tmp = urcu_gp_ctr;
> > > > 		urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> > > > 		do
> > > > 		:: 1 ->
> > > > 			if
> > > > 			:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > > 			   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > > 			   (tmp & ~RCU_GP_CTR_NEST_MASK) ->
> > > > 				skip;
> > > > 			:: else -> break;
> > > > 			fi;
> > > > 		od;
> > > > 	fi;
> > > > 
> > > > 	/* current synchronize_rcu(), second counter flip check. */
> > > > 	need_mb = 1; /* mb() F not required */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 	do
> > > > 	:: 1 ->
> > > > 		if
> > > > 		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
> > > > 		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
> > > > 		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
> > > > 			skip;
> > > > 		:: else -> break;
> > > > 		fi;
> > > > 	od;
> > > > 	need_mb = 1; /* mb() G absolutely required */
> > > > 	do
> > > > 	:: need_mb == 1 -> skip;
> > > > 	:: need_mb == 0 -> break;
> > > > 	od;
> > > > 
> > > > 	/* free-up step, e.g., kfree(). */
> > > > 	free = 1;
> > > > }
> > > > 
> > > > /*
> > > >  * Initialize the array, spawn a reader and an updater.  Because readers
> > > >  * are independent of each other, only one reader is needed.
> > > >  */
> > > > 
> > > > init {
> > > > 	atomic {
> > > > 		reader_progress[0] = 0;
> > > > 		reader_progress[1] = 0;
> > > > 		reader_progress[2] = 0;
> > > > 		reader_progress[3] = 0;
> > > > 		run urcu_reader();
> > > > 		run urcu_updater();
> > > > 	}
> > > > }
> > > 
> > > 
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
