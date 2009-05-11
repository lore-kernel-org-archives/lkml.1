Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbZEKXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbZEKXF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbZEKXFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:05:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZEKXFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:05:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: use PIT_TICK_RATE consistently
Date: Mon, 11 May 2009 23:05:12 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: John Stultz <johnstul@us.ibm.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       linux-kernel@vger.kernel.org, x86@kernel.org
References: <20090511222702.352192505@arndb.de> <20090511222702.352192505@arndb.de>> <200905112250.16176.arnd@arndb.de>
In-Reply-To: <200905112250.16176.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200905112305.12369.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+YkRgui4k/FR1NDEOfvhyLDhERv+oSK95w6uT
 ao+AHtWYmumiHWoXbzFhH16WB06qWmNAFjwQVU76CC4aFIo+oi
 GrJxrhw8t9qsvOiBHRCfTCqY/Sh1Hql
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5939f98adbf5ae727f0d3fa708247fc855f49dd2 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 3 May 2009 22:42:56 +0000
Subject: [PATCH] x86: use PIT_TICK_RATE consistently

On x86, the CLOCK_TICK_RATE is defined in terms of PIT_TICK_RATE,
from the original i8253 PIT frequency. Change all users to
refer to PIT_TICK_RATE directly, in order to reduce the number
of overloaded meanings for CLOCK_TICK_RATE.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

resend without wordwrap...

 arch/x86/include/asm/mach_timer.h |    2 +-
 arch/x86/kernel/i8253.c           |    4 ++--
 arch/x86/kernel/tsc.c             |    4 ++--
 drivers/clocksource/acpi_pm.c     |    2 +-
 drivers/input/joystick/analog.c   |    2 +-
 sound/oss/pas2_pcm.c              |    8 ++++----
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/mach_timer.h b/arch/x86/include/asm/mach_timer.h
index 8537285..88d0c3c 100644
--- a/arch/x86/include/asm/mach_timer.h
+++ b/arch/x86/include/asm/mach_timer.h
@@ -15,7 +15,7 @@
 
 #define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
 #define CALIBRATE_LATCH	\
-	((CLOCK_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
+	((PIT_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
 
 static inline void mach_prepare_counter(void)
 {
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index c2e0bb0..5b0ef4e 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -115,7 +115,7 @@ void __init setup_pit_timer(void)
 	 * IO_APIC has been initialized.
 	 */
 	pit_ce.cpumask = cpumask_of(smp_processor_id());
-	pit_ce.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
+	pit_ce.mult = div_sc(PIT_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
 	pit_ce.max_delta_ns = clockevent_delta2ns(0x7FFF, &pit_ce);
 	pit_ce.min_delta_ns = clockevent_delta2ns(0xF, &pit_ce);
 
@@ -223,7 +223,7 @@ static int __init init_pit_clocksource(void)
 	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	pit_cs.mult = clocksource_hz2mult(CLOCK_TICK_RATE, pit_cs.shift);
+	pit_cs.mult = clocksource_hz2mult(PIT_TICK_RATE, pit_cs.shift);
 
 	return clocksource_register(&pit_cs);
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d57de05..d1cb3e5 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -172,11 +172,11 @@ static unsigned long calc_pmtimer_ref(u64 deltatsc, u64 pm1, u64 pm2)
 }
 
 #define CAL_MS		10
-#define CAL_LATCH	(CLOCK_TICK_RATE / (1000 / CAL_MS))
+#define CAL_LATCH	(PIT_TICK_RATE / (1000 / CAL_MS))
 #define CAL_PIT_LOOPS	1000
 
 #define CAL2_MS		50
-#define CAL2_LATCH	(CLOCK_TICK_RATE / (1000 / CAL2_MS))
+#define CAL2_LATCH	(PIT_TICK_RATE / (1000 / CAL2_MS))
 #define CAL2_PIT_LOOPS	5000
 
 
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 40bd8c6..8e4c896 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -145,7 +145,7 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
 #ifndef CONFIG_X86_64
 #include <asm/mach_timer.h>
 #define PMTMR_EXPECTED_RATE \
-  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
+  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (PIT_TICK_RATE>>10))
 /*
  * Some boards have the PMTMR running way too fast. We check
  * the PMTMR rate against PIT channel 2 to catch these cases.
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 356b3a2..3f99867 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -139,7 +139,7 @@ struct analog_port {
 #include <asm/i8253.h>
 
 #define GET_TIME(x)	do { if (cpu_has_tsc) rdtscl(x); else x = get_time_pit(); } while (0)
-#define DELTA(x,y)	(cpu_has_tsc ? ((y) - (x)) : ((x) - (y) + ((x) < (y) ? CLOCK_TICK_RATE / HZ : 0)))
+#define DELTA(x,y)	(cpu_has_tsc ? ((y) - (x)) : ((x) - (y) + ((x) < (y) ? PIT_TICK_RATE / HZ : 0)))
 #define TIME_NAME	(cpu_has_tsc?"TSC":"PIT")
 static unsigned int get_time_pit(void)
 {
diff --git a/sound/oss/pas2_pcm.c b/sound/oss/pas2_pcm.c
index 36c3ea6..0891e3b 100644
--- a/sound/oss/pas2_pcm.c
+++ b/sound/oss/pas2_pcm.c
@@ -63,13 +63,13 @@ static int pcm_set_speed(int arg)
 
 	if (pcm_channels & 2)
 	{
-		foo = ((CLOCK_TICK_RATE / 2) + (arg / 2)) / arg;
-		arg = ((CLOCK_TICK_RATE / 2) + (foo / 2)) / foo;
+		foo = ((PIT_TICK_RATE / 2) + (arg / 2)) / arg;
+		arg = ((PIT_TICK_RATE / 2) + (foo / 2)) / foo;
 	}
 	else
 	{
-		foo = (CLOCK_TICK_RATE + (arg / 2)) / arg;
-		arg = (CLOCK_TICK_RATE + (foo / 2)) / foo;
+		foo = (PIT_TICK_RATE + (arg / 2)) / arg;
+		arg = (PIT_TICK_RATE + (foo / 2)) / foo;
 	}
 
 	pcm_speed = arg;
-- 
1.6.0.4


