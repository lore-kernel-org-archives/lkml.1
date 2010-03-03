Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0CCHjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:39:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:35658 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab0CCHjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:39:48 -0500
Message-ID: <4B8E1234.2030505@windriver.com>
Date: Wed, 03 Mar 2010 01:39:32 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com> <1267132893-23624-24-git-send-email-jason.wessel@windriver.com> <20100226080329.GD17062@core.coreip.homeip.net> <4B87F17B.6040305@windriver.com> <20100227075528.GA793@core.coreip.homeip.net> <4B8B3B08.7000705@windriver.com> <20100301050437.GE765@core.coreip.homeip.net> <4B8BF01D.7070507@windriver.com> <20100301183230.GA18380@core.coreip.homeip.net> <4B8C1696.5030207@windriver.com>
In-Reply-To: <4B8C1696.5030207@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2010 07:39:31.0500 (UTC) FILETIME=[A985C6C0:01CABAA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> This means we have two cases:
> 
> 1) Cleanup key strokes or "consume keys" for sysrq
> 2) Clear keyboard state on a kernel resume from kdb
> 


Because we have two separate problems, I created two separate patches
which I inlined below.

The first patch really has nothing to do with kdb.  It is a generic
problem that has existed for sometime.  I find it annoying that you
cannot execute a sysrq without trigging the window capture in gnome
because it treats alt-sysrq like alt-PrintScreen.  The testing
I completed shows that this is no long a problem with this patch.

The second patch is a follow on to the original discussion we
were having with respect to releasing all the depressed keys
when resuming the kernel and modified per your recent comments.

Thanks,
Jason


----------Patch 1--------------
From: Jason Wessel <jason.wessel@windriver.com> Subject: [PATCH]
keyboard: Change alt-sysrq to always discard key events

When issuing an alt-sysrq-KEY sequence with the keyboard driver in the
raw mode some unbalanced key down and up events can get propagated to
the registered input handlers.  This leads to strange behavior
particularly when running an X server.

If handle_sysrq() is called while executing an alt-sysrq-KEY_PRESS,
all the key events should get discarded related to the sysrq
activation sequence.

