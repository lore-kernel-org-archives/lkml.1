Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXJMMfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXJMMfe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbXJMMfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:35:21 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:59268 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXJMMfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:35:19 -0400
Message-Id: <20071013123412.197946192@mail.of.borg>
References: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:24 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: [patch 1/8] m68k: Atari input drivers cleanup
Content-Disposition: inline; filename=atari-input-memleak-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

m68k: Atari input drivers cleanup:
  - memleak on failed init/register of input devices fixed
  - correct keycodes table (Atari keycodes are almost, but not entirely, equal 
    to Linux keycodes).

Signed-off-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/keyboard/atakbd.c  |  157 ++++++++++++++++++++++++++++++++++++---
 drivers/input/mouse/atarimouse.c |   18 ++--
 2 files changed, 154 insertions(+), 21 deletions(-)

--- a/drivers/input/keyboard/atakbd.c
+++ b/drivers/input/keyboard/atakbd.c
@@ -55,7 +55,140 @@ MODULE_AUTHOR("Michael Schmitz <schmitz@
 MODULE_DESCRIPTION("Atari keyboard driver");
 MODULE_LICENSE("GPL");
 
-static unsigned char atakbd_keycode[0x72];
+/*
+ 0x47: KP_7     71
+ 0x48: KP_8     72
+ 0x49: KP_9     73
+ 0x62: KP_/     98
+ 0x4b: KP_4     75
+ 0x4c: KP_5     76
+ 0x4d: KP_6     77
+ 0x37: KP_*     55
+ 0x4f: KP_1     79
+ 0x50: KP_2     80
+ 0x51: KP_3     81
+ 0x4a: KP_-     74
+ 0x52: KP_0     82
+ 0x53: KP_.     83
+ 0x4e: KP_+     78
+
+ 0x67: Up       103
+ 0x6c: Down     108
+ 0x69: Left     105
+ 0x6a: Right    106
+ */
+
+
+static unsigned char atakbd_keycode[0x72] = {	/* American layout */
+	[0]	 = KEY_GRAVE,
+	[1]	 = KEY_ESC,
+	[2]	 = KEY_1,
+	[3]	 = KEY_2,
+	[4]	 = KEY_3,
+	[5]	 = KEY_4,
+	[6]	 = KEY_5,
+	[7]	 = KEY_6,
+	[8]	 = KEY_7,
+	[9]	 = KEY_8,
+	[10]	 = KEY_9,
+	[11]	 = KEY_0,
+	[12]	 = KEY_MINUS,
+	[13]	 = KEY_EQUAL,
+	[14]	 = KEY_BACKSPACE,
+	[15]	 = KEY_TAB,
+	[16]	 = KEY_Q,
+	[17]	 = KEY_W,
+	[18]	 = KEY_E,
+	[19]	 = KEY_R,
+	[20]	 = KEY_T,
+	[21]	 = KEY_Y,
+	[22]	 = KEY_U,
+	[23]	 = KEY_I,
+	[24]	 = KEY_O,
+	[25]	 = KEY_P,
+	[26]	 = KEY_LEFTBRACE,
+	[27]	 = KEY_RIGHTBRACE,
+	[28]	 = KEY_ENTER,
+	[29]	 = KEY_LEFTCTRL,
+	[30]	 = KEY_A,
+	[31]	 = KEY_S,
+	[32]	 = KEY_D,
+	[33]	 = KEY_F,
+	[34]	 = KEY_G,
+	[35]	 = KEY_H,
+	[36]	 = KEY_J,
+	[37]	 = KEY_K,
+	[38]	 = KEY_L,
+	[39]	 = KEY_SEMICOLON,
+	[40]	 = KEY_APOSTROPHE,
+	[41]	 = KEY_BACKSLASH,	/* FIXME, '#' */
+	[42]	 = KEY_LEFTSHIFT,
+	[43]	 = KEY_GRAVE,		/* FIXME: '~' */
+	[44]	 = KEY_Z,
+	[45]	 = KEY_X,
+	[46]	 = KEY_C,
+	[47]	 = KEY_V,
+	[48]	 = KEY_B,
+	[49]	 = KEY_N,
+	[50]	 = KEY_M,
+	[51]	 = KEY_COMMA,
+	[52]	 = KEY_DOT,
+	[53]	 = KEY_SLASH,
+	[54]	 = KEY_RIGHTSHIFT,
+	[55]	 = KEY_KPASTERISK,
+	[56]	 = KEY_LEFTALT,
+	[57]	 = KEY_SPACE,
+	[58]	 = KEY_CAPSLOCK,
+	[59]	 = KEY_F1,
+	[60]	 = KEY_F2,
+	[61]	 = KEY_F3,
+	[62]	 = KEY_F4,
+	[63]	 = KEY_F5,
+	[64]	 = KEY_F6,
+	[65]	 = KEY_F7,
+	[66]	 = KEY_F8,
+	[67]	 = KEY_F9,
+	[68]	 = KEY_F10,
+	[69]	 = KEY_ESC,
+	[70]	 = KEY_DELETE,
+	[71]	 = KEY_KP7,
+	[72]	 = KEY_KP8,
+	[73]	 = KEY_KP9,
+	[74]	 = KEY_KPMINUS,
+	[75]	 = KEY_KP4,
+	[76]	 = KEY_KP5,
+	[77]	 = KEY_KP6,
+	[78]	 = KEY_KPPLUS,
+	[79]	 = KEY_KP1,
+	[80]	 = KEY_KP2,
+	[81]	 = KEY_KP3,
+	[82]	 = KEY_KP0,
+	[83]	 = KEY_KPDOT,
+	[90]	 = KEY_KPLEFTPAREN,
+	[91]	 = KEY_KPRIGHTPAREN,
+	[92]	 = KEY_KPASTERISK,	/* FIXME */
+	[93]	 = KEY_KPASTERISK,
+	[94]	 = KEY_KPPLUS,
+	[95]	 = KEY_HELP,
+	[96]	 = KEY_BACKSLASH,	/* FIXME: '<' */
+	[97]	 = KEY_KPASTERISK,	/* FIXME */
+	[98]	 = KEY_KPSLASH,
+	[99]	 = KEY_KPLEFTPAREN,
+	[100]	 = KEY_KPRIGHTPAREN,
+	[101]	 = KEY_KPSLASH,
+	[102]	 = KEY_KPASTERISK,
+	[103]	 = KEY_UP,
+	[104]	 = KEY_KPASTERISK,	/* FIXME */
+	[105]	 = KEY_LEFT,
+	[106]	 = KEY_RIGHT,
+	[107]	 = KEY_KPASTERISK,	/* FIXME */
+	[108]	 = KEY_DOWN,
+	[109]	 = KEY_KPASTERISK,	/* FIXME */
+	[110]	 = KEY_KPASTERISK,	/* FIXME */
+	[111]	 = KEY_KPASTERISK,	/* FIXME */
+	[112]	 = KEY_KPASTERISK,	/* FIXME */
+	[113]	 = KEY_KPASTERISK	/* FIXME */
+};
 
 static struct input_dev *atakbd_dev;
 
@@ -86,21 +219,20 @@ static int __init atakbd_init(void)
 {
 	int i;
 
-	if (!ATARIHW_PRESENT(ST_MFP))
+	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(ST_MFP))
 		return -EIO;
 
-	// TODO: request_mem_region if not done in arch code
-
-	if (!(atakbd_dev = input_allocate_device()))
-		return -ENOMEM;
-
 	// need to init core driver if not already done so
 	if (atari_keyb_init())
 		return -ENODEV;
 
+	atakbd_dev = input_allocate_device();
+	if (!atakbd_dev)
+		return -ENOMEM;
+
 	atakbd_dev->name = "Atari Keyboard";
 	atakbd_dev->phys = "atakbd/input0";
-	atakbd_dev->id.bustype = BUS_ATARI;
+	atakbd_dev->id.bustype = BUS_HOST;
 	atakbd_dev->id.vendor = 0x0001;
 	atakbd_dev->id.product = 0x0001;
 	atakbd_dev->id.version = 0x0100;
@@ -111,16 +243,17 @@ static int __init atakbd_init(void)
 	atakbd_dev->keycodemax = ARRAY_SIZE(atakbd_keycode);
 
 	for (i = 1; i < 0x72; i++) {
-		atakbd_keycode[i] = i;
 		set_bit(atakbd_keycode[i], atakbd_dev->keybit);
 	}
 
-	input_register_device(atakbd_dev);
+	/* error check */
+	if (input_register_device(atakbd_dev)) {
+		input_free_device(atakbd_dev);
+		return -ENOMEM;
+	}
 
 	atari_input_keyboard_interrupt_hook = atakbd_interrupt;
 
-	printk(KERN_INFO "input: %s at IKBD ACIA\n", atakbd_dev->name);
-
 	return 0;
 }
 
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -73,14 +73,11 @@ static void atamouse_interrupt(char *buf
 {
 	int buttons, dx, dy;
 
-/*	ikbd_mouse_disable(); */
-
 	buttons = (buf[0] & 1) | ((buf[0] & 2) << 1);
 #ifdef FIXED_ATARI_JOYSTICK
 	buttons |= atari_mouse_buttons & 2;
 	atari_mouse_buttons = buttons;
 #endif
-/*	ikbd_mouse_rel_pos(); */
 
 	/* only relative events get here */
 	dx =  buf[1];
@@ -126,15 +123,16 @@ static int __init atamouse_init(void)
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(ST_MFP))
 		return -ENODEV;
 
-	if (!(atamouse_dev = input_allocate_device()))
-		return -ENOMEM;
-
 	if (!(atari_keyb_init()))
 		return -ENODEV;
 
+	atamouse_dev = input_allocate_device();
+	if (!atamouse_dev)
+		return -ENOMEM;
+
 	atamouse_dev->name = "Atari mouse";
 	atamouse_dev->phys = "atamouse/input0";
-	atamouse_dev->id.bustype = BUS_ATARI;
+	atamouse_dev->id.bustype = BUS_HOST;
 	atamouse_dev->id.vendor = 0x0001;
 	atamouse_dev->id.product = 0x0002;
 	atamouse_dev->id.version = 0x0100;
@@ -145,9 +143,11 @@ static int __init atamouse_init(void)
 	atamouse_dev->open = atamouse_open;
 	atamouse_dev->close = atamouse_close;
 
-	input_register_device(atamouse_dev);
+	if (input_register_device(atamouse_dev)) {
+		input_free_device(atamouse_dev);
+		return -ENOMEM;
+	}
 
-	printk(KERN_INFO "input: %s at keyboard ACIA\n", atamouse_dev->name);
 	return 0;
 }
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

