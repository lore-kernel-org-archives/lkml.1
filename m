Return-Path: <linux-kernel-owner+w=401wt.eu-S934428AbZHENif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428AbZHENif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934378AbZHENie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:38:34 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55962 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934345AbZHENid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:38:33 -0400
Date: Wed, 5 Aug 2009 15:38:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Crane Cai <crane.cai@amd.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Add support for new AMD SMBus devices
Message-ID: <20090805153814.70283b5a@hyperion.delvare>
In-Reply-To: <20090720073112.GA18219@crane-desktop>
References: <20090720073112.GA18219@crane-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Crane,

On Mon, 20 Jul 2009 15:31:12 +0800, Crane Cai wrote:
> Use driver to detect SMBus devices with Vendor ID AMD and class code is SMBus.
> 
> Signed-off-by: Crane Cai <crane.cai@amd.com>
> ---
>  drivers/i2c/busses/i2c-piix4.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index 0249a7d..034f388 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -479,6 +479,10 @@ static struct pci_device_id piix4_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
> +	/* AMD Generic, PCI class code and Vendor ID for SMBus */
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_ANY_ID),
> +	  .class = PCI_CLASS_SERIAL_SMBUS << 8,
> +	  .class_mask = 0xffffff },

Hmm, this seems a little too broad. In particular the AMD 8111 SMBus
2.0 device [1022:746a] would match, while we know it isn't compatible
with the Intel PIIX4 (it has its own driver: i2c-amd8111).

As much as I would like not having to add PCI IDs to the driver with
every new chipset released by AMD, this doesn't sound realistic in
practice, I fear. I suspect you will have to list devices individually,
just as we do for all other vendors.

>  	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
>  		     PCI_DEVICE_ID_SERVERWORKS_OSB4) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_SERVERWORKS,
> @@ -499,9 +503,10 @@ static int __devinit piix4_probe(struct pci_dev *dev,
>  {
>  	int retval;
>  
> -	if ((dev->vendor == PCI_VENDOR_ID_ATI) &&
> +	if (((dev->vendor == PCI_VENDOR_ID_ATI) &&
>  	    (dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS) &&
> -	    (dev->revision >= 0x40))
> +	    (dev->revision >= 0x40)) ||
> +	    dev->vendor == PCI_VENDOR_ID_AMD)
>  		/* base address location etc changed in SB800 */
>  		retval = piix4_setup_sb800(dev, id);
>  	else


-- 
Jean Delvare
