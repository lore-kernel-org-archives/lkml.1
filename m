Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbXGICzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbXGICzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbXGICzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:55:47 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:59710 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbXGICzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:55:46 -0400
Date: Sun, 8 Jul 2007 22:55:43 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] selinux: add support for querying object classes and
 permissions from the running policy
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082255070.12256@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christopher J. PeBenito <cpebenito@tresys.com>

Add support to the SELinux security server for obtaining a list of classes,
and for obtaining a list of permissions for a specified class.

Signed-off-by: Christopher J. PeBenito <cpebenito@tresys.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/security.h |    3 +
 security/selinux/ss/services.c      |   95 +++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index b94378a..731a173 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -87,6 +87,9 @@ int security_validate_transition(u32 oldsid, u32 newsid, u32 tasksid,
 
 int security_sid_mls_copy(u32 sid, u32 mls_sid, u32 *new_sid);
 
+int security_get_classes(char ***classes, int *nclasses);
+int security_get_permissions(char *class, char ***perms, int *nperms);
+
 #define SECURITY_FS_USE_XATTR		1 /* use xattr */
 #define SECURITY_FS_USE_TRANS		2 /* use transition SIDs, e.g. devpts/tmpfs */
 #define SECURITY_FS_USE_TASK		3 /* use task SIDs, e.g. pipefs/sockfs */
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 40660ff..e4249ad 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1996,6 +1996,101 @@ out:
 	return rc;
 }
 
+static int get_classes_callback(void *k, void *d, void *args)
+{
+	struct class_datum *datum = d;
+	char *name = k, **classes = args;
+	int value = datum->value - 1;
+
+	classes[value] = kstrdup(name, GFP_ATOMIC);
+	if (!classes[value])
+		return -ENOMEM;
+
+	return 0;
+}
+
+int security_get_classes(char ***classes, int *nclasses)
+{
+	int rc = -ENOMEM;
+
+	POLICY_RDLOCK;
+
+	*nclasses = policydb.p_classes.nprim;
+	*classes = kcalloc(*nclasses, sizeof(*classes), GFP_ATOMIC);
+	if (!*classes)
+		goto out;
+
+	rc = hashtab_map(policydb.p_classes.table, get_classes_callback,
+			*classes);
+	if (rc < 0) {
+		int i;
+		for (i = 0; i < *nclasses; i++)
+			kfree((*classes)[i]);
+		kfree(*classes);
+	}
+
+out:
+	POLICY_RDUNLOCK;
+	return rc;
+}
+
+static int get_permissions_callback(void *k, void *d, void *args)
+{
+	struct perm_datum *datum = d;
+	char *name = k, **perms = args;
+	int value = datum->value - 1;
+
+	perms[value] = kstrdup(name, GFP_ATOMIC);
+	if (!perms[value])
+		return -ENOMEM;
+
+	return 0;
+}
+
+int security_get_permissions(char *class, char ***perms, int *nperms)
+{
+	int rc = -ENOMEM, i;
+	struct class_datum *match;
+
+	POLICY_RDLOCK;
+
+	match = hashtab_search(policydb.p_classes.table, class);
+	if (!match) {
+		printk(KERN_ERR "%s:  unrecognized class %s\n",
+			__FUNCTION__, class);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	*nperms = match->permissions.nprim;
+	*perms = kcalloc(*nperms, sizeof(*perms), GFP_ATOMIC);
+	if (!*perms)
+		goto out;
+
+	if (match->comdatum) {
+		rc = hashtab_map(match->comdatum->permissions.table,
+				get_permissions_callback, *perms);
+		if (rc < 0)
+			goto err;
+	}
+
+	rc = hashtab_map(match->permissions.table, get_permissions_callback,
+			*perms);
+	if (rc < 0)
+		goto err;
+
+out:
+	POLICY_RDUNLOCK;
+	return rc;
+
+err:
+	POLICY_RDUNLOCK;
+	for (i = 0; i < *nperms; i++)
+		kfree((*perms)[i]);
+	kfree(*perms);
+	return rc;
+}
+
 struct selinux_audit_rule {
 	u32 au_seqno;
 	struct context au_ctxt;
-- 
1.5.0.6

