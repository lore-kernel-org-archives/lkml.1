Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYEQG5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYEQG5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 02:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYEQG4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 02:56:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53073 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYEQG4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 02:56:53 -0400
To: hirofumi@mail.parknet.co.jp
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <87prrl7rxg.fsf@duaron.myhome.or.jp> (message from OGAWA Hirofumi
	on Sat, 17 May 2008 08:25:15 +0900)
Subject: Re: [patch 07/22] fat: dont call notify_change
References: <20080516163136.560107038@szeredi.hu>
	<20080516163222.235825996@szeredi.hu> <87prrl7rxg.fsf@duaron.myhome.or.jp>
Message-Id: <E1JxGLP-000406-Eo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 17 May 2008 08:56:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > The FAT_IOCTL_SET_ATTRIBUTES ioctl() calls notify_change() to change
> > the file mode before changing the inode attributes.  Replace with
> > explicit calls to security_inode_setattr(), fat_setattr() and
> > fsnotify_change().
> >
> > This is equivalent to the original.  The reason it is needed, is that
> > later in the series we move the immutable check into notify_change().
> > That would break the FAT_IOCTL_SET_ATTRIBUTES ioctl, as it needs to
> > perform the mode change regardless of the immutability of the file.
> >
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> Don't we need to add EXPORT_SYMBOL(security_inode_setattr)?

Yes we do, thanks for noticing.  Committed the below patch to the
vfs-cleanups tree.

> Otherwise,
> looks good to me.
> 
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

Miklos
----

Subject: fat: don't call notify_change fix

From: Miklos Szeredi <mszeredi@suse.cz>

ERROR: "security_inode_setattr" [fs/fat/fat.ko] undefined!

Fix error if fat is built as a module.  Thanks to OGAWA Hirofumi for
noticing.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 security/security.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/security/security.c
===================================================================
--- linux-2.6.orig/security/security.c	2008-05-14 12:49:42.000000000 +0200
+++ linux-2.6/security/security.c	2008-05-17 08:46:52.000000000 +0200
@@ -476,6 +476,7 @@ int security_inode_setattr(struct dentry
 		return 0;
 	return security_ops->inode_setattr(dentry, attr);
 }
+EXPORT_SYMBOL_GPL(security_inode_setattr);
 
 int security_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 {
