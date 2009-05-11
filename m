Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbZEKW4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbZEKW4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbZEKWzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:55:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65441 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZEKWzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:55:53 -0400
Message-Id: <200905112255.37215.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 22:55:36 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org, x86@kernel.org,
       Richard Henderson <rth@twiddle.net>, Ralf Baechle <ralf@linux-mips.org>,
       Takashi Iwai <tiwai@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move PIT_TICK_RATE to linux/timex.h
Content-Disposition: inline
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/IlP5yiEbsR6TMqOiwGVZca7/ZSvbtgac+DND
 JbIJRJuPtBhpiAWbooryIVumnaSwlFJuqnndk44rpAnJOuZxwS
 zyBzBpkeh00mb9dIGBWAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PIT_TICK_RATE is currently defined in four architectures,
but in three different places. While linux/timex.h is not
the perfect place for it, it is still a reasonable replacement
for those drivers that traditionally use asm/timex.h to
get CLOCK_TICK_RATE and expect it to be the PIT frequency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/include/asm/8253pit.h   |    7 -------
 arch/alpha/kernel/sys_ruffian.c    |    1 +
 arch/mips/include/asm/i8253.h      |    2 --
 arch/powerpc/include/asm/8253pit.h |    7 -------
 arch/x86/include/asm/timex.h       |    4 +---
 arch/x86/kernel/i8253.c            |    1 +
 arch/x86/kernel/tsc.c              |    1 +
 drivers/clocksource/acpi_pm.c      |    1 +
 drivers/input/joystick/analog.c    |    2 +-
 drivers/input/misc/pcspkr.c        |    1 +
 include/linux/timex.h              |    3 +++
 sound/drivers/pcsp/pcsp.h          |    1 +
 sound/oss/pas2_pcm.c               |    2 +-
 13 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/include/asm/8253pit.h 
b/arch/alpha/include/asm/8253pit.h
index fef5c14..a71c9c1 100644
--- a/arch/alpha/include/asm/8253pit.h
+++ b/arch/alpha/include/asm/8253pit.h
@@ -1,10 +1,3 @@
 /*
  * 8253/8254 Programmable Interval Timer
  */
-
-#ifndef _8253PIT_H
-#define _8253PIT_H
-
-#define PIT_TICK_RATE 	1193180UL
-
-#endif
diff --git a/arch/alpha/kernel/sys_ruffian.c b/arch/alpha/kernel/sys_ruffian.c
index f15a329..d9f9cfe 100644
--- a/arch/alpha/kernel/sys_ruffian.c
+++ b/arch/alpha/kernel/sys_ruffian.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
+#include <linux/timex.h>
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
index 5dabc87..032ca73 100644
--- a/arch/mips/include/asm/i8253.h
+++ b/arch/mips/include/asm/i8253.h
@@ -12,8 +12,6 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-#define PIT_TICK_RATE		1193182UL
-
 extern spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
diff --git a/arch/powerpc/include/asm/8253pit.h 
b/arch/powerpc/include/asm/8253pit.h
index b70d6e5..a71c9c1 100644
--- a/arch/powerpc/include/asm/8253pit.h
+++ b/arch/powerpc/include/asm/8253pit.h
@@ -1,10 +1,3 @@
-#ifndef _ASM_POWERPC_8253PIT_H
-#define _ASM_POWERPC_8253PIT_H
-
 /*
  * 8253/8254 Programmable Interval Timer
  */
-
-#define PIT_TICK_RATE	1193182UL
-
-#endif	/* _ASM_POWERPC_8253PIT_H */
diff --git a/arch/x86/include/asm/timex.h b/arch/x86/include/asm/timex.h
index b5c9d45..1375cfc 100644
--- a/arch/x86/include/asm/timex.h
+++ b/arch/x86/include/asm/timex.h
@@ -4,9 +4,7 @@
 #include <asm/processor.h>
 #include <asm/tsc.h>
 
-/* The PIT ticks at this frequency (in HZ): */
-#define PIT_TICK_RATE		1193182
-
+/* Assume we use the PIT time source for the clock tick */
 #define CLOCK_TICK_RATE		PIT_TICK_RATE
 
 #define ARCH_HAS_READ_CURRENT_TIMER
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 5b0ef4e..3e5ec80 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
+#include <linux/timex.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/io.h>
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d1cb3e5..5c627ff 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
+#include <linux/timex.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 8e4c896..f6d351c 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -18,6 +18,7 @@
 
 #include <linux/acpi_pmtmr.h>
 #include <linux/clocksource.h>
+#include <linux/timex.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 3f99867..5776f72 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -35,7 +35,7 @@
 #include <linux/input.h>
 #include <linux/gameport.h>
 #include <linux/jiffies.h>
-#include <asm/timex.h>
+#include <linux/timex.h>
 
 #define DRIVER_DESC	"Analog joystick and gamepad driver"
 
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index d6a30ce..6d67af5 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
+#include <linux/timex.h>
 #include <asm/io.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
diff --git a/include/linux/timex.h b/include/linux/timex.h
index aa3475f..66cbf74 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -260,6 +260,9 @@ extern int do_adjtimex(struct timex *);
 
 int read_current_timer(unsigned long *timer_val);
 
+/* The clock frequency of the i8253/i8254 PIT */
+#define PIT_TICK_RATE 1193182ul
+
 #endif /* KERNEL */
 
 #endif /* LINUX_TIMEX_H */
diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
index cdef266..174dd2f 100644
--- a/sound/drivers/pcsp/pcsp.h
+++ b/sound/drivers/pcsp/pcsp.h
@@ -10,6 +10,7 @@
 #define __PCSP_H__
 
 #include <linux/hrtimer.h>
+#include <linux/timex.h>
 #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
 #include <asm/i8253.h>
diff --git a/sound/oss/pas2_pcm.c b/sound/oss/pas2_pcm.c
index 0891e3b..6f13ab4 100644
--- a/sound/oss/pas2_pcm.c
+++ b/sound/oss/pas2_pcm.c
@@ -17,7 +17,7 @@
 
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <asm/timex.h>
+#include <linux/timex.h>
 #include "sound_config.h"
 
 #include "pas2.h"
-- 
1.6.0.4

-- 



