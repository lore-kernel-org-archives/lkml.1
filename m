Return-Path: <linux-kernel-owner+w=401wt.eu-S1762969AbXGNSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762969AbXGNSto (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759765AbXGNSth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:49:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:59469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbXGNStg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:49:36 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 2/3][try 1] init: enable system-on-initramfs: root-on-tmpfs
To: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org, 7eggert@gmx.de
Reply-To: 7eggert@gmx.de
Date: Sat, 14 Jul 2007 20:49:23 +0200
References: <8GGkX-2Xv-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I9mgG-0000jf-1y@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/V/PAuFZEsUq/PVbgJzxS2yJ/R/ad9a8U5hgJ
 vQl/hm7A5kzraj8F+NAfFo77mXArKXGBpiwwkcM1IxWGaYHTYn
 pVmcKjcFsJyHk1zlUkwWQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> wrote:
> Bodo Eggert wrote:

Please reply-to-all, I'm not subscribed, but reading through a news gateway.

>> This is a rework of Al Boldi's "[PATCH] initramfs: Allow rootfs to use
>> tmpfs instead of ramfs". All the fame belongs to him, the bugs belong to
>> me.
> 
> Actually, my patch was a rework of John Zielinski's
> http://marc.info/?l=linux-kernel&m=107013630212011&w=4 patch, so the credit
> really goes to him.

>> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
>>
>>
>> diff -Xdontdiff -pruN linux-2.6.22.base/fs/Kconfig
>> linux-2.6.22.tmpfsroot/fs/Kconfig --- linux-2.6.22.base/fs/Kconfig
>> 2007-07-12 14:05:16.000000000 +0200 +++ linux-2.6.22.tmpfsroot/fs/Kconfig
>>  2007-07-12 15:10:09.000000000 +0200 @@ -989,6 +989,22 @@ config
>> TMPFS_POSIX_ACL
> 
> Setting this in fs/Kconfig is way to deep, and too far away from the
> initramfs Kconfig, which makes it obscure.

If it were under general setup, you'd have to enter fs to select tmpfs,
enter general setup to replace ramfs, and re-enter fs to disable ramfs.
I consider making people do that to be an evil deed.

The current position is very convenient, ramfs is below tmpfs, and while you
go from top to the bottom, you can enable tmpfs, tmpfs-replaces-ramfs and
ramfs=n.

>>           If you don't know what Access Control Lists are, say N.
>>
>> +config TMPFS_ROOT
>> +       bool "Use tmpfs instrad of ramfs for initramfs"
> 
> Check typo.
> 
>> +       depends on TMPFS
> 
> Should probably depend on SHMEM too.

Sounds reasonable.

>> @@ -1003,7 +1019,7 @@ config HUGETLB_PAGE
>>         def_bool HUGETLBFS
>>
>>  config RAMFS
>> -       bool
>> +       bool "Ramfs file system support" if TMPFS_ROOT
> 
> What's wrong with the original Kconfig of making this tristate?

I tested =m, found it not to compile because of a nonexported __symbol
and decided it wasn't worth the effort of adding another export while
other people struggle to reduce their number.

>> diff -Xdontdiff -pruN linux-2.6.22.base/mm/shmem.c
>> linux-2.6.22.tmpfsroot/mm/shmem.c --- linux-2.6.22.base/mm/shmem.c
>> 2007-07-12 14:05:25.000000000 +0200 +++ linux-2.6.22.tmpfsroot/mm/shmem.c
>>  2007-07-12 15:01:32.000000000 +0200 @@ -2369,6 +2369,8 @@ static void
>> init_once(void *foo, struct
>>
>>  static int init_inodecache(void)
>>  {
>> +       if (shmem_inode_cachep)
>> +               return 0;
>>         shmem_inode_cachep = kmem_cache_create("shmem_inode_cache",
>>                                 sizeof(struct shmem_inode_info),
>>                                 0, 0, init_once, NULL);
>> @@ -2582,6 +2584,34 @@ put_memory:
>>         return ERR_PTR(error);
>>  }
>>
>> +#ifdef CONFIG_TMPFS_ROOT
>> +static int rootfs_get_sb(struct file_system_type *fs_type,
>> +       int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>> +{
>> +       return get_sb_nodev(fs_type, flags|MS_NOUSER, data,
>> shmem_fill_super, +                           mnt);
> 
> Setting the MS_NOUSER flag will make this invisible to df (diskfree).

Which is obviously a bad thing for my cause, but good if you'd boot a
normal system. Is there any way out?

>> +}
>> +
>> +/*static struct super_block *rootfs_get_sb(struct file_system_type
>> *fs_type, +       int flags, const char *dev_name, void *data)
>> +{
>> +       return get_sb_single(fs_type, flags, data, shmem_fill_super);
>> +}*/
> 
> You commented this out, probably asking for clarification:  IIRC, it's
> get_sb_single instead of get_sb_nodev, because tmpfs can be mounted more
> than once and thus needs to be reference counted.

No, I had left it there accidentially. Your comment tells me it was ment to
happen.
-- 
If at first you don't succeed call in an air-strike. 

Friﬂ, Spammer: zbyUv@7nKzeel.7eggert.dyndns.org J@op16.7eggert.dyndns.org
 NS6uqbvhd9@d.7eggert.dyndns.org QcPun@SgLk.7eggert.dyndns.org
