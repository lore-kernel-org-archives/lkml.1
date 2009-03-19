Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbZCSUwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbZCSUwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZCSUw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:52:27 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43259 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZCSUw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c6gEVwA+OwAUlK/OuXeyGKuYcfiEc3CrmiWDVkSTTypZI9SHuho24msZOW0Sv8jmOh
         xb5byiNUaN/XrYuBHI81Splhmk8KjVpkVzWda2nRaezVrXRv5LX0kFqcDSZGUTJpR93d
         CwmPtcsa6Pcu9V1xNP/wRQ9x/e4eRT65g7f/U=
Date: Thu, 19 Mar 2009 21:52:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 7/7] function-graph: show binary events as comments
Message-ID: <20090319205219.GB5935@nowhere>
References: <20090319200122.512803803@goodmis.org> <20090319200201.217098940@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319200201.217098940@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 04:01:29PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> With the added TRACE_EVENT macro, the events no longer appear in
> the function graph tracer. This was because the function graph
> did not know how to display the entries. The graph tracer was
> only aware of its own entries and the printk entries.
> 
> By using the event call back feature, the graph tracer can now display
> the events.
> 
>  # echo irq > /debug/tracing/set_event
> 
> Which can show:
> 
>  0)               |          handle_IRQ_event() {
>  0)               |            /* irq_handler_entry: irq=48 handler=eth0 */
>  0)               |            e1000_intr() {
>  0)   0.926 us    |              __napi_schedule();
>  0)   3.888 us    |            }
>  0)               |            /* irq_handler_exit: irq=48 return=handled */
>  0)   0.655 us    |            runqueue_is_locked();
>  0)               |            __wake_up() {
>  0)   0.831 us    |              _spin_lock_irqsave();
> 
> The irq entry and exit events show up as comments.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>


Thanks a lot for this whole patchset :-)

Frederic.


> ---
>  kernel/trace/trace_functions_graph.c |   40 +++++++++++++++++++++++----------
>  1 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 66ea23b..e876816 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -712,10 +712,12 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
>  }
>  
>  static enum print_line_t
> -print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
> -		   struct trace_entry *ent, struct trace_iterator *iter)
> +print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
> +		    struct trace_iterator *iter)
>  {
> +	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
>  	struct fgraph_data *data = iter->private;
> +	struct trace_event *event;
>  	int depth = 0;
>  	int ret;
>  	int i;
> @@ -751,9 +753,26 @@ print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
>  	if (!ret)
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
> -	ret = trace_seq_bprintf(s, trace->fmt, trace->buf);
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	switch (iter->ent->type) {
> +	case TRACE_BPRINT:
> +		ret = trace_print_bprintk_msg_only(iter);
> +		if (ret != TRACE_TYPE_HANDLED)
> +			return ret;
> +		break;
> +	case TRACE_PRINT:
> +		ret = trace_print_printk_msg_only(iter);
> +		if (ret != TRACE_TYPE_HANDLED)
> +			return ret;
> +		break;
> +	default:
> +		event = ftrace_find_event(ent->type);
> +		if (!event)
> +			return TRACE_TYPE_UNHANDLED;
> +
> +		ret = event->trace(iter, sym_flags);
> +		if (ret != TRACE_TYPE_HANDLED)
> +			return ret;
> +	}
>  
>  	/* Strip ending newline */
>  	if (s->buffer[s->len - 1] == '\n') {
> @@ -772,8 +791,8 @@ print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
>  enum print_line_t
>  print_graph_function(struct trace_iterator *iter)
>  {
> -	struct trace_seq *s = &iter->seq;
>  	struct trace_entry *entry = iter->ent;
> +	struct trace_seq *s = &iter->seq;
>  
>  	switch (entry->type) {
>  	case TRACE_GRAPH_ENT: {
> @@ -786,14 +805,11 @@ print_graph_function(struct trace_iterator *iter)
>  		trace_assign_type(field, entry);
>  		return print_graph_return(&field->ret, s, entry, iter);
>  	}
> -	case TRACE_BPRINT: {
> -		struct bprint_entry *field;
> -		trace_assign_type(field, entry);
> -		return print_graph_comment(field, s, entry, iter);
> -	}
>  	default:
> -		return TRACE_TYPE_UNHANDLED;
> +		return print_graph_comment(s, entry, iter);
>  	}
> +
> +	return TRACE_TYPE_HANDLED;
>  }
>  
>  static void print_graph_headers(struct seq_file *s)
> -- 
> 1.6.2
> 
> -- 

