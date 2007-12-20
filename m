Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbXLTNNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbXLTNNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbXLTNN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:13:26 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43897
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759876AbXLTNNZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:13:25 -0500
Message-Id: <476A7892.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 20 Dec 2007 13:13:38 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] add task handling notifier: security keys
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mips/kernel/kspd.c      |    7 +++--
 include/linux/key.h          |    4 ---
 kernel/sys.c                 |    8 ------
 security/keys/process_keys.c |   55 ++++++++++++++++++++++++++-----------------
 4 files changed, 39 insertions(+), 35 deletions(-)

--- 2.6.24-rc5-notify-task.orig/arch/mips/kernel/kspd.c
+++ 2.6.24-rc5-notify-task/arch/mips/kernel/kspd.c
@@ -25,6 +25,7 @@
 #include <linux/workqueue.h>
 #include <linux/errno.h>
 #include <linux/list.h>
+#include <linux/notifier.h>
 
 #include <asm/vpe.h>
 #include <asm/rtlx.h>
@@ -177,8 +178,10 @@ static void sp_setfsuidgid( uid_t uid, g
 	current->fsuid = uid;
 	current->fsgid = gid;
 
-	key_fsuid_changed(current);
-	key_fsgid_changed(current);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_UID_CHANGE, current);
+	blocking_notifier_call_chain(&task_notifier_list,
+				     TASK_GID_CHANGE, current);
 }
 
 /*
--- 2.6.24-rc5-notify-task.orig/include/linux/key.h
+++ 2.6.24-rc5-notify-task/include/linux/key.h
@@ -272,8 +272,6 @@ extern void exit_keys(struct task_struct
 extern void exit_thread_group_keys(struct signal_struct *tg);
 extern int suid_keys(struct task_struct *tsk);
 extern int exec_keys(struct task_struct *tsk);
-extern void key_fsuid_changed(struct task_struct *tsk);
-extern void key_fsgid_changed(struct task_struct *tsk);
 extern void key_init(void);
 
 #define __install_session_keyring(tsk, keyring)			\
@@ -302,8 +300,6 @@ extern void key_init(void);
 #define exit_thread_group_keys(tg)	do { } while(0)
 #define suid_keys(t)			do { } while(0)
 #define exec_keys(t)			do { } while(0)
-#define key_fsuid_changed(t)		do { } while(0)
-#define key_fsgid_changed(t)		do { } while(0)
 #define key_init()			do { } while(0)
 
 /* Initial keyrings */
--- 2.6.24-rc5-notify-task.orig/kernel/sys.c
+++ 2.6.24-rc5-notify-task/kernel/sys.c
@@ -517,7 +517,6 @@ asmlinkage long sys_setregid(gid_t rgid,
 	current->fsgid = new_egid;
 	current->egid = new_egid;
 	current->gid = new_rgid;
-	key_fsgid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_GID_CHANGE, current);
 
@@ -554,7 +553,6 @@ asmlinkage long sys_setgid(gid_t gid)
 	else
 		return -EPERM;
 
-	key_fsgid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_GID_CHANGE, current);
 
@@ -644,7 +642,6 @@ asmlinkage long sys_setreuid(uid_t ruid,
 		current->suid = current->euid;
 	current->fsuid = current->euid;
 
-	key_fsuid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_UID_CHANGE, current);
 
@@ -692,7 +689,6 @@ asmlinkage long sys_setuid(uid_t uid)
 	current->fsuid = current->euid = uid;
 	current->suid = new_suid;
 
-	key_fsuid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_UID_CHANGE, current);
 
@@ -741,7 +737,6 @@ asmlinkage long sys_setresuid(uid_t ruid
 	if (suid != (uid_t) -1)
 		current->suid = suid;
 
-	key_fsuid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_UID_CHANGE, current);
 
@@ -794,7 +789,6 @@ asmlinkage long sys_setresgid(gid_t rgid
 	if (sgid != (gid_t) -1)
 		current->sgid = sgid;
 
-	key_fsgid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_GID_CHANGE, current);
 	return 0;
@@ -836,7 +830,6 @@ asmlinkage long sys_setfsuid(uid_t uid)
 		current->fsuid = uid;
 	}
 
-	key_fsuid_changed(current);
 	blocking_notifier_call_chain(&task_notifier_list,
 				     TASK_UID_CHANGE, current);
 
@@ -864,7 +857,6 @@ asmlinkage long sys_setfsgid(gid_t gid)
 			smp_wmb();
 		}
 		current->fsgid = gid;
-		key_fsgid_changed(current);
 		blocking_notifier_call_chain(&task_notifier_list,
 					     TASK_GID_CHANGE, current);
 	}
--- 2.6.24-rc5-notify-task.orig/security/keys/process_keys.c
+++ 2.6.24-rc5-notify-task/security/keys/process_keys.c
@@ -16,6 +16,7 @@
 #include <linux/keyctl.h>
 #include <linux/fs.h>
 #include <linux/err.h>
+#include <linux/notifier.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include "internal.h"
@@ -354,35 +355,47 @@ int suid_keys(struct task_struct *tsk)
 
 } /* end suid_keys() */
 
-/*****************************************************************************/
-/*
- * the filesystem user ID changed
- */
-void key_fsuid_changed(struct task_struct *tsk)
-{
-	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
+static int key_task_notifier(struct notifier_block *nb,
+			     unsigned long action,
+			     void *task)
+{
+	struct task_struct *tsk = task;
+
+	if (!tsk->thread_keyring)
+		return NOTIFY_DONE;
+
+	switch (action) {
+	case TASK_UID_CHANGE:
+		/* update the ownership of the thread keyring */
 		down_write(&tsk->thread_keyring->sem);
 		tsk->thread_keyring->uid = tsk->fsuid;
 		up_write(&tsk->thread_keyring->sem);
-	}
-
-} /* end key_fsuid_changed() */
-
-/*****************************************************************************/
-/*
- * the filesystem group ID changed
- */
-void key_fsgid_changed(struct task_struct *tsk)
-{
-	/* update the ownership of the thread keyring */
-	if (tsk->thread_keyring) {
+		break;
+	case TASK_GID_CHANGE:
+		/* update the ownership of the thread keyring */
 		down_write(&tsk->thread_keyring->sem);
 		tsk->thread_keyring->gid = tsk->fsgid;
 		up_write(&tsk->thread_keyring->sem);
+		break;
 	}
 
-} /* end key_fsgid_changed() */
+	return NOTIFY_DONE;
+
+} /* end key_task_notifier() */
+
+static struct notifier_block key_task_notifier_block = {
+	.notifier_call = key_task_notifier
+};
+
+static int __init key_notifier_init(void)
+{
+	blocking_notifier_chain_register(&task_notifier_list,
+					 &key_task_notifier_block);
+	return 0;
+
+} /* end key_notifier_init() */
+
+__initcall(key_notifier_init);
 
 /*****************************************************************************/
 /*


