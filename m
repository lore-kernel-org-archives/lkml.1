Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449Ab0AKVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab0AKVba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312Ab0AKVbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:31:25 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35373 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab0AKV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=m7m2RYSHJVTAHX9t2ZUcBJg19kgm1fVZf4EkMkFUXG1KoGskYbVlwlO9f+Zq3jvRoD
         B1rkw5Ec7m+MnI9R2KToAmCZhmvhuOomO4HCiMSW1BXXkMeyPrHp7DQUzSKdu8U5BI+n
         cimsoWGFDajX7IhguosI7wmaztTnJsZi3auss=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 08/26] i8253: Convert i8253_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:38 +0100
Message-Id: <1263245216-14754-9-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-8-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks

See also 48c7e18d4d6933e2c03a30c2859d37795c3efc7b

Signed-off-by: John Kacur <jkacur@redhat.com>
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
index b5b6b23..a920e00 100644
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
index d5cdce0..d6efe0c 100644
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
index ac11be0..c04ae8d 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -57,11 +57,11 @@ static unsigned int get_time_pit(void)
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
-- 
1.6.5.2

