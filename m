Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbYLBVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbYLBVsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYLBVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:48:26 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49540 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYLBVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:48:25 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 6/6] integrity: replace task uid with cred uid
Date: Tue,  2 Dec 2008 16:48:00 -0500
Message-Id: <4483e59ddc1d14f1b0a35578274a01c632303fe2.1228253619.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the credential merge changes in the
security-testing-2.6/next tree.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8672f86..4b74197 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -135,7 +135,7 @@ static int ima_path_check_integrity(struct path *path, int mask)
 			struct vfsmount *mnt = mntget(path->mnt);
 			struct file *file;
 
-			file = dentry_open(de, mnt, O_RDONLY);
+			file = dentry_open(de, mnt, O_RDONLY, current->cred);
 			if (IS_ERR(file)) {
 				ima_info("%s dentry_open failed\n",
 					 de->d_name.name);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index c887379..f803d1a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -92,7 +92,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
-	if ((rule->flags & IMA_UID) && rule->uid != tsk->uid)
+	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
 		return false;
 	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc;
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 29518a6..142ba8b 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -48,7 +48,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "integrity: pid=%d uid=%u auid=%u",
-			 current->pid, current->uid,
+			 current->pid, current->cred->uid,
 			 audit_get_loginuid(current));
 	audit_log_task_context(ab);
 	switch (audit_msgno) {
-- 
1.5.6.5

