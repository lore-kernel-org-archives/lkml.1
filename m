Return-Path: <linux-kernel-owner+w=401wt.eu-S965333AbXIGKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333AbXIGKcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 06:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965106AbXIGKcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 06:32:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49080 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965091AbXIGKcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 06:32:11 -0400
Date: Fri, 7 Sep 2007 16:01:59 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: [patch 4/8] Immediate Values - Move Kprobes i386 restore_interrupt to kdebug.h
Message-ID: <20070907103159.GB10389@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070906200228.086651361@polymtl.ca> <20070906200314.986455310@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200314.986455310@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:02:32PM -0400, Mathieu Desnoyers wrote:
> Since the breakpoint handler is useful both to kprobes and immediate values, it
> makes sense to make the required restore_interrupt() available through
> asm-i386/kdebug.h.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> CC: Christoph Hellwig <hch@infradead.org>
> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  include/asm-i386/kdebug.h  |   12 ++++++++++++
>  include/asm-i386/kprobes.h |    9 ---------
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6-lttng/include/asm-i386/kdebug.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-i386/kdebug.h	2007-09-04 11:52:37.000000000 -0400
> +++ linux-2.6-lttng/include/asm-i386/kdebug.h	2007-09-04 12:12:06.000000000 -0400
> @@ -6,6 +6,9 @@
>   * from x86_64 architecture.
>   */
> 
> +#include <asm/ptrace.h>
> +#include <asm/system.h>
> +
>  struct pt_regs;
> 
>  /* Grossly misnamed. */
> @@ -25,4 +28,13 @@ enum die_val {
>  	DIE_PAGE_FAULT_NO_CONTEXT,
>  };
> 
> +/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
> + * if necessary, before executing the original int3/1 (trap) handler.
> + */
> +static inline void restore_interrupts(struct pt_regs *regs)
> +{
> +	if (regs->eflags & IF_MASK)
> +		local_irq_enable();
> +}
> +
>  #endif
> Index: linux-2.6-lttng/include/asm-i386/kprobes.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-i386/kprobes.h	2007-09-04 11:53:26.000000000 -0400
> +++ linux-2.6-lttng/include/asm-i386/kprobes.h	2007-09-04 12:12:06.000000000 -0400
> @@ -79,15 +79,6 @@ struct kprobe_ctlblk {
>  	struct prev_kprobe prev_kprobe;
>  };
> 
> -/* trap3/1 are intr gates for kprobes.  So, restore the status of IF,
> - * if necessary, before executing the original int3/1 (trap) handler.
> - */
> -static inline void restore_interrupts(struct pt_regs *regs)
> -{
> -	if (regs->eflags & IF_MASK)
> -		local_irq_enable();
> -}
> -
>  extern int kprobe_exceptions_notify(struct notifier_block *self,
>  				    unsigned long val, void *data);
>  extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
