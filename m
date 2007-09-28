Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbXI1SQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbXI1SQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbXI1SQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:16:12 -0400
Received: from emailgw02.pnl.gov ([192.101.109.34]:28033 "EHLO
	emailgw02.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbXI1SQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:16:10 -0400
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="33330678"
Date: Fri, 28 Sep 2007 10:16:03 -0700
From: Ken Schmidt <kenneth.schmidt@pnl.gov>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, kenneth.schmidt@pnl.gov
Subject: [patch 02/02] vfs: variant symlinks from uts
Message-Id: <20070928101603.712857d6.kenneth.schmidt@pnl.gov>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows variant symlinks to interpret their variables from uts.

Signed-off-by: Ken Schmidt <kenneth.schmidt@pnl.gov>
--
diff -urN linux-2.6.22.5.orig/fs/Kconfig linux-2.6.22.5/fs/Kconfig
--- linux-2.6.22.5.orig/fs/Kconfig	2007-09-23 10:36:16.000000000 -0700
+++ linux-2.6.22.5/fs/Kconfig	2007-09-23 10:44:00.000000000 -0700
@@ -532,6 +532,13 @@
 	  dynamically redirect their symbolic link targets based on embedded
 	  variables. If unsure, say N
 
+config VARIANT_UTS
+	tristate "Variant symlinks from UTS(uname)"
+	depends on VARIANT
+	help
+	  If you say Y here, Variables embedded in symbolic links (variant
+	  symlinks) will be evaluated from UTS (uname).
+
 config QUOTA
 	bool "Quota support"
 	help
diff -urN linux-2.6.22.5.orig/fs/variant/Makefile linux-2.6.22.5/fs/variant/Makefile
--- linux-2.6.22.5.orig/fs/variant/Makefile	2007-09-23 09:17:04.000000000 -0700
+++ linux-2.6.22.5/fs/variant/Makefile	2007-09-23 10:44:41.000000000 -0700
@@ -3,3 +3,6 @@
 #
 
 obj-$(CONFIG_VARIANT) += variant.o
+
+obj-$(CONFIG_VARIANT_UTS) += variant-uts.o
+
--- linux-2.6.22.5.unpacked/fs/variant/variant-uts.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22.5/fs/variant/variant-uts.c	2007-09-24 05:11:37.000000000 -0700
@@ -0,0 +1,76 @@
+/*
+ *   Copyright (C) Pacific Northwest National Laboratory., 2007
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *   written by Kevin Fox (kevin.fox <at> pnl.gov) for the
+ *   Department of Energy
+ */
+
+#include<linux/init.h>
+#include<linux/module.h>
+#include<linux/string.h>
+#include<linux/utsname.h>
+#include<linux/variant.h>
+
+MODULE_LICENSE("GPL");
+
+static int variant_func_id;
+static int pri = 1;
+static char *name = "uts";
+
+static int variant_uts_replace(const char *key, int keylen, char *dest, int destlen)
+{
+	char *data = NULL;
+	int retval;
+	if (!strnicmp(key, "SYSNAME", keylen)) {
+		data = utsname()->sysname;
+	} else if (!strnicmp(key, "NODENAME", keylen)) {
+		data = utsname()->nodename;
+	} else if (!strnicmp(key, "RELEASE", keylen)) {
+		data = utsname()->release;
+	} else if (!strnicmp(key, "VERSION", keylen)) {
+		data = utsname()->version;
+	} else if (!strnicmp(key, "MACHINE", keylen)) {
+		data = utsname()->machine;
+	} else if (!strnicmp(key, "DOMAINNAME", keylen)) {
+		data = utsname()->domainname;
+	}
+	if (!data)
+		return 0;
+
+	retval = strlen(data);
+
+	if (retval > destlen)
+		return 0;
+
+	memcpy(dest, data, retval + 1);
+	return retval;
+}
+
+static int __init init_variant_uts(void)
+{
+	variant_func_id = variant_func_register(variant_uts_replace, pri, name);
+	return 0;
+}
+
+static void __exit exit_variant_uts(void)
+{
+	variant_func_unregister (variant_func_id);
+}
+
+module_init (init_variant_uts);
+module_exit (exit_variant_uts);
+module_param (pri, int, 0644);
