Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbZFKKQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbZFKKQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZFKKP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:15:59 -0400
Received: from mail.atmel.fr ([81.80.104.162]:41682 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZFKKP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:15:58 -0400
Message-ID: <4A30D94F.7040504@atmel.com>
Date: Thu, 11 Jun 2009 12:15:43 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] at91/USB: Add USB drivers for at91sam9g45 series
References: <1244547684-19672-1-git-send-email-nicolas.ferre@atmel.com> <1244547684-19672-2-git-send-email-nicolas.ferre@atmel.com> <4A2ED2CD.4010502@bluewatersys.com>
In-Reply-To: <4A2ED2CD.4010502@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ryan Mallon :
> Nicolas Ferre wrote:
>> Add both host and gadget USB drivers for at91sam9g45 series. Those SOC embed
>> high speed USB interfaces.
>> The gadget driver is the already available atmel_usba_udc.
>> The host driver is an EHCI with its companion OHCI. EHCI is handled by the new
>> ehci-atmel.c whereas the OHCI is always handled by ohci-at91.c. This last
>> wrapper is modified to allow IRQ sharing between two controllers.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Some comments below.

Thanks a lot for them.

>> ---
>> diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
>> new file mode 100644
>> index 0000000..c5f2303
>> --- /dev/null
>> +++ b/drivers/usb/host/ehci-atmel.c
>> @@ -0,0 +1,251 @@
>> +/*
>> + * Driver for EHCI UHP on Atmel chips
>> + *
>> + *  Copyright (C) 2009 Atmel Corporation,
>> + *                     Nicolas Ferre <nicolas.ferre@atmel.com>
>> + *
>> + *  Based on various ehci-*.c drivers
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License.  See the file COPYING in the main directory of this archive for
>> + * more details.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/platform_device.h>
>> +
>> +/* interface and function clocks */
>> +static struct clk *iclk, *fclk;
>> +static int clocked;
>> +
>> +/*-------------------------------------------------------------------------*/
>> +
>> +static void atmel_start_clock(void)
>> +{
>> +	clk_enable(iclk);
>> +	clk_enable(fclk);
>> +	clocked = 1;
>> +}
>> +
>> +static void atmel_stop_clock(void)
>> +{
>> +	clk_disable(fclk);
>> +	clk_disable(iclk);
>> +	clocked = 0;
>> +}
>> +
>> +static void atmel_start_ehci(struct platform_device *pdev)
>> +{
>> +
>> +	dev_dbg(&pdev->dev, "start\n");
>> +
>> +	/*
>> +	 * Start the USB clocks.
>> +	 */
>> +	atmel_start_clock();
>> +}
> 
> The clocked variable is never used outside of the start/stop functions.
> How come you have separate functions, why not just:
> 
> static void atmel_start_ehci(struct platform_device *pdev)
> {
> 	dev_dbg(&pdev->dev, "start\n");
> 	clk_enable(iclk);
> 	clk_enable(fclk);
> }
> 
> and similarly for the atmel_stop_ehci function. Also, currently these
> are only called from the probe/remove functions, so you could just move
> the clock enable/disable into those, or have you separated these out so
> that can eventually be called from pm_suspend/resume functions?

I must say that this creation of clock management function comes from an
habit of sharing drivers between AVR32 and AT91; moreover between
different kind of AT91 devices that share different clock management
schemes (Cf. at91sam9261 vs other sam9 chips).
Experience has taught me that separating clock management in a single
function set ease things.
You are right also that this may be useful for power management.

For all this I prefer to keep them.

>> +
>> +static void atmel_stop_ehci(struct platform_device *pdev)
>> +{
>> +	dev_dbg(&pdev->dev, "stop\n");
>> +
>> +	/*
>> +	 * Stop the USB clocks.
>> +	 */
>> +	atmel_stop_clock();
>> +}
>> +
>> +/*-------------------------------------------------------------------------*/
> 
> Probably don't need this comment.

Totally agree. Those start/stop comments are useless.


