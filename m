Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251Ab0BZQHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:07:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:61241 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965240Ab0BZQHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:07:10 -0500
Message-ID: <4B87F17B.6040305@windriver.com>
Date: Fri, 26 Feb 2010 10:06:19 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       Henrik Rydberg <rydberg@euromail.se>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com> <1267132893-23624-24-git-send-email-jason.wessel@windriver.com> <20100226080329.GD17062@core.coreip.homeip.net>
In-Reply-To: <20100226080329.GD17062@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2010 16:06:09.0760 (UTC) FILETIME=[9C3B6600:01CAB6FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Thu, Feb 25, 2010 at 03:21:28PM -0600, Jason Wessel wrote:
>> When using a keyboard with kdb, on resuming the system there needs to
>> be a hook to allow for the keyboard state to get reset.
>>
>> This is mainly because there is no way to force the end user to hold
>> down the original keys that were pressed prior to entering kdb.
>>
> 
> Instead of adding all the new hook can't you copy the bitmap of
> currently pressed keys when you invoke kdb and theni, on exit, use
> input_inject_event() to clear bitmasks in the devices?
> 

I know just a little more about the input system then I did 6 months
ago.  I am not sure that input_inject_event() is exactly what should
be used, but perhaps you had a different idea in mind.

I created a new patch which uses the same sort of concept.  I moved
the key release code from input_disconnect_device() into a common
function, so that it could be called by the debugger key free hook.

Would you consider acking this version (for which I can apply a delta
patch to the kdb code base)?  Or let me know what further comments you
have?

Thanks,
Jason.

---

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] input,keyboard,kgdboc: Allow key release on kernel resume

When using a keyboard with kdb, a hook point to free all the
keystrokes is required for resuming kernel operations.

This is mainly because there is no way to force the end user to hold
down the original keys that were pressed prior to entering kdb.

The change to keyboard.c fixes a defect where the keyboard bitmap map
state is not correct while in a sysrq handler.  The bitmap needs to be
updated before calling the sysrq handler.

When resuming the kernel kgdboc's callback will attempt to release all
the keys if the locks are available, else tasklet will be schedule to
release all the keys when the kernel is full resumed.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-input@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/char/keyboard.c |   10 +++---
 drivers/input/input.c   |   79 +++++++++++++++++++++++++++++++++++++++---------
 drivers/serial/kgdboc.c |   13 +++++++
 include/linux/input.h   |    7 ++++
 4 files changed, 90 insertions(+), 19 deletions(-)

--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1195,6 +1195,11 @@ static void kbd_keycode(unsigned int key
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
@@ -1237,11 +1242,6 @@ static void kbd_keycode(unsigned int key
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
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -17,6 +17,7 @@
 #include <linux/kdb.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/input.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -35,12 +36,16 @@ static struct tty_driver	*kgdb_tty_drive
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
@@ -213,6 +225,7 @@ static void kgdboc_post_exp_handler(void
 	/* decrement the module count when the debugger detaches */
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
+	kgdboc_clear_kbd();
 }
 
 static struct kgdb_io kgdboc_io_ops = {
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1359,6 +1359,13 @@ int input_flush_device(struct input_hand
 void input_event(struct input_dev *dev, unsigned int type, unsigned int code, int value);
 void input_inject_event(struct input_handle *handle, unsigned int type, unsigned int code, int value);
 
+#ifdef CONFIG_KDB_KEYBOARD
+extern void input_dbg_clear_keys(void);
+#else
+static inline void input_dbg_clear_keys(void)
+{}
+#endif
+
 static inline void input_report_key(struct input_dev *dev, unsigned int code, int value)
 {
 	input_event(dev, EV_KEY, code, !!value);
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include <linux/smp_lock.h>
+#include <linux/interrupt.h>
 #include "input-compat.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
@@ -511,12 +512,30 @@ void input_close_device(struct input_han
 EXPORT_SYMBOL(input_close_device);
 
 /*
+ * input_clear_keys - Simulate keyup events for all pressed keys so
+ * that handlers are not left with "stuck" keys.
+ */
+static void input_clear_keys(struct input_dev *dev)
+{
+	int code;
+
+	if (is_event_supported(EV_KEY, dev->evbit, EV_MAX)) {
+		for (code = 0; code <= KEY_MAX; code++) {
+			if (is_event_supported(code, dev->keybit, KEY_MAX) &&
+			    __test_and_clear_bit(code, dev->key)) {
+				input_pass_event(dev, EV_KEY, code, 0);
+			}
+		}
+		input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
+	}
+}
+
+/*
  * Prepare device for unregistering
  */
 static void input_disconnect_device(struct input_dev *dev)
 {
 	struct input_handle *handle;
-	int code;
 
 	/*
 	 * Mark device as going away. Note that we take dev->mutex here
@@ -530,20 +549,10 @@ static void input_disconnect_device(stru
 	spin_lock_irq(&dev->event_lock);
 
 	/*
-	 * Simulate keyup events for all pressed keys so that handlers
-	 * are not left with "stuck" keys. The driver may continue
-	 * generate events even after we done here but they will not
-	 * reach any handlers.
+	 * The driver may continue generate events even after we done here
+	 * but they will not reach any handlers.
 	 */
-	if (is_event_supported(EV_KEY, dev->evbit, EV_MAX)) {
-		for (code = 0; code <= KEY_MAX; code++) {
-			if (is_event_supported(code, dev->keybit, KEY_MAX) &&
-			    __test_and_clear_bit(code, dev->key)) {
-				input_pass_event(dev, EV_KEY, code, 0);
-			}
-		}
-		input_pass_event(dev, EV_SYN, SYN_REPORT, 1);
-	}
+	input_clear_keys(dev);
 
 	list_for_each_entry(handle, &dev->h_list, d_node)
 		handle->open = 0;
@@ -1692,6 +1701,48 @@ int input_register_handler(struct input_
 }
 EXPORT_SYMBOL(input_register_handler);
 
+#ifdef CONFIG_KDB_KEYBOARD
+static bool input_dbg_keys_cleared;
+
+/*
+ * input_dbg_clear_keys - Clear any keyboards if they have a call back,
+ * after returning from the kernel debugger
+ */
+static void input_clear_keys_task(unsigned long not_used)
+{
+	struct input_dev *dev;
+	unsigned long flags;
+
+	if (!input_dbg_keys_cleared)
+		return;
+	list_for_each_entry(dev, &input_dev_list, node) {
+		spin_lock_irqsave(&dev->event_lock, flags);
+		input_clear_keys(dev);
+		spin_unlock_irqrestore(&dev->event_lock, flags);
+	}
+	input_dbg_keys_cleared = false;
+}
+
+static DECLARE_TASKLET(input_clear_keys_tasklet, input_clear_keys_task, 0);
+
+void input_dbg_clear_keys(void)
+{
+	struct input_dev *dev;
+
+	if (input_dbg_keys_cleared)
+		return;
+	input_dbg_keys_cleared = true;
+	/* Schedule a tasklet unless all locks are avaialble */
+	list_for_each_entry(dev, &input_dev_list, node)
+		if (spin_is_locked(&dev->event_lock)) {
+			tasklet_schedule(&input_clear_keys_tasklet);
+			return;
+		}
+	input_clear_keys_task(0);
+}
+EXPORT_SYMBOL_GPL(input_dbg_clear_keys);
+#endif /* CONFIG_KDB_KEYBOARD */
+
 /**
  * input_unregister_handler - unregisters an input handler
  * @handler: handler to be unregistered
