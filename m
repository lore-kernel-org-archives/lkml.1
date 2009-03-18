Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZCRBhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZCRBhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbZCRBhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:37:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZCRBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:37:06 -0400
Date: Tue, 17 Mar 2009 21:37:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH 3/4] tracing: add per-event filtering
In-Reply-To: <1237271031.8033.151.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903172131340.10610@gandalf.stny.rr.com>
References: <1237271031.8033.151.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 17 Mar 2009, Tom Zanussi wrote:
> diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
> index 30627d8..d556274 100644
> --- a/kernel/trace/trace_events_stage_3.h
> +++ b/kernel/trace/trace_events_stage_3.h
> @@ -154,6 +154,7 @@ static struct ftrace_event_call event_##call;				\
>  									\
>  static void ftrace_raw_event_##call(proto)				\
>  {									\
> +	struct ftrace_event_call *call = &event_##call;			\
>  	struct ring_buffer_event *event;				\
>  	struct ftrace_raw_##call *entry;				\
>  	unsigned long irq_flags;					\
> @@ -172,6 +173,9 @@ static void ftrace_raw_event_##call(proto)				\
>  	assign;								\
>  									\
>  	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\

I have a concern hear about races.  Once the commit happens, there's 
nothing protecting us from being preempted. The reader could in fact come 
in and consume the commit, and a new write may happen, and this discard 
will corrupt the data in the buffer. Also in overwrite mode, the writer 
itself can over write this.

Would you be able to move the above unlock_commit after this.
I'll make the necessary changes in the commit to check for discarded data.

Thanks,

-- Steve



> +									
\ > +	if (call->preds && !filter_match_preds(call, entry))		\
> +		rb_event_discard(event);				\
>  }									\
>  									\
>  static int ftrace_raw_reg_event_##call(void)				\
> -- 
> 1.5.6.3
> 
> 
> 
> 
> 
> 
> 
