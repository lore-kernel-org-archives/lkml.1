Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbXH1Ulv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbXH1Ulv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXH1Ulm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:41:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:21627 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXH1Ull (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:41:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Kxc6YofWZWTteuzNe5azQWfjn1AdRd+GvYADzCnipPm/FaQvFaotWXFy63eP30mguN8y1lEgQZEqmhEV7Xkt5VsXf1uIVl0i0foMFQNSKIgBI1NWRllXz97XUmlVtGReoSJZ1JB0jaJKad6Cq4MMwnsT/EqUkT4ElB2L0pCzm9E=
Message-ID: <f158dc670708281341m4c0c6213u69c42e1ea19914e9@mail.gmail.com>
Date: Tue, 28 Aug 2007 14:41:38 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
Cc: kvm-devel@lists.sourceforge.net, v9fs-developer@lists.sourceforge.net,
       lguest@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <200708282208.52902.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11883271601857-git-send-email-ericvh@gmail.com>
	 <11883271601227-git-send-email-ericvh@gmail.com>
	 <11883271602233-git-send-email-ericvh@gmail.com>
	 <200708282208.52902.arnd@arndb.de>
X-Google-Sender-Auth: c585e9f6447f3a34
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 28 August 2007, Eric Van Hensbergen wrote:
>
> > This adds a shared memory transport for a synthetic 9p device for
> > paravirtualized file system support under KVM/QEMU.
>
> Nice driver. I'm hoping we can do a virtio driver using a similar
> concept.
>
> > +#define PCI_VENDOR_ID_9P     0x5002
> > +#define PCI_DEVICE_ID_9P     0x000D
>
> Where do these numbers come from? Can we be sure they don't conflict with
> actual hardware?

I stole the VENDOR_ID from kvm's hypercall driver. There are no any
guarantees that it doesn't conflict with actual hardware. As it was
discussed before, there is still no ID assigned for the virtual
devices.

> > +struct p9pci_trans {
> > +     struct pci_dev          *pdev;
> > +     void __iomem            *ioaddr;
> > +     void __iomem            *tx;
> > +     void __iomem            *rx;
> > +     int                     irq;
> > +     int                     pos;
> > +     int                     len;
> > +     wait_queue_head_t       wait;
> > +};
>
> I would expect the data structure to contain an embedded struct p9_trans,
> which is how most drivers work nowadays.
>
> > +static struct p9pci_trans *p9pci_trans; /* single channel for now */
>
> As a result, it should be easier to get rid of this global. My feeling is
> that it really should not be here.
>
> > +static irqreturn_t p9pci_interrupt(int irq, void *dev)
> > +{
> > +     p9pci_trans = dev;
>
> This can simply use a local variable.
>
> > +     p9pci_trans->len = le32_to_cpu(readl(p9pci_trans->rx));
>
> readl implies le32_to_cpu. Doing it twice on a PCI device is broken
> on big-endian hardware.
>
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "%p len %d\n", p9pci_trans->pdev,
> > +                                                     p9pci_trans->len);
> > +     iowrite32(0, p9pci_trans->ioaddr + 4);
>
> Also, you should not mix iowriteXX/ioreadXX and writeX/readX calls in one
> driver. Since you use pci_iomap, iowriteXX/ioreadXX are the correct functions.
>
> > +     wake_up_interruptible(&p9pci_trans->wait);
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +static int p9pci_read(struct p9_trans *trans, void *v, int len)
> > +{
> > +     struct p9pci_trans *ts;
> > +
> > +     if (!trans || trans->status == Disconnected || !trans->priv)
> > +             return -EREMOTEIO;
> > +
> > +     ts = trans->priv;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "trans %p rx %p tx %p buf %p len %d\n",
> > +                                             trans, ts->rx, ts->tx, v, len);
> > +     if (len > ts->len)
> > +             len = ts->len;
> > +
> > +     if (len) {
> > +             memcpy_fromio(v, ts->rx, len);
> > +             ts->len = 0;
> > +             /* let the host knows the message is consumed */
> > +             writel(0, ts->rx);
> > +             iowrite32(0, p9pci_trans->ioaddr + 4);
> > +             P9_DPRINTK(P9_DEBUG_TRANS, "zero rxlen %d txlen %d\n",
> > +                                             readl(ts->rx), readl(ts->tx));
> > +     }
> > +
> > +     return len;
> > +}
>
> I would expect memcpy_fromio and memcpy_toio to be relatively inefficient
> compared to virtual DMA, depending on the hypervisor. Do you have plans
> to change that, or did you have specific reasons to do the memcpy here?

