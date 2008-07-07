Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYGGQyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYGGQyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYGGQu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:29 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755478AbYGGQuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:25 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] SELinux: fix sleeping allocation in security_context_to_sid
Date: Tue,  8 Jul 2008 01:42:04 +0900
Message-Id: <1215448942-17581-3-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Fix a sleeping function called from invalid context bug by moving allocation
to the callers prior to taking the policy rdlock.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/services.c |   70 +++++++++++++++++++++++-----------------
 1 files changed, 40 insertions(+), 30 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index b86ac9d..2d5e5a3 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -730,15 +730,16 @@ int security_sid_to_context_force(u32 sid, char **scontext, u32 *scontext_len)
 	return security_sid_to_context_core(sid, scontext, scontext_len, 1);
 }
 
+/*
+ * Caveat:  Mutates scontext.
+ */
 static int string_to_context_struct(struct policydb *pol,
 				    struct sidtab *sidtabp,
-				    const char *scontext,
+				    char *scontext,
 				    u32 scontext_len,
 				    struct context *ctx,
-				    u32 def_sid,
-				    gfp_t gfp_flags)
+				    u32 def_sid)
 {
-	char *scontext2 = NULL;
 	struct role_datum *role;
 	struct type_datum *typdatum;
 	struct user_datum *usrdatum;
@@ -747,19 +748,10 @@ static int string_to_context_struct(struct policydb *pol,
 
 	context_init(ctx);
 
-	/* Copy the string so that we can modify the copy as we parse it. */
-	scontext2 = kmalloc(scontext_len+1, gfp_flags);
-	if (!scontext2) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	memcpy(scontext2, scontext, scontext_len);
-	scontext2[scontext_len] = 0;
-
 	/* Parse the security context. */
 
 	rc = -EINVAL;
-	scontextp = (char *) scontext2;
+	scontextp = (char *) scontext;
 
 	/* Extract the user. */
 	p = scontextp;
@@ -809,7 +801,7 @@ static int string_to_context_struct(struct policydb *pol,
 	if (rc)
 		goto out;
 
-	if ((p - scontext2) < scontext_len) {
+	if ((p - scontext) < scontext_len) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -822,7 +814,6 @@ static int string_to_context_struct(struct policydb *pol,
 	}
 	rc = 0;
 out:
-	kfree(scontext2);
 	return rc;
 }
 
@@ -830,6 +821,7 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 					u32 *sid, u32 def_sid, gfp_t gfp_flags,
 					int force)
 {
+	char *scontext2, *str = NULL;
 	struct context context;
 	int rc = 0;
 
@@ -839,27 +831,38 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 		for (i = 1; i < SECINITSID_NUM; i++) {
 			if (!strcmp(initial_sid_to_string[i], scontext)) {
 				*sid = i;
-				goto out;
+				return 0;
 			}
 		}
 		*sid = SECINITSID_KERNEL;
-		goto out;
+		return 0;
 	}
 	*sid = SECSID_NULL;
 
+	/* Copy the string so that we can modify the copy as we parse it. */
+	scontext2 = kmalloc(scontext_len+1, gfp_flags);
+	if (!scontext2)
+		return -ENOMEM;
+	memcpy(scontext2, scontext, scontext_len);
+	scontext2[scontext_len] = 0;
+
+	if (force) {
+		/* Save another copy for storing in uninterpreted form */
+		str = kstrdup(scontext2, gfp_flags);
+		if (!str) {
+			kfree(scontext2);
+			return -ENOMEM;
+		}
+	}
+
 	POLICY_RDLOCK;
 	rc = string_to_context_struct(&policydb, &sidtab,
-				      scontext, scontext_len,
-				      &context, def_sid, gfp_flags);
+				      scontext2, scontext_len,
+				      &context, def_sid);
 	if (rc == -EINVAL && force) {
-		context.str = kmalloc(scontext_len+1, gfp_flags);
-		if (!context.str) {
-			rc = -ENOMEM;
-			goto out;
-		}
-		memcpy(context.str, scontext, scontext_len);
-		context.str[scontext_len] = 0;
+		context.str = str;
 		context.len = scontext_len;
+		str = NULL;
 	} else if (rc)
 		goto out;
 	rc = sidtab_context_to_sid(&sidtab, &context, sid);
@@ -867,6 +870,8 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 		context_destroy(&context);
 out:
 	POLICY_RDUNLOCK;
+	kfree(scontext2);
+	kfree(str);
 	return rc;
 }
 
@@ -1339,9 +1344,14 @@ static int convert_context(u32 key,
 
 	if (c->str) {
 		struct context ctx;
-		rc = string_to_context_struct(args->newp, NULL, c->str,
-					      c->len, &ctx, SECSID_NULL,
-					      GFP_KERNEL);
+		s = kstrdup(c->str, GFP_KERNEL);
+		if (!s) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc = string_to_context_struct(args->newp, NULL, s,
+					      c->len, &ctx, SECSID_NULL);
+		kfree(s);
 		if (!rc) {
 			printk(KERN_INFO
 		       "SELinux:  Context %s became valid (mapped).\n",
-- 
1.5.5.1

