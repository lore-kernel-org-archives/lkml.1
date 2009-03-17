Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbZCQWys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbZCQWys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZCQWyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:54:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47557 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbZCQWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:54:38 -0400
Date: Tue, 17 Mar 2009 18:54:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 05/11] ftrace: ensure every event gets an id
In-Reply-To: <20090317220420.179694035@chello.nl>
Message-ID: <alpine.DEB.2.00.0903171853540.10610@gandalf.stny.rr.com>
References: <20090317215606.037073805@chello.nl> <20090317220420.179694035@chello.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Peter Zijlstra wrote:

> Previously only TRACE_EVENT events got ids, because only they generated
> raw output which needs to be demuxed from the trace.
> 
> In order to provide a unique ID for each event, register everybody, regardless.

If this is about the TRACE_FORMAT, they use the TRACE_PRINT format, which
is exported.

Again, I need to look at the rest of the patches ;-)

-- Steve

> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/trace/trace_events_stage_3.h |   15 ++++++++++++++-
>  kernel/trace/trace_output.c         |    5 +++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/trace/trace_events_stage_3.h
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_events_stage_3.h
> +++ linux-2.6/kernel/trace/trace_events_stage_3.h
> @@ -130,7 +130,19 @@ static void ftrace_unreg_event_##call(vo
>  {									\
>  	unregister_trace_##call(ftrace_event_##call);			\
>  }									\
> -
> +									\
> +static struct ftrace_event_call event_##call;				\
> +									\
> +static int ftrace_init_event_##call(void)				\
> +{									\
> +	int id;								\
> +									\
> +	id = register_ftrace_event(NULL);				\
> +	if (!id)							\
> +		return -ENODEV;						\
> +	event_##call.id = id;						\
> +	return 0;							\
> +}
>  
>  #undef TRACE_FORMAT
>  #define TRACE_FORMAT(call, proto, args, fmt)				\
> @@ -140,6 +152,7 @@ __attribute__((__aligned__(4)))						\
>  __attribute__((section("_ftrace_events"))) event_##call = {		\
>  	.name			= #call,				\
>  	.system			= __stringify(TRACE_SYSTEM),		\
> +	.raw_init		= ftrace_init_event_##call,		\
>  	.regfunc		= ftrace_reg_event_##call,		\
>  	.unregfunc		= ftrace_unreg_event_##call,		\
>  }
> Index: linux-2.6/kernel/trace/trace_output.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_output.c
> +++ linux-2.6/kernel/trace/trace_output.c
> @@ -444,6 +444,11 @@ int register_ftrace_event(struct trace_e
>  
>  	mutex_lock(&trace_event_mutex);
>  
> +	if (!event) {
> +		ret = next_event_type++;
> +		goto out;
> +	}
> +
>  	if (!event->type)
>  		event->type = next_event_type++;
>  	else if (event->type > __TRACE_LAST_TYPE) {
> 
> -- 
> 
> 
