Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZFDJW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZFDJW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZFDJWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:22:19 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43054 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbZFDJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:22:17 -0400
To: avati@gluster.com
CC: miklos@szeredi.hu, muirj@nortel.com, csaba@gluster.com,
       fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, dl-hacking@gluster.com
In-reply-to: <1119562997.1044731244033504415.JavaMail.root@mb1> (message from
	Anand Avati on Wed, 3 Jun 2009 07:51:44 -0500 (CDT))
Subject: Re: [PATCH] fuse: cache invalidation calls
References: <1119562997.1044731244033504415.JavaMail.root@mb1>
Message-Id: <E1MC99F-0004l5-JF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Jun 2009 11:22:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Anand Avati wrote:
> I was wondering how the userland libfuse would be made aware of the
> presence of these two notification features?

Here's a patch against fuse CVS.  It's also from John Muir.

I'm still thinking a bit about the API, how it would work in the
presence of stacked filesystems or multiple channels.

Thanks,
Miklos


Index: fuse/include/fuse_kernel.h
===================================================================
--- fuse.orig/include/fuse_kernel.h	2009-06-04 11:09:56.000000000 +0200
+++ fuse/include/fuse_kernel.h	2009-06-04 11:10:11.000000000 +0200
@@ -51,6 +51,8 @@
  *  - add IOCTL message
  *  - add unsolicited notification support
  *  - add POLL message and NOTIFY_POLL notification
+ *  - add notification messages for invalidation of inodes and
+ *    directory entries
  */
 
 #ifndef _LINUX_FUSE_H
@@ -58,6 +60,7 @@
 
 #include <sys/types.h>
 #define __u64 uint64_t
+#define __s64 int64_t
 #define __u32 uint32_t
 #define __s32 int32_t
 
