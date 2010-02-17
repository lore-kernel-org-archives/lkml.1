Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab0BQNrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:47:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53754 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934242Ab0BQNrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:47:25 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/3] vt: Fix refcounting use
To: linux-kernel@vger.kernel.org
Date: Wed, 17 Feb 2010 13:23:29 +0000
Message-ID: <20100217132317.17289.61570.stgit@localhost.localdomain>
In-Reply-To: <20100217131931.17289.68158.stgit@localhost.localdomain>
References: <20100217131931.17289.68158.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to properly refcount the vc tty because of the cases where a vc is
disassociated from a tty (eg destroyed). At the moment the code isn't safe
and in fact input even tries to patch up broken pointers as a result!

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/keyboard.c |   47 +++++++++++-------
 drivers/char/vt.c       |  126 ++++++++++++++++++++++++++++++++---------------
 drivers/char/vt_ioctl.c |    6 +-
 3 files changed, 119 insertions(+), 60 deletions(-)


diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index cd440f8..46d0b1a 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -315,17 +315,18 @@ int kbd_rate(struct kbd_repeat *rep)
  */
 static void put_queue(struct vc_data *vc, int ch)
 {
-	struct tty_struct *tty = vc->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&vc->port);
 
 	if (tty) {
 		tty_insert_flip_char(tty, ch, 0);
 		con_schedule_flip(tty);
+		tty_kref_put(tty);
 	}
 }
 
 static void puts_queue(struct vc_data *vc, char *cp)
 {
-	struct tty_struct *tty = vc->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&vc->port);
 
 	if (!tty)
 		return;
@@ -335,6 +336,7 @@ static void puts_queue(struct vc_data *vc, char *cp)
 		cp++;
 	}
 	con_schedule_flip(tty);
+	tty_kref_put(tty);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -497,10 +499,12 @@ static void fn_show_ptregs(struct vc_data *vc)
 
 static void fn_hold(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&vc->port);
 
-	if (rep || !tty)
+	if (rep || !tty) {
+	        tty_kref_put(tty);
 		return;
+        }
 
 	/*
 	 * Note: SCROLLOCK will be set (cleared) by stop_tty (start_tty);
@@ -511,6 +515,7 @@ static void fn_hold(struct vc_data *vc)
 		start_tty(tty);
 	else
 		stop_tty(tty);
+        tty_kref_put(tty);
 }
 
 static void fn_num(struct vc_data *vc)
@@ -575,12 +580,13 @@ static void fn_inc_console(struct vc_data *vc)
 
 static void fn_send_intr(struct vc_data *vc)
 {
-	struct tty_struct *tty = vc->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&vc->port);
 
 	if (!tty)
 		return;
 	tty_insert_flip_char(tty, 0, TTY_BREAK);
 	con_schedule_flip(tty);
+	tty_kref_put(tty);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
@@ -1167,11 +1173,14 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	int shift_final;
 	struct keyboard_notifier_param param = { .vc = vc, .value = keycode, .down = down };
 
-	tty = vc->port.tty;
+	tty = tty_port_tty_get(&vc->port);
 
-	if (tty && (!tty->driver_data)) {
-		/* No driver data? Strange. Okay we fix it then. */
-		tty->driver_data = vc;
+	if (tty && !tty->driver_data) {
+		/* No driver data? - can't continue */
+		WARN_ON(1);
+		/* If this race still exists we want to know */
+		tty_kref_put(tty);
+		return;
 	}
 
 	kbd = kbd_table + vc->vc_num;
@@ -1201,13 +1210,13 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 			sysrq_down = down;
 			sysrq_alt_use = sysrq_alt;
 		}
-		return;
+		goto put;
 	}
 	if (sysrq_down && !down && keycode == sysrq_alt_use)
 		sysrq_down = 0;
 	if (sysrq_down && down && !rep) {
 		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
-		return;
+		goto put;
 	}
 #endif
 #ifdef CONFIG_SPARC
@@ -1245,7 +1254,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 		 * characters get aren't echoed locally. This makes key repeat
 		 * usable with slow applications and under heavy loads.
 		 */
-		return;
+		goto put;
 	}
 
 	param.shift = shift_final = (shift_state | kbd->slockstate) ^ kbd->lockstate;
