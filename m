Return-Path: <linux-kernel-owner+w=401wt.eu-S933975AbXF2Qpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbXF2Qpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756560AbXF2Qpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:45:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:41138 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXF2Qpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:45:33 -0400
Date: Fri, 29 Jun 2007 09:46:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: John Keller <jpk@sgi.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - SN: Correct ROM resource length for BIOS copy
Message-Id: <20070629094644.616c754a.randy.dunlap@oracle.com>
In-Reply-To: <20070629162058.24692.18526.sendpatchset@attica.americas.sgi.com>
References: <20070629162058.24692.18526.sendpatchset@attica.americas.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 11:20:58 -0500 John Keller wrote:

> On SN systems, when setting the IORESOURCE_ROM_BIOS_COPY resource flag,
> the resource length should be set to the actual size of the ROM image
> so that a call to pci_map_rom() returns the correct size.
> 
> Signed-off-by: John Keller <jpk@sgi.com>
> ---
> 
> To avoid duplicate code, the image size calculation loop in
> pci_map_rom() has been put into a separate function that both
> pci_map_rom() and the SN specific code now call.
> 
>  arch/ia64/sn/kernel/io_acpi_init.c |   17 ++----
>  arch/ia64/sn/kernel/io_init.c      |   20 ++++++-
>  drivers/pci/rom.c                  |   73 ++++++++++++++++-----------
>  include/linux/pci.h                |    1 
>  4 files changed, 70 insertions(+), 41 deletions(-)
> 
> 
> Index: linux-2.6/drivers/pci/rom.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/rom.c	2007-06-28 10:36:02.956505069 -0500
> +++ linux-2.6/drivers/pci/rom.c	2007-06-28 10:45:18.475626403 -0500
> @@ -54,6 +54,49 @@ static void pci_disable_rom(struct pci_d
>  }
>  
>  /**
> + * pci_get_rom_size - obtain the actual size of the ROM image
> + * @rom: kernel virtual pointer to image of ROM
> + *  size: size of PCI window

nit:  s/ size/@size/

> + *  return: size of actual ROM image
> + *
> + * Determine the actual length of the ROM image.
> + * The PCI window size could be much larger than the
> + * actual image size.
> + */
> +size_t pci_get_rom_size(void __iomem *rom, size_t size)
> +{
> +	void __iomem *image;
> +	int last_image;
> +
> +	image = rom;
> +	do {
> +		void __iomem *pds;
> +		/* Standard PCI ROMs start out with these bytes 55 AA */
> +		if (readb(image) != 0x55)
> +			break;
> +		if (readb(image + 1) != 0xAA)
> +			break;
> +		/* get the PCI data structure and check its signature */
> +		pds = image + readw(image + 24);
> +		if (readb(pds) != 'P')
> +			break;
> +		if (readb(pds + 1) != 'C')
> +			break;
> +		if (readb(pds + 2) != 'I')
> +			break;
> +		if (readb(pds + 3) != 'R')
> +			break;
> +		last_image = readb(pds + 21) & 0x80;
> +		/* this length is reliable */
> +		image += readw(pds + 16) * 512;
> +	} while (!last_image);
> +
> +	/* never return a size larger than the PCI resource window */
> +	/* there are known ROMs that get the size wrong */
> +	return min((size_t)(image - rom), size);
> +}
> +
> +/**
>   * pci_map_rom - map a PCI ROM to kernel space
>   * @pdev: pointer to pci device struct
>   * @size: pointer to receive size of pci window over ROM


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
