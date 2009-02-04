Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbZBDOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbZBDOVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZBDOTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:38 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55228 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZBDOTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:31 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 4/7] integrity: IMA policy
Date: Wed,  4 Feb 2009 09:07:00 -0500
Message-Id: <83c097d4f66515bf4e84c1358dcad6bd919b9a85.1233750616.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
References: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for a user loadable policy through securityfs
with support for LSM specific policy data.
- free invalid rule in ima_parse_add_rule()

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
new file mode 100644
index 0000000..6434f0d
--- /dev/null
+++ b/Documentation/ABI/testing/ima_policy
@@ -0,0 +1,61 @@
+What:		security/ima/policy
+Date:		May 2008
+Contact:	Mimi Zohar <zohar@us.ibm.com>
+Description:
+		The Trusted Computing Group(TCG) runtime Integrity
+		Measurement Architecture(IMA) maintains a list of hash
+		values of executables and other sensitive system files
+		loaded into the run-time of this system.  At runtime,
+		the policy can be constrained based on LSM specific data.
+		Policies are loaded into the securityfs file ima/policy
+		by opening the file, writing the rules one at a time and
+		then closing the file.  The new policy takes effect after
+		the file ima/policy is closed.
+
+		rule format: action [condition ...]
+
+		action: measure | dont_measure
+		condition:= base | lsm
+			base:	[[func=] [mask=] [fsmagic=] [uid=]]
+			lsm:	[[subj_user=] [subj_role=] [subj_type=]
+				 [obj_user=] [obj_role=] [obj_type=]]
+
+		base: 	func:= [BPRM_CHECK][FILE_MMAP][INODE_PERMISSION]
+			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
+			fsmagic:= hex value
+			uid:= decimal value
+		lsm:  	are LSM specific
+
+		default policy:
+			# PROC_SUPER_MAGIC
+			dont_measure fsmagic=0x9fa0
+			# SYSFS_MAGIC
+			dont_measure fsmagic=0x62656572
+			# DEBUGFS_MAGIC
+			dont_measure fsmagic=0x64626720
+			# TMPFS_MAGIC
+			dont_measure fsmagic=0x01021994
+			# SECURITYFS_MAGIC
+			dont_measure fsmagic=0x73636673
+
+			measure func=BPRM_CHECK
+			measure func=FILE_MMAP mask=MAY_EXEC
+			measure func=INODE_PERM mask=MAY_READ uid=0
+
+		The default policy measures all executables in bprm_check,
+		all files mmapped executable in file_mmap, and all files
+		open for read by root in inode_permission.
+
+		Examples of LSM specific definitions:
+
+		SELinux:
+			# SELINUX_MAGIC
+			dont_measure fsmagic=0xF97CFF8C
+
+			dont_measure obj_type=var_log_t
+			dont_measure obj_type=auditd_log_t
+			measure subj_user=system_u func=INODE_PERM mask=MAY_READ
+			measure subj_role=system_r func=INODE_PERM mask=MAY_READ
+
+		Smack:
+			measure subj_user=_ func=INODE_PERM mask=MAY_READ
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 2a761c8..3d2b6ee 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -47,3 +47,9 @@ config IMA_AUDIT
 	  auditing messages can be enabled with 'ima_audit=1' on
 	  the kernel command line.
 
+config IMA_LSM_RULES
+	bool
+	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
+	default y
+	help
+	  Disabling this option will disregard LSM based policy rules
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 9c280cc..42706b5 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -137,4 +137,28 @@ enum ima_hooks { PATH_CHECK = 1, FILE_MMAP, BPRM_CHECK };
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
 void ima_init_policy(void);
 void ima_update_policy(void);
+int ima_parse_add_rule(char *);
+void ima_delete_rules(void);
+
+/* LSM based policy rules require audit */
+#ifdef CONFIG_IMA_LSM_RULES
+
+#define security_filter_rule_init security_audit_rule_init
+#define security_filter_rule_match security_audit_rule_match
+
+#else
+
+static inline int security_filter_rule_init(u32 field, u32 op, char *rulestr,
+					    void **lsmrule)
+{
+	return -EINVAL;
+}
+
+static inline int security_filter_rule_match(u32 secid, u32 field, u32 op,
+					     void *lsmrule,
+					     struct audit_context *actx)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_IMA_LSM_RULES */
 #endif
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 4f25be7..95ef1ca 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -19,9 +19,11 @@
 #include <linux/seq_file.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
+#include <linux/parser.h>
 
 #include "ima.h"
 
+static int valid_policy = 1;
 #define TMPBUFLEN 12
 static ssize_t ima_show_htable_value(char __user *buf, size_t count,
 				     loff_t *ppos, atomic_long_t *val)
