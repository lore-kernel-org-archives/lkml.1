Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYHEHbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYHEHbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYHEHZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:25:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:43292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYHEHZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:25:00 -0400
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       mark gross <mgross@linux.intel.com>, arjan <arjan@infradead.org>
In-Reply-To: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 09:25:01 +0200
Message-Id: <1217921101.3589.98.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 22:52 +0200, John Kacur wrote:
> Even after applying some fixes posted by Chirag and Peter Z, I'm still
> getting some messages in my log like this

> BUG: sleeping function called from invalid context swapper(0) at
> kernel/rtmutex.c:743
> in_atomic():1 [00000001], irqs_disabled():1
> Pid: 0, comm: swapper Tainted: G        W 2.6.26.1-rt1.jk #2
> 
> Call Trace:
>  [<ffffffff802305d3>] __might_sleep+0x12d/0x132
>  [<ffffffff8046cdbe>] __rt_spin_lock+0x34/0x7d
>  [<ffffffff8046ce15>] rt_spin_lock+0xe/0x10
>  [<ffffffff802532e5>] pm_qos_requirement+0x1f/0x3c
>  [<ffffffff803e1b7f>] menu_select+0x7b/0x9c
>  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>  [<ffffffff803e0b4b>] cpuidle_idle_call+0x68/0xd8
>  [<ffffffff803e0ae3>] ? cpuidle_idle_call+0x0/0xd8
>  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>  [<ffffffff8020b333>] cpu_idle+0xb2/0x12d
>  [<ffffffff80466af0>] start_secondary+0x186/0x18b
> 
> ---------------------------
> | preempt count: 00000001 ]
> | 1-level deep critical section nesting:
> ----------------------------------------
> ... [<ffffffff8020b39c>] .... cpu_idle+0x11b/0x12d
> ......[<ffffffff80466af0>] ..   ( <= start_secondary+0x186/0x18b)
> 
> The following simple patch makes the messages disappear - however,
> there may be a better more fine grained solution, but the problem is
> also that all the functions are designed to use the same lock.

Hmm, I think you're right - its called from the idle routine so we can't
go about sleeping there.

The only trouble I have is with kernel/pm_qos_params.c:update_target()'s
use of this lock - that is decidedly not O(1).

Mark, would it be possible to split that lock in two, one lock
protecting pm_qos_array[], and one lock protecting the
requirements.list ?

[ NOTE: this is the -rt kernel we're talking about ]

> Signed-off-by: John Kacur <jkacur at gmail dot com>
> 
> Index: linux-2.6.26.1-jk-rt1/kernel/pm_qos_params.c
> ===================================================================
> --- linux-2.6.26.1-jk-rt1.orig/kernel/pm_qos_params.c
> +++ linux-2.6.26.1-jk-rt1/kernel/pm_qos_params.c
> @@ -110,7 +110,7 @@ static struct pm_qos_object *pm_qos_arra
>         &network_throughput_pm_qos
>  };
>  
> -static DEFINE_SPINLOCK(pm_qos_lock);
> +static DEFINE_RAW_SPINLOCK(pm_qos_lock);
>  
>  static ssize_t pm_qos_power_write(struct file *filp, const char
> __user *buf,
>                 size_t count, loff_t *f_pos);
> 

