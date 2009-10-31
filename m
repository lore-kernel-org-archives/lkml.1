Return-Path: <linux-kernel-owner+w=401wt.eu-S933236AbZJaSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbZJaSsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbZJaSsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154AbZJaSsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:48:24 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 10/10] send events using read
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:48:19 -0400
Message-ID: <20091031184819.17244.55795.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 fs/notify/fanotify/fanotify.h      |    5 +
 fs/notify/fanotify/fanotify_user.c |  225 +++++++++++++++++++++++++++++++++++-
 include/linux/fanotify.h           |   24 ++++
 3 files changed, 250 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 59c3331..5608783 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -30,3 +30,8 @@ static inline bool fanotify_mask_valid(__u32 mask)
 		return false;
 	return true;
 }
+
+static inline __u32 fanotify_outgoing_mask(__u32 mask)
+{
+	return mask & FAN_ALL_OUTGOING_EVENTS;
+}
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index d415174..1fdd720 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -3,16 +3,208 @@
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/fsnotify_backend.h>
+#include <linux/ima.h>
 #include <linux/init.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/poll.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include <asm/ioctls.h>
 
 #include "fanotify.h"
 
 static struct kmem_cache *fanotify_mark_cache __read_mostly;
 
+/*
+ * Get an fsnotify notification event if one exists and is small
+ * enough to fit in "count". Return an error pointer if the count
+ * is not large enough.
+ *
+ * Called with the group->notification_mutex held.
+ */
+static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
+					    size_t count)
+{
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+
+	pr_debug("%s: group=%p count=%zd\n", __func__, group, count);
+
+	if (fsnotify_notify_queue_is_empty(group))
+		return NULL;
+
+	if (FAN_EVENT_METADATA_LEN > count)
+		return ERR_PTR(-EINVAL);
+
+	/* held the notification_mutex the whole time, so this is the
+	 * same event we peeked above */
+	return fsnotify_remove_notify_event(group);
+}
+
+static int create_and_fill_fd(struct fsnotify_group *group,
+			      struct fanotify_event_metadata *metadata,
+			      struct fsnotify_event *event)
+{
+	int client_fd, err;
+	struct dentry *dentry;
+	struct vfsmount *mnt;
+	struct file *new_file;
+
+	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__, group,
+		 metadata, event);
+
+	client_fd = get_unused_fd();
+	if (client_fd < 0)
+		return client_fd;
+
+	if (event->data_type != FSNOTIFY_EVENT_PATH) {
+		WARN_ON(1);
+		put_unused_fd(client_fd);
+		return -EINVAL;
+	}
+
+	/*
+	 * we need a new file handle for the userspace program so it can read even if it was
+	 * originally opened O_WRONLY.
+	 */
+	dentry = dget(event->path.dentry);
+	mnt = mntget(event->path.mnt);
+	/* it's possible this event was an overflow event.  in that case dentry and mnt
+	 * are NULL;  That's fine, just don't call dentry open */
+	if (dentry && mnt) {
+		err = ima_path_check(&event->path, MAY_READ, IMA_COUNT_UPDATE);
+		if (err)
+			new_file = ERR_PTR(err);
+		else
+			new_file = dentry_open(dentry, mnt,
+					       O_RDONLY | O_LARGEFILE | FMODE_NONOTIFY,
+					       current_cred());
+	} else
+		new_file = ERR_PTR(-EOVERFLOW);
+	if (IS_ERR(new_file)) {
+		/*
+		 * we still send an event even if we can't open the file.  this
+		 * can happen when say tasks are gone and we try to open their
+		 * /proc files or we try to open a WRONLY file like in sysfs
+		 * we just send the errno to userspace since there isn't much
+		 * else we can do.
+		 */
+		put_unused_fd(client_fd);
+		client_fd = PTR_ERR(new_file);
+	} else {
+		fd_install(client_fd, new_file);
+	}
+
+	metadata->fd = client_fd;
+
+	return 0;
+}
+
+static ssize_t fill_event_metadata(struct fsnotify_group *group,
+				   struct fanotify_event_metadata *metadata,
+				   struct fsnotify_event *event)
+{
+	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__,
+		 group, metadata, event);
+
+	metadata->event_len = FAN_EVENT_METADATA_LEN;
+	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->mask = fanotify_outgoing_mask(event->mask);
+
+	return create_and_fill_fd(group, metadata, event);
+
+}
+
+static ssize_t copy_event_to_user(struct fsnotify_group *group,
+				  struct fsnotify_event *event,
+				  char __user *buf)
+{
+	struct fanotify_event_metadata fanotify_event_metadata;
+	int ret;
+
+	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
+
+	ret = fill_event_metadata(group, &fanotify_event_metadata, event);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(buf, &fanotify_event_metadata, FAN_EVENT_METADATA_LEN))
+		return -EFAULT;
+
+	return FAN_EVENT_METADATA_LEN;
+}
+
+/* intofiy userspace file descriptor functions */
+static unsigned int fanotify_poll(struct file *file, poll_table *wait)
+{
+	struct fsnotify_group *group = file->private_data;
+	int ret = 0;
+
+	poll_wait(file, &group->notification_waitq, wait);
+	mutex_lock(&group->notification_mutex);
+	if (!fsnotify_notify_queue_is_empty(group))
+		ret = POLLIN | POLLRDNORM;
+	mutex_unlock(&group->notification_mutex);
+
+	return ret;
+}
+
+static ssize_t fanotify_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *pos)
+{
+	struct fsnotify_group *group;
+	struct fsnotify_event *kevent;
+	char __user *start;
+	int ret;
+	DEFINE_WAIT(wait);
+
+	start = buf;
+	group = file->private_data;
+
+	pr_debug("%s: group=%p\n", __func__, group);
+
+	while (1) {
+		prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&group->notification_mutex);
+		kevent = get_one_event(group, count);
+		mutex_unlock(&group->notification_mutex);
+
+		if (kevent) {
+			ret = PTR_ERR(kevent);
+			if (IS_ERR(kevent))
+				break;
+			ret = copy_event_to_user(group, kevent, buf);
+			fsnotify_put_event(kevent);
+			if (ret < 0)
+				break;
+			buf += ret;
+			count -= ret;
+			continue;
+		}
+
+		ret = -EAGAIN;
+		if (file->f_flags & O_NONBLOCK)
+			break;
+		ret = -EINTR;
+		if (signal_pending(current))
+			break;
+
+		if (start != buf)
+			break;
+
+		schedule();
+	}
+
+	finish_wait(&group->notification_waitq, &wait);
+	if (start != buf && ret != -EFAULT)
+		ret = buf - start;
+	return ret;
+}
+
 static int fanotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
