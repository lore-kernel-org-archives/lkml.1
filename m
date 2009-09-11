Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZIKF0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZIKF0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZIKF0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZIKF0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:26:36 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/8] fanotify: merge notification events with different masks
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Cc: davem@davemloft.net, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Date: Fri, 11 Sep 2009 01:26:28 -0400
Message-ID: <20090911052627.32359.29485.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of just merging fanotify events if they are exactly the same, merge
notification events with different masks.  To do this we have to clone the
old event, update the mask in the new event with the new merged mask, and
put the new event in place of the old event.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index f054300..40ee137 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -10,8 +10,7 @@
 
 static bool try_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 {
-	if ((old->mask == new->mask) &&
-	    (old->to_tell == new->to_tell) &&
+	if ((old->to_tell == new->to_tell) &&
 	    (old->data_type == new->data_type)) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_PATH):
@@ -29,15 +28,28 @@ static bool try_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 
 static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 {
-	struct fsnotify_event_holder *holder;
+	struct fsnotify_event_holder *test_holder, *prev;
 	struct fsnotify_event *test_event;
+	struct fsnotify_event *new_event;
+	int ret;
 
 	/* and the list better be locked by something too! */
 
-	list_for_each_entry_reverse(holder, list, event_list) {
-		test_event = holder->event;
-		if (try_merge(test_event, event))
+	list_for_each_entry_safe_reverse(test_holder, prev, list, event_list) {
+		test_event = test_holder->event;
+		if (try_merge(test_event, event)) {
+			if (test_event->mask == event->mask)
+				return -EEXIST;
+			new_event = fsnotify_clone_event(test_event);
+			if (!new_event)
+				return 0;
+			new_event->mask = (test_event->mask | event->mask);
+			ret = fsnotify_replace_event(test_holder, new_event);
+			fsnotify_put_event(new_event); /* matches the ref from clone */
+			if (ret)
+				return ret;
 			return -EEXIST;
+		}
 	}
 
 	return 0;

