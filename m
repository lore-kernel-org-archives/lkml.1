Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZAKTQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZAKTQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZAKTQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:16:38 -0500
Received: from louise.pinerecords.com ([213.168.176.16]:45189 "EHLO
	louise.pinerecords.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZAKTQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:16:37 -0500
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jan 2009 14:16:36 EST
Date: Sun, 11 Jan 2009 20:05:03 +0100
From: Tomas Szepe <szepe@pinerecords.com>
To: arodland@noln.com, jbglaw@lug-owl.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Morse code panics for 2.6.29-rc1
Message-ID: <20090111190503.GA20861@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bumped into this silly thing (morse code panics) by accident after
6 years or so, and couldn't resist updating it for a recent kernel.
So, here goes, enjoy.

Patch against 2.6.29-rc1.

-- 
Tomas Szepe <szepe@pinerecords.com>


diff -urN a/drivers/char/keyboard.c b/drivers/char/keyboard.c
--- a/drivers/char/keyboard.c	2008-12-25 00:26:37.000000000 +0100
+++ b/drivers/char/keyboard.c	2009-01-11 09:17:02.021500006 +0100
@@ -266,6 +266,27 @@
 EXPORT_SYMBOL(kd_mksound);
 
 /*
+ * Turn all possible leds on or off.
+ */
+void kd_set_led_all(int state)
+{
+	struct list_head *node;
+	state = state ? 1 : 0;
+
+	list_for_each(node, &kbd_handler.h_list) {
+		struct input_handle *handle = to_handle_h(node);
+		if (test_bit(EV_LED, handle->dev->evbit)) {
+			int led;
+			for (led = 0; led <= LED_MAX; led++) {
+				if (test_bit(led, handle->dev->ledbit))
+					input_event(handle->dev, EV_LED, led,
+						state);
+			}
+		}
+	}
+}
+
+/*
  * Setting the keyboard rate.
  */
 
diff -urN a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c	2008-12-25 00:26:37.000000000 +0100
+++ b/drivers/input/serio/i8042.c	2009-01-11 09:35:26.538539743 +0100
@@ -59,10 +59,6 @@
 module_param_named(noloop, i8042_noloop, bool, 0);
 MODULE_PARM_DESC(noloop, "Disable the AUX Loopback command while probing for the AUX port");
 
-static unsigned int i8042_blink_frequency = 500;
-module_param_named(panicblink, i8042_blink_frequency, uint, 0600);
-MODULE_PARM_DESC(panicblink, "Frequency with which keyboard LEDs should blink when kernel panics");
-
 #ifdef CONFIG_X86
 static unsigned int i8042_dritek;
 module_param_named(dritek, i8042_dritek, bool, 0);
@@ -838,53 +834,6 @@
 		printk(KERN_WARNING "i8042.c: Can't restore CTR.\n");
 }
 
-
-/*
- * i8042_panic_blink() will flash the keyboard LEDs and is called when
- * kernel panics. Flashing LEDs is useful for users running X who may
- * not see the console and will help distingushing panics from "real"
- * lockups.
- *
- * Note that DELAY has a limit of 10ms so we will not get stuck here
- * waiting for KBC to free up even if KBD interrupt is off
- */
-
-#define DELAY do { mdelay(1); if (++delay > 10) return delay; } while(0)
-
-static long i8042_panic_blink(long count)
-{
-	long delay = 0;
-	static long last_blink;
-	static char led;
-
-	/*
-	 * We expect frequency to be about 1/2s. KDB uses about 1s.
-	 * Make sure they are different.
-	 */
-	if (!i8042_blink_frequency)
-		return 0;
-	if (count - last_blink < i8042_blink_frequency)
-		return 0;
-
-	led ^= 0x01 | 0x04;
-	while (i8042_read_status() & I8042_STR_IBF)
-		DELAY;
-	dbg("%02x -> i8042 (panic blink)", 0xed);
-	i8042_suppress_kbd_ack = 2;
-	i8042_write_data(0xed); /* set leds */
-	DELAY;
-	while (i8042_read_status() & I8042_STR_IBF)
-		DELAY;
-	DELAY;
-	dbg("%02x -> i8042 (panic blink)", led);
-	i8042_write_data(led);
-	DELAY;
-	last_blink = count;
-	return delay;
-}
-
-#undef DELAY
-
 #ifdef CONFIG_X86
 static void i8042_dritek_enable(void)
 {
@@ -1266,8 +1215,6 @@
 	if (err)
 		goto err_free_device;
 
-	panic_blink = i8042_panic_blink;
-
 	return 0;
 
  err_free_device:
@@ -1285,8 +1232,6 @@
 	platform_device_unregister(i8042_platform_device);
 	platform_driver_unregister(&i8042_driver);
 	i8042_platform_exit();
-
-	panic_blink = NULL;
 }
 
 module_init(i8042_init);
