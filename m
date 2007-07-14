Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXGNDTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXGNDTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 23:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762920AbXGNDS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 23:18:57 -0400
Received: from [212.12.190.58] ([212.12.190.58]:33029 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760587AbXGNDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 23:18:56 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3][try 1] init: enable system-on-initramfs: root-on-tmpfs
Date: Sat, 14 Jul 2007 06:18:57 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707140618.57354.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Change the root filesystem to tmpfs. Doing this makes having a system on
> tmpfs much easier, while allowing to discard the now unnecessary ramfs.

Thanks a lot!

> Having the rootfs on tmpfs allows to safely run e.g. a rescue system
> without using tricks. You might even include the rescue system into the
> kernel.
>
> This is a rework of Al Boldi's "[PATCH] initramfs: Allow rootfs to use
> tmpfs instead of ramfs". All the fame belongs to him, the bugs belong to
> me.

Actually, my patch was a rework of John Zielinski's 
http://marc.info/?l=linux-kernel&m=107013630212011&w=4 patch, so the credit 
really goes to him.

> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
>
>
> diff -Xdontdiff -pruN linux-2.6.22.base/fs/Kconfig
> linux-2.6.22.tmpfsroot/fs/Kconfig --- linux-2.6.22.base/fs/Kconfig       
> 2007-07-12 14:05:16.000000000 +0200 +++ linux-2.6.22.tmpfsroot/fs/Kconfig 
>  2007-07-12 15:10:09.000000000 +0200 @@ -989,6 +989,22 @@ config
> TMPFS_POSIX_ACL

Setting this in fs/Kconfig is way to deep, and too far away from the 
initramfs Kconfig, which makes it obscure.

>
>           If you don't know what Access Control Lists are, say N.
>
> +config TMPFS_ROOT
> +       bool "Use tmpfs instrad of ramfs for initramfs"

Check typo.                    

> +       depends on TMPFS

Should probably depend on SHMEM too.

> +       default n
> +       help
> +         This replaces the ramfs used for unpacking the cpio images
> +         with tmpfs, thereby allowing swapping these contents to disk and
> +         adding size limit support.
> +
> +         Side effect:
> +         This is useful only if you don't plan on mounting a different
> +         root filesystem. Therefore it will change the default of the
> +         root= parameter to "rootfs".
> +
> +         If unsure, say N
> +
>  config HUGETLBFS
>         bool "HugeTLB file system support"
>         depends on X86 || IA64 || PPC64 || SPARC64 || SUPERH || BROKEN
> @@ -1003,7 +1019,7 @@ config HUGETLB_PAGE
>         def_bool HUGETLBFS
>
>  config RAMFS
> -       bool
> +       bool "Ramfs file system support" if TMPFS_ROOT

What's wrong with the original Kconfig of making this tristate?

>         default y
>         ---help---
>           Ramfs is a file system which keeps all files in RAM. It allows

:
:

> diff -Xdontdiff -pruN linux-2.6.22.base/mm/shmem.c
> linux-2.6.22.tmpfsroot/mm/shmem.c --- linux-2.6.22.base/mm/shmem.c       
> 2007-07-12 14:05:25.000000000 +0200 +++ linux-2.6.22.tmpfsroot/mm/shmem.c 
>  2007-07-12 15:01:32.000000000 +0200 @@ -2369,6 +2369,8 @@ static void
> init_once(void *foo, struct
>
>  static int init_inodecache(void)
>  {
> +       if (shmem_inode_cachep)
> +               return 0;
>         shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
>                                 sizeof(struct shmem_inode_info),
>                                 0, 0, init_once, NULL);
> @@ -2582,6 +2584,34 @@ put_memory:
>         return ERR_PTR(error);
>  }
>
> +#ifdef CONFIG_TMPFS_ROOT
> +static int rootfs_get_sb(struct file_system_type *fs_type,
> +       int flags, const char *dev_name, void *data, struct vfsmount *mnt)
> +{
> +       return get_sb_nodev(fs_type, flags|MS_NOUSER, data,
> shmem_fill_super, +                           mnt);

Setting the MS_NOUSER flag will make this invisible to df (diskfree).

> +}
> +
> +/*static struct super_block *rootfs_get_sb(struct file_system_type
> *fs_type, +       int flags, const char *dev_name, void *data)
> +{
> +       return get_sb_single(fs_type, flags, data, shmem_fill_super);
> +}*/

You commented this out, probably asking for clarification:  IIRC, it's 
get_sb_single instead of get_sb_nodev, because tmpfs can be mounted more 
than once and thus needs to be reference counted.

> +
> +static struct file_system_type rootfs_fs_type = {
> +       .name           = "rootfs",
> +       .get_sb         = rootfs_get_sb,
> +       .kill_sb        = kill_litter_super,
> +};
> +
> +int __init init_rootfs(void)
> +{
> +       if (init_inodecache())
> +               panic("Can't initialize shm inode cache");
> +       return register_filesystem(&rootfs_fs_type);
> +}
> +#endif
> +
>  /*
>   * shmem_zero_setup - setup a shared anonymous mapping
>   *


Thanks!

--
Al

