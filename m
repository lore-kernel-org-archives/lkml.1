Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0BLWg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:36:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:44150 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab0BLWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 23/28] keyboard, input: Add hook to input to allow low level event clear
Date: Fri, 12 Feb 2010 16:35:38 -0600
Message-Id: <1266014143-29444-24-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:24.0426 (UTC) FILETIME=[CEAD64A0:01CAAC33]
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
 drivers/char/keyboard.c |   29 ++++++++++++++++++++++++-----
 drivers/input/input.c   |   15 +++++++++++++++
 drivers/serial/kgdboc.c |   13 +++++++++++++
 include/linux/input.h   |   10 ++++++++++
 4 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index f706b1d..d61145a 100644
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
@@ -1410,6 +1410,22 @@ static const struct input_device_id kbd_ids[] = {
 
 MODULE_DEVICE_TABLE(input, kbd_ids);
 
+#ifdef CONFIG_KDB_KEYBOARD
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
 static struct input_handler kbd_handler = {
 	.event		= kbd_event,
 	.connect	= kbd_connect,
@@ -1417,6 +1433,9 @@ static struct input_handler kbd_handler = {
 	.start		= kbd_start,
 	.name		= "kbd",
 	.id_table	= kbd_ids,
+#ifdef CONFIG_KDB_KEYBOARD
+	.dbg_clear_keys = kbd_clear_keys,
+#endif
 };
 
 int __init kbd_init(void)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 86cb2d2..7473300 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1692,6 +1692,21 @@ int input_register_handler(struct input_handler *handler)
 }
 EXPORT_SYMBOL(input_register_handler);
 
+#ifdef CONFIG_KDB_KEYBOARD
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
index b765ab4..201cdf5 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -17,6 +17,7 @@
 #include <linux/kdb.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/input.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -35,12 +36,16 @@ static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
 
 #ifdef CONFIG_KDB_KEYBOARD
+static int kgdboc_use_kbd;  /* 1 if we use a keyboard */
+
 static int kgdboc_register_kbd(char **cptr)
 {
+	kgdboc_use_kbd = 0;
 	if (strncmp(*cptr, "kbd", 3) == 0) {
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
+			kgdboc_use_kbd = 1;
 			if (cptr[0][3] == ',')
 				*cptr += 4;
 			else
@@ -63,9 +68,16 @@ static void kgdboc_unregister_kbd(void)
 		}
 	}
 }
+
+static inline void kgdboc_clear_kbd(void)
+{
+	if (kgdboc_use_kbd)
+		input_dbg_clear_keys(); /* Release all pressed keys */
+}
 #else /* ! CONFIG_KDB_KEYBOARD */
 #define kgdboc_register_kbd(x) 0
 #define kgdboc_unregister_kbd()
+#define kgdboc_clear_kbd()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
 static int kgdboc_option_setup(char *opt)
@@ -213,6 +225,7 @@ static void kgdboc_post_exp_handler(void)
 	/* decrement the module count when the debugger detaches */
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
+	kgdboc_clear_kbd();
 }
 
 static struct kgdb_io kgdboc_io_ops = {
diff --git a/include/linux/input.h b/include/linux/input.h
index 735ceaf..c311871 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1231,6 +1231,9 @@ struct input_handler {
 	int (*connect)(struct input_handler *handler, struct input_dev *dev, const struct input_device_id *id);
 	void (*disconnect)(struct input_handle *handle);
 	void (*start)(struct input_handle *handle);
+#ifdef CONFIG_KDB_KEYBOARD
+	void (*dbg_clear_keys)(void);
+#endif
 
 	const struct file_operations *fops;
 	int minor;
@@ -1316,6 +1319,13 @@ int input_flush_device(struct input_handle* handle, struct file* file);
 void input_event(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 void input_inject_event(struct input_handle *handle, unsigned int type, unsigned int code, int value);
 
+#ifdef CONFIG_KDB_KEYBOARD
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

