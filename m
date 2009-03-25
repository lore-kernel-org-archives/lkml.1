Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZCYERz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZCYERz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZCYERG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:17:06 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15794 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbZCYERD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:17:03 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 3/3] sysfs: care-free suicide for sysfs files
To: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 22:17:02 -0600
Message-ID: <20090325041702.15921.59355.stgit@bob.kio>
In-Reply-To: <20090325035707.15921.42150.stgit@bob.kio>
References: <20090325035707.15921.42150.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Life can be weary and some sysfs files choose to commit suicide (kills
itself when written to).  This is troublesome because while a sysfs
file is being accessed, the accessing task holds active references to
the node and its parent.  Removing a sysfs node waits for active
references to be drained.  The suicidal thread ends up waiting for its
own active reference and thus is sadly forced to live till the end of
the time.

Till now, this has been dealt with by requiring suicidal node to ask
someone else (workqueue) to kill it.  In recognition of the
inhumanitarian nature of this solution, this patch implements care-free
suicide support.

Suicide attempt is automagically detected and the active references
the suiciding task is holding are put early to avoid the above
described deadlock.  Module unload is inhibited till the sysfs file
access is complete to avoid freeing the code region too early.

This patch only implements care-free suicide support.  The next patch
will convert the users.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 fs/sysfs/dir.c   |    2 ++
 fs/sysfs/file.c  |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/sysfs/sysfs.h |    2 +-
 3 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 39320a5..993edd1 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -583,6 +583,8 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		sd->s_sibling = NULL;
 
 		sysfs_drop_dentry(sd);
+		if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
+			sysfs_file_check_suicide(sd);
 		sysfs_deactivate(sd);
 		sysfs_put(sd);
 	}
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index bf93b58..7bd29cc 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -59,6 +59,8 @@ struct sysfs_buffer {
 	int			needs_read_fill;
 	int			event;
 	struct list_head	list;
+	struct task_struct      *accessor;
+	int                     committed_suicide;
 };
 
 static atomic_t module_unload_inhibit_cnt = ATOMIC_INIT(0);
@@ -130,6 +132,57 @@ static void module_allow_unload(void)
 }
 
 /**
+ *	sysfs_file_check_suicide - check whether a file is trying to kill itself
+ *	@sd: sysfs_dirent of interest
+ *
+ *	Check whether @sd is trying to commit suicide.  If so, help it
+ *	by putting active references early such that deactivation
+ *	doesn't deadlock waiting for its own active references.
+ *
+ *	This works because a leaf node is always removed before its
+ *	parent.  By the time deactivation is called on the parent, the
+ *	suiciding node has already put the active references to itself
+ *	and the parent.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void sysfs_file_check_suicide(struct sysfs_dirent *sd)
+{
+	struct sysfs_open_dirent *od;
+	struct sysfs_buffer *buffer;
+
+	spin_lock(&sysfs_open_dirent_lock);
+
+	od = sd->s_attr.open;
+	if (od) {
+		list_for_each_entry(buffer, &od->buffers, list) {
+			if (buffer->accessor != current)
+				continue;
+
+			/* it's trying to commit suicide, help it */
+
+			/* Inhibit unload till the suiciding method is
+			 * complete.  This is to avoid premature
+			 * unload of the owner of the suiciding
+			 * method.
+			 */
+			module_inhibit_unload();
+
+			/* Global unload inhibition in effect, safe to
+			 * put active references.
+			 */
+			sysfs_put_active_two(sd);
+			buffer->committed_suicide = 1;
+
+			break;
+		}
+	}
+
+	spin_unlock(&sysfs_open_dirent_lock);
+}
+
+/**
  *	fill_read_buffer - allocate and fill buffer from object.
  *	@dentry:	dentry pointer.
  *	@buffer:	data buffer for file.
@@ -158,9 +211,14 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 		return -ENODEV;
 
 	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
+	buffer->accessor = current;
+
 	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
 
-	sysfs_put_active_two(attr_sd);
+	if (buffer->committed_suicide)
+		module_allow_unload();
+	else
+		sysfs_put_active_two(attr_sd);
 
 	/*
 	 * The code works fine with PAGE_SIZE return but it's likely to
@@ -275,9 +333,13 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
+	buffer->accessor = current;
 	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
 
-	sysfs_put_active_two(attr_sd);
+	if (buffer->committed_suicide)
+		module_allow_unload();
+	else
+		sysfs_put_active_two(attr_sd);
 
 	return rc;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 5d9b340..d44603c 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -155,7 +155,7 @@ int sysfs_inode_init(void);
 extern const struct file_operations sysfs_file_operations;
 extern int sysfs_module_callback(struct notifier_block *self, unsigned long val,
 				 void *data);
-
+void sysfs_file_check_suicide(struct sysfs_dirent *sd);
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
 		   const struct attribute *attr, int type);
 

