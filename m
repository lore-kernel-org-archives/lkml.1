Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbYJNU5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbYJNU5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYJNUxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:53:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbYJNUxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:53:03 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 16/16] fanotify: send file f_flags along with notifications
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:52:54 -0400
Message-ID: <20081014205254.1057.26828.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
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
index b45c145..5f774bd 100644
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
index 711efa6..cecac79 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -73,6 +73,7 @@ struct fanotify_event_metadata {
 	uint64_t cookie;
 	pid_t pid;
 	pid_t tgid;
+	uint32_t f_flags;
 };
 
 /* fanotify getsockopt optvals */

