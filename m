Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760642AbYLQFQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYLQFQe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbYLQFNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:13:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58305 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894AbYLQFNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:13:32 -0500
To: linux-audit@redhat.com
Subject: [PATCH 15/15] audit: validate comparison operations, store them in sane form
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LCoiw-0000Gw-Ud@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 17 Dec 2008 05:13:30 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't store the field->op in the messy (and very inconvenient for e.g.
audit_comparator()) form; translate to dense set of values and do full
validation of userland-submitted value while we are at it.

->audit_init_rule() and ->audit_match_rule() get new values now; in-tree
instances updated.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/audit.h          |   12 ++++
 kernel/audit_tree.c            |    2 +-
 kernel/auditfilter.c           |  132 ++++++++++++++++++++--------------------
 security/selinux/ss/services.c |   26 ++++----
 security/smack/smack_lsm.c     |    6 +-
 5 files changed, 94 insertions(+), 84 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 4e37f06..1f73f5e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -245,6 +245,18 @@
 #define AUDIT_GREATER_THAN_OR_EQUAL	(AUDIT_GREATER_THAN|AUDIT_EQUAL)
 #define AUDIT_OPERATORS			(AUDIT_EQUAL|AUDIT_NOT_EQUAL|AUDIT_BIT_MASK)
 
+enum {
+	Audit_equal,
+	Audit_not_equal,
+	Audit_bitmask,
+	Audit_bittest,
+	Audit_lt,
+	Audit_gt,
+	Audit_le,
+	Audit_ge,
+	Audit_bad
+};
+
 /* Status symbols */
 				/* Mask values */
 #define AUDIT_STATUS_ENABLED		0x0001
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 48bddad..8ad9545 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -618,7 +618,7 @@ int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
 
 	if (pathname[0] != '/' ||
 	    rule->listnr != AUDIT_FILTER_EXIT ||
-	    op & ~AUDIT_EQUAL ||
+	    op != Audit_equal ||
 	    rule->inode_f || rule->watch || rule->tree)
 		return -EINVAL;
 	rule->tree = alloc_tree(pathname);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index e6e3829..fbf24d1 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -252,7 +252,8 @@ static inline int audit_to_inode(struct audit_krule *krule,
 				 struct audit_field *f)
 {
 	if (krule->listnr != AUDIT_FILTER_EXIT ||
-	    krule->watch || krule->inode_f || krule->tree)
+	    krule->watch || krule->inode_f || krule->tree ||
+	    (f->op != Audit_equal && f->op != Audit_not_equal))
 		return -EINVAL;
 
 	krule->inode_f = f;
@@ -270,7 +271,7 @@ static int audit_to_watch(struct audit_krule *krule, char *path, int len,
 
 	if (path[0] != '/' || path[len-1] == '/' ||
 	    krule->listnr != AUDIT_FILTER_EXIT ||
-	    op & ~AUDIT_EQUAL ||
+	    op != Audit_equal ||
 	    krule->inode_f || krule->watch || krule->tree)
 		return -EINVAL;
 
@@ -420,12 +421,32 @@ exit_err:
 	return ERR_PTR(err);
 }
 
+static u32 audit_ops[] =
+{
+	[Audit_equal] = AUDIT_EQUAL,
+	[Audit_not_equal] = AUDIT_NOT_EQUAL,
+	[Audit_bitmask] = AUDIT_BIT_MASK,
+	[Audit_bittest] = AUDIT_BIT_TEST,
+	[Audit_lt] = AUDIT_LESS_THAN,
+	[Audit_gt] = AUDIT_GREATER_THAN,
+	[Audit_le] = AUDIT_LESS_THAN_OR_EQUAL,
+	[Audit_ge] = AUDIT_GREATER_THAN_OR_EQUAL,
+};
+
+static u32 audit_to_op(u32 op)
+{
+	u32 n;
+	for (n = Audit_equal; n < Audit_bad && audit_ops[n] != op; n++)
+		;
+	return n;
+}
+
+
 /* Translate struct audit_rule to kernel's rule respresentation.
  * Exists for backward compatibility with userspace. */
 static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 {
 	struct audit_entry *entry;
-	struct audit_field *ino_f;
 	int err = 0;
 	int i;
 
@@ -435,12 +456,28 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &entry->rule.fields[i];
+		u32 n;
+
+		n = rule->fields[i] & (AUDIT_NEGATE|AUDIT_OPERATORS);
+
+		/* Support for legacy operators where
+		 * AUDIT_NEGATE bit signifies != and otherwise assumes == */
+		if (n & AUDIT_NEGATE)
+			f->op = Audit_not_equal;
+		else if (!n)
+			f->op = Audit_equal;
+		else
+			f->op = audit_to_op(n);
+
+		entry->rule.vers_ops = (n & AUDIT_OPERATORS) ? 2 : 1;
 
-		f->op = rule->fields[i] & (AUDIT_NEGATE|AUDIT_OPERATORS);
 		f->type = rule->fields[i] & ~(AUDIT_NEGATE|AUDIT_OPERATORS);
 		f->val = rule->values[i];
 
 		err = -EINVAL;
+		if (f->op == Audit_bad)
+			goto exit_free;
+
 		switch(f->type) {
 		default:
 			goto exit_free;
@@ -462,11 +499,8 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 		case AUDIT_EXIT:
 		case AUDIT_SUCCESS:
 			/* bit ops are only useful on syscall args */
-			if (f->op == AUDIT_BIT_MASK ||
-						f->op == AUDIT_BIT_TEST) {
-				err = -EINVAL;
+			if (f->op == Audit_bitmask || f->op == Audit_bittest)
 				goto exit_free;
-			}
 			break;
 		case AUDIT_ARG0:
 		case AUDIT_ARG1:
@@ -475,11 +509,8 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 			break;
 		/* arch is only allowed to be = or != */
 		case AUDIT_ARCH:
-			if ((f->op != AUDIT_NOT_EQUAL) && (f->op != AUDIT_EQUAL)
-					&& (f->op != AUDIT_NEGATE) && (f->op)) {
-				err = -EINVAL;
+			if (f->op != Audit_not_equal && f->op != Audit_equal)
 				goto exit_free;
-			}
 			entry->rule.arch_f = f;
 			break;
 		case AUDIT_PERM:
@@ -496,33 +527,10 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 				goto exit_free;
 			break;
 		}
-
-		entry->rule.vers_ops = (f->op & AUDIT_OPERATORS) ? 2 : 1;
-
-		/* Support for legacy operators where
-		 * AUDIT_NEGATE bit signifies != and otherwise assumes == */
-		if (f->op & AUDIT_NEGATE)
-			f->op = AUDIT_NOT_EQUAL;
-		else if (!f->op)
-			f->op = AUDIT_EQUAL;
-		else if (f->op == AUDIT_OPERATORS) {
-			err = -EINVAL;
-			goto exit_free;
-		}
 	}
 
