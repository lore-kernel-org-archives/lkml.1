Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbXLCSjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbXLCSjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbXLCSjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:39:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:15574 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbXLCSjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:39:22 -0500
Message-ID: <47544D58.5090306@schaufler-ca.com>
Date: Mon, 03 Dec 2007 10:39:20 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] (2.6.24-rc3-mm2) -mm Smack mutex cleanup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Clean out unnecessary mutex initializations for Smack list locks.
Once this is done, there is no need for them to be shared among
multiple files, so pull them out of the header file and put them
in the files where they belong.

Pull unnecessary locking from smack_inode_setsecurity, it used
to be required when the assignment was not guaranteed to be a
scalar value but isn't now.

Change uses of __capable(current,...) to capable(...).
Take out an inappropriate cast. Use container_of() instead
of doing the same calculation by hand.
Fix comment spelling errors.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

Tested with stamp-2007-11-30-16-39

 security/smack/smack.h        |    3 --
 security/smack/smack_access.c |    3 ++
 security/smack/smack_lsm.c    |   34 +++++++++-----------------------
 security/smack/smackfs.c      |    6 +++++
 4 files changed, 19 insertions(+), 27 deletions(-)

diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/security/smack/smack_access.c linux-2.6.24-rc3-mm2-smack/security/smack/smack_access.c
--- linux-2.6.24-rc3-mm2-base/security/smack/smack_access.c	2007-11-27 16:47:05.000000000 -0800
+++ linux-2.6.24-rc3-mm2-smack/security/smack/smack_access.c	2007-11-28 11:46:01.000000000 -0800
@@ -58,6 +58,7 @@ struct smack_known smack_known_invalid =
 };
 
 struct smack_known *smack_known = &smack_known_invalid;
+
 /*
  * The initial value needs to be bigger than any of the
  * known values above.
@@ -173,6 +174,8 @@ int smk_curacc(char *obj_label, u32 mode
 	return rc;
 }
 
+DEFINE_MUTEX(smack_known_lock);
+
 /**
  * smk_import_entry - import a label, return the list entry
  * @string: a text string that might be a Smack label
diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/security/smack/smackfs.c linux-2.6.24-rc3-mm2-smack/security/smack/smackfs.c
--- linux-2.6.24-rc3-mm2-base/security/smack/smackfs.c	2007-11-27 16:47:05.000000000 -0800
+++ linux-2.6.24-rc3-mm2-smack/security/smack/smackfs.c	2007-11-28 11:44:34.000000000 -0800
@@ -41,6 +41,12 @@ enum smk_inos {
 };
 
 /*
+ * List locks
+ */
+DEFINE_MUTEX(smack_list_lock);
+DEFINE_MUTEX(smack_cipso_lock);
+
+/*
  * This is the "ambient" label for network traffic.
  * If it isn't somehow marked, use this.
  * It can be reset via smackfs/ambient
diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/security/smack/smack.h linux-2.6.24-rc3-mm2-smack/security/smack/smack.h
--- linux-2.6.24-rc3-mm2-base/security/smack/smack.h	2007-11-27 16:47:05.000000000 -0800
+++ linux-2.6.24-rc3-mm2-smack/security/smack/smack.h	2007-11-28 11:47:07.000000000 -0800
@@ -186,7 +186,6 @@ extern int smack_net_nltype;
 extern char *smack_net_ambient;
 
 extern struct smack_known *smack_known;
-extern struct mutex smack_known_lock;
 extern struct smack_known smack_known_floor;
 extern struct smack_known smack_known_hat;
 extern struct smack_known smack_known_huh;
@@ -195,8 +194,6 @@ extern struct smack_known smack_known_st
 extern struct smack_known smack_known_unset;
 
 extern struct smk_list_entry *smack_list;
-extern struct mutex smack_list_lock;
-extern struct mutex smack_cipso_lock;
 
 /*
  * Stricly for CIPSO level manipulation.
diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/security/smack/smack_lsm.c linux-2.6.24-rc3-mm2-smack/security/smack/smack_lsm.c
--- linux-2.6.24-rc3-mm2-base/security/smack/smack_lsm.c	2007-11-27 16:47:05.000000000 -0800
+++ linux-2.6.24-rc3-mm2-smack/security/smack/smack_lsm.c	2007-11-28 11:46:13.000000000 -0800
@@ -126,7 +126,7 @@ static int smack_syslog(int type)
 	if (rc != 0)
 		return rc;
 
-	if (__capable(current, CAP_MAC_OVERRIDE))
+	if (capable(CAP_MAC_OVERRIDE))
 		return 0;
 
 	 if (sp != smack_known_floor.smk_known)
@@ -584,8 +584,7 @@ static int smack_inode_getattr(struct vf
 static int smack_inode_setxattr(struct dentry *dentry, char *name,
 				void *value, size_t size, int flags)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
-		!__capable(current, CAP_MAC_ADMIN))
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
@@ -655,8 +654,7 @@ static int smack_inode_getxattr(struct d
  */
 static int smack_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 &&
