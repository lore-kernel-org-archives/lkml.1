Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZBVV0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZBVV0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZBVVZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:25:58 -0500
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:60417 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZBVVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:25:57 -0500
Message-ID: <49A1C2E1.3020103@numericable.fr>
Date: Sun, 22 Feb 2009 22:25:53 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul.moore@hp.com>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Subject: [PATCH][SMACK] convert smack rule list to linux list V2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

This patch convert the  smack_list list to standard linux list, struct smk_list_entry is also removed
(list_head is added directly in smack_rule, smk_list_entry has no practical use?)
this patch applies on top of 
[PATCH][SMACK][RFC] convert smack_netlbladdrs to standard list v2

change since V1 : rcu variants

regards
Etienne 

Signed-off-by: <etienne.basset@numericable.fr>
---
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 2db35d7..0dcb907 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -61,18 +61,10 @@ struct inode_smack {
  * A label access rule.
  */
 struct smack_rule {
-	char	*smk_subject;
-	char	*smk_object;
-	int	smk_access;
-};
-
-/*
- * An entry in the table of permitted label accesses.
- */
-struct smk_list_entry {
-	struct smk_list_entry	*smk_next;
 	struct list_head	list;
-	struct smack_rule	smk_rule;
+	char			*smk_subject;
+	char			*smk_object;
+	int			smk_access;
 };
 
 /*
@@ -218,10 +210,10 @@ extern struct smack_known smack_known_invalid;
 extern struct smack_known smack_known_star;
 extern struct smack_known smack_known_web;
 
-extern struct smk_list_entry *smack_list;
 extern struct list_head smack_know_list;
 extern struct list_head smack_rule_list;
 extern struct list_head smk_netlbladdr_list;
+
 extern struct security_operations smack_ops;
 
 /*
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 2e0b83e..b184280 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -87,7 +87,6 @@ static u32 smack_next_secid = 10;
 int smk_access(char *subject_label, char *object_label, int request)
 {
 	u32 may = MAY_NOT;
-	struct smk_list_entry *sp;
 	struct smack_rule *srp;
 
 	/*
@@ -139,9 +138,8 @@ int smk_access(char *subject_label, char *object_label, int request)
 	 * access (e.g. read is included in readwrite) it's
 	 * good.
 	 */
-	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
-		srp = &sp->smk_rule;
-
+	rcu_read_lock();
+	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
 		if (srp->smk_subject == subject_label ||
 		    strcmp(srp->smk_subject, subject_label) == 0) {
 			if (srp->smk_object == object_label ||
@@ -151,6 +149,7 @@ int smk_access(char *subject_label, char *object_label, int request)
 			}
 		}
 	}
+	rcu_read_unlock();
 	/*
 	 * This is a bit map operation.
 	 */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 7494808..771e452 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -82,9 +82,10 @@ char *smack_onlycap;
  */
 
 LIST_HEAD(smk_netlbladdr_list);
+LIST_HEAD(smack_rule_list);
+
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
-struct smk_list_entry *smack_list;
 
 #define	SEQ_READ_FINISHED	1
 
@@ -135,24 +136,27 @@ static void *load_seq_start(struct seq_file *s, loff_t *pos)
 {
 	if (*pos == SEQ_READ_FINISHED)
 		return NULL;
-
-	return smack_list;
+	if (list_empty(&smack_rule_list))
+		return NULL;
+	return &smack_rule_list;
 }
 
 static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct smk_list_entry *skp = ((struct smk_list_entry *) v)->smk_next;
+	struct list_head *list = v;
 
