Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbZHIV7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbZHIV7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 17:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZHIV7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 17:59:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZHIV7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:59:36 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/5] fsnotify: use fsnotify_create_event to allocate the
	q_overflow event
To: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Sun, 09 Aug 2009 17:59:36 -0400
Message-ID: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently fsnotify defines a static fsnotify event which is sent when a
group overflows its allotted queue length.  This patch just allocates that
event from the event cache rather than defining it statically.  There is no
known reason that the current implementation is wrong, but this makes sure the
event is initialized and created like any other.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 5213685..4ab9243 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -56,7 +56,7 @@ static struct kmem_cache *fsnotify_event_holder_cachep;
  * it is needed.  It's refcnt is set 1 at kernel init time and will never
  * get set to 0 so it will never get 'freed'
  */
-static struct fsnotify_event q_overflow_event;
+static struct fsnotify_event *q_overflow_event;
 static atomic_t fsnotify_sync_cookie = ATOMIC_INIT(0);
 
 /**
@@ -193,7 +193,7 @@ alloc_holder:
 	mutex_lock(&group->notification_mutex);
 
 	if (group->q_len >= group->max_events) {
-		event = &q_overflow_event;
+		event = q_overflow_event;
 		/* sorry, no private data on the overflow event */
 		priv = NULL;
 	}
@@ -409,8 +409,11 @@ __init int fsnotify_notification_init(void)
 	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
 	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
 
-	initialize_event(&q_overflow_event);
-	q_overflow_event.mask = FS_Q_OVERFLOW;
+	q_overflow_event = fsnotify_create_event(NULL, FS_Q_OVERFLOW, NULL,
+						 FSNOTIFY_EVENT_NONE, NULL, 0,
+						 GFP_KERNEL);
+	if (!q_overflow_event)
+		panic("unable to allocate fsnotify q_overflow_event\n");
 
 	return 0;
 }

