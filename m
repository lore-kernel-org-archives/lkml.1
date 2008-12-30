Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbYL3Qap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbYL3Qap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYL3Qad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:30:33 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:21082 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbYL3Qac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:30:32 -0500
Message-ID: <495A4CC0.6000000@ru.mvista.com>
Date: Tue, 30 Dec 2008 19:30:56 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kirr@landau.phys.spbu.ru, Dmitry Gryazin <gdu@mns.spb.ru>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru>
In-Reply-To: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kirill Smelkov wrote:

> From: Dmitry Gryazin <gdu@mns.spb.ru>

> We need to keep our kernel working on both legacy and modern hardware.

> As it turned out, some boards don't have proper IDE DMA support for
> CompactFlash (CF) adaptors, because pin connectors which relate to DMA are left
> unsoldered (*).

> To verify this we even bought external IDE CF adaptor which showed the same
> symthoms, and then manually soldered pins that were left dangling, and voila,
> DMA started to work!

> Again, as they say, lots of manufacturers of not-so-new hardware did CF
> soldering by the wrong way with respect to DMA, so we need a workaround.

> For this __ide_dma_bad_drive function is enhance to check not only drives
> blacklist but motherboards blacklist too.

> Please apply before 2.6.29

> (*) On IEI PCISA-C3/EDEN the kernel boots _very_ slowly, becuase we have lots
> of DMA timer expiry:

>     <~30s pause>
>     hdc: dma_timer_epiry: dma_status == 0x21
>     hdc: DMA timeout error
>     ...
>     hdc: DMA disabled
>     ide1: dma reset
> 
>     <and the whole story repeats:>
>     <~30s pause>
>     hdc: dma_timer_epiry: dma_status == 0x21
>     ...

    Are you aware of ide_core.nodma= option which allows disabling DMA per 
interface/drive? Read Documentation/ide/ide.txt please. I should note that 
nodma option has been there for ages in one or other form.

> Also see this posts from 2006 where they say this is usually a problem with CF
> adapter not fully soldered:

> http://lkml.org/lkml/2006/5/23/198
> http://lkml.org/lkml/2006/6/20/164

> Signed-off-by: Dmitry Gryazin <gdu@mns.spb.ru>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>

    NAK.

> diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
> index fffd117..adb5d9d 100644
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -33,6 +33,21 @@
>  #include <linux/ide.h>
>  #include <linux/scatterlist.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/dmi.h>
> +
> +/* Internal structure for blacklisted boards */
> +struct board_blacklist_entry {
> +	const char *board_vendor;
> +	const char *board_name;
> +	const char *drive_name;
> +};
> +
> +/* Blacklisted boards which have problems with DMA */
> +static const struct board_blacklist_entry board_blacklist[] = {
> +	/* on IEI PCISA-C3 CF adapter pin connectors for DMA are missing */
> +	{ "FIC"		,	"PT-2200"	,	"hdc"	},
> +	{ NULL		,	NULL		,	NULL	}
> +};
>  
>  static const struct drive_list_entry drive_whitelist[] = {
>  	{ "Micropolis 2112A"	,       NULL		},
> @@ -207,6 +222,30 @@ void ide_dma_on(ide_drive_t *drive)
>  	drive->hwif->dma_ops->dma_host_set(drive, 1);
>  }
>  
> +static int __ide_dma_bad_adaptor(ide_drive_t *drive)
> +{
> +	const struct board_blacklist_entry *table = board_blacklist;
> +
> +	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
> +	const char *board_name   = dmi_get_system_info(DMI_BOARD_NAME);
> +
> +	if (!board_vendor || !board_name)
> +		return 0;
> +
> +	for ( ; table->board_name ; table++)
> +		if ((!strcmp(board_vendor, table->board_vendor)) &&
> +		    (!strcmp(board_name,   table->board_name))   &&
> +		    (!strcmp(drive->name,  table->drive_name))) {
> +			printk(KERN_WARNING "%s: Disabling (U)DMA for %s "
> +				"(Board %s %s is blacklisted)\n", drive->name,
> +				(char *)&drive->id[ATA_ID_PROD], board_vendor,
> +				board_name);
> +			return 1;
> +		}
> +
> +	return 0;
> +}
> +

    This code doesn't anyhow discriminate the case of on-board CF and say 
normal IDE PCI card plugged into such board -- with latter having no issues 
with DMA whatsoever. E.g. AMD Geode GX2 dev. board (DB2301) has CF slot (with 
unsoldered DMA pins, IIRC) and 3 PCI slots where you can plug a normal IDE card.

MBR, Sergei
