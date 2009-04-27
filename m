Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZD0Ksh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZD0Ksh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZD0Ks0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:48:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43552 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZD0KsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:48:25 -0400
Message-ID: <49F58D75.7040304@redhat.com>
Date: Mon, 27 Apr 2009 13:48:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com>
In-Reply-To: <49F58A8C.7090808@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>> This allows an eventfd to be registered as an irq source with a
>>> guest.  Any
>>> signaling operation on the eventfd (via userspace or kernel) will inject
>>> the registered GSI at the next available window.
>>>
>>>  
>>> +struct kvm_irqfd {
>>> +    __u32 fd;
>>> +    __u32 gsi;
>>> +};
>>> +
>>>   
>>>       
>> I think it's better to have ioctl create and return the fd.  This way
>> we aren't tied to eventfd (though it makes a lot of sense to use it).
>>     
>
> I dont mind either way, but I am not sure it buys us much as the one
> driving the fd would need to understand if the interface is
> eventfd-esque or something else anyway.  Let me know if you still want
> to see this changed.
>   

Sure, the interface remains the same (write 8 bytes), but the 
implementation can change.  For example, we can implement it to work 
from interrupt context, once we hack the locking appropriately.


>>> +static void
>>> +irqfd_inject(struct work_struct *work)
>>> +{
>>> +    struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
>>> +    struct kvm *kvm = irqfd->kvm;
>>> +
>>> +    mutex_lock(&kvm->lock);
>>> +    kvm_set_irq(kvm, kvm->irqfd.src, irqfd->gsi, 1);
>>>   
>>>       
>> Need to lower the irq too (though irqfd only supports edge triggered
>> interrupts).
>>
>>     
> Should I just do back-to-back 1+0 inside the same lock?
>
>   

Yes.  Might be nice to add a kvm_toggle_irq(), but let's leave that 
until later.

  

>> One day we'll have lockless injection and we'll want to drop this.  I
>> guess if we create the fd ourselves we can make it work, but I don't
>> see how we can do this with eventfd.
>>
>>     
>
> Hmm...this is a good point.  There probably is no way to use eventfd
> "off the shelf" in a way that doesn't cause this callback to be in a
> critical section.  Should we just worry about switching away from
> eventfd when this occurs, or should I implement a custom anon-fd now?
>   

I'd just go with eventfd, and switch when it becomes relevant.  As long 
as the kernel allocates the fd, we're free to do as we like.

-- 
error compiling committee.c: too many arguments to function

