Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbXGODwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbXGODwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 23:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXGODwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 23:52:10 -0400
Received: from [212.12.190.78] ([212.12.190.78]:32821 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753668AbXGODwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 23:52:09 -0400
From: Al Boldi <a1426z@gawab.com>
To: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 2/3][try 1] init: enable system-on-initramfs: root-on-tmpfs
Date: Sun, 15 Jul 2007 08:24:13 +0300
User-Agent: KMail/1.5
References: <8GGkX-2Xv-5@gated-at.bofh.it> <E1I9mgG-0000jf-1y@be1.lrz>
In-Reply-To: <E1I9mgG-0000jf-1y@be1.lrz>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707150824.13832.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Al Boldi <a1426z@gawab.com> wrote:
> > Bodo Eggert wrote:
>
> Please reply-to-all, I'm not subscribed, but reading through a news
> gateway.

Same here.  The problem is, I have no idea who's on the cc, and expected you 
to be on the list.  Sorry.

> >> This is a rework of Al Boldi's "[PATCH] initramfs: Allow rootfs to use
> >> tmpfs instead of ramfs". All the fame belongs to him, the bugs belong
> >> to me.
> >
> > Actually, my patch was a rework of John Zielinski's
> > http://marc.info/?l=linux-kernel&m=107013630212011&w=4 patch, so the
> > credit really goes to him.
> >
> >> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> >>
> >>
> >> diff -Xdontdiff -pruN linux-2.6.22.base/fs/Kconfig
> >> linux-2.6.22.tmpfsroot/fs/Kconfig --- linux-2.6.22.base/fs/Kconfig
> >> 2007-07-12 14:05:16.000000000 +0200 +++
> >> linux-2.6.22.tmpfsroot/fs/Kconfig 2007-07-12 15:10:09.000000000 +0200
> >> @@ -989,6 +989,22 @@ config TMPFS_POSIX_ACL
> >
> > Setting this in fs/Kconfig is way to deep, and too far away from the
> > initramfs Kconfig, which makes it obscure.
>
> If it were under general setup, you'd have to enter fs to select tmpfs,
> enter general setup to replace ramfs, and re-enter fs to disable ramfs.
> I consider making people do that to be an evil deed.

That's easy to fix, just change "depends on" to "select" in Kconfig.

> The current position is very convenient, ramfs is below tmpfs, and while
> you go from top to the bottom, you can enable tmpfs, tmpfs-replaces-ramfs
> and ramfs=n.
>
> >>           If you don't know what Access Control Lists are, say N.
> >>
> >> +config TMPFS_ROOT
> >> +       bool "Use tmpfs instrad of ramfs for initramfs"
> >
> > Check typo.
> >
> >> +       depends on TMPFS
> >
> > Should probably depend on SHMEM too.
>
> Sounds reasonable.
>
> >> @@ -1003,7 +1019,7 @@ config HUGETLB_PAGE
> >>         def_bool HUGETLBFS
> >>
> >>  config RAMFS
> >> -       bool
> >> +       bool "Ramfs file system support" if TMPFS_ROOT
> >
> > What's wrong with the original Kconfig of making this tristate?
>
> I tested =m, found it not to compile because of a nonexported __symbol
> and decided it wasn't worth the effort of adding another export while
> other people struggle to reduce their number.

Ok.

> >> diff -Xdontdiff -pruN linux-2.6.22.base/mm/shmem.c
> >> linux-2.6.22.tmpfsroot/mm/shmem.c --- linux-2.6.22.base/mm/shmem.c
> >> 2007-07-12 14:05:25.000000000 +0200 +++
> >> linux-2.6.22.tmpfsroot/mm/shmem.c 2007-07-12 15:01:32.000000000 +0200
> >> @@ -2369,6 +2369,8 @@ static void init_once(void *foo, struct
> >>
> >>  static int init_inodecache(void)
> >>  {
> >> +       if (shmem_inode_cachep)
> >> +               return 0;
> >>         shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
> >>                                 sizeof(struct shmem_inode_info),
> >>                                 0, 0, init_once, NULL);
> >> @@ -2582,6 +2584,34 @@ put_memory:
> >>         return ERR_PTR(error);
> >>  }
> >>
> >> +#ifdef CONFIG_TMPFS_ROOT
> >> +static int rootfs_get_sb(struct file_system_type *fs_type,
> >> +       int flags, const char *dev_name, void *data, struct vfsmount
> >> *mnt) +{
> >> +       return get_sb_nodev(fs_type, flags|MS_NOUSER, data,
> >> shmem_fill_super, +                           mnt);
> >
> > Setting the MS_NOUSER flag will make this invisible to df (diskfree).
>
> Which is obviously a bad thing for my cause, but good if you'd boot a
> normal system. Is there any way out?

Just remove the MS_NOUSER flag.  Normal systems would want to umount it after 
pivoting, so it won't be visible then.

> >> +}
> >> +
> >> +/*static struct super_block *rootfs_get_sb(struct file_system_type
> >> *fs_type, +       int flags, const char *dev_name, void *data)
> >> +{
> >> +       return get_sb_single(fs_type, flags, data, shmem_fill_super);
> >> +}*/
> >
> > You commented this out, probably asking for clarification:  IIRC, it's
> > get_sb_single instead of get_sb_nodev, because tmpfs can be mounted more
> > than once and thus needs to be reference counted.
>
> No, I had left it there accidentially. Your comment tells me it was ment
> to happen.


Thanks!

--
Al

