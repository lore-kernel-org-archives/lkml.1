Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbYCAUDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbYCAUDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbYCAUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:03:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:29262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbYCAUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:03:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=NTJ3RpFHs/UgKUXslcqAj9rZ1LoDMxwn6gambg7kr9mLKhk2ouHxCVz2O07PEIgvMqeWaqjd01aSVHsbO33JYrpx4YKm0RMNdVg/jxkOzc9CsId4UPcGTNmB6JpwiuW4umNoDGB/jryf1meDnJLZM6zGr/Ek1QDiMpjlt/snTXo=
Date: Sat, 1 Mar 2008 22:00:05 +0200
To: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>, Paul Moore <paul.moore@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Audit-ML <linux-audit@redhat.com>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: [PATCH 6/9] LSM/Audit: Introduce generic Audit LSM hooks
Message-ID: <20080301200005.GG19636@ubuntu>
References: <20080301194752.GA19636@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301194752.GA19636@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a generic Audit interface for security modules
by adding the following new LSM hooks:

audit_rule_init(field, op, rulestr, lsmrule)
audit_rule_known(krule)
audit_rule_match(secid, field, op, rule, actx)
audit_rule_free(rule)

Those hooks are only available if CONFIG_AUDIT is enabled.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 include/linux/security.h |   72 +++++++++++++++++++++++++++++++++++++++++++++++
 security/dummy.c         |   31 +++++++++++++++++++-
 security/security.c      |   25 ++++++++++++++++
 3 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index b5d1ad7..eb663e5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -43,6 +43,7 @@
 extern unsigned securebits;
 
 struct ctl_table;
+struct audit_krule;
 
 /*
  * These functions are in security/capability.c and are used
@@ -1227,6 +1228,37 @@ struct request_sock;
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
@@ -1487,6 +1519,13 @@ struct security_operations {
 	int (*key_getsecurity)(struct key *key, char **_buffer);
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
@@ -2670,5 +2709,38 @@ static inline int security_key_getsecurity(struct key *key, char **_buffer)
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
index b4967f4..241ab20 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -998,6 +998,30 @@ static int dummy_key_getsecurity(struct key *key, char **_buffer)
 
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
@@ -1187,6 +1211,11 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, key_permission);
 	set_to_dummy_if_null(ops, key_getsecurity);
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
index 1748329..1bf2ee4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1118,3 +1118,28 @@ int security_key_getsecurity(struct key *key, char **_buffer)
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

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

