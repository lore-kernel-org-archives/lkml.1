Return-Path: <linux-kernel-owner+w=401wt.eu-S1759990AbXLNUNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990AbXLNUNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXLNUMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:12:54 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:34548 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbXLNUMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:12:53 -0500
Message-ID: <fa686aa40712141212r3d043711jf8e37bb2ba84079@mail.gmail.com>
Date: Fri, 14 Dec 2007 13:12:52 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Steven Cavanagh" <steven.cavanagh@secretlab.ca>
Subject: Re: [PATCH] fat: Editions to support fat_fallocate()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20071214193017.7545.88989.stgit@jpe-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071214193017.7545.88989.stgit@jpe-laptop>
X-Google-Sender-Auth: 0186fed115b7cb1e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Steve; I've cc'd LKML and Hirofumi in my reply.

Cheers,
g.

On 12/14/07, Steven Cavanagh <steven.cavanagh@secretlab.ca> wrote:
> From: Steven Cavanagh <steven.cavanagh@secretlab.ca>
>
> Added support for fallocate for a msdos fat driver. This allows
> preallocation of clusters to an inode before writes to reduce
> file fragmentation
>
> Signed-off-by: Steven.Cavanagh <steven.cavanagh@secretlab.ca>
> ---
>
>  fs/fat/cache.c |    9 +++++++++
>  fs/fat/file.c  |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/fat/inode.c |   15 +++++++++++++++
>  3 files changed, 71 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fat/cache.c b/fs/fat/cache.c
> index 639b3b4..1a69ce4 100644
> --- a/fs/fat/cache.c
> +++ b/fs/fat/cache.c

Drop your changes to this file; they are just pr_debug statements that
don't need to be in mainline.

<snip>

> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 69a83b5..de3f9ee 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -6,6 +6,8 @@
>   *  regular file handling primitives for fat-based filesystems
>   */
>
> +#undef DEBUG
> +

Drop these 2 lines

>  #include <linux/capability.h>
>  #include <linux/module.h>
>  #include <linux/time.h>
> @@ -15,6 +17,7 @@ #include <linux/buffer_head.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
>  #include <linux/blkdev.h>
> +#include <linux/falloc.h>
>
>  int fat_generic_ioctl(struct inode *inode, struct file *filp,
>                       unsigned int cmd, unsigned long arg)
> @@ -312,8 +315,52 @@ int fat_getattr(struct vfsmount *mnt, st
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
> +               return -ENODEV;
> +       }
> +
> +       if ((offset + len) <= filesize) {
> +               printk(KERN_ERR
> +                       "fat_fallocate():Blocks already allocated\n");
> +                       return -EIO;
> +       }

Drop the printk... in fact, dorp the error code too and just return 0.
 It's not an IO error if the space has already been allocated.

In fact, this test is probably irrelevant.  Since we're allocating
clusters and not necessarily increasing the file size, you should
instead test to see if the requested region already has clusters
allocated.

> +       if (offset > filesize) {
> +                       printk(KERN_ERR
> +                       "fat_fallocate():Offset error\n");
> +                       return -EIO;
> +       }

I though we agreed that we *want* to support this case.  ie. if the
caller specifies an offset beyond the length of the file, then
allocate clusters to cover both the requested region and the 'gap'.

> +
> +       if ((offset + len) > filesize) {

Again, you don't want to test against the filesize; you want to test
against the number of allocated sectors.

> +               pr_debug("fat_fallocate():fat_cont_expand(): size: %llu\n",
> +                               (offset+len));
> +               ret = fat_cont_expand(inode, (offset + len));
> +       }

What if fat_cont_expand fails?  You'll end up increasing the filesize
regardless.

> +       if (mode & FALLOC_FL_KEEP_SIZE) {
> +               mutex_lock(&inode->i_mutex);

The lock/unlock needs to also protect fat_cont_expand.

> +               i_size_write(inode, filesize);
> +               mutex_unlock(&inode->i_mutex);
> +               pr_debug(
> +               "fat_fallocate():FALLOC_FL_KEEP_SIZE: %llu\n", filesize);
> +       }
> +       return ret;
> +}
> +
>  const struct inode_operations fat_file_inode_operations = {
>         .truncate       = fat_truncate,
>         .setattr        = fat_notify_change,
>         .getattr        = fat_getattr,
> +       .fallocate      = fat_fallocate,
>  };

> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 920a576..ad6f069 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c

Same for this file; this is just the addition of pr_debugs; drop from this patch

<snip>

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
