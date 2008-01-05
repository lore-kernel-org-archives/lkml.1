Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYAEPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYAEPB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 10:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYAEPBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 10:01:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:10558 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYAEPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 10:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=M7d1vKuSUWuucXXkbHYxijYdZLGysjDSm78R/bw/+LMxTLpcuyAgwqvD446qjsT7PFxNLrzxBqDtoplN2zuS37lb/E8KA9w+D/cI1pQZyp/T+N6nIs7zhsjm1kQ4lj8eASdyWcyMHuMhphJreV1VVknB+d72X3dwmnALZriN300=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 05/10] ide-floppy: factor out ioctl handlers from idefloppy_ioctl()
Date: Sat, 5 Jan 2008 16:12:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-5-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-6-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801051612.19425.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


looks good, some minor issues noted below

On Thursday 03 January 2008, Borislav Petkov wrote:
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |   90 +++++++++++++++++++++++++++++-----------------
>  1 files changed, 57 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 196a697..7823447 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -1600,6 +1600,58 @@ static int idefloppy_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>  	return 0;
>  }
>  
> +static int idefloppy_lockdoor(struct inode *inode, idefloppy_pc_t *pc,
> +		int event, unsigned int cmd)
> +{
> +	struct block_device *bdev = inode->i_bdev;

if 'drive' is passed as an argument, 'inode' and 'bdev' can be removed
('floppy' can be obtained from drive->driver_data)

> +	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
> +	ide_drive_t *drive = floppy->drive;
> +
> +	if (floppy->openers > 1)
> +		return -EBUSY;
> +
> +	/* The IOMEGA Clik! Drive doesn't support this command -
> +	 * no room for an eject mechanism */
> +	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
> +		idefloppy_create_prevent_cmd(pc, event);
> +		(void) idefloppy_queue_pc_tail(drive, pc);
> +	}
> +
> +	if (cmd == CDROMEJECT) {
> +		idefloppy_create_start_stop_cmd(pc, 2);
> +		(void) idefloppy_queue_pc_tail(drive, pc);
> +	}
> +
> +	return 0;
> +}
> +
> +static
> +int idefloppy_format_start(struct file *file, struct inode *inode,
> +		void __user *argp)
> +{
> +	struct block_device *bdev = inode->i_bdev;
> +	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
> +	ide_drive_t *drive = floppy->drive;
> +	int err;
> +
> +	if (!(file->f_mode & 2))
> +		return -EPERM;

if this check is left in idefloppy_ioctl() it is enough to pass 'drive'
and 'argp' to idefloppy_format_start()

> +	if (floppy->openers > 1) {
> +		/* Don't format if someone is using the disk */
> +		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
> +		return -EBUSY;
> +	}
> +
> +	set_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
> +
> +	err = idefloppy_begin_format(drive, argp);

idefloppy_begin_format() is called only by idefloppy_format_start() so it
would make sense to just merge the latter function into the former one

> +	if (err)
> +		clear_bit(IDEFLOPPY_FORMAT_IN_PROGRESS, &floppy->flags);
> +
> +	return err;
> +}
> +
>  static int idefloppy_ioctl(struct inode *inode, struct file *file,
>  			unsigned int cmd, unsigned long arg)
>  {
> @@ -1612,47 +1664,19 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
>  	idefloppy_pc_t pc;
>  
>  	switch (cmd) {
> +

stray newline, no need for it

>  	case CDROMEJECT:
>  		prevent = 0;

by adding:

	if (cmd == CDROMEJECT)
		prevent = 0;

to idefloppy_lockdoor() it is possible to remove the above line
(together with 'prevent' variable)

>  		/* fall through */
> -	case CDROM_LOCKDOOR:
> -		if (floppy->openers > 1)
> -			return -EBUSY;
>  
> -		/* The IOMEGA Clik! Drive doesn't support this command -
> -		 * no room for an eject mechanism */
> -                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
> -			idefloppy_create_prevent_cmd(&pc, prevent);
> -			(void) idefloppy_queue_pc_tail(drive, &pc);
> -		}
> -		if (cmd == CDROMEJECT) {
> -			idefloppy_create_start_stop_cmd(&pc, 2);
> -			(void) idefloppy_queue_pc_tail(drive, &pc);
> -		}
> -		return 0;
> +	case CDROM_LOCKDOOR:
> +		return idefloppy_lockdoor(inode, &pc, prevent, cmd);

[...]

> @@ -1669,7 +1693,7 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
>  	 */
>  	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
>  		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
> -					bdev->bd_disk, cmd, argp);
> +				bdev->bd_disk, cmd, argp);
>  	else
>  		err = -ENOTTY;
>  

this chunk doesn't seem to be needed
