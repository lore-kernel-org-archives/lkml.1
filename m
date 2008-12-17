Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760171AbYLQFOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYLQFOl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbYLQFMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:12:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37067 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbYLQFMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:12:42 -0500
To: linux-audit@redhat.com
Subject: [PATCH 10/15] audit_update_lsm_rules() misses the audit_inode_hash[] ones
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoi8-0000EG-Tl@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:12:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/auditfilter.c |   77 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 9fd85a4..0febaa0 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1778,6 +1778,41 @@ unlock_and_return:
 	return result;
 }
 
+static int update_lsm_rule(struct audit_entry *entry)
+{
+	struct audit_entry *nentry;
+	struct audit_watch *watch;
+	struct audit_tree *tree;
+	int err = 0;
+
+	if (!security_audit_rule_known(&entry->rule))
+		return 0;
+
+	watch = entry->rule.watch;
+	tree = entry->rule.tree;
+	nentry = audit_dupe_rule(&entry->rule, watch);
+	if (IS_ERR(nentry)) {
+		/* save the first error encountered for the
+		 * return value */
+		err = PTR_ERR(nentry);
+		audit_panic("error updating LSM filters");
+		if (watch)
+			list_del(&entry->rule.rlist);
+		list_del_rcu(&entry->list);
+	} else {
+		if (watch) {
+			list_add(&nentry->rule.rlist, &watch->rules);
+			list_del(&entry->rule.rlist);
+		} else if (tree)
+			list_replace_init(&entry->rule.rlist,
+				     &nentry->rule.rlist);
+		list_replace_rcu(&entry->list, &nentry->list);
+	}
+	call_rcu(&entry->rcu, audit_free_rule_rcu);
+
+	return err;
+}
+
 /* This function will re-initialize the lsm_rule field of all applicable rules.
  * It will traverse the filter lists serarching for rules that contain LSM
  * specific filter fields.  When such a rule is found, it is copied, the
@@ -1785,42 +1820,24 @@ unlock_and_return:
  * updated rule. */
 int audit_update_lsm_rules(void)
 {
-	struct audit_entry *entry, *n, *nentry;
-	struct audit_watch *watch;
-	struct audit_tree *tree;
+	struct audit_entry *e, *n;
 	int i, err = 0;
 
 	/* audit_filter_mutex synchronizes the writers */
 	mutex_lock(&audit_filter_mutex);
 
 	for (i = 0; i < AUDIT_NR_FILTERS; i++) {
-		list_for_each_entry_safe(entry, n, &audit_filter_list[i], list) {
-			if (!security_audit_rule_known(&entry->rule))
-				continue;
-
-			watch = entry->rule.watch;
-			tree = entry->rule.tree;
-			nentry = audit_dupe_rule(&entry->rule, watch);
-			if (IS_ERR(nentry)) {
-				/* save the first error encountered for the
-				 * return value */
-				if (!err)
-					err = PTR_ERR(nentry);
-				audit_panic("error updating LSM filters");
-				if (watch)
-					list_del(&entry->rule.rlist);
-				list_del_rcu(&entry->list);
-			} else {
-				if (watch) {
-					list_add(&nentry->rule.rlist,
-						 &watch->rules);
-					list_del(&entry->rule.rlist);
-				} else if (tree)
-					list_replace_init(&entry->rule.rlist,
-						     &nentry->rule.rlist);
-				list_replace_rcu(&entry->list, &nentry->list);
-			}
-			call_rcu(&entry->rcu, audit_free_rule_rcu);
+		list_for_each_entry_safe(e, n, &audit_filter_list[i], list) {
+			int res = update_lsm_rule(e);
+			if (!err)
+				err = res;
+		}
+	}
+	for (i=0; i< AUDIT_INODE_BUCKETS; i++) {
+		list_for_each_entry_safe(e, n, &audit_inode_hash[i], list) {
+			int res = update_lsm_rule(e);
+			if (!err)
+				err = res;
 		}
 	}
 
-- 
1.5.6.5