@@ -243,6 +246,8 @@ enum fuse_opcode {
 
 enum fuse_notify_code {
 	FUSE_NOTIFY_POLL   = 1,
+	FUSE_NOTIFY_INVAL_INODE = 2,
+	FUSE_NOTIFY_INVAL_ENTRY = 3,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -506,4 +511,16 @@ struct fuse_dirent {
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
 
+struct fuse_notify_inval_inode_out {
+	__u64	ino;
+	__s64	off;
+	__s64	len;
+};
+
+struct fuse_notify_inval_entry_out {
+	__u64	parent;
+	__u32	namelen;
+	__u32	padding;
+};
+
 #endif /* _LINUX_FUSE_H */
Index: fuse/include/fuse_lowlevel.h
===================================================================
--- fuse.orig/include/fuse_lowlevel.h	2009-06-04 11:09:56.000000000 +0200
+++ fuse/include/fuse_lowlevel.h	2009-06-04 11:10:11.000000000 +0200
@@ -1136,6 +1136,32 @@ int fuse_reply_poll(fuse_req_t req, unsi
  */
 int fuse_lowlevel_notify_poll(struct fuse_pollhandle *ph);
 
+/**
+ * Notify to invalidate cache for an inode
+ *
+ * @param ch the channel through which to send the invalidation
+ * @param ino the inode number
+ * @param off the offset in the inode where to start invalidating
+ *            or negative to invalidate attributes only
+ * @param len the amount of cache to invalidate or 0 for all
+ * @return zero for success, -errno for failure
+ */
+int fuse_lowlevel_notify_inval_inode(struct fuse_chan *ch, fuse_ino_t ino,
+                                     off_t off, off_t len);
+
+/**
+ * Notify to invalidate parent attributes and the dentry matching
+ * parent/name
+ *
+ * @param ch the channel through which to send the invalidation
+ * @param parent inode number
+ * @param name file name
+ * @param namelen strlen() of file name
+ * @return zero for success, -errno for failure
+ */
+int fuse_lowlevel_notify_inval_entry(struct fuse_chan *ch, fuse_ino_t parent,
+                                     const char *name, size_t namelen);
+
 /* ----------------------------------------------------------- *
  * Utility functions					       *
  * ----------------------------------------------------------- */
@@ -1340,6 +1366,14 @@ void fuse_session_reset(struct fuse_sess
 int fuse_session_exited(struct fuse_session *se);
 
 /**
+ * Get the user data provided to the session
+ *
+ * @param se the session
+ * @return the user data
+ */
+void *fuse_session_data(struct fuse_session *se);
+
+/**
  * Enter a single threaded event loop
  *
  * @param se the session
Index: fuse/lib/fuse_lowlevel.c
===================================================================
--- fuse.orig/lib/fuse_lowlevel.c	2009-06-04 11:09:56.000000000 +0200
+++ fuse/lib/fuse_lowlevel.c	2009-06-04 11:10:11.000000000 +0200
@@ -1280,6 +1280,56 @@ int fuse_lowlevel_notify_poll(struct fus
 	}
 }
 
+int fuse_lowlevel_notify_inval_inode(struct fuse_chan *ch, fuse_ino_t ino,
+                                     off_t off, off_t len)
+{
+	struct fuse_notify_inval_inode_out outarg;
+	struct fuse_ll *f;
+	struct iovec iov[2];
+
+	if (!ch)
+		return -EINVAL;
+
+	f = (struct fuse_ll *)fuse_session_data(fuse_chan_session(ch));
+	if (!f)
+		return -ENODEV;
+
+	outarg.ino = ino;
+	outarg.off = off;
+	outarg.len = len;
+
+	iov[1].iov_base = &outarg;
+	iov[1].iov_len = sizeof(outarg);
+
+	return send_notify_iov(f, ch, FUSE_NOTIFY_INVAL_INODE, iov, 2);
+}
+
+int fuse_lowlevel_notify_inval_entry(struct fuse_chan *ch, fuse_ino_t parent,
+                                     const char *name, size_t namelen)
+{
+	struct fuse_notify_inval_entry_out outarg;
+	struct fuse_ll *f;
+	struct iovec iov[3];
+
+	if (!ch)
+		return -EINVAL;
+
+	f = (struct fuse_ll *)fuse_session_data(fuse_chan_session(ch));
+	if (!f)
+		return -ENODEV;
+
+	outarg.parent = parent;
+	outarg.namelen = namelen;
+	outarg.padding = 0;
+
+	iov[1].iov_base = &outarg;
+	iov[1].iov_len = sizeof(outarg);
+	iov[2].iov_base = (void *)name;
+	iov[2].iov_len = namelen + 1;
+
+	return send_notify_iov(f, ch, FUSE_NOTIFY_INVAL_ENTRY, iov, 3);
+}
+
 void *fuse_req_userdata(fuse_req_t req)
 {
 	return req->f->userdata;
Index: fuse/lib/fuse_session.c
===================================================================
--- fuse.orig/lib/fuse_session.c	2009-06-04 11:09:56.000000000 +0200
+++ fuse/lib/fuse_session.c	2009-06-04 11:10:11.000000000 +0200
@@ -121,6 +121,11 @@ int fuse_session_exited(struct fuse_sess
 		return se->exited;
 }
 
+void *fuse_session_data(struct fuse_session *se)
+{
+	return se->data;
+}
+
 static struct fuse_chan *fuse_chan_new_common(struct fuse_chan_ops *op, int fd,
 					      size_t bufsize, void *data,
 					      int compat)
Index: fuse/lib/fuse_versionscript
===================================================================
--- fuse.orig/lib/fuse_versionscript	2009-06-04 11:09:56.000000000 +0200
+++ fuse/lib/fuse_versionscript	2009-06-04 11:10:11.000000000 +0200
@@ -165,6 +165,8 @@ FUSE_2.8 {
 		fuse_reply_ioctl;
 		fuse_reply_ioctl_retry;
 		fuse_reply_poll;
+		fuse_lowlevel_notify_inval_inode;
+		fuse_lowlevel_notify_inval_entry;
 
 	local:
 		*;
