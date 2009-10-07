Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbZJGIze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbZJGIze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934146AbZJGIzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:55:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934036AbZJGIzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:55:32 -0400
Message-ID: <4ACC5715.4000201@cn.fujitsu.com>
Date: Wed, 07 Oct 2009 16:53:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zhenwen Xu <helight.xu@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V2] fix a warning on kernel/trace/trace_branch.c and	trace_hw_branches.c
References: <20091007081946.GA25350@helight>
In-Reply-To: <20091007081946.GA25350@helight>
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

Hmm, did you really compile trace_hw_branch.c while testing
this patch?

This change is necessary too:

-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	trace_buffer_unlock_commit(tr->buffer, event, 0, 0);

And use a varaible "buffer = tr->buffer" should be better.

> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  kernel/trace/trace_branch.c      |    2 +-
>  kernel/trace/trace_hw_branches.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
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
>  	if (!event)
>  		goto out;
> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> index 23b6385..1cc17ca 100644
> --- a/kernel/trace/trace_hw_branches.c
> +++ b/kernel/trace/trace_hw_branches.c
> @@ -180,7 +180,7 @@ void trace_hw_branch(u64 from, u64 to)
>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
>  		goto out;
>  
> -	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_HW_BRANCHES,
>  					  sizeof(*entry), 0, 0);
>  	if (!event)
>  		goto out;
