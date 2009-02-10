Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZBJXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZBJXCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZBJXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:01:52 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48667 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbZBJXBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:01:51 -0500
Date: Tue, 10 Feb 2009 15:01:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090210230150.GA19550@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal> <20090209070317.GA31583@Krystal> <20090209153305.GA6802@linux.vnet.ibm.com> <20090210191731.GA20867@Krystal> <20090210211643.GL6742@linux.vnet.ibm.com> <20090210212833.GA27578@Krystal> <20090210222115.GN6742@linux.vnet.ibm.com> <20090210225839.GA19426@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20090210225839.GA19426@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 10, 2009 at 02:58:39PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 10, 2009 at 02:21:15PM -0800, Paul E. McKenney wrote:
> > On Tue, Feb 10, 2009 at 04:28:33PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Tue, Feb 10, 2009 at 02:17:31PM -0500, Mathieu Desnoyers wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Mon, Feb 09, 2009 at 02:03:17AM -0500, Mathieu Desnoyers wrote:
> > > > > > 
> > > > > > [ . . . ]
> > > > > > 
> > > > > > > I just added modified rcutorture.h and api.h from your git tree
> > > > > > > specifically for an urcutorture program to the repository. Some results :
> > > > > > > 
> > > > > > > 8-way x86_64
> > > > > > > E5405 @2 GHZ
> > > > > > > 
> > > > > > > ./urcutorture 8 perf
> > > > > > > n_reads: 1937650000  n_updates: 3  nreaders: 8  nupdaters: 1 duration: 1
> > > > > > > ns/read: 4.12871  ns/update: 3.33333e+08
> > > > > > > 
> > > > > > > ./urcutorture 8 uperf
> > > > > > > n_reads: 0  n_updates: 4413892  nreaders: 0  nupdaters: 8 duration: 1
> > > > > > > ns/read: nan  ns/update: 1812.46
> > > > > > > 
> > > > > > > n_reads: 98844204  n_updates: 10  n_mberror: 0
> > > > > > > rcu_stress_count: 98844171 33 0 0 0 0 0 0 0 0 0
> > > > > > > 
> > > > > > > However, I've tried removing the second switch_qparity() call, and the
> > > > > > > rcutorture test did not detect anything wrong. I also did a variation
> > > > > > > which calls the "sched_yield" version of the urcu, "urcutorture-yield".
> > > > > > 
> > > > > > My confusion -- I was testing my old approach where the memory barriers
> > > > > > are in rcu_read_lock() and rcu_read_unlock().  To force the failures in
> > > > > > your signal-handler-memory-barrier approach, I suspect that you are
> > > > > > going to need a bigger hammer.  In this case, one such bigger hammer
> > > > > > would be:
> > > > > > 
> > > > > > o	Just before exit from the signal handler, do a
> > > > > > 	pthread_cond_wait() under a pthread_mutex().
> > > > > > 
> > > > > > o	In force_mb_all_threads(), refrain from sending a signal to self.
> > > > > > 
> > > > > > 	Then it should be safe in force_mb_all_threads() to do a
> > > > > > 	pthread_cond_broadcast() under the same pthread_mutex().
> > > > > > 
> > > > > > This should raise the probability of seeing the failure in the case
> > > > > > where there is a single switch_qparity().
> > > > > > 
> > > > > 
> > > > > I just did a mb() version of the urcu :
> > > > > 
> > > > > (uncomment CFLAGS=+-DDEBUG_FULL_MB in the Makefile)
> > > > > 
> > > > > Time per read : 48.4086 cycles
> > > > > (about 6-7 times slower, as expected)
> > > > > 
> > > > > This will be useful especially to increase the chance to trigger races.
> > > > > 
> > > > > I tried removing the second parity switch from the writer. The rcu
> > > > > torture test did not find the problem yet (maybe I am not using the
> > > > > correct parameters ? It does not run for more than 5 seconds).
> > > > > 
> > > > > So I added a "-n" option to test_urcu, so it can make the usleep(1)
> > > > > between the writes optional. I also changed the yield for a usleep with
> > > > > random delay. I also now use a circular buffer rather than malloc so we
> > > > > are sure the memory is not quickly reused by the writer and stays longer
> > > > > in an invalid state.
> > > > > 
> > > > > So what really make the problem appear quickly is to add a delay between
> > > > > the rcu_dereference and the assertion on the data validity in thr_reader.
> > > > > 
> > > > > It now appears after just a few seconds when running
> > > > > ./test_urcu_yield 20 -r -n
> > > > > Compiled with CFLAGS=+-DDEBUG_FULL_MB
> > > > > 
> > > > > It seem to be much harder to trigger with the signal-based version. It's
> > > > > expected, because the writer takes about 50 times longer to execute than
> > > > > with the -DDEBUG_FULL_MB version.
> > > > > 
> > > > > So I'll let the ./test_urcu_yield NN -r -n run for a while on the
> > > > > correct version (with DEBUG_FULL_MB) and see what it gives.
> > > > 
> > > > Hmmm...  I had worse luck this time, took three 10-second tries to
> > > > see a failure:
> > > > 
> > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$ ./rcu_nest32 1 stress
> > > > n_reads: 44682055  n_updates: 9609503  n_mberror: 0
> > > > rcu_stress_count: 44679377 2678 0 0 0 0 0 0 0 0 0
> > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$ !!
> > > > ./rcu_nest32 1 stress
> > > > n_reads: 42281884  n_updates: 9870129  n_mberror: 0
> > > > rcu_stress_count: 42277756 4128 0 0 0 0 0 0 0 0 0
> > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$ !!
> > > > ./rcu_nest32 1 stress
> > > > n_reads: 41384304  n_updates: 10040805  n_mberror: 0
> > > > rcu_stress_count: 41380075 4228 1 0 0 0 0 0 0 0 0
> > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$
> > > > 
> > > > This is my prototype version, with read-side memory barriers, no
> > > > signals, and without your initialization-value speedup.
> > > > 
> > > 
> > > It would be interesting to re-sync our trees, or if you can point me to
> > > a current version of your prototype, I could review it.
> > 
> > Look at:
> > 
> > 	CodeSamples/defer/rcu_nest32.[hc]
> > 
> > In the git archive:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
> 
> And attached is an attempted Promela-based proof, along with a script
> that runs it.  It currently says that this version of RCU works.  Not yet
> sure whether to believe it.  ;-)
> 
> It notes that lines 37 and 92 are unreached.  37 is unreached because
> the Promela code currently doesn't exercise nested RCU read-side
> critical sections, and 92 is unreached because there is an infinite
> loop processing memory-barrier requests at the end of the reader code.
> 
> Thoughts?

