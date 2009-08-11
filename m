Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbZHKQaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbZHKQaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZHKQaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZHKQaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:11 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/8] fsnotify: provide the data type to should_send_event
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:11 -0400
Message-ID: <20090811163011.8648.52886.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify is only interested in event types which contain enough information
to open the original file in the context of the fanotify listener.  Since
fanotify may not want to send events if that data isn't present we pass
the data type to the should_send_event function call so fanotify can express
its lack of interest.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c          |    3 ++-
 fs/notify/fsnotify.c                 |    2 +-
 fs/notify/inotify/inotify_fsnotify.c |    3 ++-
 include/linux/fsnotify_backend.h     |    3 ++-
 kernel/audit_tree.c                  |    3 ++-
 kernel/audit_watch.c                 |    3 ++-
 6 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 6b71be9..7e979fb 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -132,7 +132,8 @@ static int dnotify_handle_event(struct fsnotify_group *group,
  * userspace notification for that pair.
  */
 static bool dnotify_should_send_event(struct fsnotify_group *group,
-				      struct inode *inode, __u32 mask)
+				      struct inode *inode, __u32 mask,
+				      int data_type)
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 037e878..94a58ee 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -156,7 +156,7 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
 		if (test_mask & group->mask) {
-			if (!group->ops->should_send_event(group, to_tell, mask))
+			if (!group->ops->should_send_event(group, to_tell, mask, data_is))
 				continue;
 			if (!event) {
 				event = fsnotify_create_event(to_tell, mask, data,
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 47cd258..317998e 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -84,7 +84,8 @@ static void inotify_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnot
 	inotify_ignored_and_remove_idr(entry, group);
 }
 
-static bool inotify_should_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)
+static bool inotify_should_send_event(struct fsnotify_group *group, struct inode *inode,
+				      __u32 mask, int data_type)
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e252843..61aed0c 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -84,7 +84,8 @@ struct fsnotify_event_private_data;
  *		valid group and inode to use to clean up.
  */
 struct fsnotify_ops {
-	bool (*should_send_event)(struct fsnotify_group *group, struct inode *inode, __u32 mask);
+	bool (*should_send_event)(struct fsnotify_group *group, struct inode *inode,
+				  __u32 mask, int data_type);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 184ca3f..c15af4a 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -958,7 +958,8 @@ static void audit_tree_freeing_mark(struct fsnotify_mark_entry *entry, struct fs
 	fsnotify_put_mark(entry);
 }
 
-static bool audit_tree_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)
+static bool audit_tree_send_event(struct fsnotify_group *group, struct inode *inode,
+				  __u32 mask, int data_type)
 {
 	return 0;
 }
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index aa8babc..fa37460 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -504,7 +504,8 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 	}
 }
 
-static bool audit_watch_should_send_event(struct fsnotify_group *group, struct inode *inode, __u32 mask)
+static bool audit_watch_should_send_event(struct fsnotify_group *group, struct inode *inode,
+					  __u32 mask, int data_type)
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;

