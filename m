Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZECQ7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZECQ7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZECQ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:59:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59583 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZECQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:59:43 -0400
Message-ID: <49FDCD7C.7070605@redhat.com>
Date: Sun, 03 May 2009 19:59:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v3 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090427182540.6646.96740.stgit@dev.haskins.net> <20090427183334.6646.90800.stgit@dev.haskins.net> <20090430130708.GA13763@redhat.com>
In-Reply-To: <20090430130708.GA13763@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> On Mon, Apr 27, 2009 at 02:33:34PM -0400, Gregory Haskins wrote:
>   
>> This allows an eventfd to be registered as an irq source with a guest.  Any
>> signaling operation on the eventfd (via userspace or kernel) will inject
>> the registered GSI at the next available window.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>     
>
> If we ever want to use this with e.g. MSI-X emulation in guest, and want
> to be stricly compliant to MSI-X, we'll need a way for guest to mask
> interrupts, and for host to report that a masked interrupt is pending.
> Ideally, all this will be doable with a couple of mmapped pages to avoid
> vmexits/system calls.
>
>   

We could do this in two ways:

- move msix entry emulation into the kernel
- require the device to support replacing its irqfd, and juggle it like so:
   - guest disables msi
       - replace device model fd with eventfd belonging to us
       - when the device fires its eventfd, set the irq pending bit
   - guest enables msi
        - if the pending bit is set, fire the interrupt?
        - replace device model fd with the real irqfd

I'm leaning towards the latter, though it's not an easy call.

>> +static void
>> +irqfd_inject(struct work_struct *work)
>> +{
>> +	struct _irqfd *irqfd = container_of(work, struct _irqfd, work);
>> +	struct kvm *kvm = irqfd->kvm;
>> +
>> +	mutex_lock(&kvm->lock);
>> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> +	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> +	mutex_unlock(&kvm->lock);
>>     
>
> This will do weird stuff (deliver the irq twice) if the irq is
> MSI/MSI-X. I know this was discussed already and is a temporary
> shortcut, but maybe add a comment that we really want kvm_toggle_irq,
> so that we won't forget?
>   

If so, that's a bug.  MSI should ignore kvm_set_irq(..., 0).

-- 
error compiling committee.c: too many arguments to function

