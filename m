Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbZDQXXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbZDQXXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZDQXXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:23:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:47961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZDQXXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:23:38 -0400
Subject: Re: Q: NFSD readdir in linux-2.6.28
From: David Woodhouse <dwmw2@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: hooanon05@yahoo.co.jp, hch@infradead.org,
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
Date: Sat, 18 Apr 2009 00:23:32 +0100
Message-Id: <1240010612.21423.34.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 23:53 +0100, Al Viro wrote:
> On Fri, Apr 17, 2009 at 11:43:50PM +0100, Al Viro wrote:
> > On Fri, Apr 17, 2009 at 11:17:00PM +0100, David Woodhouse wrote:
> > > It sounds like the better answer is to just make sure i_mutex is held
> > > when nfsd_buffered_readdir() calls back into the provided filldir
> > > function (we could do it in the various filldir functions themselves,
> > > _if_ they call lookup_one_len(), but I think I prefer it this way --
> > > it's simpler). Patch below for comment.
> > 
> > Umm...  I can live with that, assuming that we don't have callbacks
> > that take i_mutex themselves.  AFAICS, everything we call there is
> > either obviously not touching i_mutex or is already called while we
> > hold i_mutex elsewhere, but I'd appreciate if somebody actually
> > tested that sucker for different versions of protocol...
> 
> BTW, why mess with taking i_mutex inside the inner loop and not
> immediately around it?

Or, to phrase my last response slightly differently... because I don't
like either of these two versions very much...



diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ab93fcf..0523e9f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1885,9 +1885,10 @@ static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
 	return 0;
 }
 
-static int nfsd_buffered_readdir(struct file *file, filldir_t func,
-				 struct readdir_cd *cdp, loff_t *offsetp)
+static __be32 nfsd_buffered_readdir(struct file *file, filldir_t func,
+				    struct readdir_cd *cdp, loff_t *offsetp)
 {
+	struct inode *dir_inode = file->f_path.dentry->d_inode;
 	struct readdir_data buf;
 	struct buffered_dirent *de;
 	int host_err;
@@ -1896,7 +1897,7 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 
 	buf.dirent = (void *)__get_free_page(GFP_KERNEL);
 	if (!buf.dirent)
-		return -ENOMEM;
+		return nfserrno(-ENOMEM);
 
 	offset = *offsetp;
 
@@ -1912,23 +1913,37 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 			host_err = 0;
 
 		if (host_err < 0)
-			break;
+			goto done;
 
 		size = buf.used;
 
 		if (!size)
-			break;
+			goto done;
 
 		de = (struct buffered_dirent *)buf.dirent;
+
+		host_err = mutex_lock_killable(&dir_inode->i_mutex);
+		if (host_err)
+			goto done;
+
 		while (size > 0) {
+
+			int finished;
+
 			offset = de->offset;
 
+			/*
+			 * Various filldir functions may end up calling back
+			 * into lookup_one_len() and the file system's 
+			 * ->lookup() method. These expect i_mutex to be held.
+			 */
+
 			if (func(cdp, de->name, de->namlen, de->offset,
 				 de->ino, de->d_type))
-				goto done;
-
+				goto done_unlock;
+			    
 			if (cdp->err != nfs_ok)
-				goto done;
+				goto done_unlock;
 
 			reclen = ALIGN(sizeof(*de) + de->namlen,
 				       sizeof(u64));
@@ -1937,6 +1952,8 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 		}
 		offset = vfs_llseek(file, 0, SEEK_CUR);
 	}
+ done_unlock:
+	mutex_unlock(&dir_inode->i_mutex);
 
  done:
 	free_page((unsigned long)(buf.dirent));



====================================================================

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ab93fcf..915a47c 100644
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
@@ -1920,24 +1921,42 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
 			break;
 
 		de = (struct buffered_dirent *)buf.dirent;
+
+		host_err = mutex_lock_killable(&dir_inode->i_mutex);
+		if (host_err)
+			break;
+
 		while (size > 0) {
+			int finished;
+
 			offset = de->offset;
 
+			/*
+			 * Various filldir functions may end up calling back
+			 * into lookup_one_len() and the file system's 
+			 * ->lookup() method. These expect i_mutex to be held.
+			 */
+
 			if (func(cdp, de->name, de->namlen, de->offset,
 				 de->ino, de->d_type))
-				goto done;
-
+				goto done_unlock;
+			    
 			if (cdp->err != nfs_ok)
-				goto done;
+				goto done_unlock;
 
 			reclen = ALIGN(sizeof(*de) + de->namlen,
 				       sizeof(u64));
 			size -= reclen;
 			de = (struct buffered_dirent *)((char *)de + reclen);
 		}
+		mutex_unlock(&dir_inode->i_mutex);
 		offset = vfs_llseek(file, 0, SEEK_CUR);
-	}
+		continue;
 
+	done_unlock:
+		mutex_unlock(&dir_inode->i_mutex);
+		break;
+	}
  done:
 	free_page((unsigned long)(buf.dirent));
 

-- 
dwmw2

