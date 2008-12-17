Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759722AbYLQFP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbYLQFP0 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYLQFNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:13:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37070 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950AbYLQFND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:13:03 -0500
To: linux-audit@redhat.com
Subject: [PATCH 12/15] audit rules ordering, part 2
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoiS-0000FI-U8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:13:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the actual rule listing; add per-type lists _not_ used for matching,
with all exit,... sitting on one such list.  Simplifies "do something
for all rules" logics, while we are at it...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h |    1 +
 kernel/audit_tree.c   |    1 +
 kernel/auditfilter.c  |   95 ++++++++++++++++++++-----------------------------
 3 files changed, 41 insertions(+), 56 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index d28682c..4e37f06 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -371,6 +371,7 @@ struct audit_krule {
 	struct audit_watch	*watch;	/* associated watch */
 	struct audit_tree	*tree;	/* associated watched tree */
 	struct list_head	rlist;	/* entry in audit_{watch,tree}.rules list */
+	struct list_head	list;	/* for AUDIT_LIST* purposes only */
 	u64			prio;
 };
 
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 8b50944..48bddad 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -450,6 +450,7 @@ static void kill_rules(struct audit_tree *tree)
 			audit_log_end(ab);
 			rule->tree = NULL;
 			list_del_rcu(&entry->list);
+			list_del(&entry->rule.list);
 			call_rcu(&entry->rcu, audit_free_rule_rcu);
 		}
 	}
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 995a2e8..5d4edc6 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -86,6 +86,14 @@ struct list_head audit_filter_list[AUDIT_NR_FILTERS] = {
 #error Fix audit_filter_list initialiser
 #endif
 };
+static struct list_head audit_rules_list[AUDIT_NR_FILTERS] = {
+	LIST_HEAD_INIT(audit_rules_list[0]),
+	LIST_HEAD_INIT(audit_rules_list[1]),
+	LIST_HEAD_INIT(audit_rules_list[2]),
+	LIST_HEAD_INIT(audit_rules_list[3]),
+	LIST_HEAD_INIT(audit_rules_list[4]),
+	LIST_HEAD_INIT(audit_rules_list[5]),
+};
 
 DEFINE_MUTEX(audit_filter_mutex);
 
@@ -1007,12 +1015,15 @@ static void audit_update_watch(struct audit_parent *parent,
 			list_del_rcu(&oentry->list);
 
 			nentry = audit_dupe_rule(&oentry->rule, nwatch);
-			if (IS_ERR(nentry))
+			if (IS_ERR(nentry)) {
+				list_del(&oentry->rule.list);
 				audit_panic("error updating watch, removing");
-			else {
+			} else {
 				int h = audit_hash_ino((u32)ino);
 				list_add(&nentry->rule.rlist, &nwatch->rules);
 				list_add_rcu(&nentry->list, &audit_inode_hash[h]);
+				list_replace(&oentry->rule.list,
+					     &nentry->rule.list);
 			}
 
 			call_rcu(&oentry->rcu, audit_free_rule_rcu);
@@ -1077,6 +1088,7 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 				audit_log_end(ab);
 			}
 			list_del(&r->rlist);
+			list_del(&r->list);
 			list_del_rcu(&e->list);
 			call_rcu(&e->rcu, audit_free_rule_rcu);
 		}
@@ -1331,9 +1343,13 @@ static inline int audit_add_rule(struct audit_entry *entry,
 	}
 
 	if (entry->rule.flags & AUDIT_FILTER_PREPEND) {
+		list_add(&entry->rule.list,
+			 &audit_rules_list[entry->rule.listnr]);
 		list_add_rcu(&entry->list, list);
 		entry->rule.flags &= ~AUDIT_FILTER_PREPEND;
 	} else {
+		list_add_tail(&entry->rule.list,
+			      &audit_rules_list[entry->rule.listnr]);
 		list_add_tail_rcu(&entry->list, list);
 	}
 #ifdef CONFIG_AUDITSYSCALL
