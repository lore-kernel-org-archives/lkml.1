Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYBZXvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYBZXvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYBZXus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:50:48 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbYBZXus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:50:48 -0500
Date: Tue, 26 Feb 2008 15:49:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] mm: fix blkdev size calculation in generic_write_checks
Message-Id: <20080226154948.29043b44.akpm@linux-foundation.org>
In-Reply-To: <20070815135228.GA10616@dnb.acronis.ru>
References: <20070815135228.GA10616@dnb.acronis.ru>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 17:52:28 +0400 Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> Currently block device size calculated regardless its
> bd_block_size. This may result attempt to write outside
> block device if i_size not aligned to bdev->bd_block_size
> and result in EIO.
> 
> #### TEST_CASE_BEGIN
> # fdisk -l /dev/sdc
> Disk /dev/sdc: 36.7 GB, 36703918080 bytes
> 255 heads, 63 sectors/track, 4462 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1   *           1         254     2040223+  83  Ldinux
> /dev/sdc2             255         379     1004062+  83  Linux
> ####
> #### /dev/sdc2 size not aligned to 4K
> 
> #### at this time bd_block_size == 512 so generic_write_check
> #### performed correctly
> # dd if=/dev/zero of=/dev/sdc2 bs=1k count=7 seek=1004058
> dd: writing `/dev/sdc2': No space left on device
> 5+0 records in
> 4+0 records out
> 
> #### this bdev contain ext4fs with blksize = 4K
> # mount /dev/sdc2 /mnt/
> #### after we mounted this bdev bd_block_size == fsblksize == 4K
> 
> #### the same write operation failed with EIO
> # dd if=/dev/zero of=/dev/sdc2 bs=1k count=7 seek=1004058
> dd: writing `/dev/sdc2': Input/output error
> 3+0 records in
> 2+0 records out
> #### Attempt to write whole fsblock result write access outside
> #### blkdevice and cause -EIO (returned by blkdev_get_block)
> #### TEST_CASE_END
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  mm/filemap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 2c8776b..a23ee8a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1867,9 +1867,11 @@ inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, i
>  	} else {
>  #ifdef CONFIG_BLOCK
>  		loff_t isize;
> +		unsigned int blksize;
>  		if (bdev_read_only(I_BDEV(inode)))
>  			return -EPERM;
> -		isize = i_size_read(inode);
> +		blksize = block_size(I_BDEV(inode));
> +		isize = i_size_read(inode) & ~(blksize - 1);
>  		if (*pos >= isize) {
>  			if (*count || *pos > isize)
>  				return -ENOSPC;

I'm trying to work out how the heck we fixed
http://bugzilla.kernel.org/show_bug.cgi?id=10116

We never merged your patch because it introduced problems.  But did we
merge some alternative fix, or does the bug remain in there?

