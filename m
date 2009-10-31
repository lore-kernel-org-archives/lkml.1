Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbZJaSsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbZJaSsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933162AbZJaSsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933166AbZJaSsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:48:03 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 07/10] fanotify: fanotify_init syscall implementation
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:48:00 -0400
Message-ID: <20091031184800.17244.28267.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAME
	fanotify_init - initialize an fanotify group

SYNOPSIS
	int fanotify_init(unsigned int flags, unsigned int event_f_flags, int priority);

DESCRIPTION
	fanotify_init() initializes a new fanotify instance and returns a file
	descriptor associated with the new fanotify event queue.

	The following values can be OR'd into the flags field:

	FAN_NONBLOCK Set the O_NONBLOCK file status flag on the new open file description.
		Using this flag saves extra calls to fcntl(2) to achieve the same
		result.

	FAN_CLOEXEC Set the close-on-exec (FD_CLOEXEC) flag on the new file descriptor.
		See the description of the O_CLOEXEC flag in open(2) for reasons why
		this may be useful.

	The event_f_flags argument is unused and must be set to 0

	The priority argument is unused and must be set to 0

RETURN VALUE
	On success, this system call return a new file descriptor. On error, -1 is
	returned, and errno is set to indicate the error.

ERRORS
	EINVAL An invalid value was specified in flags.

	EINVAL A non-zero valid was passed in event_f_flags or in priority

	ENFILE The system limit on the total number of file descriptors has been reached.

	ENOMEM Insufficient kernel memory is available.

CONFORMING TO
	These system calls are Linux-specific.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.h      |    2 +
 fs/notify/fanotify/fanotify_user.c |   61 +++++++++++++++++++++++++++++++++++-
 include/linux/fanotify.h           |    4 ++
 3 files changed, 66 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 50765eb..dd656cf 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -4,6 +4,8 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+extern const struct fsnotify_ops fanotify_fsnotify_ops;
+
 static inline bool fanotify_mask_valid(__u32 mask)
 {
 	if (mask & ~((__u32)FAN_ALL_INCOMING_EVENTS))
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ca35276..9ca7413 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1,13 +1,72 @@
 #include <linux/fcntl.h>
 #include <linux/fs.h>
+#include <linux/anon_inodes.h>
 #include <linux/fsnotify_backend.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 
 #include "fanotify.h"
 
+static int fanotify_release(struct inode *ignored, struct file *file)
+{
+	struct fsnotify_group *group = file->private_data;
+
+	pr_debug("%s: file=%p group=%p\n", __func__, file, group);
+
+	/* matches the fanotify_init->fsnotify_alloc_group */
+	fsnotify_put_group(group);
+
+	return 0;
+}
+
+static const struct file_operations fanotify_fops = {
+	.poll		= NULL,
+	.read		= NULL,
+	.fasync		= NULL,
+	.release	= fanotify_release,
+	.unlocked_ioctl	= NULL,
+	.compat_ioctl	= NULL,
+};
+
+/* fanotify syscalls */
 SYSCALL_DEFINE3(fanotify_init, unsigned int, flags, unsigned int, event_f_flags,
 		int, priority)
 {
-	return -ENOSYS;
+	struct fsnotify_group *group;
+	int f_flags, fd;
+
+	pr_debug("%s: flags=%d event_f_flags=%d priority=%d\n",
+		__func__, flags, event_f_flags, priority);
+
+	if (event_f_flags)
+		return -EINVAL;
+	if (priority)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (flags & ~FAN_ALL_INIT_FLAGS)
+		return -EINVAL;
+
+	f_flags = (O_RDONLY | FMODE_NONOTIFY);
+	if (flags & FAN_CLOEXEC)
+		f_flags |= O_CLOEXEC;
+	if (flags & FAN_NONBLOCK)
+		f_flags |= O_NONBLOCK;
+
+	/* fsnotify_alloc_group takes a ref.  Dropped in fanotify_release */
+	group = fsnotify_alloc_group(&fanotify_fsnotify_ops);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
+
+	fd = anon_inode_getfd("[fanotify]", &fanotify_fops, group, f_flags);
+	if (fd < 0)
+		goto out_put_group;
+
+	return fd;
+
+out_put_group:
+	fsnotify_put_group(group);
+	return fd;
 }
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index b560f86..00bc6d4 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -18,6 +18,10 @@
 /* helper events */
 #define FAN_CLOSE		(FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE) /* close */
 
+#define FAN_CLOEXEC		0x00000001
+#define FAN_NONBLOCK		0x00000002
+
+#define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK)
 /*
  * All of the events - we build the list by hand so that we can add flags in
  * the future and not break backward compatibility.  Apps will get only the