@@ -1415,6 +1431,7 @@ static inline int audit_del_rule(struct audit_entry *entry,
 		audit_remove_tree_rule(&e->rule);
 
 	list_del_rcu(&e->list);
+	list_del(&e->rule.list);
 	call_rcu(&e->rcu, audit_free_rule_rcu);
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1443,30 +1460,16 @@ out:
 static void audit_list(int pid, int seq, struct sk_buff_head *q)
 {
 	struct sk_buff *skb;
-	struct audit_entry *entry;
+	struct audit_krule *r;
 	int i;
 
 	/* This is a blocking read, so use audit_filter_mutex instead of rcu
 	 * iterator to sync with list writers. */
 	for (i=0; i<AUDIT_NR_FILTERS; i++) {
-		list_for_each_entry(entry, &audit_filter_list[i], list) {
-			struct audit_rule *rule;
-
-			rule = audit_krule_to_rule(&entry->rule);
-			if (unlikely(!rule))
-				break;
-			skb = audit_make_reply(pid, seq, AUDIT_LIST, 0, 1,
-					 rule, sizeof(*rule));
-			if (skb)
-				skb_queue_tail(q, skb);
-			kfree(rule);
-		}
-	}
-	for (i = 0; i < AUDIT_INODE_BUCKETS; i++) {
-		list_for_each_entry(entry, &audit_inode_hash[i], list) {
+		list_for_each_entry(r, &audit_rules_list[i], list) {
 			struct audit_rule *rule;
 
-			rule = audit_krule_to_rule(&entry->rule);
+			rule = audit_krule_to_rule(r);
 			if (unlikely(!rule))
 				break;
 			skb = audit_make_reply(pid, seq, AUDIT_LIST, 0, 1,
@@ -1485,30 +1488,16 @@ static void audit_list(int pid, int seq, struct sk_buff_head *q)
 static void audit_list_rules(int pid, int seq, struct sk_buff_head *q)
 {
 	struct sk_buff *skb;
-	struct audit_entry *e;
+	struct audit_krule *r;
 	int i;
 
 	/* This is a blocking read, so use audit_filter_mutex instead of rcu
 	 * iterator to sync with list writers. */
 	for (i=0; i<AUDIT_NR_FILTERS; i++) {
-		list_for_each_entry(e, &audit_filter_list[i], list) {
-			struct audit_rule_data *data;
-
-			data = audit_krule_to_data(&e->rule);
-			if (unlikely(!data))
-				break;
-			skb = audit_make_reply(pid, seq, AUDIT_LIST_RULES, 0, 1,
-					 data, sizeof(*data) + data->buflen);
-			if (skb)
-				skb_queue_tail(q, skb);
-			kfree(data);
-		}
-	}
-	for (i=0; i< AUDIT_INODE_BUCKETS; i++) {
-		list_for_each_entry(e, &audit_inode_hash[i], list) {
+		list_for_each_entry(r, &audit_rules_list[i], list) {
 			struct audit_rule_data *data;
 
-			data = audit_krule_to_data(&e->rule);
+			data = audit_krule_to_data(r);
 			if (unlikely(!data))
 				break;
 			skb = audit_make_reply(pid, seq, AUDIT_LIST_RULES, 0, 1,
@@ -1789,35 +1778,37 @@ unlock_and_return:
 	return result;
 }
 
-static int update_lsm_rule(struct audit_entry *entry)
+static int update_lsm_rule(struct audit_krule *r)
 {
+	struct audit_entry *entry = container_of(r, struct audit_entry, rule);
 	struct audit_entry *nentry;
 	struct audit_watch *watch;
 	struct audit_tree *tree;
 	int err = 0;
 
-	if (!security_audit_rule_known(&entry->rule))
+	if (!security_audit_rule_known(r))
 		return 0;
 
-	watch = entry->rule.watch;
-	tree = entry->rule.tree;
-	nentry = audit_dupe_rule(&entry->rule, watch);
+	watch = r->watch;
+	tree = r->tree;
+	nentry = audit_dupe_rule(r, watch);
 	if (IS_ERR(nentry)) {
 		/* save the first error encountered for the
 		 * return value */
 		err = PTR_ERR(nentry);
 		audit_panic("error updating LSM filters");
 		if (watch)
-			list_del(&entry->rule.rlist);
+			list_del(&r->rlist);
 		list_del_rcu(&entry->list);
+		list_del(&r->list);
 	} else {
 		if (watch) {
 			list_add(&nentry->rule.rlist, &watch->rules);
-			list_del(&entry->rule.rlist);
+			list_del(&r->rlist);
 		} else if (tree)
-			list_replace_init(&entry->rule.rlist,
-				     &nentry->rule.rlist);
+			list_replace_init(&r->rlist, &nentry->rule.rlist);
 		list_replace_rcu(&entry->list, &nentry->list);
+		list_replace(&r->list, &nentry->rule.list);
 	}
 	call_rcu(&entry->rcu, audit_free_rule_rcu);
 
@@ -1831,27 +1822,19 @@ static int update_lsm_rule(struct audit_entry *entry)
  * updated rule. */
 int audit_update_lsm_rules(void)
 {
-	struct audit_entry *e, *n;
+	struct audit_krule *r, *n;
 	int i, err = 0;
 
 	/* audit_filter_mutex synchronizes the writers */
 	mutex_lock(&audit_filter_mutex);
 
 	for (i = 0; i < AUDIT_NR_FILTERS; i++) {
-		list_for_each_entry_safe(e, n, &audit_filter_list[i], list) {
-			int res = update_lsm_rule(e);
-			if (!err)
-				err = res;
-		}
-	}
-	for (i=0; i< AUDIT_INODE_BUCKETS; i++) {
-		list_for_each_entry_safe(e, n, &audit_inode_hash[i], list) {
-			int res = update_lsm_rule(e);
+		list_for_each_entry_safe(r, n, &audit_rules_list[i], list) {
+			int res = update_lsm_rule(r);
 			if (!err)
 				err = res;
 		}
 	}
-
 	mutex_unlock(&audit_filter_mutex);
 
 	return err;
-- 
1.5.6.5


