Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYIGOMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYIGOMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 10:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYIGOLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 10:11:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:20431 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYIGOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 10:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=dHGsL9Vo6AkFVqPDP9xERh+GOus3z3PVxjuZPE7muo8CCi0s2+G0EC0MD74gwNnxzP
         oiqHW74NQgDFuWSXuky4F78/VJ8jjLo5tUB+Qz6M6ToVwKORHDqG5zruKFF6ndHD62zT
         0kYgf/ImMMoFA9BA6JrbMAfk7RGAg7PsAbXJ0=
Date: Sun, 7 Sep 2008 17:11:43 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080907171143.3acdbedd@daedalus.pq.iki.fi>
In-Reply-To: <20080904203058.7e57729e@daedalus.pq.iki.fi>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
	<20080904203058.7e57729e@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

is there a logic behind trace_seq_print_cont() printing the terminating
newline only, when there actually is no TRACE_CONT entry?

Hmm, wait a minute, I don't understand how this thing works at all.

Let's take for instance print_lat_fmt() which is the first user of
trace_seq_print_cont(). Now, print_lat_fmt() does

	struct trace_entry *entry = iter->ent;

and uses 'entry'. Let's assume it is of type TRACE_PRINT. It does

	case TRACE_PRINT:
		seq_print_ip_sym(s, field->print.ip, sym_flags);
		trace_seq_printf(s, ": %s", field->print.buf);
		if (field->flags & TRACE_FLAG_CONT)
			trace_seq_print_cont(s, iter);
		break;

Ok, it prints the beginning of the message, and if there should be
continuation blocks, it calls trace_seq_print_cont(), defined as
follows:

static void
trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
{
	struct trace_array *tr = iter->tr;
	struct trace_array_cpu *data = tr->data[iter->cpu];
	struct trace_entry *ent;

	ent = trace_entry_idx(tr, data, iter, iter->cpu);
	if (!ent || ent->type != TRACE_CONT) {
		trace_seq_putc(s, '\n');
		return;
	}

	do {
		trace_seq_printf(s, "%s", ent->cont.buf);
		__trace_iterator_increment(iter, iter->cpu);
		ent = trace_entry_idx(tr, data, iter, iter->cpu);
	} while (ent && ent->type == TRACE_CONT);
}

Here it uses trace_entry_idx() to get 'ent'. What's the difference to
iter->ent? I don't understand how trace_entry_idx() works, but looking
at how it is used, it must return the pointer to the *next* entry in
the ring buffer. So I don't understand the name of the function, and I
don't see a call to __trace_iterator_increment(), which is confusing.

If contrary to the assumption, 'ent' is not a continuation, it prints
the terminating newline. This is an exceptional case, as the original
entry was marked as having continuation entries.

The normal case then is to execute the do-while, until it hits a
non-continuation entry. Here it does *not* print the terminating newline.

Steven, could you explain what is going on here?


Thanks.



On Thu, 4 Sep 2008 20:30:58 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> b) have a customisable trace_seq_print_cont()
> 
> I think I'd favour b). When I tried to use trace_seq_print_cont(),
> I found it difficult to control the printing of \n at the end of
> message. So I would implement my own routine to handle also what
> trace_seq_print_cont() does, filtering the text while copying it
> to struct trace_seq. I'm not sure where this function should live.
> It could be useful to all tracers, that want "one line per marker
> entry" style output, so it could live in trace.c.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