diff -urN a/include/linux/kernel.h b/include/linux/kernel.h
--- a/include/linux/kernel.h	2009-01-11 09:48:24.998469846 +0100
+++ b/include/linux/kernel.h	2009-01-11 09:34:15.220568324 +0100
@@ -157,7 +157,6 @@
 #endif
 
 extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
diff -urN a/include/linux/morseops.h b/include/linux/morseops.h
--- a/include/linux/morseops.h	1970-01-01 01:00:00.000000000 +0100
+++ b/include/linux/morseops.h	2009-01-11 09:17:02.021500006 +0100
@@ -0,0 +1,23 @@
+/*  Yes, it's morse code ops indeed.  */
+
+#ifndef _LINUX_MORSEOPS_H
+#define _LINUX_MORSEOPS_H
+
+#include <linux/autoconf.h>
+
+#ifdef CONFIG_MORSE_PANICS
+
+extern const unsigned char morsetable[];	/* in kernel/morse.c */
+void panic_morseblink(char *buf);		/* in kernel/morse.c */
+
+static inline unsigned char tomorse(char c) {
+	if (c >= 'a' && c <= 'z')
+		c -= 'a' - 'A';
+	return (c >= '"' && c <= '_') ? morsetable[c - '"'] : 0;
+}
+
+#else	/* CONFIG_MORSE_PANICS */
+# define panic_morseblink(buf)		do { } while (0)
+#endif	/* CONFIG_MORSE_PANICS */
+
+#endif	/* _LINUX_MORSEOPS_H */
diff -urN a/include/linux/vt_kern.h b/include/linux/vt_kern.h
--- a/include/linux/vt_kern.h	2008-12-25 00:26:37.000000000 +0100
+++ b/include/linux/vt_kern.h	2009-01-11 09:17:02.021500006 +0100
@@ -26,7 +26,10 @@
 #define BROKEN_GRAPHICS_PROGRAMS 1
 #endif
 
+/* keyboard.c */
+
 extern void kd_mksound(unsigned int hz, unsigned int ticks);
+extern void kd_set_led_all(int state);
 extern int kbd_rate(struct kbd_repeat *rep);
 extern int fg_console, last_console, want_console;
 
diff -urN a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig	2009-01-11 09:48:25.058469650 +0100
+++ b/init/Kconfig	2009-01-11 09:17:02.021500006 +0100
@@ -860,6 +860,21 @@
 
 source "arch/Kconfig"
 
+config MORSE_PANICS
+	bool "Morse code panics"
+	depends on VT
+	help
+	  When enabled, this code will make a panicking kernel cry for
+	  help in morse code, signalling on the leds of a possibly attached
+	  keyboard and/or a bleeper.  You can enable/disable your morse
+	  output devices of choice using the "panicmorse" kernel boot
+	  parameter.  Currently, "panicmorse=0" will disable the signalling
+	  completely, "panicmorse=1" (the default) will only blink the leds,
+	  "panicmorse=2" will only beep, and "panicmorse=3" will do both.
+
+	  If unsure, say Y.  This feature is very helpful to those who
+	  spend most of their time in X.
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT
diff -urN a/kernel/Makefile b/kernel/Makefile
--- a/kernel/Makefile	2009-01-11 09:48:25.068467569 +0100
+++ b/kernel/Makefile	2009-01-11 09:18:14.378515494 +0100
@@ -62,6 +62,7 @@
 obj-$(CONFIG_PID_NS) += pid_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
