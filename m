Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZLUBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZLUBVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbZLUBUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:20:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZLUBUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: greg@kroah.com, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com
Subject: [PATCH] [8/11] SYSCTL: Convert hotplug helper string to proc_rcu_string()
Message-Id: <20091221012029.AEE3CB158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This avoids races with lockless sysctl.

I also moved the code into a separate function because the original
was very long.

Cc: greg@kroah.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kobject.h |    2 -
 kernel/sysctl.c         |    2 -
 lib/kobject_uevent.c    |   50 ++++++++++++++++++++++++++++++------------------
 3 files changed, 34 insertions(+), 20 deletions(-)

Index: linux-2.6.33-rc1-ak/include/linux/kobject.h
===================================================================
--- linux-2.6.33-rc1-ak.orig/include/linux/kobject.h
+++ linux-2.6.33-rc1-ak/include/linux/kobject.h
@@ -31,7 +31,7 @@
 #define UEVENT_BUFFER_SIZE		2048	/* buffer for the variables */
 
 /* path to the userspace helper executed on an event */
-extern char uevent_helper[];
+extern char *uevent_helper;
 
 /* counter to tag the uevent, read only except for the kobject core */
 extern u64 uevent_seqnum;
Index: linux-2.6.33-rc1-ak/kernel/sysctl.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sysctl.c
+++ linux-2.6.33-rc1-ak/kernel/sysctl.c
@@ -551,7 +551,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &uevent_helper,
 		.maxlen		= UEVENT_HELPER_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 #endif
 #ifdef CONFIG_CHR_DEV_SG
Index: linux-2.6.33-rc1-ak/lib/kobject_uevent.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/lib/kobject_uevent.c
+++ linux-2.6.33-rc1-ak/lib/kobject_uevent.c
@@ -22,11 +22,12 @@
 #include <linux/socket.h>
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
+#include <linux/rcustring.h>
 #include <net/sock.h>
 
 
 u64 uevent_seqnum;
-char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
+char *uevent_helper = CONFIG_UEVENT_HELPER_PATH;
 static DEFINE_SPINLOCK(sequence_lock);
 #if defined(CONFIG_NET)
 static struct sock *uevent_sock;
@@ -76,6 +77,34 @@ out:
 	return ret;
 }
 
+/* Call an external helper executable. */
+static int uevent_call_helper(const char *subsystem, struct kobj_uevent_env *env)
+{
+	char *argv[3];
+	char *helper;
+	int retval;
+
+	helper = access_rcu_string(uevent_helper, UEVENT_HELPER_PATH_LEN, GFP_KERNEL);
+	if (!helper)
+		return -ENOMEM;
+
+	retval = -E2BIG;
+	argv[0] = helper;
+	argv[1] = (char *)subsystem;
+	argv[2] = NULL;
+	retval = add_uevent_var(env, "HOME=/");
+	if (retval)
+		goto error;
+	retval = add_uevent_var(env, "PATH=/sbin:/bin:/usr/sbin:/usr/bin");
+	if (retval)
+		goto error;
+
+	retval = call_usermodehelper(argv[0], argv, env->envp, UMH_WAIT_EXEC);
+error:
+	kfree(helper);
+	return retval;
+}
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
@@ -243,23 +272,8 @@ int kobject_uevent_env(struct kobject *k
 #endif
 
 	/* call uevent_helper, usually only enabled during early boot */
-	if (uevent_helper[0]) {
-		char *argv [3];
-
-		argv [0] = uevent_helper;
-		argv [1] = (char *)subsystem;
-		argv [2] = NULL;
-		retval = add_uevent_var(env, "HOME=/");
-		if (retval)
-			goto exit;
-		retval = add_uevent_var(env,
-					"PATH=/sbin:/bin:/usr/sbin:/usr/bin");
-		if (retval)
-			goto exit;
-
-		retval = call_usermodehelper(argv[0], argv,
-					     env->envp, UMH_WAIT_EXEC);
-	}
+	if (uevent_helper[0])
+		retval = uevent_call_helper(subsystem, env);
 
 exit:
 	kfree(devpath);
