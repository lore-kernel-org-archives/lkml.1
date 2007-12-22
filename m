Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXLVWSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXLVWSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXLVWSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:18:25 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:39916 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbXLVWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:18:24 -0500
Message-ID: <fa686aa40712221418m601d3ffrd5b9158104712078@mail.gmail.com>
Date: Sat, 22 Dec 2007 15:18:23 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Steven Cavanagh" <steven.cavanagh@secretlab.ca>
Subject: Re: [PATCH] fat: Editions to support fat_fallocate()
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
In-Reply-To: <20071222210958.9351.35913.stgit@jpe-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222210958.9351.35913.stgit@jpe-laptop>
X-Google-Sender-Auth: 17694bee5d1ab3a6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Steve, comments below.

On 12/22/07, Steven Cavanagh <steven.cavanagh@secretlab.ca> wrote:
> From: Steven Cavanagh <steven.cavanagh@secretlab.ca>
>
> Added support for fallocate for a msdos fat driver. This allows
> preallocation of clusters to an inode before writes to reduce
> file fragmentation

Not technically true.  This doesn't make any guarantees about
fragmentation (even if in general it works pretty well).  To really
reduce fragmentation, then cluster allocation needs to be made smarter
so it goes looking for contiguous clusters when allocating, but that's
a task for a separate patch.  Please adjust your description.

Also, please briefly describe the testing that you've performed.

More comments below.

> Signed-off-by: Steven.Cavanagh <steven.cavanagh@secretlab.ca>
> ---
>
>  fs/fat/file.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 45 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 69a83b5..f753c6a 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -15,6 +15,7 @@ #include <linux/buffer_head.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
>  #include <linux/blkdev.h>
> +#include <linux/falloc.h>
>
>  int fat_generic_ioctl(struct inode *inode, struct file *filp,
>                       unsigned int cmd, unsigned long arg)
> @@ -312,8 +313,52 @@ int fat_getattr(struct vfsmount *mnt, st
>  }
>  EXPORT_SYMBOL_GPL(fat_getattr);
>
> +/*
> + * preallocate space for a file. This implements fat fallocate inode
> + * operation, which gets called from sys_fallocate system call. User
> + * space requests len bytes at offset.
> + */
> +long fat_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> +{
> +       int ret = 0;
> +       loff_t filesize = inode->i_size;
> +
> +       /* preallocation to directories is currently not supported */
> +       if (S_ISDIR(inode->i_mode)) {
> +               printk(KERN_ERR
> +               "fat_fallocate(): Directory prealloc not supported\n");

This printk is probably not needed, or at least make it a pr_debug()

> +               return -ENODEV;
> +       }
> +
> +       if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
> +               printk(KERN_INFO
> +                       "fat_fallocate():Blocks already allocated\n");

Drop the printk() here.  It will cause a write to the system log
everytime userspace does an unnecessary fat_fallocate().  That becomes
a performance hit which I don't think we want.

> +                       return 0;
> +       }
> +
> +       if ((offset + len) > MSDOS_I(inode)->mmu_private) {
> +
> +               mutex_lock(&inode->i_mutex);
> +               ret = fat_cont_expand(inode, (offset + len));
> +               if (ret) {
> +                       printk(KERN_ERR
> +                               "fat_fallocate():fat_cont_expand() error\n");
> +                       mutex_unlock(&inode->i_mutex);
> +                       return ret;
> +               }
> +               mutex_unlock(&inode->i_mutex);
> +       }
> +       if (mode & FALLOC_FL_KEEP_SIZE) {
> +               mutex_lock(&inode->i_mutex);
> +               i_size_write(inode, filesize);
> +               mutex_unlock(&inode->i_mutex);
> +       }

Race condition.  The file is increased in size and then returned to
the original size if FALLOC_FL_KEEP_SIZE is set, but the lock is
dropped then reobtained between increasing the size and restoring to
the original.  Another file operation can occur between the two
operations.  Badness!

However, digging further, when FALLOC_FL_KEEP_SIZE is set, I don't
think fat_cont_expand() has the behaviour that we want to implement.
When that flag is set, I think we simply want to add clusters
associated with the file to the FAT.  We don't want to clear them or
map them into the page cache yet (that should be done when the
filesize is increased for real).

I believe a call to fat_allocate_clusters() is all that is needed in
this case.  Hirofumi, please correct me if I'm wrong.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
