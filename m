Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYADWjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYADWjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYADWjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:39:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:8647 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbYADWje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vvCpyhpYBnnjEywegvzVX+AWGdGOkEqV0bW1AY2q+IedMJ5gPJ/B2tnw9r2REmwB3/nr5vgk7broSe9gdKdwJ7XEXwKP19l2dhQBLcvMyrKQhW1d5Gou7K8VeyZi6xE8KEUAe9ZbCwhCNr5x51QQeqRCCfGgQMiTmpBwom3nx90=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 02/10] ide-floppy: move ide-floppy struct and macro defs into its own header. While at it
Date: Fri, 4 Jan 2008 23:49:09 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-2-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801042349.09964.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Hmm, contrary to ide-cd.c case there doesn't seem to be a need currently for
moving code out of ide-floppy.c (and this patch series doesn't change that).

Besides it would be better to just remove some structs like it has been done
with i.e. struct atapi_capabilities_page in ide-cd.c case [1] because:

* it is easier to audit/debug the code if you don't have to look at typedefs
  all the time just to see which bytes/bits the code is really accessing

* not using typedefs will make the source code significantly smaller

* documentation is publically available

* these structs are not memory mapped

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg242747.html

On Thursday 03 January 2008, Borislav Petkov wrote:
> - do a white-space cleanup
> - remove old crufty code untouched since at least 2005

Please try to not mix things like moving code around and doing actual
changes because it makes patch review difficult (i.e. it took me quite a
while to find "old crufty code" that has been removed)...

Sometimes having more "trivial" patches is better...

> - shorten lines longer than 80ish columns
> - shorten some LAAARGE typenames.

typedefs are evil (exceptions are rare) and should die :)

> There should be no functional changes resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |  763 ++++++++++++----------------------------------
>  drivers/ide/ide-floppy.h |  382 +++++++++++++++++++++++
>  2 files changed, 581 insertions(+), 564 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 785fbde..52d09c1 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c

[...]

> -} idefloppy_capabilities_page_t;

[...]

> -} idefloppy_flexible_disk_page_t;

[...]

> -} idefloppy_capacity_descriptor_t;

as mentioned earlier it would be best to just remove these structs/typedefs

[ respective structures are described in SFF-8070i spec, it is useful to audit
  the final code against the spec to catch potential coding mistakes early ]

[...]

> -#if 0
> -/*
> - *	Special requests for our block device strategy routine.
> - */
> -#define	IDEFLOPPY_FIRST_RQ	90
> -
> -/*
> - * 	IDEFLOPPY_PC_RQ is used to queue a packet command in the request queue.
> - */
> -#define	IDEFLOPPY_PC_RQ		90
> -
> -#define IDEFLOPPY_LAST_RQ	90
> -
> -/*
> - *	A macro which can be used to check if a given request command
> - *	originated in the driver or in the buffer cache layer.
> - */
> -#define IDEFLOPPY_RQ_CMD(cmd) 	((cmd >= IDEFLOPPY_FIRST_RQ) && (cmd <= IDEFLOPPY_LAST_RQ))
> -
> -#endif

Well, it was already removed, the patch is in IDE tree (and thus in -mm).

http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/ide-mm-ide-floppy-remove-dead-code.patch

If possible please base your patches against IDE tree or the latest -mm patch.

[...]

> -} idefloppy_inquiry_result_t;

[...]

> -} idefloppy_request_sense_result_t;

[...]

> -} idefloppy_mode_parameter_header_t;

more structs/typedefs heading for /dev/null

[...]

> @@ -1689,9 +1304,12 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
>  	printk(KERN_INFO "Write buffer size(?): %d bytes\n",id->buf_size*512);
>  	printk(KERN_INFO "DMA: %s",id->capability & 0x01 ? "Yes\n":"No\n");
>  	printk(KERN_INFO "LBA: %s",id->capability & 0x02 ? "Yes\n":"No\n");
> -	printk(KERN_INFO "IORDY can be disabled: %s",id->capability & 0x04 ? "Yes\n":"No\n");
> -	printk(KERN_INFO "IORDY supported: %s",id->capability & 0x08 ? "Yes\n":"Unknown\n");
> -	printk(KERN_INFO "ATAPI overlap supported: %s",id->capability & 0x20 ? "Yes\n":"No\n");
> +	printk(KERN_INFO "IORDY can be disabled: %s",
> +			id->capability & 0x04 ? "Yes\n":"No\n");
> +	printk(KERN_INFO "IORDY supported: %s",
> +			id->capability & 0x08 ? "Yes\n":"Unknown\n");
> +	printk(KERN_INFO "ATAPI overlap supported: %s",
> +			id->capability & 0x20 ? "Yes\n":"No\n");
>  	printk(KERN_INFO "PIO Cycle Timing Category: %d\n",id->tPIO);
>  	printk(KERN_INFO "DMA Cycle Timing Category: %d\n",id->tDMA);
>  	printk(KERN_INFO "Single Word DMA supported modes:\n");
> @@ -1713,12 +1331,16 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
>  			sprintf(buffer, "Not supported");
>  		else
>  			sprintf(buffer, "%d ns",id->eide_dma_min);
> -		printk(KERN_INFO "Minimum Multi-word DMA cycle per word: %s\n", buffer);
> +		printk(KERN_INFO "Minimum Multi-word DMA cycle per word: %s\n",
> +				buffer);
> +
>  		if (id->eide_dma_time == 0)
>  			sprintf(buffer, "Not supported");
>  		else
>  			sprintf(buffer, "%d ns",id->eide_dma_time);
> -		printk(KERN_INFO "Manufacturer\'s Recommended Multi-word cycle: %s\n", buffer);
> +		printk(KERN_INFO "Manufacturer\'s Recommended Multi-word"
> +				" cycle: %s\n", buffer);
> +
>  		if (id->eide_pio == 0)
>  			sprintf(buffer, "Not supported");
>  		else
> @@ -1731,7 +1353,8 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
>  			sprintf(buffer, "%d ns",id->eide_pio_iordy);
>  		printk(KERN_INFO "Minimum PIO cycle with IORDY: %s\n", buffer);
>  	} else
> -		printk(KERN_INFO "According to the device, fields 64-70 are not valid.\n");
> +		printk(KERN_INFO "According to the device, fields 64-70 are not"
> +				" valid.\n");
>  #endif /* IDEFLOPPY_DEBUG_INFO */
>  
>  	if (gcw.protocol != 2)

identify dumping has been removed by:

http://kernel.org/pub/linux/kernel/people/bart/pata-2.6/patches/ide-floppy-tape-remove-debug-code-for-dumping-identify-data.patch

[ not in -mm yet ]

Please rework/resubmit this patch (preferably splitted on few smaller ones).

Thanks,
Bart

PS please also check your patches with scripts/checkpatch.pl before posting
