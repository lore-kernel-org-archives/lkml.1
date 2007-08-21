Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbXHUA6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbXHUA6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbXHUA5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:57:33 -0400
Received: from iona.labri.fr ([147.210.8.143]:42501 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbXHUA5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:57:23 -0400
Date: Tue, 21 Aug 2007 02:57:18 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dtor@mail.ru
Subject: [PATCH] Console keyboard events and accessibility
Message-ID: <20070821005718.GD3658@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, dtor@mail.ru
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some external modules like Speakup need to use the PC keyboard to control
them and also need to get keyboard feedback (caps lock status, etc.)

This adds a keyboard notifier that such modules can use to get the keyboard
events and possibly eat them, at several stages:

- keycodes: even before translation into keysym.
- unbound keycodes: when no keysym is bound.
- unicode: when the keycode would get translated into a unicode character.
- keysym: when the keycode would get translated into a keysym.
- post_keysym: after the keysym got interpreted, so as to see the result
  (caps lock, etc.)

This also provides access to k_handler so as to permit simulation of
keypresses.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---

Hi,

Some blind people use a kernel engine called Speakup which uses hardware
synthesis to speak what gets displayed on the screen.  They use the
PC keyboard to control this engine (start/stop, accelerate, ...) and
also need to get keyboard feedback (to make sure to know what they are
typing, the caps lock status, etc.)

Up to now, the way it was done was very ugly.  Below is a patch to add a
notifier list for permitting a far better implementation, see ChangeLog
above for details.

You may wonder why this can't be done at the input layer.  The problem
is that what people want to monitor is the console keyboard, i.e. all
input keyboards that got attached to the console, and with the currently
active keymap (i.e. keysyms, not only keycodes).

Samuel

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 2ce0af1..55646de 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -41,6 +41,7 @@
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
+#include <linux/notifier.h>
 
 extern void ctrl_alt_del(void);
 
@@ -80,7 +81,8 @@
 typedef void (k_handler_fn)(struct vc_data *vc, unsigned char value,
 			    char up_flag);
 static k_handler_fn K_HANDLERS;
-static k_handler_fn *k_handler[16] = { K_HANDLERS };
+k_handler_fn *k_handler[16] = { K_HANDLERS };
+EXPORT_SYMBOL(k_handler);
 
 #define FN_HANDLERS\
 	fn_null,	fn_enter,	fn_show_ptregs,	fn_show_mem,\
@@ -159,6 +161,23 @@
 static int sysrq_alt;
 
 /*
+ * Notifier list for console keyboard events
+ */
+static ATOMIC_NOTIFIER_HEAD(keyboard_notifier_list); 
+
+int register_keyboard_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&keyboard_notifier_list, nb);
+}
+EXPORT_SYMBOL(register_keyboard_notifier);
+
+int unregister_keyboard_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&keyboard_notifier_list, nb);
+}
+EXPORT_SYMBOL(unregister_keyboard_notifier);
+
+/*
  * Translation of scancodes to keycodes. We set them on only the first
  * keyboard in the list that accepts the scancode and keycode.
  * Explanation for not choosing the first attached keyboard anymore:
@@ -1119,6 +1138,7 @@
 	unsigned char type, raw_mode;
 	struct tty_struct *tty;
 	int shift_final;
+	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 
 	tty = vc->vc_tty;
 
@@ -1206,10 +1226,11 @@
 		return;
 	}
 
-	shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
+	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
 	key_map = key_maps[shift_final];
 
-	if (!key_map) {
+	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYCODE, &param) == NOTIFY_STOP || !key_map) {
+		atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNBOUND_KEYCODE, &param);
 		compute_shiftstate();
 		kbd->slockstate = 0;
 		return;
@@ -1226,6 +1247,9 @@
 	type = KTYP(keysym);
 
 	if (type < 0xf0) {
+		param.value = keysym;
+		if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNICODE, &param) == NOTIFY_STOP)
+			return;
 		if (down && !raw_mode)
 			to_utf8(vc, keysym);
 		return;
@@ -1233,9 +1257,6 @@
 
 	type -= 0xf0;
 
-	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
-		return;
-
 	if (type == KT_LETTER) {
 		type = KT_LATIN;
 		if (vc_kbd_led(kbd, VC_CAPSLOCK)) {
@@ -1244,9 +1265,18 @@
 				keysym = key_map[keycode];
 		}
 	}
+	param.value = keysym;
+
+	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYSYM, &param) == NOTIFY_STOP)
+		return;
+
+	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
+		return;
 
 	(*k_handler[type])(vc, keysym & 0xff, !down);
 
+	atomic_notifier_call_chain(&keyboard_notifier_list, KBD_POST_KEYSYM, &param);
+
 	if (type != KT_SLOCK)
 		kbd->slockstate = 0;
 }
diff --git a/include/linux/keyboard.h b/include/linux/keyboard.h
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -2,6 +2,7 @@
 #define __LINUX_KEYBOARD_H
 
 #include <linux/wait.h>
+#include <linux/notifier.h>
 
 #define KG_SHIFT	0
 #define KG_CTRL		2
@@ -27,6 +28,16 @@
 extern const int max_vals[];
 extern unsigned short *key_maps[MAX_NR_KEYMAPS];
 extern unsigned short plain_map[NR_KEYS];
+
+struct keyboard_notifier_param {
+	struct vc_data *vc;	/* VC on which the keyboard press was done */
+	int down;		/* Pressure of the key? */
+	int shift;		/* Current shift mask */
+	unsigned int value;	/* keycode, unicode value or keysym */
+};
+
+extern int register_keyboard_notifier(struct notifier_block *nb);
+extern int unregister_keyboard_notifier(struct notifier_block *nb);
 #endif
 
 #define MAX_NR_FUNC	256	/* max nr of strings assigned to keys */
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -231,5 +231,14 @@
 #define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
 #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
 
+/* Console keyboard events.
+ * Note: KBD_KEYCODE is always sent before KBD_UNBOUND_KEYCODE, KBD_UNICODE and
+ * KBD_KEYSYM. */
+#define KBD_KEYCODE		0x0001 /* Keyboard keycode, called before any other */
+#define KBD_UNBOUND_KEYCODE	0x0002 /* Keyboard keycode which is not bound to any other */
+#define KBD_UNICODE		0x0003 /* Keyboard unicode */
+#define KBD_KEYSYM		0x0004 /* Keyboard keysym */
+#define KBD_POST_KEYSYM		0x0005 /* Called after keyboard keysym interpretation */
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
