Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYIFQhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYIFQhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYIFQhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:37:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:57800 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYIFQhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:37:47 -0400
Message-ID: <48C2B1D2.5070801@colorfullife.com>
Date: Sat, 06 Sep 2008 18:37:38 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com>
In-Reply-To: <20080905152930.GA8124@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------040504070209020000050206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040504070209020000050206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Paul,

Paul E. McKenney wrote:
> o	The rcu_pending() and rcu_needs_cpu() primitives are now
> 	much more aggressive about permitting CPUs to enter dynticks
> 	idle mode.  Only CPUs that have RCU callbacks are kept out
> 	of dynticks idle mode.
>   

I've noticed that right now rcu_enter_nohz() can be nested within 
rcu_irq_enter():
irq_exit() first calls tick_nohz_stop_sched_tick(), then rcu_irq_exit().
And tick_nohz_stop_sched_tick() can switch into nohz mode.

Is that intentional? Does rcupreempt support that? It broke my rcustate 
code on x86-64.

I would prefer if something like the attached patch is applied. What do 
you think?
Do you need the patch as well?

--
    Manfred

--------------040504070209020000050206
Content-Type: text/plain;
 name="patch-move-rcu_irq_exit"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-move-rcu_irq_exit"

diff --git a/kernel/softirq.c b/kernel/softirq.c
index ba20a90..cca5a83 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -284,10 +284,10 @@ void irq_exit(void)
 		invoke_softirq();
 
 #ifdef CONFIG_NO_HZ
+	rcu_irq_exit(0);
 	/* Make sure that timer wheel updates are propagated */
 	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
 		tick_nohz_stop_sched_tick(0);
-	rcu_irq_exit(0);
 #endif
 	preempt_enable_no_resched();
 }

--------------040504070209020000050206--
