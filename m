Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZLWVUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZLWVUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZLWVUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:20:40 -0500
Received: from mail.windriver.com ([147.11.1.11]:45104 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbZLWVUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:38 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 17/37] kgdboc,keyboard: Keyboard driver for kdb with kgdb
Date: Wed, 23 Dec 2009 15:19:30 -0600
Message-Id: <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
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
X-OriginalArrivalTime: 23 Dec 2009 21:20:16.0817 (UTC) FILETIME=[B91A5210:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in the kdb PS/2 keyboard driver.  This was mostly a
direct port from the original kdb where I cleaned up the code against
checkpatch.pl and added the glue to stitch it into kgdb.

This patch also enables early kdb debug via kgdbwait and the keyboard.

All the access to configure kdb using either a serial console or the
keyboard is done via kgdboc.

If you want to use only the keyboard and want to break in early you
would add to your kernel command arguments:

    kgdboc=kbd kgdbwait

If you wanted serial and or the keyboard access you could use:

    kgdboc=kbd,ttyS0

You can also configure kgdboc as a kernel module or at run time with
the sysfs where you can activate and deactivate kgdb.

Turn it on:
    echo kbd,ttyS0 > /sys/module/kgdboc/parameters/kgdboc

Turn it off:
    echo "" > /sys/module/kgdboc/parameters/kgdboc

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/Makefile       |    1 +
 drivers/char/kdb_keyboard.c |  207 +++++++++++++++++++++++++++++++++++++++++++
 drivers/char/kdb_keyboard.h |  143 +++++++++++++++++++++++++++++
 drivers/serial/kgdboc.c     |   67 +++++++++++++--
 include/linux/keyboard.h    |    2 +
 kernel/debug/kdb/kdb_main.c |    3 +
 lib/Kconfig.kgdb            |    7 ++
 7 files changed, 423 insertions(+), 7 deletions(-)
 create mode 100644 drivers/char/kdb_keyboard.c
 create mode 100644 drivers/char/kdb_keyboard.h

diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index f957edf..dbc579e 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
 obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
+obj-$(CONFIG_KDB_KEYBOARD)	+= kdb_keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
 obj-$(CONFIG_CONSOLE_TRANSLATIONS) += consolemap.o consolemap_deftbl.o
 obj-$(CONFIG_HW_CONSOLE)	+= vt.o defkeymap.o
diff --git a/drivers/char/kdb_keyboard.c b/drivers/char/kdb_keyboard.c
new file mode 100644
index 0000000..ab998f5
--- /dev/null
+++ b/drivers/char/kdb_keyboard.c
@@ -0,0 +1,207 @@
+/*
+ * Kernel Debugger Architecture Dependent Console I/O handler
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.
+ *
+ * Copyright (c) 1999-2006 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2009 Wind River Systems, Inc.  All Rights Reserved.
+ */
+
+
+#ifdef	CONFIG_VT_CONSOLE
+#include <linux/kdb.h>
+#include <linux/keyboard.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include "kdb_keyboard.h"
+
+
+static int kbd_exists;
+
+/*
+ * Check if the keyboard controller has a keypress for us.
+ * Some parts (Enter Release, LED change) are still blocking polled here,
+ * but hopefully they are all short.
+ */
+int kdb_get_kbd_char(void)
+{
+	int scancode, scanstatus;
+	static int shift_lock;	/* CAPS LOCK state (0-off, 1-on) */
+	static int shift_key;	/* Shift next keypress */
+	static int ctrl_key;
+	u_short keychar;
+
+	if (KDB_FLAG(NO_I8042) || KDB_FLAG(NO_VT_CONSOLE) ||
+	    (inb(KBD_STATUS_REG) == 0xff && inb(KBD_DATA_REG) == 0xff)) {
+		kbd_exists = 0;
+		return -1;
+	}
+	kbd_exists = 1;
+
+	if ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
+		return -1;
+
+	/*
+	 * Fetch the scancode
+	 */
+	scancode = inb(KBD_DATA_REG);
+	scanstatus = inb(KBD_STATUS_REG);
+
+	/*
+	 * Ignore mouse events.
+	 */
+	if (scanstatus & KBD_STAT_MOUSE_OBF)
+		return -1;
+
+	/*
+	 * Ignore release, trigger on make
+	 * (except for shift keys, where we want to
+	 *  keep the shift state so long as the key is
+	 *  held down).
+	 */
+
+	if (((scancode&0x7f) == 0x2a) || ((scancode&0x7f) == 0x36)) {
+		/*
+		 * Next key may use shift table
+		 */
+		if ((scancode & 0x80) == 0)
+			shift_key = 1;
+		else
+			shift_key = 0;
+		return -1;
+	}
+
+	if ((scancode&0x7f) == 0x1d) {
+		/*
+		 * Left ctrl key
+		 */
+		if ((scancode & 0x80) == 0)
+			ctrl_key = 1;
+		else
+			ctrl_key = 0;
+		return -1;
+	}
+
+	if ((scancode & 0x80) != 0)
+		return -1;
+
+	scancode &= 0x7f;
+
+	/*
+	 * Translate scancode
+	 */
+
+	if (scancode == 0x3a) {
+		/*
+		 * Toggle caps lock
+		 */
+		shift_lock ^= 1;
+
+#ifdef	KDB_BLINK_LED
+		kdb_toggleled(0x4);
+#endif
+		return -1;
+	}
+
+	if (scancode == 0x0e) {
+		/*
+		 * Backspace
+		 */
+		return 8;
+	}
+
+	/* Special Key */
+	switch (scancode) {
+	case 0xF: /* Tab */
+		return 9;
+	case 0x53: /* Del */
+		return 4;
+	case 0x47: /* Home */
+		return 1;
+	case 0x4F: /* End */
+		return 5;
+	case 0x4B: /* Left */
+		return 2;
+	case 0x48: /* Up */
+		return 16;
+	case 0x50: /* Down */
+		return 14;
+	case 0x4D: /* Right */
+		return 6;
+	}
+
+	if (scancode == 0xe0)
+		return -1;
+
+	/*
+	 * For Japanese 86/106 keyboards
+	 * 	See comment in drivers/char/pc_keyb.c.
+	 * 	- Masahiro Adegawa
+	 */
+	if (scancode == 0x73)
+		scancode = 0x59;
+	else if (scancode == 0x7d)
+		scancode = 0x7c;
+
+	if (!shift_lock && !shift_key && !ctrl_key) {
+		keychar = plain_map[scancode];
+	} else if (shift_lock || shift_key) {
+		keychar = shift_map[scancode];
+	} else if (ctrl_key) {
+		keychar = ctrl_map[scancode];
+	} else {
+		keychar = 0x0020;
+		kdb_printf("Unknown state/scancode (%d)\n", scancode);
+	}
+	keychar &= 0x0fff;
+	if (keychar == '\t')
+		keychar = ' ';
+	switch (KTYP(keychar)) {
+	case KT_LETTER:
+	case KT_LATIN:
+		if (isprint(keychar))
+			break;		/* printable characters */
+		/* drop through */
+	case KT_SPEC:
+		if (keychar == K_ENTER)
+			break;
+		/* drop through */
+	default:
+		return -1;	/* ignore unprintables */
+	}
+
+	if ((scancode & 0x7f) == 0x1c) {
+		/*
+		 * enter key.  All done.  Absorb the release scancode.
+		 */
+		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
+			;
+
+		/*
+		 * Fetch the scancode
+		 */
+		scancode = inb(KBD_DATA_REG);
+		scanstatus = inb(KBD_STATUS_REG);
+
+		while (scanstatus & KBD_STAT_MOUSE_OBF) {
+			scancode = inb(KBD_DATA_REG);
+			scanstatus = inb(KBD_STATUS_REG);
+		}
+
+		if (scancode != 0x9c) {
+			/*
+			 * Wasn't an enter-release,  why not?
+			 */
+			kdb_printf("kdb: expected enter got 0x%x status 0x%x\n",
+			       scancode, scanstatus);
+		}
+
+		return 13;
+	}
+
+	return keychar & 0xff;
+}
+EXPORT_SYMBOL_GPL(kdb_get_kbd_char);
+#endif	/* CONFIG_VT_CONSOLE */
diff --git a/drivers/char/kdb_keyboard.h b/drivers/char/kdb_keyboard.h
new file mode 100644
index 0000000..5541668
--- /dev/null
+++ b/drivers/char/kdb_keyboard.h
@@ -0,0 +1,143 @@
+/*
+ *	include/linux/pc_keyb.h
+ *
+ *	PC Keyboard And Keyboard Controller
+ *
+ *	(c) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ */
+
+/*
+ *	Configuration Switches
+ */
+
+#undef	KBD_REPORT_ERR			/* Report keyboard errors */
+#define	KBD_REPORT_UNKN			/* Report unknown scan codes */
+#define	KBD_REPORT_TIMEOUTS		/* Report keyboard timeouts */
+#undef	KBD_IS_FOCUS_9000		/* We have the brain-damaged
+					 * FOCUS-9000 keyboard */
+#undef	INITIALIZE_MOUSE		/* Define if your PS/2 mouse
+					 * needs initialization. */
+
+#define KBD_INIT_TIMEOUT 1000		/* Timeout in ms for initializing the
+					 * keyboard */
+#define KBC_TIMEOUT 250			/* Timeout in ms for sending
+					 * to keyboard controller */
+#define KBD_TIMEOUT 1000		/* Timeout in ms for keyboard
+					 * command acknowledge */
+
+/*
+ *	Internal variables of the driver
+ */
+
+extern unsigned char pckbd_read_mask;
+extern unsigned char aux_device_present;
+
+/*
+ *	Keyboard Controller Registers on normal PCs.
+ */
+
+#define KBD_STATUS_REG		0x64	/* Status register (R) */
+#define KBD_CNTL_REG		0x64	/* Controller command register (W) */
+#define KBD_DATA_REG		0x60	/* Keyboard data register (R/W) */
+
+/*
+ *	Keyboard Controller Commands
+ */
+
+#define KBD_CCMD_READ_MODE	0x20	/* Read mode bits */
+#define KBD_CCMD_WRITE_MODE	0x60	/* Write mode bits */
+#define KBD_CCMD_GET_VERSION	0xA1	/* Get controller version */
+#define KBD_CCMD_MOUSE_DISABLE	0xA7	/* Disable mouse interface */
+#define KBD_CCMD_MOUSE_ENABLE	0xA8	/* Enable mouse interface */
+#define KBD_CCMD_TEST_MOUSE	0xA9	/* Mouse interface test */
+#define KBD_CCMD_SELF_TEST	0xAA	/* Controller self test */
+#define KBD_CCMD_KBD_TEST	0xAB	/* Keyboard interface test */
+#define KBD_CCMD_KBD_DISABLE	0xAD	/* Keyboard interface disable */
+#define KBD_CCMD_KBD_ENABLE	0xAE	/* Keyboard interface enable */
+#define KBD_CCMD_WRITE_AUX_OBUF	0xD3    /* Write to output buffer as if
+					   initiated by the auxiliary device */
+#define KBD_CCMD_WRITE_MOUSE	0xD4	/* Write the following byte to
+					 * the mouse */
+
+/*
+ *	Keyboard Commands
+ */
+
+#define KBD_CMD_SET_LEDS	0xED	/* Set keyboard leds */
+#define KBD_CMD_SET_RATE	0xF3	/* Set typematic rate */
+#define KBD_CMD_ENABLE		0xF4	/* Enable scanning */
+#define KBD_CMD_DISABLE		0xF5	/* Disable scanning */
+#define KBD_CMD_RESET		0xFF	/* Reset */
+
+/*
+ *	Keyboard Replies
+ */
+
+#define KBD_REPLY_POR		0xAA	/* Power on reset */
+#define KBD_REPLY_ACK		0xFA	/* Command ACK */
+#define KBD_REPLY_RESEND	0xFE	/* Command NACK, send the cmd again */
+
+/*
+ *	Status Register Bits
+ */
+
+#define KBD_STAT_OBF 		0x01	/* Keyboard output buffer full */
+#define KBD_STAT_IBF 		0x02	/* Keyboard input buffer full */
+#define KBD_STAT_SELFTEST	0x04	/* Self test successful */
+#define KBD_STAT_CMD		0x08	/* Last write was a command
+					 * write (0=data) */
+#define KBD_STAT_UNLOCKED	0x10	/* Zero if keyboard locked */
+#define KBD_STAT_MOUSE_OBF	0x20	/* Mouse output buffer full */
+#define KBD_STAT_GTO 		0x40	/* General receive/xmit timeout */
+#define KBD_STAT_PERR 		0x80	/* Parity error */
+
+#define AUX_STAT_OBF (KBD_STAT_OBF | KBD_STAT_MOUSE_OBF)
+
+/*
+ *	Controller Mode Register Bits
+ */
+
+#define KBD_MODE_KBD_INT	0x01	/* Keyboard data generate IRQ1 */
+#define KBD_MODE_MOUSE_INT	0x02	/* Mouse data generate IRQ12 */
+#define KBD_MODE_SYS 		0x04	/* The system flag (?) */
+#define KBD_MODE_NO_KEYLOCK	0x08	/* The keylock doesn't affect
+					 * the keyboard if set */
+#define KBD_MODE_DISABLE_KBD	0x10	/* Disable keyboard interface */
+#define KBD_MODE_DISABLE_MOUSE	0x20	/* Disable mouse interface */
+#define KBD_MODE_KCC 		0x40	/* Scan code conversion to PC format */
+#define KBD_MODE_RFU		0x80
+
+/*
+ *	Mouse Commands
+ */
+
+#define AUX_SET_RES		0xE8	/* Set resolution */
+#define AUX_SET_SCALE11		0xE6	/* Set 1:1 scaling */
+#define AUX_SET_SCALE21		0xE7	/* Set 2:1 scaling */
+#define AUX_GET_SCALE		0xE9	/* Get scaling factor */
+#define AUX_SET_STREAM		0xEA	/* Set stream mode */
+#define AUX_SET_SAMPLE		0xF3	/* Set sample rate */
+#define AUX_ENABLE_DEV		0xF4	/* Enable aux device */
+#define AUX_DISABLE_DEV		0xF5	/* Disable aux device */
+#define AUX_RESET		0xFF	/* Reset aux device */
+#define AUX_ACK			0xFA	/* Command byte ACK. */
+
+#define AUX_BUF_SIZE		2048	/* This might be better divisible by
+					   three to make overruns stay in sync
+					   but then the read function would need
+					   a lock etc - ick */
+
+struct aux_queue {
+	unsigned long head;
+	unsigned long tail;
+	wait_queue_head_t proc_list;
+	struct fasync_struct *fasync;
+	unsigned char buf[AUX_BUF_SIZE];
+};
+
+
+/* How to access the keyboard macros on this platform.  */
+#define kbd_read_input() inb(KBD_DATA_REG)
+#define kbd_read_status() inb(KBD_STATUS_REG)
+#define kbd_write_output(val) outb(val, KBD_DATA_REG)
+#define kbd_write_command(val) outb(val, KBD_CNTL_REG)
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index eadc1ab..f4066b3 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include <linux/tty.h>
 
 #define MAX_CONFIG_LEN		40
@@ -45,11 +46,32 @@ static int kgdboc_option_setup(char *opt)
 
 __setup("kgdboc=", kgdboc_option_setup);
 
+static void cleanup_kgdboc(void)
+{
+#ifdef CONFIG_KDB_KEYBOARD
+	int i;
+
+	/* Unregister the keyboard poll hook, if registered */
+	for (i = 0; i < kdb_poll_idx; i++) {
+		if (kdb_poll_funcs[i] == kdb_get_kbd_char) {
+			kdb_poll_idx--;
+			kdb_poll_funcs[i] = kdb_poll_funcs[kdb_poll_idx];
+			kdb_poll_funcs[kdb_poll_idx] = NULL;
+			i--;
+		}
+	}
+#endif /* CONFIG_KDB_KEYBOARD */
+
+	if (configured == 1)
+		kgdb_unregister_io_module(&kgdboc_io_ops);
+}
+
 static int configure_kgdboc(void)
 {
 	struct tty_driver *p;
 	int tty_line = 0;
 	int err;
+	char *cptr = config;
 
 	err = kgdboc_option_setup(config);
 	if (err || !strlen(config) || isspace(config[0]))
@@ -57,13 +79,32 @@ static int configure_kgdboc(void)
 
 	err = -ENODEV;
 
-	p = tty_find_polling_driver(config, &tty_line);
+#ifdef CONFIG_KDB_KEYBOARD
+	kgdb_tty_driver = NULL;
+
+	if (strncmp(cptr, "kbd", 3) == 0) {
+		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
+			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
+			kdb_poll_idx++;
+			if (cptr[3] == ',')
+				cptr += 4;
+			else
+				goto do_register;
+		}
+	}
+#endif /* CONFIG_KDB_KEYBOARD */
+
+	p = tty_find_polling_driver(cptr, &tty_line);
 	if (!p)
 		goto noconfig;
 
 	kgdb_tty_driver = p;
 	kgdb_tty_line = tty_line;
 
+#ifdef CONFIG_KDB_KEYBOARD
+do_register:
+#endif /* CONFIG_KDB_KEYBOARD */
+
 	err = kgdb_register_io_module(&kgdboc_io_ops);
 	if (err)
 		goto noconfig;
@@ -75,6 +116,7 @@ static int configure_kgdboc(void)
 noconfig:
 	config[0] = 0;
 	configured = 0;
+	cleanup_kgdboc();
 
 	return err;
 }
