Return-Path: <linux-kernel-owner+w=401wt.eu-S1762728AbZENGp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762728AbZENGp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762737AbZENGpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:45:38 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:44488 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762775AbZENGph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:45:37 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/3] perf_counter: allow arch to supply event misc
 flags and instruction pointer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18955.36913.304477.712583@drongo.ozlabs.ibm.com>
References: <18955.36913.304477.712583@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 08:45:34 +0200
Message-Id: <1242283534.26820.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 13:29 +1000, Paul Mackerras wrote:
> At present the values we put in overflow events for the misc flags
> indicating processor mode and the instruction pointer are obtained
> using the standard user_mode() and instruction_pointer() functions.
> Those functions tell you where the performance monitor interrupt
> was taken, which might not be exactly where the counter overflow
> occurred, for example because interrupts were disabled at the point
> where the overflow occurred, or because the processor had many
> instructions in flight and chose to complete some more instructions
> beyond the one that caused the counter overflow.
> 
> Some architectures (e.g. powerpc) can supply more precise information
> about where the counter overflow occurred and the processor mode at
> that point.  This introduces new functions, perf_misc_flags() and
> perf_instruction_pointer(), which arch code can override to provide
> more precise information if available.  They have default implementations
> which are identical to the existing code.
> 
> This also adds a new misc flag value, PERF_EVENT_MISC_HYPERVISOR, for
> the case where a counter overflow occurred in the hypervisor.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
>  include/linux/perf_counter.h |    7 +++++++
>  kernel/perf_counter.c        |    5 ++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 614f921..2b12d98 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -213,6 +213,7 @@ struct perf_counter_mmap_page {
>  #define PERF_EVENT_MISC_KERNEL		(1 << 0)
>  #define PERF_EVENT_MISC_USER		(1 << 1)
>  #define PERF_EVENT_MISC_OVERFLOW	(1 << 2)
> +#define PERF_EVENT_MISC_HYPERVISOR	(1 << 3)

Ah, I think I've taught userspace that either !USER && !KERNEL or USER
&& KERNEL is HV information, since neither really makes sense :-)

>  struct perf_event_header {
>  	__u32	type;
> @@ -588,6 +589,12 @@ extern int sysctl_perf_counter_mlock;
>  
>  extern void perf_counter_init(void);
>  
> +#ifndef perf_misc_flags
> +#define perf_misc_flags(regs)	(user_mode(regs) ? PERF_EVENT_MISC_USER : \
> +				 PERF_EVENT_MISC_KERNEL)
> +#define perf_instruction_pointer(regs)	instruction_pointer(regs)
> +#endif
> +
>  #else
>  static inline void
>  perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index ff166c1..89568de 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -1978,11 +1978,10 @@ static void perf_counter_output(struct perf_counter *counter,
>  	header.size = sizeof(header);
>  
>  	header.misc = PERF_EVENT_MISC_OVERFLOW;
> -	header.misc |= user_mode(regs) ?
> -		PERF_EVENT_MISC_USER : PERF_EVENT_MISC_KERNEL;
> +	header.misc |= perf_misc_flags(regs);
>  
>  	if (record_type & PERF_RECORD_IP) {
> -		ip = instruction_pointer(regs);
> +		ip = perf_instruction_pointer(regs);
>  		header.type |= PERF_RECORD_IP;
>  		header.size += sizeof(ip);
>  	}

