Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab0BOJMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:12:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:56425 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0BOJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:12:11 -0500
Subject: Re: rcu_dereference() without protection in select_task_rq_fair()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100214170409.GK7084@linux.vnet.ibm.com>
References: <20100211165246.GA8329@linux.vnet.ibm.com>
	 <1266142358.5273.420.camel@laptop>
	 <20100214170409.GK7084@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 10:12:06 +0100
Message-ID: <1266225126.5273.720.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 09:04 -0800, Paul E. McKenney wrote:

> OK, but doesn't the "preempt_count() != 0" that is in the current version
> of rcu_read_lock_sched_held() already cover this check?

Hmm, yes it should.

> In other words, I believe that I have located a usage of for_each_domain()
> that violates the rule that it may only be called within preempt-disabled
> sections.

>From the trace:

>  [<ffffffff81033ec4>] select_task_rq_fair+0xc1/0x686
>  [<ffffffff810353f4>] wake_up_new_task+0x1e/0x13e

Which reads like:

void wake_up_new_task(...)
{
	...

        int cpu __maybe_unused = get_cpu();

#ifdef CONFIG_SMP
        /*
         * Fork balancing, do it here and not earlier because:
         *  - cpus_allowed can change in the fork path
         *  - any previously selected cpu might disappear through hotplug
         *
         * We still have TASK_WAKING but PF_STARTING is gone now, meaning
         * ->cpus_allowed is stable, we have preemption disabled, meaning
         * cpu_online_mask is stable.
         */
        cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
        set_task_cpu(p, cpu);
#endif

	...

	put_cpu()
}

I cannot see how we can get there without preemption disabled.