@@ -237,11 +239,66 @@ static struct file_operations ima_ascii_measurements_ops = {
 	.release = seq_release,
 };
 
+static ssize_t ima_write_policy(struct file *file, const char __user *buf,
+				size_t datalen, loff_t *ppos)
+{
+	char *data;
+	int rc;
+
+	if (datalen >= PAGE_SIZE)
+		return -ENOMEM;
+	if (*ppos != 0) {
+		/* No partial writes. */
+		return -EINVAL;
+	}
+	data = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, datalen)) {
+		kfree(data);
+		return -EFAULT;
+	}
+	*(data + datalen) = '\0';
+	rc = ima_parse_add_rule(data);
+	if (rc < 0) {
+		datalen = -EINVAL;
+		valid_policy = 0;
+	}
+
+	kfree(data);
+	return datalen;
+}
+
 static struct dentry *ima_dir;
 static struct dentry *binary_runtime_measurements;
 static struct dentry *ascii_runtime_measurements;
 static struct dentry *runtime_measurements_count;
 static struct dentry *violations;
+static struct dentry *ima_policy;
+
+/*
+ * ima_release_policy - start using the new measure policy rules.
+ *
+ * Initially, ima_measure points to the default policy rules, now
+ * point to the new policy rules, and remove the securityfs policy file.
+ */
+static int ima_release_policy(struct inode *inode, struct file *file)
+{
+	if (!valid_policy) {
+		ima_delete_rules();
+		return 0;
+	}
+	ima_update_policy();
+	securityfs_remove(ima_policy);
+	ima_policy = NULL;
+	return 0;
+}
+
+static struct file_operations ima_measure_policy_ops = {
+	.write = ima_write_policy,
+	.release = ima_release_policy
+};
 
 int ima_fs_init(void)
 {
@@ -276,13 +333,20 @@ int ima_fs_init(void)
 	if (IS_ERR(violations))
 		goto out;
 
-	return 0;
+	ima_policy = securityfs_create_file("policy",
+					    S_IRUSR | S_IRGRP | S_IWUSR,
+					    ima_dir, NULL,
+					    &ima_measure_policy_ops);
+	if (IS_ERR(ima_policy))
+		goto out;
 
+	return 0;
 out:
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_dir);
+	securityfs_remove(ima_policy);
 	return -1;
 }
 
@@ -293,4 +357,5 @@ void __exit ima_fs_cleanup(void)
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_dir);
+	securityfs_remove(ima_policy);
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 7c3d1ff..bd45360 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -15,6 +15,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/magic.h>
+#include <linux/parser.h>
 
 #include "ima.h"
 
@@ -24,7 +25,12 @@
 #define IMA_FSMAGIC	0x0004
 #define IMA_UID		0x0008
 
-enum ima_action { DONT_MEASURE, MEASURE };
+enum ima_action { UNKNOWN = -1, DONT_MEASURE = 0, MEASURE };
+
+#define MAX_LSM_RULES 6
+enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
+	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE
+};
 
 struct ima_measure_rule_entry {
 	struct list_head list;
@@ -34,8 +40,15 @@ struct ima_measure_rule_entry {
 	int mask;
 	unsigned long fsmagic;
 	uid_t uid;
+	struct {
+		void *rule;	/* LSM file metadata specific */
+		int type;	/* audit type */
+	} lsm[MAX_LSM_RULES];
 };
 
+/* Without LSM specific knowledge, the default policy can only be
+ * written in terms of .action, .func, .mask, .fsmagic, and .uid
+ */
 static struct ima_measure_rule_entry default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,
 	 .flags = IMA_FSMAGIC},
@@ -54,8 +67,11 @@ static struct ima_measure_rule_entry default_rules[] = {
 };
 
 static LIST_HEAD(measure_default_rules);
+static LIST_HEAD(measure_policy_rules);
 static struct list_head *ima_measure;
 
