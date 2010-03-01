Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0CAWNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:13:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab0CAWNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:13:40 -0500
Date: Mon, 1 Mar 2010 14:13:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH] msdos: add support for large disks
Message-Id: <20100301141335.395dc4c3.akpm@linux-foundation.org>
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 19:17:47 -0800
"Daniel Taylor" <Daniel.Taylor@wdc.com> wrote:

> In order to use disks larger than 2TiB on Windows XP, it is necessary to use
> 4096-byte logical sectors in an MBR.
> 
> Although the kernel storage and functions called from msdos.c used
> "sector_t" internally, msdos.c still used u32 variables, which results in
> the ability to handle XP-compatible large disks.
> 
> This patch changes the internal variables to "sector_t".
> 

Please Cc OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> and myself on
this work.

The patch was really badly wordwrapped.  Please fix up your email
client for next time.

> ---
> diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
> index 0028d2e..fa9c77d 100644
> --- a/fs/partitions/msdos.c
> +++ b/fs/partitions/msdos.c
> @@ -104,12 +104,12 @@ static int aix_magic_present(unsigned char *p, struct
> block_device *bdev)
>  
>  static void
>  parse_extended(struct parsed_partitions *state, struct block_device *bdev,
> -			u32 first_sector, u32 first_size)
> +			sector_t first_sector, sector_t first_size)
>  {
>  	struct partition *p;
>  	Sector sect;
>  	unsigned char *data;
> -	u32 this_sector, this_size;
> +	sector_t this_sector, this_size;
>  	int sector_size = bdev_logical_block_size(bdev) / 512;
>  	int loopct = 0;		/* number of links followed
>  				   without finding a data partition */
> @@ -145,15 +145,16 @@ parse_extended(struct parsed_partitions *state, struct
> block_device *bdev,
>  		 * First process the data partition(s)
>  		 */
>  		for (i=0; i<4; i++, p++) {
> -			u32 offs, size, next;
> +			sector_t offs, size, next;
>  			if (!NR_SECTS(p) || is_extended_partition(p))
>  				continue;
>  
>  			/* Check the 3rd and 4th entries -
>  			   these sometimes contain random garbage */
> -			offs = START_SECT(p)*sector_size;
> -			size = NR_SECTS(p)*sector_size;
> +			offs =
> (sector_t)(START_SECT(p))*(sector_t)(sector_size);
> +			size =
> (sector_t)(NR_SECTS(p))*(sector_t)(sector_size);

The patch would be cleaner if START_SECT() and NR_SECTS() were
returning the correct type.  I suggest converting these to regular C
functions, renaming them to start_sect() and nr_sects() (or something
more descriptive if you like) and making them return a sector_t.

Making local variable `sector_size' have type sector_t would eliminate
the other typecast and is a logical enough thing to do, I think.

>  			next = this_sector + offs;
> +
>  			if (i >= 2) {
>  				if (offs + size > this_size)
>  					continue;
>
> ...
>
> @@ -263,14 +264,14 @@ parse_bsd(struct parsed_partitions *state, struct
> block_device *bdev,
>  	if (le16_to_cpu(l->d_npartitions) < max_partitions)
>  		max_partitions = le16_to_cpu(l->d_npartitions);
>  	for (p = l->d_partitions; p - l->d_partitions < max_partitions; p++)
> {
> -		u32 bsd_start, bsd_size;
> +		sector_t bsd_start, bsd_size;
>  
>  		if (state->next == state->limit)
>  			break;
>  		if (p->p_fstype == BSD_FS_UNUSED) 
>  			continue;
> -		bsd_start = le32_to_cpu(p->p_offset);
> -		bsd_size = le32_to_cpu(p->p_size);
> +		bsd_start = (sector_t)(le32_to_cpu(p->p_offset));
> +		bsd_size = (sector_t)(le32_to_cpu(p->p_size));

I don't see why these two casts are needed?  The compiler will take
care of assigning a u32 to a sector_t.  Perhaps this applies to other
places in the patch.

>  		if (offset == bsd_start && size == bsd_size)
>  			/* full parent partition, we have it already */
>  			continue;
>
> ...
>
> @@ -483,8 +484,8 @@ int msdos_partition(struct parsed_partitions *state,
> struct block_device *bdev)
>  
>  	state->next = 5;
>  	for (slot = 1 ; slot <= 4 ; slot++, p++) {
> -		u32 start = START_SECT(p)*sector_size;
> -		u32 size = NR_SECTS(p)*sector_size;
> +		sector_t start =
> (sector_t)(START_SECT(p))*(sector_t)(sector_size);
> +		sector_t size =
> (sector_t)(NR_SECTS(p))*(sector_t)(sector_size);
>  		if (!size)
>  			continue;
>  		if (is_extended_partition(p)) {
> @@ -521,8 +522,8 @@ int msdos_partition(struct parsed_partitions *state,
> struct block_device *bdev)
>  
>  		if (!subtypes[n].parse)
>  			continue;
> -		subtypes[n].parse(state, bdev, START_SECT(p)*sector_size,
> -						NR_SECTS(p)*sector_size,
> slot);
> +		subtypes[n].parse(state, bdev,
> (sector_t)(START_SECT(p))*(sector_t)(sector_size),
> +
> (sector_t)(NR_SECTS(p))*(sector_t)(sector_size), slot);
>  	}
>  	put_dev_sector(sect);
>  	return 1;

Again, we can avoid some/all of this casting by more appropriate
selection of types.
