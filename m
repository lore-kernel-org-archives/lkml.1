Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbXIUWYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbXIUWYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXIUWYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:24:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34711 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbXIUWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:24:37 -0400
Date: Fri, 21 Sep 2007 15:23:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-Id: <20070921152344.ab68dd0c.randy.dunlap@oracle.com>
In-Reply-To: <1190411294.26210.12.camel@lc4eb748232119.ibm.com>
References: <1190411294.26210.12.camel@lc4eb748232119.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 14:48:14 -0700 David J. Wilder wrote:

> I updated the example code to eliminate the use of the temp print buffer
> and the use of NR_CPU.
> 
> Please see previous postings for more information and patch
> dependencies.
> http://lkml.org/lkml/2007/9/19/4 (PATCH 0/2)
> http://lkml.org/lkml/2007/9/19/6 (PATCH 2/2)
> 
> -----------<start of patch>--------------
> Trace - Provides tracing primitives
> 
> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: Martin Hunt <hunt@redhat.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  Documentation/trace/src/Makefile     |    7 +
>  Documentation/trace/src/README       |   18 +
>  Documentation/trace/src/fork_trace.c |  119 +++++++
>  Documentation/trace/trace.txt        |  164 ++++++++++
>  include/linux/trace.h                |   99 ++++++
>  lib/Kconfig                          |    9 +
>  lib/Makefile                         |    2 +
>  lib/trace.c                          |  563 +++++++++++++++++++++++++++
> +++++++

^^^ unexpected line break (similar break causes 'patch' problems later)

