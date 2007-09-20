Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXITI1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXITI1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXITI1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:27:17 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44913 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbXITI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:27:14 -0400
Message-ID: <46F22E60.2090403@linux.vnet.ibm.com>
Date: Thu, 20 Sep 2007 13:55:04 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from
 panic codepath
References: <46EA5CEB.7020104@linux.vnet.ibm.com> <a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com> <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> ------------[ cut here ]------------
>> Badness at arch/powerpc/kernel/smp.c:202
>>     
>
> comes when smp_call_function_map() has been called with irqs disabled,
> which is illegal. However, there is a special case, the panic() codepath,
> when we do not want to warn about this -- warning at that time is pointless
> anyway, and only serves to scroll away the *real* cause of the panic and
> distracts from the real bug.
>
> * So let's extract the WARN_ON() from smp_call_function_map() into all its
>   callers -- smp_call_function() and smp_call_function_single()
>
> * Also, introduce another caller of smp_call_function_map(), namely
>   __smp_call_function() (and make smp_call_function() a wrapper over this)
>   which does *not* warn about disabled irqs
>
> * Use this __smp_call_function() from the panic codepath's smp_send_stop()
>
> We also end having to move code of smp_send_stop() below the definition
> of __smp_call_function().
>
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
>
> ---
>
> Untested (not even compile-tested) patch.
> Could someone point me to ppc32/64 cross-compilers for i386?
>
>  arch/powerpc/kernel/smp.c |   27 ++++++++++++++++++---------
>  1 files changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 1ea4316..b24dcba 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -152,11 +152,6 @@ static void stop_this_cpu(void *dummy)
>  		;
>  }
>
> -void smp_send_stop(void)
> -{
> -	smp_call_function(stop_this_cpu, NULL, 1, 0);
> -}
> -
>  /*
>   * Structure and data for smp_call_function(). This is designed to minimise
>   * static memory requirements. It also looks cleaner.
> @@ -198,9 +193,6 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
>  	int cpu;
>  	u64 timeout;
>
> -	/* Can deadlock when called with interrupts disabled */
> -	WARN_ON(irqs_disabled());
> -
>  	if (unlikely(smp_ops == NULL))
>  		return ret;
>
> @@ -270,10 +262,19 @@ int smp_call_function_map(void (*func) (void *info), void *info, int nonatomic,
>  	return ret;
>  }
>
> +static int __smp_call_function(void (*func)(void *info), void *info,
> +			       int nonatomic, int wait)
> +{
> +	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
> +}
> +
>  int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
>  			int wait)
>  {
> -	return smp_call_function_map(func,info,nonatomic,wait,cpu_online_map);
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
> +	return __smp_call_function(func, info, nonatomic, wait);
>  }
>  EXPORT_SYMBOL(smp_call_function);
>
> @@ -283,6 +284,9 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
>  	cpumask_t map = CPU_MASK_NONE;
>  	int ret = 0;
>
> +	/* Can deadlock when called with interrupts disabled */
> +	WARN_ON(irqs_disabled());
> +
>  	if (!cpu_online(cpu))
>  		return -EINVAL;
>
> @@ -299,6 +303,11 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info, int
>  }
>  EXPORT_SYMBOL(smp_call_function_single);
>
> +void smp_send_stop(void)
> +{
> +	__smp_call_function(stop_this_cpu, NULL, 1, 0);
> +}
> +
>  void smp_call_function_interrupt(void)
>  {
>  	void (*func) (void *info);
>   
Hi,

This patch solves the badness oops we get on the powerpc.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

