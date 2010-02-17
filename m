Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0BQQry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:47:54 -0500
Received: from www.tglx.de ([62.245.132.106]:53158 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0BQQrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:47:52 -0500
Message-Id: <20100217163751.030764372@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 16:47:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch] i8253: Convert i8253_lock to raw_spinlock
Content-Disposition: inline; filename=0140.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i8253_lock needs to be a real spinlock in preempt-rt, i.e. it can
not be converted to a sleeping lock.

Convert it to raw_spinlock and fix up all users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 arch/mips/include/asm/i8253.h     |    2 +-
 arch/mips/kernel/i8253.c          |   14 +++++++-------
 arch/x86/include/asm/i8253.h      |    2 +-
 arch/x86/kernel/apm_32.c          |    4 ++--
 arch/x86/kernel/i8253.c           |   14 +++++++-------
 drivers/block/hd.c                |    4 ++--
 drivers/input/gameport/gameport.c |    4 ++--
 drivers/input/joystick/analog.c   |    4 ++--
 drivers/input/misc/pcspkr.c       |    6 +++---
 sound/drivers/pcsp/pcsp.h         |    2 +-
 sound/drivers/pcsp/pcsp_input.c   |    4 ++--
 sound/drivers/pcsp/pcsp_lib.c     |   12 ++++++------
 12 files changed, 36 insertions(+), 36 deletions(-)

Index: linux-2.6-tip/arch/mips/include/asm/i8253.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/i8253.h
+++ linux-2.6-tip/arch/mips/include/asm/i8253.h
@@ -12,7 +12,7 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-extern spinlock_t i8253_lock;
+extern raw_spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
 
Index: linux-2.6-tip/arch/mips/kernel/i8253.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/kernel/i8253.c
+++ linux-2.6-tip/arch/mips/kernel/i8253.c
@@ -15,7 +15,7 @@
 #include <asm/io.h>
 #include <asm/time.h>
 
-DEFINE_SPINLOCK(i8253_lock);
+DEFINE_RAW_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
 /*
@@ -26,7 +26,7 @@ EXPORT_SYMBOL(i8253_lock);
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -55,7 +55,7 @@ static void init_pit_timer(enum clock_ev
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
@@ -65,10 +65,10 @@ static void init_pit_timer(enum clock_ev
  */
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
 	outb(delta >> 8 , PIT_CH0);	/* MSB */
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 
 	return 0;
 }
@@ -137,7 +137,7 @@ static cycle_t pit_read(struct clocksour
 	static int old_count;
 	static u32 old_jifs;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
@@ -183,7 +183,7 @@ static cycle_t pit_read(struct clocksour
 	old_count = count;
 	old_jifs = jifs;
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	count = (LATCH - 1) - count;
 
Index: linux-2.6-tip/arch/x86/include/asm/i8253.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/i8253.h
+++ linux-2.6-tip/arch/x86/include/asm/i8253.h
@@ -6,7 +6,7 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-extern spinlock_t i8253_lock;
+extern raw_spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
 
Index: linux-2.6-tip/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-tip/arch/x86/kernel/apm_32.c
@@ -1224,7 +1224,7 @@ static void reinit_timer(void)
 #ifdef INIT_TIMER_AFTER_SUSPEND
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/* set the clock to HZ */
 	outb_pit(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
@@ -1232,7 +1232,7 @@ static void reinit_timer(void)
 	udelay(10);
 	outb_pit(LATCH >> 8, PIT_CH0);	/* MSB */
 	udelay(10);
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 #endif
 }
 
Index: linux-2.6-tip/arch/x86/kernel/i8253.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/i8253.c
+++ linux-2.6-tip/arch/x86/kernel/i8253.c
@@ -16,7 +16,7 @@
 #include <asm/hpet.h>
 #include <asm/smp.h>
 
-DEFINE_SPINLOCK(i8253_lock);
+DEFINE_RAW_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
 /*
@@ -33,7 +33,7 @@ struct clock_event_device *global_clock_
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -62,7 +62,7 @@ static void init_pit_timer(enum clock_ev
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
@@ -72,10 +72,10 @@ static void init_pit_timer(enum clock_ev
  */
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	outb_pit(delta & 0xff , PIT_CH0);	/* LSB */
 	outb_pit(delta >> 8 , PIT_CH0);		/* MSB */
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 
 	return 0;
 }
@@ -130,7 +130,7 @@ static cycle_t pit_read(struct clocksour
 	int count;
 	u32 jifs;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
@@ -176,7 +176,7 @@ static cycle_t pit_read(struct clocksour
 	old_count = count;
 	old_jifs = jifs;
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	count = (LATCH - 1) - count;
 
Index: linux-2.6-tip/drivers/block/hd.c
===================================================================
--- linux-2.6-tip.orig/drivers/block/hd.c
+++ linux-2.6-tip/drivers/block/hd.c
@@ -165,12 +165,12 @@ unsigned long read_timer(void)
 	unsigned long t, flags;
 	int i;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	t = jiffies * 11932;
 	outb_p(0, 0x43);
 	i = inb_p(0x40);
 	i |= inb(0x40) << 8;
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 	return(t - i);
 }
 #endif
Index: linux-2.6-tip/drivers/input/gameport/gameport.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/gameport/gameport.c
+++ linux-2.6-tip/drivers/input/gameport/gameport.c
@@ -58,11 +58,11 @@ static unsigned int get_time_pit(void)
 	unsigned long flags;
 	unsigned int count;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	outb_p(0x00, 0x43);
 	count = inb_p(0x40);
 	count |= inb_p(0x40) << 8;
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return count;
 }
Index: linux-2.6-tip/drivers/input/joystick/analog.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/joystick/analog.c
+++ linux-2.6-tip/drivers/input/joystick/analog.c
@@ -146,11 +146,11 @@ static unsigned int get_time_pit(void)
         unsigned long flags;
         unsigned int count;
 
-        spin_lock_irqsave(&i8253_lock, flags);
+        raw_spin_lock_irqsave(&i8253_lock, flags);
         outb_p(0x00, 0x43);
         count = inb_p(0x40);
         count |= inb_p(0x40) << 8;
-        spin_unlock_irqrestore(&i8253_lock, flags);
+        raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
         return count;
 }