@@ -88,20 +130,18 @@ static int __init init_kgdboc(void)
 	return configure_kgdboc();
 }
 
-static void cleanup_kgdboc(void)
-{
-	if (configured == 1)
-		kgdb_unregister_io_module(&kgdboc_io_ops);
-}
-
 static int kgdboc_get_char(void)
 {
+	if (!kgdb_tty_driver)
+		return -1;
 	return kgdb_tty_driver->ops->poll_get_char(kgdb_tty_driver,
 						kgdb_tty_line);
 }
 
 static void kgdboc_put_char(u8 chr)
 {
+	if (!kgdb_tty_driver)
+		return;
 	kgdb_tty_driver->ops->poll_put_char(kgdb_tty_driver,
 					kgdb_tty_line, chr);
 }
@@ -162,6 +202,19 @@ static struct kgdb_io kgdboc_io_ops = {
 	.post_exception		= kgdboc_post_exp_handler,
 };
 
+#ifdef CONFIG_KGDB_SERIAL_CONSOLE
+/* This is only available if kgdboc is a built in for early debugging */
+void __init early_kgdboc_init(void)
+{
+	/* save the first character of the config string because the
+	 * init routine can destroy it.
+	 */
+	char save_ch = config[0];
+	init_kgdboc();
+	config[0] = save_ch;
+}
+#endif /* CONFIG_KGDB_SERIAL_CONSOLE */
+
 module_init(init_kgdboc);
 module_exit(cleanup_kgdboc);
 module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
