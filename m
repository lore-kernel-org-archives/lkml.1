Return-Path: <linux-kernel-owner+w=401wt.eu-S1763695AbYALO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763695AbYALO1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763007AbYALO0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:26:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:50604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761482AbYALO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:26:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=APmELI+N9pvHXQ4uKSTzmG2FGeo/rziMTD47DdEJ8MdIAHwttHXd03V9PVSpvhtqBFA3LBtf/5bijxRVpsEUS3PSEm0fjogTccJ2Udr4s/NSUukQH9bzi8dfLXxmYzQWIYCj2TY8e4K6NJkc6CzBJlrzDQT+juItIjnXCCOVghs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 07/21] ide-floppy: remove struct idefloppy_capacity_descriptor
Date: Sat, 12 Jan 2008 01:59:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801120159.01194.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> We test here for updated capacity descriptors by checking whether the media
> has changed instead of memcmp-ing with a cached copy of the capacity
> descriptors.
> 
> Also:
> 
> - remove one of 2 consecutive if (!i)-tests.
> - start loop at 1 in idefloppy_get_format_capacities() since userspace doesn't
> need the current/maximum capacity descriptor. i.e the first one.
> - fix comments formatting
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |  132 +++++++++++++++++----------------------------
>  1 files changed, 50 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 679d48e..5c85833 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -119,29 +119,7 @@ typedef struct idefloppy_packet_command_s {
>  
>  #define	PC_SUPPRESS_ERROR		6	/* Suppress error reporting */
>  
> -/*
> - *	Format capacity
> - */
> -typedef struct {
> -	u8		reserved[3];
> -	u8		length;			/* Length of the following descriptors in bytes */
> -} idefloppy_capacity_header_t;

minor nitpick:
idefloppy_capacity_header_t removal wasn't mentioned in the patch description

[...]

> @@ -1229,17 +1205,16 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
>  }
>  
>  /*
> - *	Determine if a media is present in the floppy drive, and if so,
> - *	its LBA capacity.
> + * Determine if a media is present in the floppy drive, and if so, its LBA
> + * capacity.
>   */
> -static int idefloppy_get_capacity (ide_drive_t *drive)
> +static int idefloppy_get_capacity(ide_drive_t *drive)

Care to rename it to ide_floppy_get_capacity() while at it
(it has only two users)?

>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	idefloppy_pc_t pc;
> -	idefloppy_capacity_header_t *header;
> -	idefloppy_capacity_descriptor_t *descriptor;
> -	int i, descriptors, rc = 1, blocks, length;
> -	
> +	int i, desc_cnt, rc = 1, blocks, length;
> +	u8 header_len;

desc_cnt (== header_len / 8) can be u8 as well

