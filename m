Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZECTFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZECTFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZECTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:05:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZECTF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:05:27 -0400
Date: Sun, 3 May 2009 22:04:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via
	eventfd-notification interface
Message-ID: <20090503190427.GB14483@redhat.com>
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090430130708.GA13763@redhat.com> <49FDCD7C.7070605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FDCD7C.7070605@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 07:59:40PM +0300, Avi Kivity wrote:
> Michael S. Tsirkin wrote:
>> On Mon, Apr 27, 2009 at 02:33:34PM -0400, Gregory Haskins wrote:
>>   
>>> This allows an eventfd to be registered as an irq source with a guest.  Any
>>> signaling operation on the eventfd (via userspace or kernel) will inject
>>> the registered GSI at the next available window.
>>>
>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>>     
>>
>> If we ever want to use this with e.g. MSI-X emulation in guest, and want
>> to be stricly compliant to MSI-X, we'll need a way for guest to mask
>> interrupts, and for host to report that a masked interrupt is pending.
>> Ideally, all this will be doable with a couple of mmapped pages to avoid
>> vmexits/system calls.
>>
>>   
>
> We could do this in two ways:
>
> - move msix entry emulation into the kernel

It's not too bad IMO: MSIX is just a table with a list
of vectors, you check the mask bit on each interrupt,
if masked mark vector pending and poll until unmasked.

> - require the device to support replacing its irqfd, and juggle it like so:
>   - guest disables msi
>       - replace device model fd with eventfd belonging to us
>       - when the device fires its eventfd, set the irq pending bit
>   - guest enables msi
>        - if the pending bit is set, fire the interrupt?
>        - replace device model fd with the real irqfd

Looks like a lot of code. No?

> I'm leaning towards the latter, though it's not an easy call.

Actually there's a third option: add KVM_MASK_IRQ, KVM_UNMASK_IRQ ioctls
which will block/unblock guest from getting interrupt on this irq,
whatever the source.  Interrupts are queued in kernel while masked. A
third ioctl KVM_PENDING_IRQS will return the status for a set if IRQs.
qemu would call these ioctls when guest edits the MSIX vector control or
reads the pending bit array.

>>> +static void
>>> +irqfd_inject(struct work_struct *work)
>>> +{
>>> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
>>> +	struct kvm *kvm = irqfd->kvm;
>>> +
>>> +	mutex_lock(&kvm->lock);
>>> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>>> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>>> +	mutex_unlock(&kvm->lock);
>>>     
>>
>> This will do weird stuff (deliver the irq twice) if the irq is
>> MSI/MSI-X. I know this was discussed already and is a temporary
>> shortcut, but maybe add a comment that we really want kvm_toggle_irq,
>> so that we won't forget?
>>   
>
> If so, that's a bug.  MSI should ignore kvm_set_irq(..., 0).

-- 
MST
