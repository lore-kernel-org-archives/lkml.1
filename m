Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbYESTdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbYESTdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbYESTcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:32:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55289 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYESTcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:32:50 -0400
To: opslynx@gmail.com
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, mszeredi@suse.cz,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org
In-reply-to: <df47b87a0805191117m278580d2n2e23c48452ee4a19@mail.gmail.com>
	(opslynx@gmail.com)
Subject: Re: BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
References: <df47b87a0805171337h5da01cc4pd9df7d318afc47c2@mail.gmail.com>
	 <E1Jxza1-0007YO-KM@pomaz-ex.szeredi.hu> <df47b87a0805191117m278580d2n2e23c48452ee4a19@mail.gmail.com>
Message-Id: <E1JyB6E-0000Ya-6v@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 May 2008 21:32:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thanks.  I've tried to reproduce this bug, but was unable to.
> >
> > That patch looks OK to me, however there's something very weird going
> > on if sysfs_add_one() gets called with an already existing name.
> >
> > Could you please post the full dmesg output?  That should include a
> > line like
> >
> >  sysfs: duplicate filename 'foobar' can not be created
> >
> > What are the exact commands that you perform (or contents of
> > /etc/fstab, etc. that might be relevant) to tirgger this bug?
> >
> 
> I think you were unable to reproduce it because i just figured out
> that it only occurs on a raid-0 partition managed by dmraid.
> Ex:
> 
> Mounting the non-raid:
> /dev/sdb3           10913       18242    58878225    7  HPFS/NTFS
> root@ops-desktop:~# mount /dev/sdb3 /next
> root@ops-desktop:~#
> 
> The raid-0:
> /dev/mapper/isw_fjcgajage_raid3            4346       29841
> 204796620    7  HPFS/NTFS
> root@ops-desktop:~# mount /dev/mapper/isw_fjcgajage_raid3 /new
> fuse: mount failed: Cannot allocate memory
> 
> NOTE that I've tried mounting other raid-0 NTFS partitions. Same
> failure occurred. So it doesn't seem to be isolated to one partition.
> RAID is the only common thing.
> 
> I've attached the full dmesg. Hope it helps.

Thanks!

The problem seems to be that if a device isn't partitioned (and the
raid-0 device isn't), then fuse will register its own BDI with the
same name as the one belonging to the underlying device.

Here's a patch that should fix it.  Can you please confirm?

Thanks,
Miklos



Subject: fuse: fix bdi naming conflict

From: Miklos Szeredi <mszeredi@suse.cz>

Fuse allocates a separate bdi for each filesystem, and registers them
in sysfs with "MAJOR:MINOR" of sb->s_dev (st_dev).  This works fine
for anon devices normally used by fuse, but can conflict with an
already registered BDI for "fuseblk" filesystems, where sb->s_dev
represents a real block device.  In particularl this happens if a
non-partitioned device is being mounted.

Fix by registering with a different name for "fuseblk" filesystems.

Thanks to Ioan Ionita for the bug report.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/ABI/testing/sysfs-class-bdi |    4 ++++
 fs/fuse/inode.c                           |    7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2008-05-16 16:34:31.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2008-05-19 20:54:53.000000000 +0200
@@ -488,7 +488,12 @@ static struct fuse_conn *new_conn(struct
 		err = bdi_init(&fc->bdi);
 		if (err)
 			goto error_kfree;
-		err = bdi_register_dev(&fc->bdi, fc->dev);
+		if (sb->s_bdev) {
+			err = bdi_register(&fc->bdi, NULL, "%u:%u-fuseblk",
+					   MAJOR(fc->dev), MINOR(fc->dev));
+		} else {
+			err = bdi_register_dev(&fc->bdi, fc->dev);
+		}
 		if (err)
 			goto error_bdi_destroy;
 		/*
Index: linux-2.6/Documentation/ABI/testing/sysfs-class-bdi
===================================================================
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-class-bdi	2008-05-14 12:48:03.000000000 +0200
+++ linux-2.6/Documentation/ABI/testing/sysfs-class-bdi	2008-05-19 20:59:59.000000000 +0200
@@ -14,6 +14,10 @@ MAJOR:MINOR
 	non-block filesystems which provide their own BDI, such as NFS
 	and FUSE.
 
+MAJOR:MINOR-fuseblk
+
+	Value of st_dev on fuseblk filesystems.
+
 default
 
 	The default backing dev, used for non-block device backed


