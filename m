Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564Ab0AECQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0AECQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453Ab0AECPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:15:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43074 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab0AECPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:32 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
In-Reply-To: <20100105315.789846878@firstfloor.org>
To: ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/9] SYSCTL: Convert modprobe_path to proc_rcu_string()
Message-Id: <20100105021531.3919FB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 03:15:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoids races with lockless sysctl

Also saves ~220 bytes in the data segment for default kernels.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/kmod.c   |   36 ++++++++++++++++++++++++++++--------
 kernel/sysctl.c |    4 ++--
 2 files changed, 30 insertions(+), 10 deletions(-)

Index: linux-2.6.33-rc2-ak/kernel/kmod.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/kmod.c
+++ linux-2.6.33-rc2-ak/kernel/kmod.c
@@ -35,6 +35,7 @@
 #include <linux/resource.h>
 #include <linux/notifier.h>
 #include <linux/suspend.h>
+#include <linux/rcustring.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -48,7 +49,12 @@ static struct workqueue_struct *khelper_
 /*
 	modprobe_path is set via /proc/sys.
 */
-char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
+char *modprobe_path = "/sbin/modprobe";
+
+static void free_arg(char **argv, char **env)
+{
+	kfree(argv[0]);
+}
 
 /**
  * __request_module - try to load a kernel module
@@ -71,7 +77,8 @@ int __request_module(bool wait, const ch
 	char module_name[MODULE_NAME_LEN];
 	unsigned int max_modprobes;
 	int ret;
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+	char *mp_copy;
+	char *argv[] = { NULL, "-q", "--", module_name, NULL };
 	static char *envp[] = { "HOME=/",
 				"TERM=linux",
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
@@ -80,15 +87,24 @@ int __request_module(bool wait, const ch
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
 
+	/* Get a stable-over-sleeps private copy of modprobe_path */
+	mp_copy = access_rcu_string(&modprobe_path, KMOD_PATH_LEN,
+					wait ? GFP_KERNEL : GFP_ATOMIC);
+	if (!mp_copy)
+		return -ENOMEM;
+	argv[0] = mp_copy;
+
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
-	if (ret >= MODULE_NAME_LEN)
-		return -ENAMETOOLONG;
+	if (ret >= MODULE_NAME_LEN) {
+		ret = -ENAMETOOLONG;
+		goto error;
+	}
 
 	ret = security_kernel_module_request(module_name);
 	if (ret)
-		return ret;
+		goto error;
 
 	/* If modprobe needs a service that is in a module, we get a recursive
 	 * loop.  Limit the number of running kmod threads to max_threads/2 or
@@ -111,14 +127,18 @@ int __request_module(bool wait, const ch
 			       "request_module: runaway loop modprobe %s\n",
 			       module_name);
 		atomic_dec(&kmod_concurrent);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto error;
 	}
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+	ret = call_usermodehelper_cleanup(mp_copy, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC, free_arg);
+	mp_copy = NULL; /* free_arg frees */
 	atomic_dec(&kmod_concurrent);
+error:
+	kfree(mp_copy);
 	return ret;
 }
 EXPORT_SYMBOL(__request_module);
Index: linux-2.6.33-rc2-ak/kernel/sysctl.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/sysctl.c
+++ linux-2.6.33-rc2-ak/kernel/sysctl.c
@@ -121,7 +121,7 @@ static int min_percpu_pagelist_fract = 8
 static int ngroups_max = NGROUPS_MAX;
 
 #ifdef CONFIG_MODULES
-extern char modprobe_path[];
+extern char *modprobe_path;
 extern int modules_disabled;
 #endif
 #ifdef CONFIG_CHR_DEV_SG
@@ -532,7 +532,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &modprobe_path,
 		.maxlen		= KMOD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 	{
 		.procname	= "modules_disabled",