-	if (skp == NULL)
+	if (list_is_last(list->next, &smack_rule_list)) {
 		*pos = SEQ_READ_FINISHED;
-
-	return skp;
+		return NULL;
+	}
+	return list->next;
 }
 
 static int load_seq_show(struct seq_file *s, void *v)
 {
-	struct smk_list_entry *slp = (struct smk_list_entry *) v;
-	struct smack_rule *srp = &slp->smk_rule;
+	struct list_head *list = v;
+	struct smack_rule *srp =
+		 container_of(list->next, struct smack_rule, list);
 
 	seq_printf(s, "%s %s", (char *)srp->smk_subject,
 		   (char *)srp->smk_object);
@@ -213,32 +217,23 @@ static int smk_open_load(struct inode *inode, struct file *file)
  */
 static int smk_set_access(struct smack_rule *srp)
 {
-	struct smk_list_entry *sp;
-	struct smk_list_entry *newp;
+	struct smack_rule *sp;
 	int ret = 0;
-
+	int found;
 	mutex_lock(&smack_list_lock);
 
-	for (sp = smack_list; sp != NULL; sp = sp->smk_next)
-		if (sp->smk_rule.smk_subject == srp->smk_subject &&
-		    sp->smk_rule.smk_object == srp->smk_object) {
-			sp->smk_rule.smk_access = srp->smk_access;
+	found = 0;
+	list_for_each_entry_rcu(sp, &smack_rule_list, list) {
+		if (sp->smk_subject == srp->smk_subject &&
+		    sp->smk_object == srp->smk_object) {
+			found = 1;
+			sp->smk_access = srp->smk_access;
 			break;
 		}
-
-	if (sp == NULL) {
-		newp = kzalloc(sizeof(struct smk_list_entry), GFP_KERNEL);
-		if (newp == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		newp->smk_rule = *srp;
-		newp->smk_next = smack_list;
-		smack_list = newp;
 	}
+	if (found == 0)
+		list_add_rcu(&srp->list, &smack_rule_list);
 
-out:
 	mutex_unlock(&smack_list_lock);
 
 	return ret;
@@ -262,7 +257,7 @@ out:
 static ssize_t smk_write_load(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct smack_rule rule;
+	struct smack_rule *rule;
 	char *data;
 	int rc = -EINVAL;
 
@@ -273,9 +268,8 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	 */
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
-	if (*ppos != 0)
-		return -EINVAL;
-	if (count != SMK_LOADLEN)
+
+	if (*ppos != 0 || count != SMK_LOADLEN)
 		return -EINVAL;
 
 	data = kzalloc(count, GFP_KERNEL);
@@ -287,25 +281,31 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	rule.smk_subject = smk_import(data, 0);
-	if (rule.smk_subject == NULL)
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (rule == NULL) {
+		rc = -ENOMEM;
 		goto out;
+	}
 
-	rule.smk_object = smk_import(data + SMK_LABELLEN, 0);
-	if (rule.smk_object == NULL)
-		goto out;
+	rule->smk_subject = smk_import(data, 0);
+	if (rule->smk_subject == NULL)
+		goto out_free;
 
-	rule.smk_access = 0;
+	rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
+	if (rule->smk_object == NULL)
+		goto out_free;
+
+	rule->smk_access = 0;
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN]) {
 	case '-':
 		break;
 	case 'r':
 	case 'R':
-		rule.smk_access |= MAY_READ;
+		rule->smk_access |= MAY_READ;
 		break;
 	default:
-		goto out;
+		goto out_free;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 1]) {
@@ -313,10 +313,10 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		break;
 	case 'w':
 	case 'W':
-		rule.smk_access |= MAY_WRITE;
+		rule->smk_access |= MAY_WRITE;
 		break;
 	default:
-		goto out;
+		goto out_free;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 2]) {
@@ -324,10 +324,10 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		break;
 	case 'x':
 	case 'X':
-		rule.smk_access |= MAY_EXEC;
+		rule->smk_access |= MAY_EXEC;
 		break;
 	default:
-		goto out;
+		goto out_free;
 	}
 
 	switch (data[SMK_LABELLEN + SMK_LABELLEN + 3]) {
@@ -335,17 +335,20 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		break;
 	case 'a':
 	case 'A':
-		rule.smk_access |= MAY_APPEND;
+		rule->smk_access |= MAY_APPEND;
 		break;
 	default:
-		goto out;
+		goto out_free;
 	}
 
-	rc = smk_set_access(&rule);
+	rc = smk_set_access(rule);
 
 	if (!rc)
 		rc = count;
+	goto out;
 
+out_free:
+	kfree(rule);
 out:
 	kfree(data);
 	return rc;
