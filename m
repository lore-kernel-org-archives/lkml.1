Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYIHRTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYIHRTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYIHRTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:19:33 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:45004 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYIHRTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=MNES57+uZW554YmB/6SBXCvRCkzVQuTlNd4XlnD+WtZ3bezJqkNuj2ioemKfl1rS5s
         YeXalr/wKHqjWGwYTXHWT86ftKzUMa0rVwqIT23zrQA3j6pG80zCK/Ir3nw7t0p5fqvA
         RQJjYm4771DVExl3oOM+yjExc+oeR0iXa4QzY=
Date: Mon, 8 Sep 2008 20:19:23 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080908201923.192373d3@daedalus.pq.iki.fi>
In-Reply-To: <alpine.DEB.1.10.0809071315370.6716@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
	<20080907171143.3acdbedd@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0809071315370.6716@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2008 13:29:40 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Sun, 7 Sep 2008, Pekka Paalanen wrote:
> 
> > Steven,
> > 
> > is there a logic behind trace_seq_print_cont() printing the terminating
> > newline only, when there actually is no TRACE_CONT entry?
> 
> Actually, that case is more of an anomaly than the correct. It means
> that somehow the print statement wanted to continue, but did not. This 
> means that the print statement probably did not finish the line, and
> that we should do a newline to make sure the next entry starts on a
> new line.

Oh, I never thought it from that point of view.

> > static void
> > trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> > {
> > 	struct trace_array *tr = iter->tr;
> > 	struct trace_array_cpu *data = tr->data[iter->cpu];
> > 	struct trace_entry *ent;
> > 
> > 	ent = trace_entry_idx(tr, data, iter, iter->cpu);
> > 	if (!ent || ent->type != TRACE_CONT) {
> > 		trace_seq_putc(s, '\n');
> > 		return;
> > 	}
> > 
> > 	do {
> > 		trace_seq_printf(s, "%s", ent->cont.buf);
> > 		__trace_iterator_increment(iter, iter->cpu);
> > 		ent = trace_entry_idx(tr, data, iter, iter->cpu);
> > 	} while (ent && ent->type == TRACE_CONT);
> > }
> 
> Because we do a merge sort of the entries in each CPU buffer, after we
> get the next entry to print, we increment that iteration buffer. This
> means that trace_entry_idx() will return the next entry field after
> we got the iter->ent. This is also why we use iter->ent instead of
> just calling trace_entry_idx. This keeps the merge sort simpler.

Yes, I forgot the per-cpu buffers. When merging you want the first one
wrt. timestamp, and when continuing you want the next on that cpu's
buffer.

> > Here it uses trace_entry_idx() to get 'ent'. What's the difference to
> > iter->ent? I don't understand how trace_entry_idx() works, but looking
> > at how it is used, it must return the pointer to the *next* entry in
> > the ring buffer. So I don't understand the name of the function, and I
> > don't see a call to __trace_iterator_increment(), which is confusing.
> 
> iter->ent is the entry to be used in the "show" function. When we found 
> that entry, we incremented the buffer to get it ready for the next
> merge sort.
> 
> When we get to show, iter->ent is the entry to print, and if we use
> iter_entry_idx() that will point to the next entry in that buffer that
> will be used next time. I also did this to make it easier for the latency 
> format be able to calculate the notations (like the '!').
> 
> > If contrary to the assumption, 'ent' is not a continuation, it prints
> > the terminating newline. This is an exceptional case, as the original
> > entry was marked as having continuation entries.
> 
> Right, this is somehow an entry was flagged as continue, but it did not.
> It is probably a bug in the code, and instead of writing a strange format,
> where the next entry continued on the same line, I chose to let the
> entry go onto the next line.
> 
> > The normal case then is to execute the do-while, until it hits a
> > non-continuation entry. Here it does *not* print the terminating newline.
> 
> Correct. The reason is that the ftrace_printk() call should have contained
> its own new line. I could also add a check (and probably will) to see if
> the printk did end with a newline, and add one if it did not.

My first idea was to filter out all newlines from messages, making a
message a single line, and then force a newline, but now I realize
that would be an exception to the printk convention. Maybe I should
just start a new line in the output, when I get a newline :-)
Although that probably means my version of trace_seq_print_cont() must
live in trace.c, which IMHO is over-crowded already.

But then there's a small chance the whole output of a single
TRACE_PRINT entry might not fit into one trace_seq ever, since each
line in mmiotrace has a prologue. Oh well, can't win always, I'll just
drop what doesn't fit into output.

Hmm, it already does that, doesn't it, if the output does not fit into
trace_seq buffer. There might be a corner case...

> > Steven, could you explain what is going on here?
> 
> Just did ;-)
> 
> Hope it helps,

Oh yes, thank you very much :-)

btw. How do you feel about moving the #ifdef CONFIG_MMIOTRACE functions
from trace.c to trace_mmiotrace.c and unstatifying all the functions
they need? Seems some of them are inline, and the spinlock stuff just
looks so... raw :-)

-- 
Pekka Paalanen
http://www.iki.fi/pq/
