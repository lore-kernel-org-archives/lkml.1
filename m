Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbXGDDhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbXGDDhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 23:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXGDDhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 23:37:41 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:59273 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbXGDDhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 23:37:40 -0400
Date: Tue, 3 Jul 2007 23:37:38 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, dwilder@us.ibm.com,
       hunt@redhat.com
Subject: Re: [RFC PATCH 1/3] Generic Trace Setup and Control (GTSC) Documentation
Message-ID: <20070704033738.GC24341@Krystal>
References: <1183173868.24291.143.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1183173868.24291.143.camel@ubuntu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:22:28 up 2 days, 22:05,  4 users,  load average: 0.22, 0.20, 0.16
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Zanussi (zanussi@us.ibm.com) wrote:
> This is the documentation for the Generic Trace Setup and Control
> patchset, first submitted a couple of weeks ago.  See
> 
> http://marc.info/?l=linux-kernel&m=118214274912586&w=2
> 
> for a more detailed description.
> 
> I've updated this patch to incorporate the suggestions made by Alexey
> Dobriyan in that thread.
> 

It would be nice, since it claims to be "generic", to support things
brought forward by other tracers like LTTng, such as : multiple channels
(for low, medium and high event rate data, with user-selectable sizes),
hybrid trace mode (combined normal trace channels and flight recorder
channels).

Please see comments below,

> Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  gtsc.txt |  247 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 247 insertions(+)
> 
> diff --git a/Documentation/gtsc.txt b/Documentation/gtsc.txt
> new file mode 100644
> index 0000000..470d1fc
> --- /dev/null
> +++ b/Documentation/gtsc.txt
> @@ -0,0 +1,247 @@
> +Generic Trace Setup and Control (GTSC)
> +==================================
> +In the kernel, GTSC provides a simple API for starting and managing
> +data channels to user space.  GTSC builds on the relay interface. For a
> +complete description of the relay interface, please see:
> +Documentation/filesystems/relay.txt.
> +
> +GTSC provides one layer in a complete tracing application.  The idea of
> +the GTSC is to provide a kernel API for the setup and control of tracing
> +channels.  User of GTSC must provide a data layer responsible for formatting
> +and writing data into the trace channels.  
> +
> +A layered approach to tracing
> +=============================
> +A complete kernel tracing application consists of a data provider and a data
> +consumer.  Both provider and consumer contain three layers; each layer works
> +in tandem with the corresponding layer in the opposite side.  The layers are
> +represented in the following diagram.
> +  
> +Provider Data layer
> +	Formats raw trace data and provides data-related service.
> +	For example, adding timestamps used by consumer to sort data.
> +
> +Provider Control layer
> +	Provided by GTSC. Creates trace channels and informs the data layer
> +	and consumer of the current state of the trace channels.
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
> +GTSC - Features
> +==============
> +The GTSC exploits services and features provided by relay.  These features are:
> +- The creation and destruction of relay channels.
> +- Buffer management.  Overwrite or non-overwrite modes can be selected
> +  as well as global or per-CPU buffering.
> +
> +Overwrite mode can be called "flight recorder mode".  Flight recorder
> +mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
> +creating trace channels.  In flight mode when a tracing buffer is
> +full, the oldest records in the buffer will be discarded to make room
> +as new records arrive.  In the default non-overwrite mode, new records
> +may be written only if the buffer has room.  In either case, to
> +prevent data loss, a user space reader must keep the buffers
> +drained. GTSC provides a means to detect the number of records that
> +have been dropped due to a buffer-full condition (non-overwrite mode
> +only).
> +
> +When per-CPU buffers are used, relay creates one debugfs file for each
> +running CPU.  The user-space consumer of the data is responsible for
> +reading the per-CPU buffers and collating the records presumably using
> +a time stamp or sequence number included in the trace records.  The
> +use of global buffers eliminates this extra work of sequencing
> +records; however the provider's data layer must hold a lock when
> +writing records.  The lock prevents writers running on different CPUs
> +from overwriting each other's data.  However, buffering may be slower
> +because write to the buffer are serialized. Global buffering is
> +selected by setting the TRACE_GLOBAL_CHANNEL flag when creating trace
> +channels.
> +
> +GTSC User Interface
> +===================
> +When a GTSC channel is created and tracing has been started, the following
> +directories and files are created in the root of the mounted debugfs.
> +
> +/debug (root of the debugfs)
> +        /<trace-root-dir>
> +                /<trace-name>
> +                        trace0 ... traceN  (Per-CPU trace data, one per CPU)
> +	        	state		   (Used to  start and stop tracing)
> +                        dropped            (number of records dropped due
> +                                            to a full-buffer condition, only)
> +                                            for non-TRACE_FLIGHT_CHANNELs)
> +                        rewind             ('un-consume' channel data i.e.
> +                                            start next read at the beginning
> +                                            again (TRACE_FLIGHT_CHANNELS only)
> +	        	nr_sub		   (Number of sub-buffers in channel)
> +	        	sub_size	   (Size of sub-buffers in channnel)
> +
> +Trace data is gathered from the trace[0...N] files using one of the available 
> +interfaces provided by relay (see Documentation/filesystems/relay.txt).
> +When using the READ(2) interface, as data is read it is marked as consumed by
> +the relay subsystem.  Therefore, subsequent reads will only return unconsumed
> +data.
> +
> +GTSC Kernel API
> +===============
> +An overview of the GTSC Kernel API is now given. More details of the API can
> +be found in linux/gtsc.h.
> +
> +The steps a kernel data provider takes to utilize the GTSC are:
> +1) Set up a gtsc channel - trace_setup()
> +2) Start the GTSC channel - trace_start()
> +3) Write one or more trace records into the channel (using the relay API).
> +4) Optionally stop and start tracing as desired - trace_start()/trace_stop()
> +5) Destroy the GTSC channel and underlying relay channel - trace_cleanup().
> +
> +GTSC Example
> +===========
> +This small sample module creates a GTSC channel. It places a kprobe on the
> +function do_fork().  The kprobe handler will write a timestamp and
> +current->pid to the GTSC channel.  
> +
> +You can build the kernel module kprobes_gtsc.ko using the following Makefile:
> +------------------------------------CUT-------------------------------------
> +obj-m := kprobes_gtsc.o
> +KDIR := /lib/modules/$(shell uname -r)/build
> +PWD := $(shell pwd)
> +default:
> +	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
> +clean:
> +	rm -f *.mod.c *.ko *.o
> +----------------------------------CUT--------------------------------------
> +/* kprobes_gtsc.c - An example of using GTSC in a kprobes module */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/kprobes.h>
> +#include <linux/gtsc.h>
> +
> +#define PROBE_POINT "do_fork"
> +
> +static struct kprobe kp;
> +struct trace_info *kprobes_trace;
> +
> +#define GTSC_PRINTF_TMPBUF_SIZE (1024)
> +static char gtsc_printf_tmpbuf[NR_CPUS][GTSC_PRINTF_TMPBUF_SIZE];
> +

