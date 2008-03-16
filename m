Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYCPSSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYCPSSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYCPSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:18:37 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:53405 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYCPSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:18:36 -0400
Date: Sun, 16 Mar 2008 23:47:11 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
       Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Too many timer interrupts in NO_HZ
Message-ID: <20080316181711.GK18923@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: discuss@LessWatts.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	venkatesh.pallipadi@intel.com, tglx@linutronix.de,
	Arjan van de Ven <arjan@infradead.org>, suresh.b.siddha@intel.com,
	Gautham R Shenoy <ego@in.ibm.com>,
	Chanda Sethia <chanda.sethia@in.ibm.com>
References: <20080302194812.GD10028@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080302194812.GD10028@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2008-03-03 01:18:13]:

[sniped]
       
 
> The problem:
> 
> There are way too many timer interrupts even though the CPUs have
> entered tickless idle loop.  Timer interrupts basically bring the CPU
> out of idle, and then return to tickless idle.  There are very few
> try_to_wake_up()s or need_resched() in between the timer interrupts.
> 
> What can happen in an idle system in the timer interrupt context that
> does not invoke a need_resched() or try_to_wake_up()?
> 

[sniped]
 
> Please help me to understand the following scenario:
> 
> * What can happen in timer interrupt context that need not wakeup any
>   process?
> * What can prevent tick_nohz_stop_sched_tick() from actually stopping
>   the tick?  
> * Whats wrong in expecting to see some of the CPUs having tickless
>   idle time of few minutes

I think I have the answers to some of the above questions.  

Function        Count                   Name
Address

c0219922        : 5		blk_unplug_timeout
c014f464        : 55		wb_timer_fn
c02b2e67        : 350		bnx2_timer
c03efcbc        : 115		neigh_periodic_timer
c012894a        : 220		process_timeout
c027d1c4        : 2		hangcheck_fire
c03fe232        : 3		peer_check_expire
c012e830        : 25		delayed_work_timer_fn
c03afe92        : 2783		ehci_watchdog
c03f1a35        : 10		neigh_timer_handler
c01d7456        : 110		commit_timeout
c04381e9        : 2		addrconf_verify
c03f6d39        : 365		dev_watchdog
c04126bc        : 114		tcp_write_timer

These are roughly the list of functions that were responsible for the
timer interrupts across all cpus including the ones in idle.  Most of
the functions complete the job in interrupt context and also re-queue
the timer.  The count number is the call count in the 120s observation
window across all 4 CPUs.

I got these function addresses from __next_timer_interrupt() in
timer.c.  Previously, I did not look in timer.c since hrtimers were
enabled and I assumed all timer call will be through __run_hrtimer
from hrtimer.c.  The call count of __run_hrtimer was very minimal and
did not correspond to the local timer interrupt count.

These are device driver timers that we need to investigate.  We should
try to migrate them to CPU0 (or some other package) to get really long
uninterrupted CPU sleep time.  

I will post more results after tweaking some of the above timers.

Should PowerTop include local timer interrupt counts as well during
the observation period?  Interrupt do significantly affect CPU sleep
time whether they wakeup any process or not.

Comments?

Thanks,
Vaidy


