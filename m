Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYJNU6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYJNU6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYJNUxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:53:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250AbYJNUxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:53:22 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 15/16] fanotify: send tgid with notification messages
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:52:49 -0400
Message-ID: <20081014205249.1057.12197.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
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
index 74e5d4d..b45c145 100644
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
index ab7744a..711efa6 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -72,6 +72,7 @@ struct fanotify_event_metadata {
 	uint32_t mask;
 	uint64_t cookie;
 	pid_t pid;
+	pid_t tgid;
 };
 
 /* fanotify getsockopt optvals */