-	ino_f = entry->rule.inode_f;
-	if (ino_f) {
-		switch(ino_f->op) {
-		case AUDIT_NOT_EQUAL:
-			entry->rule.inode_f = NULL;
-		case AUDIT_EQUAL:
-			break;
-		default:
-			err = -EINVAL;
-			goto exit_free;
-		}
-	}
+	if (entry->rule.inode_f && entry->rule.inode_f->op == Audit_not_equal)
+		entry->rule.inode_f = NULL;
 
 exit_nofree:
 	return entry;
@@ -538,7 +546,6 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 {
 	int err = 0;
 	struct audit_entry *entry;
-	struct audit_field *ino_f;
 	void *bufp;
 	size_t remain = datasz - sizeof(struct audit_rule_data);
 	int i;
@@ -554,11 +561,11 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		struct audit_field *f = &entry->rule.fields[i];
 
 		err = -EINVAL;
-		if (!(data->fieldflags[i] & AUDIT_OPERATORS) ||
-		    data->fieldflags[i] & ~AUDIT_OPERATORS)
+
+		f->op = audit_to_op(data->fieldflags[i]);
+		if (f->op == Audit_bad)
 			goto exit_free;
 
-		f->op = data->fieldflags[i] & AUDIT_OPERATORS;
 		f->type = data->fields[i];
 		f->val = data->values[i];
 		f->lsm_str = NULL;
@@ -670,18 +677,8 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		}
 	}
 
-	ino_f = entry->rule.inode_f;
-	if (ino_f) {
-		switch(ino_f->op) {
-		case AUDIT_NOT_EQUAL:
-			entry->rule.inode_f = NULL;
-		case AUDIT_EQUAL:
-			break;
-		default:
-			err = -EINVAL;
-			goto exit_free;
-		}
-	}
+	if (entry->rule.inode_f && entry->rule.inode_f->op == Audit_not_equal)
+		entry->rule.inode_f = NULL;
 
 exit_nofree:
 	return entry;
@@ -721,10 +718,10 @@ static struct audit_rule *audit_krule_to_rule(struct audit_krule *krule)
 		rule->fields[i] = krule->fields[i].type;
 
 		if (krule->vers_ops == 1) {
-			if (krule->fields[i].op & AUDIT_NOT_EQUAL)
+			if (krule->fields[i].op == Audit_not_equal)
 				rule->fields[i] |= AUDIT_NEGATE;
 		} else {
-			rule->fields[i] |= krule->fields[i].op;
+			rule->fields[i] |= audit_ops[krule->fields[i].op];
 		}
 	}
 	for (i = 0; i < AUDIT_BITMASK_SIZE; i++) rule->mask[i] = krule->mask[i];
@@ -752,7 +749,7 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 		struct audit_field *f = &krule->fields[i];
 
 		data->fields[i] = f->type;
