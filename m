Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYIGR3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYIGR3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 13:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYIGR3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 13:29:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYIGR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 13:29:42 -0400
Date: Sun, 7 Sep 2008 13:29:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
In-Reply-To: <20080907171143.3acdbedd@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0809071315370.6716@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com> <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com> <20080827212130.4b8365a8@daedalus.pq.iki.fi> <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com> <20080828214256.296e34ec@daedalus.pq.iki.fi>
 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com> <20080904203058.7e57729e@daedalus.pq.iki.fi> <20080907171143.3acdbedd@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 7 Sep 2008, Pekka Paalanen wrote:

> Steven,
> 
> is there a logic behind trace_seq_print_cont() printing the terminating
> newline only, when there actually is no TRACE_CONT entry?

Actually, that case is more of an anomaly than the correct. It means
that somehow the print statement wanted to continue, but did not. This 
means that the print statement probably did not finish the line, and
that we should do a newline to make sure the next entry starts on a
new line.

> 
> Hmm, wait a minute, I don't understand how this thing works at all.

Heh, I guess I need to add more comments :-/

> 
> Let's take for instance print_lat_fmt() which is the first user of
> trace_seq_print_cont(). Now, print_lat_fmt() does
> 
> 	struct trace_entry *entry = iter->ent;

iter->ent is the start of the entry to print. It is not necessarily
the current entry in the iteration buffer.

> 
> and uses 'entry'. Let's assume it is of type TRACE_PRINT. It does
> 
> 	case TRACE_PRINT:
> 		seq_print_ip_sym(s, field->print.ip, sym_flags);
> 		trace_seq_printf(s, ": %s", field->print.buf);
> 		if (field->flags & TRACE_FLAG_CONT)
> 			trace_seq_print_cont(s, iter);
> 		break;
> 
> Ok, it prints the beginning of the message, and if there should be
> continuation blocks, it calls trace_seq_print_cont(), defined as
> follows:
> 
> static void
> trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> {
> 	struct trace_array *tr = iter->tr;
> 	struct trace_array_cpu *data = tr->data[iter->cpu];
> 	struct trace_entry *ent;
> 
> 	ent = trace_entry_idx(tr, data, iter, iter->cpu);
> 	if (!ent || ent->type != TRACE_CONT) {
> 		trace_seq_putc(s, '\n');
> 		return;
> 	}
> 
> 	do {
> 		trace_seq_printf(s, "%s", ent->cont.buf);
> 		__trace_iterator_increment(iter, iter->cpu);
> 		ent = trace_entry_idx(tr, data, iter, iter->cpu);
> 	} while (ent && ent->type == TRACE_CONT);
> }

Because we do a merge sort of the entries in each CPU buffer, after we
get the next entry to print, we increment that iteration buffer. This
means that trace_entry_idx() will return the next entry field after
we got the iter->ent. This is also why we use iter->ent instead of
just calling trace_entry_idx. This keeps the merge sort simpler.

> 
> Here it uses trace_entry_idx() to get 'ent'. What's the difference to
> iter->ent? I don't understand how trace_entry_idx() works, but looking
> at how it is used, it must return the pointer to the *next* entry in
> the ring buffer. So I don't understand the name of the function, and I
> don't see a call to __trace_iterator_increment(), which is confusing.

iter->ent is the entry to be used in the "show" function. When we found 
that entry, we incremented the buffer to get it ready for the next
merge sort.

When we get to show, iter->ent is the entry to print, and if we use
iter_entry_idx() that will point to the next entry in that buffer that
will be used next time. I also did this to make it easier for the latency 
format be able to calculate the notations (like the '!').

> 
> If contrary to the assumption, 'ent' is not a continuation, it prints
> the terminating newline. This is an exceptional case, as the original
> entry was marked as having continuation entries.

Right, this is somehow an entry was flagged as continue, but it did not.
It is probably a bug in the code, and instead of writing a strange format,
where the next entry continued on the same line, I chose to let the
entry go onto the next line.

> 
> The normal case then is to execute the do-while, until it hits a
> non-continuation entry. Here it does *not* print the terminating newline.

Correct. The reason is that the ftrace_printk() call should have contained
its own new line. I could also add a check (and probably will) to see if
the printk did end with a newline, and add one if it did not.

> 
> Steven, could you explain what is going on here?

Just did ;-)

Hope it helps,

-- Steve
