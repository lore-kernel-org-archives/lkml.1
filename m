Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbYHPEPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbYHPEPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 00:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYHPEGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 00:06:20 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33309 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYHPEFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 00:05:43 -0400
Date: Fri, 15 Aug 2008 21:41:47 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808160341.m7G3flhk022569@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 19/28] mdb: adding notify_die handler for keyboard debugger entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added module support for keyboard debugger entry point and
notify_die entry point.

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/keyboard.c	2008-08-15 21:26:13.000000000 -0600
+++ b/drivers/char/keyboard.c	2008-08-15 15:41:57.000000000 -0600
@@ -44,6 +44,10 @@
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
 
+#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
+#include <linux/kdebug.h>
+#endif
+
 extern void ctrl_alt_del(void);
 
 #define to_handle_h(n) container_of(n, struct input_handle, h_node)
@@ -1180,6 +1184,15 @@
 			if (keycode < BTN_MISC && printk_ratelimit())
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
 
+#if defined(CONFIG_MDB) || defined(CONFIG_MDB_MODULE)
+	if (down && !rep && keycode == KEY_PAUSE)
+        {
+	   if (notify_die(DIE_KERNELDEBUG, NULL, get_irq_regs(),
+                          0, -1, SIGINT) == NOTIFY_STOP)
+	      return;
+	}
+#endif
+
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
 	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
 		if (!sysrq_down) {
