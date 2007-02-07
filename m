Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXBGJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXBGJfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161086AbXBGJfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:35:05 -0500
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:23841 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030609AbXBGJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:35:04 -0500
Message-ID: <45C99D41.1010302@qumranet.com>
Date: Wed, 07 Feb 2007 11:34:57 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] KVM, hotplug: export register_cpu_notifier
References: <20070207081633.GA6723@elte.hu> <45C997F1.9060102@qumranet.com> <20070207091913.GA15384@elte.hu>
In-Reply-To: <20070207091913.GA15384@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2007 09:35:01.0601 (UTC) FILETIME=[3D874510:01C74A9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>> -#ifdef CONFIG_HOTPLUG_CPU
>>> -
>>> EXPORT_SYMBOL(register_cpu_notifier);
>>>
>>> +#ifdef CONFIG_HOTPLUG_CPU
>>> +
>>> void unregister_cpu_notifier(struct notifier_block *nb)
>>> {
>>> 	mutex_lock(&cpu_add_remove_lock);
>>>  
>>>       
>> This is broken: register_cpu_notifier() is __cpuinit, which means it 
>> disappears at module time if !CONFIG_CPU_HOTPLUG.
>>
>> I submitted a hackaround to Andrew some time ago with the suspend 
>> patchset.
>>     
>
> ok. What does your patch do - turns it into an inline? I fixed it up in 
> -rt via the patch below.
>
>   

yes, but only if MODULE.

> 	Ingo
>
> ---------------------->
> Subject: [patch] KVM: export register_cpu_notifier
> From: Ingo Molnar <mingo@elte.hu>
>
> KVM-trunk uses register_cpu_notifier() but it's not exported
> on CONFIG_HOTPLUG_CPU. Make it a nop inline.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/cpu.h |    6 +++++-
>  kernel/cpu.c        |    4 ----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> Index: linux/include/linux/cpu.h
> ===================================================================
> --- linux.orig/include/linux/cpu.h
> +++ linux/include/linux/cpu.h
> @@ -49,10 +49,14 @@ struct notifier_block;
>  
>  #ifdef CONFIG_SMP
>  /* Need to know about CPUs going up/down? */
> -extern int register_cpu_notifier(struct notifier_block *nb);
>  #ifdef CONFIG_HOTPLUG_CPU
> +extern int register_cpu_notifier(struct notifier_block *nb);
>  extern void unregister_cpu_notifier(struct notifier_block *nb);
>  #else
> +static inline int register_cpu_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
>  static inline void unregister_cpu_notifier(struct notifier_block *nb)
>  {
>  }
> Index: linux/kernel/cpu.c
> ===================================================================
> --- linux.orig/kernel/cpu.c
> +++ linux/kernel/cpu.c
> @@ -63,8 +63,6 @@ void unlock_cpu_hotplug(void)
>  }
>  EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
>  
> -#endif	/* CONFIG_HOTPLUG_CPU */
> -
>  /* Need to know about CPUs going up/down? */
>  int __cpuinit register_cpu_notifier(struct notifier_block *nb)
>  {
> @@ -75,8 +73,6 @@ int __cpuinit register_cpu_notifier(stru
>  	return ret;
>  }
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -
>  EXPORT_SYMBOL(register_cpu_notifier);
>  
>  void unregister_cpu_notifier(struct notifier_block *nb)
>   


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

