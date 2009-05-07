Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbZEGNqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbZEGNqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZEGNqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:46:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46235 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZEGNqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:46:42 -0400
Date: Thu, 7 May 2009 10:46:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Gregory Haskins <ghaskins@novell.com>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090507134607.GA25311@amt.cnet>
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A02AE65.3000800@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 12:48:21PM +0300, Avi Kivity wrote:
> Davide Libenzi wrote:
>> On Wed, 6 May 2009, Gregory Haskins wrote:
>>
>>   
>>> I think we are ok in this regard (at least in v5) without the 
>>> callback. kvm holds irqfd, which holds eventfd.  In a normal 
>>> situation, we will
>>> have eventfd with 2 references.  If userspace closes the eventfd, it
>>> will drop 1 of the 2 eventfd file references, but the object should
>>> remain intact as long as kvm still holds it as well.  When the kvm-fd is
>>> released, we will then decouple from the eventfd->wqh and drop the last
>>> fput(), officially freeing it.
>>>
>>> Likewise, if kvm is closed before the eventfd, we will simply decouple
>>> from the wqh and fput(eventfd), leaving the last reference held by
>>> userspace until it closes as well.
>>>
>>> Let me know if you see any holes in that.
>>>     
>>
>> Looks OK, modulo my knowledge of KVM internals.
>>   
>
> What's your take on adding irq context safe callbacks to irqfd?
>
> To give some background here, we would like to use eventfd as a generic  
> connector between components, so the components do not know about each  
> other.  So far eventfd successfully abstracts among components in the  
> same process, in different processes, and in the kernel.
>
> eventfd_signal() can be safely called from irq context, and will wake up  
> a waiting task.  But in some cases, if the consumer is in the kernel, it  
> may be able to consume the event from irq context, saving a context 
> switch.
>
> So, will you consider patches adding this capability to eventfd?

(pasting from a separate thread)

> That's my thinking.  PCI interrupts don't work because we need to do  
> some hacky stuff in there, but MSI should.  Oh, and we could improve
> UIO  
> support for interrupts when using MSI, since there's no need to  
> acknowledge the interrupt.

Ok, so for INTx assigned devices all you need to do on the ACK handler
is to re-enable the host interrupt (and set the guest interrupt line to
low).

Right now the ack comes through a kvm internal irq ack callback.

AFAICS there is no mechanism in irqfd for ACK notification, and
interrupt injection is edge triggered.

So for PCI INTx assigned devices (or any INTx level), you'd want to keep
the guest interrupt high, with some way to notify the ACK.

Avi mentioned a separate irqfd to notify the ACK. For assigned devices,
you could register a fd wakeup function in that fd, which replaces the
current irq ACK callback?

