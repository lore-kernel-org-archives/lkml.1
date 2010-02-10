Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0BJJaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:30:13 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:21269 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0BJJ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:29:23 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, mfasheh@suse.com
Subject: [PATCH 02/11] ocfs2_dlmfs: Use poll() to signify BASTs.
Date: Wed, 10 Feb 2010 01:27:45 -0800
Message-Id: <1265794074-19539-3-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B727C6E.001B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o2dlm's userspace filesystem is an easy way to use the DLM from
userspace.  It is intentionally simple. For example, it does not allow
for asynchronous behavior or lock conversion.  This is intentional to
keep the interface simple.

Because there is no asynchronous notification, there is no way for a
process holding a lock to know another node needs the lock.  This is the
number one complaint of ocfs2_dlmfs users.  Turns out, we can solve this
very easily.  We add poll() support to ocfs2_dlmfs.  When a BAST is
received, the lock's file descriptor will receive POLLIN.

This is trivial to implement.  Userdlm already has an appropriate
waitqueue, and the lock knows when it is blocked.

We add the "bast" capability to tell userspace this is available.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlm/dlmfs.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 77d0df4..ddf55da 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/backing-dev.h>
+#include <linux/poll.h>
 
 #include <asm/uaccess.h>
 
@@ -98,8 +99,12 @@ static const struct dlm_protocol_version user_locking_protocol = {
  * The ABI features are local to this machine's dlmfs mount.  This is
  * distinct from the locking protocol, which is concerned with inter-node
  * interaction.
+ *
+ * Capabilities:
+ * - bast	: POLLIN against the file descriptor of a held lock
+ *		  signifies a bast fired on the lock.
  */
-#define DLMFS_CAPABILITIES ""
+#define DLMFS_CAPABILITIES "bast"
 extern int param_set_dlmfs_capabilities(const char *val,
 					struct kernel_param *kp)
 {
@@ -215,6 +220,22 @@ static int dlmfs_file_release(struct inode *inode,
 	return 0;
 }
 
+static unsigned int dlmfs_file_poll(struct file *file, poll_table *wait)
+{
+	int event = 0;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct dlmfs_inode_private *ip = DLMFS_I(inode);
+
+	poll_wait(file, &ip->ip_lockres.l_event, wait);
+
+	spin_lock(&ip->ip_lockres.l_lock);
+	if (ip->ip_lockres.l_flags & USER_LOCK_BLOCKED)
+		event = POLLIN | POLLRDNORM;
+	spin_unlock(&ip->ip_lockres.l_lock);
+
+	return event;
+}
+
 static ssize_t dlmfs_file_read(struct file *filp,
 			       char __user *buf,
 			       size_t count,
@@ -585,6 +606,7 @@ static int dlmfs_fill_super(struct super_block * sb,
 static const struct file_operations dlmfs_file_operations = {
 	.open		= dlmfs_file_open,
 	.release	= dlmfs_file_release,
+	.poll		= dlmfs_file_poll,
 	.read		= dlmfs_file_read,
 	.write		= dlmfs_file_write,
 };
-- 
1.6.6.1

