Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYFDFNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYFDFNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 01:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYFDFNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 01:13:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39270 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbYFDFNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 01:13:07 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <E1K3kkj-0007gR-Pb@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Wed, 04 Jun 2008 06:37:37 +0200)
Subject: Re: [parch 3/4] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT}
 case
References: <4845C4CA.5070403@gmail.com> <E1K3kkj-0007gR-Pb@pomaz-ex.szeredi.hu>
Message-Id: <E1K3lIS-0007lg-4e@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 07:12:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Miklos suggested an alternative idea, migrating the
> > is_owner_or_cap() checks into fs/attr.c:inode_change_ok() via
> > the use of an ATTR_OWNER_CHECK flag.  Maybe we could do that
> > later, but for now I've gone with this version, which is
> > simpler, and can be more easily read as being correct.
> 
> Wise decision.

Or maybe not.  Isn't this a simpler and more readable patch?

Index: linux/fs/attr.c
===================================================================
--- linux.orig/fs/attr.c	2008-06-03 13:10:11.000000000 +0200
+++ linux/fs/attr.c	2008-06-04 07:07:23.000000000 +0200
@@ -51,7 +51,7 @@ int inode_change_ok(struct inode *inode,
 	}
 
 	/* Check for setting the inode time. */
-	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_UPDATE_TIMES)) {
 		if (!is_owner_or_cap(inode))
 			goto error;
 	}
Index: linux/fs/utimes.c
===================================================================
--- linux.orig/fs/utimes.c	2008-06-03 13:10:11.000000000 +0200
+++ linux/fs/utimes.c	2008-06-04 07:10:53.000000000 +0200
@@ -102,9 +102,14 @@ long do_utimes(int dfd, char __user *fil
 	if (error)
 		goto dput_and_out;
 
-	/* Don't worry, the checks are done in inode_change_ok() */
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
+		/*
+		 * Checking the owner is done in inode_change_ok(),
+		 * even for the special UTIME_OMIT/UTIME_NOW cases.
+		 */
+		newattrs.ia_valid |= ATTR_UPDATE_TIMES
+
 		error = -EPERM;
                 if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2008-06-03 13:10:25.000000000 +0200
+++ linux/include/linux/fs.h	2008-06-04 07:07:43.000000000 +0200
@@ -333,6 +333,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
 #define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
+#define ATTR_UPDATE_TIMES	(1 << 16)
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
