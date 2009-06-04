Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbZFDRyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbZFDRyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZFDRx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:53:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33451 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZFDRxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:53:55 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       vibi sreenivasan <vibi_sreenivasan@cms.com>,
       Jiri Slaby <jirislaby@gmail.com>, Eric Paris <eparis@redhat.com>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] integrity: ima audit dentry_open failure
Date: Thu,  4 Jun 2009 13:53:10 -0400
Message-Id: <1244137990-12678-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until we start appraising measurements, the ima_path_check()
return code should always be 0.

- Update the ima_path_check() return code comment
- Instead of the pr_info, audit the dentry_open failure

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

---
 security/integrity/ima/ima_main.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a2eb233..6f61187 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -149,8 +149,8 @@ static void ima_update_counts(struct ima_iint_cache *iint, int mask)
  *	- Opening a file for read when already open for write,
  * 	  could result in a file measurement error.
  *
- * Return 0 on success, an error code on failure.
- * (Based on the results of appraise_measurement().)
+ * Always return 0 and audit dentry_open failures.
+ * (Return code will be based upon measurement appraisal.)
  */
 int ima_path_check(struct path *path, int mask, int update_counts)
 {
@@ -189,8 +189,13 @@ int ima_path_check(struct path *path, int mask, int update_counts)
 		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
 				   current_cred());
 		if (IS_ERR(file)) {
-			pr_info("%s dentry_open failed\n", dentry->d_name.name);
-			rc = PTR_ERR(file);
+			int audit_info = 0;
+
+			integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
+					    dentry->d_name.name,
+					    "add_measurement",
+					    "dentry_open failed",
+					    1, audit_info);
 			file = NULL;
 			goto out;
 		}
-- 
1.6.0.6

