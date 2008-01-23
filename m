Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYAWQyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYAWQyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYAWQyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:54:00 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:48839 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYAWQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:53:59 -0500
Date: Wed, 23 Jan 2008 11:53:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
Message-ID: <20080123165353.GA12598@goodmis.org>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123160444.197366580@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 11:02:55AM -0500, Steven Rostedt wrote:
> This patch adds latency tracing for critical timings
> (how long interrupts are disabled for).
> 
>  "irqsoff" is added to /debugfs/tracing/available_tracers
> 

> Index: linux-mcount.git/kernel/lockdep.c
> ===================================================================
> --- linux-mcount.git.orig/kernel/lockdep.c	2008-01-23 10:26:11.000000000 -0500
> +++ linux-mcount.git/kernel/lockdep.c	2008-01-23 10:27:53.000000000 -0500
> @@ -39,6 +39,7 @@
>  #include <linux/irqflags.h>
>  #include <linux/utsname.h>
>  #include <linux/hash.h>
> +#include <linux/mcount.h>
>  
>  #include <asm/sections.h>
>  
> @@ -2009,7 +2010,7 @@ void early_boot_irqs_on(void)
>  /*
>   * Hardirqs will be enabled:
>   */
> -void trace_hardirqs_on(void)
> +void notrace trace_hardirqs_on_caller(unsigned long a0)
>  {
>  	struct task_struct *curr = current;
>  	unsigned long ip;
> @@ -2050,14 +2051,24 @@ void trace_hardirqs_on(void)
>  	curr->hardirq_enable_ip = ip;
>  	curr->hardirq_enable_event = ++curr->irq_events;
>  	debug_atomic_inc(&hardirqs_on_events);
> +	time_hardirqs_on(CALLER_ADDR0, a0);
>  }
> +EXPORT_SYMBOL(trace_hardirqs_on_caller);
>  
> +void notrace trace_hardirqs_on(void) {
> +	trace_hardirqs_on_caller(CALLER_ADDR0);
> +}
>  EXPORT_SYMBOL(trace_hardirqs_on);
>  

vvvvvvvvvvvvvvvv

> +void notrace trace_hardirqs_off(void) {
> +	trace_hardirqs_off_caller(CALLER_ADDR0);
> +}
> +EXPORT_SYMBOL(trace_hardirqs_off);
> +

^^^^^^^^^^^^^^^^

>  /*
>   * Hardirqs were disabled:
>   */
> -void trace_hardirqs_off(void)
> +void notrace trace_hardirqs_off_caller(unsigned long a0)
>  {
>  	struct task_struct *curr = current;
>  
> @@ -2075,10 +2086,15 @@ void trace_hardirqs_off(void)
>  		curr->hardirq_disable_ip = _RET_IP_;
>  		curr->hardirq_disable_event = ++curr->irq_events;
>  		debug_atomic_inc(&hardirqs_off_events);
> +		time_hardirqs_off(CALLER_ADDR0, a0);
>  	} else
>  		debug_atomic_inc(&redundant_hardirqs_off);
>  }
>  


> +void notrace trace_hardirqs_off(void) {
> +	trace_hardirqs_off_caller(CALLER_ADDR0);
> +}
> +
>  EXPORT_SYMBOL(trace_hardirqs_off);
> 


Bah, I didn't refresh quilt! I'll update the website with a -v5a with
this fix.

-- Steve

>  /*
