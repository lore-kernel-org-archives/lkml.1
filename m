Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab0BEONX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:13:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0BEONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:13:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=45efoH4BFn8A:10 a=7U3hwN5JcxgA:10 a=gig2LoNHlqGCPW9-oB8A:9 a=H0HBOQD3iFpXC_CYzq8A:7 a=ZdyAknogZ3zvf0FX2vBLJuXJ_3sA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 03/11] tracing: Inject lock_class_init events on
 registration
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1265188475-23509-4-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
	 <1265188475-23509-4-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Feb 2010 09:13:19 -0500
Message-ID: <1265379199.24386.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:

>  static inline void lockdep_off(void)
> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
> index 90af03c..6999f16 100644
> --- a/include/trace/events/lock.h
> +++ b/include/trace/events/lock.h
> @@ -9,7 +9,7 @@
>  
>  #ifdef CONFIG_LOCKDEP
>  
> -TRACE_EVENT(lock_class_init,
> +TRACE_EVENT_INJECT(lock_class_init,
>  
>  	TP_PROTO(struct lock_class *class),
>  
> @@ -30,7 +30,14 @@ TRACE_EVENT(lock_class_init,
>  		__entry->class_id = (void *)class->name;
>  	),
>  
> -	TP_printk("%p %s", __entry->class_id, __get_str(class_name))
> +	TP_printk("%p %s", __entry->class_id, __get_str(class_name)),
> +
> +	/*
> +	 * On activation, we want to send an event for each lock
> +	 * classes that have been recorded by lockdep, so that we
> +	 * catch up with the existing class:name mappings.
> +	 */
> +	lock_class_init_inject_events
>  );
>  

I also suggested this type of registering:

register_event_callback("event", "command", command_func, 
		command_enable_func,
		command_disable_func);

Where command_func, command_enable_func and command_disable_func can all
be a function pointer or NULL.

command_func gets called every time the event is hit while enabled.

command_enable_func gets called when the event is enabled

command_disable_func gets called when the event is disabled.

Hmm,

I could make it so that if the string "command" is NULL that these
functions are registered permanent, and can not be disabled by the user?
Otherwise, the user needs to set them with "echo command > command"

-- Steve


