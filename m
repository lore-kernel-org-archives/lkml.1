Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZIWDc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZIWDc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 23:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZIWDc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 23:32:59 -0400
Received: from ozlabs.org ([203.10.76.45]:55159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbZIWDc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 23:32:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19129.38627.94363.857137@cargo.ozlabs.ibm.com>
Date: Wed, 23 Sep 2009 13:32:51 +1000
From: Paul Mackerras <paulus@samba.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
In-Reply-To: <4AB98BB0.6020202@cn.fujitsu.com>
References: <4AB88F06.10900@cn.fujitsu.com>
	<19128.39768.149110.673711@cargo.ozlabs.ibm.com>
	<4AB98BB0.6020202@cn.fujitsu.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong writes:

> I only find three places in __perf_event_sched_in/out, could you tell me
> where is the fourth place?

My mistake, it is just those three.  I saw the list_for_each_entry_rcu
followed by if (event != event->group_leader) in perf_event_init_task
and missed the fact that it is iterating parent_ctx->event_list rather
than parent_ctx->group_list.  But as you point out:

> I also noticed that all group leader is the top level of ctx->group_list,
> if I not missed, the perf_event_init_task() function can be optimized,
> like this:
> 
> int perf_event_init_task(struct task_struct *child)
> {
> 	......
> 	/* We can only look at parent_ctx->group_list to get group leader */
> 	list_for_each_entry_rcu(event, &parent_ctx->event_list, event_entry) {
> 		if (event != event->group_leader)
> 			continue;
> 	......
> 	}
> 	......
> }

we would in fact be better off using group_list rather than event_list
anyway.  That should be safe since we hold parent_ctx->mutex.

> I'll fix those if you are not mind :-)

Please do. :)

Paul.
