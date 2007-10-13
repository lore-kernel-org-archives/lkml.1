Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbXJMS1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbXJMS1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXJMS1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:27:30 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:41375 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbXJMS12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:27:28 -0400
Date: Sat, 13 Oct 2007 20:27:22 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: [patch 2/8] m68k: Atari keyboard ACIA driver cleanup
In-Reply-To: <jed4vjrpwk.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0710132027010.15951@anakin>
References: <20071013123123.085686856@mail.of.borg> <20071013123412.672481897@mail.of.borg>
 <jed4vjrpwk.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Andreas Schwab wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> > --- a/arch/m68k/atari/atakeyb.c
> > +++ b/arch/m68k/atari/atakeyb.c
> > @@ -1,5 +1,5 @@
> >  /*
> > - * linux/atari/atakeyb.c
> > + * linux/arch/m68k/atari/atakeyb.c
> 
> Please kill that line.

Done. New version below:

Subject: m68k: Atari keyboard ACIA driver cleanup
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@atrey.karlin.mff.cuni.cz

m68k: Atari keyboard ACIA driver cleanup:
  - removed dead key autorepeat code
  - removed hardcoded initial keymap

Signed-off-by: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c |  104 ++--------------------------------------------
 1 file changed, 6 insertions(+), 98 deletions(-)

--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -1,6 +1,4 @@
 /*
- * linux/atari/atakeyb.c
- *
  * Atari Keyboard driver for 680x0 Linux
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -11,6 +9,9 @@
 /*
  * Atari support by Robert de Vries
  * enhanced by Bjoern Brauel and Roman Hodek
+ *
+ * 2.6 and input cleanup (removed autorepeat stuff) for 2.6.21
+ * 06/07 Michael Schmitz
  */
 
 #include <linux/module.h>
@@ -32,7 +33,6 @@
 #include <asm/atari_joystick.h>
 #include <asm/irq.h>
 
-static void atakeyb_rep(unsigned long ignore);
 extern unsigned int keymap_count;
 
 /* Hook for MIDI serial driver */
