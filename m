Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZLWVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZLWVYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZLWVVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:45306 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZLWVVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:43 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 26/37] keyboard, input: Add hook to input to allow low level event clear
Date: Wed, 23 Dec 2009 15:19:39 -0600
Message-Id: <1261603190-5036-27-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:27.0426 (UTC) FILETIME=[BF6D2020:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a keyboard with kdb, on resuming the system there needs to
be a hook to allow for the keyboard state to get reset.

This is mainly because there is no way to force the end user to hold
down the original keys that were pressed prior to entering kdb.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/keyboard.c |   30 +++++++++++++++++++++++++-----
 drivers/input/input.c   |   15 +++++++++++++++
 drivers/serial/kgdboc.c |    9 +++++++++
 include/linux/input.h   |   10 ++++++++++
 4 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index f706b1d..1db54f6 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1195,6 +1195,11 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 			if (keycode < BTN_MISC && printk_ratelimit())
 				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
 
+	if (down)
+		set_bit(keycode, key_down);
+	else
+		clear_bit(keycode, key_down);
+
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
 	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
 		if (!sysrq_down) {
@@ -1237,11 +1242,6 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 		raw_mode = 1;
 	}
 
-	if (down)
-		set_bit(keycode, key_down);
-	else
-		clear_bit(keycode, key_down);
-
 	if (rep &&
 	    (!vc_kbd_mode(kbd, VC_REPEAT) ||
 	     (tty && !L_ECHO(tty) && tty_chars_in_buffer(tty)))) {
@@ -1410,6 +1410,23 @@ static const struct input_device_id kbd_ids[] = {
 
 MODULE_DEVICE_TABLE(input, kbd_ids);
 
+#ifdef CONFIG_KGDB_KDB
+void kbd_clear_keys(void)
+{
+	int i, j, k;
+
+	for (i = 0; i < ARRAY_SIZE(key_down); i++) {
+		k = i * BITS_PER_LONG;
+		for (j = 0; j < BITS_PER_LONG; j++, k++) {
+			if (test_bit(k, key_down)) {
+				kbd_keycode(k, 0, 0);
+			}
+		}
+	}
+}
+#endif
+
+
 static struct input_handler kbd_handler = {
 	.event		= kbd_event,
 	.connect	= kbd_connect,
@@ -1417,6 +1434,9 @@ static struct input_handler kbd_handler = {
 	.start		= kbd_start,
 	.name		= "kbd",
 	.id_table	= kbd_ids,
+#ifdef CONFIG_KGDB_KDB
+	.dbg_clear_keys = kbd_clear_keys,
+#endif
 };
 
 int __init kbd_init(void)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index ab06071..b530050 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1635,6 +1635,21 @@ int input_register_handler(struct input_handler *handler)
 }
 EXPORT_SYMBOL(input_register_handler);
 
+#ifdef CONFIG_KGDB_KDB
+/* input_db_clear_keys - Clear any keyboards if they have a call back,
+ * after returning from the kernel debugger
+ */
+void input_dbg_clear_keys(void)
+{
+	struct input_handler *handler;
+
+	list_for_each_entry(handler, &input_handler_list, node)
+		if (handler->dbg_clear_keys)
+			handler->dbg_clear_keys();
+}
+EXPORT_SYMBOL_GPL(input_dbg_clear_keys);
+#endif
+
 /**
  * input_unregister_handler - unregisters an input handler
  * @handler: handler to be unregistered
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 02fbd86..217c9a2 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -17,6 +17,7 @@
 #include <linux/kdb.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/input.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -24,6 +25,7 @@ static struct kgdb_io		kgdboc_io_ops;
 
 /* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
 static int configured		= -1;
+static int kgdboc_use_kbd;  /* 1 if we use a keyboard */
 
 static char config[MAX_CONFIG_LEN];
 static struct kparam_string kps = {
@@ -81,6 +83,7 @@ static int configure_kgdboc(void)
 
 	err = -ENODEV;
 	kgdboc_io_ops.is_console = 0;
+	kgdboc_use_kbd = 0;
 
 #ifdef CONFIG_KDB_KEYBOARD
 	kgdb_tty_driver = NULL;
@@ -89,6 +92,7 @@ static int configure_kgdboc(void)
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
+			kgdboc_use_kbd = 1;
 			if (cptr[3] == ',')
 				cptr += 4;
 			else
@@ -206,6 +210,11 @@ static void kgdboc_post_exp_handler(void)
 	/* decrement the module count when the debugger detaches */
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
+#ifdef CONFIG_KDB_KEYBOARD
+	/* If using the kdb keyboard driver release all the keys. */
+	if (kgdboc_use_kbd)
+		input_dbg_clear_keys();
+#endif /* CONFIG_KDB_KEYBOARD */
 }
 
 static struct kgdb_io kgdboc_io_ops = {
diff --git a/include/linux/input.h b/include/linux/input.h
index 7be8a65..1e83336 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1230,6 +1230,9 @@ struct input_handler {
 	int (*connect)(struct input_handler *handler, struct input_dev *dev, const struct input_device_id *id);
 	void (*disconnect)(struct input_handle *handle);
 	void (*start)(struct input_handle *handle);
+#ifdef CONFIG_KGDB_KDB
+	void (*dbg_clear_keys)(void);
+#endif
 
 	const struct file_operations *fops;
 	int minor;
@@ -1315,6 +1318,13 @@ int input_flush_device(struct input_handle* handle, struct file* file);
 void input_event(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 void input_inject_event(struct input_handle *handle, unsigned int type, unsigned int code, int value);
 
+#ifdef CONFIG_KGDB_KDB
+void input_dbg_clear_keys(void);
+#else
+static inline void input_dbg_clear_keys(void)
+{}
+#endif
+
 static inline void input_report_key(struct input_dev *dev, unsigned int code, int value)
 {
 	input_event(dev, EV_KEY, code, !!value);
-- 
1.6.4.rc1

