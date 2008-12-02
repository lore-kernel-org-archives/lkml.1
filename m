Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYLBVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYLBVtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYLBVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:48:30 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34865 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYLBVs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:48:26 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 5/6] integrity: IMA policy
Date: Tue,  2 Dec 2008 16:47:59 -0500
Message-Id: <7cdd1813f3e4f7ef9d7db343dc1b67229ab1da04.1228253619.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
In-Reply-To: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for a user loadable policy through securityfs
with support for LSM specific policy data.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
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
index 6c6fcd9..3d5ccdb 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -32,3 +32,10 @@ config IMA_MEASURE_PCR_IDX
 	  IMA_MEASURE_PCR_IDX determines the TPM PCR register index
 	  that IMA uses to maintain the integrity aggregate of the
 	  measurement list.  If unsure, use the default 10.
+
+config IMA_LSM_RULES
+	bool "Enable LSM measurement policy rules"
+	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
+	default y
+	help
+	  Disabling this option will not enforce LSM based policy rules.
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 795b552..5bab990 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -171,4 +171,26 @@ int ima_add_rule(int, char *subj_user, char *subj_role, char *subj_type,
 		 char *func, char *mask, char *fsmagic, char *uid);
 void ima_init_policy(void);
 void ima_update_policy(void);
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
+#endif
 #endif
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 2627e56..0742520 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -280,11 +280,141 @@ static struct file_operations ima_ascii_measurements_ops = {
 	.release = seq_release,
 };
 
+static char *get_tag(char *bufStart, char *bufEnd, char delimiter, int *taglen)
+{
+	char *bufp = bufStart;
+	char *tag;
+
+	/* Get start of tag */
+	while (bufp < bufEnd) {
+		if (*bufp == ' ')	/* skip blanks */
+			while ((*bufp == ' ') && (bufp++ < bufEnd)) ;
+		else if (*bufp == '#') {	/* skip comment */
+			while ((*bufp != '\n') && (bufp++ < bufEnd)) ;
+			bufp++;
+		} else if (*bufp == '\n')	/* skip newline */
+			bufp++;
+		else if (*bufp == '\t')	/* skip tabs */
+			bufp++;
+		else
+			break;
+	}
+	if (bufp < bufEnd)
+		tag = bufp;
+	else
+		return NULL;
+
+	/* Get tag */
+	*taglen = 0;
+	while ((bufp < bufEnd) && (*taglen == 0)) {
+		if ((*bufp == delimiter) || (*bufp == '\n')) {
+			*taglen = bufp - tag;
+			*bufp = '\0';
+		}
+		bufp++;
+	}
+	if (*taglen == 0)	/* Didn't find end delimiter */
+		tag = NULL;
+	return tag;
+}
+
+static ssize_t ima_write_policy(struct file *file, const char __user *buf,
+				size_t buflen, loff_t *ppos)
+{
+	size_t rc = 0, datalen;
+	int action = 0;
+	char *data, *datap, *dataend;
+	char *subj_user = NULL, *subj_role = NULL, *subj_type = NULL;
+	char *obj_user = NULL, *obj_role = NULL, *obj_type = NULL;
+	char *func = NULL, *mask = NULL, *fsmagic = NULL, *uid = NULL;
+	int err = 0;
+	char *tag;
+	int taglen, i;
+
+	datalen = buflen > 4095 ? 4095 : buflen;
+	data = kmalloc(datalen + 1, GFP_KERNEL);
+	if (!data)
+		rc = -ENOMEM;
+
+	if (copy_from_user(data, buf, datalen)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	rc = datalen;
+	*(data + datalen) = ' ';
+
+	datap = data;
+	dataend = data + datalen;
+
+	if (strncmp(datap, "measure", 7) == 0) {
+		datap += 8;
+		action = 1;
+	} else if (strncmp(datap, "dont_measure", 12) == 0)
+		datap += 13;
+	else			/* bad format */
+		goto out;
+
+	for (i = 0; i < 6; i++) {
+		tag = get_tag(datap, dataend, ' ', &taglen);
+		if (!tag)
+			break;
+		if (strncmp(tag, "obj_user=", 9) == 0)
+			obj_user = tag + 9;
+		else if (strncmp(tag, "obj_role=", 9) == 0)
+			obj_role = tag + 9;
+		else if (strncmp(tag, "obj_type=", 9) == 0)
+			obj_type = tag + 9;
+		else if (strncmp(tag, "subj_user=", 10) == 0)
+			subj_user = tag + 10;
+		else if (strncmp(tag, "subj_role=", 10) == 0)
+			subj_role = tag + 10;
+		else if (strncmp(tag, "subj_type=", 10) == 0)
+			subj_type = tag + 10;
+		else if (strncmp(tag, "func=", 5) == 0)
+			func = tag + 5;
+		else if (strncmp(tag, "mask=", 5) == 0)
+			mask = tag + 5;
+		else if (strncmp(tag, "fsmagic=", 8) == 0)
+			fsmagic = tag + 8;
+		else if (strncmp(tag, "uid=", 4) == 0)
+			uid = tag + 4;
+		else {		/* bad format */
+			err = 1;
+			break;
+		}
+		datap += taglen + 1;
+	}
+
+	if (!err)
+		ima_add_rule(action, subj_user, subj_role, subj_type,
+			     obj_user, obj_role, obj_type,
+			     func, mask, fsmagic, uid);
+out:
+	if (!data)
+		kfree(data);
+	return rc;
+}
+
 static struct dentry *ima_dir;
 static struct dentry *binary_runtime_measurements;
 static struct dentry *ascii_runtime_measurements;
 static struct dentry *runtime_measurements_count;
 static struct dentry *violations;
+static struct dentry *ima_policy;
+
+static int ima_release_policy(struct inode *inode, struct file *file)
+{
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
@@ -319,13 +449,17 @@ int ima_fs_init(void)
 	if (!violations || IS_ERR(violations))
 		goto out;
 
+	ima_policy = securityfs_create_file("policy",
+					    S_IRUSR | S_IRGRP | S_IWUSR,
+					    ima_dir, NULL,
+					    &ima_measure_policy_ops);
 	return 0;
-
 out:
 	securityfs_remove(runtime_measurements_count);
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_dir);
+	securityfs_remove(ima_policy);
 	return -1;
 }
 
