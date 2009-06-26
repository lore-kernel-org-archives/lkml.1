Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZFZFZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZFZFZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZFZFZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:25:31 -0400
Received: from n22b.bullet.mail.mud.yahoo.com ([68.142.206.159]:39416 "HELO
	n22b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751034AbZFZFZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:25:29 -0400
X-Yahoo-Newman-Id: 819443.30010.bm@omp403.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2kMGiEqTpjKpfKR2+gtKQrMCVmfX7TgewNRIDYTxpx1Mg3MHnlC2FL7fL3HfasphjeWf7PiWQE8OpOa2EYXSV4LU2iaXK0ZkCuVV32+Z9gsyPyKukWQvWxFvRoCJoB3QvL9689ZESFbhYnoT0WTCZKn+lZXkq4Zm0SnI6vIMVtw=  ;
X-YMail-OSG: td20wYwVM1nrDUPKF5.h5f47dt9KM_Uz0iu9EJdbOYlXl65M0pyaC2MMZ3eRlmrdkVwkm3YUJrVKMoPNDZfjnmblB3xDwcolNHJ7rZdzIAbja_fwR.Ou482B26cm4bx7qGMERcN3WnPockSYwN6zYZ8Smh4lnCV6nkq39mRj7.x2_MYJL7C8ifSn64wqNdNExM4dyaAPrXljwUg3ni05xJ0JRRKatAChO2Oaturb2mm1C7AnLE0EeBjBsN.AcGaXHKJzKDcOZ3s49ZS_jDjkf9ZDCvGhyCZPRjkr.I.ybc7XUVqLf_.wprJVQZGjhA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 3/3 v3] at91/USB: Add USB EHCI driver for at91sam9g45 series
Date: Thu, 25 Jun 2009 22:25:31 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com
References: <200906190045.16496.david-b@pacbell.net> <1245776317-7134-3-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1245776317-7134-3-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252225.31665.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Nicolas Ferre wrote:
> Add host USB High speed driver for at91sam9g45 series.
> The host driver is an EHCI with its companion OHCI. EHCI is
> handled by the new ehci-atmel.c whereas the OHCI is always
> handled by ohci-at91.c.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

.... although a followup patch would be nice to remove
the MODULE_ALIAS() thing now that it's no longer needed.


