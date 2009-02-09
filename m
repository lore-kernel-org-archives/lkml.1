Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZBIPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZBIPdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZBIPdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:33:09 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36810 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbZBIPdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:33:08 -0500
Date: Mon, 9 Feb 2009 07:33:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090209153305.GA6802@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal> <20090209070317.GA31583@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209070317.GA31583@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 02:03:17AM -0500, Mathieu Desnoyers wrote:

[ . . . ]

> I just added modified rcutorture.h and api.h from your git tree
> specifically for an urcutorture program to the repository. Some results :
> 
> 8-way x86_64
> E5405 @2 GHZ
> 
> ./urcutorture 8 perf
> n_reads: 1937650000  n_updates: 3  nreaders: 8  nupdaters: 1 duration: 1
> ns/read: 4.12871  ns/update: 3.33333e+08
> 
> ./urcutorture 8 uperf
> n_reads: 0  n_updates: 4413892  nreaders: 0  nupdaters: 8 duration: 1
> ns/read: nan  ns/update: 1812.46
> 
> n_reads: 98844204  n_updates: 10  n_mberror: 0
> rcu_stress_count: 98844171 33 0 0 0 0 0 0 0 0 0
> 
> However, I've tried removing the second switch_qparity() call, and the
> rcutorture test did not detect anything wrong. I also did a variation
> which calls the "sched_yield" version of the urcu, "urcutorture-yield".

My confusion -- I was testing my old approach where the memory barriers
are in rcu_read_lock() and rcu_read_unlock().  To force the failures in
your signal-handler-memory-barrier approach, I suspect that you are
going to need a bigger hammer.  In this case, one such bigger hammer
would be:

o	Just before exit from the signal handler, do a
	pthread_cond_wait() under a pthread_mutex().

o	In force_mb_all_threads(), refrain from sending a signal to self.

	Then it should be safe in force_mb_all_threads() to do a
	pthread_cond_broadcast() under the same pthread_mutex().

This should raise the probability of seeing the failure in the case
where there is a single switch_qparity().

							Thanx, Paul
