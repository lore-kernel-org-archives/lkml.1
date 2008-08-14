Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYHNGsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYHNGsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYHNGim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:42 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38158 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYHNGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:37:58 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EcJC006256@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 19/29] mdb: adding notify_die handler for keyboard debugger entry
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added module support for keyboard debugger entry point and
notify_die entry point.



Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/drivers/char/keyboard.c	2008-08-13 14:22:15.000000000 -0600
+++ b/drivers/char/keyboard.c	2008-08-13 11:56:03.000000000 -0600
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
