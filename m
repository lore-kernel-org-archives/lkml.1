Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbXIDFd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbXIDFd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 01:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbXIDFdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 01:33:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbXIDFdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 01:33:50 -0400
Date: Tue, 4 Sep 2007 11:16:50 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       josh@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Make rcutorture RNG use temporal entropy
In-Reply-To: <20070816024904.GA5312@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.0.999.0709041047070.13651@enigma.security.iitk.ac.in>
References: <20070816024904.GA5312@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,


On Wed, 15 Aug 2007, Paul E. McKenney wrote:
> 
> The locking used by get_random_bytes() can conflict with the
> preempt_disable() and synchronize_sched() form of RCU.  This patch changes
> rcutorture's RNG to gather entropy from the new cpu_clock() interface
> (relying on interrupts, preemption, daemons, and rcutorture's reader
> thread's rock-bottom scheduling priority to provide useful entropy),
> and also adds and EXPORT_SYMBOL_GPL() to make that interface available
> to GPLed kernel modules such as rcutorture.

Honestly, rcutorture goes to some amazing lengths just to have this
randomizing-the-delays-that-read/write-test-threads-spend-inside-or-
outside-the-critical-sections thing :-) Especially, seeing that
synchro-test, the other "comparable" module, just doesn't bother with
all this at all. (especially check out its load == interval == do_sched
== 0 case! :-)

So IMHO, considering that rcutorture isn't a "serious" user of randomness
in the first place (of even a "fast-and-loose version" for that matter),
you could consider a solution where you gather all the randomness you need
at module_init time itself and save it somewhere, and then use it wherever
you're calling into rcu_random()->cpu_clock() [ or get_random_bytes() ]
in the current code. You could even make some trivial updates to those
random numbers after every RCU_RANDOM_REFRESH uses, like present.

Agreed, anybody running rcutorture isn't really looking for performance,
but why call get_random_bytes() or cpu_clock() (and the smp_processor_id()
+ irq_save/restore + export_symbol() that goes with it) when it isn't
_really_ "required" as such ...

Just a suggestion,

Satyam
