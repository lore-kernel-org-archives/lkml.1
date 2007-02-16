Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbXBPBv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbXBPBv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932904AbXBPBv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:51:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57955 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901AbXBPBv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:51:26 -0500
Date: Thu, 15 Feb 2007 17:45:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH] Linux Kernel Markers Documentation
Message-Id: <20070215174500.2b1b3bb9.randy.dunlap@oracle.com>
In-Reply-To: <20070216013348.GC12736@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca>
	<20070214231201.20918c6b.akpm@linux-foundation.org>
	<20070216013348.GC12736@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 20:33:48 -0500 Mathieu Desnoyers wrote:

> Linux Kernel Markers - Documentation
> 
> Here is some documentation explaining what is/how to use the Linux
> Kernel Markers.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> --- /dev/null
> +++ b/Documentation/marker.txt
> @@ -0,0 +1,130 @@
> + 	             Using the Linux Kernel Markers
> +
> +			    Mathieu Desnoyers
> +
> +
> +	This document discusses the purpose of markers. It shows some usage
> +examples of the Linux Kernel Markers : how to insert markers within the kernel
> +and how to connect probes to a marker. Finally, it has some probe module
> +examples. This is what connects to a marker.
> +
> +
> +* Purpose of markers
> +
> +You can put markers at important locations in the code. They act as
> +lightweight hooks that can pass an arbitrary number of parameters,
> +described in a printk-like format string, to a function whenever the marker
> +code is reached.
> +
> +They can be used for tracing (LTTng, LKET over SystemTAP), overall performance
> +accounting (SystemTAP). They could also be used to implement
> +efficient hooks for SELinux or any other subsystem the would have this
                                                      that

> +kind of need.
> +
> +Using the markers for system audit (SELinux) would require to pass a
> +variable by address that would be later checked by the marked routine.
> +
> +
> +* Usage
> +
> +MARK(subsystem_event, "%d %s %p[struct task_struct]",
> +  someint, somestring, current);
> +Where :
> +- Subsystem is the name of your subsystem.
> +- event is the name of the event to mark.

so is the MARK() supposed to be:
  MARK(subsystem, event, ...

Please make the 2 doc. lines above match the parameters...
or the parameters match the text.

> +- "%d %s %p[struct task_struct]" is the formatted string for (printk-style).
> +- someint is an integer.
> +- somestring is a char pointer.
> +- current is a pointer to a struct task_struct.
> +
> +The expression %p[struct task_struct] is a suggested marker definition
> +standard that could eventually be used for pointer type checking in
> +sparse. The brackets contain the type to which the pointer refer.
                                                              refers.

> +
> +The marker mechanism supports multiple instances of the same marker.
> +Markers can be put in inline functions, inlined static functions and
> +unrolled loops.
> +
> +Note : It is safe to put markers within preempt-safe code : preempt_enable()
> +will not call the scheduler due to the tests in preempt_schedule().
> +
> +
> +* Optimization for a given architecture
> +
> +You will find, in asm-*/marker.h, optimisations for given architectures
> +(currently i386 and powerpc). They use a load immediate instead of a data read,
> +which saves a data cache hit, but also requires cross CPU code modification. In
> +order to support embedded systems which use read-only memory for their code, the
> +optimization can be disabled through menu options.
> +
> +
> +* Probe example
> +
> +------------------------------ CUT -------------------------------------
> +/* probe-example.c
> + *
> + * Loads a function at a marker call site.
> + *
> + * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/kernel.h>
> +
> +#define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"

Is SUBSYSTEM_EVENT_FORMAT used implicitly below?  or elsewhere?

> +void probe_subsystem_event(const char *format, ...)
> +{
> +	va_list ap;
> +	/* Declare args */
> +	unsigned int value;
> +	const char *mystr;
> +	struct task_struct *task;
> +
> +	/* Assign args */
> +	va_start(ap, format);
> +	value = va_arg(ap, typeof(value));
> +	mystr = va_arg(ap, typeof(mystr));
> +	task = va_arg(ap, typeof(task));
> +
> +	/* Call tracer */
> +	trace_subsystem_event(value, mystr, task);
> +
> +	/* Or call printk */
> +	vprintk(format, ap);
> +
> +	/* or count, check rights... */
> +	
> +	va_end(ap);
> +}
> +
> +static int __init probe_init(void)
> +{
> +	int result;
> +	result = marker_set_probe("subsystem_event",
> +			FS_CLOSE_FORMAT,
> +			probe_fs_close);

Do FS_CLOSE_FORMAT and probe_fs_close() need to be defined here?
I.e., is this a complete example?

> +	if (!result)
> +		goto cleanup;
> +	return 0;
> +
> +cleanup:
> +	marker_remove_probe(probe_subsystem_event);
> +	return -EPERM;
> +}
> +
> +static void __exit probe_fini(void)
> +{	
> +	marker_remove_probe(probe_subsystem_event);
> +}
> +
> +module_init(probe_init);
> +module_exit(probe_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mathieu Desnoyers");
> +MODULE_DESCRIPTION("SUBSYSTEM Probe");
> +------------------------------ CUT -------------------------------------



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
