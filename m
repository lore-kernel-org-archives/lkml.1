Return-Path: <linux-kernel-owner+w=401wt.eu-S1763259AbZD3NnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763259AbZD3NnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZD3NnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:43:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40207 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753656AbZD3NnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:43:11 -0400
Date: Thu, 30 Apr 2009 14:44:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Li, Jiebing" <jiebing.li@intel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Subject: Re: [PATCH 1/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Message-ID: <20090430144409.54800b18@lxorguk.ukuu.org.uk>
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE029D298B1FC@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
	<95608CFE3D0C064B8468DB61F8403BE029D298B1FC@PDSMSX501.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       ptemp = (u16 *)data_buf;
> +
> +       memcpy(info->serialnum, ptemp + 10, 20);
> +       info->serialnum[20] = 0;
> +       memcpy(info->fw_ver, ptemp + 23, 8);
> +       info->fw_ver[8] = 0;
> +       memcpy(info->model_num, ptemp + 27, 40);
> +       info->model_num[40] = 0;
> +
> +       info->major = ptemp[80];
> +       info->max_lba[0] = data_buf[50];    /* units are 512-byte sectors */
> +       info->max_lba[1] = data_buf[51];

What happens here on a big endian system ?


> +int ceata_flush_cache(struct mmc_card *card)
> +{
>
> +       ret = ceata_cmd60(card, 1, cmd_buf, reg_addr, CEATA_TASKFILE_BYTELEN);
> +       if (ret)
> +               printk(KERN_ERR "%s: Error issuing CE-ATA flush cache "
> +                               "command\n", mmc_hostname(card->host));

FLUSH_CACHE_EXT in standard ATA returns an error and the number of the
failed sector on error. That means it has to be retried to continue
flushing the rest of the cache after a bad block - is CE-ATA defined
differently here - otherwise this seems insufficient ?


> +#ifndef CONFIG_MRST_MMC_WR

Really any board/chipset specific handling needs to be done with flags on
the mmc_host not by ifdefs - otherwise you can't build a fairly generic
kernel any more.

> +       /*
> +        * first BAR is fixed to 0 by Moorestown architecture
> +        */
> +       if (pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD0 ||
> +               pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD1) {
> +               first_bar = 0;

and at this point you could set a workaround flag and propogate it into
the relevant mmc_host


> +/*
> + * CE-ATA register fields
> + */
> +#define CEATA_STATUS_BSY               (1<<7)  /* Busy */
> +#define CEATA_STATUS_DRDY              (1<<6)  /* Device Ready */
> +#define CEATA_STATUS_DRQ               (1<<3)  /* Data Request */
> +#define CEATA_STATUS_ERR               (1<<0)  /* Error */
> +
> +#define CEATA_ERROR_ICRC               (1<<7)  /* Interface CRC error (w) */
> +#define CEATA_ERROR_UNC                (1<<6)  /* Uncorrectable data error (r) */
> +#define CEATA_ERROR_IDNF               (1<<4)  /* ID (sector) not found */
> +#define CEATA_ERROR_ABRT               (1<<2)  /* Aborted Command */
> +
> +#define CEATA_CONTROL_SRST             (1<<2)  /* ATA software reset */
> +#define CEATA_CONTROL_NIEN             (1<<1)  /* Neg cmd comp int enable */

These bits are defined in ata.h and used by the various ATA layers (and
old IDE driver) - could you re-use them or not ?

> +#define CEATA_CMD_IDENTIFY_DEV         0xec    /* data in */
> +#define CEATA_CMD_READ_DMA_EXT         0x25    /* data in */
> +#define CEATA_CMD_WRITE_DMA_EXT                0x35    /* data out */
> +#define CEATA_CMD_STANDBY_IMME         0xe0    /* No data */
> +#define CEATA_CMD_FLUSH_CACHE_EXT      0xea    /* No data */

Ditto


On the more general question of "should CE-ATA use libata for the ATA
work" I'd agree with this current approach. It seems unlikely CE-ATA
devices are going to grow into full-stack ATA devices in a hurry and the
CE-ATA mode within mmc as done here is therefore much smaller and neater.
