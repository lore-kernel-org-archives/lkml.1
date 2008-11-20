Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYKTQox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYKTQox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYKTQoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:44:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60878 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbYKTQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:44:19 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 4/4] integrity: replace task uid with cred uid
Date: Thu, 20 Nov 2008 11:43:06 -0500
Message-Id: <7dd0b2866a56c67b997df0eff9319383bbc775f4.1227137423.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the credential merge changes in the
security-testing-2.6/next tree.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index f62f2b7..4d59a86 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -44,7 +44,7 @@ static int update_file_hash(struct file *f, struct path *path,
 			rc = -EINVAL;
 			goto out;
 		}
-		file = dentry_open(de, mnt, O_RDONLY);
+		file = dentry_open(de, mnt, O_RDONLY, current->cred);
 		if (IS_ERR(file)) {
 			ima_info("%s dentry_open failed\n", de->d_name.name);
 			rc = PTR_ERR(file);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 2e95c35..867bfaf 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -95,7 +95,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
-	if ((rule->flags & IMA_UID) && rule->uid != tsk->uid)
+	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc;
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 758e5dd..8e32d84 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -49,7 +49,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
-			 current->pid, current->uid,
+			 current->pid, current->cred->uid,
 			 audit_get_loginuid(current));
 	audit_log_task_context(ab);
 	switch (audit_msgno) {
-- 
1.5.6.5