No specific reasons. We wanted to start with simple and easy transport
and make things work before we start optimizing it. There are many
areas where the transport can be improved, using virtual DMA sounds
like a good suggestion.

>
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "trans %p rx %p tx %p buf %p len %d\n",
> > +                                             trans, ts->rx, ts->tx, v, len);
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "rxlen %d\n", readl(ts->rx));
> > +     if (readb(ts->tx) != 0)
> > +             return 0;
> > +
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "tx addr %p io addr %p\n", ts->tx,
> > +                                                             ts->ioaddr);
>
> All these P9_DPRINTK statements somewhat limit readability. I would suggest
> you kill them as soon as the driver is considered stable.
>
> > +static int __devinit p9pci_probe(struct pci_dev *pdev,
> > +             const struct pci_device_id *ent)
> > +{
> > +     int err;
> > +     u8 pci_rev;
> > +
> > +     if (p9pci_trans)
> > +             return -1;
>
> probe should return -EBUSY or similar, not -1.
>
> > +     pci_read_config_byte(pdev, PCI_REVISION_ID, &pci_rev);
> > +
> > +     if (pdev->vendor == PCI_VENDOR_ID_9P &&
> > +         pdev->device == PCI_DEVICE_ID_9P)
> > +             printk(KERN_INFO "pci dev %s (id %04x:%04x rev %02x) is a 9P\n",
> > +                    pci_name(pdev), pdev->vendor, pdev->device, pci_rev);
>
> You wouldn't be here for a different vendor/device code, so the check is
> bogus.
>
> > +     P9_DPRINTK(P9_DEBUG_TRANS, "%p\n", pdev);
> > +     p9pci_trans = kzalloc(sizeof(*p9pci_trans), GFP_KERNEL);
> > +     p9pci_trans->irq = -1;
>
> Use NO_IRQ to signify an invalid irq.
>
> > +     init_waitqueue_head(&p9pci_trans->wait);
> > +     err = pci_enable_device(pdev);
> > +     if (err)
> > +             goto error;
> > +
> > +     p9pci_trans->pdev = pdev;
> > +     err = pci_request_regions(pdev, "9p");
> > +     if (err)
> > +             goto error;
> > +
> > +     p9pci_trans->ioaddr = pci_iomap(pdev, 0, 8);
> > +     if (!p9pci_trans->ioaddr) {
> > +             P9_DPRINTK(P9_DEBUG_ERROR, "Cannot remap MMIO, aborting\n");
> > +             err = -EIO;
> > +             goto error;
> > +     }
> > +
> > +     p9pci_trans->tx = pci_iomap(pdev, 1, 0x20000);
> > +     p9pci_trans->rx = pci_iomap(pdev, 2, 0x20000);
>
> New code should use pcim_iomap, you don't need the unmapping code
> any more then.
>
> > +     pci_set_drvdata(pdev, p9pci_trans);
> > +     err = request_irq(pdev->irq, &p9pci_interrupt, 0, "p9pci", p9pci_trans);
> > +     if (err)
> > +             goto error;
> > +
> > +     p9pci_trans->irq = pdev->irq;
> > +     return 0;
> > +
> > +error:
> > +     P9_DPRINTK(P9_DEBUG_ERROR, "error %d\n", err);
> > +     if (p9pci_trans->irq >= 0) {
> > +             synchronize_irq(p9pci_trans->irq);
> > +             free_irq(p9pci_trans->irq, p9pci_trans);
> > +     }
> > +
> > +     if (p9pci_trans->pdev) {
> > +             pci_release_regions(pdev);
> > +             pci_iounmap(pdev, p9pci_trans->ioaddr);
> > +             pci_set_drvdata(pdev, NULL);
> > +             pci_disable_device(pdev);
> > +     }
> > +
> > +     kfree(p9pci_trans);
> > +     return -1;
> > +}
>
> return err;
>
> > +static void __exit p9pci_cleanup_module(void)
> > +{
> > +     pci_unregister_driver(&p9pci_driver);
> > +     printk(KERN_ERR "Removal of 9p transports not implemented\n");
> > +     BUG();
> > +}
>
> Not having a cleanup function at all is a much better way of preventing module
> unload.

Thanks for your comments.

    Lucho
