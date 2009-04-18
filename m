Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZDRAQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZDRAQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 20:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZDRAQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 20:16:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:51433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbZDRAQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 20:16:03 -0400
Subject: [PATCH] Fix i_mutex handling in nfsd readdir.
From: David Woodhouse <dwmw2@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: bfields@citi.umich.edu, hooanon05@yahoo.co.jp, hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090417225306.GO26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl>
	 <1239960739.3428.33.camel@macbook.infradead.org>
	 <20090417193233.GM26366@ZenIV.linux.org.uk>
	 <1240006620.19059.41.camel@macbook.infradead.org>
	 <20090417224350.GN26366@ZenIV.linux.org.uk>
	 <20090417225306.GO26366@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 18 Apr 2009 01:15:53 +0100
Message-Id: <1240013753.21423.86.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 14f7dd63 ("Copy XFS readdir hack into nfsd code") introduced a
bug to generic code which had been extant for a long time in the XFS
version -- it started to call through into lookup_one_len() and hence
into the file systems' ->lookup() methods without i_mutex held on the
directory.

This patch fixes it by locking the directory's i_mutex again before
calling the filldir functions. The original deadlocks which commit
14f7dd63 was designed to avoid are still avoided, because they were due
to fs-internal locking, not i_mutex.

While we're at it, fix the return type of nfsd_buffered_readdir() which
should be a __be32 not an int -- it's an NFS errno, not a Linux errno.
And return nfserrno(-ENOMEM) when allocation fails, not just -ENOMEM.
Sparse would have caught both of those if it wasn't so busy bitching
about __cold__.

Reported-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

Commit 05f4f678b introduced a similar problem for NFSv4 which I'm not
going to attempt to deal with before getting some sleep...

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
index ab93fcf..44a68e1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1885,8 +1885,8 @@ static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
 	return 0;
 }
 
-static int nfsd_buffered_readdir(struct file *file, filldir_t func,
-				 struct readdir_cd *cdp, loff_t *offsetp)
+static __be32 nfsd_buffered_readdir(struct file *file, filldir_t func,
+				    struct readdir_cd *cdp, loff_t *offsetp)
 {
 	struct readdir_data buf;
 	struct buffered_dirent *de;
@@ -1896,11 +1896,12 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 
 	buf.dirent = (void *)__get_free_page(GFP_KERNEL);
 	if (!buf.dirent)
-		return -ENOMEM;
+		return nfserrno(-ENOMEM);
 
 	offset = *offsetp;
 
 	while (1) {
+		struct inode *dir_inode = file->f_path.dentry->d_inode;
 		unsigned int reclen;
 
 		cdp->err = nfserr_eof; /* will be cleared on successful read */
@@ -1919,22 +1920,35 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 		if (!size)
 			break;
 
+		/*
+		 * Various filldir functions may end up calling back into
+		 * lookup_one_len() and the file system's ->lookup() method.
+		 * These expect i_mutex to be held, as it would within readdir.
+		 */
+		host_err = mutex_lock_killable(&dir_inode->i_mutex);
+		if (host_err)
+			break;
+
 		de = (struct buffered_dirent *)buf.dirent;
 		while (size > 0) {
 			offset = de->offset;
 
 			if (func(cdp, de->name, de->namlen, de->offset,
 				 de->ino, de->d_type))
-				goto done;
+				break;
 
 			if (cdp->err != nfs_ok)
-				goto done;
+				break;
 
 			reclen = ALIGN(sizeof(*de) + de->namlen,
 				       sizeof(u64));
 			size -= reclen;
 			de = (struct buffered_dirent *)((char *)de + reclen);
 		}
+		mutex_unlock(&dir_inode->i_mutex);
+		if (size > 0) /* We bailed out early */
+			break;
+
 		offset = vfs_llseek(file, 0, SEEK_CUR);
 	}
 


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

