Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbZLUBUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbZLUBUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZLUBUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37718 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbZLUBUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: [PATCH] [7/11] SYSCTL: Convert poweroff_command to proc_rcu_string
Message-Id: <20091221012028.AC0E9B158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoids races with lockless sysctl.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/reboot.h |    2 +-
 kernel/sys.c           |    8 ++++++--
 kernel/sysctl.c        |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc1-ak/kernel/sys.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sys.c
+++ linux-2.6.33-rc1-ak/kernel/sys.c
@@ -1595,7 +1595,7 @@ SYSCALL_DEFINE3(getcpu, unsigned __user
 	return err ? -EFAULT : 0;
 }
 
-char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+char *poweroff_cmd = "/sbin/poweroff";
 
 static void argv_cleanup(char **argv, char **envp)
 {
@@ -1612,7 +1612,7 @@ static void argv_cleanup(char **argv, ch
 int orderly_poweroff(bool force)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
@@ -1621,6 +1621,10 @@ int orderly_poweroff(bool force)
 	int ret = -ENOMEM;
 	struct subprocess_info *info;
 
+	/* RCU protection for poweroff_cmd */
+	rcu_read_lock();
+	argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	rcu_read_unlock();
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
 		       __func__, poweroff_cmd);
Index: linux-2.6.33-rc1-ak/include/linux/reboot.h
===================================================================
--- linux-2.6.33-rc1-ak.orig/include/linux/reboot.h
+++ linux-2.6.33-rc1-ak/include/linux/reboot.h
@@ -67,7 +67,7 @@ extern void kernel_power_off(void);
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
-extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
+extern char *poweroff_cmd;
 
 extern int orderly_poweroff(bool force);
 
Index: linux-2.6.33-rc1-ak/kernel/sysctl.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sysctl.c
+++ linux-2.6.33-rc1-ak/kernel/sysctl.c
@@ -871,7 +871,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &poweroff_cmd,
 		.maxlen		= POWEROFF_CMD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 #ifdef CONFIG_KEYS
 	{