@@ -336,4 +470,5 @@ void __exit ima_fs_cleanup(void)
 	securityfs_remove(ascii_runtime_measurements);
 	securityfs_remove(binary_runtime_measurements);
 	securityfs_remove(ima_dir);
+	securityfs_remove(ima_policy);
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 260f71c..c887379 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -8,6 +8,7 @@
  *
  * ima_policy.c
  * 	- initialize default measure policy rules
+	- load a policy ruleset
  *
  */
 #include <linux/module.h>
@@ -19,9 +20,18 @@
 
 #include "ima.h"
 
+#define MAX_LSM_RULES 6
+enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
+	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE
+};
+
 struct ima_measure_rule_entry {
 	struct list_head list;
 	int action;
+	struct {
+		void *rule;
+		int type;	/* audit type */
+	} lsm_field[MAX_LSM_RULES];
 	unsigned int flags;
 	enum lim_hooks func;
 	int mask;
@@ -55,8 +65,11 @@ static struct ima_measure_rule_entry default_rules[] = {
 };
 
 static struct list_head measure_default_rules;
+static struct list_head measure_policy_rules;
 static struct list_head *ima_measure;
 
+static DEFINE_MUTEX(ima_measure_mutex);
+
 /**
  * ima_match_rules - determine whether an inode matches the measure rule.
  * @rule: a pointer to a rule
@@ -70,6 +83,7 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 			    struct inode *inode, enum lim_hooks func, int mask)
 {
 	struct task_struct *tsk = current;
+	int i;
 
 	if ((rule->flags & IMA_FUNC) && rule->func != func)
 		return false;
@@ -80,6 +94,39 @@ static bool ima_match_rules(struct ima_measure_rule_entry *rule,
 		return false;
 	if ((rule->flags & IMA_UID) && rule->uid != tsk->uid)
 		return false;
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		int rc;
+		u32 osid, sid;
+
+		if (!rule->lsm_field[i].rule)
+			continue;
+
+		switch (i) {
+		case LSM_OBJ_USER:
+		case LSM_OBJ_ROLE:
+		case LSM_OBJ_TYPE:
+			security_inode_getsecid(inode, &osid);
+			rc = security_filter_rule_match(osid,
+							rule->lsm_field[i].type,
+							AUDIT_EQUAL,
+							rule->lsm_field[i].rule,
+							NULL);
+			break;
+		case LSM_SUBJ_USER:
+		case LSM_SUBJ_ROLE:
+		case LSM_SUBJ_TYPE:
+			security_task_getsecid(tsk, &sid);
+			rc = security_filter_rule_match(sid,
+							rule->lsm_field[i].type,
+							AUDIT_EQUAL,
+							rule->lsm_field[i].rule,
+							NULL);
+		default:
+			break;
+		}
+		if (!rc)
+			return false;
+	}
 	return true;
 }
 
@@ -121,4 +168,164 @@ void ima_init_policy(void)
 	for (i = 0; i < ARRAY_SIZE(default_rules); i++)
 		list_add_tail(&default_rules[i].list, &measure_default_rules);
 	ima_measure = &measure_default_rules;
+
+	INIT_LIST_HEAD(&measure_policy_rules);
+}
+
+/**
+ * ima_update_policy - update default_rules with new measure rules
+ *
+ * Wait to update the default rules with a complete new set of measure rules.
+ */
+void ima_update_policy(void)
+{
+	char *op = "policy_update";
+	char *cause = "already exists";
+	int result = 1;
+
+	if (ima_measure == &measure_default_rules) {
+		ima_measure = &measure_policy_rules;
+		cause = "complete";
+		result = 0;
+	}
+	integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+			    NULL, op, cause, result);
+}
+
+/**
+ * ima_add_rule - add ima measure rules
+ * @action: integer 1 indicating MEASURE, 0 indicating DONT_MEASURE
+ * @subj_user: pointer to an LSM subject's user value
+ * @subj_role:  pointer to an LSM subject's role value
+ * @subj_type:  pointer to an LSM subject's type value
+ * @obj_user: pointer to an LSM object's user value
+ * @obj_role:  pointer to an LSM object's role value
+ * @obj_type:  pointer to an LSM object's type value
+ * @func: LIM hook identifier
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ * @fsmagic: fs magic hex value string
+ * @uid: uid value string
+ *
+ * Returns 0 on success, an error code on failure.
+ */
+int ima_add_rule(int action,
+		 char *subj_user, char *subj_role, char *subj_type,
+		 char *obj_user, char *obj_role, char *obj_type,
+		 char *func, char *mask, char *fsmagic, char *uid)
+{
+	struct ima_measure_rule_entry *entry;
+	int i, result = 0;
+
+	/* Prevent installed policy from changing */
+	if (ima_measure != &measure_default_rules) {
+		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
+				    NULL, "policy_update", "already exists", 0);
+		return -EACCES;
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	INIT_LIST_HEAD(&entry->list);
+	if (action < 0 || action > 1)
+		result = -EINVAL;
+	else
+		entry->action = action;
+
+	if (!result && subj_user) {
+		i = LSM_SUBJ_USER;
+		entry->lsm_field[i].type = AUDIT_SUBJ_USER;
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, subj_user,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && subj_role) {
+		i = LSM_SUBJ_ROLE;
+		entry->lsm_field[i].type = AUDIT_SUBJ_ROLE;
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, subj_role,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && subj_type) {
+		i = LSM_SUBJ_TYPE;
+		entry->lsm_field[i].type = AUDIT_SUBJ_TYPE;
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, subj_type,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && obj_user) {
+		i = LSM_OBJ_USER;
+		entry->lsm_field[i].type = AUDIT_OBJ_USER;
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, obj_user,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && obj_role) {
+		i = LSM_OBJ_ROLE;
+		entry->lsm_field[i].type = AUDIT_OBJ_ROLE;
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, obj_role,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && obj_type) {
+		i = LSM_OBJ_TYPE;
+		entry->lsm_field[i].type = AUDIT_OBJ_TYPE;
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, obj_type,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && func) {
+		if (strcmp(func, "PATH_CHECK") == 0)
+			entry->func = PATH_CHECK;
+		else if (strcmp(func, "FILE_MMAP") == 0)
+			entry->func = FILE_MMAP;
+		else if (strcmp(func, "BPRM_CHECK") == 0)
+			entry->func = BPRM_CHECK;
+		else
+			result = -EINVAL;
+		if (!result)
+			entry->flags |= IMA_FUNC;
+	}
+	if (!result && mask) {
+		if (strcmp(mask, "MAY_EXEC") == 0)
+			entry->mask = MAY_EXEC;
+		else if (strcmp(mask, "MAY_WRITE") == 0)
+			entry->mask = MAY_WRITE;
+		else if (strcmp(mask, "MAY_READ") == 0)
+			entry->mask = MAY_READ;
+		else if (strcmp(mask, "MAY_APPEND") == 0)
+			entry->mask = MAY_APPEND;
+		else
+			result = -EINVAL;
+		if (!result)
+			entry->flags |= IMA_MASK;
+	}
+	if (!result && fsmagic) {
+		int rc;
+
+		rc = strict_strtoul(fsmagic, 16, &entry->fsmagic);
+		if (rc)
+			result = -EINVAL;
+		else
+			entry->flags |= IMA_FSMAGIC;
+	}
+	if (!result && uid) {
+		unsigned long lnum;
+		int rc;
+
+		rc = strict_strtoul(uid, 10, &lnum);
+		if (rc)
+			result = -EINVAL;
+		else {
+			entry->uid = (uid_t) lnum;
+			if (entry->uid != lnum)
+				result = -EINVAL;
+			else
+				entry->flags |= IMA_UID;
+		}
+	}
+	if (!result) {
+		mutex_lock(&ima_measure_mutex);
+		list_add_tail(&entry->list, &measure_policy_rules);
+		mutex_unlock(&ima_measure_mutex);
+	}
+	return result;
 }
-- 
1.5.6.5

