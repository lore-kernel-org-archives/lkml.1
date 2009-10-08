Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZJHAyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZJHAyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 20:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbZJHAyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 20:54:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbZJHAyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 20:54:15 -0400
Message-ID: <4ACD37C7.4060305@cn.fujitsu.com>
Date: Thu, 08 Oct 2009 08:52:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zhenwen Xu <helight.xu@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V3] fix a warning on kernel/trace/trace_branch.c	andtrace_hw_branches.c
References: <20091007113915.GA5265@helight>
In-Reply-To: <20091007113915.GA5265@helight>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhenwen Xu wrote:
> fix warnings that caused the API change of trace_buffer_lock_reserve()
> change files: kernel/trace/trace_hw_branch.c
> 	      kernel/trace/trace_branch.c
> 
> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  kernel/trace/trace_branch.c      |    2 +-
>  kernel/trace/trace_hw_branches.c |    6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 7a7a9fd..216e2dd 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  		goto out;
>  
>  	pc = preempt_count();
> -	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
>  					  sizeof(*entry), flags, pc);

As Steven has picked up the previous patch, this part can be removed now.

>  	if (!event)
>  		goto out;
> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> index 23b6385..e40f5fb 100644
> --- a/kernel/trace/trace_hw_branches.c
> +++ b/kernel/trace/trace_hw_branches.c
> @@ -165,6 +165,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	struct ftrace_event_call *call = &event_hw_branch;
>  	struct trace_array *tr = hw_branch_trace;
>  	struct ring_buffer_event *event;
> +	struct ring_buffer      *buf;

Just use one space:

 +	struct ring_buffer *buf;

>  	struct hw_branch_entry *entry;
>  	unsigned long irq1;
>  	int cpu;
> @@ -180,7 +181,8 @@ void trace_hw_branch(u64 from, u64 to)
>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>  		goto out;
>  
> -	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
> +	buf = tr->buffer
> +	event = trace_buffer_lock_reserve(buf, TRACE_HW_BRANCHES,
>  					  sizeof(*entry), 0, 0);
>  	if (!event)
>  		goto out;
> @@ -190,7 +192,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	entry->from = from;
>  	entry->to   = to;
>  	if (!filter_check_discard(call, entry, tr->buffer, event))

s/tr->buffer/buf

> -		trace_buffer_unlock_commit(tr, event, 0, 0);
> +		trace_buffer_unlock_commit(buf, event, 0, 0);
>  
>   out:
>  	atomic_dec(&tr->data[cpu]->disabled);

Otherwise looks good.
