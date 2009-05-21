Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZEUNKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZEUNKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZEUNJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:09:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40342 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZEUNJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:09:54 -0400
Date: Thu, 21 May 2009 15:05:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/workqueue: Get rid of searching last executed
	worklet in probe_worklet_complete()
Message-ID: <20090521130528.GA14149@redhat.com>
References: <4A153345.3040905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A153345.3040905@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, Zhaolei wrote:
>
> We don't need search workqueue's worklet list for worklet which was latest
> executed, instead, we can use a pointer in cpu_workqueue_stats to remember
> which worklet was just executed.

Minor nit,

> @@ -192,22 +192,11 @@ probe_worklet_complete(struct task_struct *wq_thread, void *work)
>  	goto end;
>
>  found_wq:
> -	list_for_each_entry(wfnode, &node->workfunclist, list) {
> -		u64 executed_time;
> +	executed_time = trace_clock_global() - node->last_workfunc->start_time;
> +	node->last_workfunc->total_time += executed_time;

Suppose that "enqueue" handler fails to allocate the memory for the new
work_struct.

This means that the "execute" handler does not record ->last_workfunc.

In that case probe_worklet_complete() uses the wrong workfunc_stats or
we can even crash if ->last_workfunc == NULL.

I think _execute() should set ->last_workfunc = NULL first, then serach
for wfnode. _complete() should check ->last_workfunc != NULL and return
if it is NULL.

Oleg.

