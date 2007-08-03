Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXHCSU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXHCSU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXHCSUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:20:52 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49209 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXHCSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:20:51 -0400
Date: Fri, 3 Aug 2007 20:20:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11] fuse: fix permission checking on sticky directories
In-Reply-To: <20070803174945.860663499@szeredi.hu>
Message-ID: <Pine.LNX.4.64.0708032019450.26527@fbirervta.pbzchgretzou.qr>
References: <20070803174425.998083527@szeredi.hu> <20070803174945.860663499@szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3 2007 19:44, Miklos Szeredi wrote:
>--- linux.orig/fs/fuse/fuse_i.h	2007-08-03 18:36:15.000000000 +0200
>+++ linux/fs/fuse/fuse_i.h	2007-08-03 18:36:17.000000000 +0200
>@@ -63,6 +63,10 @@ struct fuse_inode {
> 
> 	/** Time in jiffies until the file attributes are valid */
> 	u64 i_time;
>+
>+	/** The sticky bit in inode->i_mode may have been remved, so
                                                             ^
                                            may have been removed.

>+	    preserve the original mode */
>+	mode_t orig_i_mode;
> };
> 
> /** FUSE specific file data */
>Index: linux/fs/fuse/inode.c
>===================================================================
>--- linux.orig/fs/fuse/inode.c	2007-08-03 18:36:14.000000000 +0200
>+++ linux/fs/fuse/inode.c	2007-08-03 18:36:37.000000000 +0200
>@@ -120,10 +120,18 @@ static void fuse_truncate(struct address
> void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr)
> {
> 	struct fuse_conn *fc = get_fuse_conn(inode);
>+	struct fuse_inode *fi = get_fuse_inode(inode);
> 	loff_t oldsize;
> 
> 	inode->i_ino     = attr->ino;
>-	inode->i_mode    = (inode->i_mode & S_IFMT) + (attr->mode & 07777);
>+	fi->orig_i_mode  = (inode->i_mode & S_IFMT) + (attr->mode & 07777);

Although it does not matter in this case, | is safer (and perhaps faster?).



	Jan
-- 
