Return-Path: <linux-kernel-owner+w=401wt.eu-S935664AbYBVA3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935664AbYBVA3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935936AbYBVA3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:29:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:32796 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935898AbYBVA31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:29:27 -0500
X-SBRS: 3.5
X-MesageID: 42998616
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,388,1199682000"; 
   d="scan'208";a="42998616"
Date: Fri, 22 Feb 2008 01:28:22 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH2] Basic braille screen reader support
Message-ID: <20080222002822.GB32480@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
	Jiri Kosina <jkosina@suse.cz>
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080205165853.561d5f3d.akpm@linux-foundation.org> <20080206020423.GG4394@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080206020423.GG4394@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Wed 06 Feb 2008 02:04:23 +0000, a écrit :
> Andrew Morton, le Tue 05 Feb 2008 16:58:53 -0800, a écrit :
> > On Tue, 5 Feb 2008 22:00:54 +0000
> > Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> > > +	serial8250_console.write(braille_co, data, c - data);
> > 
> > hm.  Is it appropriate that this driver wire itself directly into
> > serial8250?
> > What if the screen reader is attached to some other sort of
> > uart, or a terminal server, or...
> 
> Indeed that's an issue.  For now, there is no clean way to attach to the
> early serial drivers, that's why I chose 8250,

In the patch below, I hook into kernel/printk.c's console= parser, which
now gives me attachment to any kind of console.




This adds a minimalistic braille screen reader support.
This is meant to be used by blind people e.g. on boot failures or when /
cannot be mounted etc and thus the userland screen readers can not work.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff -ur linux-2.6.24.1-orig/drivers/char/consolemap.c linux-2.6.24.1-perso/drivers/char/consolemap.c
--- linux-2.6.24.1-orig/drivers/char/consolemap.c	2008-01-25 09:32:05.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/char/consolemap.c	2008-02-03 22:27:04.000000000 +0100
@@ -277,6 +277,7 @@
 			return p->inverse_translations[m][glyph];
 	}
 }
+EXPORT_SYMBOL_GPL(inverse_translate);
 
 static void update_user_maps(void)
 {
diff -ur linux-2.6.24.1-orig/drivers/char/keyboard.c linux-2.6.24.1-perso/drivers/char/keyboard.c
--- linux-2.6.24.1-orig/drivers/char/keyboard.c	2008-01-25 09:32:06.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/char/keyboard.c	2008-02-04 03:44:37.000000000 +0100
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
diff -ur linux-2.6.24.1-orig/drivers/char/vt.c linux-2.6.24.1-perso/drivers/char/vt.c
--- linux-2.6.24.1-orig/drivers/char/vt.c	2008-01-25 09:32:06.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/char/vt.c	2008-02-03 22:27:04.000000000 +0100
@@ -3982,6 +3982,7 @@
 		c |= 0x100;
 	return c;
 }
+EXPORT_SYMBOL_GPL(screen_glyph);
 
 /* used by vcs - note the word offset */
 unsigned short *screen_pos(struct vc_data *vc, int w_offset, int viewed)
diff -ur linux-2.6.24.1-orig/drivers/Kconfig linux-2.6.24.1-perso/drivers/Kconfig
--- linux-2.6.24.1-orig/drivers/Kconfig	2008-01-25 09:32:04.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/Kconfig	2008-02-20 21:52:54.000000000 +0100
@@ -95,4 +95,6 @@
 source "drivers/uio/Kconfig"
 
 source "drivers/virtio/Kconfig"
+
+source "drivers/accessibility/Kconfig"
 endmenu
diff -ur linux-2.6.24.1-orig/drivers/Makefile linux-2.6.24.1-perso/drivers/Makefile
--- linux-2.6.24.1-orig/drivers/Makefile	2008-01-25 09:32:04.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/Makefile	2008-02-20 21:55:38.000000000 +0100
@@ -5,6 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+obj-$(CONFIG_ACCESSIBILITY)	+= accessibility/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
diff -ur linux-2.6.24.1-orig/include/linux/console.h linux-2.6.24.1-perso/include/linux/console.h
--- linux-2.6.24.1-orig/include/linux/console.h	2008-01-25 09:32:44.000000000 +0100
+++ linux-2.6.24.1-perso/include/linux/console.h	2008-02-21 12:11:08.000000000 +0100
@@ -91,6 +91,7 @@
 #define CON_ENABLED	(4)
 #define CON_BOOT	(8)
 #define CON_ANYTIME	(16) /* Safe to call when cpu is offline */
