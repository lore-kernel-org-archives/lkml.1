Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZDQWRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZDQWRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 18:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761657AbZDQWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 18:17:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:47618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759667AbZDQWRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 18:17:06 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hooanon05@yahoo.co.jp, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090417193233.GM26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl>
	 <1239960739.3428.33.camel@macbook.infradead.org>
	 <20090417193233.GM26366@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 23:17:00 +0100
Message-Id: <1240006620.19059.41.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 20:32 +0100, Al Viro wrote:
> Ow...  Sorry, I've missed that one.  I really don't like flags-based
> solution ;-/  It's not just filesystem method that want i_mutex there -
> we have fs/namei.c code suddenly called in different locking conditions
> now.

Well, we have that already.

When nfsd readdirplus code ends up calling back into lookup_one_len(),
it does so without i_mutex held. XFS had been doing it that way for
years, so that detail escaped our notice when we shifted the XFS 'hack'
into nfsd code.

> What were the details of xfs and jffs2 locking problems, just in case
> if something can be done in that direction short-term?

JFFS2 has its own internal mutex protecting the directory. It needs an
internal mutex instead of i_mutex because of ordering issues with
garbage collection. We are _in_ jffs2_readdir(), with the lock held,
when we call back into nfsd's filldir function... which calls right back
into jffs2_lookup() and deadlocks when it tries to take the same lock
again.

The situation in btrfs and xfs is broadly similar. They have their own
locks, and we end up deadlocking. GFS2 has some lovely "is this process
the owner of the lock" magic to avoid a similar deadlock.

It sounds like the better answer is to just make sure i_mutex is held
when nfsd_buffered_readdir() calls back into the provided filldir
function (we could do it in the various filldir functions themselves,
_if_ they call lookup_one_len(), but I think I prefer it this way --
it's simpler). Patch below for comment.

(While I'm staring at it, it looks like nfsd_buffered_readdir() should
be returning a __be32 not an int, and its 'return -ENOMEM' should be
'return nfserrno(-ENOMEM)'. The first bug I inherited from the existing
nfsd_do_readdir() when I replaced it, but the second is all my own. I'll
send a patch to fix those shortly.)

diff --git a/fs/namei.c b/fs/namei.c
index b8433eb..78f253c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1248,6 +1248,8 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 	int err;
 	struct qstr this;
 
+	WARN_ON_ONCE(!mutex_is_locked(&base->d_inode->i_mutex));
+
 	err = __lookup_one_len(name, &this, base, len);
 	if (err)
 		return ERR_PTR(err);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ab93fcf..fb2965d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1920,13 +1920,27 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 			break;
 
 		de = (struct buffered_dirent *)buf.dirent;
+
 		while (size > 0) {
+			struct inode *dir_inode = file->f_path.dentry->d_inode;
+			int finished;
+
 			offset = de->offset;
 
-			if (func(cdp, de->name, de->namlen, de->offset,
-				 de->ino, de->d_type))
+			/*
+			 * Various filldir functions may end up calling back
+			 * into lookup_one_len() and the file system's 
+			 * ->lookup() method. These expect i_mutex to be held.
+			 */
+			host_err = mutex_lock_killable(&dir_inode->i_mutex);
+			if (host_err)
 				goto done;
 
+			finished = func(cdp, de->name, de->namlen, de->offset,
+					de->ino, de->d_type);
+
+			mutex_unlock(&dir_inode->i_mutex);
+
 			if (cdp->err != nfs_ok)
 				goto done;
 



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

