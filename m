Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYGGQxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYGGQxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYGGQuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:17 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755243AbYGGQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:14 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] SELinux: open code load_mutex
Date: Tue,  8 Jul 2008 01:42:13 +0900
Message-Id: <1215448942-17581-12-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open code load_mutex as suggested by Andrew Morton.

Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/services.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index e8ec54d..d06df33 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -71,10 +71,7 @@ int selinux_policycap_openperm;
 extern const struct selinux_class_perm selinux_class_perm;
 
 static DEFINE_RWLOCK(policy_rwlock);
-
 static DEFINE_MUTEX(load_mutex);
-#define LOAD_LOCK mutex_lock(&load_mutex)
-#define LOAD_UNLOCK mutex_unlock(&load_mutex)
 
 static struct sidtab sidtab;
 struct policydb policydb;
@@ -1456,17 +1453,17 @@ int security_load_policy(void *data, size_t len)
 	int rc = 0;
 	struct policy_file file = { data, len }, *fp = &file;
 
-	LOAD_LOCK;
+	mutex_lock(&load_mutex);
 
 	if (!ss_initialized) {
 		avtab_cache_init();
 		if (policydb_read(&policydb, fp)) {
-			LOAD_UNLOCK;
+			mutex_unlock(&load_mutex);
 			avtab_cache_destroy();
 			return -EINVAL;
 		}
 		if (policydb_load_isids(&policydb, &sidtab)) {
-			LOAD_UNLOCK;
+			mutex_unlock(&load_mutex);
 			policydb_destroy(&policydb);
 			avtab_cache_destroy();
 			return -EINVAL;
@@ -1475,7 +1472,7 @@ int security_load_policy(void *data, size_t len)
 		if (validate_classes(&policydb)) {
 			printk(KERN_ERR
 			       "SELinux:  the definition of a class is incorrect\n");
-			LOAD_UNLOCK;
+			mutex_unlock(&load_mutex);
 			sidtab_destroy(&sidtab);
 			policydb_destroy(&policydb);
 			avtab_cache_destroy();
@@ -1485,7 +1482,7 @@ int security_load_policy(void *data, size_t len)
 		policydb_loaded_version = policydb.policyvers;
 		ss_initialized = 1;
 		seqno = ++latest_granting;
-		LOAD_UNLOCK;
+		mutex_unlock(&load_mutex);
 		selinux_complete_init();
 		avc_ss_reset(seqno);
 		selnl_notify_policyload(seqno);
@@ -1499,12 +1496,12 @@ int security_load_policy(void *data, size_t len)
 #endif
 
 	if (policydb_read(&newpolicydb, fp)) {
-		LOAD_UNLOCK;
+		mutex_unlock(&load_mutex);
 		return -EINVAL;
 	}
 
 	if (sidtab_init(&newsidtab)) {
-		LOAD_UNLOCK;
+		mutex_unlock(&load_mutex);
 		policydb_destroy(&newpolicydb);
 		return -ENOMEM;
 	}
@@ -1552,7 +1549,7 @@ int security_load_policy(void *data, size_t len)
 	seqno = ++latest_granting;
 	policydb_loaded_version = policydb.policyvers;
 	write_unlock_irq(&policy_rwlock);
-	LOAD_UNLOCK;
+	mutex_unlock(&load_mutex);
 
 	/* Free the old policydb and SID table. */
 	policydb_destroy(&oldpolicydb);
@@ -1566,7 +1563,7 @@ int security_load_policy(void *data, size_t len)
 	return 0;
 
 err:
-	LOAD_UNLOCK;
+	mutex_unlock(&load_mutex);
 	sidtab_destroy(&newsidtab);
 	policydb_destroy(&newpolicydb);
 	return rc;
-- 
1.5.5.1

