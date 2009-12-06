Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbZLFH7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbZLFH7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZLFH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:59:47 -0500
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:50577 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298AbZLFH7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:59:42 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: stewb@linux-foundation.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC 1/5] vfs, support pathconf(3) with _PC_LINK_MAX
Date: Sun,  6 Dec 2009 16:58:59 +0900
Message-Id: <1260086343-8406-2-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pathconf(_PC_LINK_MAX) cannot get the correct value, since linux
kernel doesn't provide such interface. And the current implementation in
GLibc issues statfs(2) first and then returns the predefined value
(EXT2_LINK_MAX, etc) based upoin the filesystem type. But GLibc doesn't
support all filesystem types. ie. when the target filesystem is unknown
to pathconf(3), it will return LINUX_LINK_MAX (127).
For GLibc, there is no way except implementing this poor method.

This patch makes statfs(2) return the correct value via struct
statfs.f_spare[0].

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/compat.c            |    5 +++--
 fs/libfs.c             |    1 +
 fs/open.c              |    9 +++++++--
 include/linux/statfs.h |    6 ++++++
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6c19040..fd1d96b 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -246,7 +246,7 @@ static int put_compat_statfs(struct compat_statfs __user *ubuf, struct kstatfs *
 	    __put_user(kbuf->f_fsid.val[0], &ubuf->f_fsid.val[0]) ||
 	    __put_user(kbuf->f_fsid.val[1], &ubuf->f_fsid.val[1]) ||
 	    __put_user(kbuf->f_frsize, &ubuf->f_frsize) ||
-	    __put_user(0, &ubuf->f_spare[0]) || 
+	    __put_user(kbuf->f_linkmax, &ubuf->f_linkmax) || /* f_spare[0] */
 	    __put_user(0, &ubuf->f_spare[1]) || 
 	    __put_user(0, &ubuf->f_spare[2]) || 
 	    __put_user(0, &ubuf->f_spare[3]) || 
@@ -319,7 +319,8 @@ static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstat
 	    __put_user(kbuf->f_namelen, &ubuf->f_namelen) ||
 	    __put_user(kbuf->f_fsid.val[0], &ubuf->f_fsid.val[0]) ||
 	    __put_user(kbuf->f_fsid.val[1], &ubuf->f_fsid.val[1]) ||
-	    __put_user(kbuf->f_frsize, &ubuf->f_frsize))
+	    __put_user(kbuf->f_frsize, &ubuf->f_frsize) ||
+	    __put_user(kbuf->f_linkmax, &ubuf->f_linkmax)) /* f_spare[0] */
 		return -EFAULT;
 	return 0;
 }
diff --git a/fs/libfs.c b/fs/libfs.c
index 219576c..1a078dd 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -28,6 +28,7 @@ int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = dentry->d_sb->s_magic;
 	buf->f_bsize = PAGE_CACHE_SIZE;
 	buf->f_namelen = NAME_MAX;
+	buf->f_linkmax = LINK_MAX_UNLIMITED; /* cf. simple_link() */
 	return 0;
 }
 
diff --git a/fs/open.c b/fs/open.c
index 4f01e06..4ca513f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -39,6 +39,7 @@ int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		retval = -ENOSYS;
 		if (dentry->d_sb->s_op->statfs) {
 			memset(buf, 0, sizeof(*buf));
+			buf->f_linkmax = LINK_MAX_DEFAULT;
 			retval = security_sb_statfs(dentry);
 			if (retval)
 				return retval;
@@ -91,7 +92,9 @@ static int vfs_statfs_native(struct dentry *dentry, struct statfs *buf)
 		buf->f_fsid = st.f_fsid;
 		buf->f_namelen = st.f_namelen;
 		buf->f_frsize = st.f_frsize;
-		memset(buf->f_spare, 0, sizeof(buf->f_spare));
+		/* contain f_linkmax */
+		BUILD_BUG_ON(sizeof(buf->f_spare) < sizeof(st.f_spare));
+		memcpy(buf->f_spare, st.f_spare, sizeof(st.f_spare));
 	}
 	return 0;
 }
@@ -118,7 +121,9 @@ static int vfs_statfs64(struct dentry *dentry, struct statfs64 *buf)
 		buf->f_fsid = st.f_fsid;
 		buf->f_namelen = st.f_namelen;
 		buf->f_frsize = st.f_frsize;
-		memset(buf->f_spare, 0, sizeof(buf->f_spare));
+		/* contain f_linkmax */
+		BUILD_BUG_ON(sizeof(buf->f_spare) < sizeof(st.f_spare));
+		memcpy(buf->f_spare, st.f_spare, sizeof(st.f_spare));
 	}
 	return 0;
 }
diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index b34cc82..958b837 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -19,4 +19,10 @@ struct kstatfs {
 	long f_spare[5];
 };
 
+/* support pathconf(3) with _PC_LINK_MAX */
+#define f_linkmax		f_spare[0]
+#define LINK_MAX_UNLIMITED	(-1)	/* link(2) does not check i_nlink */
+#define LINK_MAX_UNSUPPORTED	1	/* hardlink is unavailable */
+#define LINK_MAX_DEFAULT	127	/* compatibility to glibc */
+
 #endif
-- 
1.6.1.284.g5dc13

