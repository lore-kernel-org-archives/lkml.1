Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbXH1UJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbXH1UJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXH1UJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:09:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXH1UJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:09:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [RFC] 9p: add KVM/QEMU pci transport
Date: Tue, 28 Aug 2007 22:08:51 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070508.662491)
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, lguest@ozlabs.org
References: <11883271601857-git-send-email-ericvh@gmail.com> <11883271601227-git-send-email-ericvh@gmail.com> <11883271602233-git-send-email-ericvh@gmail.com>
In-Reply-To: <11883271602233-git-send-email-ericvh@gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708282208.52902.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ciMMY9AtwHURWd4IjhGqLGFM25MHihzRg9oj
 zkUspG2iJo66Ofjo4KCkE0RDn++2bKLI3qKwgRhoZfu8VE01V7
 uVu98QLCKAFzE9Bysu15g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007, Eric Van Hensbergen wrote:

> This adds a shared memory transport for a synthetic 9p device for
> paravirtualized file system support under KVM/QEMU.

Nice driver. I'm hoping we can do a virtio driver using a similar
concept.

> +#define PCI_VENDOR_ID_9P	0x5002
> +#define PCI_DEVICE_ID_9P	0x000D

Where do these numbers come from? Can we be sure they don't conflict with
actual hardware?

> +struct p9pci_trans {
> +	struct pci_dev		*pdev;
> +	void __iomem		*ioaddr;
> +	void __iomem		*tx;
> +	void __iomem		*rx;
> +	int			irq;
> +	int			pos;
> +	int			len;
> +	wait_queue_head_t	wait;
> +};

I would expect the data structure to contain an embedded struct p9_trans,
which is how most drivers work nowadays.

> +static struct p9pci_trans *p9pci_trans; /* single channel for now */

As a result, it should be easier to get rid of this global. My feeling is
that it really should not be here.

> +static irqreturn_t p9pci_interrupt(int irq, void *dev)
> +{
> +	p9pci_trans = dev;

This can simply use a local variable.

> +	p9pci_trans->len = le32_to_cpu(readl(p9pci_trans->rx));

readl implies le32_to_cpu. Doing it twice on a PCI device is broken
on big-endian hardware.

> +	P9_DPRINTK(P9_DEBUG_TRANS, "%p len %d\n", p9pci_trans->pdev,
> +							p9pci_trans->len);
> +	iowrite32(0, p9pci_trans->ioaddr + 4);

Also, you should not mix iowriteXX/ioreadXX and writeX/readX calls in one
driver. Since you use pci_iomap, iowriteXX/ioreadXX are the correct functions.

> +	wake_up_interruptible(&p9pci_trans->wait);
> +	return IRQ_HANDLED;
> +}
> +
> +static int p9pci_read(struct p9_trans *trans, void *v, int len)
> +{
> +	struct p9pci_trans *ts;
> +
> +	if (!trans || trans->status == Disconnected || !trans->priv)
> +		return -EREMOTEIO;
> +
> +	ts = trans->priv;
> +
> +	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p rx %p tx %p buf %p len %d\n",
> +						trans, ts->rx, ts->tx, v, len);
> +	if (len > ts->len)
> +		len = ts->len;
> +
> +	if (len) {
> +		memcpy_fromio(v, ts->rx, len);
> +		ts->len = 0;
> +		/* let the host knows the message is consumed */
> +		writel(0, ts->rx);
> +		iowrite32(0, p9pci_trans->ioaddr + 4);
> +		P9_DPRINTK(P9_DEBUG_TRANS, "zero rxlen %d txlen %d\n",
> +						readl(ts->rx), readl(ts->tx));
> +	}
> +
> +	return len;
> +}

I would expect memcpy_fromio and memcpy_toio to be relatively inefficient
compared to virtual DMA, depending on the hypervisor. Do you have plans
to change that, or did you have specific reasons to do the memcpy here?

