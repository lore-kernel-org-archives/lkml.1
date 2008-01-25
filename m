Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYAYATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYAYATn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbYAYATf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:19:35 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:63412 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYAYATe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ML2w5BVVxRXbJ/juv2cPh6M9PoGrVOxjlk0CN7I7EIgLQuTH5yV8WYLYNOk4n4O0Oe3sCGIYrtXnlVUGExcFb4Y5eHeRy+YyNqOS8GbmvioF/xLylDiMY68pi3nEfW5QXh9zcLlbhXVEEGojiOaDyCkpan5exeRynMGQrK3xvrc=
Message-ID: <47992B0F.6000506@gmail.com>
Date: Fri, 25 Jan 2008 09:19:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Shane Huang <Shane.Huang@amd.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] PCI: modify SB700 SATA MSI quirk
References: <5CAB7B5D6F8AB84AA868A46B47A507055D8C1D@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF78E@sshaexmb1.amd.com> <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com>
In-Reply-To: <B90463BC30D2E446BA423D888DC85E501BF796@sshaexmb1.amd.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shane Huang wrote:
> SB700 SATA MSI bug will be fixed in SB700 revision A21 at hardware
> level,
> but the SB700 revision older than A21 will also be found in the market.
> This patch modify the original quirk commit
> bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.
> 
> 
> Signed-off-by: Shane Huang <shane.huang@amd.com>
> 
> 
> Since there is some word wrapping problem with my mail client MS
> outlook, I also attach the patch as an attachment. Please check it.

Can you please get a decent email client?  Thunderbird + toggle word
wrap + external editor combination works fine.

> diff -ruN old/drivers/pci/quirks.c new/drivers/pci/quirks.c
> --- old/drivers/pci/quirks.c	2008-01-07 05:45:38.000000000 +0800
> +++ new/drivers/pci/quirks.c	2008-01-22 11:31:09.000000000 +0800
> @@ -1709,6 +1709,22 @@
>  {
>  	dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
>  }
> +static void __devinit quirk_msi_intx_disable_ati_bug(struct pci_dev
> *dev)
> +{
> +	struct pci_dev *p;
> +	u8 rev = 0;
> +
> +	/* SB700 MSI issue will be fixed at HW level from revision A21,
> +	 * we need check PCI REVISION ID of SMBus controller to get
> SB700 revision.
> +	 */
> +	p = pci_get_device(PCI_VENDOR_ID_ATI,
> PCI_DEVICE_ID_ATI_SBX00_SMBUS, NULL);

It would be nice if things stay under 80col limit although we don't
follow that too well in quirks.c.

> +	if (p!=NULL) {

We usually write 'if (p)' and don't use unless necessary.

> +		pci_read_config_byte(p, PCI_CLASS_REVISION, &rev);
> +	}
> +	if ((rev < 0x3B) && (rev >= 0x30)) {
> +		dev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
> +	}
> +}
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM,
>  			PCI_DEVICE_ID_TIGON3_5780,
>  			quirk_msi_intx_disable_bug);
> @@ -1729,17 +1745,17 @@
>  			quirk_msi_intx_disable_bug);
>  
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4390,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4391,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4392,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4393,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4394,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4395,
> -			quirk_msi_intx_disable_bug);
> +			quirk_msi_intx_disable_ati_bug);

-- 
tejun
