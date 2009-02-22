Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbZBVVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbZBVVWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZBVVWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:22:15 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:50577 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZBVVWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:22:14 -0500
Message-ID: <49A1C200.80609@numericable.fr>
Date: Sun, 22 Feb 2009 22:22:08 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul.moore@hp.com>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Subject: [PATCH][SMACK][RFC] convert smack_netlbladdrs to standard list V2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

please find below my seond   try to convert smack_netlbladdrs to standard list
(patch on top of .29rc5 + [PATCH] SMACK netlabel fixes v2)
I tested it and found no regression, no hangs etc...

change since v1 : use rcu variants for list manipulation (thanks Tetsuo Handa a Paul McKenney) 

Please let me know if there are problems
Etienne

Signed-off-by: <etienne.basset@numericable.fr>
---
diff --git a/security/smack/smack.h b/security/smack/smack.h
index b79582e..2db35d7 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -18,6 +18,8 @@
 #include <linux/security.h>
 #include <linux/in.h>
 #include <net/netlabel.h>
+#include <linux/list.h>
+#include <linux/rculist.h>
 
 /*
  * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
@@ -69,6 +71,7 @@ struct smack_rule {
  */
 struct smk_list_entry {
 	struct smk_list_entry	*smk_next;
+	struct list_head	list;
 	struct smack_rule	smk_rule;
 };
 