+static DEFINE_MUTEX(ima_measure_mutex);
+
 /**
  * ima_match_rules - determine whether an inode matches the measure rule.
  * @rule: a pointer to a rule
@@ -69,6 +85,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 			    struct inode *inode, enum ima_hooks func, int mask)
 {
 	struct task_struct *tsk = current;
+	int i;
 
 	if ((rule->flags & IMA_FUNC) && rule->func != func)
 		return false;
@@ -79,6 +96,39 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 		return false;
 	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
 		return false;
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		int rc;
+		u32 osid, sid;
+
+		if (!rule->lsm[i].rule)
+			continue;
+
+		switch (i) {
+		case LSM_OBJ_USER:
+		case LSM_OBJ_ROLE:
+		case LSM_OBJ_TYPE:
+			security_inode_getsecid(inode, &osid);
+			rc = security_filter_rule_match(osid,
+							rule->lsm[i].type,
+							AUDIT_EQUAL,
+							rule->lsm[i].rule,
+							NULL);
+			break;
+		case LSM_SUBJ_USER:
+		case LSM_SUBJ_ROLE:
+		case LSM_SUBJ_TYPE:
+			security_task_getsecid(tsk, &sid);
+			rc = security_filter_rule_match(sid,
+							rule->lsm[i].type,
+							AUDIT_EQUAL,
+							rule->lsm[i].rule,
+							NULL);
+		default:
+			break;
+		}
+		if (!rc)
+			return false;
+	}
 	return true;
 }
 
@@ -112,9 +162,8 @@ int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask)
 /**
  * ima_init_policy - initialize the default measure rules.
  *
- * (Could use the default_rules directly, but in policy patch
  * ima_measure points to either the measure_default_rules or the
- * the new measure_policy_rules.)
+ * the new measure_policy_rules.
  */
 void ima_init_policy(void)
 {
@@ -124,3 +173,241 @@ void ima_init_policy(void)
 		list_add_tail(&default_rules[i].list, &measure_default_rules);
 	ima_measure = &measure_default_rules;
 }
