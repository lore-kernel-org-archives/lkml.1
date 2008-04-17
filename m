Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbYDQLIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbYDQLIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbYDQLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:41597 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760859AbYDQLGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:33 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH 06/12] LSM/Audit: Introduce generic Audit LSM hooks
Date: Thu, 17 Apr 2008 11:06:03 +0000
Message-Id: <d7470dd3d3ec489b61e9bd6216c9413ce7b949ef.1208428765.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <darwish.07@gmail.com>

Introduce a generic Audit interface for security modules
by adding the following new LSM hooks:

audit_rule_init(field, op, rulestr, lsmrule)
audit_rule_known(krule)
audit_rule_match(secid, field, op, rule, actx)
audit_rule_free(rule)

Those hooks are only available if CONFIG_AUDIT is enabled.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---
 include/linux/security.h |   72 ++++++++++++++++++++++++++++++++++++++++++++++
 security/dummy.c         |   31 +++++++++++++++++++-
 security/security.c      |   25 ++++++++++++++++
 3 files changed, 127 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 45717d9..697f228 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -37,6 +37,7 @@
 extern unsigned securebits;
 
 struct ctl_table;
+struct audit_krule;
 
 /*
  * These functions are in security/capability.c and are used
@@ -1235,6 +1236,37 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@secdata contains the security context.
  *	@seclen contains the length of the security context.
  *
+ * Security hooks for Audit
+ *
+ * @audit_rule_init:
+ *	Allocate and initialize an LSM audit rule structure.
+ *	@field contains the required Audit action. Fields flags are defined in include/linux/audit.h
+ *	@op contains the operator the rule uses.
+ *	@rulestr contains the context where the rule will be applied to.
+ *	@lsmrule contains a pointer to receive the result.
+ *	Return 0 if @lsmrule has been successfully set,
+ *	-EINVAL in case of an invalid rule.
+ *
+ * @audit_rule_known:
+ *	Specifies whether given @rule contains any fields related to current LSM.
+ *	@rule contains the audit rule of interest.
+ *	Return 1 in case of relation found, 0 otherwise.
+ *
+ * @audit_rule_match:
+ *	Determine if given @secid matches a rule previously approved
+ *	by @audit_rule_known.
+ *	@secid contains the security id in question.
+ *	@field contains the field which relates to current LSM.
+ *	@op contains the operator that will be used for matching.
+ *	@rule points to the audit rule that will be checked against.
+ *	@actx points to the audit context associated with the check.
+ *	Return 1 if secid matches the rule, 0 if it does not, -ERRNO on failure.
+ *
+ * @audit_rule_free:
+ *	Deallocate the LSM audit rule structure previously allocated by
+ *	audit_rule_init.
+ *	@rule contains the allocated rule
+ *
  * This is the main security structure.
  */
 struct security_operations {
@@ -1494,6 +1526,13 @@ struct security_operations {
 
 #endif	/* CONFIG_KEYS */
 
+#ifdef CONFIG_AUDIT
+	int (*audit_rule_init)(u32 field, u32 op, char *rulestr, void **lsmrule);
+	int (*audit_rule_known)(struct audit_krule *krule);
+	int (*audit_rule_match)(u32 secid, u32 field, u32 op, void *lsmrule,
+				struct audit_context *actx);
+	void (*audit_rule_free)(void *lsmrule);
+#endif /* CONFIG_AUDIT */
 };
 
 /* prototypes */
@@ -2700,5 +2739,38 @@ static inline int security_key_permission(key_ref_t key_ref,
 #endif
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_AUDIT
+#ifdef CONFIG_SECURITY
+int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule);
+int security_audit_rule_known(struct audit_krule *krule);
+int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
+			      struct audit_context *actx);
+void security_audit_rule_free(void *lsmrule);
+
+#else
+
+static inline int security_audit_rule_init(u32 field, u32 op, char *rulestr,
+					   void **lsmrule)
+{
+	return 0;
+}
+
+static inline int security_audit_rule_known(struct audit_krule *krule)
+{
+	return 0;
+}
+
+static inline int security_audit_rule_match(u32 secid, u32 field, u32 op,
+				   void *lsmrule, struct audit_context *actx)
+{
+	return 0;
+}
+
+static inline void security_audit_rule_free(void *lsmrule)
+{ }
+
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_AUDIT */
+
 #endif /* ! __LINUX_SECURITY_H */
 
diff --git a/security/dummy.c b/security/dummy.c
index fb2e942..1ac9f8e 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -993,6 +993,30 @@ static inline int dummy_key_permission(key_ref_t key_ref,
 }
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_AUDIT
+static inline int dummy_audit_rule_init(u32 field, u32 op, char *rulestr,
+					void **lsmrule)
+{
+	return 0;
+}
+
+static inline int dummy_audit_rule_known(struct audit_krule *krule)
+{
+	return 0;
+}
+
+static inline int dummy_audit_rule_match(u32 secid, u32 field, u32 op,
+					 void *lsmrule,
+					 struct audit_context *actx)
+{
+	return 0;
+}
+
+static inline void dummy_audit_rule_free(void *lsmrule)
+{ }
+
+#endif /* CONFIG_AUDIT */
+
 struct security_operations dummy_security_ops;
 
 #define set_to_dummy_if_null(ops, function)				\
@@ -1182,6 +1206,11 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, key_free);
 	set_to_dummy_if_null(ops, key_permission);
 #endif	/* CONFIG_KEYS */
-
+#ifdef CONFIG_AUDIT
+	set_to_dummy_if_null(ops, audit_rule_init);
+	set_to_dummy_if_null(ops, audit_rule_known);
+	set_to_dummy_if_null(ops, audit_rule_match);
+	set_to_dummy_if_null(ops, audit_rule_free);
+#endif
 }
 
diff --git a/security/security.c b/security/security.c
index 33e59a7..bf189d2 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1120,3 +1120,28 @@ int security_key_permission(key_ref_t key_ref,
 }
 
 #endif	/* CONFIG_KEYS */
+
+#ifdef CONFIG_AUDIT
+
+int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
+{
+	return security_ops->audit_rule_init(field, op, rulestr, lsmrule);
+}
+
+int security_audit_rule_known(struct audit_krule *krule)
+{
+	return security_ops->audit_rule_known(krule);
+}
+
+void security_audit_rule_free(void *lsmrule)
+{
+	security_ops->audit_rule_free(lsmrule);
+}
+
+int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
+			      struct audit_context *actx)
+{
+	return security_ops->audit_rule_match(secid, field, op, lsmrule, actx);
+}
+
+#endif /* CONFIG_AUDIT */
-- 
1.5.4.2

