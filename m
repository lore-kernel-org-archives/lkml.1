Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYKLQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYKLQQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYKLQM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:12:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYKLQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:12:23 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 15/21] fanotify: send tgid with notification messages
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:11:45 -0500
Message-ID: <20081112161145.25434.24884.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send tgid of original process to fanotify listeners

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h     |    1 +
 fs/notify/notification.c |    2 ++
 include/linux/fanotify.h |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 55b0bab..e6d7898 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -49,6 +49,7 @@ struct fanotify_event {
 	/* if waiting for a userspace access answer this is the cookie they will send back */
 	unsigned long cookie;
 	pid_t pid;		/* pid of the original process */
+	pid_t tgid;		/* tgid of the original process */
 	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index da2045a..acd13b0 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -182,6 +182,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->mask = mask;
 
 	event->pid = current->pid;
+	event->tgid = current->tgid;
 
 	WARN_ON(!event->path.dentry);
 	WARN_ON(!event->path.mnt);
@@ -248,6 +249,7 @@ int fanotify_create_event_fd(struct fanotify_group *group, struct fanotify_event
 	data->mask = event->mask;
 	data->cookie = event->cookie;
 	data->pid = event->pid;
+	data->tgid = event->tgid;
 
 	fanotify_put_event(event);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index a5cded3..6cbcfc3 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -67,6 +67,7 @@ struct fanotify_event_metadata {
 	__u32 mask;
 	__u64 cookie;
 	pid_t pid;
+	pid_t tgid;
 }  __attribute__((packed));
 
 /* fanotify getsockopt optvals */