diff --git a/include/linux/keyboard.h b/include/linux/keyboard.h
index 33a63f6..08cd0db 100644
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -28,6 +28,8 @@ extern const int NR_TYPES;
 extern const int max_vals[];
 extern unsigned short *key_maps[MAX_NR_KEYMAPS];
 extern unsigned short plain_map[NR_KEYS];
+extern unsigned short shift_map[NR_KEYS];
+extern unsigned short ctrl_map[NR_KEYS];
 
 struct keyboard_notifier_param {
 	struct vc_data *vc;	/* VC on which the keyboard press was done */
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 4a3b61d..e0754c8 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2842,4 +2842,7 @@ void __init kdb_init(void)
 	kdb_initbptab();	/* Initialize Breakpoint Table */
 	kdb_cmd_init();		/* Preset commands from kdb_cmds */
 	kdb_initial_cpu = -1;	/* Avoid recursion problems */
+#if defined(CONFIG_KDB_KEYBOARD) && defined(CONFIG_KGDB_SERIAL_CONSOLE)
+	early_kgdboc_init();
+#endif /* CONFIG_KDB_KEYBOARD && CONFIG_KGDB_SERIAL_CONSOLE */
 }
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 02b46de..0fb633c 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -63,4 +63,11 @@ config KGDB_KDB
 	help
 	  KDB frontend for kernel
 
+config KDB_KEYBOARD
+	bool "KGDB_KDB: keyboard as input device"
+	depends on VT && KGDB_KDB
+	default y
+	help
+	  KDB can use a PS/2 type keyboard for an input device
+
 endif # KGDB
-- 
1.6.4.rc1

