Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYG0EE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYG0EE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 00:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYG0EEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 00:04:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26712 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYG0EEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 00:04:44 -0400
Date: Sat, 26 Jul 2008 19:22:41 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] xsysace: make it 'struct hd_driveid'-free
Message-ID: <20080727012241.GF12191@secretlab.ca>
References: <200807232032.39073.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807232032.39073.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 08:32:38PM +0200, Bartlomiej Zolnierkiewicz wrote:
> * Change cf_id field in struct ace_device from 'struct hd_driveid *id'
>   to 'u16 *id' and update driver accordingly.
> 
> * Include <linux/ata.h> directly instead of through <linux/hdreg.h>.
> 
> While at it:
> 
> * Use ata_id_u32() macro.
> 
> There should be no functional changes caused by this patch.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Looks good to me.  I'll pick it up (with one small change.  I can now
simply inline the contents ace_fix_driveid().  I'll test this when I get
back to Calgary.

Thanks,
g.

> ---
> depends on 'ata: add missing ATA_ID_* defines (take 2)' patch
> posted earlier (http://lkml.org/lkml/2008/7/22/469)
> 
>  drivers/block/xsysace.c |   30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
> 
> Index: b/drivers/block/xsysace.c
> ===================================================================
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -89,6 +89,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> +#include <linux/ata.h>
>  #include <linux/hdreg.h>
>  #include <linux/platform_device.h>
>  #if defined(CONFIG_OF)
> @@ -208,7 +209,7 @@ struct ace_device {
>  	struct gendisk *gd;
>  
>  	/* Inserted CF card parameters */
> -	struct hd_driveid cf_id;
> +	u16 cf_id[ATA_ID_WORDS];
>  };
>  
>  static int ace_major;
> @@ -402,21 +403,14 @@ static void ace_dump_regs(struct ace_dev
>  		 ace_in32(ace, ACE_CFGLBA), ace_in(ace, ACE_FATSTAT));
>  }
>  
> -void ace_fix_driveid(struct hd_driveid *id)
> +void ace_fix_driveid(u16 *id)
>  {
>  #if defined(__BIG_ENDIAN)
> -	u16 *buf = (void *)id;
>  	int i;
>  
>  	/* All half words have wrong byte order; swap the bytes */
> -	for (i = 0; i < sizeof(struct hd_driveid); i += 2, buf++)
> -		*buf = le16_to_cpu(*buf);
> -
> -	/* Some of the data values are 32bit; swap the half words  */
> -	id->lba_capacity = ((id->lba_capacity >> 16) & 0x0000FFFF) |
> -	    ((id->lba_capacity << 16) & 0xFFFF0000);
> -	id->spg = ((id->spg >> 16) & 0x0000FFFF) |
> -	    ((id->spg << 16) & 0xFFFF0000);
> +	for (i = 0; i < ATA_ID_WORDS; i++, id++)
> +		*id = le16_to_cpu(*id);
>  #endif
>  }
>  
> @@ -592,7 +586,7 @@ static void ace_fsm_dostate(struct ace_d
>  		break;
>  
>  	case ACE_FSM_STATE_IDENTIFY_COMPLETE:
> -		ace_fix_driveid(&ace->cf_id);
> +		ace_fix_driveid(&ace->cf_id[0]);
>  		ace_dump_mem(&ace->cf_id, 512);	/* Debug: Dump out disk ID */
>  
>  		if (ace->data_result) {
> @@ -605,9 +599,10 @@ static void ace_fsm_dostate(struct ace_d
>  			ace->media_change = 0;
>  
>  			/* Record disk parameters */
> -			set_capacity(ace->gd, ace->cf_id.lba_capacity);
> +			set_capacity(ace->gd,
> +				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
>  			dev_info(ace->dev, "capacity: %i sectors\n",
> -				 ace->cf_id.lba_capacity);
> +				ata_id_u32(&ace->cf_id, ATA_ID_LBA_CAPACITY));
>  		}
>  
>  		/* We're done, drop to IDLE state and notify waiters */
> @@ -907,12 +902,13 @@ static int ace_release(struct inode *ino
>  static int ace_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  {
>  	struct ace_device *ace = bdev->bd_disk->private_data;
> +	u16 *cf_id = &ace->cf_id[0];
>  
>  	dev_dbg(ace->dev, "ace_getgeo()\n");
>  
> -	geo->heads = ace->cf_id.heads;
> -	geo->sectors = ace->cf_id.sectors;
> -	geo->cylinders = ace->cf_id.cyls;
> +	geo->heads	= cf_id[ATA_ID_HEADS];
> +	geo->sectors	= cf_id[ATA_ID_SECTORS];
> +	geo->cylinders	= cf_id[ATA_ID_CYLS];
>  
>  	return 0;
>  }
