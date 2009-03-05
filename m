Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZCEOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZCEOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZCEOkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:40:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52162 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZCEOkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:40:12 -0500
Date: Thu, 5 Mar 2009 09:40:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: don't rebalance if attached on NULL
 domain
In-Reply-To: <tip-a9c4ae3ae077905b3c413f42e0c9fb21dc86402d@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0903050939460.26101@gandalf.stny.rr.com>
References: <49af242d.1c07d00a.32d5.ffffc019@mx.google.com> <tip-a9c4ae3ae077905b3c413f42e0c9fb21dc86402d@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 5 Mar 2009, Frederic Weisbecker wrote:

> 
> sched: don't rebalance if attached on NULL domain
> 
> Impact: fix function graph trace hang / drop pointless softirq on UP
> 
> While debugging a function graph trace hang on an old PII, I saw
> that it consumed most of its time on the timer interrupt. And
> the domain rebalancing softirq was the most concerned.
> 
> The timer interrupt calls trigger_load_balance() which will
> decide if it is worth to schedule a rebalancing softirq.
> 
> In case of builtin UP kernel, no problem arises because there is
> no domain question.
> 
> In case of builtin SMP kernel running on an SMP box, still no
> problem, the softirq will be raised each time we reach the
> next_balance time.
> 
> In case of builtin SMP kernel running on a UP box (most distros
> provide default SMP kernels, whatever the box you have), then
> the CPU is attached to the NULL sched domain. So a kind of
> unexpected behaviour happen:
> 
> trigger_load_balance() -> raises the rebalancing softirq later
> on softirq: run_rebalance_domains() -> rebalance_domains() where
> the for_each_domain(cpu, sd) is not taken because of the NULL
> domain we are attached at. Which means rq->next_balance is never
> updated. So on the next timer tick, we will enter
> trigger_load_balance() which will always reschedule() the
> rebalacing softirq:
> 
> if (time_after_eq(jiffies, rq->next_balance))
> 	raise_softirq(SCHED_SOFTIRQ);
> 
> So for each tick, we process this pointless softirq.

Nice catch!

-- Steve
