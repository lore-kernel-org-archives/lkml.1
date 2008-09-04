Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYIDSLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYIDSLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYIDSLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:11:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYIDSLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:11:08 -0400
Date: Thu, 4 Sep 2008 14:11:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
In-Reply-To: <20080904203058.7e57729e@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com> <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com> <20080827212130.4b8365a8@daedalus.pq.iki.fi> <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com> <20080828214256.296e34ec@daedalus.pq.iki.fi>
 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com> <20080904203058.7e57729e@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Sep 2008, Pekka Paalanen wrote:

> On Thu, 4 Sep 2008 18:20:09 +0200
> "Fr?d?ric Weisbecker" <fweisbec@gmail.com> wrote:
> 
> > What is the best way to implement tracers's printk handlers?
> 
> Your last message had an idea I didn't think before (or I misunderstood
> you), that there could be an optional callback for inserting markers
> into the ring buffer. My first thought was to have the usual entry
> handler (print_line callback) to format marker text when it is taken
> from the ring buffer and read to user space.
> 
> > Do you think that these functions must be implemented in trace.c or is
> > it more relevant to dispatch the message to
> > a function provided by the current tracer in its struct tracer
> > operations? If such handler is not implemented, we just defaults the
> > formatting like ftrace_printk does.
> 
> For the output formatting case, I'd prefer the print_line callback,
> it's just one more case for an entry type in there. Notice the
> difference between writing to ring buffer and reading to user.
> 
> The trick is, when does mmiotrace sanitize the marker text, when it
> comes from user space, the debugfs file. Either
> a) have another callback for inserting messages into the ring buffer
> b) have a customisable trace_seq_print_cont()
> 
> I think I'd favour b). When I tried to use trace_seq_print_cont(),
> I found it difficult to control the printing of \n at the end of
> message. So I would implement my own routine to handle also what
> trace_seq_print_cont() does, filtering the text while copying it
> to struct trace_seq. I'm not sure where this function should live.
> It could be useful to all tracers, that want "one line per marker
> entry" style output, so it could live in trace.c.
> 
> So my suggestion is to put the marker text unfiltered into the ring
> buffer, and filter it (if required) during read to user (print_line).
> 

For logdev (my pet project from way back, and the latest ftrace is based 
on), I had a CUSTOM type. The API allowed to register a callback to a 
type, and it would associate that type to some number (descriptor) and 
pass that number back to you. Then you could use this number to write to 
the buffer using the CUSTOM type and registered number. On output, when a 
CUSTOM type is detected, it would read the custom.id (the number) and 
search for any registered callbacks to handle the entry.

This probably would not be too difficult to implement. Especially since it 
is already implemented in logdev.
(see http://rostedt.homelinux.com/logdev/)

-- Steve

