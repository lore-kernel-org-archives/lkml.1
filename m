Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZIWCp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZIWCp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZIWCp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:45:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbZIWCp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:45:56 -0400
Message-ID: <4AB98BB0.6020202@cn.fujitsu.com>
Date: Wed, 23 Sep 2009 10:45:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: cleanup for __perf_event_sched_in()
References: <4AB88F06.10900@cn.fujitsu.com> <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
In-Reply-To: <19128.39768.149110.673711@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Mackerras wrote:
> Xiao Guangrong writes:
> 
>> It must be a group leader if event->attr.pinned is "1"
> 
> Actually, looking at this more closely, it has to be a group leader
> anyway since it's at the top level of ctx->group_list.  In fact I see
> four places where we do:
> 
> 		list_for_each_entry(event, &ctx->group_list, group_entry) {
> 			if (event == event->group_leader)
> 				...
> 
> or the equivalent, three of which appear to have been introduced by
> afedadf2 ("perf_counter: Optimize sched in/out of counters") back in
> May by Peter Z.
> 

I only find three places in __perf_event_sched_in/out, could you tell me
where is the fourth place?

I also noticed that all group leader is the top level of ctx->group_list,
if I not missed, the perf_event_init_task() function can be optimized,
like this:

int perf_event_init_task(struct task_struct *child)
{
	......
	/* We can only look at parent_ctx->group_list to get group leader */
	list_for_each_entry_rcu(event, &parent_ctx->event_list, event_entry) {
		if (event != event->group_leader)
			continue;
	......
	}
	......
}

I'll fix those if you are not mind :-)

Thanks,
Xiao
