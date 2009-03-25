Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZCYNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZCYNGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZCYNGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:06:12 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:29805 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZCYNGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZkhkaSOtideloGVV0RJbQ5N/FYl06NutAEIwxfI0Me5znbi3jGFugp3wm+EgOYajUi
         QeYBlQ0+PYAPOo2FLZDbCBuuFUCB2xgUO9QFVAWodfwvIbX85sf/xnwar7MrUguaAmrS
         lSo2dAvL0fbPOB64SgMvh7vFx/fGwnTu4hi1c=
Date: Wed, 25 Mar 2009 14:06:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 7/9] LTTng instrumentation - kernel
Message-ID: <20090325130603.GD5976@nowhere>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.872305963@polymtl.ca> <20090324183313.GH31117@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324183313.GH31117@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 07:33:13PM +0100, Ingo Molnar wrote:
> 
> (Rusty Cc:-ed - for the module.c tracepoints below)
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Instrument the core kernel : module load/free and printk events. It helps the
> > tracer to keep track of module related events and to export valuable printk
> > information into the traces.
> > 
> > Those tracepoints are used by LTTng.
> > 
> > About the performance impact of tracepoints (which is comparable to markers),
> > even without immediate values optimizations, tests done by Hideo Aoki on ia64
> > show no regression. His test case was using hackbench on a kernel where
> > scheduler instrumentation (about 5 events in code scheduler code) was added.
> > See the "Tracepoints" patch header for performance result detail.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: 'Ingo Molnar' <mingo@elte.hu>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Masami Hiramatsu <mhiramat@redhat.com>
> > CC: 'Peter Zijlstra' <peterz@infradead.org>
> > CC: "Frank Ch. Eigler" <fche@redhat.com>
> > CC: 'Hideo AOKI' <haoki@redhat.com>
> > CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> > CC: 'Steven Rostedt' <rostedt@goodmis.org>
> > CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  include/trace/kernel.h |   19 +++++++++++++++++++
> >  kernel/module.c        |    8 ++++++++
> >  kernel/printk.c        |    7 +++++++
> >  3 files changed, 34 insertions(+)
> > 
> > Index: linux-2.6-lttng/kernel/printk.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/printk.c	2009-03-24 09:09:52.000000000 -0400
> > +++ linux-2.6-lttng/kernel/printk.c	2009-03-24 09:31:53.000000000 -0400
> > @@ -32,6 +32,7 @@
> >  #include <linux/security.h>
> >  #include <linux/bootmem.h>
> >  #include <linux/syscalls.h>
> > +#include <trace/kernel.h>
> >  
> >  #include <asm/uaccess.h>
> >  
> > @@ -59,6 +60,7 @@ int console_printk[4] = {
> >  	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
> >  	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
> >  };
> > +EXPORT_SYMBOL_GPL(console_printk);
> >  
> >  /*
> >   * Low level drivers may need that to know if they can schedule in
> > @@ -128,6 +130,9 @@ EXPORT_SYMBOL(console_set_on_cmdline);
> >  /* Flag: console code may call schedule() */
> >  static int console_may_schedule;
> >  
> > +DEFINE_TRACE(kernel_printk);
> > +DEFINE_TRACE(kernel_vprintk);
> > +
> >  #ifdef CONFIG_PRINTK
> >  
> >  static char __log_buf[__LOG_BUF_LEN];
> > @@ -560,6 +565,7 @@ asmlinkage int printk(const char *fmt, .
> >  	int r;
> >  
> >  	va_start(args, fmt);
> > +	trace_kernel_printk(_RET_IP_);
> >  	r = vprintk(fmt, args);
> >  	va_end(args);
> >
> > @@ -667,6 +673,7 @@ asmlinkage int vprintk(const char *fmt, 
> >  	printed_len += vscnprintf(printk_buf + printed_len,
> >  				  sizeof(printk_buf) - printed_len, fmt, args);
> >  
> > +	trace_kernel_vprintk(_RET_IP_, printk_buf, printed_len);
> 
> So here we pass in the formatted output. What sense does it make to 
> have the above printk tracepoint? Little i think.
> 
> Also, i'm not entirely convinced about the wiseness of instrumenting 
> an essential debug facility like printk(). Lets keep this one at the 
> tail portion of the patch-queue, ok?


Especially the trace_kernel_printk hook which only probes the printk callers.
I don't think a performance measurement of a printk call in that relevant.

Concerning trace_kernel_vprintk(), if the goal is to capture the printk messages,
I would rather see it through the dynamic printk facility or setting a console which
route printk output to trace_printk(). If that is useful for someone.

Thanks,
Frederic.

 
> > Index: linux-2.6-lttng/kernel/module.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/module.c	2009-03-24 09:09:59.000000000 -0400
> > +++ linux-2.6-lttng/kernel/module.c	2009-03-24 09:31:53.000000000 -0400
> > @@ -51,6 +51,7 @@
> >  #include <linux/tracepoint.h>
> >  #include <linux/ftrace.h>
> >  #include <linux/async.h>
> > +#include <trace/kernel.h>
> >  
> >  #if 0
> >  #define DEBUGP printk
> > @@ -78,6 +79,9 @@ static BLOCKING_NOTIFIER_HEAD(module_not
> >  /* Bounds of module allocation, for speeding __module_text_address */
> >  static unsigned long module_addr_min = -1UL, module_addr_max = 0;
> >  
> > +DEFINE_TRACE(kernel_module_load);
> > +DEFINE_TRACE(kernel_module_free);
> 
> I believe that to have a complete picture of module usage, module 
> refcount get/put events should be included as well, beyond the basic 
> load/free events.
> 
> These both have performance impact (a module get/put in a fastpath 
> hurts scalability), and are informative in terms of establishing the 
> module dependency graph.
> 
> Another thing that is iteresting and which is not covered here are 
> module request events and usermode helper callouts. These too have 
> instrumentation and performance analysis uses.
> 
> Plus, here too it would be desired to put in default probes as well, 
> via TRACE_EVENT().
> 
> Thanks,
> 
> 	Ingo

