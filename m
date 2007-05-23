Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbXEWWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbXEWWLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXEWWLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:11:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:12803 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbXEWWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I17/PkTu2KFD2IH7s4xKy48N5thrwVr/PIaSNaFrQ6y1iK3CpmHiPyZF+FnG5DoCfRi7Rpakzdc5NmK2vZTGG6d33GeQZcC0/U3DZqDC6C8uLShkStOfoJF7vWexvM6oP3HCKsCgJNPNvqGm1tzfo2zk9w4whc/DtBsYCUY9aCk=
Message-ID: <4654BC10.2000808@gmail.com>
Date: Thu, 24 May 2007 02:11:28 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>
In-Reply-To: <adaejl79rh0.fsf@cisco.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>>> Uncompressing Linux .. Ok, booting the kernel.
>>> BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)
>>> PCI: Failed to allocate mem resource #6:20000@30000000 for 0000:01:00.0
> 
> This message is about device 01:00.0 as it says (your nvidia video
> card based on later lspci output).
> 
>  > The device is a new DTV bridge from NXP (SAA7162E) with a PCIe interface.
>  > 
>  > 06:00.0 Multimedia controller: Philips Semiconductors Unknown device
>  > 7162 (rev 01)
>  >         Subsystem: Twinhan Technology Co. Ltd Unknown device 0027
> 
> This is device 06:00.0, so it's not related to that earlier message at
> all.  You didn't say what problem you're having with your driver for
> this device... 


If i uncomment the saa716x_read or write, what i get is a solid freeze
on module load. If i leave it commented out, the module loads fine.

static irqreturn_t saa716x_pcie_irq(int irq, void *dev_id)
{
	struct saa716x *saa716x;
	u32 stat, mask;

	if (unlikely((saa716x = (struct saa716x *) dev_id) == NULL)) {
		printk(KERN_ERR "%s: Aeie NULL ptr\n", __func__);
		return IRQ_NONE;
	}
//	stat = saa716x_read(0x500);
	dprintk(verbose, SAA716x_DEBUG, 0, "=== Interrupts[%04x] [", stat);

	dprintk(verbose, SAA716x_DEBUG, 0, "] ==\n");

	return IRQ_HANDLED;
}

int saa716x_pcie_init(struct saa716x *saa716x)
{
	struct pci_dev *pdev = saa716x->pdev;
	int err = 0;
	u8 latency, revision;

	printk(KERN_INFO "%s: found a %s device\n", __func__,
saa716x->hwconfig->model_name);
	pci_set_drvdata(pdev, saa716x);

	if ((err = pci_enable_device(pdev)) != 0) {
		printk(KERN_ERR "%s ERROR: pci enable failed (%i)\n", __func__, err);
		goto fail0;
	}
	if (request_mem_region(pci_resource_start(pdev, 0),
			       pci_resource_len(pdev, 0), DRIVER_NAME) == NULL) {

		printk(KERN_ERR "%s ERROR: mem region request failed\n", __func__);
		err = -ENOMEM;
		goto fail1;
	}

	saa716x->mmio = ioremap(pci_resource_start(pdev, 0), 0x1000); // FIXME:
check this size

	if ((err = request_irq(pdev->irq, saa716x_pcie_irq, IRQF_SHARED |
IRQF_DISABLED,
			       DRIVER_NAME, (void *) saa716x)) != 0) {
		printk(KERN_ERR "%s ERROR: irq request failed (%i)\n", err, __func__);
		goto fail2;
	}
	pci_set_master(pdev);
	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &latency);
	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);

	dprintk(verbose, SAA716x_ERROR, 0, "     SAA7160/1/2 Rev %d [%04x:%04x], ",
		revision,
		saa716x->pdev->subsystem_vendor, saa716x->pdev->subsystem_device);

	dprintk(verbose, SAA716x_ERROR, 0,
		"irq: %d, latency: %d\n     memory: 0x%04x, mmio: 0x%p\n",
		saa716x->pdev->irq, latency, pci_resource_start(pdev, 0), saa716x->mmio);

	saa716x->verbose = verbose;
//	init_waitqueue_head(&saa716x->i2c_queue);
	/* Disable all interrupts here */
//	saa716x_write(0, 0x500);
	return 0;

fail2:
	iounmap(saa716x->mmio);
	release_mem_region(pci_resource_start(saa716x->pdev, 0),
			   pci_resource_len(saa716x->pdev, 0));
fail1:
	pci_disable_device(pdev);
fail0:
	pci_set_drvdata(pdev, NULL);
	return err;
}
EXPORT_SYMBOL_GPL(saa716x_pcie_init);



> but all standard PCI stuff should work fine for PCIe
> devices -- the normal PCI driver stuff is all you should need for
> everything but exotic cases.

That part is then fine. Does MSI require any special tinkering ?


Thanks,
Manu