+#define CON_BRL		(32) /* Used for a braille device */
 
 struct console {
 	char	name[16];
@@ -121,6 +122,9 @@
 extern void console_stop(struct console *);
 extern void console_start(struct console *);
 extern int is_console_locked(void);
+extern int braille_register_console(struct console *, int index,
+		char *console_options, char *braille_options);
+extern int braille_unregister_console(struct console *);
 
 extern int console_suspend_enabled;
 
diff -ur linux-2.6.24.1-orig/kernel/printk.c linux-2.6.24.1-perso/kernel/printk.c
--- linux-2.6.24.1-orig/kernel/printk.c	2008-02-20 21:47:09.000000000 +0100
+++ linux-2.6.24.1-perso/kernel/printk.c	2008-02-21 12:09:06.000000000 +0100
@@ -105,6 +105,7 @@
 	char	name[8];			/* Name of the driver	    */
 	int	index;				/* Minor dev. to use	    */
 	char	*options;			/* Options for the driver   */
+	char	*brl_options;			/* Options for braille driver */
 };
 
 #define MAX_CMDLINECONSOLES 8
@@ -766,15 +767,59 @@
 
 #endif
 
+static int __add_preferred_console(char *name, int idx, char *options,
+				   char *brl_options)
+{
+	struct console_cmdline *c;
+	int i;
+
+	/*
+	 *	See if this tty is not yet registered, and
+	 *	if we have a slot free.
+	 */
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+		if (strcmp(console_cmdline[i].name, name) == 0 &&
+			  console_cmdline[i].index == idx) {
+				if (!brl_options)
+					selected_console = i;
+				return 0;
+		}
+	if (i == MAX_CMDLINECONSOLES)
+		return -E2BIG;
+	if (!brl_options)
+		selected_console = i;
+	c = &console_cmdline[i];
+	memcpy(c->name, name, sizeof(c->name));
+	c->name[sizeof(c->name) - 1] = 0;
+	c->options = options;
+	c->brl_options = brl_options;
+	c->index = idx;
+	return 0;
+}
 /*
  * Set up a list of consoles.  Called from init/main.c
  */
 static int __init console_setup(char *str)
 {
 	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
-	char *s, *options;
+	char *s, *options, *brl_options = NULL;
 	int idx;
 
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	if (!memcmp(str, "brl,", 4)) {
+		brl_options = "";
+		str += 4;
+	} else if (!memcmp(str, "brl=", 4)) {
+		brl_options = str + 4;
+		str = strchr(brl_options, ',');
+		if (!str) {
+			printk(KERN_ERR "need port name after brl=\n");
+			return 1;
+		}
+		*(str++) = 0;
+	}
+#endif
+
 	/*
 	 * Decode str into name, index, options.
 	 */
@@ -799,7 +844,7 @@
 	idx = simple_strtoul(s, NULL, 10);
 	*s = 0;
 
-	add_preferred_console(buf, idx, options);
+	__add_preferred_console(buf, idx, options, brl_options);
 	return 1;
 }
 __setup("console=", console_setup);
@@ -819,28 +864,7 @@
  */
 int add_preferred_console(char *name, int idx, char *options)
 {
-	struct console_cmdline *c;
-	int i;
-
-	/*
-	 *	See if this tty is not yet registered, and
-	 *	if we have a slot free.
-	 */
-	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
-		if (strcmp(console_cmdline[i].name, name) == 0 &&
-			  console_cmdline[i].index == idx) {
-				selected_console = i;
-				return 0;
-		}
-	if (i == MAX_CMDLINECONSOLES)
-		return -E2BIG;
-	selected_console = i;
-	c = &console_cmdline[i];
-	memcpy(c->name, name, sizeof(c->name));
-	c->name[sizeof(c->name) - 1] = 0;
-	c->options = options;
-	c->index = idx;
-	return 0;
+	return __add_preferred_console(name, idx, options, NULL);
 }
 
 int update_console_cmdline(char *name, int idx, char *name_new, int idx_new, char *options)
@@ -1121,6 +1145,16 @@
 			continue;
 		if (console->index < 0)
 			console->index = console_cmdline[i].index;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+		if (console_cmdline[i].brl_options) {
+			console->flags |= CON_BRL;
+			braille_register_console(console,
+					console_cmdline[i].index,
+					console_cmdline[i].options,
+					console_cmdline[i].brl_options);
+			return;
+		}
+#endif
 		if (console->setup &&
 		    console->setup(console, console_cmdline[i].options) != 0)
 			break;
