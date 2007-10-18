Return-Path: <linux-kernel-owner+w=401wt.eu-S1764369AbXJRKSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764369AbXJRKSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 06:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbXJRKSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 06:18:33 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:43955 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1764226AbXJRKSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:18:31 -0400
Message-ID: <4717312B.5050408@dev.rtsoft.ru>
Date: Thu, 18 Oct 2007 14:10:51 +0400
From: Dmitry Antipov <antipov@dev.rtsoft.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] SIGIO-driven I/O with inotify queues
Content-Type: multipart/mixed;
 boundary="------------030402080509010801060507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030402080509010801060507
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch proposes SIGIO-driven I/O for descriptors returned by
inotify_init(). The thing may be enabled by convenient
fcntl (fd, F_SETFL, O_ASYNC) call.

Dmitry


--------------030402080509010801060507
Content-Type: text/x-patch;
 name="2.6.23-inotify-fasync.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.23-inotify-fasync.patch"

Signed-off-by: Dmitry Antipov <antipov@dev.rtsoft.ru>

diff -ur -X /tmp/dontdiff .orig-2.6.23/fs/inotify_user.c 2.6.23/fs/inotify_user.c
--- .orig-2.6.23/fs/inotify_user.c	2007-10-10 00:31:38.000000000 +0400
+++ 2.6.23/fs/inotify_user.c	2007-10-18 14:06:38.000000000 +0400
@@ -78,6 +78,7 @@
 	atomic_t		count;		/* reference count */
 	struct user_struct	*user;		/* user who opened this dev */
 	struct inotify_handle	*ih;		/* inotify handle */
+	struct fasync_struct    *fa;            /* async notification */
 	unsigned int		queue_size;	/* size of the queue (bytes) */
 	unsigned int		event_count;	/* number of pending events */
 	unsigned int		max_events;	/* maximum number of events */
@@ -301,6 +302,7 @@
 	dev->queue_size += sizeof(struct inotify_event) + kevent->event.len;
 	list_add_tail(&kevent->list, &dev->events);
 	wake_up_interruptible(&dev->wq);
+	kill_fasync(&dev->fa, SIGIO, POLL_IN);
 
 out:
 	mutex_unlock(&dev->ev_mutex);
@@ -489,6 +491,13 @@
 	return ret;
 }
 
+static int inotify_fasync(int fd, struct file *file, int on)
+{
+	struct inotify_device *dev = file->private_data;
+
+	return fasync_helper(fd, file, on, &dev->fa) >= 0 ? 0 : -EIO;
+}
+
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct inotify_device *dev = file->private_data;
@@ -501,6 +510,9 @@
 		inotify_dev_event_dequeue(dev);
 	mutex_unlock(&dev->ev_mutex);
 
+	if (file->f_flags & FASYNC)
+		inotify_fasync(-1, file, 0);
+
 	/* free this device: the put matching the get in inotify_init() */
 	put_inotify_dev(dev);
 
@@ -529,6 +541,7 @@
 static const struct file_operations inotify_fops = {
 	.poll           = inotify_poll,
 	.read           = inotify_read,
+	.fasync         = inotify_fasync,
 	.release        = inotify_release,
 	.unlocked_ioctl = inotify_ioctl,
 	.compat_ioctl	= inotify_ioctl,
@@ -576,6 +589,7 @@
 		goto out_free_dev;
 	}
 	dev->ih = ih;
+	dev->fa = NULL;
 
 	filp->f_op = &inotify_fops;
 	filp->f_path.mnt = mntget(inotify_mnt);

--------------030402080509010801060507--
