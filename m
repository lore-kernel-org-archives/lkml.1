Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbXICGtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbXICGtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 02:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXICGs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 02:48:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56634 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXICGsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 02:48:54 -0400
Date: Mon, 3 Sep 2007 08:48:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 08/32] Unionfs: cache-coherency - update inode times
In-Reply-To: <1188786056593-git-send-email-jsipek@cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0709030844250.4454@fbirervta.pbzchgretzou.qr>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
 <1188786056593-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
>-static ssize_t unionfs_write(struct file * file, const char __user * buf,
>+
>+static ssize_t unionfs_write(struct file *file, const char __user *buf,
> 			     size_t count, loff_t *ppos)
> {
> 	int err = 0;
> 
> 	unionfs_read_lock(file->f_path.dentry->d_sb);
>-
> 	if ((err = unionfs_file_revalidate(file, 1)))
> 		goto out;
> 
> 	err = do_sync_write(file, buf, count, ppos);
>+	/* update our inode times upon a successful lower write */
>+	if (err >= 0)
>+		unionfs_copy_attr_times(file->f_path.dentry->d_inode);

So, revisiting the question of inotifying, write() is indeed a case which
warrants notification (I think). Just was not sure what callers
unionfs_copy_attr_times can have.

>@@ -245,6 +245,12 @@ static struct dentry *unionfs_lookup(struct inode *parent,
> 		nd->dentry = path_save.dentry;
> 		nd->mnt = path_save.mnt;
> 	}
>+	if (!IS_ERR(ret)) {
>+		if (ret)
>+			dentry = ret;
>+		/* parent times may have changed */
>+		unionfs_copy_attr_times(dentry->d_parent->d_inode);
>+	}

On lookup? No inotify if you ask me...


>@@ -675,8 +681,11 @@ out:
> 
> 	kfree(name);
> 
>+	if (!err)
>+		unionfs_copy_attr_times(dentry->d_inode);
> 	unionfs_unlock_dentry(dentry);
> 	unionfs_read_unlock(dentry->d_sb);
>+
> 	return err;
> }
> 

Can't decide ;-)

>@@ -1006,6 +1015,8 @@ static int unionfs_permission(struct inode *inode, int mask,
> 			break;
> 		}
> 	}
>+	/* sync times which may have changed (asynchronously) below */
>+	unionfs_copy_attr_times(inode);
> 
> out:
> 	return err;

permission => readonly operation => no inotify

>diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
>index 822bffe..7ad19ec 100644
>--- a/fs/unionfs/unlink.c
>+++ b/fs/unionfs/unlink.c
>@@ -41,6 +41,9 @@ static int unionfs_unlink_whiteout(struct inode *dir, struct dentry *dentry)
> 	dget(lower_dentry);
> 	if (!(err = is_robranch_super(dentry->d_sb, bindex)))
> 		err = vfs_unlink(lower_dir_dentry->d_inode, lower_dentry);
>+	/* if vfs_unlink succeeded, update our inode's times */
>+	if (!err)
>+		unionfs_copy_attr_times(dentry->d_inode);
> 	dput(lower_dentry);
> 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
> 	unlock_dir(lower_dir_dentry);

unlink => write operation => inotify



	Jan
-- 
