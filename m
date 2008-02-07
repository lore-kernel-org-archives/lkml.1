Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbYBGNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbYBGNjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYBGNjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:39:07 -0500
Received: from s131.mittwaldmedien.de ([62.216.178.31]:11625 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYBGNjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:39:06 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Subject: [PATCH] sysctl: allow embedded targets to disable sysctl_check.c
Date: Thu, 7 Feb 2008 14:38:58 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802071438.58497.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable sysctl_check.c for embedded targets. This saves about about 11 kB
in .text and another 11 kB in .data on a PXA255 embedded platform.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -475,6 +475,17 @@
 
 	  If unsure say Y here.
 
+config SYSCTL_SYSCALL_CHECK
+	bool "Sysctl checks" if EMBEDDED
+	depends on SYSCTL_SYSCALL
+	default y
+	---help---
+	  sys_sysctl uses binary paths that have been found challenging
+	  to properly maintain and use. This enables checks that help
+	  you to keep things correct.
+
+	  If unsure say Y here.
+
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
 	 default y
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -11,7 +11,7 @@
 	    hrtimer.o rwsem.o nsproxy.o srcu.o \
 	    utsname.o notifier.o ksysfs.o pm_qos_params.o
 
-obj-$(CONFIG_SYSCTL) += sysctl_check.o
+obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
 obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -1604,9 +1604,13 @@
 
 static __init int sysctl_init(void)
 {
-	int err;
 	sysctl_set_parent(NULL, root_table);
-	err = sysctl_check_table(current->nsproxy, root_table);
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
+	{
+		int err;
+		err = sysctl_check_table(current->nsproxy, root_table);
+	}
+#endif
 	return 0;
 }
 
@@ -1733,10 +1737,12 @@
 	header->unregistering = NULL;
 	header->root = root;
 	sysctl_set_parent(NULL, header->ctl_table);
+#ifdef CONFIG_SYSCTL_SYSCALL_CHECK
 	if (sysctl_check_table(namespaces, header->ctl_table)) {
 		kfree(header);
 		return NULL;
 	}
+#endif
 	spin_lock(&sysctl_lock);
 	header_list = lookup_header_list(root, namespaces);
 	list_add_tail(&header->ctl_entry, header_list);