-		!__capable(current, CAP_MAC_ADMIN))
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
 	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
@@ -736,7 +734,7 @@ static int smack_inode_setsecurity(struc
 				   const void *value, size_t size, int flags)
 {
 	char *sp;
-	struct inode_smack *nsp = (struct inode_smack *)inode->i_security;
+	struct inode_smack *nsp = inode->i_security;
 	struct socket_smack *ssp;
 	struct socket *sock;
 
@@ -748,9 +746,7 @@ static int smack_inode_setsecurity(struc
 		return -EINVAL;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
-		mutex_lock(&nsp->smk_lock);
 		nsp->smk_inode = sp;
-		mutex_unlock(&nsp->smk_lock);
 		return 0;
 	}
 	/*
@@ -950,7 +946,7 @@ static int smack_file_send_sigiotask(str
 	/*
 	 * struct fown_struct is never outside the context of a struct file
 	 */
-	file = (struct file *)((long)fown - offsetof(struct file, f_owner));
+	file = container_of(fown, struct file, f_owner);
 	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
 	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
 		return 0;
@@ -987,7 +983,7 @@ static int smack_file_receive(struct fil
  * @tsk: the task in need of a blob
  *
  * Smack isn't using copies of blobs. Everyone
- * points to an immutible list. No alloc required.
+ * points to an immutable list. No alloc required.
  * No data copy required.
  *
  * Always returns 0
@@ -1004,7 +1000,7 @@ static int smack_task_alloc_security(str
  * @task: the task with the blob
  *
  * Smack isn't using copies of blobs. Everyone
- * points to an immutible list. The blobs never go away.
+ * points to an immutable list. The blobs never go away.
  * There is no leak here.
  */
 static void smack_task_free_security(struct task_struct *task)
@@ -1192,8 +1188,7 @@ static int smack_task_wait(struct task_s
 	 * state into account in the decision as well as
 	 * the smack value.
 	 */
-	if (__capable(current, CAP_MAC_OVERRIDE) ||
-		__capable(p, CAP_MAC_OVERRIDE))
+	if (capable(CAP_MAC_OVERRIDE) || __capable(p, CAP_MAC_OVERRIDE))
 		return 0;
 
 	return rc;
@@ -1226,12 +1221,12 @@ static void smack_task_to_inode(struct t
  *
  * Returns 0 on success, -ENOMEM is there's no memory
  */
-static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
+static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 {
 	char *csp = current->security;
 	struct socket_smack *ssp;
 
-	ssp = kzalloc(sizeof(struct socket_smack), priority);
+	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
 	if (ssp == NULL)
 		return -ENOMEM;
 
@@ -1252,7 +1247,6 @@ static int smack_sk_alloc_security(struc
 static void smack_sk_free_security(struct sock *sk)
 {
 	kfree(sk->sk_security);
-	sk->sk_security = NULL;
 }
 
 /**
@@ -2481,10 +2475,6 @@ static struct security_operations smack_
 	.release_secctx = 		smack_release_secctx,
 };
 
-DEFINE_MUTEX(smack_list_lock);
-DEFINE_MUTEX(smack_known_lock);
-DEFINE_MUTEX(smack_cipso_lock);
-
 /**
  * smack_init - initialize the smack system
  *
@@ -2509,10 +2499,6 @@ static __init int smack_init(void)
 	spin_lock_init(&smack_known_floor.smk_cipsolock);
 	spin_lock_init(&smack_known_invalid.smk_cipsolock);
 
-	mutex_init(&smack_known_lock);
-	mutex_init(&smack_list_lock);
-	mutex_init(&smack_cipso_lock);
-
 	/*
 	 * Register with LSM
 	 */