+
+/**
+ * ima_update_policy - update default_rules with new measure rules
+ *
+ * Called on file .release to update the default rules with a complete new
+ * policy.  Once updated, the policy is locked, no additional rules can be
+ * added to the policy.
+ */
+void ima_update_policy(void)
+{
+	const char *op = "policy_update";
+	const char *cause = "already exists";
+	int result = 1;
+	int audit_info = 0;
+
+	if (ima_measure == &measure_default_rules) {
+		ima_measure = &measure_policy_rules;
+		cause = "complete";
+		result = 0;
+	}
+	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+			    NULL, op, cause, result, audit_info);
+}
+
+enum {
+	Opt_err = -1,
+	Opt_measure = 1, Opt_dont_measure,
+	Opt_obj_user, Opt_obj_role, Opt_obj_type,
+	Opt_subj_user, Opt_subj_role, Opt_subj_type,
+	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid
+};
+
+static match_table_t policy_tokens = {
+	{Opt_measure, "measure"},
+	{Opt_dont_measure, "dont_measure"},
+	{Opt_obj_user, "obj_user=%s"},
+	{Opt_obj_role, "obj_role=%s"},
+	{Opt_obj_type, "obj_type=%s"},
+	{Opt_subj_user, "subj_user=%s"},
+	{Opt_subj_role, "subj_role=%s"},
+	{Opt_subj_type, "subj_type=%s"},
+	{Opt_func, "func=%s"},
+	{Opt_mask, "mask=%s"},
+	{Opt_fsmagic, "fsmagic=%s"},
+	{Opt_uid, "uid=%s"},
+	{Opt_err, NULL}
+};
+
+static int ima_lsm_rule_init(struct ima_measure_rule_entry *entry,
+			     char *args, int lsm_rule, int audit_type)
+{
+	int result;
+
+	entry->lsm[lsm_rule].type = audit_type;
+	result = security_filter_rule_init(entry->lsm[lsm_rule].type,
+					   AUDIT_EQUAL, args,
+					   &entry->lsm[lsm_rule].rule);
+	return result;
+}
+
+static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
+{
+	struct audit_buffer *ab;
+	char *p;
+	int result = 0;
+
+	ab = audit_log_start(current->audit_context, GFP_KERNEL,
+			     AUDIT_INTEGRITY_STATUS);
+
+	entry->action = -1;
+	while ((p = strsep(&rule, " \n")) != NULL) {
+		substring_t args[MAX_OPT_ARGS];
+		int token;
+		unsigned long lnum;
+
+		if (result < 0)
+			break;
+		if (!*p)
+			continue;
+		token = match_token(p, policy_tokens, args);
+		switch (token) {
+		case Opt_measure:
+			audit_log_format(ab, "%s ", "measure");
+			entry->action = MEASURE;
+			break;
+		case Opt_dont_measure:
+			audit_log_format(ab, "%s ", "dont_measure");
+			entry->action = DONT_MEASURE;
+			break;
+		case Opt_func:
+			audit_log_format(ab, "func=%s ", args[0].from);
+			if (strcmp(args[0].from, "PATH_CHECK") == 0)
+				entry->func = PATH_CHECK;
+			else if (strcmp(args[0].from, "FILE_MMAP") == 0)
+				entry->func = FILE_MMAP;
+			else if (strcmp(args[0].from, "BPRM_CHECK") == 0)
+				entry->func = BPRM_CHECK;
+			else
+				result = -EINVAL;
+			if (!result)
+				entry->flags |= IMA_FUNC;
+			break;
+		case Opt_mask:
+			audit_log_format(ab, "mask=%s ", args[0].from);
+			if ((strcmp(args[0].from, "MAY_EXEC")) == 0)
+				entry->mask = MAY_EXEC;
+			else if (strcmp(args[0].from, "MAY_WRITE") == 0)
+				entry->mask = MAY_WRITE;
+			else if (strcmp(args[0].from, "MAY_READ") == 0)
+				entry->mask = MAY_READ;
+			else if (strcmp(args[0].from, "MAY_APPEND") == 0)
+				entry->mask = MAY_APPEND;
+			else
+				result = -EINVAL;
+			if (!result)
+				entry->flags |= IMA_MASK;
+			break;
+		case Opt_fsmagic:
+			audit_log_format(ab, "fsmagic=%s ", args[0].from);
+			result = strict_strtoul(args[0].from, 16,
+						&entry->fsmagic);
+			if (!result)
+				entry->flags |= IMA_FSMAGIC;
+			break;
+		case Opt_uid:
+			audit_log_format(ab, "uid=%s ", args[0].from);
+			result = strict_strtoul(args[0].from, 10, &lnum);
+			if (!result) {
+				entry->uid = (uid_t) lnum;
+				if (entry->uid != lnum)
+					result = -EINVAL;
+				else
+					entry->flags |= IMA_UID;
+			}
+			break;
+		case Opt_obj_user:
+			audit_log_format(ab, "obj_user=%s ", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_OBJ_USER,
+						   AUDIT_OBJ_USER);
+			break;
+		case Opt_obj_role:
+			audit_log_format(ab, "obj_role=%s ", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_OBJ_ROLE,
+						   AUDIT_OBJ_ROLE);
+			break;
+		case Opt_obj_type:
+			audit_log_format(ab, "obj_type=%s ", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_OBJ_TYPE,
+						   AUDIT_OBJ_TYPE);
+			break;
+		case Opt_subj_user:
+			audit_log_format(ab, "subj_user=%s ", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_SUBJ_USER,
+						   AUDIT_SUBJ_USER);
+			break;
+		case Opt_subj_role:
+			audit_log_format(ab, "subj_role=%s ", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_SUBJ_ROLE,
+						   AUDIT_SUBJ_ROLE);
+			break;
+		case Opt_subj_type:
+			audit_log_format(ab, "subj_type=%s ", args[0].from);
+			result = ima_lsm_rule_init(entry, args[0].from,
+						   LSM_SUBJ_TYPE,
+						   AUDIT_SUBJ_TYPE);
+			break;
+		case Opt_err:
+			printk(KERN_INFO "%s: unknown token: %s\n",
+			       __FUNCTION__, p);
+			break;
+		}
+	}
+	if (entry->action == UNKNOWN)
+		result = -EINVAL;
+
+	audit_log_format(ab, "res=%d", result);
+	audit_log_end(ab);
+	return result;
+}
+
+/**
+ * ima_parse_add_rule - add a rule to measure_policy_rules
+ * @rule - ima measurement policy rule
+ *
+ * Uses a mutex to protect the policy list from multiple concurrent writers.
+ * Returns 0 on success, an error code on failure.
+ */
+int ima_parse_add_rule(char *rule)
+{
+	const char *op = "add_rule";
+	struct ima_measure_rule_entry *entry;
+	int result = 0;
+	int audit_info = 0;
+
+	/* Prevent installed policy from changing */
+	if (ima_measure != &measure_default_rules) {
+		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+				    NULL, op, "already exists",
+				    -EACCES, audit_info);
+		return -EACCES;
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+				    NULL, op, "-ENOMEM", -ENOMEM, audit_info);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&entry->list);
+
+	result = ima_parse_rule(rule, entry);
+	if (!result) {
+		mutex_lock(&ima_measure_mutex);
+		list_add_tail(&entry->list, &measure_policy_rules);
+		mutex_unlock(&ima_measure_mutex);
+	} else
+		kfree(entry);
+	return result;
+}
+
+/* ima_delete_rules called to cleanup invalid policy */
+void ima_delete_rules()
+{
+	struct ima_measure_rule_entry *entry, *tmp;
+
+	mutex_lock(&ima_measure_mutex);
+	list_for_each_entry_safe(entry, tmp, &measure_policy_rules, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	mutex_unlock(&ima_measure_mutex);
+}
-- 
1.5.6.6

