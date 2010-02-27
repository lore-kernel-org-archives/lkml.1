Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312Ab0B0Lwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:52:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48093 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966055Ab0B0Lwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ASJv3Qd6dU98Q3InPbktVblvtwweWYAO+R2fl59jq/ofWV6t/f1eFJZ3CIrATOZFyV
         92mUbJQYPwI4mJN+Ov3qRAvzdTa73pIg5thrXDH5k4OhGmxrZzZTSJb5PeEGJl39qcyd
         KZPUys9HLShKSfBYWvChPMuS4Ol/rBmEYHbDE=
Date: Sat, 27 Feb 2010 12:52:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/2 v2] tracing: Add EXTRACT_TRACE_SYMBOL() macro
Message-ID: <20100227115234.GG5130@nowhere>
References: <20100226053831.050130780@goodmis.org> <20100226054125.278472284@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226054125.278472284@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:38:32AM -0500, Steven Rostedt wrote:
> The trace events that are created with the TRACE_EVENT family macros
> can be read by binary readers, such as perf and trace-cmd. In order
> to translate the binary data, the events also have a format file
> associated with them. This format file explains the offset, size and
> signedness of elements in the raw binary data of an event.
> 
> At the end of the format file, there is a description on how to print
> this data. A helper function is used to map numbers into strings
> called __print_symbolic(). A problem arises when these numbers are
> defined as enums in the kernel. The macros that export this data into
> the format file does not translate the enums into numbers. Thus we
> have in the irq.h file:
> 
>  #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
>  #define show_softirq_name(val)				\
> 	__print_symbolic(val,				\
> 			 softirq_name(HI),		\
> 			 softirq_name(TIMER),		\
> 			 softirq_name(NET_TX),		\
> 			 softirq_name(NET_RX),		\
> 			 softirq_name(BLOCK),		\
> 			 softirq_name(BLOCK_IOPOLL),	\
> 			 softirq_name(TASKLET),		\
> 			 softirq_name(SCHED),		\
> 			 softirq_name(HRTIMER),		\
> 			 softirq_name(RCU))
> 
> 
> 	TP_printk("vec=%d [action=%s]", __entry->vec,
> 		  show_softirq_name(__entry->vec))
> 
> 
> Which shows up in the event format file as:
> 
>   print fmt: "vec=%d [action=%s]", REC->vec, __print_symbolic(REC->vec, { HI_SOFTIRQ, "HI" }, { TIMER_SOFTIRQ, "TIMER" }, { NET_TX_SOFTIRQ, "NET_TX" }, { NET_RX_SOFTIRQ, "NET_RX" }, { BLOCK_SOFTIRQ, "BLOCK" }, { BLOCK_IOPOLL_SOFTIRQ, "BLOCK_IOPOLL" }, { TASKLET_SOFTIRQ, "TASKLET" }, { SCHED_SOFTIRQ, "SCHED" }, { HRTIMER_SOFTIRQ, "HRTIMER" }, { RCU_SOFTIRQ, "RCU" })
> 
> 
> The parser has no idea of how to translate "HI_SOFTIRQ" into a number.
> 
> This patch adds an EXTRACT_TRACE_SYMBOLS() macro that lets a trace header
> define symbols that it uses, and will be converted into numbers.
> These symbols will be shown in an "event_symbols" file in the event
> directory.
> 
> Enums that use this also need to be converted into the following format:
> 
>  #define ENUMS 				\
> 	C(ENUM1)			\
> 	C(ENUM2)			\
> 	C(ENUM3)
> 
>  #define C(name) name
>  enum { ENUMS };
>  #undef C
> 
> Then the trace header can do the following:
> 
>   #define C(name)  TRACE_SYMBOL_PARSE(#name, name, sizeof(name))
>   EXTRACT_TRACE_SYMBOLS(mysyms, ENUMS)
> 
> For example, for the softirq names we can now have:
> 
>  #define C(sirq) \
> 	TRACE_SYMBOL_PARSE(#sirq, sirq##_SOFTIRQ, sizeof(sirq##_SOFTIRQ))
> 
>  EXTRACT_TRACE_SYMBOLS(softirqs, SOFTIRQ_NAMES)
> 
> where the SOFTIRQ_NAMES are defined as:
> 
>  #define SOFTIRQ_NAMES			\
> 	C(HI),				\
> 	C(TIMER),			\
> 	C(NET_TX),			\
> 	[...]
> 	C(RCU)
>  #define C(name) name##_SOFTIRQ
>  enum { SOFTIRQ_NAMES, NR_SOFTIRQS };
>
> 
> This produces:
> 
>    [tracing/]$ cat events/event_symbols
>    # Symbol:Size:Value
>    # =================
>    HI_SOFTIRQ:4:0
>    TIMER_SOFTIRQ:4:1
>    NET_TX_SOFTIRQ:4:2
>    NET_RX_SOFTIRQ:4:3
>    BLOCK_SOFTIRQ:4:4
>    BLOCK_IOPOLL_SOFTIRQ:4:5
>    TASKLET_SOFTIRQ:4:6
>    SCHED_SOFTIRQ:4:7
>    HRTIMER_SOFTIRQ:4:8
>    RCU_SOFTIRQ:4:9


There is a risk of having a big mess in this file
if we have various types of enums inside. I mean,
it doesn't make the things easy for the tools as they will
have to iterate through the whole list and sort it out
using the suffixes (*_SOFTIRQ).

We could perhaps have this per event subsystem?

cat events/irq/event_symbols


>  	TRACE_PRINTKS()							\
> Index: linux-trace.git/include/linux/tracepoint.h
> ===================================================================
> --- linux-trace.git.orig/include/linux/tracepoint.h	2010-02-12 13:35:15.000000000 -0500
> +++ linux-trace.git/include/linux/tracepoint.h	2010-02-25 22:47:10.000000000 -0500
> @@ -292,4 +292,6 @@ static inline void tracepoint_synchroniz
>  		assign, print, reg, unreg)			\
>  	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
>  
> +#define EXTRACT_TRACE_SYMBOLS(name, symbols)



So this could also take the name of the subsystem.



> +
>  #endif /* ifdef TRACE_EVENT (see note above) */
> Index: linux-trace.git/include/trace/define_trace.h
> ===================================================================
> --- linux-trace.git.orig/include/trace/define_trace.h	2010-02-12 13:35:15.000000000 -0500
> +++ linux-trace.git/include/trace/define_trace.h	2010-02-25 23:53:52.000000000 -0500
> @@ -20,6 +20,7 @@
>  /* Prevent recursion */
>  #undef CREATE_TRACE_POINTS
>  
> +#include <trace/trace_syms.h>
>  #include <linux/stringify.h>
>  
>  #undef TRACE_EVENT
> @@ -43,6 +44,20 @@
>  #define DECLARE_TRACE(name, proto, args)	\
>  	DEFINE_TRACE(name)
>  
> +#undef EXTRACT_TRACE_SYMBOLS
> +#define EXTRACT_TRACE_SYMBOLS(name, symbols)	\
> +	struct trace_syms ___trace_sym_##name[]					\
> +	__attribute__((section("_trace_symbols"), aligned(4)))	= {	\
> +		symbols							\
> +	}
> +
> +#define TRACE_SYMBOL_PARSE(symbol, value, sym_size)			\
> +	{								\
> +		.name = symbol,						\
> +		.val = (u64)(value),					\
> +		.size = sym_size					\



...which could be appended there.

What do you think?