Index: linux-2.6-tip/drivers/input/misc/pcspkr.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/misc/pcspkr.c
+++ linux-2.6-tip/drivers/input/misc/pcspkr.c
@@ -30,7 +30,7 @@ MODULE_ALIAS("platform:pcspkr");
 #include <asm/i8253.h>
 #else
 #include <asm/8253pit.h>
-static DEFINE_SPINLOCK(i8253_lock);
+static DEFINE_RAW_SPINLOCK(i8253_lock);
 #endif
 
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
@@ -50,7 +50,7 @@ static int pcspkr_event(struct input_dev
 	if (value > 20 && value < 32767)
 		count = PIT_TICK_RATE / value;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* set command for counter 2, 2 byte write */
@@ -65,7 +65,7 @@ static int pcspkr_event(struct input_dev
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return 0;
 }
Index: linux-2.6-tip/sound/drivers/pcsp/pcsp.h
===================================================================
--- linux-2.6-tip.orig/sound/drivers/pcsp/pcsp.h
+++ linux-2.6-tip/sound/drivers/pcsp/pcsp.h
@@ -16,7 +16,7 @@
 #include <asm/i8253.h>
 #else
 #include <asm/8253pit.h>
-static DEFINE_SPINLOCK(i8253_lock);
+static DEFINE_RAW_SPINLOCK(i8253_lock);
 #endif
 
 #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */
Index: linux-2.6-tip/sound/drivers/pcsp/pcsp_input.c
===================================================================
--- linux-2.6-tip.orig/sound/drivers/pcsp/pcsp_input.c
+++ linux-2.6-tip/sound/drivers/pcsp/pcsp_input.c
@@ -21,7 +21,7 @@ static void pcspkr_do_sound(unsigned int
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* set command for counter 2, 2 byte write */
@@ -36,7 +36,7 @@ static void pcspkr_do_sound(unsigned int
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
 void pcspkr_stop_sound(void)
Index: linux-2.6-tip/sound/drivers/pcsp/pcsp_lib.c
===================================================================
--- linux-2.6-tip.orig/sound/drivers/pcsp/pcsp_lib.c
+++ linux-2.6-tip/sound/drivers/pcsp/pcsp_lib.c
@@ -65,7 +65,7 @@ static u64 pcsp_timer_update(struct snd_
 	timer_cnt = val * CUR_DIV() / 256;
 
 	if (timer_cnt && chip->enable) {
-		spin_lock_irqsave(&i8253_lock, flags);
+		raw_spin_lock_irqsave(&i8253_lock, flags);
 		if (!nforce_wa) {
 			outb_p(chip->val61, 0x61);
 			outb_p(timer_cnt, 0x42);
@@ -74,7 +74,7 @@ static u64 pcsp_timer_update(struct snd_
 			outb(chip->val61 ^ 2, 0x61);
 			chip->thalf = 1;
 		}
-		spin_unlock_irqrestore(&i8253_lock, flags);
+		raw_spin_unlock_irqrestore(&i8253_lock, flags);
 	}
 
 	chip->ns_rem = PCSP_PERIOD_NS();
@@ -158,10 +158,10 @@ static int pcsp_start_playing(struct snd
 		return -EIO;
 	}
 
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	chip->val61 = inb(0x61) | 0x03;
 	outb_p(0x92, 0x43);	/* binary, mode 1, LSB only, ch 2 */
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 	atomic_set(&chip->timer_active, 1);
 	chip->thalf = 0;
 
@@ -178,11 +178,11 @@ static void pcsp_stop_playing(struct snd
 		return;
 
 	atomic_set(&chip->timer_active, 0);
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	/* restore the timer */
 	outb_p(0xb6, 0x43);	/* binary, mode 3, LSB/MSB, ch 2 */
 	outb(chip->val61 & 0xFC, 0x61);
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*


