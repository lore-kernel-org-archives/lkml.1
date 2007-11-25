Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXKYKKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXKYKKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 05:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXKYKKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 05:10:46 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:62637 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXKYKKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 05:10:45 -0500
Date: Sun, 25 Nov 2007 11:10:38 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: zippel@linux-m68k.org, schmitz@debian.org, geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071125095858.32254.98071.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] include/asm-m68k: Remove atari_joystick.h
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove include/asm-m68k/atari_joystick.h and clean up.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Not compiled, but should be trivial.
(if FIXED_ATARI_JOYSTICK is defined somehow, please tell how)

 b/arch/m68k/atari/atakeyb.c        |    8 --------
 b/arch/m68k/atari/atari_ksyms.c    |    1 -
 b/drivers/input/mouse/atarimouse.c |   10 ----------
 include/asm-m68k/atari_joystick.h  |   22 ----------------------
 4 files changed, 41 deletions(-)


diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 880add1..11a622b 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -30,7 +30,6 @@
 #include <asm/atariints.h>
 #include <asm/atarihw.h>
 #include <asm/atarikb.h>
-#include <asm/atari_joystick.h>
 #include <asm/irq.h>
 
 extern unsigned int keymap_count;
@@ -272,9 +271,6 @@ repeat:
 		case JOYSTICK:
 			kb_state.buf[1] = scancode;
 			kb_state.state = KEYBOARD;
-#ifdef FIXED_ATARI_JOYSTICK
-			atari_joystick_interrupt(kb_state.buf);
-#endif
 			break;
 
 		case CLOCK:
@@ -623,10 +619,6 @@ int __init atari_keyb_init(void)
 	ikbd_mouse_disable();
 	ikbd_joystick_disable();
 
-#ifdef FIXED_ATARI_JOYSTICK
-	atari_joystick_init();
-#endif
-
 	// flag init done
 	atari_keyb_done = 1;
 	return 0;
diff --git a/arch/m68k/atari/atari_ksyms.c b/arch/m68k/atari/atari_ksyms.c
index a047571..c6113b4 100644
--- a/arch/m68k/atari/atari_ksyms.c
+++ b/arch/m68k/atari/atari_ksyms.c
@@ -5,7 +5,6 @@
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 #include <asm/atarikb.h>
-#include <asm/atari_joystick.h>
 #include <asm/atari_stdma.h>
 #include <asm/atari_stram.h>
 
diff --git a/drivers/input/mouse/atarimouse.c b/drivers/input/mouse/atarimouse.c
index 98a3561..b8de36f 100644
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -62,9 +62,6 @@ static int mouse_threshold[2] = {2,2};
 #ifdef __MODULE__
 MODULE_PARM(mouse_threshold, "2i");
 #endif
-#ifdef FIXED_ATARI_JOYSTICK
-extern int atari_mouse_buttons;
-#endif
 static int atamouse_used = 0;
 
 static struct input_dev *atamouse_dev;
@@ -74,10 +71,6 @@ static void atamouse_interrupt(char *buf)
 	int buttons, dx, dy;
 
 	buttons = (buf[0] & 1) | ((buf[0] & 2) << 1);
-#ifdef FIXED_ATARI_JOYSTICK
-	buttons |= atari_mouse_buttons & 2;
-	atari_mouse_buttons = buttons;
-#endif
 
 	/* only relative events get here */
 	dx =  buf[1];
@@ -100,9 +93,6 @@ static int atamouse_open(struct input_dev *dev)
 	if (atamouse_used++)
 		return 0;
 
-#ifdef FIXED_ATARI_JOYSTICK
-	atari_mouse_buttons = 0;
-#endif
 	ikbd_mouse_y0_top();
 	ikbd_mouse_thresh(mouse_threshold[0], mouse_threshold[1]);
 	ikbd_mouse_rel_pos();
diff --git a/include/asm-m68k/atari_joystick.h b/include/asm-m68k/atari_joystick.h
deleted file mode 100644
index 93be7da..0000000
--- a/include/asm-m68k/atari_joystick.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _LINUX_ATARI_JOYSTICK_H
-#define _LINUX_ATARI_JOYSTICK_H
-
-/*
- * linux/include/linux/atari_joystick.h
- * header file for Atari Joystick driver
- * by Robert de Vries (robert@and.nl) on 19Jul93
- */
-
-void atari_joystick_interrupt(char*);
-int atari_joystick_init(void);
-extern int atari_mouse_buttons;
-
-struct joystick_status {
-	char		fire;
-	char		dir;
-	int		ready;
-	int		active;
-	wait_queue_head_t wait;
-};
-
-#endif
