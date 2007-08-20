Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXHTOIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXHTOIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbXHTOIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:08:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:37677 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbXHTOIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:08:11 -0400
Message-ID: <46C9A057.6060303@qumranet.com>
Date: Mon, 20 Aug 2007 17:08:23 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Ingo Molnar <mingo@elte.hu>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [kvm-devel] [PATCH 4/4] Modify KVM to update guest time accounting.
References: <46C993A6.3060001@bull.net> <46C999C8.4080307@qumranet.com> <46C99C05.90701@bull.net>
In-Reply-To: <46C99C05.90701@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Avi Kivity wrote:
>   
>> Laurent Vivier wrote:
>>     
>>> [PATCH 4/4] Modify KVM to update guest time accounting.
>>>
>>>   
>>>       
>>> Index: kvm/drivers/kvm/kvm.h
>>> ===================================================================
>>> --- kvm.orig/drivers/kvm/kvm.h    2007-08-20 13:23:53.000000000 +0200
>>> +++ kvm/drivers/kvm/kvm.h    2007-08-20 13:23:58.000000000 +0200
>>> @@ -589,6 +589,17 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
>>>  
>>>  int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>>>  
>>> +static inline void kvm_guest_enter(void)
>>> +{
>>> +#ifdef CONFIG_GUEST_ACCOUNTING
>>> +    current->flags |= PF_VCPU;
>>> +#endif
>>>   
>>>       
>> Since you select GUEST_ACCOUNTING, the #ifdef is always true?
>>     
>
> It is just to avoid error if we compile kvm module outside of the kernel, with
> kernel without support of guest accounting. Can be removed if you want.
>
>   

Ah okay.  We take care of the external module in 
external-module-compat.h (in this case, we can #define PF_VCPU to 0 if 
it is undefined).

>>> +}
>>> +
>>> +static inline void kvm_guest_exit(void)
>>> +{
>>>   
>>>       
>> Missing content?
>>     
>
> No, empty function.
>
> It is just to introduce "symmetry" in code, the VCPU code begins with
> "kvm_guest_start()" and ends with "kvm_guest_exit()". And we have no operation
> to do in kvm_guest_exit() (the PF_VCPU is cleared by account_system_time()), so
> "empty function", removed by the optimizer (I hope).
>   

But what if account_system_time() is not called (because we exited 
before the timer interrupt hit)?


-- 
error compiling committee.c: too many arguments to function