@@ -25,13 +217,38 @@ static int fanotify_release(struct inode *ignored, struct file *file)
 	return 0;
 }
 
+static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct fsnotify_group *group;
+	struct fsnotify_event_holder *holder;
+	void __user *p;
+	int ret = -ENOTTY;
+	size_t send_len = 0;
+
+	group = file->private_data;
+
+	p = (void __user *) arg;
+
+	switch (cmd) {
+	case FIONREAD:
+		mutex_lock(&group->notification_mutex);
+		list_for_each_entry(holder, &group->notification_list, event_list)
+			send_len += FAN_EVENT_METADATA_LEN;
+		mutex_unlock(&group->notification_mutex);
+		ret = put_user(send_len, (int __user *) p);
+		break;
+	}
+
+	return ret;
+}
+
 static const struct file_operations fanotify_fops = {
-	.poll		= NULL,
-	.read		= NULL,
+	.poll		= fanotify_poll,
+	.read		= fanotify_read,
 	.fasync		= NULL,
 	.release	= fanotify_release,
-	.unlocked_ioctl	= NULL,
-	.compat_ioctl	= NULL,
+	.unlocked_ioctl	= fanotify_ioctl,
+	.compat_ioctl	= fanotify_ioctl,
 };
 
 static void fanotify_free_mark(struct fsnotify_mark *fsn_mark)
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 95aeea2..c1c6616 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -51,6 +51,30 @@
  */
 #define FAN_ALL_INCOMING_EVENTS	(FAN_ALL_EVENTS |\
 				 FAN_EVENT_ON_CHILD)
+
+#define FAN_ALL_OUTGOING_EVENTS	(FAN_ALL_EVENTS |\
+				 FAN_Q_OVERFLOW)
+
+#define FANOTIFY_METADATA_VERSION	1
+
+struct fanotify_event_metadata {
+	__u32 event_len;
+	__u32 vers;
+	__s32 fd;
+	__u64 mask;
+} __attribute__ ((packed));
+
+/* Helper functions to deal with fanotify_event_metadata buffers */
+#define FAN_EVENT_METADATA_LEN (sizeof(struct fanotify_event_metadata))
+
+#define FAN_EVENT_NEXT(meta, len) ((len) -= (meta)->event_len, \
+				   (struct fanotify_event_metadata*)(((char *)(meta)) + \
+				   (meta)->event_len))
+
+#define FAN_EVENT_OK(meta, len)	((long)(len) >= (long)FAN_EVENT_METADATA_LEN && \
+				(long)(meta)->event_len >= (long)FAN_EVENT_METADATA_LEN && \
+				(long)(meta)->event_len <= (long)(len))
+
 #ifdef __KERNEL__
 
 #endif /* __KERNEL__ */

