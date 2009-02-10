Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZBJTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZBJTYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbZBJTRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:17:36 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:50207 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758276AbZBJTRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:17:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEANtbkUlMQWt2/2dsb2JhbACBbtJOhBoG
Date: Tue, 10 Feb 2009 14:17:31 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090210191731.GA20867@Krystal>
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal> <20090209070317.GA31583@Krystal> <20090209153305.GA6802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090209153305.GA6802@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:43:54 up 40 days, 17:42,  4 users,  load average: 0.08, 0.45,
	0.49
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Feb 09, 2009 at 02:03:17AM -0500, Mathieu Desnoyers wrote:
> 
> [ . . . ]
> 
> > I just added modified rcutorture.h and api.h from your git tree
> > specifically for an urcutorture program to the repository. Some results :
> > 
> > 8-way x86_64
> > E5405 @2 GHZ
> > 
> > ./urcutorture 8 perf
> > n_reads: 1937650000  n_updates: 3  nreaders: 8  nupdaters: 1 duration: 1
> > ns/read: 4.12871  ns/update: 3.33333e+08
> > 
> > ./urcutorture 8 uperf
> > n_reads: 0  n_updates: 4413892  nreaders: 0  nupdaters: 8 duration: 1
> > ns/read: nan  ns/update: 1812.46
> > 
> > n_reads: 98844204  n_updates: 10  n_mberror: 0
> > rcu_stress_count: 98844171 33 0 0 0 0 0 0 0 0 0
> > 
> > However, I've tried removing the second switch_qparity() call, and the
> > rcutorture test did not detect anything wrong. I also did a variation
> > which calls the "sched_yield" version of the urcu, "urcutorture-yield".
> 
> My confusion -- I was testing my old approach where the memory barriers
> are in rcu_read_lock() and rcu_read_unlock().  To force the failures in
> your signal-handler-memory-barrier approach, I suspect that you are
> going to need a bigger hammer.  In this case, one such bigger hammer
> would be:
> 
> o	Just before exit from the signal handler, do a
> 	pthread_cond_wait() under a pthread_mutex().
> 
> o	In force_mb_all_threads(), refrain from sending a signal to self.
> 
> 	Then it should be safe in force_mb_all_threads() to do a
> 	pthread_cond_broadcast() under the same pthread_mutex().
> 
> This should raise the probability of seeing the failure in the case
> where there is a single switch_qparity().
> 

I just did a mb() version of the urcu :

(uncomment CFLAGS=+-DDEBUG_FULL_MB in the Makefile)

Time per read : 48.4086 cycles
(about 6-7 times slower, as expected)

This will be useful especially to increase the chance to trigger races.

I tried removing the second parity switch from the writer. The rcu
torture test did not find the problem yet (maybe I am not using the
correct parameters ? It does not run for more than 5 seconds).

So I added a "-n" option to test_urcu, so it can make the usleep(1)
between the writes optional. I also changed the yield for a usleep with
random delay. I also now use a circular buffer rather than malloc so we
are sure the memory is not quickly reused by the writer and stays longer
in an invalid state.

So what really make the problem appear quickly is to add a delay between
the rcu_dereference and the assertion on the data validity in thr_reader.

It now appears after just a few seconds when running
./test_urcu_yield 20 -r -n
Compiled with CFLAGS=+-DDEBUG_FULL_MB

It seem to be much harder to trigger with the signal-based version. It's
expected, because the writer takes about 50 times longer to execute than
with the -DDEBUG_FULL_MB version.

So I'll let the ./test_urcu_yield NN -r -n run for a while on the
correct version (with DEBUG_FULL_MB) and see what it gives.

Mathieu


> 							Thanx, Paul
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
