Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbXF3D0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbXF3D0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbXF3DY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:24:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50738 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbXF3DYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:24:54 -0400
Subject: [RFC PATCH 5/6] relay: add relay_kernel_read()
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Content-Type: text/plain
Date: Fri, 29 Jun 2007 22:24:17 -0500
Message-Id: <1183173857.24291.141.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a relay_kernel_read() function to relay, which allows
kernel clients to easily extract only the data (i.e. and skip over
padding) from a channel buffer.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 Documentation/filesystems/relay.txt |   14 ++++++
 include/linux/relay.h               |    5 ++
 kernel/relay.c                      |   79 ++++++++++++++++++++++++++++++++----
 3 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/relay.txt b/Documentation/filesystems/relay.txt
index d31113a..e9f10cf 100644
--- a/Documentation/filesystems/relay.txt
+++ b/Documentation/filesystems/relay.txt
@@ -185,6 +185,7 @@ TBD(curr. line MT:/API/)
 
     relay_buf_full(buf)
     subbuf_start_reserve(buf, length)
+    relay_kernel_read(rbuf, buffer, count, ppos)
 
 
 Creating a channel
@@ -446,6 +447,19 @@ closed.
 Misc
 ----
 
+relay_kernel_read() provides the same functionality as the userspace
+read(2) implementation, but instead of copying the relay buffer data
+to a buffer in user space, the data is copied to the supplied kernel
+buffer target.  As with user space read(), the sub-buffer padding is
+automatically removed from the output and is not seen by the reader.
+In the case of relay_kernel_read(), there is no file object associated
+with the reader, so it needs to supply a pointer to a ppos variable,
+which will be used to maintain the current read position instead.
+This is useful for applications that may want to provide an
+alternative interface to the relay buffer data or who want access to
+the buffer data without needing to know anything about buffer
+internals.
+
 Some applications may want to keep a channel around and re-use it
 rather than open and close a new channel for each use.  relay_reset()
 can be used for this purpose - it resets a channel to its initial
diff --git a/include/linux/relay.h b/include/linux/relay.h
index aca45fa..6caedef 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -181,6 +181,11 @@ extern int relay_buf_full(struct rchan_buf *buf);
 extern size_t relay_switch_subbuf(struct rchan_buf *buf,
 				  size_t length);
 
+extern ssize_t relay_kernel_read(struct rchan_buf *rbuf,
+				 char *buffer,
+				 size_t count,
+				 loff_t *ppos);
+
 /**
  *	relay_write - write data into the channel
  *	@chan: relay channel
diff --git a/kernel/relay.c b/kernel/relay.c
index 6806636..ed58ee6 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -987,6 +987,24 @@ static size_t relay_file_read_end_pos(struct rchan_buf *buf,
 	return end_pos;
 }
 
+/**
+ *     subbuf_kernel_read_actor - read up to one subbuf's worth of data
+ */
+static int subbuf_kernel_read_actor(size_t read_start,
+				    struct rchan_buf *buf,
+				    size_t avail,
+				    read_descriptor_t *desc,
+				    read_actor_t actor)
+{
+	void *from = buf->start + read_start;
+	memcpy(desc->arg.data, from, avail);
+	desc->arg.data += avail;
+	desc->written += avail;
+	desc->count -= avail;
+
+	return avail;
+}
+
 /*
  *	subbuf_read_actor - read up to one subbuf's worth of data
  */
@@ -1058,19 +1076,17 @@ typedef int (*subbuf_actor_t) (size_t read_start,
 /*
  *	relay_file_read_subbufs - read count bytes, bridging subbuf boundaries
  */
-static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
+static ssize_t relay_file_read_subbufs(struct rchan_buf *buf, loff_t *ppos,
 					subbuf_actor_t subbuf_actor,
 					read_actor_t actor,
 					read_descriptor_t *desc)
 {
-	struct rchan_buf *buf = filp->private_data;
 	size_t read_start, avail;
 	int ret;
 
 	if (!desc->count)
 		return 0;
 
-	mutex_lock(&filp->f_path.dentry->d_inode->i_mutex);
 	do {
 		if (!relay_file_read_avail(buf, *ppos))
 			break;
@@ -1090,23 +1106,62 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
 			*ppos = relay_file_read_end_pos(buf, read_start, ret);
 		}
 	} while (desc->count && ret);
-	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
 
 	return desc->written;
 }
 
+/**
+ *     relay_kernel_read - read relay buffer into kernel target buffer
+ *     @rbuf: the relay buffer struct
+ *     @buffer: the target kernel buffer
+ *     @count: number of bytes to read
+ *     @ppos: pointer to read position variable
+ *
+ *     Returns the number of bytes copied into buffer.
+ *
+ *     Performs the same function as user space read, except that
+ *     relay buffer contents are copied to the supplied kernel buffer
+ *     instead of a user space buffer.  The user must supply a ppos
+ *     variable, initialized to 0, which will be used to maintain the
+ *     current read position.
+ */
+ssize_t relay_kernel_read(struct rchan_buf *rbuf,
+			  char *buffer,
+			  size_t count,
+			  loff_t *ppos)
+{
+	read_descriptor_t desc;
+
+	desc.written = 0;
+	desc.count = count;
+	desc.arg.buf = buffer;
+	desc.error = 0;
+
+	return relay_file_read_subbufs(rbuf, ppos, subbuf_kernel_read_actor,
+				       NULL, &desc);
+}
+EXPORT_SYMBOL_GPL(relay_kernel_read);
+
 static ssize_t relay_file_read(struct file *filp,
 			       char __user *buffer,
 			       size_t count,
 			       loff_t *ppos)
 {
+	struct rchan_buf *rbuf = filp->private_data;
+	size_t ret;
 	read_descriptor_t desc;
+
 	desc.written = 0;
 	desc.count = count;
 	desc.arg.buf = buffer;
 	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_read_actor,
-				       NULL, &desc);
+
+	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
+	ret = relay_file_read_subbufs(rbuf, ppos, subbuf_read_actor,
+				      NULL, &desc);
+	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
+
+	return ret;
 }
 
 static ssize_t relay_file_sendfile(struct file *filp,
@@ -1115,13 +1170,21 @@ static ssize_t relay_file_sendfile(struct file *filp,
 				   read_actor_t actor,
 				   void *target)
 {
+	struct rchan_buf *rbuf = filp->private_data;
+	size_t ret;
 	read_descriptor_t desc;
+
 	desc.written = 0;
 	desc.count = count;
 	desc.arg.data = target;
 	desc.error = 0;
-	return relay_file_read_subbufs(filp, ppos, subbuf_send_actor,
-				       actor, &desc);
+
+	mutex_lock(&filp->f_dentry->d_inode->i_mutex);
+	ret = relay_file_read_subbufs(rbuf, ppos, subbuf_send_actor,
+				      actor, &desc);
+	mutex_unlock(&filp->f_dentry->d_inode->i_mutex);
+
+	return ret;
 }
 
 const struct file_operations relay_file_operations = {



