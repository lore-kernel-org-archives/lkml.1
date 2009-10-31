Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbZJaSrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbZJaSrk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933157AbZJaSrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154AbZJaSrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:47:37 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 03/10] fanotify:drop notification if they exist in the
	outgoing queue
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:47:35 -0400
Message-ID: <20091031184734.17244.83857.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify listeners get an open file descriptor to the object in question so
the ordering of operations is not as important as in other notification
systems.  inotify will drop events if the last event in the event FIFO is
the same as the current event.  This patch will drop fanotify events if
they are the same as another event anywhere in the event FIFO.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c |   45 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 3ffb9db..c35c117 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -6,6 +6,45 @@
 
 #include "fanotify.h"
 
+static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
+{
+	pr_debug("%s: old=%p new=%p\n", __func__, old, new);
+
+	if ((old->mask == new->mask) &&
+	    (old->to_tell == new->to_tell) &&
+	    (old->data_type == new->data_type)) {
+		switch (old->data_type) {
+		case (FSNOTIFY_EVENT_PATH):
+			if ((old->path.mnt == new->path.mnt) &&
+			    (old->path.dentry == new->path.dentry))
+				return true;
+		case (FSNOTIFY_EVENT_NONE):
+			return true;
+		default:
+			BUG();
+		};
+	}
+	return false;
+}
+
+static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
+{
+	struct fsnotify_event_holder *holder;
+	struct fsnotify_event *test_event;
+
+	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
+
+	/* and the list better be locked by something too! */
+
+	list_for_each_entry_reverse(holder, list, event_list) {
+		test_event = holder->event;
+		if (should_merge(test_event, event))
+			return -EEXIST;
+	}
+
+	return 0;
+}
+
 static int fanotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
 {
 	int ret;
@@ -21,8 +60,10 @@ static int fanotify_handle_event(struct fsnotify_group *group, struct fsnotify_e
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	ret = fsnotify_add_notify_event(group, event, NULL, NULL);
-
+	ret = fsnotify_add_notify_event(group, event, NULL, fanotify_merge);
+	/* -EEXIST means this event was merged with another, not that it was an error */
+	if (ret == -EEXIST)
+		ret = 0;
 	return ret;
 }
 

