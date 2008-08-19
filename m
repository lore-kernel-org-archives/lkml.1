Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbYHSRlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbYHSRlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYHSRld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:41:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60345 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbYHSRld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:41:33 -0400
Date: Tue, 19 Aug 2008 10:41:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       oleg@tv-sign.ru, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: nohz_cpu_mask question (was: Re: [PATCH tip/core/rcu] classic
	RCU locking and memory-barrier cleanups)
Message-ID: <20080819174118.GD6724@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080805162144.GA8297@linux.vnet.ibm.com> <489936E5.7020509@colorfullife.com> <20080807031806.GA6910@linux.vnet.ibm.com> <48A93D49.2000601@colorfullife.com> <20080818140404.GD6847@linux.vnet.ibm.com> <48AAA501.8010502@colorfullife.com> <20080819140339.GF7106@linux.vnet.ibm.com> <48AAFFF0.7020405@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AAFFF0.7020405@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 07:16:32PM +0200, Manfred Spraul wrote:
> Hi all,
>
> can someone explain me nohz_cpu_mask?
>
> If I understand it correctly, it merely means that this cpu does not take 
> timer interrupts, correct?
> The cpu can still take "real" interupts, e.g. a nic interrupt. The cpu 
> could also do softirq processing.

Yep, that is correct.

> Is that correct? Ingo?
>
> If nohz cpus can take normal interrupts, then it would be wrong to exclude 
> these cpus from the mask of cpus that must pass a quiescent cycle - a 
> softirq could hold on a pointers.

That is indeed the approach that preemptable RCU takes, and
I am considering making classic RCU also take this approach.
The main advantage is that sleeping CPUs need not be awakened
unless it is participating directly in the RCU grace period (as in
it has some callbacks).  See rcu_irq_enter() and rcu_irq_exit() in
kernel/rcupreempt.c as well as rcu_enter_nohz() and rcu_exit_nohz()
in include/linux/rcupreempt.h.  And http://lwn.net/Articles/279077/
for the proof of correctness.  ;-)

Instead, classic RCU prevents any CPU from going into nohz mode in the
first place if RCU is waiting on it.  I am not completely confident
in this algorithm, which is one reason that I am looking to switch to
the preemptable RCU approach.  The other reason is power efficiency --
after all, why bother waking up a CPU just to have it tell RCU that it
is sitting idle?

							Thanx, Paul
