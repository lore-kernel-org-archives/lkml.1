Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbYBEWBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbYBEWBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760232AbYBEWBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:01:12 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:46429 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759536AbYBEWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:01:10 -0500
X-Greylist: delayed 153726 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 17:01:09 EST
Date: Tue, 5 Feb 2008 22:00:54 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH,RESEND] Basic braille screen reader support
Message-ID: <20080205220054.GD4394@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	torvalds@osdl.org, linux-kernel@vger.kernel.org
References: <20080204031842.GE4439@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204031842.GE4439@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a minimalistic braille screen reader support.
This is meant to be used by blind people e.g. on boot failures or when /
cannot be mounted etc and thus the userland screen readers can not work.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
Greg KH was OK with this patch and there was no other complains, so I
resubmit it, with a fixed signed-off-by.
I think it should fine for mainline, as it is not enable by default and
doesn't change anything else and exporting a few functions that will be
needed for SpeakUp too.

--- linux-2.6.24-orig/drivers/char/consolemap.c	2008-01-25 08:32:05.000000000 +0000
+++ linux-2.6.24-perso/drivers/char/consolemap.c	2008-02-03 21:27:04.000000000 +0000
@@ -277,6 +277,7 @@
 			return p->inverse_translations[m][glyph];
 	}
 }
+EXPORT_SYMBOL_GPL(inverse_translate);
 
 static void update_user_maps(void)
 {
--- linux-2.6.24-orig/drivers/char/vt.c	2008-01-25 08:32:06.000000000 +0000
+++ linux-2.6.24-perso/drivers/char/vt.c	2008-02-03 21:27:04.000000000 +0000
@@ -3982,6 +3982,7 @@
 		c |= 0x100;
 	return c;
 }
+EXPORT_SYMBOL_GPL(screen_glyph);
 
 /* used by vcs - note the word offset */
 unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
--- linux-2.6.24-orig/drivers/char/keyboard.c	2008-01-25 08:32:06.000000000 +0000
+++ linux-2.6.24-perso/drivers/char/keyboard.c	2008-02-04 02:44:37.000000000 +0000
@@ -110,6 +110,7 @@
 const int NR_TYPES = ARRAY_SIZE(max_vals);
 
 struct kbd_struct kbd_table[MAX_NR_CONSOLES];
+EXPORT_SYMBOL_GPL(kbd_table);
 static struct kbd_struct *kbd = kbd_table;
 
 struct vt_spawn_console vt_spawn_con = {
@@ -260,6 +261,7 @@
 	} else
 		kd_nosound(0);
 }
