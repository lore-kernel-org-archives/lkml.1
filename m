Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYKLQRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYKLQRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKLQMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45446 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbYKLQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:23 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 16/21] fanotify: send file f_flags along with
	notifications
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:51 -0500
Message-ID: <20081112161151.25434.9535.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify listeners may be interested in what flags the file associated with
a particular event were set.  This sends f_flags along with the event
metadata.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h     |    1 +
 fs/notify/notification.c |    2 ++
 include/linux/fanotify.h |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index e6d7898..2721da2 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -50,6 +50,7 @@ struct fanotify_event {
 	unsigned long cookie;
 	pid_t pid;		/* pid of the original process */
 	pid_t tgid;		/* tgid of the original process */
+	unsigned int f_flags;	/* f_flags from the original file */
 	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index acd13b0..4d1d046 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -183,6 +183,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 
 	event->pid = current->pid;
 	event->tgid = current->tgid;
+	event->f_flags = file->f_flags;
 
 	WARN_ON(!event->path.dentry);
 	WARN_ON(!event->path.mnt);
@@ -250,6 +251,7 @@ int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event
 	data->cookie = event->cookie;
 	data->pid = event->pid;
 	data->tgid = event->tgid;
+	data->f_flags = event->f_flags;
 
 	fanotify_put_event(event);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 6cbcfc3..14ad6f9 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -68,6 +68,7 @@ struct fanotify_event_metadata {
 	__u64 cookie;
 	pid_t pid;
 	pid_t tgid;
+	__u32 f_flags;
 }  __attribute__((packed));
 
 /* fanotify getsockopt optvals */

