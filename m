Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZEESLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZEESLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZEESL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:11:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZEESLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:11:25 -0400
Message-ID: <4A008127.7060406@redhat.com>
Date: Tue, 05 May 2009 21:10:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A005F05.30409@redhat.com> <4A007DDA.5000302@novell.com>
In-Reply-To: <4A007DDA.5000302@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Avi Kivity wrote:
>   
>> Gregory Haskins wrote:
>>
>>     
>>> +int
>>> +kvm_irqfd(struct kvm *kvm, int gsi, int flags)
>>> +{
>>> +    struct _irqfd *irqfd;
>>> +    struct file *file = NULL;
>>> +    int fd = -1;
>>> +    int ret;
>>> +
>>> +    irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
>>> +    if (!irqfd)
>>> +        return -ENOMEM;
>>> +
>>> +    irqfd->kvm = kvm;
>>>   
>>>       
>> You need to increase the refcount on struct kvm here.  Otherwise evil
>> userspace will create an irqfd, close the vm and vcpu fds, and inject
>> an interrupt.
>>     
>
> I just reviewed the code in prep for v5, and now I remember why I didnt
> take a reference:  I designed it the opposite direction:  the vm-fd owns
> a reference to the irqfd, and will decouple the kvm context from the
> eventfd on shutdown  (see kvm_irqfd_release()).   I still need to spin a
> v5 regardless in order to add the padding as previously discussed.  But
> let me know if you still see any holes in light of this alternate object
> lifetime approach I am using.
>   

Right, irqfd_release works.  But I think refcounting is simpler, since 
we already kvm_get_kvm() and kvm_put_kvm(), and you wouldn't need the 
irqfd list.  On the other hand, I'm not sure you get a callback from 
eventfd on close(), so refcounting may not be implementable.

Drat, irqfd_release doesn't work.  You reference kvm->lock in 
irqfd_inject without taking any locks.

btw, there's still your original idea of creating the eventfd in 
userspace and passing it down.  That would be workable if we can see a 
way to both signal the eventfd and get called back in irq context.  
Maybe that's preferable to what we're doing here, but we need to see how 
it would work.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

