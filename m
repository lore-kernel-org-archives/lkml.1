Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYHATVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYHATVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYHATU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:20:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55161 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYHATU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:20:58 -0400
Subject: [Patch]integrity: ima policy update patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com
Content-Type: text/plain
Date: Fri, 01 Aug 2008 15:20:32 -0400
Message-Id: <1217618432.3401.3.camel@new-host-2.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- This patch adds support for policy definitions defined in terms of
  LSM subj_role, subj_type, and obj_role.
- Support for uid measurement policy definitions.
- Constrain the default INODE_PERMISSION measurement to only measure 
  files opened for read by root.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/security/integrity/ima/ima_policy.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_policy.c
+++ security-testing-2.6/security/integrity/ima/ima_policy.c
@@ -20,29 +20,51 @@ 

 #include "ima.h"
 
+#define MAX_LSM_RULES 6
+enum lsm_rule_types { LSM_OBJ_USER, LSM_OBJ_ROLE, LSM_OBJ_TYPE,
+	LSM_SUBJ_USER, LSM_SUBJ_ROLE, LSM_SUBJ_TYPE
+};
+
+#define audit_type(type) AUDIT_ ##type
+#define lsm_type(type) LSM_ ##type
+
 struct ima_measure_rule_entry {
 	struct list_head list;
 	int action;
-	void *lsm_obj_rule;
-	void *lsm_subj_rule;
-	void *lsm_type_rule;
+	struct {
+		void *rule;
+		int type;	/* audit type */
+	} lsm_field[MAX_LSM_RULES];
+	uint flags;
 	enum lim_hooks func;
 	int mask;
 	ulong fsmagic;
+	uid_t uid;
 };
 
+/* flags definitions */
+#define IMA_FUNC 	0x0001
+#define IMA_MASK 	0x0002
+#define IMA_FSMAGIC	0x0004
+#define IMA_UID		0x0008
+
 /* Without LSM specific knowledge, default policy can only
  * be written in terms of .action, .func, .mask and .fsmagic.
  */
 static struct ima_measure_rule_entry default_rules[] = {
-	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC},
-	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC},
-	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC},
-	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC},
-	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC},
-	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC},
-	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC},
-	{.action = MEASURE,.func = INODE_PERMISSION,.mask = MAY_READ},
+	{.action = DONT_MEASURE,.fsmagic = PROC_SUPER_MAGIC,
+	 .flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
+	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,
+	 .flags = IMA_FSMAGIC},
+	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
+	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
+	 .flags = IMA_FUNC | IMA_MASK},
+	{.action = MEASURE,.func = INODE_PERMISSION,.mask = MAY_READ,.uid = 0,
+	 .flags = IMA_FUNC | IMA_MASK | IMA_UID}
 };
 
 static struct list_head measure_default_rules;
