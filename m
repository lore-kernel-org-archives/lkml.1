Return-Path: <linux-kernel-owner+w=401wt.eu-S1763785AbYBTDJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763785AbYBTDJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYBTDJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:09:43 -0500
Received: from n12.bullet.mail.mud.yahoo.com ([209.191.125.209]:39293 "HELO
	n12.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750773AbYBTDJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:09:42 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 22:09:42 EST
X-Yahoo-Newman-Id: 912088.21310.bm@omp417.mail.mud.yahoo.com
X-YMail-OSG: Ub5pKJEVM1kHFElg_loIUgdvKluZrR2kVJbTHAJIJhFsvXqnoH0m3eh8LZI5rVpQHcOPA2ow6pyrXdcXmi62_tEaJgOi6AKcAZTMnUBguP0qLDHOjQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <47BB4437.8020600@schaufler-ca.com>
Date: Tue, 19 Feb 2008 13:03:51 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       casey@schaufler-ca.com
Subject: [PATCH] (linus git 02/19/08) Smack update for file capabilities
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Update the Smack LSM to allow the registration of the capability
"module" as a secondary LSM. Integrate the new hooks required for
file based capabilities.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack_lsm.c |   87 +++++++++++++++++++++++++++++------
 1 file changed, 74 insertions(+), 13 deletions(-)

diff -uprN -X linux-2.6.25-g0219-precap/Documentation/dontdiff linux-2.6.25-g0219-precap/security/smack/smack_lsm.c linux-2.6.25-g0219/security/smack/smack_lsm.c
--- linux-2.6.25-g0219-precap/security/smack/smack_lsm.c	2008-02-19 10:15:30.000000000 -0800
+++ linux-2.6.25-g0219/security/smack/smack_lsm.c	2008-02-19 09:24:19.000000000 -0800
@@ -584,14 +584,20 @@ static int smack_inode_getattr(struct vf
 static int smack_inode_setxattr(struct dentry *dentry, char *name,
 				void *value, size_t size, int flags)
 {
-	if (!capable(CAP_MAC_ADMIN)) {
-		if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
-		    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
-		    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0)
-			return -EPERM;
-	}
+	int rc = 0;
+
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
+		if (!capable(CAP_MAC_ADMIN))
+			rc = -EPERM;
+	} else
+		rc = cap_inode_setxattr(dentry, name, value, size, flags);
+
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
 
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -658,10 +664,20 @@ static int smack_inode_getxattr(struct d
  */
 static int smack_inode_removexattr(struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SMACK) == 0 && !capable(CAP_MAC_ADMIN))
-		return -EPERM;
+	int rc = 0;
 
-	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+	if (strcmp(name, XATTR_NAME_SMACK) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPIN) == 0 ||
+	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
+		if (!capable(CAP_MAC_ADMIN))
+			rc = -EPERM;
+	} else
+		rc = cap_inode_removexattr(dentry, name);
+
+	if (rc == 0)
+		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
+
+	return rc;
 }
 
 /**
@@ -1016,7 +1032,12 @@ static void smack_task_getsecid(struct t
  */
 static int smack_task_setnice(struct task_struct *p, int nice)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	int rc;
+
+	rc = cap_task_setnice(p, nice);
+	if (rc == 0)
+		rc = smk_curacc(p->security, MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -1028,7 +1049,12 @@ static int smack_task_setnice(struct tas
  */
 static int smack_task_setioprio(struct task_struct *p, int ioprio)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	int rc;
+
+	rc = cap_task_setioprio(p, ioprio);
+	if (rc == 0)
+		rc = smk_curacc(p->security, MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -1053,7 +1079,12 @@ static int smack_task_getioprio(struct t
 static int smack_task_setscheduler(struct task_struct *p, int policy,
 				   struct sched_param *lp)
 {
-	return smk_curacc(p->security, MAY_WRITE);
+	int rc;
+
+	rc = cap_task_setscheduler(p, policy, lp);
+	if (rc == 0)
+		rc = smk_curacc(p->security, MAY_WRITE);
+	return rc;
 }
 
 /**
@@ -1093,6 +1124,11 @@ static int smack_task_movememory(struct 
 static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 			   int sig, u32 secid)
 {
+	int rc;
+
+	rc = cap_task_kill(p, info, sig, secid);
+	if (rc != 0)
+		return rc;
 	/*
 	 * Special cases where signals really ought to go through
 	 * in spite of policy. Stephen Smalley suggests it may
@@ -1778,6 +1814,27 @@ static int smack_ipc_permission(struct k
 	return smk_curacc(isp, may);
 }
 
+/* module stacking operations */
+
+/**
+ * smack_register_security - stack capability module
+ * @name: module name
+ * @ops: module operations - ignored
+ *
+ * Allow the capability module to register.
+ */
+static int smack_register_security(const char *name,
+				   struct security_operations *ops)
+{
+	if (strcmp(name, "capability") != 0)
+		return -EINVAL;
+
+	printk(KERN_INFO "%s:  Registering secondary module %s\n",
+	       __func__, name);
+
+	return 0;
+}
+
 /**
  * smack_d_instantiate - Make sure the blob is correct on an inode
  * @opt_dentry: unused
@@ -2412,6 +2469,8 @@ static struct security_operations smack_
 	.inode_post_setxattr = 		smack_inode_post_setxattr,
 	.inode_getxattr = 		smack_inode_getxattr,
 	.inode_removexattr = 		smack_inode_removexattr,
+	.inode_need_killpriv =		cap_inode_need_killpriv,
+	.inode_killpriv =		cap_inode_killpriv,
 	.inode_getsecurity = 		smack_inode_getsecurity,
 	.inode_setsecurity = 		smack_inode_setsecurity,
 	.inode_listsecurity = 		smack_inode_listsecurity,
@@ -2471,6 +2530,8 @@ static struct security_operations smack_
 	.netlink_send =			cap_netlink_send,
 	.netlink_recv = 		cap_netlink_recv,
 
+	.register_security = 		smack_register_security,
+
 	.d_instantiate = 		smack_d_instantiate,
 
 	.getprocattr = 			smack_getprocattr,


