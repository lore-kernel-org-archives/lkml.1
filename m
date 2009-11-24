Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbZKXROF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbZKXROF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 12:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbZKXROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 12:14:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63523 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933492AbZKXROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 12:14:00 -0500
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 12:14:05 -0500
Message-Id: <1259082845.22249.1110.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 13:57 +0100, Jiri Olsa wrote:
> Hi,
> 
> there's a case where the graph tracer might get confused and omits
> display of a single record.  This applies for both destructive
> (trace_pipe) and nondestructive (trace) cases.
> 
> 
> <issue description>
> 
> The issue description for nondestructive case (trace) follows:
> 
> As the function_graph tracer goes through the trace entries (using "trace" file)
> it keeps pointer to the current record and the next one:
> 
> current ->  func1 ENTRY
>    next ->  func2 ENTRY
>             func2 RETURN
>             func1 RETURN
> 
> If it spots adjacent ENTRY and RETURN trace entries of the same function
> and pid, it displays the "func2();" trace
> 
>             func1 ENTRY
> current ->  func2 ENTRY 
>    next ->  func2 RETURN
>             func1 RETURN
> 
> and moves the next trace entry pointer behind the RETURN entry
> 
>             func1 ENTRY
> current ->  func2 ENTRY 
>             func2 RETURN
>    next ->  func1 RETURN
> 
> so the next record peek will skip the RETURN entry and continue with
> whatever is next.
> 
> It works ok but for one case. 
> 
> If the "func2()" trace does not make it to the seq_file read buffer, it needs

In the trace_pipe it may be possible to fill the trace_seq buffer if the
buffer passed into userspace is larger than the trace_seq buffer. But
the trace_seq buffer should never overflow on the "trace" case. If it
is, then there's probably another bug.


> to be processed again in the next read.  And here comes the issue: 
> the next read will see following pointers setup for func2 processing:
> 
>             func1 ENTRY
> current ->  func2 ENTRY 
>             func2 RETURN
>    next ->  func1 RETURN
> 
> which will turn to displaying the func2 entry like: "func2() {", since the
> next entry is not RETURN of the same type.  Generaly it is whatever entry 
> that follows, but definitelly not the RETURN entry of the same function.
> 
> The destructive case (trace_pipe) suffers from the similar issue,
> although it keeps only the current pointer.
> 
> </issue description>
> 
> 
> The following patch propose generic solution for both cases.
> It keeps the last read entry/return in the tracer private
> iterator storage and keeps track of the failed output.
> Whenever the output fails, next read will output previous
> 'not displayed' entry before processing next entry.

Have you added tests to make sure that the trace_seq buffer is indeed
filling up?  In the trace_pipe, this could happen when the user buffer
gets full.

What I think you are seeing, is a buffer overflow during a run. If the
trace buffer overflows, it will leave gaps in the trace. Those abandoned
leaf functions are probably a result of a trace buffer wrap.

I don't thing this is the proper solution to the problem.

> 


>  static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 874f289..ca52715 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3049,10 +3049,14 @@ waitagain:

(side note)

This is why I like to have spaces in front of labels (not a comment on
this patch). I hate trying to figure out what function this is for :-p
Luckily, in this case, there's only one function with "waitagain" label.

>  	if (cnt >= PAGE_SIZE)
>  		cnt = PAGE_SIZE - 1;
>  
> -	/* reset all but tr, trace, and overruns */
> -	memset(&iter->seq, 0,
> +	/*
> +	 * Reset all but tr, trace, and overruns. Preserve 'failed'
> +	 * field in the trace_seq structure.
> +	 */
> +	trace_seq_init(&iter->seq);
> +	memset(&iter->ent, 0,
>  	       sizeof(struct trace_iterator) -
> -	       offsetof(struct trace_iterator, seq));
> +	       offsetof(struct trace_iterator, ent));
>  	iter->pos = -1;
>  
>  	trace_event_read_lock();


-- Steve


