Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZHKQbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZHKQbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZHKQaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZHKQaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:17 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/8] fsnotify: include data in should_send calls
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:17 -0400
Message-ID: <20090811163017.8648.98116.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify is going to need to look at file->private_data to know if an event
should be sent or not.  This passes the data (which might be a file,
dentry, inode, or none) to the should_send function calls so fanotify can
get that information when available

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c          |    2 +-
 fs/notify/fsnotify.c                 |    3 ++-
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 include/linux/fsnotify_backend.h     |    2 +-
 kernel/audit_tree.c                  |    2 +-
 kernel/audit_watch.c                 |    2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 7e979fb..c28c38f 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -133,7 +133,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
  */
 static bool dnotify_should_send_event(struct fsnotify_group *group,
 				      struct inode *inode, __u32 mask,
-				      int data_type)
+				      void *data, int data_type)
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 94a58ee..b98be4a 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -156,7 +156,8 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 	idx = srcu_read_lock(&fsnotify_grp_srcu);
 	list_for_each_entry_rcu(group, &fsnotify_groups, group_list) {
 		if (test_mask & group->mask) {
-			if (!group->ops->should_send_event(group, to_tell, mask, data_is))
+			if (!group->ops->should_send_event(group, to_tell, mask,
+							   data, data_is))
 				continue;
 			if (!event) {
 				event = fsnotify_create_event(to_tell, mask, data,
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 317998e..743d8fa 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -85,7 +85,7 @@ static void inotify_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnot
 }
 
 static bool inotify_should_send_event(struct fsnotify_group *group, struct inode *inode,
-				      __u32 mask, int data_type)
+				      __u32 mask, void *data, int data_type)
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 61aed0c..2766df6 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -85,7 +85,7 @@ struct fsnotify_event_private_data;
  */
 struct fsnotify_ops {
 	bool (*should_send_event)(struct fsnotify_group *group, struct inode *inode,
-				  __u32 mask, int data_type);
+				  __u32 mask, void *data, int data_type);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index c15af4a..295c03c 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -959,7 +959,7 @@ static void audit_tree_freeing_mark(struct fsnotify_mark_entry *entry, struct fs
 }
 
 static bool audit_tree_send_event(struct fsnotify_group *group, struct inode *inode,
-				  __u32 mask, int data_type)
+				  __u32 mask, void *data, int data_type)
 {
 	return 0;
 }
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index fa37460..6056aca 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -505,7 +505,7 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 }
 
 static bool audit_watch_should_send_event(struct fsnotify_group *group, struct inode *inode,
-					  __u32 mask, int data_type)
+					  __u32 mask, void *data, int data_type)
 {
 	struct fsnotify_mark_entry *entry;
 	bool send;

