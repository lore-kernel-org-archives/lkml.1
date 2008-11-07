Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYKGAgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYKGAgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 19:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYKGAf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 19:35:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49599 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYKGAfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 19:35:55 -0500
Message-ID: <49138CAD.3000304@cn.fujitsu.com>
Date: Fri, 07 Nov 2008 08:32:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address() and
 kernel_text_address()
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com> <4910FB3D.4020805@cn.fujitsu.com> <491212C0.4030900@redhat.com> <49124307.60909@cn.fujitsu.com> <49130F4C.6070603@redhat.com>
In-Reply-To: <49130F4C.6070603@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> __register_kprobe() can be preempted after checking probing address
> but before module_text_address() or try_module_get(), and in this
> interval the module can be unloaded. In that case,
> try_module_get(probed_mod) will access to invalid address,
> or kprobe will probe invalid address.
> 
> this patch uses preempt_disable() to protect it and use
> __module_text_address() and __kernel_text_address().

It's good, Thanks.

> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> 
>>> @@ -718,9 +725,11 @@ static void __kprobes __unregister_kprob
>>>  	struct kprobe *old_p;
>>>
>>>  	if (p->mod_refcounted) {
>>> -		mod = module_text_address((unsigned long)p->addr);
>>> +		preempt_disable();
>>> +		mod = __module_text_address((unsigned long)p->addr);
>>>  		if (mod)
>>>  			module_put(mod);
>>> +		preempt_enable();
>> this is bad fix, we have had a reference to mod. we don't need
>> preempt_disable() before module_put(mod).
> 
> Hmm, Indeed.
> So let's add a comment there.
> 
>  kernel/kprobes.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> Index: 2.6.28-rc3/kernel/kprobes.c
> ===================================================================
> --- 2.6.28-rc3.orig/kernel/kprobes.c
> +++ 2.6.28-rc3/kernel/kprobes.c
> @@ -613,30 +613,37 @@ static int __kprobes __register_kprobe(s
>  		return -EINVAL;
>  	p->addr = addr;
> 
> -	if (!kernel_text_address((unsigned long) p->addr) ||
> -	    in_kprobes_functions((unsigned long) p->addr))
> +	preempt_disable();
> +	if (!__kernel_text_address((unsigned long) p->addr) ||
> +	    in_kprobes_functions((unsigned long) p->addr)) {
> +		preempt_enable();
>  		return -EINVAL;
> +	}
> 
>  	p->mod_refcounted = 0;
> 
>  	/*
>  	 * Check if are we probing a module.
>  	 */
> -	probed_mod = module_text_address((unsigned long) p->addr);
> +	probed_mod = __module_text_address((unsigned long) p->addr);
>  	if (probed_mod) {
> -		struct module *calling_mod = module_text_address(called_from);
> +		struct module *calling_mod;
> +		calling_mod = __module_text_address(called_from);
>  		/*
>  		 * We must allow modules to probe themself and in this case
>  		 * avoid incrementing the module refcount, so as to allow
>  		 * unloading of self probing modules.
>  		 */
>  		if (calling_mod && calling_mod != probed_mod) {
> -			if (unlikely(!try_module_get(probed_mod)))
> +			if (unlikely(!try_module_get(probed_mod))) {
> +				preempt_enable();
>  				return -EINVAL;
> +			}
>  			p->mod_refcounted = 1;
>  		} else
>  			probed_mod = NULL;
>  	}
> +	preempt_enable();
> 
>  	p->nmissed = 0;
>  	INIT_LIST_HEAD(&p->list);
> @@ -718,6 +725,10 @@ static void __kprobes __unregister_kprob
>  	struct kprobe *old_p;
> 
>  	if (p->mod_refcounted) {
> +		/*
> +		 * Since we've already incremented refcount,
> +		 * we don't need to disable preemption.
> +		 */
>  		mod = module_text_address((unsigned long)p->addr);
>  		if (mod)
>  			module_put(mod);
> 