And of course it is trivial to add nested RCU read-side critical
sections, as in the attached.  Still passes, so up to you to figure
out what errors I have in my Promela code.  ;-)

							Thanx, Paul

--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="urcu.spin"

bit removed = 0;
bit free = 0;

#define RCU_GP_CTR_BIT (1 << 7)
#define RCU_GP_CTR_NEST_MASK (RCU_GP_CTR_BIT - 1)

bit need_mb = 0;
byte urcu_gp_ctr = 1;
byte urcu_active_readers = 0;

byte reader_progress[4];

proctype urcu_reader()
{
	bit done = 0;
	byte tmp;
	byte tmp_removed;
	byte tmp_free;

	do
	:: 1 ->
		if
		:: need_mb == 1 ->
			need_mb = 0;
		:: else -> break;
		fi
	od;
	do
	:: 1 ->
		if
		:: reader_progress[0] < 2 ->
			tmp = urcu_active_readers;
			if
			:: (tmp & RCU_GP_CTR_NEST_MASK) == 0 ->
				urcu_active_readers = urcu_gp_ctr;
			:: else ->
				urcu_active_readers = tmp + 1;
			fi;
			reader_progress[0] = 1;
		:: reader_progress[1] == 0 ->
			tmp_removed = removed;
			reader_progress[1] = 1;
		:: reader_progress[2] == 0 ->
			tmp_free = free;
			reader_progress[2] = 1;
		:: ((reader_progress[0] > reader_progress[3]) &&
		    (reader_progress[3] < 2)) ->
			urcu_active_readers = urcu_active_readers - 1;
		:: else -> break;
		fi;
		atomic {
			tmp = 0;
			do
			:: reader_progress[tmp] == 0 ->
				tmp = tmp + 1;
				break;
			:: reader_progress[tmp] == 1 && tmp < 4 ->
				tmp = tmp + 1;
			:: tmp >= 4 ->
				done = 1;
				break;
			od;
			do
			:: tmp < 4 && reader_progress[tmp] == 0 ->
				tmp = tmp + 1;
			:: tmp < 4 && reader_progress[tmp] == 1 ->
				break;
			:: tmp >= 4 ->
				if
				:: need_mb == 1 ->
					need_mb = 0;
				:: else -> skip;
				fi;
				done = 1;
				break;
			od

		}
		if
		:: done == 1 -> break;
		:: else -> skip;
		fi
	od;
	do
	:: 1 ->
		if
		:: need_mb == 1 ->
			need_mb = 0;
		:: else -> skip;
		fi;
		assert((free == 0) || (removed == 1));
	od;
}

proctype urcu_updater()
{
	removed = 1;
	need_mb = 1;
	do
	:: need_mb == 1 -> skip;
	:: need_mb == 0 -> break;
	od;
	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
	do
	:: 1 ->
		if
		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
			skip;
		:: else -> break;
		fi
	od;

	need_mb = 1;
	do
	:: need_mb == 1 -> skip;
	:: need_mb == 0 -> break;
	od;
	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
	do
	:: 1 ->
		if
		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
			skip;
		:: else -> break;
		fi;
	od;

	free = 1;
}

init {
	atomic {
		reader_progress[0] = 0;
		reader_progress[1] = 0;
		reader_progress[2] = 0;
		reader_progress[3] = 0;
		run urcu_reader();
		run urcu_updater();
	}
}

--r5Pyd7+fXNt84Ff3
Content-Type: application/x-sh
Content-Disposition: attachment; filename="urcu.sh"
Content-Transfer-Encoding: quoted-printable

spin -a urcu.spin =0Acc -DSAFETY -o pan pan.c=0A./pan=0A
--r5Pyd7+fXNt84Ff3--
