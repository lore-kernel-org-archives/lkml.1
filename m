Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXENTMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXENTMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbXENTMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:12:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42695 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbXENTMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:12:16 -0400
Date: Mon, 14 May 2007 12:11:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       randy.dunlap@oracle.com, paulus@samba.org, benh@kernel.crashing.org,
       David Miller <davem@davemloft.net>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] Let smp_call_function_single return -EBUSY.
Message-Id: <20070514121137.ddcc3f5a.akpm@linux-foundation.org>
In-Reply-To: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com>
References: <20070514092317.GB8968@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 11:23:17 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> All architectures that have an implementation of smp_call_function_single
> let it return -EBUSY if it is asked to execute func on the current cpu.
> Therefore the UP version must always return -EBUSY.
> 

smp_call_function_single() is a mess.

- it's unclear to me why smp_call_function_single(cpu, ...) doesn't just
  call the darn function if cpu==smp_processor_id().

- it's unclear to me why smp_call_function_single(cpu, ...) doesn't just
  call the darn function if CONFIG_SMP=n.

- it's unclear to me why smp_call_function_single(cpu, ...) isn't called
  smp_call_function_on(cpu, ...)

- the x86_64 version doesn't return -EBUSY: it returns zero.  Despite its
  claim "Retrurns 0 on success, else a negative status code.".

- i386 _does_ return -EBUSY.

> This of course raises another question: it is not clear in which context
> the smp_call_function* functions are supposed to be called. Should it be
> with preemption disabled or is preemption enabled allowed as well?
> If calling with preemption enabled is allowed then the powerpc implementation
> is broken, since smp_processor_id() as well as num_online_cpus() may change
> while they are accessed.

These are all excellent questions.  And important ones.   I would suggest:

- May be called with preemption enabled.  The implementation must take
  care of that.

- May not be called under local_irq_disable() for the usual reasons.

- Will run the callback function under local_irq_disable() (this is
  unimportant at present, but if we decide to later change it to run the
  callback even on !SMP builds, we'll need to take care of that like we did
  in on_each_cpu())



>  include/linux/smp.h |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/include/linux/smp.h
> ===================================================================
> --- linux-2.6.orig/include/linux/smp.h
> +++ linux-2.6/include/linux/smp.h
> @@ -99,11 +99,9 @@ static inline void smp_send_reschedule(i
>  #define num_booting_cpus()			1
>  #define smp_prepare_boot_cpu()			do {} while (0)
>  static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
> -				void *info, int retry, int wait)
> +					   void *info, int retry, int wait)
>  {
> -	/* Disable interrupts here? */
> -	func(info);
> -	return 0;
> +	return -EBUSY;
>  }
>  
>  #endif /* !SMP */

Your patch seems appropriate given the present and proposed peculiar
semantics, but I think we need more work in there.  x86_64 needs its return
value fixing asap, surely.


