Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZDHLM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZDHLM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDHLMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:12:46 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45268 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZDHLMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:12:45 -0400
Date: Wed, 8 Apr 2009 16:42:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090408111227.GA4851@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090407063058.301701787@prasadkr_t60p.in.ibm.com> <20090407063714.GL17461@in.ibm.com> <20090408080201.GA5996@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408080201.GA5996@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 10:02:03AM +0200, Frederic Weisbecker wrote:
> Hi Prasad,
> 
> 
> On Tue, Apr 07, 2009 at 12:07:14PM +0530, K.Prasad wrote:
> > This patch adds an ftrace plugin to detect and profile memory access over kernel
> > variables. It uses HW Breakpoint interfaces to 'watch memory addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > Acked-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/Kconfig          |   21 +
> >  kernel/trace/Makefile         |    1 
> >  kernel/trace/trace.h          |   25 +
> >  kernel/trace/trace_ksym.c     |  558 ++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_selftest.c |   36 ++
> >  5 files changed, 641 insertions(+)
> > 
> > Index: kernel/trace/Kconfig
> > ===================================================================
> > --- kernel/trace/Kconfig.orig
> > +++ kernel/trace/Kconfig
> > @@ -268,6 +268,27 @@ config POWER_TRACER
> >  	  power management decisions, specifically the C-state and P-state
> >  	  behavior.
> >  
> > +config KSYM_TRACER
> > +	bool "Trace read and write access on kernel memory locations"
> > +	depends on HAVE_HW_BREAKPOINT
> > +	select TRACING
> > +	help
> > +	  This tracer helps find read and write operations on any given kernel
> > +	  symbol i.e. /proc/kallsyms.
> > +
> > +config PROFILE_KSYM_TRACER
> > +	bool "Profile all kernel memory accesses on 'watched' variables"
> > +	depends on KSYM_TRACER
> > +	help
> > +	  This tracer profiles kernel accesses on variables watched through the
> > +	  ksym tracer ftrace plugin. Depending upon the hardware, all read
> > +	  and write operations on kernel variables can be monitored for
> > +	  accesses.
> > +
> > +	  The results will be displayed in:
> > +	  /debugfs/tracing/profile_ksym
> > +
> > +	  Say N if unsure.
> >  
> >  config STACK_TRACER
> >  	bool "Trace max stack"
> > Index: kernel/trace/Makefile
> > ===================================================================
> > --- kernel/trace/Makefile.orig
> > +++ kernel/trace/Makefile
> > @@ -46,5 +46,6 @@ obj-$(CONFIG_EVENT_TRACER) += trace_expo
> >  obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
> >  obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
> >  obj-$(CONFIG_EVENT_TRACER) += trace_events_filter.o
> > +obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
> >  
> >  libftrace-y := ftrace.o
> > Index: kernel/trace/trace.h
> > ===================================================================
> > --- kernel/trace/trace.h.orig
> > +++ kernel/trace/trace.h
> > @@ -12,6 +12,10 @@
> >  #include <trace/kmemtrace.h>
> >  #include <trace/power.h>
> >  
> > +#ifdef CONFIG_KSYM_TRACER
> > +#include <asm/hw_breakpoint.h>
> > +#endif
> > +
> >  enum trace_type {
> >  	__TRACE_FIRST_TYPE = 0,
> >  
> > @@ -37,6 +41,7 @@ enum trace_type {
> >  	TRACE_KMEM_FREE,
> >  	TRACE_POWER,
> >  	TRACE_BLK,
> > +	TRACE_KSYM,
> >  
> >  	__TRACE_LAST_TYPE,
> >  };
> > @@ -212,6 +217,23 @@ struct syscall_trace_exit {
> >  	unsigned long		ret;
> >  };
> >  
> > +#ifdef CONFIG_KSYM_TRACER
> > +struct trace_ksym {
> > +	struct trace_entry	ent;
> > +	struct hw_breakpoint	*ksym_hbp;
> > +	unsigned long		ksym_addr;
> > +	unsigned long		ip;
> > +#ifdef CONFIG_PROFILE_KSYM_TRACER
> > +	unsigned long 		counter;
> > +#endif
> > +	struct hlist_node	ksym_hlist;
> > +	char			ksym_name[KSYM_NAME_LEN];
> > +	char			p_name[TASK_COMM_LEN];
> > +};
> > +#else
> > +struct trace_ksym {
> > +};
> > +#endif /* CONFIG_KSYM_TRACER */
> >  /*
> 
> 
> Is this #ifdef CONFIG_KSYM_TRACER necessary?
> On the off-case it wouldn't hurt I guess, neither
> would it fill any irrelevant space.
> 
> 
> 

I agree. The other structures used various plugins are also defined
unconditionally. I will remove them when submitting the patch again for
inclusion.

> >   * trace_flag_type is an enumeration that holds different
> > @@ -330,6 +352,7 @@ extern void __ftrace_bad_type(void);
> >  			  TRACE_SYSCALL_ENTER);				\
> >  		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
> >  			  TRACE_SYSCALL_EXIT);				\
> > +		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
> >  		__ftrace_bad_type();					\
> >  	} while (0)
> >  
> > @@ -593,6 +616,8 @@ extern int trace_selftest_startup_syspro
> >  					       struct trace_array *tr);
> >  extern int trace_selftest_startup_branch(struct tracer *trace,
> >  					 struct trace_array *tr);
> > +extern int trace_selftest_startup_ksym(struct tracer *trace,
> > +					 struct trace_array *tr);
> >  #endif /* CONFIG_FTRACE_STARTUP_TEST */
> >  
> >  extern void *head_page(struct trace_array_cpu *data);
> > Index: kernel/trace/trace_ksym.c
> > ===================================================================
> > --- /dev/null
> > +++ kernel/trace/trace_ksym.c
> > @@ -0,0 +1,558 @@
> > +/*
> > + * trace_ksym.c - Kernel Symbol Tracer
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> > + *
> > + * Copyright (C) IBM Corporation, 2009
> > + */
> > +
> > +#include <linux/kallsyms.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/ftrace.h>
> > +#include <linux/module.h>
> > +#include <linux/jhash.h>
> > +#include <linux/fs.h>
> > +
> > +#include "trace_output.h"
> > +#include "trace_stat.h"
> > +#include "trace.h"
> > +
> > +/* For now, let us restrict the no. of symbols traced simultaneously to number
> > + * of available hardware breakpoint registers.
> > + */
> > +#define KSYM_TRACER_MAX HB_NUM
> > +
> > +#define KSYM_TRACER_OP_LEN 3 /* rw- */
> > +#define KSYM_FILTER_ENTRY_LEN (KSYM_NAME_LEN + KSYM_TRACER_OP_LEN + 1)
> > +
> > +#ifdef CONFIG_FTRACE_SELFTEST
> > +
> > +static int ksym_selftest_dummy;
> > +#define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
> > +
> > +#endif /* CONFIG_FTRACE_SELFTEST */
> > +
> > +static struct trace_array *ksym_trace_array;
> > +
> > +DEFINE_MUTEX(ksym_tracer_mutex);
> > +
> > +static unsigned int ksym_filter_entry_count;
> > +static unsigned int ksym_tracing_enabled;
> > +
> > +static HLIST_HEAD(ksym_filter_head);
> > +
> > +#ifdef CONFIG_PROFILE_KSYM_TRACER
> > +
> > +#define MAX_UL_INT 0xffffffff
> > +DEFINE_SPINLOCK(ksym_stat_lock);
> > +
> > +void ksym_collect_stats(unsigned long hbp_hit_addr)
> > +{
> > +	struct hlist_node *node;
> > +	struct trace_ksym *entry;
> > +
> > +	spin_lock(&ksym_stat_lock);
> 
> 
> 
> Does this spinlock protect your list iteration against concurrent removal
> or inserts? Other readers and writers of this list use ksym_tracer_mutex
> to synchronize, it looks like this site override this rule.
> 
> 
> 

While the ksym_stat_lock spinlock was meant to protect the counter
updation, you've unearthed the fact that the hlist whose head is
ksym_filter_head needs to be protected from simultaneous read/write
operations that can happen through ksym_trace_filter_write().

Since the same hlist is updated/read from both exception context and
otherwise (in the control plane of ftrace), ksym_stat_lock spinlock
will be used universally after replacing the ksym_tracer_mutex (this
could potentially be treated with RCU too, but choosing spinlock for
now). 

I will send out another version of this patch that includes this change,
and would accept your acknowledgement. Thanks for pointing out the
potential issue.

-- K.Prasad

