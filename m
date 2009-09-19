Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZISNpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZISNpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 09:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZISNpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 09:45:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZISNpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 09:45:12 -0400
Subject: Re: [tip:tracing/urgent] tracing: Allocate the ftrace event
 profile buffer dynamically
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       lizf@cn.fujitsu.com, peterz@infradead.org, fweisbec@gmail.com,
       tglx@linutronix.de, jbaron@redhat.com, mhiramat@redhat.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-31dcbc09033bd90190e90d943863d7ef9f39b93b@git.kernel.org>
References: <tip-31dcbc09033bd90190e90d943863d7ef9f39b93b@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Sat, 19 Sep 2009 09:45:14 -0400
Message-Id: <1253367914.20020.338.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 07:58 +0000, tip-bot for Frederic Weisbecker
wrote:

> +/*
> + * We can't use a size but a type in alloc_percpu()
> + * So let's create a dummy type that matches the desired size
> + */
> +typedef struct {char buf[FTRACE_MAX_PROFILE_SIZE];} profile_buf_t;
> +
>  static int ftrace_profile_enable_event(struct ftrace_event_call *event)
>  {
> +	char *buf;
> +	int ret;
> +
>  	if (atomic_inc_return(&event->profile_count))
>  		return 0;
>  
> -	return event->profile_enable();
> +	buf = (char *)alloc_percpu(profile_buf_t);
> +	if (!buf)
> +		return -ENOMEM;

Ingo,

Did you pull in the version that allocates a buffer for each event? I
thought Frederic made just a global per cpu buffer that all events can
use. The buffer is just a temporary storage that will be too big to put
on the stack.

-- Steve

> +
> +	rcu_assign_pointer(event->profile_buf, buf);
> +
> +	buf = (char *)alloc_percpu(profile_buf_t);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto fail_nmi;
> +	}
> +
> +	rcu_assign_pointer(event->profile_buf_nmi, buf);
> +
> +	ret = event->profile_enable();
> +	if (!ret)
> +		return 0;
> +
> +	kfree(event->profile_buf_nmi);
> +fail_nmi:
> +	kfree(event->profile_buf);
> +
> +	return ret;
>  }
>  

