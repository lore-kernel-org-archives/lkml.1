Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbXJBPyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbXJBPyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXJBPwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:37 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:58988 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbXJBPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:34 -0400
Message-Id: <20071002155218.749014790@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:32 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 06/12] fuse: improve utimes support
Content-Disposition: inline; filename=fuse_utimes_update.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add two new flags for setattr: FATTR_ATIME_NOW and FATTR_MTIME_NOW.
These mean, that atime or mtime should be changed to the current time.

Also it is now possible to update atime or mtime individually, not
just together.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-25 21:19:13.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-25 21:19:14.000000000 +0200
@@ -1014,6 +1014,20 @@ static int fuse_dir_fsync(struct file *f
 	return file ? fuse_fsync_common(file, de, datasync, 1) : 0;
 }
 
+static bool update_mtime(unsigned ivalid)
+{
+	/* Always update if mtime is explicitly set  */
+	if (ivalid & ATTR_MTIME_SET)
+		return true;
+
+	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
+	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
+		return false;
+
+	/* In all other cases update */
+	return true;
+}
+
 static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg)
 {
 	unsigned ivalid = iattr->ia_valid;
@@ -1026,11 +1040,19 @@ static void iattr_to_fattr(struct iattr 
 		arg->valid |= FATTR_GID,    arg->gid = iattr->ia_gid;
 	if (ivalid & ATTR_SIZE)
 		arg->valid |= FATTR_SIZE,   arg->size = iattr->ia_size;
-	/* You can only _set_ these together (they may change by themselves) */
-	if ((ivalid & (ATTR_ATIME | ATTR_MTIME)) == (ATTR_ATIME | ATTR_MTIME)) {
-		arg->valid |= FATTR_ATIME | FATTR_MTIME;
+	if (ivalid & ATTR_ATIME) {
+		arg->valid |= FATTR_ATIME;
 		arg->atime = iattr->ia_atime.tv_sec;
+		arg->atimensec = iattr->ia_atime.tv_nsec;
+		if (!(ivalid & ATTR_ATIME_SET))
+			arg->valid |= FATTR_ATIME_NOW;
+	}
+	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
+		arg->valid |= FATTR_MTIME;
 		arg->mtime = iattr->ia_mtime.tv_sec;
+		arg->mtimensec = iattr->ia_mtime.tv_nsec;
+		if (!(ivalid & ATTR_MTIME_SET))
+			arg->valid |= FATTR_MTIME_NOW;
 	}
 }
 
Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-25 21:19:13.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-25 21:19:14.000000000 +0200
@@ -83,6 +83,8 @@ struct fuse_file_lock {
 #define FATTR_ATIME	(1 << 4)
 #define FATTR_MTIME	(1 << 5)
 #define FATTR_FH	(1 << 6)
+#define FATTR_ATIME_NOW	(1 << 7)
+#define FATTR_MTIME_NOW	(1 << 8)
 
 /**
  * Flags returned by the OPEN request

--
