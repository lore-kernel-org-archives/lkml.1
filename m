Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbXJBRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbXJBRPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXJBRPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:15:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45765 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbXJBRPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:15:10 -0400
Date: Tue, 2 Oct 2007 10:10:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org,
       systemtap@sources.redhat.com
Subject: Re: [patch 3/3]  Trace sample
Message-Id: <20071002101032.55403fef.randy.dunlap@oracle.com>
In-Reply-To: <1191342805.31351.11.camel@lc4eb748232119.ibm.com>
References: <1191342805.31351.11.camel@lc4eb748232119.ibm.com>
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

On Tue, 02 Oct 2007 09:33:25 -0700 David J. Wilder wrote:

> Trace example - Adds the trace example to samples/
> 
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  samples/Kconfig            |    6 ++
>  samples/Makefile           |    1 +
>  samples/trace/Makefile     |    4 +
>  samples/trace/fork_trace.c |  132 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 143 insertions(+), 0 deletions(-)
> 
> diff --git a/samples/Kconfig b/samples/Kconfig
> index 57bb223..e11c806 100644
> --- a/samples/Kconfig
> +++ b/samples/Kconfig
> @@ -13,4 +13,10 @@ config SAMPLE_MARKERS
>  	help
>  	  This build markers example modules.
>  
> +config SAMPLE_TRACE
> +	tristate "Build trace example -- loadable modules only"
> +	depends on TRACE && m

The sample code uses kprobes, so this should also be:

	depends on KPROBES

Is (are?) kprobes always needed for trace?  If so, the documentation
probably should mention that also (along with relay & debugfs).


> +	help
> +	  This builds a trace example module.
> +
>  endif # SAMPLES
> diff --git a/samples/Makefile b/samples/Makefile
> index 5a4f0b6..8f6d05b 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -1,3 +1,4 @@
>  # Makefile for Linux samples code
>  
>  obj-$(CONFIG_SAMPLES)	+= markers/
> +obj-$(CONFIG_SAMPLES)	+= trace/
> diff --git a/samples/trace/Makefile b/samples/trace/Makefile
> new file mode 100644
> index 0000000..a2da8af
> --- /dev/null
> +++ b/samples/trace/Makefile
> @@ -0,0 +1,4 @@
> +# builds the trace example kernel modules;
> +# then to use (as root):  insmod <fork_trace.ko>
> +
> +obj-$(CONFIG_SAMPLE_TRACE) := fork_trace.o
> diff --git a/samples/trace/fork_trace.c b/samples/trace/fork_trace.c
> new file mode 100644
> index 0000000..71c04c7
> --- /dev/null
> +++ b/samples/trace/fork_trace.c
> @@ -0,0 +1,132 @@
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
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * -------
> + * This module creates a trace channel and places a kprobe
> + * on the function do_fork(). The value of current->pid is written to
> + * the trace channel each time the kprobe is hit..
> + *
> + * How to run the example:
> + * $ mount -t debugfs /debug
> + * $ insmod fork_trace.ko
> + *
> + * To view the data produced by the module:
> + * $ cat /debug/trace_example/do_fork/trace0
> + *
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
...
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

---
~Randy
