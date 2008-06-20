Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYFTRpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYFTRpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYFTRpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:45:33 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:44104 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbYFTRpc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:45:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag0FABOKW0hMQW1O/2dsb2JhbACBW64k
Date: Fri, 20 Jun 2008 13:45:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
Message-ID: <20080620174529.GB10943@Krystal>
References: <485BE2C6.1080901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <485BE2C6.1080901@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:32:36 up 15 days, 22:13,  4 users,  load average: 1.19, 0.61,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Add trace points of irq handle events ported from LTTng's markers.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> I just rewrote LTTng's irq event by using DEFINE_TRACE for example.
> 
>  include/linux/irq_trace.h |    6 ++++++
>  kernel/irq/handle.c       |    6 ++++++
>  2 files changed, 12 insertions(+)
> 
> Index: 2.6.26-rc5-mm3/include/linux/irq_trace.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ 2.6.26-rc5-mm3/include/linux/irq_trace.h	2008-06-16 12:27:51.000000000 -0400
> @@ -0,0 +1,6 @@
> +#include <linux/marker.h>
> +
> +DEFINE_TRACE(irq_entry, (int irq_id, int kernel_mode), irq_id, kernel_mode);
> +
> +DEFINE_TRACE(irq_exit, (void));
> +

All this work look good, thanks Masami! Sorry I did not find time to do
it lately, I've been busy on other things. A small question though :
since LTTng is configurable both as an external module or as an
in-kernel tracer, I wonder if it would really hurt to add the format
strings to DEFINE_TRACE, e.g. :

DEFINE_TRACE(name, prototype, format_string, args...)

which would give :

DEFINE_TRACE(irq_entry, (int irq_id, int kernel_mode), "%d %d",
    irq_id, kernel_mode);

DEFINE_TRACE(irq_exit, (void), MARK_NOARGS);

and calling this in the kernel code :

trace_irq_entry(irq, (regs)?(!user_mode(regs)):(1));
...
trace_irq_exit();

and for quick-and-dirty debug usage, one would add this to kernel code :

trace_mark(subsystem_event, "(int arg, struct task_struct *task)",
 "%d %p", arg, current);

By doing so, we could leave a gcc format string check by passing the
format string to __mark_check_format(). We could extract the field names
from the prototype, so there is no need to duplicate field information
in the format string.

Since the format string information is hidden in a header but kept at
the same location as the trace point definition, I think it reaches
goals of being "neat", efficient for general purpose tracers and to keep
the tracepoint information all in one place so we don't end up adding
stuff to various information consumers whenever a new trace point is
added.

What do you think of these changes ?

Mathieu


> Index: 2.6.26-rc5-mm3/kernel/irq/handle.c
> ===================================================================
> --- 2.6.26-rc5-mm3.orig/kernel/irq/handle.c	2008-06-16 12:27:50.000000000 -0400
> +++ 2.6.26-rc5-mm3/kernel/irq/handle.c	2008-06-16 12:27:51.000000000 -0400
> @@ -15,6 +15,7 @@
>  #include <linux/random.h>
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
> +#include <linux/irq_trace.h>
> 
>  #include "internals.h"
> 
> @@ -130,6 +131,9 @@ irqreturn_t handle_IRQ_event(unsigned in
>  {
>  	irqreturn_t ret, retval = IRQ_NONE;
>  	unsigned int status = 0;
> +	struct pt_regs *regs = get_irq_regs();
> +
> +	trace_irq_entry(irq, (regs)?(!user_mode(regs)):(1));
> 
>  	handle_dynamic_tick(action);
> 
> @@ -148,6 +152,8 @@ irqreturn_t handle_IRQ_event(unsigned in
>  		add_interrupt_randomness(irq);
>  	local_irq_disable();
> 
> +	trace_irq_exit();
> +
>  	return retval;
>  }
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
