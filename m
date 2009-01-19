Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbZASVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbZASVI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZASVIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:08:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:51489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZASVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:08:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fX3iaGioS22z26/AM8Djch2pzYYbAphA2FpEfFANSaBFd+v4iODNkGLEs/YkHEfiU/
         NbuZ1GJr8NriOFO37ZHnusCziV/2dAr0D7UZNh07q6xkJDZi6VwWA0kwv+G6C5uU5arS
         uT/rruPdDjFftH92xNBxNSUYPuVGZNhZWtutw=
Date: Mon, 19 Jan 2009 22:08:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ftrace: infrastructure for supporting binary record
Message-ID: <20090119210839.GA6194@nowhere>
References: <495ADF45.2030203@cn.fujitsu.com> <20081231045956.GC28472@nowhere> <39e6f6c70901021424v28c1a7dbgbaaf67ac12ca9526@mail.gmail.com> <c62985530901191128k5a76fe4bh4fae585b8febf6c@mail.gmail.com> <20090119202523.GE690@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119202523.GE690@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 06:25:23PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 19, 2009 at 08:28:03PM +0100, Frédéric Weisbecker escreveu:
> > 2009/1/2 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> > >
> > > warning: I haven't looked at the patch details
> > >
> > > But I would love to use something like this to provide the exact
> > > contents the userspace blktrace utilities want.
> > >
> > > - Arnaldo
> > >
> > 
> > 
> > Hi Arnaldo,
>  
> > Since you talked about binary record for the blk tracer, I just recall
> > this patch.  Are you sure this infrastructure would cover your needs?
> 
> Nope, now that I look at it it definetely isn't what I need. See? the
> warning was valid after all :-)
> 
> What I want and will experiment now is to almost dump the contents of
> the ring buffer as-is to userspace. I want that so that I can use
> blkparse to validate the ring buffer + blkFtrace routines produced
> buffer.
> 
> So probably it will be a matter of using trace_iter to signal that, and
> when it gets to my print_line routine I just put together the initial
> trace format expected by blkparse + the ones I'm collecting at
> tracepoint time.


So you would like two different trace files? Or print both bin and formatted
output together in the same file?
I'm not sure I understand :-s


> > >From your traced site, trace_vbprintk will carry your random typed
> > datas in a binary-contiguous way.
> > But actually, its purpose is more about holding binary data transport
> > to finally print them in a formatted string
> > output, as usual.
> > 
> > You can compare it with ftrace_printk, since the result is the same.
> > The difference is in the transport.
> > ftrace_printk will carry your data as already formatted whereas
> > trace_vbprintk will carry them as binary values and format them
> > in the last moment. On most cases, trace_vbprintk would be logically
> > more lightweight.
> 
> Understood, but I already do this, and then leave it to the last minute
> to look at the blktrace types:
> 
> +static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
> +{
> +       struct trace_seq *s = &iter->seq;
> +       struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
> +       const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
> +       int ret;
> +
> +       switch (what) {
> +       case __BLK_TA_ISSUE:        ret = blk_log_generic(iter, t, "D"); break;
> +       case __BLK_TA_INSERT:       ret = blk_log_generic(iter, t, "I"); break;
> +       case __BLK_TA_QUEUE:        ret = blk_log_generic(iter, t, "Q"); break;
> +       case __BLK_TA_BOUNCE:       ret = blk_log_generic(iter, t, "B"); break;
> +       case __BLK_TA_BACKMERGE:    ret = blk_log_generic(iter, t, "M"); break;
> +       case __BLK_TA_FRONTMERGE:   ret = blk_log_generic(iter, t, "F"); break;
> +       case __BLK_TA_GETRQ:        ret = blk_log_generic(iter, t, "G"); break;
> +       case __BLK_TA_SLEEPRQ:      ret = blk_log_generic(iter, t, "S"); break;
> +       case __BLK_TA_REQUEUE:      ret = blk_log_with_err(iter, t, "R"); break;
> +       case __BLK_TA_COMPLETE:     ret = blk_log_with_err(iter, t, "C"); break;
> +       case __BLK_TA_PLUG:         ret = blk_log_plug(iter, t); break;
> +       case __BLK_TA_UNPLUG_IO:    ret = blk_log_unplug(iter, t, "U"); break;
> +       case __BLK_TA_UNPLUG_TIMER: ret = blk_log_unplug(iter, t, "UT"); break;
> +       case __BLK_TA_REMAP:        ret = blk_log_remap(iter, t); break;
> +       case __BLK_TA_SPLIT:        ret = blk_log_split(iter, t, "X"); break;
> 
> I did this trying to get as close to the existing blktrace record format
> as possible, to minimize the current patch.

Ok.

> I guess that the right thing to do is to create a new blktrace record
> format, that is:
> 
> 	struct blk_io_trace {
> 		struct trace_entry ent;
> 		<what is not in struct trace_entry already>
> 	}
> 
> And rebuild the userspace blkparse utility.
> 
> But I'm still trying to figure out how to best use the ever-improving
> ftrace infrastructure.
> 
> For instance, now I think that I need to register one event for each of
> the case __BLK_TA_ lines above, like kernel/trace/trace_branch.c already
> does.


Right, but I fear it would make the event types list in trace.h very large.
But, actually, it is expected to host as much tracer as needed... So...

Probably it can be done that way, or one other approach would be to implement
a way to have subtypes events for a tracer.
This way, one tracer can dynamically register as much private types as needed with their
events callbacks without wondering about making trace.h too fat....

Steven, what would you prefer?

> If I do that I can also provide a trace_event->bin that would use
> trace_seq_putmem.


Yes, I discovered it recently, so all is actually ready for binary
output :-)


> > But if you have some predefined typed data to export as binary, I
> > think that can't really help you.
> > You would prefer to define you own type and then export them as binary
> > values with your own output helper function.
> 
> Agreed
> 
> > Hmm?
> > 
> > Steven, Ingo, what are your thoughts about this patch?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

