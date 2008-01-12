Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbYALO1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbYALO1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762906AbYALO0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:26:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:50633 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760227AbYALO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:26:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Qx7/ztS1fiLwethl2g7sKpd6a1BXvVX0rQbyQ2x17iJzoCmxfVnbnyvaL1q5r2KdS7IkZ9+QrNI6DcPL5AdafHYDfAdrqPgSpBcjbd9Xw/0IKYof7LQLrEQ08mQaI27Dqxme/79BYxhnb9oKhsdW1pyAHjm7RokljYHG/JgaSlE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 06/21] ide-floppy: remove struct idefloppy_flexible_disk_page
Date: Sat, 12 Jan 2008 01:58:57 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801120158.57895.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 11 January 2008, Borislav Petkov wrote:
> The driver used to test whether the flexible disk page has changed by memcmp-ing
> it with a cached copy of a previous version of the page from a different remo-
> vable medium. Since, according to the SFF-8070i spec, the flexible disk page
> "specifies parameters relating to the currently installed medium type," this
> comparison is now done by simply checking whether the medium has changed.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |   89 ++++++++++++++++-----------------------------
>  1 files changed, 32 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 2b9885f..679d48e 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c

[...]

> @@ -1188,50 +1159,54 @@ static int idefloppy_queue_pc_tail (ide_drive_t *drive,idefloppy_pc_t *pc)
>  }
>  
>  /*
> - *	Look at the flexible disk page parameters. We will ignore the CHS
> - *	capacity parameters and use the LBA parameters instead.
> + * Look at the flexible disk page parameters. We will ignore the CHS capacity
> + * parameters and use the LBA parameters instead.
>   */
> -static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
> +static int idefloppy_get_flexible_disk_page(ide_drive_t *drive)

Care to rename it to ide_floppy_get_flexible_disk_page() while at it
(it has only one user)?

>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	idefloppy_pc_t pc;
> -	idefloppy_mode_parameter_header_t *header;
> -	idefloppy_flexible_disk_page_t *page;
>  	int capacity, lba_capacity;
> +	u8 heads, sectors;
> +	u16 transfer_rate, sector_size, cyls, rpm;

some CodingStyle nitpicks (not really that important, rather personal taste):

	u16 transfer_rate, sector_size, cyls, rpm;
	u8 heads, sectors;

> -	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE, MODE_SENSE_CURRENT);
> -	if (idefloppy_queue_pc_tail(drive,&pc)) {
> -		printk(KERN_ERR "ide-floppy: Can't get flexible disk "
> -			"page parameters\n");
> +	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
> +			MODE_SENSE_CURRENT);

	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
					MODE_SENSE_CURRENT);

> +	if (idefloppy_queue_pc_tail(drive, &pc)) {
> +		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
> +				" parameters\n");
>  		return 1;
>  	}
> -	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
> -	floppy->wp = header->wp;
> +	floppy->wp = pc.buffer[3] & 0x80;

This is not an equivalent transformation:

header->wp is 0 or 1
pc.buffer[3] & 0x80 is 0 or 0x80

It seems to work fine for ->wp (because it is needlessly defined as 'int')
but may seriously confuse set_disk_ro() and thus bdev_read_only() users.

Should be fixed to '(pc.buffer[3] & 0x80) ? 1 : 0' (or something similar).

>  	set_disk_ro(floppy->disk, floppy->wp);
> -	page = (idefloppy_flexible_disk_page_t *) (header + 1);
> -
> -	page->transfer_rate = be16_to_cpu(page->transfer_rate);
> -	page->sector_size = be16_to_cpu(page->sector_size);
> -	page->cyls = be16_to_cpu(page->cyls);
> -	page->rpm = be16_to_cpu(page->rpm);
> -	capacity = page->cyls * page->heads * page->sectors * page->sector_size;
> -	if (memcmp (page, &floppy->flexible_disk_page, sizeof (idefloppy_flexible_disk_page_t)))
> +
> +	transfer_rate = be16_to_cpu(*(u16 *)&pc.buffer[8 + 2]);
> +	sector_size   = be16_to_cpu(*(u16 *)&pc.buffer[8 + 6]);
> +	cyls          = be16_to_cpu(*(u16 *)&pc.buffer[8 + 8]);
> +	rpm           = be16_to_cpu(*(u16 *)&pc.buffer[8 + 28]);
> +	heads         = pc.buffer[8 + 4];
> +	sectors       = pc.buffer[8 + 5];
> +
> +	capacity = cyls * heads * sectors * sector_size;
> +
> +	if ((1UL << IDEFLOPPY_MEDIA_CHANGED) & floppy->flags)

IDEFLOPPY_MEDIA_CHANGED is set when block device is opened for the first
time (please check idefloppy_open() for details) so I don't think it is
the right change.  'Flexible Disk Page' is only 32 bytes so we are better
off with leaving 'u8 flexible_disk_page[32]' in idefloppy_floppy_t and
doing things the old way.

Besides please do not intermix real changes like the above one with purely
cleanup ones like idefloppy_flexible_disk_page_t removal.  This is bad from
maintainability point of view.  If some patch causes problems it is easier
to narrow it down by heaving purely cleanup changes separated out + if we
would need to revert the real change we would have to make a separate patch
doing it instead of just reverting the guilty commit (given that we don't
want cleanup changes to be reverted as well).

>  		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
>  				"%d sector size, %d rpm\n",
> -			drive->name, capacity / 1024, page->cyls,
> -			page->heads, page->sectors,
> -			page->transfer_rate / 8, page->sector_size, page->rpm);
> -
> -	floppy->flexible_disk_page = *page;
> -	drive->bios_cyl = page->cyls;
> -	drive->bios_head = page->heads;
> -	drive->bios_sect = page->sectors;
> +			drive->name, capacity / 1024, cyls, heads, sectors,
> +			transfer_rate / 8, sector_size, rpm);

more CodingStyle nitpicks:

		printk(KERN_INFO "%s: %dkB, %d/%d/%d CHS, %d kBps, "
				 "%d sector size, %d rpm\n",
				 drive->name, capacity / 1024, cyls, heads, sectors,
				 transfer_rate / 8, sector_size, rpm);

would be more readable IMO

> +	drive->bios_cyl = cyls;
> +	drive->bios_head = heads;
> +	drive->bios_sect = sectors;

extra newline would distinguish the above block from the code below

>  	lba_capacity = floppy->blocks * floppy->block_size;
> +
>  	if (capacity < lba_capacity) {
>  		printk(KERN_NOTICE "%s: The disk reports a capacity of %d "
>  			"bytes, but the drive only handles %d\n",
>  			drive->name, lba_capacity, capacity);
> -		floppy->blocks = floppy->block_size ? capacity / floppy->block_size : 0;
> +		floppy->blocks = floppy->block_size ?
> +			capacity / floppy->block_size : 0;
>  	}
>  	return 0;
>  }

Otherwise looks fine, please recast and resubmit.
