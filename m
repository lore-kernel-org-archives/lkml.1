Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYGGQ4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYGGQ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYGGQur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:47 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755674AbYGGQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:41 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/20] selinux: support deferred mapping of contexts
Date: Tue,  8 Jul 2008 01:42:03 +0900
Message-Id: <1215448942-17581-2-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Introduce SELinux support for deferred mapping of security contexts in
the SID table upon policy reload, and use this support for inode
security contexts when the context is not yet valid under the current
policy.  Only processes with CAP_MAC_ADMIN + mac_admin permission in
policy can set undefined security contexts on inodes.  Inodes with
such undefined contexts are treated as having the unlabeled context
until the context becomes valid upon a policy reload that defines the
context.  Context invalidation upon policy reload also uses this
support to save the context information in the SID table and later
recover it upon a subsequent policy reload that defines the context
again.

This support is to enable package managers and similar programs to set
down file contexts unknown to the system policy at the time the file
is created in order to better support placing loadable policy modules
in packages and to support build systems that need to create images of
different distro releases with different policies w/o requiring all of
the contexts to be defined or legal in the build host policy.

With this patch applied, the following sequence is possible, although
in practice it is recommended that this permission only be allowed to
specific program domains such as the package manager.

# rmdir baz
# rm bar
# touch bar
# chcon -t foo_exec_t bar # foo_exec_t is not yet defined
chcon: failed to change context of `bar' to `system_u:object_r:foo_exec_t': Invalid argument
# mkdir -Z system_u:object_r:foo_exec_t baz
mkdir: failed to set default file creation context to `system_u:object_r:foo_exec_t': Invalid argument
# cat setundefined.te
policy_module(setundefined, 1.0)
require {
	type unconfined_t;
	type unlabeled_t;
}
files_type(unlabeled_t)
allow unconfined_t self:capability2 mac_admin;
# make -f /usr/share/selinux/devel/Makefile setundefined.pp
# semodule -i setundefined.pp
# chcon -t foo_exec_t bar # foo_exec_t is not yet defined
# mkdir -Z system_u:object_r:foo_exec_t baz
# ls -Zd bar baz
-rw-r--r--  root root system_u:object_r:unlabeled_t    bar
drwxr-xr-x  root root system_u:object_r:unlabeled_t    baz
# cat foo.te
policy_module(foo, 1.0)
type foo_exec_t;
files_type(foo_exec_t)
# make -f /usr/share/selinux/devel/Makefile foo.pp
# semodule -i foo.pp # defines foo_exec_t
# ls -Zd bar baz
-rw-r--r--  root root user_u:object_r:foo_exec_t       bar
drwxr-xr-x  root root system_u:object_r:foo_exec_t    baz
# semodule -r foo
# ls -Zd bar baz
-rw-r--r--  root root system_u:object_r:unlabeled_t    bar
drwxr-xr-x  root root system_u:object_r:unlabeled_t    baz
# semodule -i foo.pp
# ls -Zd bar baz
-rw-r--r--  root root user_u:object_r:foo_exec_t       bar
drwxr-xr-x  root root system_u:object_r:foo_exec_t    baz
# semodule -r setundefined foo
# chcon -t foo_exec_t bar # no longer defined and not allowed
chcon: failed to change context of `bar' to `system_u:object_r:foo_exec_t': Invalid argument
# rmdir baz
# mkdir -Z system_u:object_r:foo_exec_t baz
mkdir: failed to set default file creation context to `system_u:object_r:foo_exec_t': Invalid argument

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/hooks.c            |   20 +++-
 security/selinux/include/security.h |    5 +
 security/selinux/ss/context.h       |   27 ++++-
 security/selinux/ss/mls.c           |   11 +-
 security/selinux/ss/mls.h           |    3 +-
 security/selinux/ss/services.c      |  245 ++++++++++++++++++++++++----------
 security/selinux/ss/sidtab.c        |   58 +++------
 security/selinux/ss/sidtab.h        |    7 +-
 8 files changed, 248 insertions(+), 128 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1c864c0..59c6e98 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2495,7 +2495,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	}
 
 	if (value && len) {
-		rc = security_sid_to_context(newsid, &context, &clen);
+		rc = security_sid_to_context_force(newsid, &context, &clen);
 		if (rc) {
 			kfree(namep);
 			return rc;
@@ -2669,6 +2669,11 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 		return rc;
 
 	rc = security_context_to_sid(value, size, &newsid);
+	if (rc == -EINVAL) {
+		if (!capable(CAP_MAC_ADMIN))
+			return rc;
+		rc = security_context_to_sid_force(value, size, &newsid);
+	}
 	if (rc)
 		return rc;
 
@@ -2703,10 +2708,11 @@ static void selinux_inode_post_setxattr(struct dentry *dentry, const char *name,
 		return;
 	}
 
-	rc = security_context_to_sid(value, size, &newsid);
+	rc = security_context_to_sid_force(value, size, &newsid);
 	if (rc) {
-		printk(KERN_WARNING "%s:  unable to obtain SID for context "
-		       "%s, rc=%d\n", __func__, (char *)value, -rc);
+		printk(KERN_ERR "SELinux:  unable to map context to SID"
+		       "for (%s, %lu), rc=%d\n",
+		       inode->i_sb->s_id, inode->i_ino, -rc);
 		return;
 	}
 
@@ -5153,6 +5159,12 @@ static int selinux_setprocattr(struct task_struct *p,
 			size--;
 		}
 		error = security_context_to_sid(value, size, &sid);
+		if (error == -EINVAL && !strcmp(name, "fscreate")) {
+			if (!capable(CAP_MAC_ADMIN))
+				return error;
+			error = security_context_to_sid_force(value, size,
+							      &sid);
+		}
 		if (error)
 			return error;
 	}
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index ad30ac4..7c54300 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -93,12 +93,17 @@ int security_change_sid(u32 ssid, u32 tsid,
 int security_sid_to_context(u32 sid, char **scontext,
 	u32 *scontext_len);
 
+int security_sid_to_context_force(u32 sid, char **scontext, u32 *scontext_len);
+
 int security_context_to_sid(const char *scontext, u32 scontext_len,
 	u32 *out_sid);
 
 int security_context_to_sid_default(const char *scontext, u32 scontext_len,
 				    u32 *out_sid, u32 def_sid, gfp_t gfp_flags);
 
+int security_context_to_sid_force(const char *scontext, u32 scontext_len,
+				  u32 *sid);
+
 int security_get_user_sids(u32 callsid, char *username,
 			   u32 **sids, u32 *nel);
 
diff --git a/security/selinux/ss/context.h b/security/selinux/ss/context.h
index b9a6f7f..658c2bd 100644
--- a/security/selinux/ss/context.h
+++ b/security/selinux/ss/context.h
@@ -28,6 +28,8 @@ struct context {
 	u32 role;
 	u32 type;
 	struct mls_range range;
+	char *str;	/* string representation if context cannot be mapped. */
+	u32 len;        /* length of string in bytes */
 };
 
 static inline void mls_context_init(struct context *c)
@@ -106,20 +108,43 @@ static inline void context_init(struct context *c)
 
 static inline int context_cpy(struct context *dst, struct context *src)
 {
+	int rc;
+
 	dst->user = src->user;
 	dst->role = src->role;
 	dst->type = src->type;
-	return mls_context_cpy(dst, src);
+	if (src->str) {
+		dst->str = kstrdup(src->str, GFP_ATOMIC);
+		if (!dst->str)
+			return -ENOMEM;
+		dst->len = src->len;
+	} else {
+		dst->str = NULL;
+		dst->len = 0;
+	}
+	rc = mls_context_cpy(dst, src);
+	if (rc) {
+		kfree(dst->str);
+		return rc;
+	}
+	return 0;
 }
 
 static inline void context_destroy(struct context *c)
 {
 	c->user = c->role = c->type = 0;
+	kfree(c->str);
+	c->str = NULL;
+	c->len = 0;
 	mls_context_destroy(c);
 }
 
 static inline int context_cmp(struct context *c1, struct context *c2)
 {
+	if (c1->len && c2->len)
+		return (c1->len == c2->len && !strcmp(c1->str, c2->str));
+	if (c1->len || c2->len)
+		return 0;
 	return ((c1->user == c2->user) &&
 		(c1->role == c2->role) &&
 		(c1->type == c2->type) &&
diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index 8b1706b..a6ca058 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -239,7 +239,8 @@ int mls_context_isvalid(struct policydb *p, struct context *c)
  * Policy read-lock must be held for sidtab lookup.
  *
  */
-int mls_context_to_sid(char oldc,
+int mls_context_to_sid(struct policydb *pol,
+		       char oldc,
 		       char **scontext,
 		       struct context *context,
 		       struct sidtab *s,
@@ -286,7 +287,7 @@ int mls_context_to_sid(char oldc,
 		*p++ = 0;
 
 	for (l = 0; l < 2; l++) {
-		levdatum = hashtab_search(policydb.p_levels.table, scontextp);
+		levdatum = hashtab_search(pol->p_levels.table, scontextp);
 		if (!levdatum) {
 			rc = -EINVAL;
 			goto out;
@@ -311,7 +312,7 @@ int mls_context_to_sid(char oldc,
 					*rngptr++ = 0;
 				}
 
-				catdatum = hashtab_search(policydb.p_cats.table,
+				catdatum = hashtab_search(pol->p_cats.table,
 							  scontextp);
 				if (!catdatum) {
 					rc = -EINVAL;
@@ -327,7 +328,7 @@ int mls_context_to_sid(char oldc,
 				if (rngptr) {
 					int i;
 
-					rngdatum = hashtab_search(policydb.p_cats.table, rngptr);
+					rngdatum = hashtab_search(pol->p_cats.table, rngptr);
 					if (!rngdatum) {
 						rc = -EINVAL;
 						goto out;
@@ -395,7 +396,7 @@ int mls_from_string(char *str, struct context *context, gfp_t gfp_mask)
 	if (!tmpstr) {
 		rc = -ENOMEM;
 	} else {
-		rc = mls_context_to_sid(':', &tmpstr, context,
+		rc = mls_context_to_sid(&policydb, ':', &tmpstr, context,
 					NULL, SECSID_NULL);
 		kfree(freestr);
 	}
diff --git a/security/selinux/ss/mls.h b/security/selinux/ss/mls.h
index 0fdf625..1276715 100644
--- a/security/selinux/ss/mls.h
+++ b/security/selinux/ss/mls.h
@@ -30,7 +30,8 @@ int mls_context_isvalid(struct policydb *p, struct context *c);
 int mls_range_isvalid(struct policydb *p, struct mls_range *r);
 int mls_level_isvalid(struct policydb *p, struct mls_level *l);
 
-int mls_context_to_sid(char oldc,
+int mls_context_to_sid(struct policydb *p,
+		       char oldc,
 		       char **scontext,
 		       struct context *context,
 		       struct sidtab *s,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index dcc2e1c..b86ac9d 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -616,6 +616,14 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
 	*scontext = NULL;
 	*scontext_len = 0;
 
+	if (context->len) {
+		*scontext_len = context->len;
+		*scontext = kstrdup(context->str, GFP_ATOMIC);
+		if (!(*scontext))
+			return -ENOMEM;
+		return 0;
+	}
+
 	/* Compute the size of the context. */
 	*scontext_len += strlen(policydb.p_user_val_to_name[context->user - 1]) + 1;
 	*scontext_len += strlen(policydb.p_role_val_to_name[context->role - 1]) + 1;
@@ -655,17 +663,8 @@ const char *security_get_initial_sid_context(u32 sid)
 	return initial_sid_to_string[sid];
 }
 
-/**
- * security_sid_to_context - Obtain a context for a given SID.
- * @sid: security identifier, SID
- * @scontext: security context
- * @scontext_len: length in bytes
- *
- * Write the string representation of the context associated with @sid
- * into a dynamically allocated string of the correct size.  Set @scontext
- * to point to this string and set @scontext_len to the length of the string.
- */
-int security_sid_to_context(u32 sid, char **scontext, u32 *scontext_len)
+static int security_sid_to_context_core(u32 sid, char **scontext,
+					u32 *scontext_len, int force)
 {
 	struct context *context;
 	int rc = 0;
@@ -693,7 +692,10 @@ int security_sid_to_context(u32 sid, char **scontext, u32 *scontext_len)
 		goto out;
 	}
 	POLICY_RDLOCK;
-	context = sidtab_search(&sidtab, sid);
+	if (force)
+		context = sidtab_search_force(&sidtab, sid);
+	else
+		context = sidtab_search(&sidtab, sid);
 	if (!context) {
 		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
 			__func__, sid);
@@ -708,36 +710,44 @@ out:
 
 }
 
-static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
-					u32 *sid, u32 def_sid, gfp_t gfp_flags)
+/**
+ * security_sid_to_context - Obtain a context for a given SID.
+ * @sid: security identifier, SID
+ * @scontext: security context
+ * @scontext_len: length in bytes
+ *
+ * Write the string representation of the context associated with @sid
+ * into a dynamically allocated string of the correct size.  Set @scontext
+ * to point to this string and set @scontext_len to the length of the string.
+ */
+int security_sid_to_context(u32 sid, char **scontext, u32 *scontext_len)
 {
-	char *scontext2;
-	struct context context;
+	return security_sid_to_context_core(sid, scontext, scontext_len, 0);
+}
+
+int security_sid_to_context_force(u32 sid, char **scontext, u32 *scontext_len)
+{
+	return security_sid_to_context_core(sid, scontext, scontext_len, 1);
+}
+
+static int string_to_context_struct(struct policydb *pol,
+				    struct sidtab *sidtabp,
+				    const char *scontext,
+				    u32 scontext_len,
+				    struct context *ctx,
+				    u32 def_sid,
+				    gfp_t gfp_flags)
+{
+	char *scontext2 = NULL;
 	struct role_datum *role;
 	struct type_datum *typdatum;
 	struct user_datum *usrdatum;
 	char *scontextp, *p, oldc;
 	int rc = 0;
 
-	if (!ss_initialized) {
-		int i;
+	context_init(ctx);
 
-		for (i = 1; i < SECINITSID_NUM; i++) {
-			if (!strcmp(initial_sid_to_string[i], scontext)) {
-				*sid = i;
-				goto out;
-			}
-		}
-		*sid = SECINITSID_KERNEL;
-		goto out;
-	}
-	*sid = SECSID_NULL;
-
-	/* Copy the string so that we can modify the copy as we parse it.
-	   The string should already by null terminated, but we append a
-	   null suffix to the copy to avoid problems with the existing
-	   attr package, which doesn't view the null terminator as part
-	   of the attribute value. */
+	/* Copy the string so that we can modify the copy as we parse it. */
 	scontext2 = kmalloc(scontext_len+1, gfp_flags);
 	if (!scontext2) {
 		rc = -ENOMEM;
@@ -746,11 +756,6 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 	memcpy(scontext2, scontext, scontext_len);
 	scontext2[scontext_len] = 0;
 
-	context_init(&context);
-	*sid = SECSID_NULL;
-
-	POLICY_RDLOCK;
-
 	/* Parse the security context. */
 
 	rc = -EINVAL;
@@ -762,15 +767,15 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 		p++;
 
 	if (*p == 0)
-		goto out_unlock;
+		goto out;
 
 	*p++ = 0;
 
-	usrdatum = hashtab_search(policydb.p_users.table, scontextp);
+	usrdatum = hashtab_search(pol->p_users.table, scontextp);
 	if (!usrdatum)
-		goto out_unlock;
+		goto out;
 
-	context.user = usrdatum->value;
+	ctx->user = usrdatum->value;
 
 	/* Extract role. */
 	scontextp = p;
@@ -778,14 +783,14 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 		p++;
 
 	if (*p == 0)
-		goto out_unlock;
+		goto out;
 
 	*p++ = 0;
 
-	role = hashtab_search(policydb.p_roles.table, scontextp);
+	role = hashtab_search(pol->p_roles.table, scontextp);
 	if (!role)
-		goto out_unlock;
-	context.role = role->value;
+		goto out;
+	ctx->role = role->value;
 
 	/* Extract type. */
 	scontextp = p;
@@ -794,33 +799,74 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 	oldc = *p;
 	*p++ = 0;
 
-	typdatum = hashtab_search(policydb.p_types.table, scontextp);
+	typdatum = hashtab_search(pol->p_types.table, scontextp);
 	if (!typdatum)
-		goto out_unlock;
+		goto out;
 
-	context.type = typdatum->value;
+	ctx->type = typdatum->value;
 
-	rc = mls_context_to_sid(oldc, &p, &context, &sidtab, def_sid);
+	rc = mls_context_to_sid(pol, oldc, &p, ctx, sidtabp, def_sid);
 	if (rc)
-		goto out_unlock;
+		goto out;
 
 	if ((p - scontext2) < scontext_len) {
 		rc = -EINVAL;
-		goto out_unlock;
+		goto out;
 	}
 
 	/* Check the validity of the new context. */
-	if (!policydb_context_isvalid(&policydb, &context)) {
+	if (!policydb_context_isvalid(pol, ctx)) {
 		rc = -EINVAL;
-		goto out_unlock;
+		context_destroy(ctx);
+		goto out;
 	}
-	/* Obtain the new sid. */
-	rc = sidtab_context_to_sid(&sidtab, &context, sid);
-out_unlock:
-	POLICY_RDUNLOCK;
-	context_destroy(&context);
+	rc = 0;
+out:
 	kfree(scontext2);
+	return rc;
+}
+
+static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
+					u32 *sid, u32 def_sid, gfp_t gfp_flags,
+					int force)
+{
+	struct context context;
+	int rc = 0;
+
+	if (!ss_initialized) {
+		int i;
+
+		for (i = 1; i < SECINITSID_NUM; i++) {
+			if (!strcmp(initial_sid_to_string[i], scontext)) {
+				*sid = i;
+				goto out;
+			}
+		}
+		*sid = SECINITSID_KERNEL;
+		goto out;
+	}
+	*sid = SECSID_NULL;
+
+	POLICY_RDLOCK;
+	rc = string_to_context_struct(&policydb, &sidtab,
+				      scontext, scontext_len,
+				      &context, def_sid, gfp_flags);
+	if (rc == -EINVAL && force) {
+		context.str = kmalloc(scontext_len+1, gfp_flags);
+		if (!context.str) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		memcpy(context.str, scontext, scontext_len);
+		context.str[scontext_len] = 0;
+		context.len = scontext_len;
+	} else if (rc)
+		goto out;
+	rc = sidtab_context_to_sid(&sidtab, &context, sid);
+	if (rc)
+		context_destroy(&context);
 out:
+	POLICY_RDUNLOCK;
 	return rc;
 }
 
@@ -838,7 +884,7 @@ out:
 int security_context_to_sid(const char *scontext, u32 scontext_len, u32 *sid)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
-					    sid, SECSID_NULL, GFP_KERNEL);
+					    sid, SECSID_NULL, GFP_KERNEL, 0);
 }
 
 /**
@@ -855,6 +901,7 @@ int security_context_to_sid(const char *scontext, u32 scontext_len, u32 *sid)
  * The default SID is passed to the MLS layer to be used to allow
  * kernel labeling of the MLS field if the MLS field is not present
  * (for upgrading to MLS without full relabel).
+ * Implicitly forces adding of the context even if it cannot be mapped yet.
  * Returns -%EINVAL if the context is invalid, -%ENOMEM if insufficient
  * memory is available, or 0 on success.
  */
@@ -862,7 +909,14 @@ int security_context_to_sid_default(const char *scontext, u32 scontext_len,
 				    u32 *sid, u32 def_sid, gfp_t gfp_flags)
 {
 	return security_context_to_sid_core(scontext, scontext_len,
-					    sid, def_sid, gfp_flags);
+					    sid, def_sid, gfp_flags, 1);
+}
+
+int security_context_to_sid_force(const char *scontext, u32 scontext_len,
+				  u32 *sid)
+{
+	return security_context_to_sid_core(scontext, scontext_len,
+					    sid, SECSID_NULL, GFP_KERNEL, 1);
 }
 
 static int compute_sid_handle_invalid_context(
@@ -1246,9 +1300,12 @@ static inline int convert_context_handle_invalid_context(struct context *context
 		char *s;
 		u32 len;
 
-		context_struct_to_string(context, &s, &len);
-		printk(KERN_ERR "SELinux:  context %s is invalid\n", s);
-		kfree(s);
+		if (!context_struct_to_string(context, &s, &len)) {
+			printk(KERN_WARNING
+		       "SELinux:  Context %s would be invalid if enforcing\n",
+			       s);
+			kfree(s);
+		}
 	}
 	return rc;
 }
@@ -1280,6 +1337,32 @@ static int convert_context(u32 key,
 
 	args = p;
 
+	if (c->str) {
+		struct context ctx;
+		rc = string_to_context_struct(args->newp, NULL, c->str,
+					      c->len, &ctx, SECSID_NULL,
+					      GFP_KERNEL);
+		if (!rc) {
+			printk(KERN_INFO
+		       "SELinux:  Context %s became valid (mapped).\n",
+			       c->str);
+			/* Replace string with mapped representation. */
+			kfree(c->str);
+			memcpy(c, &ctx, sizeof(*c));
+			goto out;
+		} else if (rc == -EINVAL) {
+			/* Retain string representation for later mapping. */
+			rc = 0;
+			goto out;
+		} else {
+			/* Other error condition, e.g. ENOMEM. */
+			printk(KERN_ERR
+		       "SELinux:   Unable to map context %s, rc = %d.\n",
+			       c->str, -rc);
+			goto out;
+		}
+	}
+
 	rc = context_cpy(&oldc, c);
 	if (rc)
 		goto out;
@@ -1319,13 +1402,21 @@ static int convert_context(u32 key,
 	}
 
 	context_destroy(&oldc);
+	rc = 0;
 out:
 	return rc;
 bad:
-	context_struct_to_string(&oldc, &s, &len);
+	/* Map old representation to string and save it. */
+	if (context_struct_to_string(&oldc, &s, &len))
+		return -ENOMEM;
 	context_destroy(&oldc);
-	printk(KERN_ERR "SELinux:  invalidating context %s\n", s);
-	kfree(s);
+	context_destroy(c);
+	c->str = s;
+	c->len = len;
+	printk(KERN_INFO
+	       "SELinux:  Context %s became invalid (unmapped).\n",
+	       c->str);
+	rc = 0;
 	goto out;
 }
 
@@ -1406,7 +1497,11 @@ int security_load_policy(void *data, size_t len)
 		return -EINVAL;
 	}
 
-	sidtab_init(&newsidtab);
+	if (sidtab_init(&newsidtab)) {
+		LOAD_UNLOCK;
+		policydb_destroy(&newpolicydb);
+		return -ENOMEM;
+	}
 
 	/* Verify that the kernel defined classes are correct. */
 	if (validate_classes(&newpolicydb)) {
@@ -1429,11 +1524,15 @@ int security_load_policy(void *data, size_t len)
 		goto err;
 	}
 
-	/* Convert the internal representations of contexts
-	   in the new SID table and remove invalid SIDs. */
+	/*
+	 * Convert the internal representations of contexts
+	 * in the new SID table.
+	 */
 	args.oldp = &policydb;
 	args.newp = &newpolicydb;
-	sidtab_map_remove_on_error(&newsidtab, convert_context, &args);
+	rc = sidtab_map(&newsidtab, convert_context, &args);
+	if (rc)
+		goto err;
 
 	/* Save the old policydb and SID table to free later. */
 	memcpy(&oldpolicydb, &policydb, sizeof policydb);
@@ -1673,6 +1772,8 @@ int security_get_user_sids(u32 fromsid,
 
 	POLICY_RDLOCK;
 
+	context_init(&usercon);
+
 	fromcon = sidtab_search(&sidtab, fromsid);
 	if (!fromcon) {
 		rc = -EINVAL;
diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index 4a516ff..ba35416 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -86,7 +86,7 @@ out:
 	return rc;
 }
 
-struct context *sidtab_search(struct sidtab *s, u32 sid)
+static struct context *sidtab_search_core(struct sidtab *s, u32 sid, int force)
 {
 	int hvalue;
 	struct sidtab_node *cur;
@@ -99,7 +99,10 @@ struct context *sidtab_search(struct sidtab *s, u32 sid)
 	while (cur != NULL && sid > cur->sid)
 		cur = cur->next;
 
-	if (cur == NULL || sid != cur->sid) {
+	if (force && cur && sid == cur->sid && cur->context.len)
+		return &cur->context;
+
+	if (cur == NULL || sid != cur->sid || cur->context.len) {
 		/* Remap invalid SIDs to the unlabeled SID. */
 		sid = SECINITSID_UNLABELED;
 		hvalue = SIDTAB_HASH(sid);
@@ -113,6 +116,16 @@ struct context *sidtab_search(struct sidtab *s, u32 sid)
 	return &cur->context;
 }
 
+struct context *sidtab_search(struct sidtab *s, u32 sid)
+{
+	return sidtab_search_core(s, sid, 0);
+}
+
+struct context *sidtab_search_force(struct sidtab *s, u32 sid)
+{
+	return sidtab_search_core(s, sid, 1);
+}
+
 int sidtab_map(struct sidtab *s,
 	       int (*apply) (u32 sid,
 			     struct context *context,
@@ -138,43 +151,6 @@ out:
 	return rc;
 }
 
-void sidtab_map_remove_on_error(struct sidtab *s,
-				int (*apply) (u32 sid,
-					      struct context *context,
-					      void *args),
-				void *args)
-{
-	int i, ret;
-	struct sidtab_node *last, *cur, *temp;
-
-	if (!s)
-		return;
-
-	for (i = 0; i < SIDTAB_SIZE; i++) {
-		last = NULL;
-		cur = s->htable[i];
-		while (cur != NULL) {
-			ret = apply(cur->sid, &cur->context, args);
-			if (ret) {
-				if (last)
-					last->next = cur->next;
-				else
-					s->htable[i] = cur->next;
-				temp = cur;
-				cur = cur->next;
-				context_destroy(&temp->context);
-				kfree(temp);
-				s->nel--;
-			} else {
-				last = cur;
-				cur = cur->next;
-			}
-		}
-	}
-
-	return;
-}
-
 static inline u32 sidtab_search_context(struct sidtab *s,
 						  struct context *context)
 {
@@ -215,6 +191,10 @@ int sidtab_context_to_sid(struct sidtab *s,
 			goto unlock_out;
 		}
 		sid = s->next_sid++;
+		if (context->len)
+			printk(KERN_INFO
+		       "SELinux:  Context %s is not valid (left unmapped).\n",
+			       context->str);
 		ret = sidtab_insert(s, sid, context);
 		if (ret)
 			s->next_sid--;
diff --git a/security/selinux/ss/sidtab.h b/security/selinux/ss/sidtab.h
index 2fe9dfa..64ea5b1 100644
--- a/security/selinux/ss/sidtab.h
+++ b/security/selinux/ss/sidtab.h
@@ -32,6 +32,7 @@ struct sidtab {
 int sidtab_init(struct sidtab *s);
 int sidtab_insert(struct sidtab *s, u32 sid, struct context *context);
 struct context *sidtab_search(struct sidtab *s, u32 sid);
+struct context *sidtab_search_force(struct sidtab *s, u32 sid);
 
 int sidtab_map(struct sidtab *s,
 	       int (*apply) (u32 sid,
@@ -39,12 +40,6 @@ int sidtab_map(struct sidtab *s,
 			     void *args),
 	       void *args);
 
-void sidtab_map_remove_on_error(struct sidtab *s,
-				int (*apply) (u32 sid,
-					      struct context *context,
-					      void *args),
-				void *args);
-
 int sidtab_context_to_sid(struct sidtab *s,
 			  struct context *context,
 			  u32 *sid);
-- 
1.5.5.1

