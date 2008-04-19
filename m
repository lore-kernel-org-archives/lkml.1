Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYDSRST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYDSRST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYDSRSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 13:18:09 -0400
Received: from h155.mvista.com ([63.81.120.155]:23028 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754325AbYDSRSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 13:18:06 -0400
Message-ID: <480A2926.6050404@ru.mvista.com>
Date: Sat, 19 Apr 2008 21:17:26 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] siimage: add sil_* I/O ops
References: <200804092051.33163.bzolnier@gmail.com>
In-Reply-To: <200804092051.33163.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Add sil_iowrite{8,16,32}() and sil_ioread{8,16}() helpers, then use them to
> merge code accessing configuration registers through PCI and MMIO together.

   Sigh, my coding style cleanup patch heavily clashed with this one, so I had 
to recast it...

> [ because of this SATA initialization bits from setup_mmio_siimage() are
>   moved to init_chipset_siimage() ]

> This also cuts code size a bit:

>    text    data     bss     dec     hex filename
>    4437     164       0    4601    11f9 drivers/ide/pci/siimage.o.before
>    3979     164       0    4143    102f drivers/ide/pci/siimage.o.after

    Good work. :-)

> While at it:

> * Use I/O ops directly instead of using ->IN{B,W} and ->OUT{B,W}.

> * Fixup CodingStyle in setup_mmio_siimage().

> * Rename 'tmpbyte' variable to 'tmp' in init_chipset_siimage().

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/pci/siimage.c
> ===================================================================
> --- a/drivers/ide/pci/siimage.c
> +++ b/drivers/ide/pci/siimage.c
> @@ -2,7 +2,7 @@
>   * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
>   * Copyright (C) 2003		Red Hat <alan@redhat.com>
>   * Copyright (C) 2007		MontaVista Software, Inc.
> - * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
> + * Copyright (C) 2007-2008	Bartlomiej Zolnierkiewicz
>   *
>   *  May be copied or modified under the terms of the GNU General Public License
>   *
> @@ -124,6 +124,54 @@ static inline unsigned long siimage_seld
>  	return base;
>  }
>  
> +static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
> +{
> +	u8 tmp = 0;
> +
> +	if (pci_get_drvdata(dev))
> +		tmp = readb((void __iomem *)addr);
> +	else
> +		pci_read_config_byte(dev, addr, &tmp);
> +
> +	return tmp;
> +}
> +
> +static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
> +{
> +	u16 tmp = 0;
> +
> +	if (pci_get_drvdata(dev))
> +		tmp = readw((void __iomem *)addr);
> +	else
> +		pci_read_config_word(dev, addr, &tmp);
> +
> +	return tmp;
> +}
> +
> +static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
> +{
> +	if (pci_get_drvdata(dev))
> +		writeb(val, (void __iomem *)addr);
> +	else
> +		pci_write_config_byte(dev, addr, val);
> +}
> +
> +static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
> +{
> +	if (pci_get_drvdata(dev))
> +		writew(val, (void __iomem *)addr);
> +	else
> +		pci_write_config_word(dev, addr, val);
> +}
> +
> +static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
> +{
> +	if (pci_get_drvdata(dev))
> +		writel(val, (void __iomem *)addr);
> +	else
> +		pci_write_config_dword(dev, addr, val);
> +}
> +

    I think this could be further imporoved -- since we have to call 
pci_get_drvdata() in the accessors anyway, we could have used it to get the 
MMIO base right there, and thus be freed from the necessity to add it to the 
MMIO offset in the callers and also most probably from having it copied to 
hwif->hwif_data.

> @@ -203,36 +249,20 @@ static void sil_set_pio_mode(ide_drive_t
[...]
> +	mode |= (unit ? 0x10 : 0x01);

    Useless parens -- I'm getting rid of them in my patch anyway...

> @@ -557,50 +513,80 @@ static unsigned int setup_mmio_siimage (
[...]
> +	sil_iowrite8(dev,        0x72, base + 0xA1);
> +	sil_iowrite16(dev,     0x328A, base + 0xA2);
> +	sil_iowrite32(dev, 0x62DD62DD, base + 0xA4);
> +	sil_iowrite32(dev, 0x43924392, base + 0xA8);
> +	sil_iowrite32(dev, 0x40094009, base + 0xAC);
> +	sil_iowrite8(dev,        0x72, base ? (base + 0xE1) : 0xB1);
> +	sil_iowrite16(dev,     0x328A, base ? (base + 0xE2) : 0xB2);
> +	sil_iowrite32(dev, 0x62DD62DD, base ? (base + 0xE4) : 0xB4);
> +	sil_iowrite32(dev, 0x43924392, base ? (base + 0xE8) : 0xB8);
> +	sil_iowrite32(dev, 0x40094009, base ? (base + 0xEC) : 0xBC);
> +

    Sigh, I was going to send a patch getting rid of these writes altogether 
last year -- there should be no point in setting PIO/DMA/UDMA timings here.
Maybe I'll submit it...

MBR, Sergei