@@ -1256,14 +1265,14 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 		atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNBOUND_KEYCODE, &param);
 		compute_shiftstate();
 		kbd->slockstate = 0;
-		return;
+		goto put;
 	}
 
 	if (keycode >= NR_KEYS)
 		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
 			keysym = U(K(KT_BRL, keycode - KEY_BRL_DOT1 + 1));
 		else
-			return;
+			goto put;
 	else
 		keysym = key_map[keycode];
 
@@ -1272,10 +1281,10 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	if (type < 0xf0) {
 		param.value = keysym;
 		if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNICODE, &param) == NOTIFY_STOP)
-			return;
+			goto put;
 		if (down && !raw_mode)
 			to_utf8(vc, keysym);
-		return;
+		goto put;
 	}
 
 	type -= 0xf0;
@@ -1291,10 +1300,10 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	param.value = keysym;
 
 	if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_KEYSYM, &param) == NOTIFY_STOP)
-		return;
+		goto put;
 
 	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
-		return;
+		goto put;
 
 	(*k_handler[type])(vc, keysym & 0xff, !down);
 
@@ -1303,6 +1312,8 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 
 	if (type != KT_SLOCK)
 		kbd->slockstate = 0;
+put:
+        tty_kref_put(tty);
 }
 
 static void kbd_event(struct input_handle *handle, unsigned int event_type,
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 9821628..bc9f1fd 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -157,7 +157,7 @@ static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
 static void set_palette(struct vc_data *vc);
-
+static int con_activate(struct tty_port *port, struct tty_struct *tty);
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
 module_param(default_utf8, int, S_IRUGO | S_IWUSR);
@@ -744,6 +744,10 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
 }
 
+static const struct tty_port_operations con_port_ops = {
+	.activate = con_activate,
+};
+
 int vc_allocate(unsigned int currcons)	/* return 0 on success */
 {
 	WARN_CONSOLE_UNLOCKED();
@@ -769,6 +773,7 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		return -ENOMEM;
 	    vc_cons[currcons].d = vc;
 	    tty_port_init(&vc->port);
+	    vc->port.ops = &con_port_ops;
 	    INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
@@ -2696,6 +2701,7 @@ static int con_write(struct tty_struct *tty, const unsigned char *buf, int count
 	retval = do_con_write(tty, buf, count);
 	con_flush_chars(tty);
 
+	printk("con_write: %s %d\n", current->comm, retval);
 	return retval;
 }
 
@@ -2771,7 +2777,6 @@ static void con_flush_chars(struct tty_struct *tty)
 	if (in_interrupt())	/* from flush_to_ldisc */
 		return;
 
-	/* if we race with con_close(), vt may be null */
 	acquire_console_sem();
 	vc = tty->driver_data;
 	if (vc)
@@ -2779,61 +2784,100 @@ static void con_flush_chars(struct tty_struct *tty)
 	release_console_sem();
 }
 
-/*
- * Allocate the console screen memory.
+/**
+ *	con_install	-	called when a tty is being opened
+ *	@driver: the driver for the tty
+ *	@tty: the new tty being created
+ *
+ *	Allocate the console screen memory and install the relevant structures
+ *	into the kernel. We don't yet use this to kref consoles but the
+ *	tty layer provides the framework for this via the install and shutdown
+ *	methods.
  */
-static int con_open(struct tty_struct *tty, struct file *filp)
+
+static int con_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	unsigned int currcons = tty->index;
-	int ret = 0;
+	int idx = tty->index;
+	int ret = tty_init_termios(tty);
+	struct vc_data *vc;
+
+	if (ret)
+		return ret;
 
 	acquire_console_sem();