>  	drive->bios_cyl = 0;
>  	drive->bios_head = drive->bios_sect = 0;
>  	floppy->blocks = 0;
> @@ -1251,17 +1226,17 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
>  		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
>  		return 1;
>  	}
> -	header = (idefloppy_capacity_header_t *) pc.buffer;
> -	descriptors = header->length / sizeof(idefloppy_capacity_descriptor_t);
> -	descriptor = (idefloppy_capacity_descriptor_t *) (header + 1);
> +	header_len = pc.buffer[3];
> +	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
>  
> -	for (i = 0; i < descriptors; i++, descriptor++) {
> -		blocks = descriptor->blocks = be32_to_cpu(descriptor->blocks);
> -		length = descriptor->length = be16_to_cpu(descriptor->length);
> +	for (i = 0; i < desc_cnt; i++) {
> +		unsigned int desc_start = 4 + i*8;

missing newline

> +		blocks = be32_to_cpu(*(u32 *)&pc.buffer[desc_start]);
> +		length = be16_to_cpu(*(u16 *)&pc.buffer[desc_start + 6]);

if the last debug_log() call in the loop will be moved here
  
> -		if (!i) 
> +		if (!i)
>  		{

the 'if (!i)' can be replaced with:

		if (i)
			continue;

> -		switch (descriptor->dc) {
> +		switch (pc.buffer[desc_start + 4] & 0x03) {
>  		/* Clik! drive returns this instead of CAPACITY_CURRENT */
>  		case CAPACITY_UNFORMATTED:
>  			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
> @@ -1272,11 +1247,11 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
>  				break;
>  		case CAPACITY_CURRENT:
>  			/* Normal Zip/LS-120 disks */
> -			if (memcmp(descriptor, &floppy->capacity, sizeof (idefloppy_capacity_descriptor_t)))
> +			if ((1UL << IDEFLOPPY_MEDIA_CHANGED) & floppy->flags)

Same issue as with similar change in patch #6:

[ Please note that idefloppy_get_capacity() is called from idefloppy_setup()
  and IDEFLOPPY_MEDIA_CHANGED flag is first set in idefloppy_open(). ]

IMO it is the best to leave floppy->capacity alone for now.

>  				printk(KERN_INFO "%s: %dkB, %d blocks, %d "
>  					"sector size\n", drive->name,
>  					blocks * length / 1024, blocks, length);
> -			floppy->capacity = *descriptor;
> +
>  			if (!length || length % 512) {
>  				printk(KERN_NOTICE "%s: %d bytes block size "
>  					"not supported\n", drive->name, length);
> @@ -1303,9 +1278,8 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
>  				"in drive\n", drive->name);
>  			break;
>  		}
> -		}
> -		if (!i) {
> -			debug_log("Descriptor 0 Code: %d\n", descriptor->dc);
> +		debug_log("Descriptor 0 Code: %d\n",
> +				pc.buffer[desc_start + 4] & 0x03);

minor CodingStyle nitpick:

		debug_log("Descriptor 0 Code: %d\n",
			  pc.buffer[desc_start + 4] & 0x03);

>  		}
>  		debug_log("Descriptor %d: %dkB, %d blocks, %d sector size\n",
>  				i, blocks * length / 1024, blocks, length);
> @@ -1321,35 +1295,32 @@ static int idefloppy_get_capacity (ide_drive_t *drive)
>  }
>  
>  /*
> -** Obtain the list of formattable capacities.
> -** Very similar to idefloppy_get_capacity, except that we push the capacity
> -** descriptors to userland, instead of our own structures.
> -**
> -** Userland gives us the following structure:
> -**
> -** struct idefloppy_format_capacities {
> -**        int nformats;
> -**        struct {
> -**                int nblocks;
> -**                int blocksize;
> -**                } formats[];
> -**        } ;
> -**
> -** userland initializes nformats to the number of allocated formats[]
> -** records.  On exit we set nformats to the number of records we've
> -** actually initialized.
> -**
> -*/
> + * Obtain the list of formattable capacities.
> + * Very similar to idefloppy_get_capacity, except that we push the capacity
> + * descriptors to userland, instead of our own structures.
> + *
> + * Userland gives us the following structure:
> + *
> + * struct idefloppy_format_capacities {
> + *        int nformats;
> + *        struct {
> + *                int nblocks;
> + *                int blocksize;
> + *                } formats[];
> + *        } ;

nitpicking taken to an extreme:
I would replace spaces with tabs while at it...

> + *
> + * userland initializes nformats to the number of allocated formats[]
> + * records.  On exit we set nformats to the number of records we've
> + * actually initialized.
> + *
> + */
>  
>  static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)

ide_floppy_get_format_capacities() (only one user)? :)

>  {
>          idefloppy_pc_t pc;

would be nice to fix this whitespace damage while at it

> -	idefloppy_capacity_header_t *header;
> -        idefloppy_capacity_descriptor_t *descriptor;
> -	int i, descriptors, blocks, length;
> -	int u_array_size;
> -	int u_index;
> +	int i, desc_cnt, blocks, length, u_array_size, u_index;
>  	int __user *argp;
> +	u8 header_len;

desc_cnt can be u8
 
>  	if (get_user(u_array_size, arg))
>  		return (-EFAULT);
> @@ -1362,28 +1333,25 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
>  		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
>                  return (-EIO);
>          }

Care to fix the above whitespace damage while at it?

[...]

Otherwise it looks good.  Please recast/resubmit.
