Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZCRV5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZCRV5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbZCRVvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:51:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbZCRVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:51:14 -0400
Date: Wed, 18 Mar 2009 17:51:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [BUG] circular lock dependency in tip
In-Reply-To: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903181736170.31583@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0903181729360.31583@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 18 Mar 2009, Steven Rostedt wrote:
> 
> 
> Seems that the issue is that we have:
> 
> static void idle_balance(int this_cpu, struct rq *this_rq)
> {
>         struct sched_domain *sd;
>         int pulled_task = 0;
>         unsigned long next_balance = jiffies + HZ;
>         cpumask_var_t tmpmask;
> 
>         if (!alloc_cpumask_var(&tmpmask, GFP_ATOMIC))
>                 return;

Is this really a good idea? I mean, if the system is very active, it can 
easily fail to acquire memory, you just need to have cache filled. 
Remember, this is GFP_ATOMIC, if the memory is not available, then we do 
not try to reclaim. With the system busy, this may be exactly the time we 
need to do the idle_balance.

I'm thinking a blind conversion of cpumask_var_t is not the best way to 
handle changes. This is as bad as fixing compiler warnings without looking 
into the real cause.

-- Steve

