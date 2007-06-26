Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbXFZStY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbXFZStY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXFZStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:49:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:41389 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757224AbXFZStM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:49:12 -0400
Message-ID: <46816011.70000@ru.mvista.com>
Date: Tue, 26 Jun 2007 22:50:57 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] sis5513: backport short cables support from pata_sis.c
References: <200706101558.33636.bzolnier@gmail.com>
In-Reply-To: <200706101558.33636.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Backport short cables support from pata_sis.c.

> This patch should allow UDMA > 2 modes on ASUS A6K.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/pci/sis5513.c
> ===================================================================
> --- a/drivers/ide/pci/sis5513.c
> +++ b/drivers/ide/pci/sis5513.c
[...]
> @@ -796,10 +796,33 @@ static unsigned int __devinit init_chips
>  	return 0;
>  }
>  
> +struct sis_laptop {
> +	u16 device;
> +	u16 subvendor;
> +	u16 subdevice;
> +};
> +
> +static const struct sis_laptop sis_laptop[] = {
> +	/* devid, subvendor, subdev */
> +	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
> +	/* end marker */
> +	{ 0, }
> +};
> +
>  static u8 __devinit ata66_sis5513(ide_hwif_t *hwif)
>  {
> +	struct pci_dev *pdev = hwif->pci_dev;
> +	const struct sis_laptop *lap = &sis_laptop[0];
>  	u8 ata66 = 0;
>  
> +	while (lap->device) {
> +		if (lap->device == pdev->device &&
> +		    lap->subvendor == pdev->subsystem_vendor &&
> +		    lap->subdevice == pdev->subsystem_device)
> +			return ATA_CBL_PATA40_SHORT;
> +		lap++;
> +	}
> +

   The code even starts looking generic enough to be put into helper...

>  	if (chipset_family >= ATA_133) {
>  		u16 regw = 0;
>  		u16 reg_addr = hwif->channel ? 0x52: 0x50;

MBR, Sergei
