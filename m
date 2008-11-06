Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbYKFTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbYKFTa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYKFTaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:30:15 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:39189 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKFTaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:30:13 -0500
X-IronPort-AV: E=Sophos;i="4.33,559,1220241600"; 
   d="scan'208";a="62179666"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB/ISP1760: Add support for the generic platfrom device centralized driver model
Date: Thu, 6 Nov 2008 19:29:30 -0000
Message-ID: <8A42379416420646B9BFAC9682273B6D0649D8D0@limkexm3.ad.analog.com>
In-Reply-To: <20081106175705.GA4687@www.tglx.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB/ISP1760: Add support for the generic platfrom device centralized driver model
Thread-Index: AclAOYvlvKjkh+v5R8amh3Z3QgQjOAACz4mQ
References: <1225963549-9892-1-git-send-email-cooloney@kernel.org> <20081106175705.GA4687@www.tglx.de>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
       "Bryan Wu" <cooloney@kernel.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
X-OriginalArrivalTime: 06 Nov 2008 19:29:35.0614 (UTC) FILETIME=[007229E0:01C94046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

Thanks for your feedback, see my comments below.
We will resubmit a patch soon.

Thanks and best regards,
Michael


>-----Original Message-----
>From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de]
>Sent: Thursday, November 06, 2008 6:57 PM
>To: Bryan Wu
>Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
>Hennerich
>Subject: Re: [PATCH] USB/ISP1760: Add support for the generic platfrom
>device centralized driver model
>
>* Bryan Wu | 2008-11-06 17:25:49 [+0800]:
>
>>From: Michael Hennerich <michael.hennerich@analog.com>
>>
>>Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>>Signed-off-by: Bryan Wu <cooloney@kernel.org>
>>---
>> drivers/usb/host/isp1760-if.c |   98
>+++++++++++++++++++++++++++++++++++++++++
>> 1 files changed, 98 insertions(+), 0 deletions(-)
>>
>>diff --git a/drivers/usb/host/isp1760-if.c
b/drivers/usb/host/isp1760-if.c
>>index af849f5..dc16698 100644
>>--- a/drivers/usb/host/isp1760-if.c
>>+++ b/drivers/usb/host/isp1760-if.c
>>@@ -3,6 +3,7 @@
>>  * Currently there is support for
>>  * - OpenFirmware
>>  * - PCI
>>+ * - PDEV (generic platform device centralized driver model)
>>  *
>>  * (c) 2007 Sebastian Siewior <bigeasy@linutronix.de>
>>  *
>>@@ -23,6 +24,12 @@
>> #include <linux/pci.h>
>> #endif
>>
>>+#if !defined(CONFIG_USB_ISP1760_OF) &&
!defined(CONFIG_USB_ISP1760_PCI)
>>+#define USB_ISP1760_PDEV
>Usually I would prefer to make it conditional on
>CONFIGU_USB_ISP1760_PDEV. But since
>http://marc.info/?l=linux-usb&m=122563596420156&w=2 I would prefer to
>have unconditional.
>Any reason why you only enable it PDEV if you have neiher PCI nor OF?


Originally I had this kconfig option, but later decided to toss it.
Why would you use pdev if you have PCI or OF, was my argument... :-)
I'll add it back.   

>
>>+#include <linux/platform_device.h>
>>+#include <linux/usb/isp1760.h>
>You can't include files which are not mainline

My tree features this file.
It simply misses in this patch.


