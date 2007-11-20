Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbXKTQLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbXKTQLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbXKTQLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:11:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:45825 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbXKTQLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:11:44 -0500
Message-ID: <4743076F.8000105@qumranet.com>
Date: Tue, 20 Nov 2007 18:12:31 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com> <474300AD.4060509@us.ibm.com>
In-Reply-To: <474300AD.4060509@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>   
>> Anthony Liguori wrote:
>>     
>>> This is a PCI device that implements a transport for virtio.  It 
>>> allows virtio
>>> devices to be used by QEMU based VMMs like KVM or Xen.
>>>
>>> +
>>> +/* the notify function used when creating a virt queue */
>>> +static void vp_notify(struct virtqueue *vq)
>>> +{
>>> +    struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>>> +    struct virtio_pci_vq_info *info = vq->priv;
>>> +
>>> +    /* we write the queue's selector into the notification register to
>>> +     * signal the other end */
>>> +    iowrite16(info->queue_index, vp_dev->ioaddr + 
>>> VIRTIO_PCI_QUEUE_NOTIFY);
>>> +}
>>>   
>>>       
>> This means we can't kick multiple queues with one exit.
>>     
>
> There is no interface in virtio currently to batch multiple queue 
> notifications so the only way one could do this AFAICT is to use a timer 
> to delay the notifications.  Were you thinking of something else?
>
>   

No.  We can change virtio though, so let's have a flexible ABI.

>> I'd also like to see a hypercall-capable version of this (but that can 
>> wait).
>>     
>
> That can be a different device.
>   

That means the user has to select which device to expose.  With feature 
bits, the hypervisor advertises both pio and hypercalls, the guest picks 
whatever it wants.

>   
>>> +
>>> +/* A small wrapper to also acknowledge the interrupt when it's handled.
>>> + * I really need an EIO hook for the vring so I can ack the 
>>> interrupt once we
>>> + * know that we'll be handling the IRQ but before we invoke the 
>>> callback since
>>> + * the callback may notify the host which results in the host 
>>> attempting to
>>> + * raise an interrupt that we would then mask once we acknowledged the
>>> + * interrupt. */
>>> +static irqreturn_t vp_interrupt(int irq, void *opaque)
>>> +{
>>> +    struct virtio_pci_device *vp_dev = opaque;
>>> +    struct virtio_pci_vq_info *info;
>>> +    irqreturn_t ret = IRQ_NONE;
>>> +    u8 isr;
>>> +
>>> +    /* reading the ISR has the effect of also clearing it so it's very
>>> +     * important to save off the value. */
>>> +    isr = ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
>>>   
>>>       
>> Can this be implemented via shared memory? We're exiting now on every 
>> interrupt.
>>     
>
> I don't think so.  A vmexit is required to lower the IRQ line.  It may 
> be possible to do something clever like set a shared memory value that's 
> checked on every vmexit.  I think it's very unlikely that it's worth it 
> though.
>   

Why so unlikely?  Not all workloads will have good batching.


>   
>>> +    return ret;
>>> +}
>>> +
>>> +/* the config->find_vq() implementation */
>>> +static struct virtqueue *vp_find_vq(struct virtio_device *vdev, 
>>> unsigned index,
>>> +                    bool (*callback)(struct virtqueue *vq))
>>> +{
>>> +    struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>>> +    struct virtio_pci_vq_info *info;
>>> +    struct virtqueue *vq;
>>> +    int err;
>>> +    u16 num;
>>> +
>>> +    /* Select the queue we're interested in */
>>> +    iowrite16(index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
>>>   
>>>       
>> I would really like to see this implemented as pci config space, with 
>> no tricks like multiplexing several virtqueues on one register. 
>> Something like the PCI BARs where you have all the register numbers 
>> allocated statically to queues.
>>     
>
> My first implementation did that.  I switched to using a selector 
> because it reduces the amount of PCI config space used and does not 
> limit the number of queues defined by the ABI as much.
>   

But... it's tricky, and it's nonstandard.  With pci config, you can do 
live migration by shipping the pci config space to the other side.  With 
the special iospace, you need to encode/decode it.

Not much of an argument, I know.


wrt. number of queues, 8 queues will consume 32 bytes of pci space if 
all you store is the ring pfn.


-- 
error compiling committee.c: too many arguments to function