+EXPORT_SYMBOL_GPL(kd_mksound);
 
 /*
  * Setting the keyboard rate.
--- linux-2.6.24-orig/drivers/Kconfig	2008-01-25 08:32:04.000000000 +0000
+++ linux-2.6.24-perso/drivers/Kconfig	2008-02-04 01:32:17.000000000 +0000
@@ -95,4 +95,6 @@
 source "drivers/uio/Kconfig"
 
 source "drivers/virtio/Kconfig"
+
+source "drivers/a11y/Kconfig"
 endmenu
--- linux-2.6.24-orig/drivers/Makefile	2008-01-25 08:32:04.000000000 +0000
+++ linux-2.6.24-perso/drivers/Makefile	2008-02-04 01:33:27.000000000 +0000
@@ -28,6 +28,8 @@
 obj-$(CONFIG_FB_INTEL)          += video/intelfb/
 
 obj-y				+= serial/
+# a11y comes after serial because it depends on it
+obj-$(CONFIG_A11Y)		+= a11y/
 obj-$(CONFIG_PARPORT)		+= parport/
 obj-y				+= base/ block/ misc/ mfd/ net/ media/
 obj-$(CONFIG_NUBUS)		+= nubus/
--- linux-2.6.24-orig/include/linux/serial_8250.h	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.24-perso/include/linux/serial_8250.h	2008-02-03 21:28:40.000000000 +0000
@@ -66,4 +66,6 @@
 extern int serial8250_find_port_for_earlycon(void);
 extern int setup_early_serial8250_console(char *cmdline);
 
+extern struct console serial8250_console;
+
 #endif
--- linux-2.6.24-orig/drivers/serial/8250.c	2007-10-09 21:31:38.000000000 +0100
+++ linux-2.6.24-perso/drivers/serial/8250.c	2008-02-03 21:29:54.000000000 +0000
@@ -2547,7 +2547,7 @@
 }
 
 static struct uart_driver serial8250_reg;
-static struct console serial8250_console = {
+struct console serial8250_console = {
 	.name		= "ttyS",
 	.write		= serial8250_console_write,
 	.device		= uart_console_device,
@@ -2557,6 +2557,7 @@
 	.index		= -1,
 	.data		= &serial8250_reg,
 };
+EXPORT_SYMBOL_GPL(serial8250_console);
 
 static int __init serial8250_console_init(void)
 {
diff -urN linux-2.6.24-orig/drivers/a11y/braille/braille_console.c linux-2.6.24-perso/drivers/a11y/braille/braille_console.c
--- linux-2.6.24-orig/drivers/a11y/braille/braille_console.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-perso/drivers/a11y/braille/braille_console.c	2008-02-04 01:58:16.000000000 +0000
@@ -0,0 +1,390 @@
+/*
+ * Minimalistic braille device kernel support.
+ *
+ * By default, shows console messages on the braille device.
+ * Pressing Insert switches to VC browsing.
+ *
+ *  Copyright (C) Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software ; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation ; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY ; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the program ; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/console.h>
+#include <linux/notifier.h>
+
+#include <linux/selection.h>
+#include <linux/vt_kern.h>
+#include <linux/consolemap.h>
+
+#include <linux/keyboard.h>
+#include <linux/kbd_kern.h>
+#include <linux/input.h>
+
+#include <linux/serial_8250.h>
+
+MODULE_AUTHOR("samuel.thibault@ens-lyon.org");
+MODULE_DESCRIPTION("braille device");
+MODULE_LICENSE("GPL");
+
+/*
+ * Braille device support part.
+ */
+
+/* Emit various sounds */
+static int sound;
+module_param(sound, bool, 0);
+MODULE_PARM_DESC(sound, "emit sounds");
+#define beep(freq) do { if (sound) kd_mksound(freq, HZ/10); } while(0)
+
+/* mini console */
+#define WIDTH 40
+#define BRAILLE_KEY KEY_INSERT
+static u16 console_buf[WIDTH];
+static int console_cursor = 0;
+
+/* mini view of VC */
+static int vc_x, vc_y, lastvc_x, lastvc_y;
+
+/* show console ? (or show VC) */
+static int console_show = 1;
+/* pending newline ? */
+static int console_newline = 1;
+static int lastVC = -1;
+
+static struct console *braille_co;
+
+/* Very VisioBraille-specific */
+static void braille_write(u16 *buf)
+{
+	static u16 lastwrite[WIDTH];
+	unsigned char data[1 + 1 + 2*WIDTH + 2 + 1], csum = 0, *c;
+	u16 out;
+	int i;
+
+	if (!braille_co)
+		return;
+
+	if (!memcmp(lastwrite, buf, WIDTH * sizeof(*buf)))
+		return;
+	memcpy(lastwrite, buf, WIDTH * sizeof(*buf));
+
+#define SOH 1
+#define STX 2
+#define ETX 2
+#define EOT 4
+#define ENQ 5
+	data[0] = STX;
+	data[1] = '>';
+	csum ^= '>';
+	c = &data[2];
+	for (i=0; i<WIDTH; i++) {
+		out = buf[i];
+		if (out >= 0x100)
+			out = '?';
+		else if (out == 0x00)
+			out = ' ';
+		csum ^= out;
+		if (out <= 0x05) {
+			*c++ = SOH;
+			out |= 0x40;
+		}
+		*c++ = out;
+	}
+
+	if (csum <= 0x05) {
+		*c++ = SOH;
+		csum = 0x40;
+	}
+	*c++ = csum;
+	*c++ = ETX;
+
+	serial8250_console.write(braille_co, data, c - data);
+}
+
+/* Follow the VC cursor*/
+static void vc_follow_cursor(struct vc_data *vc)
+{
+	vc_x = vc->vc_x - (vc->vc_x % WIDTH);
+	vc_y = vc->vc_y;
+	lastvc_x = vc->vc_x;
+	lastvc_y = vc->vc_y;
+}
+
+/* Maybe the VC cursor moved, if so follow it */
+static void vc_maybe_cursor_moved(struct vc_data *vc)
+{
+	if (vc->vc_x != lastvc_x || vc->vc_y != lastvc_y)
+		vc_follow_cursor(vc);
+}
+
+/* Show portion of VC at vc_x, vc_y */
+static void vc_refresh(struct vc_data *vc)
+{
+	u16 buf[WIDTH];
+	int i;
+
+	for (i = 0; i<WIDTH; i++) {
+		u16 glyph = screen_glyph(vc, 2 * (vc_x + i) + vc_y * vc->vc_size_row);
+		buf[i] = inverse_translate(vc, glyph, 1);
+	}
+	braille_write(buf);
+}
+
+/*
+ * Link to keyboard
+ */
+
+static int keyboard_notifier_call(struct notifier_block *blk, unsigned long code, void *_param)
+{
+	struct keyboard_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	int ret = NOTIFY_OK;
+
+	if (!param->down)
+		return ret;
+
+	switch (code) {
+		case KBD_KEYCODE:
+			if (console_show) {
+				if (param->value == BRAILLE_KEY) {
+					console_show = 0;
+					beep(880);
+					vc_maybe_cursor_moved(vc);
+					vc_refresh(vc);
+					ret = NOTIFY_STOP;
+				}
+			} else {
+				ret = NOTIFY_STOP;
+				switch (param->value) {
+					case KEY_INSERT:
+						beep(440);
+						console_show = 1;
+						lastVC = -1;
+						braille_write(console_buf);
+						break;
+					case KEY_LEFT:
+						if (vc_x > 0) {
+							vc_x -= WIDTH;
+							if (vc_x < 0)
+								vc_x = 0;
+						} else if (vc_y >= 1) {
+							beep(880);
+							vc_y--;
+							vc_x = vc->vc_cols-WIDTH;
+						} else
+							beep(220);
+						break;
+					case KEY_RIGHT:
+						if (vc_x + WIDTH < vc->vc_cols) {
+							vc_x += WIDTH;
+						} else if (vc_y + 1 < vc->vc_rows) {
+							beep(880);
+							vc_y++;
+							vc_x = 0;
+						} else
+							beep(220);
+						break;
+					case KEY_DOWN:
+						if (vc_y + 1 < vc->vc_rows)
+							vc_y++;
+						else
+							beep(220);
+						break;
+					case KEY_UP:
+						if (vc_y >= 1)
+							vc_y--;
+						else
+							beep(220);
+						break;
+					case KEY_HOME:
+						vc_follow_cursor(vc);
+						break;
+					case KEY_PAGEUP:
+						vc_x = 0;
+						vc_y = 0;
+						break;
+					case KEY_PAGEDOWN:
+						vc_x = 0;
+						vc_y = vc->vc_rows-1;
+						break;
+					default:
+						ret = NOTIFY_OK;
+						break;
+				}
+				if (ret == NOTIFY_STOP)
+					vc_refresh(vc);
+			}
+			break;
+		case KBD_POST_KEYSYM:
+		{
+			unsigned char type = KTYP(param->value) - 0xf0;
+			if (type == KT_SPEC) {
+				unsigned char val = KVAL(param->value);
+				int on_off = -1;
+
+				switch(val) {
+					case KVAL(K_CAPS):
+						on_off = vc_kbd_led(kbd_table + fg_console, VC_CAPSLOCK);
+						break;
+					case KVAL(K_NUM):
+						on_off = vc_kbd_led(kbd_table + fg_console, VC_NUMLOCK);
+						break;
+					case KVAL(K_HOLD):
+						on_off = vc_kbd_led(kbd_table + fg_console, VC_SCROLLOCK);
+						break;
+				}
+				if (on_off == 1)
+					beep(880);
+				else if (on_off == 0)
+					beep(440);
+			}
+		}
+		case KBD_UNBOUND_KEYCODE:
+		case KBD_UNICODE:
+		case KBD_KEYSYM:
+			/* Unused */
+			break;
+	}
+	return ret;
+}
+
+static struct notifier_block keyboard_notifier_block = {
+	.notifier_call = keyboard_notifier_call,
+};
+
+static int vt_notifier_call(struct notifier_block *blk, unsigned long code, void *_param)
+{
+	struct vt_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	switch (code) {
+		case VT_ALLOCATE:
+			break;
+		case VT_DEALLOCATE:
+			break;
+		case VT_WRITE:
+		{
+			unsigned char c = param->c;
+			switch (c) {
+				case '\b':
+				case 127:
+					if (console_cursor > 0) {
+						console_cursor--;
+						console_buf[console_cursor] = ' ';
+					}
+					break;
+				case '\n':
+				case '\v':
+				case '\f':
+				case '\r':
+					console_newline = 1;
+					break;
+				case '\t':
+					c = ' ';
+					/* Fallthrough */
+				default:
+					if (c < 32)
+						/* Ignore other control sequences */
+						break;
+					if (console_newline) {
+						memset(console_buf, 0, sizeof(console_buf));
+						console_cursor = 0;
+						console_newline = 0;
+					}
+					if (console_cursor == WIDTH)
+						memmove(console_buf, &console_buf[1], (WIDTH-1) * sizeof(*console_buf));
+					else
+						console_cursor++;
+					console_buf[console_cursor-1] = c;
+					break;
+			}
+			if (console_show)
+				braille_write(console_buf);
+			else {
+				vc_maybe_cursor_moved(vc);
+				vc_refresh(vc);
+			}
+			break;
+		}
+		case VT_UPDATE:
+			/* Maybe a VT switch, flush */
+			if (console_show) {
+				if (vc->vc_num != lastVC) {
+					lastVC = vc->vc_num;
+					memset(console_buf, 0, sizeof(console_buf));
+					console_cursor = 0;
+					braille_write(console_buf);
+				}
+			} else {
+				vc_maybe_cursor_moved(vc);
+				vc_refresh(vc);
+			}
+			break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vt_notifier_block = {
+	.notifier_call = vt_notifier_call,
+};
+
+/*
+ * Link to serial console
+ */
+
+static int __init braille_console_setup(struct console *co, char *options)
+{
+	int ret = 0;
+	if (co->index == -1)
+		co->index = 0;
+#ifndef MODULE
+	ret = serial8250_console.setup(co, options);
+	if (ret < 0)
+		return ret;
+#endif
+	braille_co = co;
+	return ret;
+}
+
+static struct console braille_console = {
+	.name		= "brl",
+	.setup		= braille_console_setup,
+	.flags		= CON_PRINTBUFFER,
+	.index		= -1,
+};
+
+/*
+ * Module access
+ */
+
+static int __init checkinit(void)
+{
+	register_console(&braille_console);
+	register_keyboard_notifier(&keyboard_notifier_block);
+	register_vt_notifier(&vt_notifier_block);
+	return 0;
+}
+static void __exit checkexit(void)
+{
+	unregister_vt_notifier(&vt_notifier_block);
+	unregister_keyboard_notifier(&keyboard_notifier_block);
+	unregister_console(&braille_console);
+}
+
+module_init(checkinit);
+module_exit(checkexit);
diff -urN linux-2.6.24-orig/drivers/a11y/Kconfig linux-2.6.24-perso/drivers/a11y/Kconfig
--- linux-2.6.24-orig/drivers/a11y/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-perso/drivers/a11y/Kconfig	2008-02-04 01:54:36.000000000 +0000
@@ -0,0 +1,22 @@
+menuconfig A11Y
+	bool "Accessibility support"
+	---help---
+	  Enable a submenu where accessibility items may be enabled.
+
+	  If unsure, say N.
+
+if A11Y
+config A11Y_BRAILLE_CONSOLE
+	tristate "Console on braille device"
+	depends on SERIAL_8250_CONSOLE
+	---help---
+	  Enables console output on a braille device connected to a 8250
+	  serial port. For now only the VisioBraille device is supported.
+
+	  To actually enable it, you need to pass option
+	  console=brl0
+	  to the kernel. Options are the same as for serial console.
+
+	  If unsure, say N.
+
+endif # A11Y
diff -urN linux-2.6.24-orig/drivers/a11y/Makefile linux-2.6.24-perso/drivers/a11y/Makefile
--- linux-2.6.24-orig/drivers/a11y/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-perso/drivers/a11y/Makefile	2008-02-04 01:42:32.000000000 +0000
@@ -0,0 +1 @@
+obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille/braille_console.o
