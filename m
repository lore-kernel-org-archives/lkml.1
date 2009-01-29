Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbZA2WZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbZA2WZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZA2WZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:25:14 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39888 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbZA2WZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:25:10 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 5/6] integrity: IMA policy open
Date: Thu, 29 Jan 2009 17:23:26 -0500
Message-Id: <0ebb89266caaf4a9db2982f8a2e05aa3d1e3da4c.1233262163.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sequentialize access to the policy file
- permit multiple attempts to replace default policy with a valid policy

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 752a344..dde803d 100644
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

