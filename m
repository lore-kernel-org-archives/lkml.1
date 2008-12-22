Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbYLVEQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbYLVEQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 23:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYLVEQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 23:16:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:8685 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYLVEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 23:16:23 -0500
Message-ID: <494F148F.8070101@larces.uece.br>
Date: Mon, 22 Dec 2008 01:16:15 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       LSM <linux-security-module@vger.kernel.org>,
       LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH] smackfs: check for allocation failures in smk_set_access()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 smackfs: check for allocation failures in smk_set_access() 

 While adding a new subject/object pair to smack_list, smk_set_access()
 didn't check the return of kzalloc(). 

 This patch changes smk_set_access() to return 0 or -ENOMEM, based on 
 kzalloc()'s return. It also updates its caller, smk_write_load(), to
 check for smk_set_access()'s return, given it is no longer a void 
 return function.

 Signed-off-by: Sergio Luis <sergio@larces.uece.br>
 To: Casey Schaufler <casey@schaufler-ca.com>
 Cc: Ahmed S. Darwish <darwish.07@gmail.com>
 Cc: LSM <linux-security-module@vger.kernel.org>
 Cc: LKLM <linux-kernel@vger.kernel.org>

 security/smack/smackfs.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index c21d8c8..44eb933 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -185,11 +185,15 @@ static int smk_open_load(struct inode *inode, struct file *file)
  * the subject/object pair and replaces the access that was
  * there. If the pair isn't found add it with the specified
  * access.
+ *
+ * Returns 0 if nothing goes wrong or -ENOMEM if it fails
+ * during the allocation of the new pair to add.
  */
-static void smk_set_access(struct smack_rule *srp)
+static int smk_set_access(struct smack_rule *srp)
 {
 	struct smk_list_entry *sp;
 	struct smk_list_entry *newp;
+	int ret = 0;
 
 	mutex_lock(&smack_list_lock);
 
@@ -202,14 +206,20 @@ static void smk_set_access(struct smack_rule *srp)
 
 	if (sp == NULL) {
 		newp = kzalloc(sizeof(struct smk_list_entry), GFP_KERNEL);
+		if (newp == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
 		newp->smk_rule = *srp;
 		newp->smk_next = smack_list;
 		smack_list = newp;
 	}
 
+out:
 	mutex_unlock(&smack_list_lock);
 
-	return;
+	return ret;
 }
 
 /**
@@ -309,8 +319,10 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	smk_set_access(&rule);
-	rc = count;
+	rc = smk_set_access(&rule);
+
+	if (!rc)
+		rc = count;
 
 out:
 	kfree(data);
