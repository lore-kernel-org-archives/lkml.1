Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbXLWMQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbXLWMQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXLWMQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:16:26 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:40603 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXLWMQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:16:25 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Steven Cavanagh" <steven.cavanagh@secretlab.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Editions to support fat_fallocate()
References: <20071222210958.9351.35913.stgit@jpe-laptop>
	<fa686aa40712221418m601d3ffrd5b9158104712078@mail.gmail.com>
Date: Sun, 23 Dec 2007 21:16:19 +0900
In-Reply-To: <fa686aa40712221418m601d3ffrd5b9158104712078@mail.gmail.com>
	(Grant Likely's message of "Sat, 22 Dec 2007 15:18:23 -0700")
Message-ID: <87tzm91u98.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Grant Likely" <grant.likely@secretlab.ca> writes:

>> +/*
>> + * preallocate space for a file. This implements fat fallocate inode
>> + * operation, which gets called from sys_fallocate system call. User
>> + * space requests len bytes at offset.
>> + */
>> +long fat_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)

This should be "static".

>> +{
>> +       int ret = 0;
>> +       loff_t filesize = inode->i_size;
>> +
>> +       /* preallocation to directories is currently not supported */
>> +       if (S_ISDIR(inode->i_mode)) {
>> +               printk(KERN_ERR
>> +               "fat_fallocate(): Directory prealloc not supported\n");
>
> This printk is probably not needed, or at least make it a pr_debug()

Yes. Please remove printk().

>> +               return -ENODEV;
>> +       }
>> +
>> +       if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
>> +               printk(KERN_INFO
>> +                       "fat_fallocate():Blocks already allocated\n");
>
> Drop the printk() here.  It will cause a write to the system log
> everytime userspace does an unnecessary fat_fallocate().  That becomes
> a performance hit which I don't think we want.

Yes. And it should be ->i_size, not ->mmu_private.

>> +       if ((offset + len) > MSDOS_I(inode)->mmu_private) {

Ditto. This should also be ->i_size. Furthermore, this check should be
under ->i_mutex, otherwise others may expand ->i_size before this already.

>> +               mutex_lock(&inode->i_mutex);
>> +               ret = fat_cont_expand(inode, (offset + len));
>> +               if (ret) {
>> +                       printk(KERN_ERR
>> +                               "fat_fallocate():fat_cont_expand() error\n");
>> +                       mutex_unlock(&inode->i_mutex);
>> +                       return ret;
>> +               }
>> +               mutex_unlock(&inode->i_mutex);
>> +       }
>> +       if (mode & FALLOC_FL_KEEP_SIZE) {
>> +               mutex_lock(&inode->i_mutex);
>> +               i_size_write(inode, filesize);
>> +               mutex_unlock(&inode->i_mutex);
>> +       }
>
> Race condition.  The file is increased in size and then returned to
> the original size if FALLOC_FL_KEEP_SIZE is set, but the lock is
> dropped then reobtained between increasing the size and restoring to
> the original.  Another file operation can occur between the two
> operations.  Badness!
>
> However, digging further, when FALLOC_FL_KEEP_SIZE is set, I don't
> think fat_cont_expand() has the behaviour that we want to implement.
> When that flag is set, I think we simply want to add clusters
> associated with the file to the FAT.  We don't want to clear them or
> map them into the page cache yet (that should be done when the
> filesize is increased for real).
>
> I believe a call to fat_allocate_clusters() is all that is needed in
> this case.  Hirofumi, please correct me if I'm wrong.

Right. And we need to care the limitation on FAT specification (compatibility).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
