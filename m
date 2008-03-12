Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYCLMWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYCLMWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYCLMWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:22:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:4393 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYCLMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=fOJbKLRtnJsiI8CyuUJPOsMVdEVRzhXdUdVuYSBTwQ35g34Uo2Zz/XrQP/1QmjMrv5CYJrZIjKxb11Mc9RSn2HF3BxryL3ChG7Lj1a87sveDBWwwgU2qLyCVvVbqdoNp9jMEZR+NxAiLGg5OkqAQFAA/Pf9n53y4f4PksQSpvU8=
Date: Wed, 12 Mar 2008 14:18:47 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>
Subject: [PATCH -v2b] Smack: Integrate with Audit
Message-ID: <20080312121847.GA7678@ubuntu>
References: <20080312024446.GA5820@ubuntu> <602525.379.qm@web36612.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602525.379.qm@web36612.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!,

[ Minor styling fixes ]

-->

Setup the new Audit hooks for Smack. SELinux Audit rule fields 
are recycled to avoid `auditd' userspace modifications.
Currently only equality testing is supported on labels acting 
as a subject (AUDIT_SUBJ_USER) or as an object (AUDIT_OBJ_USER).

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index afa7967..f999ab5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -26,6 +26,7 @@
 #include <linux/pipe_fs_i.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
+#include <linux/audit.h>
 
 #include "smack.h"
 
@@ -759,6 +760,18 @@ static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 	return -EINVAL;
 }
 
+/**
+ * smack_inode_getsecid - Extract inode's security id
+ * @inode: inode to extract the info from
+ * @secid: where result will be saved
+ */
+static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
+{
+	struct inode_smack *isp = inode->i_security;
+
+	*secid = smack_to_secid(isp->smk_inode);
+}
+
 /*
  * File Hooks
  */
@@ -1814,6 +1827,18 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 	return smk_curacc(isp, may);
 }
 
+/**
+ * smack_ipc_getsecid - Extract smack security id
+ * @ipcp: the object permissions
+ * @secid: where result will be saved
+ */
+static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
+{
+	char *smack = ipp->security;
+
+	*secid = smack_to_secid(smack);
+}
+
 /* module stacking operations */
 
 /**
@@ -2391,6 +2416,124 @@ static int smack_key_permission(key_ref_t key_ref,
 #endif /* CONFIG_KEYS */
 
 /*
+ * Smack Audit hooks
+ *
+ * Audit requires a unique representation of each Smack specific
+ * rule. This unique representation is used to distinguish the
+ * object to be audited from remaining kernel objects and also
+ * works as a glue between the audit hooks.
+ *
+ * Since repository entries are added but never deleted, we'll use
+ * the smack_known label address related to the given audit rule as
+ * the needed unique representation. This also better fits the smack
+ * model where nearly everything is a label.
+ */
+#ifdef CONFIG_AUDIT
+
+/**
+ * smack_audit_rule_init - Initialize a smack audit rule
+ * @field: audit rule fields given from user-space (audit.h)
+ * @op: required testing operator (=, !=, >, <, ...)
+ * @rulestr: smack label to be audited
+ * @vrule: pointer to save our own audit rule representation
+ *
+ * Prepare to audit cases where (@field @op @rulestr) is true.
+ * The label to be audited is created if necessay.
+ */
+static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
+{
+	char **rule = (char **)vrule;
+	*rule = NULL;
+
+	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
+		return -EINVAL;
+
+	if (op != AUDIT_EQUAL && op != AUDIT_NOT_EQUAL)
+		return -EINVAL;
+
+	*rule = smk_import(rulestr, 0);
+
+	return 0;
+}
+
+/**
+ * smack_audit_rule_known - Distinguish Smack audit rules
+ * @krule: rule of interest, in Audit kernel representation format
+ *
+ * This is used to filter Smack rules from remaining Audit ones.
+ * If it's proved that this rule belongs to us, the
+ * audit_rule_match hook will be called to do the final judgement.
+ */
+static int smack_audit_rule_known(struct audit_krule *krule)
+{
+	struct audit_field *f;
+	int i;
+
+	for (i = 0; i < krule->field_count; i++) {
+		f = &krule->fields[i];
+
+		if (f->type == AUDIT_SUBJ_USER || f->type == AUDIT_OBJ_USER)
+			return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * smack_audit_rule_match - Audit given object ?
+ * @secid: security id for identifying the object to test
+ * @field: audit rule flags given from user-space
+ * @op: required testing operator
+ * @vrule: smack internal rule presentation
+ * @actx: audit context associated with the check
+ *
+ * The core Audit hook. It's used to take the decision of
+ * whether to audit or not to audit a given object.
+ */
+static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
+				  struct audit_context *actx)
+{
+	char *smack;
+	char *rule = vrule;
+
+	if (!rule) {
+		audit_log(actx, GFP_KERNEL, AUDIT_SELINUX_ERR,
+			  "Smack: missing rule\n");
+		return -ENOENT;
+	}
+
+	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
+		return 0;
+
+	smack = smack_from_secid(secid);
+
+	/*
+	 * No need to do string comparisons. If a match occurs,
+	 * both pointers will point to the same smack_known
+	 * label.
+	 */
+	if (op == AUDIT_EQUAL)
+		return (rule == smack);
+	if (op == AUDIT_NOT_EQUAL)
+		return (rule != smack);
+
+	return 0;
+}
+
+/**
+ * smack_audit_rule_free - free smack rule representation
+ * @vrule: rule to be freed.
+ *
+ * No memory was allocated.
+ */
+static void smack_audit_rule_free(void *vrule)
+{
+	/* No-op */
+}
+
+#endif /* CONFIG_AUDIT */
+
+/*
  * smack_secid_to_secctx - return the smack label for a secid
  * @secid: incoming integer
  * @secdata: destination
@@ -2476,6 +2619,7 @@ struct security_operations smack_ops = {
 	.inode_getsecurity = 		smack_inode_getsecurity,
 	.inode_setsecurity = 		smack_inode_setsecurity,
 	.inode_listsecurity = 		smack_inode_listsecurity,
+	.inode_getsecid =		smack_inode_getsecid,
 
 	.file_permission = 		smack_file_permission,
 	.file_alloc_security = 		smack_file_alloc_security,
@@ -2506,6 +2650,7 @@ struct security_operations smack_ops = {
 	.task_to_inode = 		smack_task_to_inode,
 
 	.ipc_permission = 		smack_ipc_permission,
+	.ipc_getsecid =			smack_ipc_getsecid,
 
 	.msg_msg_alloc_security = 	smack_msg_msg_alloc_security,
 	.msg_msg_free_security = 	smack_msg_msg_free_security,
@@ -2550,12 +2695,22 @@ struct security_operations smack_ops = {
 	.sk_free_security = 		smack_sk_free_security,
 	.sock_graft = 			smack_sock_graft,
 	.inet_conn_request = 		smack_inet_conn_request,
+
  /* key management security hooks */
 #ifdef CONFIG_KEYS
 	.key_alloc = 			smack_key_alloc,
 	.key_free = 			smack_key_free,
 	.key_permission = 		smack_key_permission,
 #endif /* CONFIG_KEYS */
+
+ /* Audit hooks */
+#ifdef CONFIG_AUDIT
+	.audit_rule_init =		smack_audit_rule_init,
+	.audit_rule_known =		smack_audit_rule_known,
+	.audit_rule_match =		smack_audit_rule_match,
+	.audit_rule_free =		smack_audit_rule_free,
+#endif /* CONFIG_AUDIT */
+
 	.secid_to_secctx = 		smack_secid_to_secctx,
 	.secctx_to_secid = 		smack_secctx_to_secid,
 	.release_secctx = 		smack_release_secctx,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

