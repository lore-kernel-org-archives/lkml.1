Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0CBJkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:40:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:47327 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0CBJkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:40:09 -0500
Date: Tue, 2 Mar 2010 09:39:32 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tiwai@suse.de, jens.axboe@oracle.com, dmitry.torokhov@gmail.com,
       ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
       tiwai@suse.de, jens.axboe@oracle.com
In-Reply-To: <20100217163751.030764372@linutronix.de>
References: <20100217163751.030764372@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] i8253: Convert i8253_lock to raw_spinlock
Message-ID: <tip-ced918eb748ce30b3aace549fd17540e40ffdca0@git.kernel.org>
Git-Commit-ID: ced918eb748ce30b3aace549fd17540e40ffdca0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Mar 2010 09:39:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ced918eb748ce30b3aace549fd17540e40ffdca0
Gitweb:     http://git.kernel.org/tip/ced918eb748ce30b3aace549fd17540e40ffdca0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 17 Feb 2010 16:47:10 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 2 Mar 2010 10:28:38 +0100

i8253: Convert i8253_lock to raw_spinlock

i8253_lock needs to be a real spinlock in preempt-rt, i.e. it can
not be converted to a sleeping lock.

Convert it to raw_spinlock and fix up all users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <20100217163751.030764372@linutronix.de>

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

diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
index 032ca73..48bb823 100644
--- a/arch/mips/include/asm/i8253.h
+++ b/arch/mips/include/asm/i8253.h
@@ -12,7 +12,7 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-extern spinlock_t i8253_lock;
+extern raw_spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
 
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index ed5c441..9479406 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
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
@@ -55,7 +55,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
@@ -65,10 +65,10 @@ static void init_pit_timer(enum clock_event_mode mode,
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
@@ -137,7 +137,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	static int old_count;
 	static u32 old_jifs;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
@@ -183,7 +183,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	old_count = count;
 	old_jifs = jifs;
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	count = (LATCH - 1) - count;
 
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index 1edbf89..fc1f579 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -6,7 +6,7 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-extern spinlock_t i8253_lock;
+extern raw_spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 031aa88..c4f9182 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
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
 
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 23c1679..2dfd315 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -16,7 +16,7 @@
 #include <asm/hpet.h>
 #include <asm/smp.h>
 
-DEFINE_SPINLOCK(i8253_lock);
+DEFINE_RAW_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
 /*
@@ -33,7 +33,7 @@ struct clock_event_device *global_clock_event;
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -62,7 +62,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
@@ -72,10 +72,10 @@ static void init_pit_timer(enum clock_event_mode mode,
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
@@ -130,7 +130,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	int count;
 	u32 jifs;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
@@ -176,7 +176,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	old_count = count;
 	old_jifs = jifs;
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	count = (LATCH - 1) - count;
 
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 5116c65..b9868ad 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
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
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 7e18bcf..46239e4 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -59,11 +59,11 @@ static unsigned int get_time_pit(void)
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
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 1c0b529..4afe0a3 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
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
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index ea4e1fd..f080dd3 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -30,7 +30,7 @@ MODULE_ALIAS("platform:pcspkr");
 #include <asm/i8253.h>
 #else
 #include <asm/8253pit.h>
-static DEFINE_SPINLOCK(i8253_lock);
+static DEFINE_RAW_SPINLOCK(i8253_lock);
 #endif
 
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
@@ -50,7 +50,7 @@ static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int c
 	if (value > 20 && value < 32767)
 		count = PIT_TICK_RATE / value;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* set command for counter 2, 2 byte write */
@@ -65,7 +65,7 @@ static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int c
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return 0;
 }
diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
index 1e12307..4ff6c8c 100644
--- a/sound/drivers/pcsp/pcsp.h
+++ b/sound/drivers/pcsp/pcsp.h
@@ -16,7 +16,7 @@
 #include <asm/i8253.h>
 #else
 #include <asm/8253pit.h>
-static DEFINE_SPINLOCK(i8253_lock);
+static DEFINE_RAW_SPINLOCK(i8253_lock);
 #endif
 
 #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */
diff --git a/sound/drivers/pcsp/pcsp_input.c b/sound/drivers/pcsp/pcsp_input.c
index 0444cde..b5e2b54 100644
--- a/sound/drivers/pcsp/pcsp_input.c
+++ b/sound/drivers/pcsp/pcsp_input.c
@@ -21,7 +21,7 @@ static void pcspkr_do_sound(unsigned int count)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* set command for counter 2, 2 byte write */
@@ -36,7 +36,7 @@ static void pcspkr_do_sound(unsigned int count)
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
 void pcspkr_stop_sound(void)
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index e1145ac..f6a2e72 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -65,7 +65,7 @@ static u64 pcsp_timer_update(struct snd_pcsp *chip)
 	timer_cnt = val * CUR_DIV() / 256;
 
 	if (timer_cnt && chip->enable) {
-		spin_lock_irqsave(&i8253_lock, flags);
+		raw_spin_lock_irqsave(&i8253_lock, flags);
 		if (!nforce_wa) {
 			outb_p(chip->val61, 0x61);
 			outb_p(timer_cnt, 0x42);
@@ -74,7 +74,7 @@ static u64 pcsp_timer_update(struct snd_pcsp *chip)
 			outb(chip->val61 ^ 2, 0x61);
 			chip->thalf = 1;
 		}
-		spin_unlock_irqrestore(&i8253_lock, flags);
+		raw_spin_unlock_irqrestore(&i8253_lock, flags);
 	}
 
 	chip->ns_rem = PCSP_PERIOD_NS();
@@ -158,10 +158,10 @@ static int pcsp_start_playing(struct snd_pcsp *chip)
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
 
@@ -178,11 +178,11 @@ static void pcsp_stop_playing(struct snd_pcsp *chip)
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
