Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbXGIGjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbXGIGjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXGIGjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:39:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:34867 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbXGIGjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:39:46 -0400
Message-ID: <4691D82F.3030401@qumranet.com>
Date: Mon, 09 Jul 2007 09:39:43 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com>	 <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com>	 <20070708134850.GB22911@elte.hu> <1183937563.6005.365.camel@localhost.localdomain>
In-Reply-To: <1183937563.6005.365.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 09 Jul 2007 09:39:43 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Sun, 2007-07-08 at 15:48 +0200, Ingo Molnar wrote:
>   
>> * Avi Kivity <avi@qumranet.com> wrote:
>>
>>     
>>>>> +#ifdef CONFIG_SCHED_KVM
>>>>> +static __read_mostly struct sched_kvm_hooks kvm_hooks;
>>>>> +#endif
>>>>>           
>>>> please just add a current->put_vcpu() function pointer instead of 
>>>> this hooks thing.
>>>>         
>>> Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
>>> The function pointers are common to all virtual machines.
>>>       
>> well, this function pointer could then be reused by other virtual 
>> machines as well, couldnt it? If the task struct overhead is a problem 
>> (it really isnt, and it's dependent on CONFIG_KVM) then we could switch 
>> it around to a notifier-alike mechanism.
>>     
>
> OK, this patch is *ugly*.  Not that there's anything wrong with a patch
> which says "I'm going to preempt you", but making it kvm-specific is
> ugly.  ISTR times past where I wanted such a hook, although none spring
> immediately into my pre-coffee brain.
>
> I think a "struct preempt_ops *" and a "void *preempt_ops_data" inside
> every task struct is a better idea.  Call the config option
> PREEMPT_SCHED_HOOKS and now there's nothing kvm-specific about it...
>   

I considered that, but your proposal does not allow a single task to
have multiple preemption hooks installed (hookers?!).  Since in general
there's no reason to suppose that users would be mutually exclusive, we
need to have a struct hlist of these things.  All in all this seemed to
indicate that the second user should have the honor of figuring out that
stuff.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

