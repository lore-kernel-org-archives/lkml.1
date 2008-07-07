Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYGGQyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYGGQyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYGGQu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:26 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753880AbYGGQuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:23 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] SELinux: drop load_mutex in security_load_policy
Date: Tue,  8 Jul 2008 01:42:16 +0900
Message-Id: <1215448942-17581-15-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

We used to protect against races of policy load in security_load_policy
by using the load_mutex.  Since then we have added a new mutex,
sel_mutex, in sel_write_load() which is always held across all calls to
security_load_policy we are covered and can safely just drop this one.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/services.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f26a8ca..543fd0f 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -71,7 +71,6 @@ int selinux_policycap_openperm;
 extern const struct selinux_class_perm selinux_class_perm;
 
 static DEFINE_RWLOCK(policy_rwlock);
-static DEFINE_MUTEX(load_mutex);
 
 static struct sidtab sidtab;
 struct policydb policydb;
@@ -1453,17 +1452,13 @@ int security_load_policy(void *data, size_t len)
 	int rc = 0;
 	struct policy_file file = { data, len }, *fp = &file;
 
-	mutex_lock(&load_mutex);
-
 	if (!ss_initialized) {
 		avtab_cache_init();
 		if (policydb_read(&policydb, fp)) {
-			mutex_unlock(&load_mutex);
 			avtab_cache_destroy();
 			return -EINVAL;
 		}
 		if (policydb_load_isids(&policydb, &sidtab)) {
-			mutex_unlock(&load_mutex);
 			policydb_destroy(&policydb);
 			avtab_cache_destroy();
 			return -EINVAL;
@@ -1472,7 +1467,6 @@ int security_load_policy(void *data, size_t len)
 		if (validate_classes(&policydb)) {
 			printk(KERN_ERR
 			       "SELinux:  the definition of a class is incorrect\n");
-			mutex_unlock(&load_mutex);
 			sidtab_destroy(&sidtab);
 			policydb_destroy(&policydb);
 			avtab_cache_destroy();
@@ -1482,7 +1476,6 @@ int security_load_policy(void *data, size_t len)
 		policydb_loaded_version = policydb.policyvers;
 		ss_initialized = 1;
 		seqno = ++latest_granting;
-		mutex_unlock(&load_mutex);
 		selinux_complete_init();
 		avc_ss_reset(seqno);
 		selnl_notify_policyload(seqno);
@@ -1495,13 +1488,10 @@ int security_load_policy(void *data, size_t len)
 	sidtab_hash_eval(&sidtab, "sids");
 #endif
 
-	if (policydb_read(&newpolicydb, fp)) {
-		mutex_unlock(&load_mutex);
+	if (policydb_read(&newpolicydb, fp))
 		return -EINVAL;
-	}
 
 	if (sidtab_init(&newsidtab)) {
-		mutex_unlock(&load_mutex);
 		policydb_destroy(&newpolicydb);
 		return -ENOMEM;
 	}
@@ -1549,7 +1539,6 @@ int security_load_policy(void *data, size_t len)
 	seqno = ++latest_granting;
 	policydb_loaded_version = policydb.policyvers;
 	write_unlock_irq(&policy_rwlock);
-	mutex_unlock(&load_mutex);
 
 	/* Free the old policydb and SID table. */
 	policydb_destroy(&oldpolicydb);
@@ -1563,7 +1552,6 @@ int security_load_policy(void *data, size_t len)
 	return 0;
 
 err:
-	mutex_unlock(&load_mutex);
 	sidtab_destroy(&newsidtab);
 	policydb_destroy(&newpolicydb);
 	return rc;
-- 
1.5.5.1

