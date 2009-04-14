Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZDNCu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZDNCu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZDNCuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:50:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47539 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZDNCuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:50:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2 4/4] ftrace: add latecy mesurement feature to workqueue tracer
Cc: kosaki.motohiro@jp.fujitsu.com, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090413145335.6E10.A69D9226@jp.fujitsu.com>
References: <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145335.6E10.A69D9226@jp.fujitsu.com>
Message-Id: <20090414114908.C63A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 11:50:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: b/include/trace/workqueue_event_types.h
> ===================================================================
> --- a/include/trace/workqueue_event_types.h	2009-04-13 13:58:21.000000000 +0900
> +++ b/include/trace/workqueue_event_types.h	2009-04-13 14:07:14.000000000 +0900
> @@ -43,6 +43,8 @@ TRACE_EVENT(workqueue_handler_entry,
>  		__field(pid_t,			thread_pid)
>  		__field(struct work_struct *,	work)
>  		__field(work_func_t,		func)
> +		__field(unsigned long,		expected_time)
> +		__field(unsigned long,		actual_time)
>  	),
>  
>  	TP_fast_assign(
> @@ -50,10 +52,14 @@ TRACE_EVENT(workqueue_handler_entry,
>  		__entry->thread_pid	= wq_thread->pid;
>  		__entry->work		= work;
>  		__entry->func		= work->func;
> +		__entry->expected_time	= work->expected_time;
> +		__entry->actual_time	= jiffies;
>  	),

Oops, that's my fault.
There is work->expected_time only if CONFIG_WORKQUEUE_TRACER is on.


>  
> -	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
> -		__entry->thread_pid, __entry->func)
> +	TP_printk("thread=%s:%d latency=%lums func=%pF", __entry->thread_comm,
> +		  __entry->thread_pid,
> +		  jiffies_to_msecs(__entry->actual_time-__entry->expected_time),
> +		  __entry->func)
>  );



