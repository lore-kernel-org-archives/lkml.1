Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZKYQVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZKYQVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZKYQVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:21:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZKYQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:21:15 -0500
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
	 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
	 <20091124211423.GE5071@nowhere>
	 <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 25 Nov 2009 11:21:20 -0500
Message-Id: <1259166080.21397.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 09:45 +0100, Jiri Olsa wrote:
> On Tue, Nov 24, 2009 at 10:14:36PM +0100, Frederic Weisbecker wrote:

> > 
> > Hmm, yeah in trace_pipe case we repeat until we have no space
> > left in trace_seq (TRACE_TYPE_PARTIAL_LINE), or until we
> > the user buffer is filled.
> > 
> > But indeed in case of trace file, we are using a seq file
> > so the buffer gets flushed after each entries.
> > 
> > Assuming the trace_seq is 4096 bytes long this is probably
> > enough for every function graph entries (even with headers and
> > interrupts), this is not something we are supposed to see in trace_seq.
> > 
> > I did not realized that when Jiri sent the first version of this patch.
> 
> sure, but it is not the trace_seq structure that overflows, it is the bare 
> seq_file underneath. The s_show calls "trace_print_seq":
> 
> void trace_print_seq(struct seq_file *m, struct trace_seq *s)
> {               
>         int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
>         
>         seq_write(m, s->buffer, len);
> 
>         trace_seq_init(s);
> }               
> 
> it flushes the trace_seq to the seq_file and reinits the trace_seq.
> But the seq_file will get filled in the end, ending up with
> not displayed output in that case I described in the first email.
> 

First note, the filling of the trace_seq is only an issue with
trace_pipe. The trace file never has this issue because it uses the
trace_seq once per event, and there exists no event that is bigger than
a page.


The trace_pipe fills as much as it can because it is doing it live and
wants to be as fast as possible, and it is passing information between
user and kernel. Thus it will try to pass as much to userspace as
possible.


Now any issue with the trace file is not caused by trace_seq. But lets
look at what is happening with trace_pipe.

In tracing_read_pipe, we do the following:

	len = iter->seq.len;

	ret = print_trace_line(iter);
	if (ret == TRACE_TYPE_PARTIAL_LINE) {
		iter->seq.len = len;  /* this removes any partial write */
		break;
	}

	if (ret != TRACE_TYPE_NO_CONSUME)
		trace_consume(iter);

	if (iter->seq.len >= cnt)
		break;


The above is contained in a loop. It stops when either there are no more
events, the trace_seq buffer is full or we fill the users buffer.

The print_trace_line is what eventually goes into the function graph
tracer calling print_graph_function.

The call get_return_for_leaf figures out if this is a leaf function or
not.

	ring_iter = iter->buffer_iter[iter->cpu];

	if (ring_iter)
		event = ring_buffer_iter_peak(ring_iter, NULL);
	else {
		ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
		event = ring_buffer_peak(iter->tr->buffer, iter->cpu,
					NULL);
	}

ring_iter is NULL on trace_pipe, so we consume the event. If the next
item is not a graph item, it will be consumed in the loop described
above and lost.

In the case of print_graph_entry_nested, where we don't want to discard
the consumed event, on success it returns: TRACE_TYPE_NO_CONSUME, so
that the event does not get consumed.

But if the buffer fills up, and we exit with TRACE_TYPE_PARTIAL_LINE, we
lost the current event :-(  That is, it was consumed and not read. The
next read by userspace that calls the find_next_entry_inc() will not
have the correct entry.

Looking at this deeper, I'm not sure the find_next_entry_inc is correct
here. If we break out of the loop by filling up the seq buffer, we lose
that event all together. I'll look deeper into this.

Thanks,

-- Steve


