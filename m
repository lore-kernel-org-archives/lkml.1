Return-Path: <linux-kernel-owner+w=401wt.eu-S933127AbYCABD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbYCABD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYCABDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:03:47 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYCABDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:03:46 -0500
Date: Fri, 29 Feb 2008 17:02:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Seidel <fseidel@suse.de>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH] fs/partitions/msdos: directly check if FAT boot
 sector
Message-Id: <20080229170246.67391f7b.akpm@linux-foundation.org>
In-Reply-To: <47C6A9C1.8000008@suse.de>
References: <47C6A9C1.8000008@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 13:32:01 +0100
Frank Seidel <fseidel@suse.de> wrote:

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

fs/partitions/msdos.c: In function 'msdos_partition':
fs/partitions/msdos.c:446: warning: comparison is always true due to limited range of data type

didn't you get this?

The reason is that FAT_VALID_MEDIA() is bogus:

#define FAT_VALID_MEDIA(x)      ((0xF8 <= (x) && (x) <= 0xFF) || (x) == 0xF0)

It appears that the on-disk field which FAT_VALID_MEDIA() is designed to
test is only 8-bit, so the comparison with 0xff is pointless.  The only
existing caller of FAT_VALID_MEDIA() cheats by copying the value into a
local unsigned int first.

So I'll leave things as they are for now, but I'd ask that someone can
confirm that we should simply remove the 0xff test from FAT_VALID_MEDIA()?

