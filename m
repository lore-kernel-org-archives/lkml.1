Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXJUByA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXJUByA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXJUBwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:52:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56845 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXJUBw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:52:27 -0400
Date: Sun, 21 Oct 2007 01:52:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] MultiAdmin 1.0.7
In-Reply-To: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710210152420.1997@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710210149270.1997@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH 3/4] task_post_setgid()

    -   Implement the task_post_setgid() LSM hook which is required by
        MultiAdmin to switch between classes.
        (task_post_setuid also switches between classes -- and already exists)


Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, May 01 2006
Modified July 11 2006

---
 include/linux/security.h |   13 +++++++++++++
 kernel/sys.c             |   15 ++++++++++++---
 security/dummy.c         |    7 +++++++
 3 files changed, 32 insertions(+), 3 deletions(-)

Index: linux-2.6.23.1/include/linux/security.h
===================================================================
--- linux-2.6.23.1.orig/include/linux/security.h
+++ linux-2.6.23.1/include/linux/security.h
@@ -1400,6 +1400,7 @@ struct security_operations {
 #endif	/* CONFIG_KEYS */
 
 	int (*cap_extra)(struct task_struct *, unsigned int);
+	int (*task_post_setgid)(gid_t, gid_t, gid_t, unsigned int);
 };
 
 /* global variables */
@@ -2139,6 +2140,12 @@ static inline int security_cap_extra(str
 	return security_ops->cap_extra(task, cap);
 }
 
+static inline int security_task_post_setgid(gid_t real, gid_t effective,
+    gid_t saved, unsigned int type)
+{
+	return security_ops->task_post_setgid(real, effective, saved, type);
+}
+
 /* prototypes */
 extern int security_init	(void);
 extern int register_security	(struct security_operations *ops);
@@ -2799,6 +2806,12 @@ static inline int security_cap_extra(str
 	return 0;
 }
 
+static inline int security_task_post_setgid(gid_t real, gid_t effective,
+    gid_t saved, unsigned int type)
+{
+	return 0;
+}
+
 static inline struct dentry *securityfs_create_dir(const char *name,
 					struct dentry *parent)
 {
Index: linux-2.6.23.1/kernel/sys.c
===================================================================
--- linux-2.6.23.1.orig/kernel/sys.c
+++ linux-2.6.23.1/kernel/sys.c
@@ -1052,7 +1052,8 @@ asmlinkage long sys_setregid(gid_t rgid,
 	current->gid = new_rgid;
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
-	return 0;
+	return security_task_post_setgid(old_rgid, old_egid,
+	       (gid_t)-1, LSM_SETID_RE);
 }
 
 /*
@@ -1062,6 +1063,7 @@ asmlinkage long sys_setregid(gid_t rgid,
  */
 asmlinkage long sys_setgid(gid_t gid)
 {
+	gid_t old_rgid = current->gid;
 	int old_egid = current->egid;
 	int retval;
 
@@ -1087,7 +1089,8 @@ asmlinkage long sys_setgid(gid_t gid)
 
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
-	return 0;
+	return security_task_post_setgid(old_rgid, (gid_t)-1,
+	       (gid_t)-1, LSM_SETID_ID);
 }
   
 static int set_user(uid_t new_ruid, int dumpclear)
@@ -1290,6 +1293,9 @@ asmlinkage long sys_getresuid(uid_t __us
  */
 asmlinkage long sys_setresgid(gid_t rgid, gid_t egid, gid_t sgid)
 {
+	gid_t old_rgid = current->gid;
+	gid_t old_egid = current->egid;
+	gid_t old_sgid = current->sgid;
 	int retval;
 
 	retval = security_task_setgid(rgid, egid, sgid, LSM_SETID_RES);
@@ -1322,7 +1328,8 @@ asmlinkage long sys_setresgid(gid_t rgid
 
 	key_fsgid_changed(current);
 	proc_id_connector(current, PROC_EVENT_GID);
-	return 0;
+	return security_task_post_setgid(old_rgid, old_egid,
+	       old_sgid, LSM_SETID_RES);
 }
 
 asmlinkage long sys_getresgid(gid_t __user *rgid, gid_t __user *egid, gid_t __user *sgid)
@@ -1391,6 +1398,8 @@ asmlinkage long sys_setfsgid(gid_t gid)
 		key_fsgid_changed(current);
 		proc_id_connector(current, PROC_EVENT_GID);
 	}
+	security_task_post_setgid(old_fsgid, (gid_t)-1,
+	                          (gid_t)-1, LSM_SETID_FS);
 	return old_fsgid;
 }
 
Index: linux-2.6.23.1/security/dummy.c
===================================================================
--- linux-2.6.23.1.orig/security/dummy.c
+++ linux-2.6.23.1/security/dummy.c
@@ -698,6 +698,12 @@ static int dummy_cap_extra(struct task_s
 	return 0;
 }
 
+static int dummy_task_post_setgid(gid_t real, gid_t effective,
+    gid_t saved, unsigned int type)
+{
+	return 0;
+}
+
 #ifdef CONFIG_SECURITY_NETWORK
 static int dummy_unix_stream_connect (struct socket *sock,
 				      struct socket *other,
@@ -1138,5 +1144,6 @@ void security_fixup_ops (struct security
 #endif	/* CONFIG_KEYS */
 
 	set_to_dummy_if_null(ops, cap_extra);
+	set_to_dummy_if_null(ops, task_post_setgid);
 }
 