>
>>+#endif
>>+
>> #ifdef CONFIG_USB_ISP1760_OF
>> static int of_isp1760_probe(struct of_device *dev,
>> 		const struct of_device_id *match)
>>@@ -286,12 +293,100 @@ static struct pci_driver isp1761_pci_driver = {
>> };
>> #endif
>>
>>+#ifdef USB_ISP1760_PDEV
>>+static int __devinit
>>+isp1760_pdev_probe(struct platform_device *pdev)
>>+{
>Please make it
>static int __devinit isp1760_pdev_probe(struct platform_device *pdev)

I see - single line...

>
>>+	struct usb_hcd *hcd;
>>+	struct resource	*addr;
>>+	int irq;
>>+	unsigned int devflags = 0;
>>+	struct isp1760_platform_data *priv = pdev->dev.platform_data;
>>+
>>+	/* basic sanity checks first.  board-specific init logic should
>>+	 * have initialized these two resources and probably board
>>+	 * specific platform_data.  we don't probe for IRQs, and do only
>>+	 * minimal sanity checking.
>>+	 */
>>+
>>+	if (usb_disabled())
>>+		return -ENODEV;
>>+
>>+	if (pdev->num_resources < 2)
>>+		return -ENODEV;
>>+
>>+	addr = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>+	irq = platform_get_irq(pdev, 0);
>>+
>>+	if (!addr || irq < 0)
>>+		return -ENODEV;
>>+
>>+	if (priv) {
>>+		if (priv->is_isp1761)
>>+			devflags |= ISP1760_FLAG_ISP1761;
>>+		if (priv->port1_disable)
>>+			devflags |= ISP1760_FLAG_PORT1_DIS;
>>+		if (priv->bus_width_16)
>>+			devflags |= ISP1760_FLAG_BUS_WIDTH_16;
>>+		if (priv->port1_otg)
>>+			devflags |= ISP1760_FLAG_OTG_EN;
>>+		if (priv->analog_oc)
>>+			devflags |= ISP1760_FLAG_ANALOG_OC;
>>+		if (priv->dack_polarity_high)
>>+			devflags |= ISP1760_FLAG_DACK_POL_HIGH;
>>+		if (priv->dreq_polarity_high)
>>+			devflags |= ISP1760_FLAG_DREQ_POL_HIGH;
>>+	}
>>+
>>+	hcd = isp1760_register(addr->start, resource_size(addr), irq,
>>+		IRQF_DISABLED | IRQF_SHARED | IRQF_TRIGGER_FALLING,
>This won't work. The chip itself is configured as level, active low.
You
>have to make sure the chip is configured as edge as well.

Well it somehow worked - I'll fix it.

>
>>+		&pdev->dev, dev_name(&pdev->dev),
>>+		devflags);
>>+
>>+	if (IS_ERR(hcd))
>>+		return PTR_ERR(hcd);
>>+
>>+	return 0;
>>+}
>>+
>>+static int __devexit
>>+isp1760_pdev_remove(struct platform_device *pdev)
>>+{
>>+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
>>+
>>+	platform_set_drvdata(pdev, NULL);
>>+
>>+	usb_remove_hcd(hcd);
>>+	iounmap(hcd->regs);
>>+	usb_put_hcd(hcd);
>>+	return 0;
>>+}
>>+
>>+/* this driver is exported so sl811_cs can depend on it */
>What are you telling me here?

Noting - I'll remove it

>
>>+struct platform_driver isp1760_pdev_driver = {
>>+	.probe =	isp1760_pdev_probe,
>>+	.remove =	__devexit_p(isp1760_pdev_remove),
>>+	.driver = {
>>+		.name =	"isp1760-hcd",
>>+		.owner = THIS_MODULE,
>>+	},
>>+};
>>+#endif /* USB_ISP1760_PDEV */
>>+
>> static int __init isp1760_init(void)
>> {
>> 	int ret = -ENODEV;
>>
>> 	init_kmem_once();
>>
>>+#ifdef USB_ISP1760_PDEV
>>+	ret = platform_driver_register(&isp1760_pdev_driver);
>>+	if (ret) {
>>+		deinit_kmem_cache();
>>+		return ret;
>>+	}
>>+#endif
>>+
>> #ifdef CONFIG_USB_ISP1760_OF
>> 	ret = of_register_platform_driver(&isp1760_of_driver);
>> 	if (ret) {
>>@@ -325,6 +420,9 @@ static void __exit isp1760_exit(void)
>> #ifdef CONFIG_USB_ISP1760_PCI
>> 	pci_unregister_driver(&isp1761_pci_driver);
>> #endif
>>+#ifdef USB_ISP1760_PDEV
>>+	platform_driver_unregister(&isp1760_pdev_driver);
>>+#endif
>> 	deinit_kmem_cache();
>> }
>> module_exit(isp1760_exit);
>>--
>>1.5.6.3
>
>Sebastian
