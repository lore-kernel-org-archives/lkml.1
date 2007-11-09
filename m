Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbXKIBGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbXKIBGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbXKIBGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:06:02 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:63160 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXKIBGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=S3ORUiThEsBQqotae7jO01lTTMITmj4Ygsi6LpH5gnp7UcmgoM9Rzd/zS+8Bn1PJzH6IJhV9oU6hPbBZWPxHzVigdmoGLD1fWOWKMwNVL4yNUccnc6wQIOiIizMlXhWFDfvCiMvFo3pyMZvUEZJzAdcTzIBP2JpJ3aVUti0rXk0=
Message-ID: <4733AC3A.20701@qumranet.com>
Date: Fri, 09 Nov 2007 02:39:22 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11944900163817-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> This is a PCI device that implements a transport for virtio.  It allows virtio
> devices to be used by QEMU based VMMs like KVM or Xen.
>
> ....
>   
While it's a little premature, we can start thinking of irq path 
improvements.
The current patch acks a private isr and afterwards apic eoi will also 
be hit since its
a level trig irq. This means 2 vmexits per irq.
We can start with regular pci irqs and move afterwards to msi.
Some other ugly hack options [we're better use msi]:
    - Read the eoi directly from apic and save the first private isr ack
    - Convert the specific irq line to edge triggered and dont share it
What do you guys think?
> +/* A small wrapper to also acknowledge the interrupt when it's handled.
> + * I really need an EIO hook for the vring so I can ack the interrupt once we
> + * know that we'll be handling the IRQ but before we invoke the callback since
> + * the callback may notify the host which results in the host attempting to
> + * raise an interrupt that we would then mask once we acknowledged the
> + * interrupt. */
> +static irqreturn_t vp_interrupt(int irq, void *opaque)
> +{
> +	struct virtio_pci_device *vp_dev = opaque;
> +	struct virtio_pci_vq_info *info;
> +	irqreturn_t ret = IRQ_NONE;
> +	u8 isr;
> +
> +	/* reading the ISR has the effect of also clearing it so it's very
> +	 * important to save off the value. */
> +	isr = ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
> +
> +	/* It's definitely not us if the ISR was not high */
> +	if (!isr)
> +		return IRQ_NONE;
> +
> +	spin_lock(&vp_dev->lock);
> +	list_for_each_entry(info, &vp_dev->virtqueues, node) {
> +		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
> +			ret = IRQ_HANDLED;
> +	}
> +	spin_unlock(&vp_dev->lock);
> +
> +	return ret;
> +}
>   