Still doing an extra copy hey? :)

> +/* This lock is needed only when using global relay buffers */
> +static DEFINE_SPINLOCK(gtsc_printf_lock);
> +
> +void gtsc_printf(struct trace_info *trace, const char *format, ...)
> +{
> +	va_list args;
> +	void *buf;
> +	int len;
> +	char *record;
> +
> +	if (!trace)
> +		return;
> +	if (!trace_running(trace))
> +		return;
> +
> +	/* get a timestamp */
> +	buf = gtsc_printf_tmpbuf[smp_processor_id()];
> +	len = sprintf(buf,"[%lld] ", trace_timestamp());
> +
> +	/* get the data */
> +	va_start(args, format);
> +	len += vsnprintf(buf+len, GTSC_PRINTF_TMPBUF_SIZE, format, args);
> +	va_end(args);
> +
> +	/*
> +	 * Locking can be eliminated by specifying per-cpu buffers
> +	 * when calling trace_setup().
> +	 */
> +	spin_lock(&gtsc_printf_lock);
> +

I really hope nobody is willing to call gtsc_printf from an interrupt
handler.. :) Easy dead embrace in perspective.

> +	/* Send everything to the relay buffer */
> +	if ((record = relay_reserve(trace->rchan, len)))
> +		memcpy(record, buf, len);
> +
> +	spin_unlock(&gtsc_printf_lock);
> +}
> +
> +
> +int handler_pre(struct kprobe *p, struct pt_regs *regs)
> +{
> +	gtsc_printf(kprobes_trace,"%d\n", current->pid);
> +	return 0;
> +}
> +
> +int init_module(void)
> +{
> +	int ret;
> +	/* setup gtsc, use a global relay buffer */
> +	kprobes_trace = trace_setup("gtsc_example",PROBE_POINT,
> +				1024,8,
> +				TRACE_GLOBAL_CHANNEL | TRACE_FLIGHT_CHANNEL);
> +	if (!kprobes_trace)
> +		return -1;
> +
> +	trace_start(kprobes_trace);
> +
> +	/* setup the kprobe */
> +	kp.pre_handler = handler_pre;
> +	kp.post_handler = NULL;
> +	kp.fault_handler = NULL;
> +	kp.symbol_name = PROBE_POINT;
> +	if ((ret=register_kprobe(&kp)) < 0) 
> +		gtsc_printf(kprobes_trace,"register_kprobe failed  %d\n", ret);
> +	return 0;
> +}
> +
> +void cleanup_module(void)
> +{
> +	unregister_kprobe(&kp);
> +	/* close down the gtsc channel */
> +	trace_stop(kprobes_trace);
> +	trace_cleanup(kprobes_trace);
> +}
> +
> +MODULE_LICENSE("GPL");
> +-----------------------------CUT--------------------------------------------
> +How to run the example:
> +$ mount -t debugfs /debug 
> +$ make
> +$ insmod kprobes_gtsc.ko
> +
> +To view the data produced by the module:
> +$ cat /debug/gtsc_example/do_fork/trace0
> +
> +Remove the module.
> +$ rmmod kprobes_gtsc
> +
> +The function trace_cleanup() is called when the module
> +is removed.  This will cause the GTSC channel to be destroyed and the
> +corresponding files to disappear from the debug file system.
> +
> +Credits
> +=======
> +GTSC adapted from blktrace authored by Jens Axboe (axboe@suse.de).
> +
> +Major contributions to GTSC were made by:
> +Tom Zanussi <zanussi@us.ibm.com>
> +Martin Hunt <hunt@redhat.com>
> +David Wilder <dwilder@us.ibm.com>
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
