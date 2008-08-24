Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbYHXIUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbYHXIUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYHXIUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:20:08 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:6716 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYHXIUA (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fci9k4bdxBrNrzODj67oSOksnMpZAcCB944iMFJ4quPr7qpeN+8b+QFjcenKZuJ7P3
         OLb/oOW9gBoLdenVBvbp0kqQZkAPTSzRg9A11PtDgE31kOpqufVkPnbvgXuqwURooGH2
         whn1l4Q0+IhEGfamv9hrop8jaTrJ3VT7Jmht4=
Message-ID: <28c262360808240119x44aaa728tc55d2148d14ac3c2@mail.gmail.com>
Date: Sun, 24 Aug 2008 17:19:58 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: jaredeh@gmail.com
Subject: Re: [PATCH 07/10] AXFS: axfs_bdev.c
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <48AD010B.6030209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD010B.6030209@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 2:45 PM, Jared Hulbert <jaredeh@gmail.com> wrote:
> All the block device code goes here.
>
> Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
> ---
> diff --git a/fs/axfs/axfs_bdev.c b/fs/axfs/axfs_bdev.c
> new file mode 100644
> index 0000000..4c6f83c
> --- /dev/null
> +++ b/fs/axfs/axfs_bdev.c
> @@ -0,0 +1,158 @@
> +/*
> + * Advanced XIP File System for Linux - AXFS
> + *   Readonly, compressed, and XIP filesystem for Linux systems big and small
> + *
> + * Copyright(c) 2008 Numonyx
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * Authors:
> + *  Jared Hulbert <jaredeh@gmail.com>
> + *
> + * Project url: http://axfs.sourceforge.net
> + *
> + * axfs_bdev.c -
> + *   Allows axfs to use block devices or has dummy functions if block
> + *   device support is compiled out of the kernel.
> + *
> + */
> +
> +#include <linux/axfs.h>
> +#include <linux/mount.h>
> +#ifdef CONFIG_BLOCK
> +#include <linux/buffer_head.h>
> +#include <linux/namei.h>
> +
> +int axfs_fill_super(struct super_block *sb, void *data, int silent);
> +
> +int axfs_get_sb_bdev(struct file_system_type *fs_type, int flags,
> +                    const char *dev_name, struct axfs_super *sbi,
> +                    struct vfsmount *mnt, int *err)
> +{
> +       *err = get_sb_bdev(fs_type, flags, dev_name, sbi, axfs_fill_super, mnt);
> +
> +       if (*err)
> +               return FALSE;
> +       return TRUE;
> +}
> +
> +void axfs_kill_block_super(struct super_block *sb)
> +{
> +       kill_block_super(sb);
> +}
> +
> +/******************************************************************************
> + *
> + * axfs_copy_block_data
> + *
> + * Description: Helper function to read data from block device
> + *
> + * Parameters:
> + *    (IN) sb - pointer to super block structure.
> + *
> + *    (IN) dst_addr - pointer to buffer into which data is to be read.
> + *
> + *    (IN) boffset - offset within block device
> + *
> + *    (IN) len - length of data to be read
> + *
> + * Returns:
> + *     0 or error number
> + *
> + *****************************************************************************/
> +int axfs_copy_block(struct super_block *sb, void *dst_addr, u64 fsoffset,
> +                   u64 len)
> +{
> +       struct axfs_super *sbi = AXFS_SB(sb);
> +       u64 boffset = AXFS_FSOFFSET_2_DEVOFFSET(sbi, fsoffset);
> +       u64 blocks;
> +       u64 blksize = sb->s_blocksize;
> +       unsigned long dst;
> +       unsigned long src;
> +       sector_t block;
> +       size_t bytes;
> +       struct buffer_head *bh;
> +       u64 copied = 0;
> +
> +       if (len == 0)
> +               return 0;
> +
> +       blocks = len / blksize;
> +       if ((len % blksize) > 0)
> +               blocks += 1;

blocks ??
You have to drop blocks variable since anyone don't use it.

> +       while (copied < len) {
> +               /* Explicit casting for ARM linker errors. */
> +               block = (sector_t) boffset + (sector_t) copied;
> +               block /= (sector_t) blksize;
> +               bh = sb_bread(sb, block);
> +               src = (unsigned long)bh->b_data;
> +               dst = (unsigned long)dst_addr;
> +               if (copied == 0) {
> +                       /* Explicit casting for ARM linker errors. */
> +                       bytes = (size_t) blksize;
> +                       bytes -= (size_t) boffset % (size_t) blksize;
> +                       if (bytes > len)
> +                               bytes = len;
> +                       /* Explicit casting for ARM linker errors. */
> +                       src += (unsigned long)boffset % (unsigned long)blksize;
> +               } else {
> +                       dst += copied;
> +                       if ((len - copied) < blksize) {
> +                               bytes = len - copied;
> +                       } else {
> +                               bytes = blksize;
> +                       }
> +               }
> +               memcpy((void *)dst, (void *)src, bytes);
> +               copied += bytes;
> +               brelse(bh);
> +       }
> +       return 0;
> +}
> +
> +int axfs_is_dev_bdev(char *path)
> +{
> +       struct nameidata nd;
> +       int ret = FALSE;
> +
> +       if (!path)
> +               return FALSE;
> +
> +       if (path_lookup(path, LOOKUP_FOLLOW, &nd))
> +               return FALSE;
> +
> +       if (S_ISBLK(nd.path.dentry->d_inode->i_mode))
> +               ret = TRUE;
> +
> +       path_put(&nd.path);
> +       return ret;
> +}
> +
> +#else
> +
> +int axfs_get_sb_bdev(struct file_system_type *fs_type, int flags,
> +                    const char *dev_name, struct axfs_super *sbi,
> +                    struct vfsmount *mnt, int *err)
> +{
> +       return FALSE;
> +}
> +
> +void axfs_kill_block_super(struct super_block *sb)
> +{
> +}
> +
> +int axfs_copy_block(struct super_block *sb, void *dst_addr, u64 fsoffset,
> +                   u64 len)
> +{
> +       return -EINVAL;
> +}
> +
> +int axfs_is_dev_bdev(char *path)
> +{
> +       return FALSE;
> +}
> +
> +#endif /* CONFIG_BLOCK */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-embedded" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Kinds regards,
MinChan Kim