>> +
>> +static int ehci_atmel_setup(struct usb_hcd *hcd)
>> +{
>> +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
>> +	int retval = 0;
>> +
>> +	/*
>> +	 * registers start at offset 0x0
>> +	 */
>> +	ehci->caps = hcd->regs;
>> +	ehci->regs = hcd->regs +
>> +		HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
>> +	dbg_hcs_params(ehci, "reset");
>> +	dbg_hcc_params(ehci, "reset");
>> +
>> +	/*
>> +	 * cache this readonly data; minimize chip reads
>> +	 */
>> +	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
>> +
>> +	retval = ehci_halt(ehci);
>> +	if (retval)
>> +		return retval;
>> +
>> +	/*
>> +	 * data structure init
>> +	 */
>> +	retval = ehci_init(hcd);
>> +	if (retval)
>> +		return retval;
>> +
>> +	ehci->sbrn = 0x20;
>> +
>> +	ehci_reset(ehci);
>> +	ehci_port_power(ehci, 0);
>> +
>> +	return retval;
>> +}
>> +
>> +static const struct hc_driver ehci_atmel_hc_driver = {
>> +	.description		= hcd_name,
>> +	.product_desc		= "Atmel EHCI UHP HS",
>> +	.hcd_priv_size		= sizeof(struct ehci_hcd),
>> +
>> +	/*
>> +	 * generic hardware linkage
>> +	 */
> 
> Nitpick: put single line comments on single lines.

Ok.

>> +	.irq			= ehci_irq,
>> +	.flags			= HCD_MEMORY | HCD_USB2,
>> +
>> +	/*
>> +	 * basic lifecycle operations
>> +	 */
>> +	.reset			= ehci_atmel_setup,
>> +	.start			= ehci_run,
>> +	.stop			= ehci_stop,
>> +	.shutdown		= ehci_shutdown,
>> +
>> +	/*
>> +	 * managing i/o requests and associated device resources
>> +	 */
>> +	.urb_enqueue		= ehci_urb_enqueue,
>> +	.urb_dequeue		= ehci_urb_dequeue,
>> +	.endpoint_disable	= ehci_endpoint_disable,
>> +
>> +	/*
>> +	 * scheduling support
>> +	 */
>> +	.get_frame_number	= ehci_get_frame,
>> +
>> +	/*
>> +	 * root hub support
>> +	 */
>> +	.hub_status_data	= ehci_hub_status_data,
>> +	.hub_control		= ehci_hub_control,
>> +	.bus_suspend		= ehci_bus_suspend,
>> +	.bus_resume		= ehci_bus_resume,
>> +	.relinquish_port	= ehci_relinquish_port,
>> +	.port_handed_over	= ehci_port_handed_over,
>> +};
>> +
>> +static int __init ehci_atmel_drv_probe(struct platform_device *pdev)
>> +{
>> +	struct usb_hcd *hcd;
>> +	const struct hc_driver *driver = &ehci_atmel_hc_driver;
>> +	struct resource *res;
>> +	int irq;
>> +	int retval;
>> +
>> +	if (usb_disabled())
>> +		return -ENODEV;
>> +
>> +	pr_debug("Initializing Atmel-SoC USB Host Controller\n");
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq <= 0) {
>> +		dev_err(&pdev->dev,
>> +			"Found HC with no IRQ. Check %s setup!\n",
>> +			dev_name(&pdev->dev));
>> +		retval = -ENODEV;
>> +		goto fail_create_hcd;
>> +	}
>> +
>> +	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
>> +	if (!hcd) {
>> +		retval = -ENOMEM;
>> +		goto fail_create_hcd;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		dev_err(&pdev->dev,
>> +			"Found HC with no register addr. Check %s setup!\n",
>> +			dev_name(&pdev->dev));
>> +		retval = -ENODEV;
>> +		goto fail_request_resource;
>> +	}
>> +	hcd->rsrc_start = res->start;
>> +	hcd->rsrc_len = res->end - res->start + 1;
>> +
>> +	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
>> +				driver->description)) {
>> +		dev_dbg(&pdev->dev, "controller already in use\n");
>> +		retval = -EBUSY;
>> +		goto fail_request_resource;
>> +	}
>> +
>> +	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
>> +	if (hcd->regs == NULL) {
>> +		dev_dbg(&pdev->dev, "error mapping memory\n");
>> +		retval = -EFAULT;
>> +		goto fail_ioremap;
>> +	}
>> +
>> +	iclk = clk_get(&pdev->dev, "ehci_clk");
>> +	fclk = clk_get(&pdev->dev, "uhpck");
>> +	if (IS_ERR(iclk) || IS_ERR(fclk)) {
>> +		dev_err(&pdev->dev, "Error getting clocks\n");
>> +		retval = -ENOENT;
>> +		goto fail_get_clk;
>> +	}
> 
> This doesn't seem right. If one or neither of the clk_gets succeed here
> then you will clk_put a clock which you never got in fail_get_clk. You
> should probably get the two clocks individually an have separate error
> paths for both.

Ok.


Thanks, I will post a modified patch soon.

Best regards,
-- 
Nicolas Ferre

