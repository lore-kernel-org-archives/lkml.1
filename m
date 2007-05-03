Return-Path: <linux-kernel-owner+w=401wt.eu-S1031369AbXECRbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031369AbXECRbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031371AbXECRbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:31:36 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:32086 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031369AbXECRbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=cdVpJbzbyPHpBY0tut8h6caR6QjaN30vKCzQBSlDFOlDIvexNoHwbgEzUc7jfk9dBRHEOhujhh71eLQiZTeiXciu5XWRY/JL0XtfhyGKDk13TvWpCTXxWF+KbB7bi/s7WhV77gb7r29J+4nhohGyRk7t2WcIyDJyeF9GoteMOn4=
Date: Fri, 4 May 2007 02:25:29 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Joel Becker <joel.becker@oracle.com>
Subject: [PATCH] use simple_read_from_buffer() in fs/
Message-ID: <20070503172529.GC3491@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Becker <joel.becker@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

Cleanup using simple_read_from_buffer() in binfmt_misc,
configfs, and sysfs.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/binfmt_misc.c   |   13 +------------
 fs/configfs/file.c |   33 ++-------------------------------
 fs/sysfs/file.c    |   33 ++-------------------------------
 3 files changed, 5 insertions(+), 74 deletions(-)

Index: 2.6-git/fs/configfs/file.c
===================================================================
--- 2.6-git.orig/fs/configfs/file.c
+++ 2.6-git/fs/configfs/file.c
@@ -77,36 +77,6 @@ static int fill_read_buffer(struct dentr
 	return ret;
 }
 
-
-/**
- *	flush_read_buffer - push buffer to userspace.
- *	@buffer:	data buffer for file.
- *	@userbuf:	user-passed buffer.
- *	@count:		number of bytes requested.
- *	@ppos:		file position.
- *
- *	Copy the buffer we filled in fill_read_buffer() to userspace.
- *	This is done at the reader's leisure, copying and advancing
- *	the amount they specify each time.
- *	This may be called continuously until the buffer is empty.
- */
-static int flush_read_buffer(struct configfs_buffer * buffer, char __user * buf,
-			     size_t count, loff_t * ppos)
-{
-	int error;
-
-	if (*ppos > buffer->count)
-		return 0;
-
-	if (count > (buffer->count - *ppos))
-		count = buffer->count - *ppos;
-
-	error = copy_to_user(buf,buffer->page + *ppos,count);
-	if (!error)
-		*ppos += count;
-	return error ? -EFAULT : count;
-}
-
 /**
  *	configfs_read_file - read an attribute.
  *	@file:	file pointer.
@@ -139,7 +109,8 @@ configfs_read_file(struct file *file, ch
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
 		 __FUNCTION__, count, *ppos, buffer->page);
-	retval = flush_read_buffer(buffer,buf,count,ppos);
+	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
+					 buffer->count);
 out:
 	up(&buffer->sem);
 	return retval;
Index: 2.6-git/fs/sysfs/file.c
===================================================================
--- 2.6-git.orig/fs/sysfs/file.c
+++ 2.6-git/fs/sysfs/file.c
@@ -112,36 +112,6 @@ static int fill_read_buffer(struct dentr
 	return ret;
 }
 
-
-/**
- *	flush_read_buffer - push buffer to userspace.
- *	@buffer:	data buffer for file.
- *	@buf:		user-passed buffer.
- *	@count:		number of bytes requested.
- *	@ppos:		file position.
- *
- *	Copy the buffer we filled in fill_read_buffer() to userspace.
- *	This is done at the reader's leisure, copying and advancing 
- *	the amount they specify each time.
- *	This may be called continuously until the buffer is empty.
- */
-static int flush_read_buffer(struct sysfs_buffer * buffer, char __user * buf,
-			     size_t count, loff_t * ppos)
-{
-	int error;
-
-	if (*ppos > buffer->count)
-		return 0;
-
-	if (count > (buffer->count - *ppos))
-		count = buffer->count - *ppos;
-
-	error = copy_to_user(buf,buffer->page + *ppos,count);
-	if (!error)
-		*ppos += count;
-	return error ? -EFAULT : count;
-}
-
 /**
  *	sysfs_read_file - read an attribute. 
  *	@file:	file pointer.
@@ -178,7 +148,8 @@ sysfs_read_file(struct file *file, char 
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
 		 __FUNCTION__, count, *ppos, buffer->page);
-	retval = flush_read_buffer(buffer,buf,count,ppos);
+	retval = simple_read_from_buffer(buf, count, ppos, buffer->page,
+					 buffer->count);
 out:
 	up(&buffer->sem);
 	return retval;
Index: 2.6-git/fs/binfmt_misc.c
===================================================================
--- 2.6-git.orig/fs/binfmt_misc.c
+++ 2.6-git/fs/binfmt_misc.c
@@ -675,19 +675,8 @@ static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	char *s = enabled ? "enabled" : "disabled";
-	int len = strlen(s);
-	loff_t pos = *ppos;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= len)
-		return 0;
-	if (len < pos + nbytes)
-		nbytes = len - pos;
-	if (copy_to_user(buf, s + pos, nbytes))
-		return -EFAULT;
-	*ppos = pos + nbytes;
-	return nbytes;
+	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
 static ssize_t bm_status_write(struct file * file, const char __user * buffer,