@@ -85,7 +88,7 @@ struct smack_cipso {
  * An entry in the table identifying hosts.
  */
 struct smk_netlbladdr {
-	struct smk_netlbladdr	*smk_next;
+	struct list_head	list;
 	struct sockaddr_in	smk_host;	/* network address */
 	struct in_addr		smk_mask;	/* network mask */
 	char			*smk_label;	/* label */
@@ -113,6 +116,7 @@ struct smk_netlbladdr {
  * the cipso direct mapping in used internally.
  */
 struct smack_known {
+	struct list_head	list;
 	struct smack_known	*smk_next;
 	char			smk_known[SMK_LABELLEN];
 	u32			smk_secid;
@@ -215,7 +219,9 @@ extern struct smack_known smack_known_star;
 extern struct smack_known smack_known_web;
 
 extern struct smk_list_entry *smack_list;
-extern struct smk_netlbladdr *smack_netlbladdrs;
+extern struct list_head smack_know_list;
+extern struct list_head smack_rule_list;
+extern struct list_head smk_netlbladdr_list;
 extern struct security_operations smack_ops;
 
 /*
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e7ded13..65a4a8a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1509,8 +1509,8 @@ static char *smack_host_label(struct sockaddr_in *sip)
 
 	if (siap->s_addr == 0)
 		return NULL;
-
-	for (snp = smack_netlbladdrs; snp != NULL; snp = snp->smk_next) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(snp, &smk_netlbladdr_list, list) {
 		/*
 		 * we break after finding the first match because
 		 * the list is sorted from longest to shortest mask
@@ -1518,10 +1518,11 @@ static char *smack_host_label(struct sockaddr_in *sip)
 		 */
 		if ((&snp->smk_host.sin_addr)->s_addr  ==
 			(siap->s_addr & (&snp->smk_mask)->s_addr)) {
+			rcu_read_unlock();
 			return snp->smk_label;
 		}
 	}
-
+	rcu_read_unlock();
 	return NULL;
 }
 
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 51f0efc..7494808 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -80,7 +80,8 @@ char *smack_onlycap;
  * Packets are sent there unlabeled, but only from tasks that
  * can write to the specified label.
  */
-struct smk_netlbladdr *smack_netlbladdrs;
+
+LIST_HEAD(smk_netlbladdr_list);
 
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 struct smk_list_entry *smack_list;
@@ -637,18 +638,21 @@ static void *netlbladdr_seq_start(struct seq_file *s, loff_t *pos)
 {
 	if (*pos == SEQ_READ_FINISHED)
 		return NULL;
-
-	return smack_netlbladdrs;
+	if (list_empty(&smk_netlbladdr_list))
+		return NULL;
+	return &smk_netlbladdr_list;
 }
 
 static void *netlbladdr_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct smk_netlbladdr *skp = ((struct smk_netlbladdr *) v)->smk_next;
-
-	if (skp == NULL)
+	struct list_head *list = v;
+	
+	if (list_is_last(list->next, &smk_netlbladdr_list)) {
 		*pos = SEQ_READ_FINISHED;
+		return NULL;
+	}
 
-	return skp;
+	return list->next;
 }
 #define BEBITS	(sizeof(__be32) * 8)
 
@@ -657,7 +661,8 @@ static void *netlbladdr_seq_next(struct seq_file *s, void *v, loff_t *pos)
  */
 static int netlbladdr_seq_show(struct seq_file *s, void *v)
 {
-	struct smk_netlbladdr *skp = (struct smk_netlbladdr *) v;
+	struct list_head *list = v;
+	struct smk_netlbladdr *skp = container_of(list->next, struct smk_netlbladdr, list);
 	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
 	int maskn;
 	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
@@ -701,33 +706,37 @@ static int smk_open_netlbladdr(struct inode *inode, struct file *file)
  *
  * This helper insert netlabel in the smack_netlbladdrs list
  * sorted by netmask length (longest to smallest)
+ * locked by &smk_netlbladdr_lock in smk_write_netlbladdr
+ *
  */
 static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
 {
-	struct smk_netlbladdr *m;
+	struct smk_netlbladdr *m, *m_next;
 
-	if (smack_netlbladdrs == NULL) {
-		smack_netlbladdrs = new;
-		return;
-	}
+        if (list_empty(&smk_netlbladdr_list)) {
+                list_add_rcu(&new->list, &smk_netlbladdr_list);
+                return;
+        }
 
 	/* the comparison '>' is a bit hacky, but works */
-	if (new->smk_mask.s_addr > smack_netlbladdrs->smk_mask.s_addr) {
-		new->smk_next = smack_netlbladdrs;
-		smack_netlbladdrs = new;
-		return;
-	}
-	for (m = smack_netlbladdrs; m != NULL; m = m->smk_next) {
-		if (m->smk_next == NULL) {
-			m->smk_next = new;
-			return;
-		}
-		if (new->smk_mask.s_addr > m->smk_next->smk_mask.s_addr) {
-			new->smk_next = m->smk_next;
-			m->smk_next = new;
-			return;
-		}
-	}
+	m = container_of(rcu_dereference(smk_netlbladdr_list.next), struct smk_netlbladdr, list);
+
+        if (new->smk_mask.s_addr > m->smk_mask.s_addr) {
+                list_add_rcu(&new->list, &smk_netlbladdr_list);
+                return;
+        }
+
+	list_for_each_entry_rcu(m, &smk_netlbladdr_list, list) {
+                if (list_is_last(&m->list, &smk_netlbladdr_list)) {
+                        list_add_rcu(&new->list, &m->list);
+                        return;
+                }
+                m_next = container_of(rcu_dereference(m->list.next), struct smk_netlbladdr, list);
+                if (new->smk_mask.s_addr > m_next->smk_mask.s_addr) {
+                        list_add_rcu(&new->list, &m->list);
+                        return;
+                }
+        }
 }
 
 
@@ -754,6 +763,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	struct netlbl_audit audit_info;
 	struct in_addr mask;
 	unsigned int m;
+	int found;
 	u32 mask_bits = (1<<31);
 	__be32 nsa;
 	u32 temp_mask;
@@ -807,14 +817,18 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 
 	nsa = newname.sin_addr.s_addr;
 	/* try to find if the prefix is already in the list */
-	for (skp = smack_netlbladdrs; skp != NULL; skp = skp->smk_next)
+	found = 0;
+	list_for_each_entry_rcu(skp, &smk_netlbladdr_list, list) {
 		if (skp->smk_host.sin_addr.s_addr == nsa &&
-		    skp->smk_mask.s_addr == mask.s_addr)
-			break;
+		    skp->smk_mask.s_addr == mask.s_addr) {
+			found = 1;
+			break;	
+		}
+	}
 
 	smk_netlabel_audit_set(&audit_info);
 
-	if (skp == NULL) {
+	if (!found) {
 		skp = kzalloc(sizeof(*skp), GFP_KERNEL);
 		if (skp == NULL)
 			rc = -ENOMEM;