@@ -61,45 +83,50 @@ static DEFINE_MUTEX(ima_measure_mutex);
  * Returns true on rule match, false on failure.
  */
 static bool ima_match_rules(struct ima_measure_rule_entry *rule,
-			   struct inode *inode, enum lim_hooks func, int mask)
+			    struct inode *inode, enum lim_hooks func, int mask)
 {
-	if (rule->func && rule->func != func)
+	struct task_struct *tsk = current;
+	int i;
+
+	if ((rule->flags & IMA_FUNC) && rule->func != func)
 		return false;
-	if (rule->mask && rule->mask != mask)
+	if ((rule->flags & IMA_MASK) && rule->mask != mask)
 		return false;
-	if (rule->fsmagic && rule->fsmagic != inode->i_sb->s_magic)
+	if ((rule->flags & IMA_FSMAGIC)
+	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
-	if (rule->lsm_subj_rule) {
-		struct task_struct *tsk = current;
-		u32 sid;
-		int rc;
-
-		security_task_getsecid(tsk, &sid);
-		rc = security_filter_rule_match(sid, AUDIT_SUBJ_USER,
-						AUDIT_EQUAL,
-						rule->lsm_subj_rule, NULL);
-		if (!rc)
-			return false;
-	}
-	if (rule->lsm_obj_rule) {
-		u32 osid;
+	if ((rule->flags & IMA_UID) && rule->uid != tsk->uid)
+		return false;
+	for (i = 0; i < MAX_LSM_RULES; i++) {
 		int rc;
+		u32 osid, sid;
 
-		security_inode_getsecid(inode, &osid);
-		rc = security_filter_rule_match(osid, AUDIT_OBJ_USER,
-						AUDIT_EQUAL,
-						rule->lsm_obj_rule, NULL);
-		if (!rc)
-			return false;
-	}
-	if (rule->lsm_type_rule) {
-		u32 osid;
-		int rc;
+		if (!rule->lsm_field[i].rule)
+			continue;
 
-		security_inode_getsecid(inode, &osid);
-		rc = security_filter_rule_match(osid, AUDIT_OBJ_TYPE,
-						AUDIT_EQUAL,
-						rule->lsm_type_rule, NULL);
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
 		if (!rc)
 			return false;
 	}
@@ -180,11 +207,13 @@ void ima_update_policy(void)
  *
  * Returns 0 on success, an error code on failure.
  */
-int ima_add_rule(int action, char *subj, char *obj, char *type,
-		 char *func, char *mask, char *fsmagic)
+int ima_add_rule(int action,
+		 char *subj_user, char *subj_role, char *subj_type,
+		 char *obj_user, char *obj_role, char *obj_type,
+		 char *func, char *mask, char *fsmagic, char *uid)
 {
 	struct ima_measure_rule_entry *entry;
-	int result = 0;
+	int i, result = 0;
 
 	/* Prevent installed policy from changing */
 	if (ima_measure != &measure_default_rules) {
@@ -199,15 +228,49 @@ int ima_add_rule(int action, char *subj,
 		result = -EINVAL;
 	else
 		entry->action = action;
-	if (!result && subj)
-		result = security_filter_rule_init(AUDIT_SUBJ_USER, AUDIT_EQUAL,
-						   subj, &entry->lsm_subj_rule);
-	if (!result && obj)
-		result = security_filter_rule_init(AUDIT_OBJ_USER, AUDIT_EQUAL,
-						   obj, &entry->lsm_obj_rule);
-	if (!result && type)
-		result = security_filter_rule_init(AUDIT_OBJ_TYPE, AUDIT_EQUAL,
-						   obj, &entry->lsm_obj_rule);
+
+	if (!result && subj_user) {
+		i = lsm_type(SUBJ_USER);
+		entry->lsm_field[i].type = audit_type(SUBJ_USER);
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, subj_user,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && subj_role) {
+		i = lsm_type(SUBJ_ROLE);
+		entry->lsm_field[i].type = audit_type(SUBJ_ROLE);
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, subj_role,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && subj_type) {
+		i = lsm_type(SUBJ_TYPE);
+		entry->lsm_field[i].type = audit_type(SUBJ_TYPE);
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, subj_type,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && obj_user) {
+		i = lsm_type(OBJ_USER);
+		entry->lsm_field[i].type = audit_type(OBJ_USER);
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, obj_user,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && obj_role) {
+		i = lsm_type(OBJ_ROLE);
+		entry->lsm_field[i].type = audit_type(OBJ_ROLE);
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, obj_role,
+						   &entry->lsm_field[i].rule);
+	}
+	if (!result && obj_type) {
+		i = lsm_type(OBJ_TYPE);
+		entry->lsm_field[i].type = audit_type(OBJ_TYPE);
+		result = security_filter_rule_init(entry->lsm_field[i].type,
+						   AUDIT_EQUAL, obj_type,
+						   &entry->lsm_field[i].rule);
+	}
 	if (!result && func) {
 		if (strcmp(func, "INODE_PERMISSION") == 0)
 			entry->func = INODE_PERMISSION;
@@ -217,6 +280,8 @@ int ima_add_rule(int action, char *subj,
 			entry->func = BPRM_CHECK;
 		else
 			result = -EINVAL;
+		if (!result)
+			entry->flags |= IMA_FUNC;
 	}
 	if (!result && mask) {
 		if (strcmp(mask, "MAY_EXEC") == 0)
@@ -229,6 +294,8 @@ int ima_add_rule(int action, char *subj,
 			entry->mask = MAY_APPEND;
 		else
 			result = -EINVAL;
+		if (!result)
+			entry->flags |= IMA_MASK;
 	}
 	if (!result && fsmagic) {
 		int rc;
@@ -236,6 +303,23 @@ int ima_add_rule(int action, char *subj,
 		rc = strict_strtoul(fsmagic, 16, &entry->fsmagic);
 		if (rc)
 			result = -EINVAL;
+		else
+			entry->flags |= IMA_FSMAGIC;
+	}
+	if (!result && uid) {
+		int rc;
+		ulong lnum;
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
 	}
 	if (!result) {
 		mutex_lock(&ima_measure_mutex);
Index: security-testing-2.6/security/integrity/ima/ima_fs.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_fs.c
+++ security-testing-2.6/security/integrity/ima/ima_fs.c
@@ -313,8 +313,9 @@ static ssize_t ima_write_policy(struct f
 	size_t rc = 0, datalen;
 	int action = 0;
 	char *data, *datap, *dataend;
-	char *subj = NULL, *obj = NULL, *type = NULL;
-	char *func = NULL, *mask = NULL, *fsmagic = NULL;
+	char *subj_user = NULL, *subj_role = NULL, *subj_type = NULL;
+	char *obj_user = NULL, *obj_role = NULL, *obj_type = NULL;
+	char *func = NULL, *mask = NULL, *fsmagic = NULL, *uid = NULL;
 	int err = 0;
 	char *tag;
 	int taglen, i;
@@ -347,18 +348,26 @@ static ssize_t ima_write_policy(struct f
 		tag = get_tag(datap, dataend, ' ', &taglen);
 		if (!tag)
 			break;
-		if (strncmp(tag, "obj=", 4) == 0)
-			obj = tag + 4;
-		else if (strncmp(tag, "subj=", 5) == 0)
-			subj = tag + 5;
-		else if (strncmp(tag, "type=", 5) == 0)
-			type = tag + 5;
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
 		else if (strncmp(tag, "func=", 5) == 0)
 			func = tag + 5;
 		else if (strncmp(tag, "mask=", 5) == 0)
 			mask = tag + 5;
 		else if (strncmp(tag, "fsmagic=", 8) == 0)
 			fsmagic = tag + 8;
+		else if (strncmp(tag, "uid=", 4) == 0)
+			uid = tag + 4;
 		else {		/* bad format */
 			err = 1;
 			break;
@@ -367,10 +376,14 @@ static ssize_t ima_write_policy(struct f
 	}
 
 	if (!err) {
-		ima_info("%s %s %s %s %s %s %s\n",
+		ima_info("%s subj: %s %s %s obj: %s %s %s %s %s %s %s\n",
 			 action ? "measure " : "dont_measure",
-			 subj, obj, type, func, mask, fsmagic);
-		ima_add_rule(action, subj, obj, type, func, mask, fsmagic);
+			 subj_user, subj_role, subj_type,
+			 obj_user, obj_role, obj_type,
+			 func, mask, fsmagic, uid);
+		ima_add_rule(action, subj_user, subj_role, subj_type,
+			     obj_user, obj_role, obj_type,
+			     func, mask, fsmagic, uid);
 	}
 out:
 	if (!data)
Index: security-testing-2.6/security/integrity/ima/ima.h
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima.h
+++ security-testing-2.6/security/integrity/ima/ima.h
@@ -78,7 +78,9 @@ void ima_add_violation(struct inode *ino
 
 enum ima_action {DONT_MEASURE, MEASURE};
 int ima_match_policy(struct inode *inode, enum lim_hooks func, int mask);
-int ima_add_rule(int, char *, char *, char *, char *, char *, char *);
+int ima_add_rule(int, char *subj_user, char *subj_role, char *subj_type,
+		 char *obj_user, char *obj_role, char *obj_type,
+		 char *func, char *mask, char *fsmagic, char *uid);
 void ima_init_policy(void);
 void ima_update_policy(void);
 
Index: security-testing-2.6/Documentation/ABI/testing/ima_policy
===================================================================
--- security-testing-2.6.orig/Documentation/ABI/testing/ima_policy
+++ security-testing-2.6/Documentation/ABI/testing/ima_policy
@@ -16,12 +16,14 @@ Description:
 
 		action: measure | dont_measure
 		condition:= base | lsm
-			base:	[[func=] [mask=] [fsmagic=]]
-			lsm:	[[subj=] [obj=] [type=]]
+			base:	[[func=] [mask=] [fsmagic=] [uid=]]
+			lsm:	[[subj_user=] [subj_role=] [subj_type=]
+				 [obj_user=] [obj_role=] [obj_type=]]
 
 		base: 	func:= [BPRM_CHECK][FILE_MMAP][INODE_PERMISSION]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
 			fsmagic:= hex value
+			uid:= decimal value
 		lsm:  	are LSM specific
 
 		default policy:
@@ -35,21 +37,24 @@ Description:
 			dont_measure fsmagic=0x01021994
 			# SECURITYFS_MAGIC
 			dont_measure fsmagic=0x73636673
+			# SELINUX_MAGIC
+			dont_measure fsmagic=0xF97CFF8C
 
 			measure func=BPRM_CHECK
 			measure func=FILE_MMAP mask=MAY_EXEC
-			measure func=INODE_PERM mask=MAY_READ
+			measure func=INODE_PERM mask=MAY_READ uid=0
 
 		The default policy measures all executables in bprm_check,
 		all files mmapped executable in file_mmap, and all files
-		open for read in inode_permission.
+		open for read by root in inode_permission.
 
 		Examples of LSM specific definitions:
 
 		SELinux:
-			dont_measure type=var_log_t
-			dont_measure type=auditd_log_t
-			measure subj=system_u func=INODE_PERM mask=MAY_READ
+			dont_measure obj_type=var_log_t
+			dont_measure obj_type=auditd_log_t
+			measure subj_user=system_u func=INODE_PERM mask=MAY_READ
+			measure subj_role=system_r func=INODE_PERM mask=MAY_READ
 
 		Smack:
-			measure subj=_ func=INODE_PERM mask=MAY_READ
+			measure subj_user=_ func=INODE_PERM mask=MAY_READ


