Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJNU4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJNU4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbYJNUxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:53:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37823 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbYJNUwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:52:55 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 14/16] fanotify: send pid with fanotify notification events
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:52:44 -0400
Message-ID: <20081014205244.1057.94484.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
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
index d65db61..74e5d4d 100644
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
index a36bd6b..ab7744a 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -71,6 +71,7 @@ struct fanotify_event_metadata {
 	int32_t fd;
 	uint32_t mask;
 	uint64_t cookie;
+	pid_t pid;
 };
 
 /* fanotify getsockopt optvals */