>  8 files changed, 981 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/trace/src/Makefile
> b/Documentation/trace/src/Makefile
> new file mode 100644
> index 0000000..9ee4c72
> --- /dev/null
> +++ b/Documentation/trace/src/Makefile
> @@ -0,0 +1,7 @@
> +obj-m := fork_trace.o
> +KDIR := /lib/modules/$(shell uname -r)/build
> +PWD := $(shell pwd)
> +default:
> +	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
> +clean:
> +	rm -f *.mod.c *.ko *.o
> diff --git a/Documentation/trace/src/README
> b/Documentation/trace/src/README
> new file mode 100644
> index 0000000..f538491
> --- /dev/null
> +++ b/Documentation/trace/src/README
> @@ -0,0 +1,18 @@
> +This small sample module creates a trace channel. It places a kprobe
> +on the function do_fork(). The value of current->pid is written to
> +the trace channel each time the kprobe is hit..
> +
> +How to run the example:
> +$ mount -t debugfs /debug
> +$ make
> +$ insmod fork_trace.ko
> +
> +To view the data produced by the module:
> +$ cat /debug/trace_example/do_fork/trace0
> +
> +Remove the module.
> +$ rmmod fork_trace
> +
> +The function trace_cleanup() is called when the module
> +is removed.  This will cause the TRACE channel to be destroyed and the
> +corresponding files to disappear from the debug file system.
> diff --git a/Documentation/trace/src/fork_trace.c
> b/Documentation/trace/src/fork_trace.c
> new file mode 100644
> index 0000000..aae3196
> --- /dev/null
> +++ b/Documentation/trace/src/fork_trace.c
> @@ -0,0 +1,119 @@
> +/*
> + * An example of using trace in a kprobes module 
> + *
> + * Copyright (C) 2007 IBM Inc.
> + *
> + * David Wilder <dwilder@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> 02110-1301  USA

^^^ here:  patch --dryrun says:

patch: **** malformed patch at line 92: 02110-1301  USA

You can also see this at
http://lkml.org/lkml/2007/9/21/431


> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/kprobes.h>
> +#include <linux/trace.h>
> +
> +#define USE_GLOBAL_BUFFERS 1
> +#define USE_FLIGHT 1
> +
> +#define PROBE_POINT "do_fork"
> +
> +static struct kprobe kp;
> +static struct trace_info *kprobes_trace;
> +
> +#ifdef USE_GLOBAL_BUFFERS
> +static DEFINE_SPINLOCK(trace_lock);
> +#endif
> +
> +/*
> + * Send formated trace data to trace channel.

           formatted

> + * @note Preemption must be disabled to use this.
> + */
> +static void trace_printf(struct trace_info *trace, const char
> *format, ...)
> +{
> +	va_list ap, aq;
> +	char *record;
> +	unsigned long flags;
> +	int len;
> +
> +	if (!trace)
> +		return;
> +
> +#ifdef USE_GLOBAL_BUFFERS
> +	spin_lock_irqsave(&trace_lock, flags);
> +#endif
> +	if (trace_running(trace)) {
> +		va_start(ap, format);
> +		va_copy(aq, ap);
> +		len = vsnprintf(NULL, 0, format, aq);
> +		va_end(aq);
> +		record = relay_reserve(trace->rchan, ++len);
> +		if (record)
> +			vsnprintf(record, len, format, ap);
> +		va_end(ap);
> +	}
> +#ifdef USE_GLOBAL_BUFFERS
> +	spin_unlock_irqrestore(&trace_lock, flags);
> +#endif
> +}
> +
> +static int handler_pre(struct kprobe *p, struct pt_regs *regs)
> +{
> +	rcu_read_lock();
> +	trace_printf(kprobes_trace, "%d\n", current->pid);
> +	rcu_read_unlock();
> +	return 0;
> +}
> +
> +int init_module(void)
> +{
> +	int ret;
> +	u32 flags = 0;
> +
> +#ifdef USE_GLOBAL_BUFFERS
> +	flags |= TRACE_GLOBAL_CHANNEL;
> +#endif
> +
> +#ifdef USE_FLIGHT
> +	flags |= TRACE_FLIGHT_CHANNEL;
> +#endif
> +
> +	/* setup the trace */
> +	kprobes_trace = trace_setup("trace_example", PROBE_POINT,
> +				     1024, 8, flags);
> +	if (IS_ERR(kprobes_trace))
> +		return PTR_ERR(kprobes_trace);
> +
> +	trace_start(kprobes_trace);
> +
> +	/* setup the kprobe */
> +	kp.pre_handler = handler_pre;
> +	kp.post_handler = NULL;
> +	kp.fault_handler = NULL;
> +	kp.symbol_name = PROBE_POINT;
> +	ret = register_kprobe(&kp);
> +	if (ret) {
> +		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +void cleanup_module(void)
> +{
> +	unregister_kprobe(&kp);
> +	trace_stop(kprobes_trace);
> +	trace_cleanup(kprobes_trace);
> +}
> +MODULE_LICENSE("GPL");
> diff --git a/Documentation/trace/trace.txt
> b/Documentation/trace/trace.txt
> new file mode 100644
> index 0000000..d88cb8f
> --- /dev/null
> +++ b/Documentation/trace/trace.txt
> @@ -0,0 +1,164 @@
> +Trace Setup and Control
> +=======================
> +In the kernel, the trace interface provides a simple mechanism for
> +starting and managing data channels (traces) to user space.  The
> +trace interface builds on the relay interface.  For a complete
> +description of the relay interface, please see:
> +Documentation/filesystems/relay.txt.
> +
> +The trace interface provides a single layer in a complete tracing
> +application.  Trace provides a kernel API that can be used for the
> setup

^^^ bad line split

> +and control of tracing channels.  User of trace must provide a data
> layer

^^^ ditto

> +responsible for formatting and writing data into the trace channels.
> +
> +A layered approach to tracing
> +=============================
> +A complete kernel tracing application consists of a data provider and
> +a data consumer.  Both provider and consumer contain three layers; each
> +layer works in tandem with the corresponding layer in the opposite
> side.

^^^ ditto

Is Evolution doing this?
There could be other places that I missed.


> +The layers are represented in the following diagram.
> +
> +Provider Data layer
> +	Formats raw trace data and provides data-related service.
> +	For example, adding timestamps used by consumer to sort data.
> +
> +Provider Control layer
> +	Provided by the trace interface, this layer creates trace channels
> +	and informs the data layer and consumer of the current state
> +	of the trace channels.
> +
> +Provider Buffering layer
> +	Provided by relay. This layer buffers data in the
> +	kernel for consumption by the consumer's buffer
> +	layer.
> +
> +Provider (in-kernel facility)
> +-----------------------------------------------------------------------------
> +Consumer (user application)
> +
> +
> +Consumer Buffer layer
> +	Reads/consumes data from the provider's data buffers.
> +
> +Consumer Control layer
> +	Communicates to the provider's control layer to control the state
> +	of the trace channels.
> +
> +Consumer Data layer
> +	Sorts and formats data as provided by the provider's data layer.
> +
> +The provider is coded as a kernel facility.  The consumer is coded as
> +a user application.
> +
> +
> +Trace - Features
> +================
> +Trace exploits services and features provided by relay.  These features
> +are:
> +- The creation and destruction of relay channels.
> +- Buffer management.  Overwrite or non-overwrite modes can be selected
> +  as well as global or per-CPU buffering.
> +
> +Overwrite mode can be called "flight recorder mode".  Flight recorder
> +mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
> +creating trace channels.  In flight mode when a tracing buffer is
> +full, the oldest records in the buffer will be discarded to make room
> +as new records arrive.	In the default non-overwrite mode, new records

s/<tab>/space/ above

> +may be written only if the buffer has room.  In either case, to
> +prevent data loss, a user space reader must keep the buffers
> +drained. Trace provides a means to detect the number of records that
> +have been dropped due to a buffer-full condition (non-overwrite mode
> +only).
> +
> +When per-CPU buffers are used, relay creates one debugfs file for each
> +running CPU.  The user-space consumer of the data is responsible for
> +reading the per-CPU buffers and collating the records presumably using
> +a time stamp or sequence number included in the trace records.	The

s/<tab>/space/ above

> +use of global buffers eliminates this extra work of sequencing
> +records; however the provider's data layer must hold a lock when
> +writing records.  The lock prevents writers running on different CPUs
> +from overwriting each other's data.  However, buffering may be slower
> +because writes to the buffer are serialized. Global buffering is
> +selected by setting the TRACE_GLOBAL_CHANNEL flag when creating trace
> +channels.
> +
> +Trace User Interface
> +===================
> +When a trace channel is created and started, the following
> +directories and files are created in the root of the mounted debugfs.
> +
> +/debug (root of the debugfs)
> +	/<trace-root-dir>
> +		/<trace-name>
> +			trace0 ... traceN  Per-CPU trace data, one
> +					   file per CPU.
> +

so above is for N+1 CPUs?

> +			state		   Start or stop tracing by
> +					   by writing the strings
> +					   "start" or "stop" to this
> +					   file. Read the file to get the
> +					   current state.
> +
> +			dropped		   The number of records dropped
> +					   due to a full-buffer condition,
> +					   for non-TRACE_FLIGHT_CHANNELs
> +					   only.
> +
> +			rewind		   Trigger a rewind by writing
> +					   to this file.  i.e. start
> +					   next read at the beginning
> +					   again. Only available for
> +					   TRACE_FLIGHT_CHANNELS.
> +
> +
> +			nr_sub		   Number of sub-buffers
> +					   in the channel.
> +
> +			sub_size	   Size of sub-buffers in
> +					   the channnel.
> +
> +Trace data is gathered from the trace[0...N] files using one of the
> +available interfaces provided by relay.
> +
> +When using the read(2) interface, as data is read it is marked as
> +consumed by the relay subsystem.  Therefore, subsequent reads will
> +only return unconsumed data.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
