Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZLIQ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZLIQ0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 11:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZLIQ0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 11:26:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbZLIQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 11:26:54 -0500
X-Authority-Analysis: v=1.0 c=1 a=SxjS2MsuMSQA:10 a=7U3hwN5JcxgA:10 a=h6exnWOQHSoof0EG2eQA:9 a=H8GqsPPdBK8ARyf4OMUA:7 a=D-6LeoamDDURWtRRouK_h8CnkUMA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/2][RFC] [RFC] tracing: separate out buffer from
 trace_seq
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <4B1F7198.708@cn.fujitsu.com>
References: <20091208195405.653797300@goodmis.org>
	 <4B1F7198.708@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 11:26:59 -0500
Message-ID: <1260376019.2146.90.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 17:44 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:

> > Steven Rostedt (2):
> >       tracing: Change trace_seq to use separate buffer
> >       tracing: Write directly into splice page for trace_pipe
> 
> It's great that you wrote it and trace_pipe benefit from it.
> And it show separate buffer is required.
> 
> But I didn't expect so much/big changes. I'm wondering that

Yeah, I first did a patch (and I still have it) that keeps the trace_seq
structure as is. But then I decided to bite the bullet and just convert
it to a print helper.

> we can use seq file directly for some files and
> kill all kmalloc(sizeof(struct trace_seq)).
> 
> kernel/trace/trace.c:3720:      s = kmalloc(sizeof(*s), GFP_KERNEL);
> We can use a short buffer + simple_read_from_buffer()
> Or seq file.

Heh, yeah that usage of trace_seq was not necessary. It looks like a
handler for sprintf only.


> 
> kernel/trace/trace_events.c:539:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> We can use seq file after of my patchset(today) is applied.

Yeah, sure.

> 
> kernel/trace/trace_events.c:580:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> we can use a shor buffer. "char buf[20]" + simple_read_from_buffer()
> 
> kernel/trace/trace_events.c:604:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> We can use a short buffer + simple_read_from_buffer()
> Or seq file.
> 
> kernel/trace/trace_events.c:660:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> We can use a short buffer + simple_read_from_buffer()
> Or seq file.

Yep to the above.

> 
> kernel/trace/trace_events.c:715:        s = kmalloc(sizeof(*s), GFP_KERNEL);
> We can use seq file.

Hmm, this I'm not so sure about (my line numbers are off, this is
"show_header" right?).

The reason that I wrote trace_seq is to let functions write to whatever
buffer they want to. Not just a seq_file. This function calls other
functions that write to this buffer, and in the future, this buffer may
not be from a normal read.


> 
> kernel/trace/trace_ksym.c:230:  s = kmalloc(sizeof(*s), GFP_KERNEL);
> We should use seq! It's very bad that we use trace_seq.

I agree that seq_file should be used here, but I would not say it was
"very bad" to use trace_seq.

> 
> For function_stat_show(), it uses static trace_seq. but it can also
> use a short buffer + simple_read_from_buffer().

No it can't. It uses it to call trace_print_graph_duration which is used
for trace and trace_pipe (and others). This requires the trace_seq
structure.

> 
> I will do this.(or you if you would like to)

The ones that I said above are fine, you can do. Also split the patches
up per section. That is, the trace_seq -> small buffer +
simple_read_from_buffer should be a separate patch than the conversion
to seq_file.

Note, one reason others have used trace_seq over seq_file is that the
seq_file is a confusing interface. I constantly get it wrong. Helper
functions should be simplistic and intuitive, not something to spend
time debugging when it is suppose to be helping.

I agree with most of the above conversions, but I don't want to convert
all of them just because they can be. seq_file can limit their usage.

> 
> So could you write a simpler version of separate-buffer-trace_seq
> with supposition that all kmalloc(sizeof(struct trace_seq)) are removed.

Make the above changes (where I agreed), then I'll rewrite this patch on
top of yours.

OK?

Thanks!

-- Steve