@@ -104,25 +104,6 @@ static unsigned long broken_keys[128/(si
  *  - Keypad Left/Right Parenthesis mapped to new K_PPAREN[LR]
  */
 
-static u_short ataplain_map[NR_KEYS] __initdata = {
-	0xf200, 0xf01b, 0xf031, 0xf032, 0xf033, 0xf034, 0xf035, 0xf036,
-	0xf037, 0xf038, 0xf039, 0xf030, 0xf02d, 0xf03d, 0xf008, 0xf009,
-	0xfb71, 0xfb77, 0xfb65, 0xfb72, 0xfb74, 0xfb79, 0xfb75, 0xfb69,
-	0xfb6f, 0xfb70, 0xf05b, 0xf05d, 0xf201, 0xf702, 0xfb61, 0xfb73,
-	0xfb64, 0xfb66, 0xfb67, 0xfb68, 0xfb6a, 0xfb6b, 0xfb6c, 0xf03b,
-	0xf027, 0xf060, 0xf700, 0xf05c, 0xfb7a, 0xfb78, 0xfb63, 0xfb76,
-	0xfb62, 0xfb6e, 0xfb6d, 0xf02c, 0xf02e, 0xf02f, 0xf700, 0xf200,
-	0xf703, 0xf020, 0xf207, 0xf100, 0xf101, 0xf102, 0xf103, 0xf104,
-	0xf105, 0xf106, 0xf107, 0xf108, 0xf109, 0xf200, 0xf200, 0xf114,
-	0xf603, 0xf200, 0xf30b, 0xf601, 0xf200, 0xf602, 0xf30a, 0xf200,
-	0xf600, 0xf200, 0xf115, 0xf07f, 0xf200, 0xf200, 0xf200, 0xf200,
-	0xf200, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200,
-	0xf200, 0xf1ff, 0xf11b, 0xf312, 0xf313, 0xf30d, 0xf30c, 0xf307,
-	0xf308, 0xf309, 0xf304, 0xf305, 0xf306, 0xf301, 0xf302, 0xf303,
-	0xf300, 0xf310, 0xf30e, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200,
-	0xf200, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200, 0xf200
-};
-
 typedef enum kb_state_t {
 	KEYBOARD, AMOUSE, RMOUSE, JOYSTICK, CLOCK, RESYNC
 } KB_STATE_T;
@@ -137,41 +118,6 @@ typedef struct keyboard_state {
 
 KEYBOARD_STATE kb_state;
 
-#define	DEFAULT_KEYB_REP_DELAY	(HZ/4)
-#define	DEFAULT_KEYB_REP_RATE	(HZ/25)
-
-/* These could be settable by some ioctl() in future... */
-static unsigned int key_repeat_delay = DEFAULT_KEYB_REP_DELAY;
-static unsigned int key_repeat_rate = DEFAULT_KEYB_REP_RATE;
-
-static unsigned char rep_scancode;
-static struct timer_list atakeyb_rep_timer = {
-	.function = atakeyb_rep,
-};
-
-static void atakeyb_rep(unsigned long ignore)
-{
-	/* Disable keyboard for the time we call handle_scancode(), else a race
-	 * in the keyboard tty queue may happen */
-	atari_disable_irq(IRQ_MFP_ACIA);
-	del_timer(&atakeyb_rep_timer);
-
-	/* A keyboard int may have come in before we disabled the irq, so
-	 * double-check whether rep_scancode is still != 0 */
-	if (rep_scancode) {
-		init_timer(&atakeyb_rep_timer);
-		atakeyb_rep_timer.expires = jiffies + key_repeat_rate;
-		add_timer(&atakeyb_rep_timer);
-
-		//handle_scancode(rep_scancode, 1);
-		if (atari_input_keyboard_interrupt_hook)
-			atari_input_keyboard_interrupt_hook(rep_scancode, 1);
-	}
-
-	atari_enable_irq(IRQ_MFP_ACIA);
-}
-
-
 /* ++roman: If a keyboard overrun happened, we can't tell in general how much
  * bytes have been lost and in which state of the packet structure we are now.
  * This usually causes keyboards bytes to be interpreted as mouse movements
@@ -209,9 +155,6 @@ repeat:
 		/* ...happens often if interrupts were disabled for too long */
 		printk(KERN_DEBUG "Keyboard overrun\n");
 		scancode = acia.key_data;
-		/* Turn off autorepeating in case a break code has been lost */
-		del_timer(&atakeyb_rep_timer);
-		rep_scancode = 0;
 		if (ikbd_self_test)
 			/* During self test, don't do resyncing, just process the code */
 			goto interpret_scancode;
@@ -281,11 +224,12 @@ repeat:
 					 * make codes instead. Therefore, simply ignore
 					 * break_flag...
 					 */
-					int keyval = plain_map[scancode], keytyp;
+					int keyval, keytyp;
 
 					set_bit(scancode, broken_keys);
 					self_test_last_rcv = jiffies;
-					keyval = plain_map[scancode];
+					/* new Linux scancodes; approx. */
+					keyval = scancode;
 					keytyp = KTYP(keyval) - 0xf0;
 					keyval = KVAL(keyval);
 
@@ -301,19 +245,6 @@ repeat:
 				} else if (test_bit(scancode, broken_keys))
 					break;
 
-#if 0	// FIXME; hangs at boot
-				if (break_flag) {
-					del_timer(&atakeyb_rep_timer);
-					rep_scancode = 0;
-				} else {
-					del_timer(&atakeyb_rep_timer);
-					rep_scancode = scancode;
-					atakeyb_rep_timer.expires = jiffies + key_repeat_delay;
-					add_timer(&atakeyb_rep_timer);
-				}
-#endif
-
-				// handle_scancode(scancode, !break_flag);
 				if (atari_input_keyboard_interrupt_hook)
 					atari_input_keyboard_interrupt_hook((unsigned char)scancode, !break_flag);
 				break;
@@ -639,9 +570,6 @@ int __init atari_keyb_init(void)
 	if (atari_keyb_done)
 		return 0;
 
-	/* setup key map */
-	memcpy(key_maps[0], ataplain_map, sizeof(plain_map));
-
 	kb_state.state = KEYBOARD;
 	kb_state.len = 0;
 
@@ -704,26 +632,6 @@ int __init atari_keyb_init(void)
 	return 0;
 }
 
-int atari_kbdrate(struct kbd_repeat *k)
-{
-	if (k->delay > 0) {
-		/* convert from msec to jiffies */
-		key_repeat_delay = (k->delay * HZ + 500) / 1000;
-		if (key_repeat_delay < 1)
-			key_repeat_delay = 1;
-	}
-	if (k->period > 0) {
-		key_repeat_rate = (k->period * HZ + 500) / 1000;
-		if (key_repeat_rate < 1)
-			key_repeat_rate = 1;
-	}
-
-	k->delay  = key_repeat_delay * 1000 / HZ;
-	k->period = key_repeat_rate  * 1000 / HZ;
-
-	return 0;
-}
-
 int atari_kbd_translate(unsigned char keycode, unsigned char *keycodep, char raw_mode)
 {
 #ifdef CONFIG_MAGIC_SYSRQ


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
