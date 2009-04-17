Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbZDQJci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbZDQJci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbZDQJc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:32:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:37138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800AbZDQJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:32:27 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: hooanon05@yahoo.co.jp
Cc: Al Viro <viro@zeniv.linux.org.uk>, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <8913.1237476890@jrobl>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org>  <8913.1237476890@jrobl>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 10:32:19 +0100
Message-Id: <1239960739.3428.33.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-3.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 00:34 +0900, hooanon05@yahoo.co.jp wrote:
> David Woodhouse:
> > Yes, well spotted. It didn't matter when the buffered readdir() was
> > purely internal to XFS, because it didn't matter there that we called
> > ->lookup() without i_mutex set. But now we're exposing arbitrary file
> > systems to it, we need to make sure we follow the locking rules. 
> > 
> > I _think_ it's sufficient to make the affected callers of
> > lookup_one_len() lock the parent's i_mutex for themselves before calling
> > it. I'll take a closer look...
> 
> If you remember why you discarded the FS_NO_LOOKUP_IN_READDIR flag
> approach, please let me know. URL or something is enough.

I think someone talked me into doing it in the interest of simplicity,
so we confine the necessary hack into the NFS code alone and _always_
just use the "safe" version. I can't remember who it was, but I'm
guessing Al or Christoph -- both of whom are CC'd in case they want to
object:

Given the fun with i_mutex I think the best answer is to bring it back.
I'm about to test this patch which restores it (and sets it for btrfs,
jffs2 and xfs)...

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index deeeed0..06f539c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -357,7 +357,10 @@ otherwise noted.
 	If you wish to overload the dentry methods then you should
 	initialise the "d_dop" field in the dentry; this is a pointer
 	to a struct "dentry_operations".
-	This method is called with the directory inode semaphore held
+	This method is called with the directory inode mutex held
+	unless the file system sets the FS_NO_LOOKUP_IN_READDIR flag
+	its file system flags, in which case lookup() calls from NFS
+	readdirplus() requests will be made without directory mutex.
 
   link: called by the link(2) system call. Only required if you want
 	to support hard links. You will probably need to call
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9744af9..f0e9d18 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -619,7 +619,7 @@ static struct file_system_type btrfs_fs_type = {
 	.name		= "btrfs",
 	.get_sb		= btrfs_get_sb,
 	.kill_sb	= kill_anon_super,
-	.fs_flags	= FS_REQUIRES_DEV,
+	.fs_flags	= FS_REQUIRES_DEV | FS_NO_LOOKUP_IN_READDIR,
 };
 
 /*
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 4c4e18c..0e97a35 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -209,6 +209,7 @@ static struct file_system_type jffs2_fs_type = {
 	.name =		"jffs2",
 	.get_sb =	jffs2_get_sb,
 	.kill_sb =	jffs2_kill_sb,
+	.flags =	FS_NO_LOOKUP_IN_READDIR,
 };
 
 static int __init init_jffs2_fs(void)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ab93fcf..230e30e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1841,6 +1841,30 @@ out:
 	return err;
 }
 
+
+static int nfsd_real_readdir(struct file *file, filldir_t func,
+			     struct readdir_cd *cdp, loff_t *offsetp)
+{
+	int host_err;
+
+	/*
+	 * Read the directory entries. This silly loop is necessary because
+	 * readdir() is not guaranteed to fill up the entire buffer, but
+	 * may choose to do less.
+	 */
+	do {
+		cdp->err = nfserr_eof; /* will be cleared on successful read */
+		host_err = vfs_readdir(file, func, cdp);
+	} while (host_err >=0 && cdp->err == nfs_ok);
+
+	*offsetp = vfs_llseek(file, 0, 1);
+
+	if (host_err)
+		return nfserrno(host_err);
+	else
+		return cdp->err;
+}
+
 /*
  * We do this buffering because we must not call back into the file
  * system's ->lookup() method from the filldir callback. That may well
@@ -1970,7 +1994,11 @@ nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp,
 		goto out_close;
 	}
 
-	err = nfsd_buffered_readdir(file, func, cdp, offsetp);
+	if ((file->f_path.dentry->d_inode->i_sb->s_type->fs_flags &
+	     FS_NO_LOOKUP_IN_READDIR))
+		err = nfsd_buffered_readdir(file, func, cdp, offsetp);
+	else
+		err = nfsd_real_readdir(file, func, cdp, offsetp);
 
 	if (err == nfserr_eof || err == nfserr_toosmall)
 		err = nfs_ok; /* can still be found in ->err */
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index bb68526..7bba46a 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1546,7 +1546,7 @@ static struct file_system_type xfs_fs_type = {
 	.name			= "xfs",
 	.get_sb			= xfs_fs_get_sb,
 	.kill_sb		= kill_block_super,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_NO_LOOKUP_IN_READDIR,
 };
 
 STATIC int __init
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e766be0..caf2a94 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -176,6 +176,11 @@ struct inodes_stat_t {
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
 					 */
+#define FS_NO_LOOKUP_IN_READDIR	65536	/* FS has its own locking and will
+	   deadlock if you call its lookup() method from within a filldir
+	   function, as NFSd wants to. A file system setting this flag must
+	   be happy for its ->lookup() method to be called without i_mutex,
+	   which is what the NFSd workaround code will do. */
 
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported


-- 
dwmw2