@@ -1179,6 +1213,11 @@
         struct console *a, *b;
 	int res = 1;
 
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
+	if (console->flags & CON_BRL)
+		return braille_unregister_console(console);
+#endif
+
 	acquire_console_sem();
 	if (console_drivers == console) {
 		console_drivers=console->next;
diff -urN linux-2.6.24.1-orig/drivers/accessibility/braille/braille_console.c linux-2.6.24.1-perso/drivers/accessibility/braille/braille_console.c
--- linux-2.6.24.1-orig/drivers/accessibility/braille/braille_console.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/accessibility/braille/braille_console.c	2008-02-21 12:27:41.000000000 +0100
@@ -0,0 +1,397 @@
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
+
+static void beep(unsigned int freq)
+{
+	if (sound)
+		kd_mksound(freq, HZ/10);
+}
+
+/* mini console */
+#define WIDTH 40
+#define BRAILLE_KEY KEY_INSERT
+static u16 console_buf[WIDTH];
+static int console_cursor;
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
+	for (i = 0; i < WIDTH; i++) {
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
+		csum |= 0x40;
+	}
+	*c++ = csum;
+	*c++ = ETX;
+
+	braille_co->write(braille_co, data, c - data);
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
+	for (i = 0; i < WIDTH; i++) {
+		u16 glyph = screen_glyph(vc,
+				2 * (vc_x + i) + vc_y * vc->vc_size_row);
+		buf[i] = inverse_translate(vc, glyph, 1);
+	}
+	braille_write(buf);
+}
+
+/*
+ * Link to keyboard
+ */
+
+static int keyboard_notifier_call(struct notifier_block *blk,
+				  unsigned long code, void *_param)
+{
+	struct keyboard_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	int ret = NOTIFY_OK;
+
+	if (!param->down)
+		return ret;
+
+	switch (code) {
+	case KBD_KEYCODE:
+		if (console_show) {
+			if (param->value == BRAILLE_KEY) {
+				console_show = 0;
+				beep(880);
+				vc_maybe_cursor_moved(vc);
+				vc_refresh(vc);
+				ret = NOTIFY_STOP;
+			}
+		} else {
+			ret = NOTIFY_STOP;
+			switch (param->value) {
+			case KEY_INSERT:
+				beep(440);
+				console_show = 1;
+				lastVC = -1;
+				braille_write(console_buf);
+				break;
+			case KEY_LEFT:
+				if (vc_x > 0) {
+					vc_x -= WIDTH;
+					if (vc_x < 0)
+						vc_x = 0;
+				} else if (vc_y >= 1) {
+					beep(880);
+					vc_y--;
+					vc_x = vc->vc_cols-WIDTH;
+				} else
+					beep(220);
+				break;
+			case KEY_RIGHT:
+				if (vc_x + WIDTH < vc->vc_cols) {
+					vc_x += WIDTH;
+				} else if (vc_y + 1 < vc->vc_rows) {
+					beep(880);
+					vc_y++;
+					vc_x = 0;
+				} else
+					beep(220);
+				break;
+			case KEY_DOWN:
+				if (vc_y + 1 < vc->vc_rows)
+					vc_y++;
+				else
+					beep(220);
+				break;
+			case KEY_UP:
+				if (vc_y >= 1)
+					vc_y--;
+				else
+					beep(220);
+				break;
+			case KEY_HOME:
+				vc_follow_cursor(vc);
+				break;
+			case KEY_PAGEUP:
+				vc_x = 0;
+				vc_y = 0;
+				break;
+			case KEY_PAGEDOWN:
+				vc_x = 0;
+				vc_y = vc->vc_rows-1;
+				break;
+			default:
+				ret = NOTIFY_OK;
+				break;
+			}
+			if (ret == NOTIFY_STOP)
+				vc_refresh(vc);
+		}
+		break;
+	case KBD_POST_KEYSYM:
+	{
+		unsigned char type = KTYP(param->value) - 0xf0;
+		if (type == KT_SPEC) {
+			unsigned char val = KVAL(param->value);
+			int on_off = -1;
+
+			switch (val) {
+			case KVAL(K_CAPS):
+				on_off = vc_kbd_led(kbd_table + fg_console,
+						VC_CAPSLOCK);
+				break;
+			case KVAL(K_NUM):
+				on_off = vc_kbd_led(kbd_table + fg_console,
+						VC_NUMLOCK);
+				break;
+			case KVAL(K_HOLD):
+				on_off = vc_kbd_led(kbd_table + fg_console,
+						VC_SCROLLOCK);
+				break;
+			}
+			if (on_off == 1)
+				beep(880);
+			else if (on_off == 0)
+				beep(440);
+		}
+	}
+	case KBD_UNBOUND_KEYCODE:
+	case KBD_UNICODE:
+	case KBD_KEYSYM:
+		/* Unused */
+		break;
+	}
+	return ret;
+}
+
+static struct notifier_block keyboard_notifier_block = {
+	.notifier_call = keyboard_notifier_call,
+};
+
+static int vt_notifier_call(struct notifier_block *blk,
+			    unsigned long code, void *_param)
+{
+	struct vt_notifier_param *param = _param;
+	struct vc_data *vc = param->vc;
+	switch (code) {
+	case VT_ALLOCATE:
+		break;
+	case VT_DEALLOCATE:
+		break;
+	case VT_WRITE:
+	{
+		unsigned char c = param->c;
+		if (vc->vc_num != fg_console)
+			break;
+		switch (c) {
+		case '\b':
+		case 127:
+			if (console_cursor > 0) {
+				console_cursor--;
+				console_buf[console_cursor] = ' ';
+			}
+			break;
+		case '\n':
+		case '\v':
+		case '\f':
+		case '\r':
+			console_newline = 1;
+			break;
+		case '\t':
+			c = ' ';
+			/* Fallthrough */
+		default:
+			if (c < 32)
+				/* Ignore other control sequences */
+				break;
+			if (console_newline) {
+				memset(console_buf, 0, sizeof(console_buf));
+				console_cursor = 0;
+				console_newline = 0;
+			}
+			if (console_cursor == WIDTH)
+				memmove(console_buf, &console_buf[1],
+					(WIDTH-1) * sizeof(*console_buf));
+			else
+				console_cursor++;
+			console_buf[console_cursor-1] = c;
+			break;
+		}
+		if (console_show)
+			braille_write(console_buf);
+		else {
+			vc_maybe_cursor_moved(vc);
+			vc_refresh(vc);
+		}
+		break;
+	}
+	case VT_UPDATE:
+		/* Maybe a VT switch, flush */
+		if (console_show) {
+			if (vc->vc_num != lastVC) {
+				lastVC = vc->vc_num;
+				memset(console_buf, 0, sizeof(console_buf));
+				console_cursor = 0;
+				braille_write(console_buf);
+			}
+		} else {
+			vc_maybe_cursor_moved(vc);
+			vc_refresh(vc);
+		}
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vt_notifier_block = {
+	.notifier_call = vt_notifier_call,
+};
+
+/*
+ * Called from printk.c when console=brl is given
+ */
+
+int braille_register_console(struct console *console, int index,
+		char *console_options, char *braille_options)
+{
+	int ret;
+	if (!console_options)
+		/* Only support VisioBraille for now */
+		console_options = "57600o8";
+	if (braille_co)
+		return -ENODEV;
+	if (console->setup) {
+		ret = console->setup(console, console_options);
+		if (ret != 0)
+			return ret;
+	}
+	console->flags |= CON_ENABLED;
+	console->index = index;
+	braille_co = console;
+	return 0;
+}
+
+int braille_unregister_console(struct console *console)
+{
+	if (braille_co != console)
+		return -EINVAL;
+	braille_co = NULL;
+	return 0;
+}
+
+static int __init braille_init(void)
+{
+	register_keyboard_notifier(&keyboard_notifier_block);
+	register_vt_notifier(&vt_notifier_block);
+	return 0;
+}
+
+console_initcall(braille_init);
diff -urN linux-2.6.24.1-orig/drivers/accessibility/Kconfig linux-2.6.24.1-perso/drivers/accessibility/Kconfig
--- linux-2.6.24.1-orig/drivers/accessibility/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/accessibility/Kconfig	2008-02-20 21:54:26.000000000 +0100
@@ -0,0 +1,22 @@
+menuconfig ACCESSIBILITY
+	bool "Accessibility support"
+	---help---
+	  Enable a submenu where accessibility items may be enabled.
+
+	  If unsure, say N.
+
+if ACCESSIBILITY
+config A11Y_BRAILLE_CONSOLE
+	bool "Console on braille device"
+	depends on SERIAL_CORE_CONSOLE
+	---help---
+	  Enables console output on a braille device connected to a 8250
+	  serial port. For now only the VisioBraille device is supported.
+
+	  To actually enable it, you need to pass option
+	  console=brl,ttyS0
+	  to the kernel. Options are the same as for serial console.
+
+	  If unsure, say N.
+
+endif # ACCESSIBILITY
diff -urN linux-2.6.24.1-orig/drivers/accessibility/Makefile linux-2.6.24.1-perso/drivers/accessibility/Makefile
--- linux-2.6.24.1-orig/drivers/accessibility/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/accessibility/Makefile	2008-02-04 02:42:32.000000000 +0100
@@ -0,0 +1 @@
+obj-$(CONFIG_A11Y_BRAILLE_CONSOLE)		+= braille/braille_console.o
