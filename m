Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYILMeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYILMeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 08:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYILMd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 08:33:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59626 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYILMd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 08:33:57 -0400
Date: Fri, 12 Sep 2008 06:33:40 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: PCI: Add ALI M5229 comaptibility mode quirk
Message-ID: <20080912123339.GA10844@parisc-linux.org>
References: <20080912112252.505651015@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912112252.505651015@fluff.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 12:22:52PM +0100, Ben Dooks wrote:
> The libata driver will not work with an M5229 set into native IDE
> mode (the old drivers/pci one does) if the M5229 does not provide
> it's own IRQ.
> 
> The M5229 implementation embedded into the ALI M1543 uses the
> M1543's ISA PIC to provide the interrupts and thus does not have
> an valid PCI IRQ set. This quirk detects the abscence of IRQ and
> sets the M5229 back into compatibility mode to use IRQs 14 and 15
> so that libata works correctly.
> 
> Note, I belive that the check for an valid interrupt line is
> correct, I only have an M5229 in an ALI M1543 to check this
> on. It would be useful to confirm that a M5229 with an valid IRQ
> does not trigger this quirk.

Why does this need to be a quirk rather than something in the libata ALi
driver?

> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Index: linux-2.6.27-rc6-cats1/drivers/pci/quirks.c
> ===================================================================
> --- linux-2.6.27-rc6-cats1.orig/drivers/pci/quirks.c	2008-09-11 11:26:35.000000000 +0100
> +++ linux-2.6.27-rc6-cats1/drivers/pci/quirks.c	2008-09-12 12:18:05.000000000 +0100
> @@ -905,6 +905,34 @@ static void __devinit quirk_svwks_csb5id
>  }
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_CSB5IDE, quirk_svwks_csb5ide);
>  
> +/* Some systems set the ALI M5229 in the ALI M1543 bridge to native mode,
> + * which cannot be supported by the pata_ali.c driver (the old drivers/ide
> + * makes a compatibility effort to change the IDE interrupts).
> + */
> +static void __devinit quirk_ali_ide_compatibility(struct pci_dev *pdev)
> +{
> +	u8 tmp;
> +
> +	/* pdev->irq and pdev->pin have yet to be initialised, so check
> +	 * by reading from the configuration header to see if we've got
> +	 * a valid interrupt line. */
> +
> +	pci_read_config_byte(pdev, PCI_INTERRUPT_LINE, &tmp);
> +	if (tmp != 0xff)
> +		return;
> +
> +	pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp);
> +	if (tmp & 0x5) {
> +		dev_info(&pdev->dev, "quirk: changing to IDE compatibility mode\n");
> +
> +		tmp &= ~0x05;
> +		pdev->class &= ~0x05;
> +		pci_write_config_byte(pdev, PCI_CLASS_PROG, tmp);
> +	}
> +}
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M5229, quirk_ali_ide_compatibility);
> +
>  /*
>   *	Intel 82801CAM ICH3-M datasheet says IDE modes must be the same
>   */
> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
