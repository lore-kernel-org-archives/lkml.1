Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZGOVji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZGOVji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZGOVjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:39:37 -0400
Received: from www.tglx.de ([62.245.132.106]:43985 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbZGOVjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:39:36 -0400
Date: Wed, 15 Jul 2009 23:39:11 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: anthony@codemonkey.ws, avi@redhat.com, kvm@vger.kernel.org,
       chrisw@redhat.com, hjk@linutronix.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090715213909.GA3637@local>
References: <20090715201340.GA12279@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715201340.GA12279@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> This adds a generic uio driver that can bind to any PCI device.  First
> user will be virtualization where a qemu userspace process needs to give
> guest OS access to the device.
> 
> Interrupts are handled using the Interrupt Disable bit in the PCI command
> register and Interrupt Status bit in the PCI status register.  All devices
> compliant to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
> support these bits.  Driver detects this support, and won't bind to devices
> which do not support the Interrupt Disable Bit in the command register.
> 
> It's expected that more features of interest to virtualization will be
> added to this driver in the future. Possibilities are: mmap for device
> resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.

Well, I'm not enough of a PCI expert to tell whether your 2.3-test works or
not (can it have side effects, e.g. trigger an interrupt when you toggle that
bit?). I've added Jesse Barnes to Cc: since you modify a PCI core header file.
If there are no objections from the PCI people, I guess we can take this.

Thanks,
Hans

> 
> Acked-by: Chris Wright <chrisw@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
> 
> Hans, Greg, please review and consider for upstream.
> 
> This is intended to solve the problem in virtualization that shared
> interrupts do not work with assigned devices. Earlier versions of this
> patch have circulated on kvm@vger.
> 
> Changes since v1:
> - some naming changes
> - do a single read to get both command and status register
> Changes since v2:
> - remove irqcontrol: user can enable interrupts by
>   writing command register directly
> - don't claim resources as we don't support mmap yet,
>   but note the intent to do so in the commit log
> Changes since v3:
> - minor driver version fix
> 
>  MAINTAINERS                   |    8 ++
>  drivers/uio/Kconfig           |   10 ++
>  drivers/uio/Makefile          |    1 +
>  drivers/uio/uio_pci_generic.c |  207 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci_regs.h      |    1 +
>  5 files changed, 227 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pci_generic.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 18c3f0c..39c7207 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2538,6 +2538,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
>  S:	Maintained
>  F:	include/asm-generic
>  
> +GENERIC UIO DRIVER FOR PCI DEVICES
> +P:	Michael S. Tsirkin
> +M:	mst@redhat.com
> +L:	kvm@vger.kernel.org
> +L:	linux-kernel@vger.kernel.org
> +S:	Supported
> +F:	drivers/uio/uio_pci_generic.c
> +
>  GFS2 FILE SYSTEM
>  P:	Steven Whitehouse
>  M:	swhiteho@redhat.com
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 7f86534..0f14c8e 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -89,4 +89,14 @@ config UIO_SERCOS3
>  
>  	  If you compile this as a module, it will be called uio_sercos3.
>  
> +config UIO_PCI_GENERIC
> +	tristate "Generic driver for PCI 2.3 and PCI Express cards"
> +	depends on PCI
> +	default n
> +	help
> +	  Generic driver that you can bind, dynamically, to any
> +	  PCI 2.3 compliant and PCI Express card. It is useful,
> +	  primarily, for virtualization scenarios.
> +	  If you compile this as a module, it will be called uio_pci_generic.
> +
>  endif
> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
> index 5c2586d..73b2e75 100644
> --- a/drivers/uio/Makefile
> +++ b/drivers/uio/Makefile
> @@ -5,3 +5,4 @@ obj-$(CONFIG_UIO_PDRV_GENIRQ)	+= uio_pdrv_genirq.o
>  obj-$(CONFIG_UIO_SMX)	+= uio_smx.o
>  obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
>  obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
> +obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> new file mode 100644
> index 0000000..313da35
> --- /dev/null
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -0,0 +1,207 @@
> +/* uio_pci_generic - generic UIO driver for PCI 2.3 devices
> + *
> + * Copyright (C) 2009 Red Hat, Inc.
> + * Author: Michael S. Tsirkin <mst@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * Since the driver does not declare any device ids, you must allocate
> + * id and bind the device to the driver yourself.  For example:
> + *
> + * # echo "8086 10f5" > /sys/bus/pci/drivers/uio_pci_generic/new_id
> + * # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/e1000e/unbind
> + * # echo -n 0000:00:19.0 > /sys/bus/pci/drivers/uio_pci_generic/bind
> + * # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
> + * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/uio_pci_generic
> + *
> + * Driver won't bind to devices which do not support the Interrupt Disable Bit
> + * in the command register. All devices compliant to PCI 2.3 (circa 2002) and
> + * all compliant PCI Express devices should support this bit.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/uio_driver.h>
> +#include <linux/spinlock.h>
> +
> +#define DRIVER_VERSION	"0.01.0"
> +#define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
> +#define DRIVER_DESC	"Generic UIO driver for PCI 2.3 devices"
> +
> +struct uio_pci_generic_dev {
> +	struct uio_info info;
> +	struct pci_dev *pdev;
> +	spinlock_t lock; /* guards command register accesses */
> +};
> +
> +static inline struct uio_pci_generic_dev *
> +to_uio_pci_generic_dev(struct uio_info *info)
> +{
> +	return container_of(info, struct uio_pci_generic_dev, info);
> +}
> +
> +/* Interrupt handler. Read/modify/write the command register to disable
> + * the interrupt. */
> +static irqreturn_t irqhandler(int irq, struct uio_info *info)
> +{
> +	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
> +	struct pci_dev *pdev = gdev->pdev;
> +	irqreturn_t ret = IRQ_NONE;
> +	u32 cmd_status_dword;
> +	u16 origcmd, newcmd, status;
> +
> +	/* We do a single dword read to retrieve both command and status.
> +	 * Document assumptions that make this possible. */
> +	BUILD_BUG_ON(PCI_COMMAND % 4);
> +	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
> +
> +	spin_lock_irq(&gdev->lock);
> +	pci_block_user_cfg_access(pdev);
> +
> +	/* Read both command and status registers in a single 32-bit operation.
> +	 * Note: we could cache the value for command and move the status read
> +	 * out of the lock if there was a way to get notified of user changes
> +	 * to command register through sysfs. Should be good for shared irqs. */
> +	pci_read_config_dword(pdev, PCI_COMMAND, &cmd_status_dword);
> +	origcmd = cmd_status_dword;
> +	status = cmd_status_dword >> 16;
> +
> +	/* Check interrupt status register to see whether our device
> +	 * triggered the interrupt. */
> +	if (!(status & PCI_STATUS_INTERRUPT))
> +		goto done;
> +
> +	/* We triggered the interrupt, disable it. */
> +	newcmd = origcmd | PCI_COMMAND_INTX_DISABLE;
> +	if (newcmd != origcmd)
> +		pci_write_config_word(pdev, PCI_COMMAND, newcmd);
> +
> +	/* UIO core will signal the user process. */
> +	ret = IRQ_HANDLED;
> +done:
> +
> +	pci_unblock_user_cfg_access(pdev);
> +	spin_unlock_irq(&gdev->lock);
> +	return ret;
> +}
> +
> +/* Verify that the device supports Interrupt Disable bit in command register,
> + * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
> + * in PCI 2.2. */
> +static int __devinit verify_pci_2_3(struct pci_dev *pdev)
> +{
> +	u16 orig, new;
> +	int err = 0;
> +
> +	pci_block_user_cfg_access(pdev);
> +	pci_read_config_word(pdev, PCI_COMMAND, &orig);
> +	pci_write_config_word(pdev, PCI_COMMAND,
> +			      orig ^ PCI_COMMAND_INTX_DISABLE);
> +	pci_read_config_word(pdev, PCI_COMMAND, &new);
> +	/* There's no way to protect against
> +	 * hardware bugs or detect them reliably, but as long as we know
> +	 * what the value should be, let's go ahead and check it. */
> +	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
> +		err = -EBUSY;
> +		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
> +			"driver or HW bug?\n", orig, new);
> +		goto err;
> +	}
> +	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
> +		dev_warn(&pdev->dev, "Device does not support "
> +			 "disabling interrupts: unable to bind.\n");
> +		err = -ENODEV;
> +		goto err;
> +	}
> +	/* Now restore the original value. */
> +	pci_write_config_word(pdev, PCI_COMMAND, orig);
> +err:
> +	pci_unblock_user_cfg_access(pdev);
> +	return err;
> +}
> +
> +static int __devinit probe(struct pci_dev *pdev,
> +			   const struct pci_device_id *id)
> +{
> +	struct uio_pci_generic_dev *gdev;
> +	int err;
> +
> +	if (!pdev->irq) {
> +		dev_warn(&pdev->dev, "No IRQ assigned to device: "
> +			 "no support for interrupts?\n");
> +		return -ENODEV;
> +	}
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "%s: pci_enable_device failed: %d\n",
> +			__func__, err);
> +		return err;
> +	}
> +
> +	err = verify_pci_2_3(pdev);
> +	if (err)
> +		goto err_verify;
> +
> +	gdev = kzalloc(sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
> +	if (!gdev) {
> +		err = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	gdev->info.name = "uio_pci_generic";
> +	gdev->info.version = DRIVER_VERSION;
> +	gdev->info.irq = pdev->irq;
> +	gdev->info.irq_flags = IRQF_SHARED;
> +	gdev->info.handler = irqhandler;
> +	gdev->pdev = pdev;
> +	spin_lock_init(&gdev->lock);
> +
> +	if (uio_register_device(&pdev->dev, &gdev->info))
> +		goto err_register;
> +	pci_set_drvdata(pdev, gdev);
> +
> +	return 0;
> +err_register:
> +	kfree(gdev);
> +err_alloc:
> +err_verify:
> +	pci_disable_device(pdev);
> +	return err;
> +}
> +
> +static void remove(struct pci_dev *pdev)
> +{
> +	struct uio_pci_generic_dev *gdev = pci_get_drvdata(pdev);
> +
> +	uio_unregister_device(&gdev->info);
> +	pci_disable_device(pdev);
> +	kfree(gdev);
> +}
> +
> +static struct pci_driver driver = {
> +	.name = "uio_pci_generic",
> +	.id_table = NULL, /* only dynamic id's */
> +	.probe = probe,
> +	.remove = remove,
> +};
> +
> +static int __init init(void)
> +{
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> +	return pci_register_driver(&driver);
> +}
> +
> +static void __exit cleanup(void)
> +{
> +	pci_unregister_driver(&driver);
> +}
> +
> +module_init(init);
> +module_exit(cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index fcaee42..dd0bed4 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -42,6 +42,7 @@
>  #define  PCI_COMMAND_INTX_DISABLE 0x400 /* INTx Emulation Disable */
>  
>  #define PCI_STATUS		0x06	/* 16 bits */
> +#define  PCI_STATUS_INTERRUPT	0x08	/* Interrupt status */
>  #define  PCI_STATUS_CAP_LIST	0x10	/* Support Capability List */
>  #define  PCI_STATUS_66MHZ	0x20	/* Support 66 Mhz PCI 2.1 bus */
>  #define  PCI_STATUS_UDF		0x40	/* Support User Definable Features [obsolete] */
> -- 
> 1.6.2.5
