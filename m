Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZDHLLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZDHLLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDHLLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:11:38 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:18467 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZDHLLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aHESwaVT2s8rIgk42zDOf7e9aglSOSYISKrCrqBVX1ynIAH/XcQ1LxGVN0CSeK5RTP
         dMk7RUzONxjqqIG3hZZ04eh81zx2sR8n06oIRPJeGaSMtQ6RjO5dbQMh9MmSRGY8bTgr
         x7fTK5HBLHAffyAqaCqx5n6H1mYcuRjIDi3Gw=
Date: Wed, 8 Apr 2009 13:11:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/filters: use ring_buffer_discard_commit() in
	filter_check_discard()
Message-ID: <20090408111130.GA6005@nowhere>
References: <1239083415.7220.45.camel@tropicana> <20090407130854.GA17992@elte.hu> <1239178441.10295.34.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239178441.10295.34.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 03:14:01AM -0500, Tom Zanussi wrote:
> On Tue, 2009-04-07 at 15:08 +0200, Ingo Molnar wrote:
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > This patch changes filter_check_discard() to make use of the new 
> > > ring_buffer_discard_commit() function and modifies the current 
> > > users to call the old commit function in the non-discard case.  It 
> > > also introduces a version of filter_check_discard() that uses the 
> > > global trace buffer (filter_current_check_discard()) for those 
> > > cases.
> > 
> > Nice!
> > 
> > I've merged it into tip/tracing/filters but it cannot go into 
> > tip/master yet due to build failures. I fixed the obvious typo 
> > problem (find the fix below) but punted on this one for now:
> > 
> >  kernel/built-in.o: In function `filter_check_discard':
> >  trace.c:(.text+0x613fc): undefined reference to  `filter_match_preds'
> >  kernel/built-in.o: In function `trace_vprintk':
> >  (.text+0x6154f): undefined reference to `event_print'
> >  kernel/built-in.o: In function `trace_vbprintk':
> >  (.text+0x61717): undefined reference to `event_bprint'
> >  kernel/built-in.o: In function `__ftrace_trace_stack':
> > 
> > config attached.
> > 
> > 	Ingo
> > 
> > Index: linux/kernel/trace/trace_branch.c
> > ===================================================================
> > --- linux.orig/kernel/trace/trace_branch.c
> > +++ linux/kernel/trace/trace_branch.c
> > @@ -74,7 +74,7 @@ probe_likely_condition(struct ftrace_bra
> >  	entry->line = f->line;
> >  	entry->correct = val == expect;
> >  
> > -	if !(filter_check_discard(call, entry, event))
> > +	if (!(filter_check_discard(call, entry, tr->buffer, event)))
> >  		ring_buffer_unlock_commit(tr->buffer, event);
> >  
> >   out:
> > 
> 
> Wow, I can't believe I missed that - didn't have CONFIG_BRANCH_TRACE on
> I guess.
> 
> As for the other errors, it's the CONFIG_EVENT_TRACER not being turned
> on again.  I think the tracing config patch below would be a better
> solution than the one I previously posted...
> 
> It adds a new config option, CONFIG_EVENT_TRACING that gets selected
> when CONFIG_TRACING is selected and adds everything needed by the stuff
> in trace_export - basically all the event tracing support needed by e.g.
> bprint, minus the actual events, which are only included if
> CONFIG_EVENT_TRACER is selected.  So CONFIG_EVENT_TRACER can be used to
> turn on or off the generated events (what I think of as the 'event
> tracer'), while CONFIG_EVENT_TRACING turns on or off the base event
> tracing support used by both the event tracer and the other things such
> as bprint that can't be configured out. 
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  kernel/trace/Kconfig              |    4 ++++
>  kernel/trace/Makefile             |    6 +++---
>  3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 7fa660f..7e9b1e9 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -61,7 +61,7 @@
>  #define BRANCH_PROFILE()
>  #endif
>  
> -#ifdef CONFIG_EVENT_TRACER
> +#ifdef CONFIG_EVENT_TRACING
>  #define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
>  			*(_ftrace_events)				\
>  			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 23b96eb..644606e 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -48,6 +48,9 @@ config FTRACE_NMI_ENTER
>         depends on HAVE_FTRACE_NMI_ENTER
>         default y
>  
> +config EVENT_TRACING
> +	bool
> +
>  config TRACING
>  	bool
>  	select DEBUG_FS
> @@ -56,6 +59,7 @@ config TRACING
>  	select TRACEPOINTS
>  	select NOP_TRACER
>  	select BINARY_PRINTF
> +	select EVENT_TRACING
>  
>  #
>  # Minimum requirements an architecture has to meet for us to
> diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
> index 2630f51..3ad367e 100644
> --- a/kernel/trace/Makefile
> +++ b/kernel/trace/Makefile
> @@ -40,11 +40,11 @@ obj-$(CONFIG_POWER_TRACER) += trace_power.o
>  obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
>  obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
>  obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
> -obj-$(CONFIG_EVENT_TRACER) += trace_events.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_events.o
>  obj-$(CONFIG_EVENT_TRACER) += events.o
> -obj-$(CONFIG_EVENT_TRACER) += trace_export.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_export.o
>  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
>  obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
> -obj-$(CONFIG_EVENT_TRACER) += trace_events_filter.o
> +obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
>  
>  libftrace-y := ftrace.o
> -- 
> 1.5.6.3
> 
> 
> 


Yeah, looks good this way!