+obj-$(CONFIG_MORSE_PANICS) += morse.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
diff -urN a/kernel/morse.c b/kernel/morse.c
--- a/kernel/morse.c	1970-01-01 01:00:00.000000000 +0100
+++ b/kernel/morse.c	2009-01-11 09:39:05.692604924 +0100
@@ -0,0 +1,234 @@
+/*
+ *  kernel/morse.c
+ *
+ *  Copyright (C) 2002 Andrew Rodland <arodland@noln.com>
+ *  Copyright (C) 2003, 2009 Tomas Szepe <szepe@pinerecords.com>
+ *
+ *  Tell the user who may be running in X and not see the console that
+ *  we have panic'd.  This is to distingush panics from "real lockups."
+ *  Could in theory send the panic message as morse, but that is left
+ *  as an exercise for the reader.
+ *
+ *  And now it's done! LED and speaker morse code by Andrew Rodland
+ *  <arodland@noln.com>, with improvements based on suggestions from
+ *  linux@horizon.com and a host of others.
+ *
+ *  Initial 2.5 morsepanics port and cleanup by
+ *  Tomas Szepe <szepe@pinerecords.com>, January 2003.
+ *
+ *  Cryptic morse code table replaced with meticulous macrowork by
+ *  Jan-Benedict Glaw <jbglaw@lug-owl.de>, February 2003.
+ *
+ *  Updated for 2.6.29-rc1 by
+ *  Tomas Szepe <szepe@pinerecords.com>, January 2009.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/morseops.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/vt_kern.h>
+
+#define DITLEN			(HZ / 5)
+#define DAHLEN			(3 * DITLEN)
+#define SPACELEN		(7 * DITLEN)
+#define FREQ			844
+
+#define MORSE_OUTPUT_BLINK	(1 << 0)
+#define MORSE_OUTPUT_BLEEP	(1 << 1)
+#define MORSE_OUTPUT_ESTRADE	(MORSE_OUTPUT_BLINK | MORSE_OUTPUT_BLEEP)
+
+static int morse_setting = MORSE_OUTPUT_BLINK;
+
+/*  The following macros are used to make up the morse code table.  */
+
+#define	IS_DASH(letter, shift)					\
+	((letter) == '-' ? (1 << (shift)) : (0 << (shift)))
+#define	MORSE(shift, b1, b2, b3, b4, b5, b6)			\
+	(1 << (shift)	| IS_DASH((b1), 5) | IS_DASH((b2), 4)	\
+			| IS_DASH((b3), 3) | IS_DASH((b4), 2)	\
+			| IS_DASH((b5), 1) | IS_DASH((b6), 0))
+#define	MORSE0(letter)						\
+		(0)
+#define	MORSE1(letter, b1)					\
+		MORSE(1, '.', '.', '.', '.', '.', (b1))
+#define	MORSE2(letter, b1, b2)					\
+		MORSE(2, '.', '.', '.', '.', (b1), (b2))
+#define	MORSE3(letter, b1, b2, b3)				\
+		MORSE(3, '.', '.', '.', (b1), (b2), (b3))
+#define	MORSE4(letter, b1, b2, b3, b4)				\
+		MORSE(4, '.', '.', (b1), (b1), (b3), (b4))
+#define	MORSE5(letter, b1, b2, b3, b4, b5)			\
+		MORSE(5, '.', (b1), (b2), (b3), (b4), (b5))
+#define	MORSE6(letter, b1, b2, b3, b4, b5, b6)			\
+		MORSE(6, (b1), (b2), (b3), (b4), (b5), (b6))
+
+/*  Do not shuffle things about in here, the order matters.  */
+const unsigned char morsetable[] = {
+
+	/*  0122, 0, 0310, 0, 0, 0163,				"#$%&'  */
+	MORSE6('"', '-', '.', '-', '-', '.', '-'),
+	MORSE0('#'),
+	0310,		/*  '$': FIXME  */
+	MORSE0('%'),
+	MORSE0('&'),
+	MORSE6('\'', '-', '.', '-', '.', '-', '-'),
+
+	/*  055, 0155, 0, 0, 0163, 0141, 0152, 0051,		()*+,-./  */
+	MORSE5('(', '-', '.', '-', '-', '.'),
+	MORSE6(')', '-', '.', '-', '-', '.', '-'),
+	MORSE0('*'),
+
+	/*  http://www.vennfuessler.de/service/technik/morsen.html  */
+	MORSE5('+', '.', '-', '.', '-', '.'),
+
+	MORSE6(',', '-', '-', '.', '.', '.', '-'),
+	MORSE6('-', '-', '.', '.', '.', '.', '-'),
+	MORSE6('.', '.', '-', '.', '-', '.', '-'),
+	MORSE5('/', '-', '.', '.', '-', '.'),
+
+	/*  077, 076, 074, 070, 060, 040, 041, 043, 047, 057,	0-9  */
+	MORSE5('0', '-', '-', '-', '-', '-'),
+	MORSE5('1', '.', '-', '-', '-', '-'),
+	MORSE5('2', '.', '.', '-', '-', '-'),
+	MORSE5('3', '.', '.', '.', '-', '-'),
+	MORSE5('4', '.', '.', '.', '.', '-'),
+	MORSE5('5', '.', '.', '.', '.', '.'),
+	MORSE5('6', '-', '.', '.', '.', '.'),
+	MORSE5('7', '-', '-', '.', '.', '.'),
+	MORSE5('8', '-', '-', '-', '.', '.'),
+	MORSE5('9', '-', '-', '-', '-', '.'),
+
+	/*  0107, 0125, 0, 0061, 0, 0114, 0,			:;<=>?@  */
+	MORSE6(':', '-', '-', '-', '.', '.', '.'),
+	MORSE6(';', '-', '.', '-', '.', '-', '.'),
+	MORSE0('<'),
+	MORSE5('=', '-', '.', '.', '.', '-'),
+	MORSE0('>'),
+	MORSE6('?', '.', '.', '-', '-', '.', '.'),
+	MORSE0('@'),
+
+	/*  006, 021, 025, 011, 002, 024, 013, 020, 004,	A-I  */
+	MORSE2('A', '.', '-'),
+	MORSE4('B', '-', '.', '.', '.'),
+	MORSE4('C', '-', '.', '-', '.'),
+	MORSE3('D', '-', '.', '.'),
+	MORSE1('E', '.'),
+	MORSE4('F', '.', '.', '-', '.'),
+	MORSE3('G', '-', '-', '.'),
+	MORSE4('H', '.', '.', '.', '.'),
+	MORSE2('I', '.', '.'),
+
+	/*  036, 015, 022, 007, 005, 017, 026, 033, 012,	J-R  */
+	MORSE4('J', '.', '-', '-', '-'),
+	MORSE3('K', '-', '.', '-'),
+	MORSE4('L', '.', '-', '.', '.'),
+	MORSE2('M', '-', '-'),
+	MORSE2('N', '-', '.'),
+	MORSE3('O', '-', '-', '-'),
+	MORSE4('P', '.', '-', '-', '.'),
+	MORSE4('Q', '-', '-', '.', '-'),
+	MORSE3('R', '.', '-', '.'),
+
+	/*  010, 003, 014, 030, 016, 031, 035, 023,		S-Z  */
+	MORSE3('S', '.', '.', '.'),
+	MORSE1('T', '-'),
+	MORSE3('U', '.', '.', '-'),
+	MORSE4('V', '.', '.', '.', '-'),
+	MORSE3('W', '.', '-', '-'),
+	MORSE4('X', '-', '.', '.', '-'),
+	MORSE4('Y', '-', '.', '-', '-'),
+	MORSE4('Z', '-', '-', '.', '.'),
+
+	/*  0, 0, 0, 0, 0154					[\]^_  */
+	MORSE0('['),
+	MORSE0('\\'),
+	MORSE0(']'),
+	MORSE0('^'),
+	MORSE6('_', '.', '-', '-', '-', '.', '-'),
+};
+
+void panic_morseblink(char *buf)
+{ 
+	static unsigned long next_jiffie = 0;
+	static char *bufpos = 0;
+	static unsigned char morse = 0;
+	static char state = 1;
+	
+	if (!(morse_setting & MORSE_OUTPUT_ESTRADE))
+		return;
+
+	if (!buf)
+		buf = "Uh oh, we lost the panic msg.";
+
+	/*  Waiting for something?  */
+	if (bufpos && time_after(next_jiffie, jiffies))
+		return;
+
+	if (state) {	/*  Coming off of a blink.  */
+		if (morse_setting & MORSE_OUTPUT_BLINK)
+			kd_set_led_all(0);
+
+		state = 0;
+
+		if (morse > 1) {
+			/*  Not done yet, just a one-dit pause.  */
+			next_jiffie = jiffies + DITLEN;
+		} else {
+			/*  Get a new char, figure out how much space.  */
+
+			/*  First time through.  */
+			if (!bufpos)
+				bufpos = buf;
+
+			if (!*bufpos) {
+				/*  Repeating.  */
+				bufpos = buf;
+				next_jiffie = jiffies + SPACELEN;
+			} else {
+				/*  Inter-letter space.  */
+				next_jiffie = jiffies + DAHLEN; 
+			}
+
+			if (!(morse = tomorse(*bufpos))) {
+				next_jiffie = jiffies + SPACELEN;
+				state = 1;	/*  And get us back here.  */
+			}
+			bufpos++;
+		}
+	} else {
+		/*  Starting a new blink.  We have a valid code in morse.  */
+		int len;
+
+		len = (morse & 0x01) ? DAHLEN : DITLEN;
+
+		if (morse_setting & MORSE_OUTPUT_BLEEP)
+			kd_mksound(FREQ, len);
+
+		if (morse_setting & MORSE_OUTPUT_BLINK)
+			kd_set_led_all(1);
+
+		next_jiffie = jiffies + len;
+
+		state = 1;
+		morse >>= 1;
+	}
+}
+
+static int __init panicmorse_setup(char *str)
+{
+	int par;
+
+	if (get_option(&str, &par)) 
+		morse_setting = par;
+
+	return 1;
+}
+
+/*  "panicmorse=0" disables the blinking as it caused problems with
+ *  certain console switches.
+ *
+ *  "panicmorse | 1" does the show using kbd leds.
+ *  "panicmorse | 2" throws in bleeping via kd_mksound().
+ */
+__setup("panicmorse=", panicmorse_setup);
diff -urN a/kernel/panic.c b/kernel/panic.c
--- a/kernel/panic.c	2009-01-11 09:48:25.088467527 +0100
+++ b/kernel/panic.c	2009-01-11 09:47:59.108672887 +0100
@@ -22,6 +22,7 @@
 #include <linux/random.h>
 #include <linux/kallsyms.h>
 #include <linux/dmi.h>
+#include <linux/morseops.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -35,15 +36,6 @@
 
 EXPORT_SYMBOL(panic_notifier_list);
 
-static long no_blink(long time)
-{
-	return 0;
-}
-
-/* Returns how long it waited in ms */
-long (*panic_blink)(long time);
-EXPORT_SYMBOL(panic_blink);
-
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
@@ -94,9 +86,6 @@
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	if (!panic_blink)
-		panic_blink = no_blink;
-
 	if (panic_timeout > 0) {
 		/*
 	 	 * Delay timeout seconds before rebooting the machine. 
@@ -105,7 +94,7 @@
 		printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
 		for (i = 0; i < panic_timeout*1000; ) {
 			touch_nmi_watchdog();
-			i += panic_blink(i);
+			panic_morseblink(buf);
 			mdelay(1);
 			i++;
 		}
@@ -127,11 +116,10 @@
 	disabled_wait(caller);
 #endif
 	local_irq_enable();
-	for (i = 0;;) {
+	for (;;) {
 		touch_softlockup_watchdog();
-		i += panic_blink(i);
+		panic_morseblink(buf);
 		mdelay(1);
-		i++;
 	}
 }
 
