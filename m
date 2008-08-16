Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbYHPEOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbYHPEOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYHPEGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:18 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33312 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYHPEFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:44 -0400
Date: Fri, 15 Aug 2008 21:41:47 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3fl4Y022575@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 25/28] mdb: add a notify_die handler to panic.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add a notify_die handler to hook the panic entry point prior to 
Linux "execve"-ing another kernel for crash analysis.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/panic.c	2008-08-15 21:26:27.000000000 -0600
+++ b/kernel/panic.c	2008-08-15 15:41:57.000000000 -0600
@@ -21,6 +21,8 @@
 #include <linux/debug_locks.h>
 #include <linux/random.h>
 #include <linux/kallsyms.h>
+#include <linux/kdebug.h>
+
 
 int panic_on_oops;
 int tainted;
@@ -82,6 +84,13 @@
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 	bust_spinlocks(0);
 
+        /* call the notify_die handler for any resident debuggers which
+        * may be active and pass the message string.   On a software
+        * fault return at least some sort of regs for a remote debugger
+        * to look at.
+        */
+	notify_die(DIE_PANIC, buf, get_irq_regs(), 0, 0, 0);
+
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
