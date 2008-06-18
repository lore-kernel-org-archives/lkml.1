Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYFRVeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYFRVeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYFRVeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:34:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:35115 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbYFRVeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=U6rsa4eAak90rawPwla3XqmJXxSX+nPG6NMf6RkX9V+uh9Nzf1531jhRHE5UbYj9PA
         m48N8t+CyYcZqKHkKpQgxDu0SG7oVfNy61WL2cuZRnvO/RLjrcaRnHxs3cO2b9XGHYu9
         CuNNr/PhEm11JZg0jMoafphsvPomYq/171ZIg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [patch 27/28] PNP: avoid legacy IDE IRQs
Date: Wed, 18 Jun 2008 23:34:06 +0200
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Jiri Slaby <jirislaby@gmail.com>, Jeff Garzik <jgarzik@pobox.com>
References: <20080617225823.045233728@ldl.fc.hp.com> <20080617225913.281681169@ldl.fc.hp.com>
In-Reply-To: <20080617225913.281681169@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806182334.07049.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 18 June 2008, Bjorn Helgaas wrote:
> If an IDE controller is in compatibility mode, it expects to use
> IRQs 14 and 15, so PNP should avoid them.
> 
> This patch should resolve this problem report:
>   parallel driver grabs IRQ14 preventing legacy SFF ATA controller from working
>   https://bugzilla.novell.com/show_bug.cgi?id=375836
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Index: work14/drivers/pnp/resource.c
> ===================================================================
> --- work14.orig/drivers/pnp/resource.c	2008-06-17 15:52:36.000000000 -0600
> +++ work14/drivers/pnp/resource.c	2008-06-17 16:14:18.000000000 -0600
> @@ -17,6 +17,7 @@
>  #include <linux/pci.h>
>  #include <linux/ioport.h>
>  #include <linux/init.h>
> +#include <linux/libata.h>

this include is for libata only AFAIK

[ I added Jeff to cc: ]

>  #include <linux/pnp.h>
>  #include "base.h"
> @@ -286,6 +287,61 @@ static irqreturn_t pnp_test_handler(int 
>  	return IRQ_HANDLED;
>  }
>  
> +#ifdef CONFIG_PCI
> +static int pci_dev_uses_irq(struct pnp_dev *pnp, struct pci_dev *pci,
> +			    unsigned int irq)
> +{
> +	u32 class;
> +	u8 progif;
> +
> +	if (pci->irq == irq) {
> +		dev_dbg(&pnp->dev, "device %s using irq %d\n",
> +			pci_name(pci), irq);
> +		return 1;
> +	}
> +
> +	/*
> +	 * See pci_setup_device() and ata_pci_sff_activate_host() for
> +	 * similar IDE legacy detection.
> +	 */
> +	pci_read_config_dword(pci, PCI_CLASS_REVISION, &class);
> +	class >>= 8;		/* discard revision ID */
> +	progif = class & 0xff;
> +	class >>= 8;
> +
> +	if (class == PCI_CLASS_STORAGE_IDE) {
> +		/*
> +		 * Unless both channels are native-PCI mode only,
> +		 * treat the compatibility IRQs as busy.
> +		 */
> +		if ((progif & 0x5) != 0x5)
> +			if (ATA_PRIMARY_IRQ(pci) == irq ||
> +			    ATA_SECONDARY_IRQ(pci) == irq) {

ATA_*_IRQ are libata specific (+ it looks like they should be removed),
please use pci_get_legacy_ide_irq(dev, channel) instead.

Thanks,
Bart
