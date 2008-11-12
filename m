Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbYKLQPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbYKLQPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYKLQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45423 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbYKLQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:10 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 14/21] fanotify: send pid with fanotify notification
	events
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:40 -0500
Message-ID: <20081112161140.25434.30284.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often things like AV scanners may want to allow access to 'bad' files
based on the process making the access help by sending the pid of the
originally acting process.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h     |    1 +
 fs/notify/notification.c |    3 +++
 include/linux/fanotify.h |    1 +
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 4f42a1f..55b0bab 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -48,6 +48,7 @@ struct fanotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	/* if waiting for a userspace access answer this is the cookie they will send back */
 	unsigned long cookie;
+	pid_t pid;		/* pid of the original process */
 	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index dd0d2db..da2045a 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -181,6 +181,8 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->cookie = 0;
 	event->mask = mask;
 
+	event->pid = current->pid;
+
 	WARN_ON(!event->path.dentry);
 	WARN_ON(!event->path.mnt);
 
@@ -245,6 +247,7 @@ int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event
 	data->fd = client_fd;
 	data->mask = event->mask;
 	data->cookie = event->cookie;
+	data->pid = event->pid;
 
 	fanotify_put_event(event);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index b01309e..a5cded3 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -66,6 +66,7 @@ struct fanotify_event_metadata {
 	__s32 fd;
 	__u32 mask;
 	__u64 cookie;
+	pid_t pid;
 }  __attribute__((packed));
 
 /* fanotify getsockopt optvals */

