Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXKMUVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXKMUVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760934AbXKMUVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:21:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:56309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761116AbXKMUVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:21:00 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86, ptrace: support for branch trace store(BTS)
Date: Tue, 13 Nov 2007 21:20:53 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, markus.t.metzger@intel.com,
       akpm@linux-foundation.org
References: <20071113195954.GA2428@linux-os.sc.intel.com>
In-Reply-To: <20071113195954.GA2428@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711132120.53458.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 20:59:54 Siddha, Suresh B wrote:
> Support for Intel's last branch recording to ptrace. This gives debuggers
> access to this hardware feature and allows them to show an execution trace
> of the debugged application.

Cool. Finally someone gets around to supporting this properly.

Ok mostly properly, the patch needs some improvements.

But can you please add a mode for tracing kernel code too? I guess
this means a way to forbid it to user space or allocate the register.
That would be probably needed by kernel debuggers too anyways, so
might be better to add it from the begging.

I'm sure some people will suggest now that should be all only
supported with utrace. My suggestion is to ignore them.

Also there was some discussion recently that complex kernel
interfaces like this need manpages on proposal so that proper review
of the interfaces is possible. I would suggest to write manpages
(or manpages patches) and point to them on the next submission.

> Index: linux-2.6/arch/x86/kernel/process_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/process_32.c	2007-11-07 09:08:32.%N +0100
> +++ linux-2.6/arch/x86/kernel/process_32.c	2007-11-07 09:09:36.%N +0100
> @@ -735,6 +735,18 @@
>  		__switch_to_xtra(prev_p, next_p, tss);
>  
>  	/*
> +	 * Last branch recording recofiguration of trace hardware and
> +	 * disentangling of trace data per task.
> +	 */
> +	if (unlikely(task_thread_info(prev_p)->flags & _TIF_BTS_TRACE ||
> +		     task_thread_info(prev_p)->flags & _TIF_BTS_TRACE_TS))
> +		ptrace_bts_task_departs(prev_p);
> +
> +	if (unlikely(task_thread_info(next_p)->flags & _TIF_BTS_TRACE ||
> +		     task_thread_info(next_p)->flags & _TIF_BTS_TRACE_TS))
> +		ptrace_bts_task_arrives(next_p);
> +

Congratulations. You managed to pick exactly the wrong place.  
Why do you think __switch_to_xtra was invented?  The bits should be in 
CTXSW_PREV/NEXT and then the checks moved there. Then it would be zero
cost for the nobody using it case.


> +#ifdef __i386__
> +static int ptrace_bts_disable_netburst(void)
> +{
> +	unsigned long long debugctl_msr = 0;
> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
> +	debugctl_msr &=
> +		~((1 << 2) | /* TR */
> +		  (1 << 3));  /* BTS */
> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);
> +
> +	return 0;
> +}
> +
> +static int ptrace_bts_disable_pentium_m(void)
> +{
> +	unsigned long long debugctl_msr = 0;
> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl_msr);

etc. Surely it would be faster to cache the value of the MSR in RAM?
Might matter for the context switch.

> +	if (size_in_records > 4000)
> +		return -EINVAL;

Nasty undocumented undefined magic numbers.


> +
> +	if (!ptrace_bts_ops.allocate_bts)
> +		return -EOPNOTSUPP;
> +	return (*ptrace_bts_ops.allocate_bts)(child, size_in_records);
> +}
> +
> +#ifdef __i386__

etc. The code duplication for i386 is indeed quite ugly. Would
be good to find some better way to do this. A lot of it seems
to be just different sizeof(), surely that could be passed around too
or gotten from the ops structure? 

Also it's unclear why you got different MSR access functions for 32bit 
and 64bit.

> +static int ptrace_bts_init_intel(void)

This should be probably in the standard CPU initialization code,
possibly using synthesized feature bits too.

Also do you have user space to use this?

-Andi
