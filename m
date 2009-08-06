Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZHFPmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZHFPmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZHFPmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:42:05 -0400
Received: from emulex.emulex.com ([138.239.112.1]:47186 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbZHFPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:42:03 -0400
From: Chetan.Loke@Emulex.Com
To: <hancockrwd@gmail.com>, <tony@linx.net>
CC: <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <philipl@overt.org>
Date: Thu, 6 Aug 2009 08:41:30 -0700
Subject: RE: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
 sata_nv
Thread-Topic: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
 sata_nv
Thread-Index: AcoWJTld4mQJ3xBpRQqkOx/u5f/oQAAhiO+A
Message-ID: <412A05BA40734D4887DBC67661F433080D73228B@EXMAIL.ad.emulex.com>
References: <20090805192055.8F2DE1007C@gold.linx.net>
 <4A7A16C9.6030500@gmail.com>
In-Reply-To: <4A7A16C9.6030500@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2009 15:41:32.0630 (UTC) FILETIME=[5F863F60:01CA16AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n76FgQ7T030223

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Robert Hancock
> Sent: Wednesday, August 05, 2009 7:33 PM
> To: Tony Vroon
> Cc: Jeff Garzik; linux-ide@vger.kernel.org; LKML; Philip Langdale
> Subject: Re: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
> sata_nv
> 
> On 08/05/2009 01:20 PM, Tony Vroon wrote:
> > The nVidia MCP55 SATA2 controller quite happily supports MSI.
> > This adds an option to use it. It is disabled by default and
> > will only be honoured on the specific controller I tested.
> > This was suggested in 2007 back when the driver was less mature,
> > perhaps now is a better time for it.
> 
> I'm not sure the conditional on MCP55 is necessary, I would be inclined
> to just try to enable it on any device if the option is specified.
> pci_enable_msi will just fail harmlessly if the device doesn't support
> MSI capability or the kernel detects MSI is not usable on the machine
> (which these days I think we should be able to do fairly accurately on
> HT chipsets..)
> 

disable_msi() is missing right?


> >
> > Signed-off-by: Tony Vroon<tony@linx.net>
> >
> > diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
> > index b2d11f3..5ec29c4 100644
> > --- a/drivers/ata/sata_nv.c
> > +++ b/drivers/ata/sata_nv.c
> > @@ -602,6 +602,7 @@ MODULE_VERSION(DRV_VERSION);
> >
> >   static int adma_enabled;
> >   static int swncq_enabled = 1;
> > +static int msi_enabled;
> >
> >   static void nv_adma_register_mode(struct ata_port *ap)
> >   {
> > @@ -2459,6 +2460,13 @@ static int nv_init_one(struct pci_dev *pdev,
> const struct pci_device_id *ent)
> >   	} else if (type == SWNCQ)
> >   		nv_swncq_host_init(host);
> >
> > +	/* enable MSI if requested */
> > +	if (pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2&&
> > +		msi_enabled) {
> > +		dev_printk(KERN_NOTICE,&pdev->dev, "Using MSI\n");
> > +		pci_enable_msi(pdev);
> > +	}
> > +
> >   	pci_set_master(pdev);
> >   	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
> >   				 IRQF_SHARED, ipriv->sht);

..
msi_rc = pci_enable_msi(pdev);
...
ata_rc = ata_host_activate(host, pdev->irq, ipriv->irq_handler,
   				 IRQF_SHARED, ipriv->sht);
if (ata_rc && msi_enabled && !msi_rc)
	pci_disable_msi(pdev);

return ata_rc;



Chetan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
