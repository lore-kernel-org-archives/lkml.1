Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXGBM4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXGBM4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbXGBM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:56:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:46540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbXGBM4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:56:24 -0400
Date: Mon, 2 Jul 2007 14:56:18 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Indan Zupancic <indan@nul.nu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070702125618.GA18987@suse.de>
Mail-Followup-To: Andi Kleen <ak@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Indan Zupancic <indan@nul.nu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <200707021439.27357.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Andi Kleen <ak@suse.de> [2007-07-02 14:39]:
> 
> > Another option would be for it not use panic_blink. Do your kexec
> > kernels have atkbd support enabled? You could write an new "blink"
> > input handler that would latch to keyboards supporting leds and blink
> > by sending EV_LED events.
> 
> Yes that would be probably a better implementation. Also hook something
> for USB keyboards. iirc Bernhard Walle (cc'ed) was looking at that.

The problem is that most distributions use USB as module (in initrd,
or later). If you're able to load modules, you're also able to run a
userspace programs that blinks. That's the way I implemented it in
SUSE now. In my tests it takes about < 5 seconds from the sysrq-c to
the time the first blink. That's ok IMO.

And if a person compiles his kernel manually, he doesn't need keyboard
LED blinking for kdump because he can look at the HDD LED to see what
happens (or serial console). ... :)

I don't know if it's worth to apply a patch that uses the keyboard
interface in the kernel, because there are several small changes
necessary (see patch, that's what my thought was).


Thanks,
   Bernhard

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=add_setledstate_global

---
 drivers/char/keyboard.c  |    7 +++++++
 include/linux/keyboard.h |    7 +++++++
 2 files changed, 14 insertions(+)

Index: linux-2.6.21.1/drivers/char/keyboard.c
===================================================================
--- linux-2.6.21.1.orig/drivers/char/keyboard.c
+++ linux-2.6.21.1/drivers/char/keyboard.c
@@ -956,6 +956,13 @@ void setledstate(struct kbd_struct *kbd,
 	set_leds();
 }
 
+void setledstate_fgconsole(unsigned int led)
+{
+	struct kbd_struct *kbd = kbd_table + fg_console;
+	setledstate(kbd, led);
+}
+EXPORT_SYMBOL_GPL(setledstate_fgconsole);
+
 static inline unsigned char getleds(void)
 {
 	struct kbd_struct *kbd = kbd_table + fg_console;
Index: linux-2.6.21.1/include/linux/keyboard.h
===================================================================
--- linux-2.6.21.1.orig/include/linux/keyboard.h
+++ linux-2.6.21.1/include/linux/keyboard.h
@@ -441,4 +441,11 @@ extern unsigned short plain_map[NR_KEYS]
 #define NR_BRL		9
 
 #define MAX_DIACR	256
+
+
+
+#ifdef __KERNEL__
+void setledstate_fgconsole(unsigned int led);
+#endif
+
 #endif

--4Ckj6UjgE2iN1+kY--
