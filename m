Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZBTSpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZBTSpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZBTSpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:45:03 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44032 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZBTSpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:45:01 -0500
Date: Fri, 20 Feb 2009 10:44:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: compudj@krystal.dyndns.org, bert.wesarg@googlemail.com, bob@watson.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH URCU formal] Add liveness checks to user-level RCU
	model.
Message-ID: <20090220184459.GO6960@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <123515156769-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <123515156769-git-send-email->
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, this model does -not- cover Mathieu's scenario where a very
large number of reading processes continually arrive using an obsolete
value of the urcu_gp_ctr variable.  Something about having finite memory
on all the machines I have access to.  ;-)

So, here is an informal outline of why forward progress is guaranteed
in this situation:

o	We assume that if one CPU makes a change to a shared variable,
	all other CPUs see the change in a finite period of time.
	[CPUs like the semi-SMP Blackfins will need to make this be the
	case in software.  If you cannot make this assumption, you cannot
	prove that -any- non-trivial SMP algorithm will complete.]

o	We assume that any given CPU executes code at a finite rate.
	Of course, I would be very interested in hearing of any real
	hardware that violates this assumption.  ;-)

o	We assume that all RCU read-side critical sections complete
	in finite time (which can be violated if there are CPU-bound
	real-time-priority processes unless you have priority boosting,
	a scenario I am excluding -- but if this is a real problem,
	we need to add priority boosting).

o	Then there must be a finite number of threads that have observed
	the old value of urcu_gp_ctr.

o	Any subsequent RCU read-side critical sections will use the new
	value of urcu_gp_ctr.

o	The total time consumed by these threads' RCU read-side critical
	sections will then be finite.

o	The updater will therefore eventually observe all the threads
	that used the old value of urcu_gp_ctr to have exited all of
	their RCU read-side critical sections.

So given the three assumptions above, forward progress is guaranteed.
Note that although we don't explicitly assume a finite number of threads,
the finite-CPU-speed assumption makes it difficult to see how the updater
scans the per-thread variables in finite time.  ;-)

							Thanx, Paul

