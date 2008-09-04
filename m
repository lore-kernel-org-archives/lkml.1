Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYIDRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYIDRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYIDRbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:31:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:30699 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYIDRbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=ZN80uAuwuPWcOkx95PsAPl9ISVk15CA4p0XAtNY36dKtKIcx8zj+R5qIkFmx6cNVPG
         a9+uiRMZSmkA49dbjH8O2+hb8HDnea5yw+ngXaW/GbaN0MpcrwkSYwyOour5+y7XmXhE
         ef6lj3VqK25p+BV42m4zG1xN+Egpk+tXtYcgU=
Date: Thu, 4 Sep 2008 20:30:58 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080904203058.7e57729e@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
References: <48B1D5CA.8000607@gmail.com>
	<c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	<20080827212130.4b8365a8@daedalus.pq.iki.fi>
	<c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
	<20080828214256.296e34ec@daedalus.pq.iki.fi>
	<c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 18:20:09 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> What is the best way to implement tracers's printk handlers?

Your last message had an idea I didn't think before (or I misunderstood
you), that there could be an optional callback for inserting markers
into the ring buffer. My first thought was to have the usual entry
handler (print_line callback) to format marker text when it is taken
from the ring buffer and read to user space.

> Do you think that these functions must be implemented in trace.c or is
> it more relevant to dispatch the message to
> a function provided by the current tracer in its struct tracer
> operations? If such handler is not implemented, we just defaults the
> formatting like ftrace_printk does.

For the output formatting case, I'd prefer the print_line callback,
it's just one more case for an entry type in there. Notice the
difference between writing to ring buffer and reading to user.

The trick is, when does mmiotrace sanitize the marker text, when it
comes from user space, the debugfs file. Either
a) have another callback for inserting messages into the ring buffer
b) have a customisable trace_seq_print_cont()

I think I'd favour b). When I tried to use trace_seq_print_cont(),
I found it difficult to control the printing of \n at the end of
message. So I would implement my own routine to handle also what
trace_seq_print_cont() does, filtering the text while copying it
to struct trace_seq. I'm not sure where this function should live.
It could be useful to all tracers, that want "one line per marker
entry" style output, so it could live in trace.c.

So my suggestion is to put the marker text unfiltered into the ring
buffer, and filter it (if required) during read to user (print_line).


Cheers,
pq

-- 
Pekka Paalanen
http://www.iki.fi/pq/
