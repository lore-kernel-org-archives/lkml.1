Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZBVVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZBVVu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZBVVuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:50:18 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:60131 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbZBVVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:50:17 -0500
Message-ID: <49A1C895.5030803@numericable.fr>
Date: Sun, 22 Feb 2009 22:50:13 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul.moore@hp.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: [PATCH][SMACK] convert smack_known list to a standard linux list.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

this patch on top of [PATCH][SMACK] convert smack rule list to linux list V2
converts "smack_known" to a regular linux list. (rcu variant)


regards,
Etienne

Signed-off-by: <etienne.basset@numericable.fr>
---
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 0dcb907..64164f8 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -109,7 +109,6 @@ struct smk_netlbladdr {
  */
 struct smack_known {
 	struct list_head	list;
-	struct smack_known	*smk_next;
 	char			smk_known[SMK_LABELLEN];
 	u32			smk_secid;
 	struct smack_cipso	*smk_cipso;
@@ -202,7 +201,6 @@ extern int smack_cipso_direct;
 extern char *smack_net_ambient;
 extern char *smack_onlycap;
 
-extern struct smack_known *smack_known;
 extern struct smack_known smack_known_floor;
 extern struct smack_known smack_known_hat;
 extern struct smack_known smack_known_huh;
@@ -210,7 +208,7 @@ extern struct smack_known smack_known_invalid;
 extern struct smack_known smack_known_star;
 extern struct smack_known smack_known_web;
 
-extern struct list_head smack_know_list;
+extern struct list_head smack_known_list;
 extern struct list_head smack_rule_list;
 extern struct list_head smk_netlbladdr_list;
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index b184280..b16086f 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -16,48 +16,42 @@
 #include "smack.h"
 
 struct smack_known smack_known_huh = {
-	.smk_next	= NULL,
 	.smk_known	= "?",
 	.smk_secid	= 2,
 	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_hat = {
-	.smk_next	= &smack_known_huh,
 	.smk_known	= "^",
 	.smk_secid	= 3,
 	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_star = {
-	.smk_next	= &smack_known_hat,
 	.smk_known	= "*",
 	.smk_secid	= 4,
 	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_floor = {
-	.smk_next	= &smack_known_star,
 	.smk_known	= "_",
 	.smk_secid	= 5,
 	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_invalid = {
-	.smk_next	= &smack_known_floor,
 	.smk_known	= "",
 	.smk_secid	= 6,
 	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_web = {
-	.smk_next	= &smack_known_invalid,
 	.smk_known	= "@",
 	.smk_secid	= 7,
 	.smk_cipso	= NULL,
 };
 
-struct smack_known *smack_known = &smack_known_web;
+LIST_HEAD(smack_known_list);
 
 /*
  * The initial value needs to be bigger than any of the
@@ -227,14 +221,17 @@ struct smack_known *smk_import_entry(const char *string, int len)
 
 	mutex_lock(&smack_known_lock);
 
-	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
-		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
+	found = 0;
+	list_for_each_entry_rcu(skp, &smack_known_list, list) {
+		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
+			found = 1;
 			break;
+		}
+	}
 
-	if (skp == NULL) {
+	if (found == 0) {
 		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
 		if (skp != NULL) {
-			skp->smk_next = smack_known;
 			strncpy(skp->smk_known, smack, SMK_MAXLEN);
 			skp->smk_secid = smack_next_secid++;
 			skp->smk_cipso = NULL;
@@ -244,7 +241,7 @@ struct smack_known *smk_import_entry(const char *string, int len)
 			 * filled before putting it on the list.
 			 */
 			smp_mb();
-			smack_known = skp;
+			list_add(&skp->list, &smack_known_list);
 		}
 	}
 
@@ -282,14 +279,19 @@ char *smack_from_secid(const u32 secid)
 {
 	struct smack_known *skp;
 
-	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
-		if (skp->smk_secid == secid)
+	rcu_read_lock();
+	list_for_each_entry_rcu(skp, &smack_known_list, list) {
+		if (skp->smk_secid == secid) {
+			rcu_read_unlock();
 			return skp->smk_known;
+		}
+	}
 
 	/*
 	 * If we got this far someone asked for the translation
 	 * of a secid that is not on the list.
 	 */
+	rcu_read_unlock();
 	return smack_known_invalid.smk_known;
 }
 
@@ -304,9 +306,14 @@ u32 smack_to_secid(const char *smack)
 {
 	struct smack_known *skp;
 
-	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
-		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0)
+	rcu_read_lock();
+	list_for_each_entry_rcu(skp, &smack_known_list, list) {
+		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
+			rcu_read_unlock();
 			return skp->smk_secid;
+		}
+	}
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -331,7 +338,8 @@ void smack_from_cipso(u32 level, char *cp, char *result)
 	struct smack_known *kp;
 	char *final = NULL;
 
-	for (kp = smack_known; final == NULL && kp != NULL; kp = kp->smk_next) {
+	rcu_read_lock();
+	list_for_each_entry(kp, &smack_known_list, list) {
 		if (kp->smk_cipso == NULL)
 			continue;
 
@@ -343,6 +351,7 @@ void smack_from_cipso(u32 level, char *cp, char *result)
 
 		spin_unlock_bh(&kp->smk_cipsolock);
 	}
+	rcu_read_unlock();
 	if (final == NULL)
 		final = smack_known_huh.smk_known;
 	strncpy(result, final, SMK_MAXLEN);
@@ -359,13 +368,19 @@ void smack_from_cipso(u32 level, char *cp, char *result)
 int smack_to_cipso(const char *smack, struct smack_cipso *cp)
 {
 	struct smack_known *kp;
+	int found = 0;
 
-	for (kp = smack_known; kp != NULL; kp = kp->smk_next)
+	rcu_read_lock();
+	list_for_each_entry_rcu(kp, &smack_known_list, list) {
 		if (kp->smk_known == smack ||
-		    strcmp(kp->smk_known, smack) == 0)
+		    strcmp(kp->smk_known, smack) == 0) {
+			found = 1;
 			break;
+		}
+	}
+	rcu_read_unlock();
 
-	if (kp == NULL || kp->smk_cipso == NULL)
+	if (found == 0 || kp->smk_cipso == NULL)
 		return -ENOENT;
 
 	memcpy(cp, kp->smk_cipso, sizeof(struct smack_cipso));
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 65a4a8a..e6f89d6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2935,6 +2935,17 @@ struct security_operations smack_ops = {
 	.release_secctx = 		smack_release_secctx,
 };
 
+
+static __init init_smack_know_list(void)
+{
+	list_add(&smack_known_huh.list, &smack_known_list);
+	list_add(&smack_known_hat.list, &smack_known_list);
+	list_add(&smack_known_star.list, &smack_known_list);
+	list_add(&smack_known_floor.list, &smack_known_list);
+	list_add(&smack_known_invalid.list, &smack_known_list);
+	list_add(&smack_known_web.list, &smack_known_list);
+}
+
 /**
  * smack_init - initialize the smack system
  *
@@ -2955,6 +2966,8 @@ static __init int smack_init(void)
 	cred = (struct cred *) current->cred;
 	cred->security = &smack_known_floor.smk_known;
 
+	/* initilize the smack_know_list */
+	init_smack_know_list();
 	/*
 	 * Initialize locks
 	 */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 771e452..665e2cc 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -84,7 +84,6 @@ char *smack_onlycap;
 LIST_HEAD(smk_netlbladdr_list);
 LIST_HEAD(smack_rule_list);
 
-
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 #define	SEQ_READ_FINISHED	1
@@ -436,24 +435,26 @@ static void *cipso_seq_start(struct seq_file *s, loff_t *pos)
 {
 	if (*pos == SEQ_READ_FINISHED)
 		return NULL;
+	if (list_empty(&smack_known_list))
+		return NULL;
 
-	return smack_known;
+	return &smack_known_list;
 }
 
 static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct smack_known *skp = ((struct smack_known *) v)->smk_next;
+	struct list_head  *list = v;
 
 	/*
-	 * Omit labels with no associated cipso value
+	 * labels with no associated cipso value wont be printed
+	 * in cipso_seq_show
 	 */
-	while (skp != NULL && !skp->smk_cipso)
-		skp = skp->smk_next;
-
-	if (skp == NULL)
+	if (list_is_last(list->next, &smack_known_list)) {
 		*pos = SEQ_READ_FINISHED;
+		return NULL;
+	}
 
-	return skp;
+	return list->next;
 }
 
 /*
@@ -462,7 +463,8 @@ static void *cipso_seq_next(struct seq_file *s, void *v, loff_t *pos)
  */
 static int cipso_seq_show(struct seq_file *s, void *v)
 {
-	struct smack_known *skp = (struct smack_known *) v;
+	struct list_head  *list = v;
+	struct smack_known *skp = container_of(list->next, struct smack_known, list);
 	struct smack_cipso *scp = skp->smk_cipso;
 	char *cbp;
 	char sep = '/';
