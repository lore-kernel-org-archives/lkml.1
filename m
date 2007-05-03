Return-Path: <linux-kernel-owner+w=401wt.eu-S1161796AbXECGuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161796AbXECGuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161802AbXECGuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:50:02 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161796AbXECGuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:50:00 -0400
Date: Wed, 2 May 2007 23:49:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 1/1] Misc: add sensable phantom driver
Message-Id: <20070502234956.cdfe31c2.akpm@linux-foundation.org>
In-Reply-To: <219403193181341921@karneval.cz>
References: <219403193181341921@karneval.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 May 2007 17:56:01 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:

> add sensable phantom driver

<googles>

Is that one of these? 
http://www.est-kl.com/aufbau_general/index_hard_haptic.html?http://www.est-kl.com/hardware/haptic/sensable/phantom_omni.html

I don't think we've ever had a driver for a device like that before.  I
wonder how you designed the userspace interface to it.

> +static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
> +	u_long arg)

Could we please use standard-looking types in this driver?  u32 and u64 and
things?

However in this case, as it's an ioctl handler it should be "int" and
"unsigned long".

Does this driver require compat handling?  (Seems not?)

> static int phantom_open(struct inode *inode, struct file *file)
> {
> 	struct phantom_device *dev = container_of(inode->i_cdev,
> 			struct phantom_device, cdev);
> 
> 	if (mutex_lock_interruptible(&dev->open_lock))
> 		return -ERESTARTSYS;
> 
> 	if (dev->opened) {
> 		mutex_unlock(&dev->open_lock);
> 		return -EINVAL;
> 	}
> 
> 	file->private_data = dev;
> 
> 	dev->opened++;
> 	mutex_unlock(&dev->open_lock);
> 
> 	return 0;
> }

You should call nonseekable_open() in here.

> +static int phantom_release(struct inode *inode, struct file *file)
> +{
> +	struct phantom_device *dev = file->private_data;
> +
> +	if (mutex_lock_interruptible(&dev->open_lock))
> +		return -ERESTARTSYS;
> +
> +	dev->opened = 0;
> +	phantom_status(dev, dev->status & ~PHB_RUNNING);
> +
> +	mutex_unlock(&dev->open_lock);
> +
> +	return 0;
> +}

The mutex_lock_interruptible() is wrong, I think.  This function is called
when we do the final close().  If the signal _is_ taken then it's game
over: the device can no longer be opened.

> +static unsigned int phantom_poll(struct file *file, poll_table *wait)
> +{
> +	struct phantom_device *dev = file->private_data;
> +	unsigned int mask = 0;
> +
> +	pr_debug("phantom_poll: %u\n", dev->counter);
> +	poll_wait(file, &dev->wait, wait);
> +	if (dev->counter) {
> +		mask = POLLIN | POLLRDNORM;
> +		dev->counter--;
> +	} else if ((dev->status & PHB_RUNNING) == 0)
> +		mask = POLLIN | POLLRDNORM | POLLERR;
> +	pr_debug("phantom_poll end: %x/%u\n", mask, dev->counter);
> +
> +	return mask;
> +}
> +
> +static struct file_operations phantom_file_ops = {
> +	.open = phantom_open,
> +	.release = phantom_release,
> +	.ioctl = phantom_ioctl,
> +	.poll = phantom_poll,
> +};
> +
> +static irqreturn_t phantom_isr(int irq, void *data)
> +{
> +	struct phantom_device *dev = data;
> +
> +	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
> +		return IRQ_NONE;
> +
> +	iowrite32(0, dev->iaddr);
> +	iowrite32(0xc0, dev->iaddr);
> +
> +	dev->counter++;
> +	wake_up_interruptible(&dev->wait);
> +
> +	return IRQ_HANDLED;
> +}

The access to dev->counter is racy even on non-preempt uniprocessor.  An
atomic_t would suit.

> +/*
> + * Init and deinit driver
> + */
> +
> +static unsigned int __devinit phantom_get_free(void)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < PHANTOM_MAX_MINORS; i++)
> +		if (phantom_devices[i] == 0)
> +			break;
> +
> +	return i;
> +}

This function assumes that the phantom_devices[] array will never have any
holes in it.  But if phantom_remove() is called out-of-order, it _will_
have holes.  Perhaps - I didn't look too hard.


