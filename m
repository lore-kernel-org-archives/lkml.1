Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbZBDOVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbZBDOVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZBDOTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:36 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55229 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZBDOTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:31 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 5/7] integrity: IMA policy open
Date: Wed,  4 Feb 2009 09:07:01 -0500
Message-Id: <c0d05ed6a2ee379d6a2760a1ffe97a50b9a5dfc8.1233750617.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sequentialize access to the policy file
- permit multiple attempts to replace default policy with a valid policy

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 95ef1ca..573780c 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -277,16 +277,30 @@ static struct dentry *runtime_measurements_count;
 static struct dentry *violations;
 static struct dentry *ima_policy;
 
+static atomic_t policy_opencount = ATOMIC_INIT(1);
+/*
+ * ima_open_policy: sequentialize access to the policy file
+ */
+int ima_open_policy(struct inode * inode, struct file * filp)
+{
+	if (atomic_dec_and_test(&policy_opencount))
+		return 0;
+	return -EBUSY;
+}
+
 /*
  * ima_release_policy - start using the new measure policy rules.
  *
  * Initially, ima_measure points to the default policy rules, now
- * point to the new policy rules, and remove the securityfs policy file.
+ * point to the new policy rules, and remove the securityfs policy file,
+ * assuming a valid policy.
  */
 static int ima_release_policy(struct inode *inode, struct file *file)
 {
 	if (!valid_policy) {
 		ima_delete_rules();
+		valid_policy = 1;
+		atomic_set(&policy_opencount, 1);
 		return 0;
 	}
 	ima_update_policy();
@@ -296,6 +310,7 @@ static int ima_release_policy(struct inode *inode, struct file *file)
 }
 
 static struct file_operations ima_measure_policy_ops = {
+	.open = ima_open_policy,
 	.write = ima_write_policy,
 	.release = ima_release_policy
 };
-- 
1.5.6.6