-		data->fieldflags[i] = f->op;
+		data->fieldflags[i] = audit_ops[f->op];
 		switch(f->type) {
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
@@ -1626,28 +1623,29 @@ int audit_receive_filter(int type, int pid, int uid, int seq, void *data,
 	return err;
 }
 
-int audit_comparator(const u32 left, const u32 op, const u32 right)
+int audit_comparator(u32 left, u32 op, u32 right)
 {
 	switch (op) {
-	case AUDIT_EQUAL:
+	case Audit_equal:
 		return (left == right);
-	case AUDIT_NOT_EQUAL:
+	case Audit_not_equal:
 		return (left != right);
-	case AUDIT_LESS_THAN:
+	case Audit_lt:
 		return (left < right);
-	case AUDIT_LESS_THAN_OR_EQUAL:
+	case Audit_le:
 		return (left <= right);
-	case AUDIT_GREATER_THAN:
+	case Audit_gt:
 		return (left > right);
-	case AUDIT_GREATER_THAN_OR_EQUAL:
+	case Audit_ge:
 		return (left >= right);
-	case AUDIT_BIT_MASK:
+	case Audit_bitmask:
 		return (left & right);
-	case AUDIT_BIT_TEST:
+	case Audit_bittest:
 		return ((left & right) == right);
+	default:
+		BUG();
+		return 0;
 	}
-	BUG();
-	return 0;
 }
 
 /* Compare given dentry name with last component in given path,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 343c8ab..c65e4fe 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2602,7 +2602,7 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 	case AUDIT_OBJ_ROLE:
 	case AUDIT_OBJ_TYPE:
 		/* only 'equals' and 'not equals' fit user, role, and type */
-		if (op != AUDIT_EQUAL && op != AUDIT_NOT_EQUAL)
+		if (op != Audit_equal && op != Audit_not_equal)
 			return -EINVAL;
 		break;
 	case AUDIT_SUBJ_SEN:
@@ -2736,10 +2736,10 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 	case AUDIT_SUBJ_USER:
 	case AUDIT_OBJ_USER:
 		switch (op) {
-		case AUDIT_EQUAL:
+		case Audit_equal:
 			match = (ctxt->user == rule->au_ctxt.user);
 			break;
-		case AUDIT_NOT_EQUAL:
+		case Audit_not_equal:
 			match = (ctxt->user != rule->au_ctxt.user);
 			break;
 		}
@@ -2747,10 +2747,10 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 	case AUDIT_SUBJ_ROLE:
 	case AUDIT_OBJ_ROLE:
 		switch (op) {
-		case AUDIT_EQUAL:
+		case Audit_equal:
 			match = (ctxt->role == rule->au_ctxt.role);
 			break;
-		case AUDIT_NOT_EQUAL:
+		case Audit_not_equal:
 			match = (ctxt->role != rule->au_ctxt.role);
 			break;
 		}
@@ -2758,10 +2758,10 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 	case AUDIT_SUBJ_TYPE:
 	case AUDIT_OBJ_TYPE:
 		switch (op) {
-		case AUDIT_EQUAL:
+		case Audit_equal:
 			match = (ctxt->type == rule->au_ctxt.type);
 			break;
-		case AUDIT_NOT_EQUAL:
+		case Audit_not_equal:
 			match = (ctxt->type != rule->au_ctxt.type);
 			break;
 		}
@@ -2774,31 +2774,31 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 			  field == AUDIT_OBJ_LEV_LOW) ?
 			 &ctxt->range.level[0] : &ctxt->range.level[1]);
 		switch (op) {
-		case AUDIT_EQUAL:
+		case Audit_equal:
 			match = mls_level_eq(&rule->au_ctxt.range.level[0],
 					     level);
 			break;
-		case AUDIT_NOT_EQUAL:
+		case Audit_not_equal:
 			match = !mls_level_eq(&rule->au_ctxt.range.level[0],
 					      level);
 			break;
-		case AUDIT_LESS_THAN:
+		case Audit_lt:
 			match = (mls_level_dom(&rule->au_ctxt.range.level[0],
 					       level) &&
 				 !mls_level_eq(&rule->au_ctxt.range.level[0],
 					       level));
 			break;
-		case AUDIT_LESS_THAN_OR_EQUAL:
+		case Audit_le:
 			match = mls_level_dom(&rule->au_ctxt.range.level[0],
 					      level);
 			break;
-		case AUDIT_GREATER_THAN:
+		case Audit_gt:
 			match = (mls_level_dom(level,
 					      &rule->au_ctxt.range.level[0]) &&
 				 !mls_level_eq(level,
 					       &rule->au_ctxt.range.level[0]));
 			break;
-		case AUDIT_GREATER_THAN_OR_EQUAL:
+		case Audit_ge:
 			match = mls_level_dom(level,
 					      &rule->au_ctxt.range.level[0]);
 			break;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6e2dc0b..45eacc4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2443,7 +2443,7 @@ static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
 		return -EINVAL;
 
-	if (op != AUDIT_EQUAL && op != AUDIT_NOT_EQUAL)
+	if (op != Audit_equal && op != Audit_not_equal)
 		return -EINVAL;
 
 	*rule = smk_import(rulestr, 0);
@@ -2507,9 +2507,9 @@ static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
 	 * both pointers will point to the same smack_known
 	 * label.
 	 */
-	if (op == AUDIT_EQUAL)
+	if (op == Audit_equal)
 		return (rule == smack);
-	if (op == AUDIT_NOT_EQUAL)
+	if (op == Audit_not_equal)
 		return (rule != smack);
 
 	return 0;
-- 
1.5.6.5