> +	P9_DPRINTK(P9_DEBUG_TRANS, "trans %p rx %p tx %p buf %p len %d\n",
> +						trans, ts->rx, ts->tx, v, len);
> +	P9_DPRINTK(P9_DEBUG_TRANS, "rxlen %d\n", readl(ts->rx));
> +	if (readb(ts->tx) != 0)
> +		return 0;
> +
> +	P9_DPRINTK(P9_DEBUG_TRANS, "tx addr %p io addr %p\n", ts->tx,
> +								ts->ioaddr);

All these P9_DPRINTK statements somewhat limit readability. I would suggest
you kill them as soon as the driver is considered stable.

> +static int __devinit p9pci_probe(struct pci_dev *pdev,
> +		const struct pci_device_id *ent)
> +{
> +	int err;
> +	u8 pci_rev;
> +
> +	if (p9pci_trans)
> +		return -1;

probe should return -EBUSY or similar, not -1.

> +	pci_read_config_byte(pdev, PCI_REVISION_ID, &pci_rev);
> +
> +	if (pdev->vendor == PCI_VENDOR_ID_9P &&
> +	    pdev->device == PCI_DEVICE_ID_9P)
> +		printk(KERN_INFO "pci dev %s (id %04x:%04x rev %02x) is a 9P\n",
> +		       pci_name(pdev), pdev->vendor, pdev->device, pci_rev);

You wouldn't be here for a different vendor/device code, so the check is
bogus.

> +	P9_DPRINTK(P9_DEBUG_TRANS, "%p\n", pdev);
> +	p9pci_trans = kzalloc(sizeof(*p9pci_trans), GFP_KERNEL);
> +	p9pci_trans->irq = -1;

Use NO_IRQ to signify an invalid irq.

> +	init_waitqueue_head(&p9pci_trans->wait);
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		goto error;
> +
> +	p9pci_trans->pdev = pdev;
> +	err = pci_request_regions(pdev, "9p");
> +	if (err)
> +		goto error;
> +
> +	p9pci_trans->ioaddr = pci_iomap(pdev, 0, 8);
> +	if (!p9pci_trans->ioaddr) {
> +		P9_DPRINTK(P9_DEBUG_ERROR, "Cannot remap MMIO, aborting\n");
> +		err = -EIO;
> +		goto error;
> +	}
> +
> +	p9pci_trans->tx = pci_iomap(pdev, 1, 0x20000);
> +	p9pci_trans->rx = pci_iomap(pdev, 2, 0x20000);

New code should use pcim_iomap, you don't need the unmapping code
any more then.

> +	pci_set_drvdata(pdev, p9pci_trans);
> +	err = request_irq(pdev->irq, &p9pci_interrupt, 0, "p9pci", p9pci_trans);
> +	if (err)
> +		goto error;
> +
> +	p9pci_trans->irq = pdev->irq;
> +	return 0;
> +
> +error:
> +	P9_DPRINTK(P9_DEBUG_ERROR, "error %d\n", err);
> +	if (p9pci_trans->irq >= 0) {
> +		synchronize_irq(p9pci_trans->irq);
> +		free_irq(p9pci_trans->irq, p9pci_trans);
> +	}
> +
> +	if (p9pci_trans->pdev) {
> +		pci_release_regions(pdev);
> +		pci_iounmap(pdev, p9pci_trans->ioaddr);
> +		pci_set_drvdata(pdev, NULL);
> +		pci_disable_device(pdev);
> +	}
> +
> +	kfree(p9pci_trans);
> +	return -1;
> +}

return err;

> +static void __exit p9pci_cleanup_module(void)
> +{
> +	pci_unregister_driver(&p9pci_driver);
> +	printk(KERN_ERR "Removal of 9p transports not implemented\n");
> +	BUG();
> +}

Not having a cleanup function at all is a much better way of preventing module
unload.

	Arnd <><

