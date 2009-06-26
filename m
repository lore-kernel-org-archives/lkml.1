Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbZFZPZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbZFZPZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZFZPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:24:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33671 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZFZPYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:24:54 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] integrity: add ima_counts_put
Date: Fri, 26 Jun 2009 11:24:34 -0400
Message-Id: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an imbalance message as reported by J.R. Okajima.
The IMA file counters are incremented in ima_path_check. If the
actual open fails, such as ETXTBSY, decrement the counters to
prevent unnecessary imbalance messages.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/namei.c                        |    7 +++++++
 include/linux/ima.h               |    6 ++++++
 security/integrity/ima/ima_main.c |   29 ++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 527119a..5abba79 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1758,6 +1758,10 @@ do_last:
 			goto exit;
 		}
 		filp = nameidata_to_filp(&nd, open_flag);
+		if (IS_ERR(filp))
+			ima_counts_put(&nd.path,
+				       acc_mode & (MAY_READ | MAY_WRITE |
+						   MAY_EXEC));
 		mnt_drop_write(nd.path.mnt);
 		return filp;
 	}
@@ -1812,6 +1816,9 @@ ok:
 		goto exit;
 	}
 	filp = nameidata_to_filp(&nd, open_flag);
+	if (IS_ERR(filp))
+		ima_counts_put(&nd.path,
+			       acc_mode & (MAY_READ | MAY_WRITE | MAY_EXEC));
 	/*
 	 * It is now safe to drop the mnt write
 	 * because the filp has had a write taken
diff --git a/include/linux/ima.h b/include/linux/ima.h
index b1b827d..57ab5fd 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -24,6 +24,7 @@ extern int ima_path_check(struct path *path, int mask, int update_counts);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern void ima_counts_get(struct file *file);
+extern void ima_counts_put(struct path *path, int mask);
 
 #else
 static inline int ima_bprm_check(struct linux_binprm *bprm)
@@ -60,5 +61,10 @@ static inline void ima_counts_get(struct file *file)
 {
 	return;
 }
+
+static inline void ima_counts_put(struct path *path, int mask);)
+{
+	return;
+}
 #endif /* CONFIG_IMA_H */
 #endif /* _LINUX_IMA_H */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 6f61187..101c512 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -238,7 +238,34 @@ out:
 }
 
 /*
- * ima_opens_get - increment file counts
+ * ima_counts_put - decrement file counts
+ *
+ * File counts are incremented in ima_path_check. On file open
+ * error, such as ETXTBSY, decrement the counts to prevent
+ * unnecessary imbalance messages.
+ */
+void ima_counts_put(struct path *path, int mask)
+{
+	struct inode *inode = path->dentry->d_inode;
+	struct ima_iint_cache *iint;
+
+	if (!ima_initialized || !S_ISREG(inode->i_mode))
+		return;
+	iint = ima_iint_find_insert_get(inode);
+	if (!iint)
+		return;
+
+	mutex_lock(&iint->mutex);
+	iint->opencount--;
+	if ((mask & MAY_WRITE) || (mask == 0))
+		iint->writecount--;
+	else if (mask & (MAY_READ | MAY_EXEC))
+		iint->readcount--;
+	mutex_unlock(&iint->mutex);
+}
+
+/*
+ * ima_counts_get - increment file counts
  *
  * - for IPC shm and shmat file.
  * - for nfsd exported files.
-- 
1.6.0.6