> ---
> v2 -> v3: split patch to:
> - gadget
> - ohci
> - ehci
> 
>  drivers/usb/Kconfig           |    1 +
>  drivers/usb/host/ehci-atmel.c |  232 +++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/ehci-hcd.c   |    5 +
>  3 files changed, 238 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/host/ehci-atmel.c
> 
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index c6c816b..3974c9c 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -57,6 +57,7 @@ config USB_ARCH_HAS_EHCI
>  	default y if PPC_83xx
>  	default y if SOC_AU1200
>  	default y if ARCH_IXP4XX
> +	default y if ARCH_AT91SAM9G45
>  	default PCI
>  
>  # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
> diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
> new file mode 100644
> index 0000000..3095403
> --- /dev/null
> +++ b/drivers/usb/host/ehci-atmel.c
> @@ -0,0 +1,232 @@
> +/*
> + * Driver for EHCI UHP on Atmel chips
> + *
> + *  Copyright (C) 2009 Atmel Corporation,
> + *                     Nicolas Ferre <nicolas.ferre@atmel.com>
> + *
> + *  Based on various ehci-*.c drivers
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file COPYING in the main directory of this archive for
> + * more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +
> +/* interface and function clocks */
> +static struct clk *iclk, *fclk;
> +static int clocked;
> +
> +/*-------------------------------------------------------------------------*/
> +
> +static void atmel_start_clock(void)
> +{
> +	clk_enable(iclk);
> +	clk_enable(fclk);
> +	clocked = 1;
> +}
> +
> +static void atmel_stop_clock(void)
> +{
> +	clk_disable(fclk);
> +	clk_disable(iclk);
> +	clocked = 0;
> +}
> +
> +static void atmel_start_ehci(struct platform_device *pdev)
> +{
> +	dev_dbg(&pdev->dev, "start\n");
> +	atmel_start_clock();
> +}
> +
> +static void atmel_stop_ehci(struct platform_device *pdev)
> +{
> +	dev_dbg(&pdev->dev, "stop\n");
> +	atmel_stop_clock();
> +}
> +
> +/*-------------------------------------------------------------------------*/
> +
> +static int ehci_atmel_setup(struct usb_hcd *hcd)
> +{
> +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> +	int retval = 0;
> +
> +	/* registers start at offset 0x0 */
> +	ehci->caps = hcd->regs;
> +	ehci->regs = hcd->regs +
> +		HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
> +	dbg_hcs_params(ehci, "reset");
> +	dbg_hcc_params(ehci, "reset");
> +
> +	/* cache this readonly data; minimize chip reads */
> +	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
> +
> +	retval = ehci_halt(ehci);
> +	if (retval)
> +		return retval;
> +
> +	/* data structure init */
> +	retval = ehci_init(hcd);
> +	if (retval)
> +		return retval;
> +
> +	ehci->sbrn = 0x20;
> +
> +	ehci_reset(ehci);
> +	ehci_port_power(ehci, 0);
> +
> +	return retval;
> +}
> +
> +static const struct hc_driver ehci_atmel_hc_driver = {
> +	.description		= hcd_name,
> +	.product_desc		= "Atmel EHCI UHP HS",
> +	.hcd_priv_size		= sizeof(struct ehci_hcd),
> +
> +	/* generic hardware linkage */
> +	.irq			= ehci_irq,
> +	.flags			= HCD_MEMORY | HCD_USB2,
> +
> +	/* basic lifecycle operations */
> +	.reset			= ehci_atmel_setup,
> +	.start			= ehci_run,
> +	.stop			= ehci_stop,
> +	.shutdown		= ehci_shutdown,
> +
> +	/* managing i/o requests and associated device resources */
> +	.urb_enqueue		= ehci_urb_enqueue,
> +	.urb_dequeue		= ehci_urb_dequeue,
> +	.endpoint_disable	= ehci_endpoint_disable,
> +
> +	/* scheduling support */
> +	.get_frame_number	= ehci_get_frame,
> +
> +	/* root hub support */
> +	.hub_status_data	= ehci_hub_status_data,
> +	.hub_control		= ehci_hub_control,
> +	.bus_suspend		= ehci_bus_suspend,
> +	.bus_resume		= ehci_bus_resume,
> +	.relinquish_port	= ehci_relinquish_port,
> +	.port_handed_over	= ehci_port_handed_over,
> +};
> +
> +static int __init ehci_atmel_drv_probe(struct platform_device *pdev)
> +{
> +	struct usb_hcd *hcd;
> +	const struct hc_driver *driver = &ehci_atmel_hc_driver;
> +	struct resource *res;
> +	int irq;
> +	int retval;
> +
> +	if (usb_disabled())
> +		return -ENODEV;
> +
> +	pr_debug("Initializing Atmel-SoC USB Host Controller\n");
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		dev_err(&pdev->dev,
> +			"Found HC with no IRQ. Check %s setup!\n",
> +			dev_name(&pdev->dev));
> +		retval = -ENODEV;
> +		goto fail_create_hcd;
> +	}
> +
> +	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
> +	if (!hcd) {
> +		retval = -ENOMEM;
> +		goto fail_create_hcd;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev,
> +			"Found HC with no register addr. Check %s setup!\n",
> +			dev_name(&pdev->dev));
> +		retval = -ENODEV;
> +		goto fail_request_resource;
> +	}
> +	hcd->rsrc_start = res->start;
> +	hcd->rsrc_len = res->end - res->start + 1;
> +
> +	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
> +				driver->description)) {
> +		dev_dbg(&pdev->dev, "controller already in use\n");
> +		retval = -EBUSY;
> +		goto fail_request_resource;
> +	}
> +
> +	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
> +	if (hcd->regs == NULL) {
> +		dev_dbg(&pdev->dev, "error mapping memory\n");
> +		retval = -EFAULT;
> +		goto fail_ioremap;
> +	}
> +
> +	iclk = clk_get(&pdev->dev, "ehci_clk");
> +	if (IS_ERR(iclk)) {
> +		dev_err(&pdev->dev, "Error getting interface clock\n");
> +		retval = -ENOENT;
> +		goto fail_get_iclk;
> +	}
> +	fclk = clk_get(&pdev->dev, "uhpck");
> +	if (IS_ERR(fclk)) {
> +		dev_err(&pdev->dev, "Error getting function clock\n");
> +		retval = -ENOENT;
> +		goto fail_get_fclk;
> +	}
> +
> +	atmel_start_ehci(pdev);
> +
> +	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
> +	if (retval)
> +		goto fail_add_hcd;
> +
> +	return retval;
> +
> +fail_add_hcd:
> +	atmel_stop_ehci(pdev);
> +	clk_put(fclk);
> +fail_get_fclk:
> +	clk_put(iclk);
> +fail_get_iclk:
> +	iounmap(hcd->regs);
> +fail_ioremap:
> +	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> +fail_request_resource:
> +	usb_put_hcd(hcd);
> +fail_create_hcd:
> +	dev_err(&pdev->dev, "init %s fail, %d\n",
> +		dev_name(&pdev->dev), retval);
> +
> +	return retval;
> +}
> +
> +static int __exit ehci_atmel_drv_remove(struct platform_device *pdev)
> +{
> +	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> +
> +	ehci_shutdown(hcd);
> +	usb_remove_hcd(hcd);
> +	iounmap(hcd->regs);
> +	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> +	usb_put_hcd(hcd);
> +
> +	atmel_stop_ehci(pdev);
> +	clk_put(fclk);
> +	clk_put(iclk);
> +	fclk = iclk = NULL;
> +
> +	return 0;
> +}
> +
> +MODULE_ALIAS("platform:atmel-ehci");
> +
> +static struct platform_driver ehci_atmel_driver = {
> +	.probe		= ehci_atmel_drv_probe,
> +	.remove		= __exit_p(ehci_atmel_drv_remove),
> +	.shutdown	= usb_hcd_platform_shutdown,
> +	.driver.name	= "atmel-ehci",
> +};
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index c637207..df2ddee 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -1072,6 +1072,11 @@ MODULE_LICENSE ("GPL");
>  #define	PLATFORM_DRIVER		ixp4xx_ehci_driver
>  #endif
>  
> +#ifdef CONFIG_ARCH_AT91
> +#include "ehci-atmel.c"
> +#define	PLATFORM_DRIVER		ehci_atmel_driver
> +#endif
> +
>  #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
>      !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER)
>  #error "missing bus glue for ehci-hcd"
> -- 
> 1.5.3.7
> 
> 



