Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYB2CQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYB2CQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYB2CQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:16:43 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:53442 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYB2CQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:16:42 -0500
Date: Thu, 28 Feb 2008 18:16:37 -0800
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] fs/partitions/msdos: directly check if FAT boot	sector
In-reply-to: <47C6A9C1.8000008@suse.de>
To: Frank Seidel <fseidel@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <20080229021637.GF3176@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <47C6A9C1.8000008@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 28, 2008  13:32 +0100, Frank Seidel wrote:
> i received a complaint that some FAT formated medias
> (e.g. sd memory cards) trigger a "unknown partition table" message even though
> there is no partition table and they work correctly, while in general
> (when e.g. formated with mkdosfs or even Windows Vista) this message is not
> shown.
> Currently this seems only to happen when the medias get formatted with
> Windows XP (and possibly Win 2000). Then the boot indicator byte contains
> garbage (part of text message) and so do the other parts checked by
> msdos_paritition which then later triggers this message.
> 
> Would the patch below be appropriate to solve this issue/calm those users?
> It works ok here for the medias i could test.

There is also a similar complaint from users who format ext3 directly on
a disk/LUN without a partition table, because the partition table offset
negatively impacts the performance of the filesystem (causing unaligned
IO on a RAID device).  Turning off this message is very good.

> ---
> From: Frank Seidel <fseidel@suse.de>
> Subject: detect fat media without partition table correctly
> References: novell bug #364365
> 
> Most fat formatted media without partition table contains
> zeros in the boot indication and the other tested bytes
> and so falls through the checks in msdos_partition, leading
> it to return with 1 (all is fine).
> But some (e.g. WinXP formatted) fat fomated medias don't
> use boot_ind and so the check fails and causes a
> "unkown partition table" warning eventhough there is none
> and everything would be fine.
> This additional check directly verifies if there is a
> fat formatted medium without a partition table.
> 
> Signed-off-by: Frank Seidel <fseidel@suse.de>
> ---
>  fs/partitions/msdos.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> --- a/fs/partitions/msdos.c
> +++ b/fs/partitions/msdos.c
> @@ -18,7 +18,7 @@
>   *
>   *  Re-organised Feb 1998 Russell King
>   */
> -
> +#include <linux/msdos_fs.h>
>  
>  #include "check.h"
>  #include "msdos.h"
> @@ -419,6 +419,7 @@ int msdos_partition(struct parsed_partit
>  	Sector sect;
>  	unsigned char *data;
>  	struct partition *p;
> +	struct fat_boot_sector *fb;
>  	int slot;
>  
>  	data = read_dev_sector(bdev, 0, &sect);
> @@ -441,6 +442,12 @@ int msdos_partition(struct parsed_partit
>  	 * partition table. Reject this in case the boot indicator
>  	 * is not 0 or 0x80.
>  	 */
> +	fb = (struct fat_boot_sector *) data;
> +	if (fb->reserved && fb->fats && FAT_VALID_MEDIA(fb->media)) {
> +		printk("\n");
> +		put_dev_sector(sect);
> +		return 1;
> +	}
>  	p = (struct partition *) (data + 0x1be);
>  	for (slot = 1; slot <= 4; slot++, p++) {
>  		if (p->boot_ind != 0 && p->boot_ind != 0x80) {
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

