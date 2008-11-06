Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYKFQKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYKFQKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYKFQK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:10:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48101 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYKFQK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:10:27 -0500
Message-ID: <491316D9.20206@redhat.com>
Date: Thu, 06 Nov 2008 17:10:01 +0100
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, nhorman@redhat.com, jmarchan@redhat.com
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in	native_machine_halt
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com> <20081020160058.GB22779@elte.hu> <48FDCCCB.2080103@redhat.com>
In-Reply-To: <48FDCCCB.2080103@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments?

Ivan

---
Ivan Vecera wrote:
> Ingo Molnar wrote:
>> the code in arch/x86/kernel/smp.c::stop_this_cpu() is very similar to 
>> this and could be shared. You could move the stop_this_cpu() function to 
>> arch/x86/kernel/process.c (out of smp.c), so that it can be used by 
>> reboot.c.
>>
> Yes, this make sense. Here is the patch.
> 
> Ivan
> 
> ---
>  arch/x86/kernel/process.c |   16 ++++++++++++++++
>  arch/x86/kernel/reboot.c  |    5 +++++
>  arch/x86/kernel/smp.c     |   13 -------------
>  include/asm-x86/system.h  |    2 ++
>  4 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index c622772..af6904e 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -8,6 +8,7 @@
>  #include <linux/pm.h>
>  #include <linux/clockchips.h>
>  #include <asm/system.h>
> +#include <asm/apic.h>
>  
>  unsigned long idle_halt;
>  EXPORT_SYMBOL(idle_halt);
> @@ -122,6 +123,21 @@ void default_idle(void)
>  EXPORT_SYMBOL(default_idle);
>  #endif
>  
> +void stop_this_cpu(void *dummy)
> +{
> +	local_irq_disable();
> +	/*
> +	 * Remove this CPU:
> +	 */
> +	cpu_clear(smp_processor_id(), cpu_online_map);
> +#ifdef CONFIG_X86_LOCAL_APIC
> +	disable_local_APIC();
> +#endif
> +	if (hlt_works(smp_processor_id()))
> +		for (;;) halt();
> +	for (;;);
> +}
> +
>  static void do_nothing(void *unused)
>  {
>  }
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index f4c93f1..3113d9e 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -465,6 +465,11 @@ static void native_machine_restart(char *__unused)
>  
>  static void native_machine_halt(void)
>  {
> +	/* stop other cpus and apics */
> +	machine_shutdown();
> +
> +	/* stop this cpu */
> +	stop_this_cpu(NULL);
>  }
>  
>  static void native_machine_power_off(void)
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 18f9b19..3f92b13 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -140,19 +140,6 @@ void native_send_call_func_ipi(cpumask_t mask)
>  		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
>  }
>  
> -static void stop_this_cpu(void *dummy)
> -{
> -	local_irq_disable();
> -	/*
> -	 * Remove this CPU:
> -	 */
> -	cpu_clear(smp_processor_id(), cpu_online_map);
> -	disable_local_APIC();
> -	if (hlt_works(smp_processor_id()))
> -		for (;;) halt();
> -	for (;;);
> -}
> -
>  /*
>   * this function calls the 'stop' function on all other CPUs in the system.
>   */
> diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
> index b20c894..17ac753 100644
> --- a/include/asm-x86/system.h
> +++ b/include/asm-x86/system.h
> @@ -314,6 +314,8 @@ extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
>  
>  void default_idle(void);
>  
> +void stop_this_cpu(void *dummy);
> +
>  /*
>   * Force strict CPU ordering.
>   * And yes, this is required on UP too when we're talking

