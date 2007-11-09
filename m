Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXKICR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXKICR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbXKICRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:17:17 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37049 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbXKICRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:17:17 -0500
Message-ID: <4733C340.8080208@us.ibm.com>
Date: Thu, 08 Nov 2007 20:17:36 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: dor.laor@qumranet.com
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com> <4733AC3A.20701@qumranet.com>
In-Reply-To: <4733AC3A.20701@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dor Laor wrote:
> Anthony Liguori wrote:
>> This is a PCI device that implements a transport for virtio.  It 
>> allows virtio
>> devices to be used by QEMU based VMMs like KVM or Xen.
>>
>> ....
>>   
> While it's a little premature, we can start thinking of irq path 
> improvements.
> The current patch acks a private isr and afterwards apic eoi will also 
> be hit since its
> a level trig irq. This means 2 vmexits per irq.
> We can start with regular pci irqs and move afterwards to msi.
> Some other ugly hack options [we're better use msi]:
>    - Read the eoi directly from apic and save the first private isr ack

I must admit, that I don't know a whole lot about interrupt delivery.  
If we can avoid the private ISR ack then that would certainly be a good 
thing to do!  I think that would involve adding another bit to the 
virtqueues to indicate whether or not there is work to be handled.  It's 
really just moving the ISR to shared memory so that there's no plenty 
for accessing it.

Regards,

Anthony Liguori

>    - Convert the specific irq line to edge triggered and dont share it
> What do you guys think?
>> +/* A small wrapper to also acknowledge the interrupt when it's handled.
>> + * I really need an EIO hook for the vring so I can ack the 
>> interrupt once we
>> + * know that we'll be handling the IRQ but before we invoke the 
>> callback since
>> + * the callback may notify the host which results in the host 
>> attempting to
>> + * raise an interrupt that we would then mask once we acknowledged the
>> + * interrupt. */
>> +static irqreturn_t vp_interrupt(int irq, void *opaque)
>> +{
>> +    struct virtio_pci_device *vp_dev = opaque;
>> +    struct virtio_pci_vq_info *info;
>> +    irqreturn_t ret = IRQ_NONE;
>> +    u8 isr;
>> +
>> +    /* reading the ISR has the effect of also clearing it so it's very
>> +     * important to save off the value. */
>> +    isr = ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
>> +
>> +    /* It's definitely not us if the ISR was not high */
>> +    if (!isr)
>> +        return IRQ_NONE;
>> +
>> +    spin_lock(&vp_dev->lock);
>> +    list_for_each_entry(info, &vp_dev->virtqueues, node) {
>> +        if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
>> +            ret = IRQ_HANDLED;
>> +    }
>> +    spin_unlock(&vp_dev->lock);
>> +
>> +    return ret;
>> +}
>>   
>

