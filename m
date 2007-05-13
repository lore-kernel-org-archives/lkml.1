Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXEMNZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXEMNZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 09:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbXEMNZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 09:25:36 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:32505 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007AbXEMNZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 09:25:34 -0400
Date: Sun, 13 May 2007 16:25:17 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] allow kernel module exclusion on load
Message-ID: <20070513132517.GA14038@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel developers might find it useful for quickly getting out from some 
rough debugging scenarios.

Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/init/Kconfig b/init/Kconfig
index 4e009fd..796715e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -682,6 +682,17 @@ config KMOD
 	  runs modprobe with the appropriate arguments, thereby
 	  loading the module if it is available.  If unsure, say Y.
 
+config MODULE_EXCLUSION
+	bool "Refuse loading of modules with certain names"
+	depends on MODULES && DEBUG_KERNEL
+	help
+	  During kernel module development and debugging you might come
+	  into a situation where one of your kernel modules crashes the
+	  kernel on boot. This option lets you specify in the kernel
+	  command line (via exclude-modules=) a comma-separated list 
+	  of kernel modules that the kernel will refuse to load based 
+	  on their names.
+
 config STOP_MACHINE
 	bool
 	default y
diff --git a/kernel/module.c b/kernel/module.c
index 9bd93de..14457dd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1551,6 +1551,27 @@ static inline void add_kallsyms(struct module *mod,
 }
 #endif /* CONFIG_KALLSYMS */
 
+#ifdef CONFIG_MODULE_EXCLUSION
+
+static char exclusion_names[0x100];
+static int __init module_exclusion_setup(char *str)
+{
+	snprintf(exclusion_names, sizeof(exclusion_names), ",%s,", str);
+	return 1;
+}
+__setup("exclude-modules=", module_exclusion_setup);
+
+static int is_module_excluded(const char *name)
+{
+	char lookup_str[MODULE_NAME_LEN+3];
+	snprintf(lookup_str, sizeof(lookup_str), ",%s,", name);
+	return strstr(exclusion_names, lookup_str) != NULL;
+}
+
+#else
+static inline int is_module_excluded(const char *name) {return 0;}
+#endif
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static struct module *load_module(void __user *umod,
@@ -1714,6 +1735,11 @@ static struct module *load_module(void __user *umod,
 		goto free_hdr;
 	}
 
+	if (is_module_excluded(mod->name)) {
+		err = -EACCES;
+		goto free_mod;
+	}
+
 	if (find_module(mod->name)) {
 		err = -EEXIST;
 		goto free_mod;


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