On Fri, Feb 20, 2009 at 09:39:27AM -0800, Paul E. McKenney wrote:
> Break all potentially infinite loops in both urcu_reader() and
> urcu_updater(), ensure that urcu_reader() will process any memory barriers
> that urcu_updater() might issue, and formulate a "never" claim that checks
> to make sure that if either urcu_reader() or urcu_updater() completes,
> then the other will eventually also complete.  Since urcu_reader()
> now has a finite number of steps, it must eventually complete.
> 
> Also replace the code at the end of urcu_reader() that previously absorbed
> late memory-barrier requests from urcu_updater with code in urcu_writer()
> that checks to see if urcu_reader() has completed.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  formal-model/urcu.sh   |   26 ++++++++++-
>  formal-model/urcu.spin |  113 ++++++++++++++++++++++-------------------------
>  2 files changed, 77 insertions(+), 62 deletions(-)
> 
> diff --git a/formal-model/urcu.sh b/formal-model/urcu.sh
> index b76c764..5e525ec 100644
> --- a/formal-model/urcu.sh
> +++ b/formal-model/urcu.sh
> @@ -1,3 +1,25 @@
> +#!/bin/sh
> +#
> +# Compiles and runs the urcu.spin Promela model.
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License as published by
> +# the Free Software Foundation; either version 2 of the License, or
> +# (at your option) any later version.
> +#
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write to the Free Software
> +# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> +#
> +# Copyright (C) IBM Corporation, 2009
> +#
> +# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> +
>  spin -a urcu.spin 
> -cc -DSAFETY -o pan pan.c
> -./pan
> +cc -o pan pan.c
> +./pan -a
> diff --git a/formal-model/urcu.spin b/formal-model/urcu.spin
> index 3e18457..cf1f670 100644
> --- a/formal-model/urcu.spin
> +++ b/formal-model/urcu.spin
> @@ -40,21 +40,28 @@ bit updater_done = 0;
>  byte urcu_gp_ctr = 1;
>  byte urcu_active_readers = 0;
> 
> +/* must be at least the number of smp_mb() statements in urcu_updater(). */
> +#define N_SMP_MB 9
> +
>  /* Model the RCU read-side critical section. */
> 
>  proctype urcu_reader()
>  {
>  	bit done = 0;
> +	byte i;
>  	bit mbok;
>  	byte tmp;
>  	byte tmp_removed;
>  	byte tmp_free;
> 
>  	/* Absorb any early requests for memory barriers. */
> +	i = 0;
>  	do
> -	:: need_mb == 1 ->
> +	:: i < N_SMP_MB && need_mb == 1 ->
>  		need_mb = 0;
> -	:: !updater_done -> skip;
> +		i++;
> +	:: i < N_SMP_MB ->
> +		i++;
>  	:: 1 -> break;
>  	od;
> 
> @@ -91,12 +98,17 @@ proctype urcu_reader()
>  			if
>  			:: (tmp & RCU_GP_CTR_NEST_MASK) == 0 ->
>  				tmp = urcu_gp_ctr;
> +				i = 0;
>  				do
> -				:: (reader_progress[1] +
> +				:: i < N_SMP_MB &&
> +				   (reader_progress[1] +
>  				    reader_progress[2] +
> -				    reader_progress[3] == 0) && need_mb == 1 ->
> +				    reader_progress[3] == 0) &&
> +				   need_mb == 1 ->
>  					need_mb = 0;
> -				:: !updater_done -> skip;
> +					i++;
> +				:: i < N_SMP_MB ->
> +					i++;
>  				:: 1 -> break;
>  				od;
>  				urcu_active_readers = tmp;
> @@ -151,10 +163,13 @@ proctype urcu_reader()
>  		if
>  		:: mbok == 1 ->
>  			/* We get here if mb processing is safe. */
> +			i = 0;
>  			do
> -			:: need_mb == 1 ->
> +			:: i < N_SMP_MB && need_mb == 1 ->
>  				need_mb = 0;
> -			:: !updater_done -> skip;
> +				i++;
> +			:: i < N_SMP_MB ->
> +				i++;
>  			:: 1 -> break;
>  			od;
>  		:: else -> skip;
> @@ -169,36 +184,30 @@ proctype urcu_reader()
>  		:: else -> skip;
>  		fi
>  	od;
> +
> +	/* Make sure any concurrent grace period was sufficiently long. */
>  	assert((tmp_free == 0) || (tmp_removed == 1));
> 
>  	/* Reader has completed. */
>  	reader_done = 1;
> -
> -	/* Process any late-arriving memory-barrier requests. */
> -	do
> -	:: need_mb == 1 ->
> -		need_mb = 0;
> -	:: !updater_done -> skip;
> -	:: 1 -> break;
> -	od;
>  }
> 
> +#define smp_mb() \
> +	need_mb = 1; \
> +	do \
> +	:: !reader_done && need_mb == 1 -> skip; \
> +	:: reader_done -> break; \
> +	:: need_mb == 0 -> break; \
> +	od
> +
>  /* Model the RCU update process. */
> 
>  proctype urcu_updater()
>  {
>  	/* prior synchronize_rcu(), second counter flip. */
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
>  	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
>  	do
>  	:: 1 ->
>  		if
> @@ -209,27 +218,15 @@ proctype urcu_updater()
>  		:: else -> break;
>  		fi;
>  	od;
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
> 
>  	/* Removal statement, e.g., list_del_rcu(). */
>  	removed = 1;
> 
>  	/* current synchronize_rcu(), first counter flip. */
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
>  	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
>  	do
>  	:: 1 ->
>  		if
> @@ -240,24 +237,12 @@ proctype urcu_updater()
>  		:: else -> break;
>  		fi;
>  	od;
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
> 
>  	/* current synchronize_rcu(), second counter flip. */
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
>  	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
>  	do
>  	:: 1 ->
>  		if
> @@ -268,11 +253,7 @@ proctype urcu_updater()
>  		:: else -> break;
>  		fi;
>  	od;
> -	need_mb = 1;
> -	do
> -	:: need_mb == 1 -> skip;
> -	:: need_mb == 0 -> break;
> -	od;
> +	smp_mb();
> 
>  	/* free-up step, e.g., kfree(). */
>  	free = 1;
> @@ -299,3 +280,15 @@ init {
>  		run urcu_updater();
>  	}
>  }
> +
> +/* Require that both reader and updater eventually get done. */
> +
> +never {
> +	do
> +	:: skip;
> +	:: reader_done != 0 || updater_done != 0 -> break;
> +	od;
> +accept:	do
> +	:: reader_done == 0 || updater_done == 0;
> +	od;
> +}
> -- 
> 1.5.2.5
> 
