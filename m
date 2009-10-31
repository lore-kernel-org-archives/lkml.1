Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbZJaSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbZJaSrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933179AbZJaSrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:47:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157AbZJaSrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:47:45 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 04/10] fanotify: merge notification events with different masks
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:47:41 -0400
Message-ID: <20091031184741.17244.16660.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
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

 fs/notify/fanotify/fanotify.c |   39 ++++++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index c35c117..8e574d6 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -10,8 +10,7 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 {
 	pr_debug("%s: old=%p new=%p\n", __func__, old, new);
 
-	if ((old->mask == new->mask) &&
-	    (old->to_tell == new->to_tell) &&
+	if ((old->to_tell == new->to_tell) &&
 	    (old->data_type == new->data_type)) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_PATH):
@@ -29,20 +28,42 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 
 static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 {
-	struct fsnotify_event_holder *holder;
+	struct fsnotify_event_holder *test_holder;
 	struct fsnotify_event *test_event;
+	struct fsnotify_event *new_event;
+	int ret = 0;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 
 	/* and the list better be locked by something too! */
 
-	list_for_each_entry_reverse(holder, list, event_list) {
-		test_event = holder->event;
-		if (should_merge(test_event, event))
-			return -EEXIST;
+	list_for_each_entry_reverse(test_holder, list, event_list) {
+		test_event = test_holder->event;
+		if (should_merge(test_event, event)) {
+			ret = -EEXIST;
+
+			/* if they are exactly the same we are done */
+			if (test_event->mask == event->mask)
+				goto out;
+
+			/* can't allocate memory, merge was no possible */
+			new_event = fsnotify_clone_event(test_event);
+			if (unlikely(!new_event)) {
+				ret = 0;
+				goto out;
+			}
+
+			/* build new event and replace it on the list */
+			new_event->mask = (test_event->mask | event->mask);
+			fsnotify_replace_event(test_holder, new_event);
+			/* match ref from fsnotify_clone_event() */
+			fsnotify_put_event(new_event);
+
+			break;
+		}
 	}
-
-	return 0;
+out:
+	return ret;
 }
 
 static int fanotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)

