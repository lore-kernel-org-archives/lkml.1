Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXITH1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXITH1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbXITH01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:23908 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759785AbXITH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=ByyPm1zIh/ReMCtjPqIUE5dYnIniH5bGhr4SWAaSRpZIQCzMz9AABK4A7WTAGXT4HEf2CP4ZOb9JFN7HY0gaQnVoLbn6STjedzbD13vUulG0HorDrSJpoHi3bz+pjNUWEay2bqulJbU7eHCrBkXjEYxLLaGg70tF+XGzybh/JUA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/4] sysfs: care-free suicide for sysfs files
In-Reply-To: <11902731752407-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:26:15 +0900
Message-Id: <11902731754189-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Life can be weary and some sysfs files choose to commit suicide (kills
itself when written to).  This is troublesome because while a sysfs
file is being accessed, the accessing task holds active references to
the node and its parent.  Removing a sysfs node waits for active
references to be drained.  The suicidal thread ends up waiting for its
own active reference and thus is sadly forced to live till the end of
the time.

Till now, this has been dealt with by requiring suicidal node to ask
someone else (workqueue) to kill it.  In recognition of the
inhumanitrian nature of this solution, this patch implements care-free
suicide support.

Suicide attempt is automagically detected and the active references
the suiciding task is holding are put early to avoid the above
described deadlock.  Module unload is inhibited till the sysfs file
access is complete to avoid freeing the code region too early.

This patch only implements care-free suicide support.  The next patch
will convert the users.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |    2 +
 fs/sysfs/file.c  |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index c902bdc..fe8270c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -546,6 +546,8 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		sd->s_sibling = NULL;
 
 		sysfs_drop_dentry(sd);
+		if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
+			sysfs_file_check_suicide(sd);
 		sysfs_deactivate(sd);
 		sysfs_put(sd);
 	}
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index c05f961..0460970 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -76,9 +76,62 @@ struct sysfs_buffer {
 	int			needs_read_fill;
 	int			event;
 	struct list_head	list;
+	struct task_struct	*accessor;
+	int			committed_suicide;
 };
 
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
@@ -107,9 +160,14 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
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
 
 	BUG_ON(count > (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
@@ -215,9 +273,14 @@ flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
+	buffer->accessor = current;
+
 	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
 
-	sysfs_put_active_two(attr_sd);
+	if (buffer->committed_suicide)
+		module_allow_unload();
+	else
+		sysfs_put_active_two(attr_sd);
 
 	return rc;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index be16947..58f517b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -142,6 +142,7 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
  */
 extern const struct file_operations sysfs_file_operations;
 
+void sysfs_file_check_suicide(struct sysfs_dirent *sd);
 int sysfs_add_file(struct sysfs_dirent *dir_sd,
 		   const struct attribute *attr, int type);
 
-- 
1.5.0.3


