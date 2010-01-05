Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512Ab0AECPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0AECPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411Ab0AECPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:15:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43073 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab0AECPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:33 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
In-Reply-To: <20100105315.789846878@firstfloor.org>
To: ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/9] SYSCTL: Convert poweroff_command to proc_rcu_string
Message-Id: <20100105021532.3BE00B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 03:15:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoids races with lockless sysctl.

Also saves ~220 bytes in the data segment for default kernels.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/reboot.h |    2 +-
 kernel/sys.c           |    8 ++++++--
 kernel/sysctl.c        |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc2-ak/kernel/sys.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/sys.c
+++ linux-2.6.33-rc2-ak/kernel/sys.c
@@ -1597,7 +1597,7 @@ SYSCALL_DEFINE3(getcpu, unsigned __user
 	return err ? -EFAULT : 0;
 }
 
-char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+char *poweroff_cmd = "/sbin/poweroff";
 
 static void argv_cleanup(char **argv, char **envp)
 {
@@ -1614,7 +1614,7 @@ static void argv_cleanup(char **argv, ch
 int orderly_poweroff(bool force)
 {
 	int argc;
-	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	char **argv;
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
@@ -1623,6 +1623,10 @@ int orderly_poweroff(bool force)
 	int ret = -ENOMEM;
 	struct subprocess_info *info;
 
+	/* RCU protection for poweroff_cmd */
+	rcu_read_lock();
+	argv = argv_split(GFP_ATOMIC, rcu_dereference(poweroff_cmd), &argc);
+	rcu_read_unlock();
 	if (argv == NULL) {
 		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
 		       __func__, poweroff_cmd);
Index: linux-2.6.33-rc2-ak/include/linux/reboot.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/reboot.h
+++ linux-2.6.33-rc2-ak/include/linux/reboot.h
@@ -67,7 +67,7 @@ extern void kernel_power_off(void);
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
-extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
+extern char *poweroff_cmd;
 
 extern int orderly_poweroff(bool force);
 
Index: linux-2.6.33-rc2-ak/kernel/sysctl.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/sysctl.c
+++ linux-2.6.33-rc2-ak/kernel/sysctl.c
@@ -871,7 +871,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &poweroff_cmd,
 		.maxlen		= POWEROFF_CMD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 #ifdef CONFIG_KEYS
 	{
