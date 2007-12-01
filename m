Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbXLAXQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbXLAXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXLAXQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:16:15 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:64513 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXLAXQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:16:13 -0500
Date: Sat, 1 Dec 2007 15:14:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, Nick Warne <nick@ukfsn.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Peculiar out-of-sync boot log lines
Message-Id: <20071201151419.39a169f1.randy.dunlap@oracle.com>
In-Reply-To: <200712012259.35152.bzolnier@gmail.com>
References: <20071129193728.2f1c237e@linuxamd.linicks.net>
	<474F1D24.4070009@rtr.ca>
	<200712012259.35152.bzolnier@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 22:59:35 +0100 Bartlomiej Zolnierkiewicz wrote:

> Thanks for reporting/debugging it guys!
> 
> > Something in there needs to insert a '\n' before the "skipping word" message.
> > Since it doesn't do that right now, the KERN_DEBUG string appears as "<7>"
> 
> This seems like a good occasion to fix ide_dma_verbose() for good so... :)
> 
> [ patch is against current Linus tree so might not apply to 2.6.23.9 ]
> 
> [PATCH] ide: DMA reporting and validity checking fixes
> 
> * ide_xfer_verbose() fixups:
>   - beautify returned mode names
>   - fix PIO5 reporting
>   - make it return 'const char *'
> 
> * Change printk() level from KERN_DEBUG to KERN_INFO in ide_find_dma_mode().
> 
> * Add ide_id_dma_bug() helper based on ide_dma_verbose() to check for invalid
>   DMA info in identify block.
> 
> * Use ide_id_dma_bug() in ide_tune_dma() and ide_driveid_update().
> 
>   As a result DMA won't be tuned or will be disabled after tuning if device
>   reports inconsistent info about enabled DMA mode (ide_dma_verbose() does the
>   same checks while the IDE device is probed by ide-{cd,disk} device driver).
> 
> * Since (id->capability & 1) && id->tDMA is a valid configuration handle
>   it correctly in ide_id_dma_bug().
> 
> * Remove no longer needed ide_dma_verbose().
> 
> This patch should fix the following problem with out-of-sync IDE messages
> reported by Nick Warned:
> 
>        hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd:
>        skipping word 93 validity check
>         , UDMA(66)
> 
> and later debugged by Mark Lord to be caused by:
> 
>         ide_dma_verbose()
>                 printk( ... "2048kB Cache");
>         eighty_ninty_three()
>                 printk(KERN_DEBUG "%s: skipping word 93 validity check\n");
>         ide_dma_verbose()
>                 printk(", UDMA(66)"
> 
> Please note that as a result ide-{cd,disk} device drivers won't report the
> DMA speed used but this is intended since now DMA mode being used is always
> reported by IDE core code.
> 
> Cc: Nick Warne <nick@ukfsn.org>
> Cc: Mark Lord <lkml@rtr.ca>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-cd.c   |    7 ------
>  drivers/ide/ide-disk.c |    5 ----
>  drivers/ide/ide-dma.c  |   57 ++++++++++++-------------------------------------
>  drivers/ide/ide-iops.c |    3 ++
>  drivers/ide/ide-lib.c  |   55 ++++++++++++++++++++++++-----------------------
>  include/linux/ide.h    |    6 ++---
>  6 files changed, 51 insertions(+), 82 deletions(-)
> 
> Index: b/drivers/ide/ide-cd.c
> ===================================================================
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -3049,12 +3049,7 @@ int ide_cdrom_probe_capabilities (ide_dr
>          else 	
>          	printk(" drive");
>  
> -	printk(", %dkB Cache", be16_to_cpu(cap.buffer_size));
> -
> -	if (drive->using_dma)
> -		ide_dma_verbose(drive);
> -
> -	printk("\n");
> +	printk(", %dkB Cache\n", be16_to_cpu(cap.buffer_size));

Use
	printk(KERN_CONT ...
so that someone won't try to add another KERN_* facility level to it.
(same for other continued printk calls in this patch)

>  
>  	return nslots;
>  }
> Index: b/drivers/ide/ide-disk.c
> ===================================================================
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -961,11 +961,8 @@ static void idedisk_setup (ide_drive_t *
>  	if (id->buf_size)
>  		printk (" w/%dKiB Cache", id->buf_size/2);
>  
> -	printk(", CHS=%d/%d/%d", 
> +	printk(", CHS=%d/%d/%d\n",

Ditto.

>  	       drive->bios_cyl, drive->bios_head, drive->bios_sect);
> -	if (drive->using_dma)
> -		ide_dma_verbose(drive);
> -	printk("\n");
>  
>  	/* write cache enabled? */
>  	if ((id->csfo & 1) || (id->cfs_enable_1 & (1 << 5)))

> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h

> @@ -1333,8 +1334,7 @@ static inline void ide_set_hwifdata (ide
>  	hwif->hwif_data = data;
>  }
>  
> -/* ide-lib.c */
> -extern char *ide_xfer_verbose(u8 xfer_rate);
> +const char *ide_xfer_verbose(u8);
>  extern void ide_toggle_bounce(ide_drive_t *drive, int on);
>  extern int ide_set_xfer_rate(ide_drive_t *drive, u8 rate);

Ideally function prototypes would include variable names, not just
types, as a helpful hint to readers of them.

---
~Randy
The Linux kernel requires that any needed documentation accompany all
changes requiring said documentation -- part of the source-code patch
must apply to the Documentation/ directory. [...]
To sum up: No undocumented changes.
-- Donnie Berkholz engages in some wishful thinking
<http://lwn.net/Articles/259470/> Quote of the Week