-	if (tty->driver_data == NULL) {
-		ret = vc_allocate(currcons);
-		if (ret == 0) {
-			struct vc_data *vc = vc_cons[currcons].d;
-
-			/* Still being freed */
-			if (vc->port.tty) {
-				release_console_sem();
-				return -ERESTARTSYS;
-			}
-			tty->driver_data = vc;
-			vc->port.tty = tty;
+	ret = vc_allocate(idx);
+	if (ret == 0) {
+		printk("install: %s: vc_allocate %d = %d\n", current->comm, idx, ret);
+		vc = vc_cons[idx].d;
+		tty_driver_kref_get(driver);
+		tty->count++;
+		tty->driver_data = vc;
+		driver->ttys[idx] = tty;
+	} else 
+		tty_free_termios(tty);
+	release_console_sem();
+	return ret;
+}
 
-			if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
-				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
-				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
-			}
-			if (vc->vc_utf)
-				tty->termios->c_iflag |= IUTF8;
-			else
-				tty->termios->c_iflag &= ~IUTF8;
-			release_console_sem();
-			return ret;
-		}
+/**
+ *	con_activate	-	set up for initial open
+ *	@port: the port being opened
+ *	@tty: the tty we are binding
+ *
+ *	At this point tty->driver_data has been set by the install method.
+ *	We are called under the port mutex serialized from close and hangup
+ *	events. Fill in the various termios and winsize related bits according
+ *	to the console itself.
+ */
+
+static int con_activate(struct tty_port *port, struct tty_struct *tty)
+{
+	struct vc_data *vc = tty->driver_data;
+
+	printk("con_activate %d: %s\n", tty->index, current->comm);
+	acquire_console_sem();
+	if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
+		tty->winsize.ws_row = vc->vc_rows;
+		tty->winsize.ws_col = vc->vc_cols;
 	}
+	if (vc->vc_utf)
+		tty->termios->c_iflag |= IUTF8;
+	else
+		tty->termios->c_iflag &= ~IUTF8;
 	release_console_sem();
+	return 0;
+}	
+
+/*
+ *	Use the standard helpers for this part of the process.
+ */
+
+static int con_open(struct tty_struct *tty, struct file *filp)
+{
+	struct vc_data *vc = tty->driver_data;
+	int ret; 
+	printk("Console open %s %d\n", current->comm, tty->index);
+	ret = tty_port_open(&vc->port, tty, filp);
+	printk("Ret %d\n", ret);
 	return ret;
 }
 
 static void con_close(struct tty_struct *tty, struct file *filp)
 {
-	/* Nothing to do - we defer to shutdown */
+	struct vc_data *vc = tty->driver_data;
+	printk("Console close %s %d\n", current->comm, tty->index);
+	tty_port_close(&vc->port, tty, filp);
 }
 
-static void con_shutdown(struct tty_struct *tty)
+static void con_hangup(struct tty_struct *tty)
 {
 	struct vc_data *vc = tty->driver_data;
-	BUG_ON(vc == NULL);
-	acquire_console_sem();
-	vc->port.tty = NULL;
-	release_console_sem();
-	tty_shutdown(tty);
+	printk("Console hangup %s %d\n", current->comm, tty->index);
+	tty_port_hangup(&vc->port);
 }
 
-static int default_italic_color    = 2; // green (ASCII)
-static int default_underline_color = 3; // cyan (ASCII)
+static int default_italic_color    = 2; /* green (ASCII) */
+static int default_underline_color = 3; /* cyan (ASCII) */
 module_param_named(italic, default_italic_color, int, S_IRUGO | S_IWUSR);
 module_param_named(underline, default_underline_color, int, S_IRUGO | S_IWUSR);
 
@@ -2910,6 +2954,7 @@ static int __init con_init(void)
 		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		tty_port_init(&vc->port);
+		vc->port.ops = &con_port_ops;
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
@@ -2940,6 +2985,8 @@ console_initcall(con_init);
 static const struct tty_operations con_ops = {
 	.open = con_open,
 	.close = con_close,
+	.hangup = con_hangup,
+	.install = con_install,
 	.write = con_write,
 	.write_room = con_write_room,
 	.put_char = con_put_char,
@@ -2954,7 +3001,6 @@ static const struct tty_operations con_ops = {
 	.throttle = con_throttle,
 	.unthrottle = con_unthrottle,
 	.resize = vt_resize,
-	.shutdown = con_shutdown
 };
 
 static struct cdev vc0_cdev;
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 625f77d..8540604 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1367,13 +1367,15 @@ void vc_SAK(struct work_struct *work)
 	acquire_console_sem();
 	vc = vc_con->d;
 	if (vc) {
-		tty = vc->port.tty;
+		tty = tty_port_tty_get(&vc->port);
 		/*
 		 * SAK should also work in all raw modes and reset
 		 * them properly.
 		 */
-		if (tty)
+		if (tty) {
 			__do_SAK(tty);
+			tty_kref_put(tty);
+		}
 		reset_vc(vc);
 	}
 	release_console_sem();