> +static int __devinit phantom_probe(struct pci_dev *pdev,
> +	const struct pci_device_id *pci_id)
> +{
> +	struct phantom_device *pht;
> +	unsigned int minor;
> +	int retval;
> +
> +	retval = pci_enable_device(pdev);
> +	if (retval)
> +		goto err;
> +
> +	minor = phantom_get_free();
> +	if (minor == PHANTOM_MAX_MINORS) {
> +		dev_err(&pdev->dev, "too many devices found!\n");
> +		retval = -EIO;
> +		goto err_dis;
> +	}
> +
> +	phantom_devices[minor] = 1;
> +
> +	retval = pci_request_regions(pdev, "phantom");
> +	if (retval)
> +		goto err_null;
> +
> +	retval = -ENOMEM;
> +	pht = kzalloc(sizeof(*pht), GFP_KERNEL);
> +	if (pht == NULL) {
> +		dev_err(&pdev->dev, "unable to allocate device\n");
> +		goto err_reg;
> +	}
> +
> +	pht->caddr = pci_iomap(pdev, 0, 0);
> +	if (pht->caddr == NULL) {
> +		dev_err(&pdev->dev, "can't remap conf space\n");
> +		goto err_fr;
> +	}
> +	pht->iaddr = pci_iomap(pdev, 2, 0);
> +	if (pht->iaddr == NULL) {
> +		dev_err(&pdev->dev, "can't remap input space\n");
> +		goto err_unmc;
> +	}
> +	pht->oaddr = pci_iomap(pdev, 3, 0);
> +	if (pht->oaddr == NULL) {
> +		dev_err(&pdev->dev, "can't remap output space\n");
> +		goto err_unmi;
> +	}
> +
> +	mutex_init(&pht->open_lock);
> +	init_waitqueue_head(&pht->wait);
> +	cdev_init(&pht->cdev, &phantom_file_ops);
> +	pht->cdev.owner = THIS_MODULE;
> +
> +	iowrite32(0, pht->caddr + PHN_IRQCTL);
> +	retval = request_irq(pdev->irq, phantom_isr,
> +			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
> +	if (retval) {
> +		dev_err(&pdev->dev, "can't establish ISR\n");
> +		goto err_unmo;
> +	}
> +
> +	retval = cdev_add(&pht->cdev, MKDEV(phantom_major, minor), 1);
> +	if (retval) {
> +		dev_err(&pdev->dev, "chardev registration failed\n");
> +		goto err_irq;
> +	}
> +
> +	if (IS_ERR(device_create(phantom_class, &pdev->dev, MKDEV(phantom_major,
> +			minor), "phantom%u", minor)))
> +		dev_err(&pdev->dev, "can't create device\n");
> +
> +	pci_set_drvdata(pdev, pht);
> +
> +	return 0;
> +err_irq:
> +	free_irq(pdev->irq, pht);
> +err_unmo:
> +	pci_iounmap(pdev, pht->oaddr);
> +err_unmi:
> +	pci_iounmap(pdev, pht->iaddr);
> +err_unmc:
> +	pci_iounmap(pdev, pht->caddr);
> +err_fr:
> +	kfree(pht);
> +err_reg:
> +	pci_release_regions(pdev);
> +err_null:
> +	phantom_devices[minor] = 0;
> +err_dis:
> +	pci_disable_device(pdev);
> +err:
> +	return retval;
> +}
> +
> +static void __devexit phantom_remove(struct pci_dev *pdev)
> +{
> +	struct phantom_device *pht = pci_get_drvdata(pdev);
> +	unsigned int minor = MINOR(pht->cdev.dev);
> +
> +	device_destroy(phantom_class, MKDEV(phantom_major, minor));
> +
> +	cdev_del(&pht->cdev);
> +
> +	iowrite32(0, pht->caddr + PHN_IRQCTL);
> +	free_irq(pdev->irq, pht);
> +
> +	pci_iounmap(pdev, pht->oaddr);
> +	pci_iounmap(pdev, pht->iaddr);
> +	pci_iounmap(pdev, pht->caddr);
> +
> +	kfree(pht);
> +
> +	pci_release_regions(pdev);
> +
> +	phantom_devices[minor] = 0;
> +
> +	pci_disable_device(pdev);
> +}
> +
> +#ifdef CONFIG_PM
> +static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct phantom_device *dev = pci_get_drvdata(pdev);
> +
> +	iowrite32(0, dev->caddr + PHN_IRQCTL);
> +
> +	return 0;
> +}
> +
> +static int phantom_resume(struct pci_dev *pdev)
> +{
> +	struct phantom_device *dev = pci_get_drvdata(pdev);
> +
> +	iowrite32(0, dev->caddr + PHN_IRQCTL);
> +
> +	return 0;
> +}
> +#endif

It's conventional to do

#else
#define phantom_suspend NULL
#define phantom_resume NULL
#endif

> +static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050),
> +		.class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, phantom_pci_tbl);
> +
> +static struct pci_driver phantom_pci_driver = {
> +	.name = "phantom",
> +	.id_table = phantom_pci_tbl,
> +	.probe = phantom_probe,
> +	.remove = __devexit_p(phantom_remove),
> +#ifdef CONFIG_PM
> +	.suspend = phantom_suspend,
> +	.resume = phantom_resume
> +#endif
> +};

thus making these ifdefs unnecessary.

> index 0000000..d3ebbfa
> --- /dev/null
> +++ b/include/linux/phantom.h
> @@ -0,0 +1,42 @@
> +/*
> + *  Copyright (C) 2005-2007 Jiri Slaby <jirislaby@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + */
> +
> +#ifndef __PHANTOM_H
> +#define __PHANTOM_H
> +
> +#include <asm/types.h>
> +
> +/* PHN_(G/S)ET_REG param */
> +struct phm_reg {
> +	__u32 reg;
> +	__u32 value;
> +};
> +
> +/* PHN_(G/S)ET_REGS param */
> +struct phm_regs {
> +	__u32 count;
> +	__u32 mask;
> +	__u32 values[8];
> +};

No, I guess it doesn't need compat handling.

> +#define PH_IOC_MAGIC		'p'
> +#define PHN_GET_REG		_IOWR(PH_IOC_MAGIC, 0, struct phm_reg *)
> +#define PHN_SET_REG		_IOW (PH_IOC_MAGIC, 1, struct phm_reg *)
> +#define PHN_GET_REGS		_IOWR(PH_IOC_MAGIC, 2, struct phm_regs *)
> +#define PHN_SET_REGS		_IOW (PH_IOC_MAGIC, 3, struct phm_regs *)
> +#define PH_IOC_MAXNR		3
> +
> +#define PHN_CONTROL		0x6     /* control byte in iaddr space */
> +#define PHN_CTL_AMP		0x1     /*   switch after torques change */
> +#define PHN_CTL_BUT		0x2     /*   is button switched */
> +#define PHN_CTL_IRQ		0x10    /*   is irq enabled */
> +
> +#define PHN_ZERO_FORCE		2048	/* zero torque on motor */
> +
> +#endif

Exported to userspace?  If so, it'll need a mention in include/linux/Kbuild?
