Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZHIWAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZHIWAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 18:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZHIWAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 18:00:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbZHIV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:59:58 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/5] fsnotify: use kmem_cache_zalloc to simplify event
	initialization
To: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Sun, 09 Aug 2009 17:59:59 -0400
Message-ID: <20090809215958.26204.11952.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
References: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify event initialization is done entry by entry with almost everything
set to either 0 or NULL.  Use kmem_cache_zalloc and only initialize things
that need non-zero initialization.  Also means we don't have to change
initialization entries based on the config options.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 4ab9243..96ffbd0 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -311,25 +311,14 @@ void fsnotify_flush_notify(struct fsnotify_group *group)
 
 static void initialize_event(struct fsnotify_event *event)
 {
-	event->holder.event = NULL;
 	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
 
 	spin_lock_init(&event->lock);
 
-	event->path.dentry = NULL;
-	event->path.mnt = NULL;
-	event->inode = NULL;
 	event->data_type = FSNOTIFY_EVENT_NONE;
 
 	INIT_LIST_HEAD(&event->private_data_list);
-
-	event->to_tell = NULL;
-
-	event->file_name = NULL;
-	event->name_len = 0;
-
-	event->sync_cookie = 0;
 }
 
 /*
@@ -350,7 +339,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 {
 	struct fsnotify_event *event;
 
-	event = kmem_cache_alloc(fsnotify_event_cachep, gfp);
+	event = kmem_cache_zalloc(fsnotify_event_cachep, gfp);
 	if (!event)
 		return NULL;
 