When handle_sysrq() is not called and the keyboard driver is in the
raw mode, a down and up sysrq keycode will get passed to the
registered input handlers.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-input@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/char/keyboard.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -160,6 +160,7 @@ unsigned char kbd_sysrq_xlate[KEY_MAX + 
         "\r\000/";                                      /* 0x60 - 0x6f */
 static int sysrq_down;
 static int sysrq_alt_use;
+static int sysrq_sent;
 #endif
 static int sysrq_alt;
 
@@ -1158,6 +1159,13 @@ static void kbd_rawcode(unsigned char da
 		put_queue(vc, data);
 }
 
+#define emulate_raw_keycode(kc, dwn) \
+	if (raw_mode && !hw_raw) \
+		if (emulate_raw(vc, kc, !dwn << 7)) \
+			if (keycode < BTN_MISC && printk_ratelimit()) \
+				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", kc)
+
+
 static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
@@ -1185,26 +1193,35 @@ static void kbd_keycode(unsigned int key
 
 	rep = (down == 2);
 
-	if ((raw_mode = (kbd->kbdmode == VC_RAW)) && !hw_raw)
-		if (emulate_raw(vc, keycode, !down << 7))
-			if (keycode < BTN_MISC && printk_ratelimit())
-				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
+	raw_mode = kbd->kbdmode == VC_RAW;
 
 #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
 	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
 		if (!sysrq_down) {
 			sysrq_down = down;
 			sysrq_alt_use = sysrq_alt;
+			sysrq_sent = 0;
 		}
 		return;
 	}
-	if (sysrq_down && !down && keycode == sysrq_alt_use)
+	if (sysrq_down && !down && keycode == sysrq_alt_use) {
 		sysrq_down = 0;
-	if (sysrq_down && down && !rep) {
-		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
+		if (!sysrq_sent) {
+			emulate_raw_keycode(KEY_SYSRQ, 1);
+			emulate_raw_keycode(KEY_SYSRQ, 0);
+		}
+	}
+	if (sysrq_down && !rep) {
+		if (down) {
+			handle_sysrq(kbd_sysrq_xlate[keycode], tty);
+			sysrq_sent = keycode;
+		}
 		return;
 	}
 #endif
+
+	emulate_raw_keycode(keycode, down);
+
 #ifdef CONFIG_SPARC
 	if (keycode == KEY_A && sparc_l1_a_state) {
 		sparc_l1_a_state = 0;







----------Patch 2--------------
From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] keyboard,kgdboc: Allow key release on kernel resume

When using a keyboard with kdb, a hook point to free all the
keystrokes is required for resuming kernel operations.

This is mainly because there is no way to force the end user to hold
down the original keys that were pressed prior to entering kdb when
resuming the kernel.

The kgdboc driver will call kbd_dbg_clear_keys() just prior to
resuming the kernel execution which will schedule a callback to clear
any keys which were depressed prior to the entering the kernel
debugger.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-input@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/char/keyboard.c  |   37 +++++++++++++++++++++++++++++++++++++
 drivers/serial/kgdboc.c  |   13 +++++++++++++
 include/linux/kbd_kern.h |    1 +
 3 files changed, 51 insertions(+)

--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -380,6 +380,43 @@ static void to_utf8(struct vc_data *vc, 
 	}
 }
 
+#ifdef CONFIG_KDB_KEYBOARD
+static int kbd_clear_keys_helper(struct input_handle *handle, void *data)
+{
+	unsigned int *keycode = data;
+	input_inject_event(handle, EV_KEY, *keycode, 0);
+	return 0;
+}
+
+static void kbd_clear_keys_callback(struct work_struct *dummy)
+{
+	unsigned int i, j, k;
+
+	for (i = 0; i < ARRAY_SIZE(key_down); i++) {
+		if (!key_down[i])
+			continue;
+
+		k = i * BITS_PER_LONG;
+
+		for (j = 0; j < BITS_PER_LONG; j++, k++) {
+			if (!test_bit(k, key_down))
+				continue;
+			input_handler_for_each_handle(&kbd_handler, &k,
+				      kbd_clear_keys_helper);
+		}
+	}
+}
+
+static DECLARE_WORK(kbd_clear_keys_work, kbd_clear_keys_callback);
+
+/* Called to clear any key presses after resuming the kernel. */
+void kbd_dbg_clear_keys(void)
+{
+	schedule_work(&kbd_clear_keys_work);
+}
+EXPORT_SYMBOL_GPL(kbd_dbg_clear_keys);
+#endif /* CONFIG_KDB_KEYBOARD */
+
 /*
  * Called after returning from RAW mode or when changing consoles - recompute
  * shift_down[] and shift_state from key_down[] maybe called when keymap is
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -17,6 +17,7 @@
 #include <linux/kdb.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/kbd_kern.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -35,12 +36,16 @@ static struct tty_driver	*kgdb_tty_drive
 static int			kgdb_tty_line;
 
 #ifdef CONFIG_KDB_KEYBOARD
+static bool			kgdboc_use_kbd;
+
 static int kgdboc_register_kbd(char **cptr)
 {
+	kgdboc_use_kbd = false;
 	if (strncmp(*cptr, "kbd", 3) == 0) {
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
+			kgdboc_use_kbd = true;
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
+		kbd_dbg_clear_keys(); /* Release all pressed keys */
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
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -144,6 +144,7 @@ struct console;
 int getkeycode(unsigned int scancode);
 int setkeycode(unsigned int scancode, unsigned int keycode);
 void compute_shiftstate(void);
+void kbd_dbg_clear_keys(void);
 
 /* defkeymap.c */
 
