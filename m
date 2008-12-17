Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759464AbYLQFQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYLQFQF (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYLQFNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:13:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822AbYLQFNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:13:22 -0500
To: linux-audit@redhat.com
Subject: [PATCH 14/15] clean up audit_rule_{add,del} a bit
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoim-0000GY-UP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:13:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/auditfilter.c |   42 +++++++++++++++++-------------------------
 1 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 5d4edc6..e6e3829 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1114,12 +1114,16 @@ static void audit_inotify_unregister(struct list_head *in_list)
 /* Find an existing audit rule.
  * Caller must hold audit_filter_mutex to prevent stale rule data. */
 static struct audit_entry *audit_find_rule(struct audit_entry *entry,
-					   struct list_head *list)
+					   struct list_head **p)
 {
 	struct audit_entry *e, *found = NULL;
+	struct list_head *list;
 	int h;
 
-	if (entry->rule.watch) {
+	if (entry->rule.inode_f) {
+		h = audit_hash_ino(entry->rule.inode_f->val);
+		*p = list = &audit_inode_hash[h];
+	} else if (entry->rule.watch) {
 		/* we don't know the inode number, so must walk entire hash */
 		for (h = 0; h < AUDIT_INODE_BUCKETS; h++) {
 			list = &audit_inode_hash[h];
@@ -1130,6 +1134,8 @@ static struct audit_entry *audit_find_rule(struct audit_entry *entry,
 				}
 		}
 		goto out;
+	} else {
+		*p = list = &audit_filter_list[entry->rule.listnr];
 	}
 
 	list_for_each_entry(e, list, list)
@@ -1274,14 +1280,13 @@ static u64 prio_low = ~0ULL/2;
 static u64 prio_high = ~0ULL/2 - 1;
 
 /* Add rule to given filterlist if not a duplicate. */
-static inline int audit_add_rule(struct audit_entry *entry,
-				 struct list_head *list)
+static inline int audit_add_rule(struct audit_entry *entry)
 {
 	struct audit_entry *e;
-	struct audit_field *inode_f = entry->rule.inode_f;
 	struct audit_watch *watch = entry->rule.watch;
 	struct audit_tree *tree = entry->rule.tree;
 	struct nameidata *ndp = NULL, *ndw = NULL;
+	struct list_head *list;
 	int h, err;
 #ifdef CONFIG_AUDITSYSCALL
 	int dont_count = 0;
@@ -1292,13 +1297,8 @@ static inline int audit_add_rule(struct audit_entry *entry,
 		dont_count = 1;
 #endif
 
-	if (inode_f) {
-		h = audit_hash_ino(inode_f->val);
-		list = &audit_inode_hash[h];
-	}
-
 	mutex_lock(&audit_filter_mutex);
-	e = audit_find_rule(entry, list);
+	e = audit_find_rule(entry, &list);
 	mutex_unlock(&audit_filter_mutex);
 	if (e) {
 		err = -EEXIST;
@@ -1372,15 +1372,14 @@ error:
 }
 
 /* Remove an existing rule from filterlist. */
-static inline int audit_del_rule(struct audit_entry *entry,
-				 struct list_head *list)
+static inline int audit_del_rule(struct audit_entry *entry)
 {
 	struct audit_entry  *e;
-	struct audit_field *inode_f = entry->rule.inode_f;
 	struct audit_watch *watch, *tmp_watch = entry->rule.watch;
 	struct audit_tree *tree = entry->rule.tree;
+	struct list_head *list;
 	LIST_HEAD(inotify_list);
-	int h, ret = 0;
+	int ret = 0;
 #ifdef CONFIG_AUDITSYSCALL
 	int dont_count = 0;
 
@@ -1390,13 +1389,8 @@ static inline int audit_del_rule(struct audit_entry *entry,
 		dont_count = 1;
 #endif
 
-	if (inode_f) {
-		h = audit_hash_ino(inode_f->val);
-		list = &audit_inode_hash[h];
-	}
-
 	mutex_lock(&audit_filter_mutex);
-	e = audit_find_rule(entry, list);
+	e = audit_find_rule(entry, &list);
 	if (!e) {
 		mutex_unlock(&audit_filter_mutex);
 		ret = -ENOENT;
@@ -1603,8 +1597,7 @@ int audit_receive_filter(int type, int pid, int uid, int seq, void *data,
 		if (IS_ERR(entry))
 			return PTR_ERR(entry);
 
-		err = audit_add_rule(entry,
-				     &audit_filter_list[entry->rule.listnr]);
+		err = audit_add_rule(entry);
 		audit_log_rule_change(loginuid, sessionid, sid, "add",
 				      &entry->rule, !err);
 
@@ -1620,8 +1613,7 @@ int audit_receive_filter(int type, int pid, int uid, int seq, void *data,
 		if (IS_ERR(entry))
 			return PTR_ERR(entry);
 
-		err = audit_del_rule(entry,
-				     &audit_filter_list[entry->rule.listnr]);
+		err = audit_del_rule(entry);
 		audit_log_rule_change(loginuid, sessionid, sid, "remove",
 				      &entry->rule, !err);
 
-- 
1.5.6.5


