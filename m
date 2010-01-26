Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821Ab0AZWCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0AZWCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470Ab0AZWCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:02:51 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50880 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0AZWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:02:50 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] ima: rename PATH_CHECK to FILE_CHECK
Date: Tue, 26 Jan 2010 17:02:41 -0500
Message-Id: <1264543361-3999-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264543361-3999-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1264543361-3999-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the movement of the ima hooks functions were renamed from *path* to
*file* since they always deal with struct file.  This patch renames some of
the ima internal flags to make them consistent with the rest of the code.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---
 Documentation/ABI/testing/ima_policy |   12 ++++++------
 security/integrity/ima/ima.h         |    2 +-
 security/integrity/ima/ima_api.c     |    4 ++--
 security/integrity/ima/ima_main.c    |    4 ++--
 security/integrity/ima/ima_policy.c  |    9 ++++++---
 5 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 6434f0d..6cd6dae 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -20,7 +20,7 @@ Description:
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
 
-		base: 	func:= [BPRM_CHECK][FILE_MMAP][INODE_PERMISSION]
+		base: 	func:= [BPRM_CHECK][FILE_MMAP][FILE_CHECK]
 			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
 			fsmagic:= hex value
 			uid:= decimal value
@@ -40,11 +40,11 @@ Description:
 
 			measure func=BPRM_CHECK
 			measure func=FILE_MMAP mask=MAY_EXEC
-			measure func=INODE_PERM mask=MAY_READ uid=0
+			measure func=FILE_CHECK mask=MAY_READ uid=0
 
 		The default policy measures all executables in bprm_check,
 		all files mmapped executable in file_mmap, and all files
-		open for read by root in inode_permission.
+		open for read by root in do_filp_open.
 
 		Examples of LSM specific definitions:
 
@@ -54,8 +54,8 @@ Description:
 
 			dont_measure obj_type=var_log_t
 			dont_measure obj_type=auditd_log_t
-			measure subj_user=system_u func=INODE_PERM mask=MAY_READ
-			measure subj_role=system_r func=INODE_PERM mask=MAY_READ
+			measure subj_user=system_u func=FILE_CHECK mask=MAY_READ
+			measure subj_role=system_r func=FILE_CHECK mask=MAY_READ
 
 		Smack:
-			measure subj_user=_ func=INODE_PERM mask=MAY_READ
+			measure subj_user=_ func=FILE_CHECK mask=MAY_READ
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index c41afe6..4136bd8 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -131,7 +131,7 @@ void iint_free(struct kref *kref);
 void iint_rcu_free(struct rcu_head *rcu);
 
 /* IMA policy related functions */
-enum ima_hooks { PATH_CHECK = 1, FILE_MMAP, BPRM_CHECK };
+enum ima_hooks { FILE_CHECK = 1, FILE_MMAP, BPRM_CHECK };
 
 int ima_match_policy(struct inode *inode, enum ima_hooks func, int mask);
 void ima_init_policy(void);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 3cd58b6..2a5e0bc 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -95,12 +95,12 @@ err_out:
  * ima_must_measure - measure decision based on policy.
  * @inode: pointer to inode to measure
  * @mask: contains the permission mask (MAY_READ, MAY_WRITE, MAY_EXECUTE)
- * @function: calling function (PATH_CHECK, BPRM_CHECK, FILE_MMAP)
+ * @function: calling function (FILE_CHECK, BPRM_CHECK, FILE_MMAP)
  *
  * The policy is defined in terms of keypairs:
  * 		subj=, obj=, type=, func=, mask=, fsmagic=
  *	subj,obj, and type: are LSM specific.
- * 	func: PATH_CHECK | BPRM_CHECK | FILE_MMAP
+ * 	func: FILE_CHECK | BPRM_CHECK | FILE_MMAP
  * 	mask: contains the permission mask
  *	fsmagic: hex value
  *
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index bab392e..4fe6192 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -153,7 +153,7 @@ void ima_counts_get(struct file *file)
 	if (!iint)
 		return;
 	mutex_lock(&iint->mutex);
-	rc = ima_must_measure(iint, inode, MAY_READ, PATH_CHECK);
+	rc = ima_must_measure(iint, inode, MAY_READ, FILE_CHECK);
 	if (rc < 0)
 		goto out;
 
@@ -312,7 +312,7 @@ int ima_file_check(struct file *file, int mask)
 
 	rc = process_measurement(file, file->f_dentry->d_name.name,
 				 mask & (MAY_READ | MAY_WRITE | MAY_EXEC),
-				 PATH_CHECK);
+				 FILE_CHECK);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index e127839..4759d0f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -67,7 +67,7 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
-	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
+	{.action = MEASURE,.func = FILE_CHECK,.mask = MAY_READ,.uid = 0,
 	 .flags = IMA_FUNC | IMA_MASK | IMA_UID},
 };
 
@@ -282,8 +282,11 @@ static int ima_parse_rule(char *rule, struct ima_measure_rule_entry *entry)
 			break;
 		case Opt_func:
 			audit_log_format(ab, "func=%s ", args[0].from);
-			if (strcmp(args[0].from, "PATH_CHECK") == 0)
-				entry->func = PATH_CHECK;
+			if (strcmp(args[0].from, "FILE_CHECK") == 0)
+				entry->func = FILE_CHECK;
+			/* PATH_CHECK is for backwards compat */
+			else if (strcmp(args[0].from, "PATH_CHECK") == 0)
+				entry->func = FILE_CHECK;
 			else if (strcmp(args[0].from, "FILE_MMAP") == 0)
 				entry->func = FILE_MMAP;
 			else if (strcmp(args[0].from, "BPRM_CHECK") == 0)
-- 
1.6.0.6

