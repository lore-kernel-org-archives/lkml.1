Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZHFA7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZHFA7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbZHFA7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:59:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48453 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZHFA7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:59:19 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432R98dN179dN873fizz1202hzzz32i21ch6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNXK2B-03-1XK-01
Date: Thu, 6 Aug 2009 08:59:03 +0800
From: "Cai, Crane" <crane.cai@amd.com>
To: Jean Delvare <khali@linux-fr.org>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Add support for new AMD SMBus devices
Message-ID: <20090806005903.GA7026@crane-desktop>
Mail-Followup-To: "Cai, Crane" <crane.cai@amd.com>,
	Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090720073112.GA18219@crane-desktop> <20090805153814.70283b5a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090805153814.70283b5a@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 06 Aug 2009 00:59:05.0622 (UTC) FILETIME=[18A5FB60:01CA1631]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Wed, Aug 05, 2009 at 03:38:14PM +0200, Jean Delvare wrote:
> Hi Crane,
> 
> On Mon, 20 Jul 2009 15:31:12 +0800, Crane Cai wrote:
> > Use driver to detect SMBus devices with Vendor ID AMD and class code is SMBus.
> > 
> > Signed-off-by: Crane Cai <crane.cai@amd.com>
> > ---
> >  drivers/i2c/busses/i2c-piix4.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> > index 0249a7d..034f388 100644
> > --- a/drivers/i2c/busses/i2c-piix4.c
> > +++ b/drivers/i2c/busses/i2c-piix4.c
> > @@ -479,6 +479,10 @@ static struct pci_device_id piix4_ids[] = {
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP300_SMBUS) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP400_SMBUS) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS) },
> > +	/* AMD Generic, PCI class code and Vendor ID for SMBus */
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_ANY_ID),
> > +	  .class = PCI_CLASS_SERIAL_SMBUS << 8,
> > +	  .class_mask = 0xffffff },
> 
> Hmm, this seems a little too broad. In particular the AMD 8111 SMBus
> 2.0 device [1022:746a] would match, while we know it isn't compatible
> with the Intel PIIX4 (it has its own driver: i2c-amd8111).
> 
> As much as I would like not having to add PCI IDs to the driver with
> every new chipset released by AMD, this doesn't sound realistic in
> practice, I fear. I suspect you will have to list devices individually,
> just as we do for all other vendors.

Thank you for your useful comments. I think in serveral years SMBus controller
hardware core will not change its interface. That's why we try to avoid
frequently add device ID in driver. But we forget outdate chips you mentioned.
Here is the solution for it: As we know device ID number is increaseed by its
manufacture year, we can filter out outdate chips by the feature. If in future
hardware interface changed (almost zero in factor), we also can use this method
to filter new chips out. code clips as this:
	pci_dev->device > PCI_DEVICE_ID_AMD_8111_SMBUS2 && 
	pci_dev->device < PCI_DEVICE_ID_AMD_FEATURE_ONE

All this code clips will be in piix4_setup_sb800 branch, and if filtered out, it
return with NODEV. It will not affect your driver main function, and will not
avoid other driver's PCI probing.

Do you approve this solution? If you approve, I will resend a new patch for it.

-- 
Best Regards,
- Crane

