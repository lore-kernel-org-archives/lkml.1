Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZJDNBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZJDNBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 09:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbZJDNBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 09:01:47 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56604 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbZJDNBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 09:01:45 -0400
Message-Id: <20091004125333.994018883@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sun, 04 Oct 2009 21:50:06 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #16 20/25] TOMOYO: Add policy loader launcher.
Content-Disposition: inline; filename=tomoyo-add-load_policy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains code for policy loader.
By default, TOMOYO checks for /sbin/tomoyo-init and run it when /sbin/init (or
/sbin/tomoyo-start) is requested. But it is configurable via kernel commandline
parameter. /sbin/tomoyo-start is a dummy name for environments where /sbin/init
is missing (e.g. Android).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/load_policy.c |   97 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

--- /dev/null
+++ security-testing-2.6/security/tomoyo/load_policy.c
@@ -0,0 +1,97 @@
+/*
+ * security/tomoyo/load_policy.c
+ *
+ * Copyright (C) 2005-2009  NTT DATA CORPORATION
+ */
+#include "internal.h"
+#include <linux/module.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+
+/* Path to the policy loader. The default is /sbin/tomoyo-init. */
+static const char *tomoyo_loader;
+
+/**
+ * tomoyo_loader_setup - Specify the policy loader to use.
+ *
+ * @str: Path to the policy loader.
+ *
+ * Returns 0.
+ */
+static int __init tomoyo_loader_setup(char *str)
+{
+	tomoyo_loader = str;
+	return 0;
+}
+__setup("TOMOYO_loader=", tomoyo_loader_setup);
+
+/**
+ * tomoyo_policy_loader_exists - Check whether /sbin/tomoyo-init exists.
+ *
+ * Returns true if /sbin/tomoyo-init exists, false otherwise.
+ */
+static bool tomoyo_policy_loader_exists(void)
+{
+	/*
+	 * Don't activate MAC if the path given by 'TOMOYO_loader=' option
+	 * doesn't exist. If the initrd includes /sbin/init but real-root-dev
+	 * has not mounted on / yet, activating MAC will block the system since
+	 * policies are not loaded yet.
+	 * Thus, let do_execve() call this function everytime.
+	 */
+	struct path path;
+	if (!tomoyo_loader)
+		tomoyo_loader = "/sbin/tomoyo-init";
+	if (kern_path(tomoyo_loader, LOOKUP_FOLLOW, &path)) {
+		printk(KERN_INFO "Not activating Mandatory Access Control now "
+		       "since %s doesn't exist.\n", tomoyo_loader);
+		return false;
+	}
+	path_put(&path);
+	return true;
+}
+
+/**
+ * tomoyo_load_policy - Run external policy loader to load policy.
+ *
+ * @filename: The program about to start.
+ *
+ * This function checks whether @filename is /sbin/init , and if so
+ * invoke /sbin/tomoyo-init and wait for the termination of /sbin/tomoyo-init
+ * and then continues invocation of /sbin/init.
+ * /sbin/tomoyo-init reads policy files in /etc/tomoyo/ directory and
+ * writes to /sys/kernel/security/tomoyo/ interfaces.
+ *
+ * Returns nothing.
+ */
+void tomoyo_load_policy(const char *filename)
+{
+	if (tomoyo_policy_loaded)
+		return;
+	/*
+	 * Check filename is /sbin/init or /sbin/tomoyo-start.
+	 * /sbin/tomoyo-start is a dummy filename in case where /sbin/init
+	 * can't be passed. You can create /sbin/tomoyo-start by
+	 * "ln -s /bin/true /sbin/tomoyo-start".
+	 */
+	if (strcmp(filename, "/sbin/init") &&
+	    strcmp(filename, "/sbin/tomoyo-start"))
+		return;
+	if (!tomoyo_policy_loader_exists())
+		return;
+	{
+		char *argv[2];
+		char *envp[3];
+		printk(KERN_INFO "Calling %s to load policy. Please wait.\n",
+		       tomoyo_loader);
+		argv[0] = (char *) tomoyo_loader;
+		argv[1] = NULL;
+		envp[0] = "HOME=/";
+		envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
+		envp[2] = NULL;
+		call_usermodehelper(argv[0], argv, envp, 1);
+	}
+	printk(KERN_INFO "TOMOYO: 2.3.0-pre   2009/10/01\n");
+	printk(KERN_INFO "Mandatory Access Control activated.\n");
+	tomoyo_check_profile();
+}

-- 
