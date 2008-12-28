Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYL1TQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYL1TQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbYL1TQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:16:00 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:60577 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYL1TP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:15:57 -0500
Date: Sun, 28 Dec 2008 20:15:51 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git] m68k
Message-ID: <Pine.LNX.4.64.0812282015210.20983@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hi Linus,

Please pull from

    git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

to receive the following m68k-related updates for 2.6.29:

Finn Thain (7):
      m68k: Reinstate mac rtc
      m68k: Mac via cleanup and commentry
      m68k: machw.h cleanup
      m68k: mac baboon interrupt enable/disable
      macfb annotations and compiler warning fix
      m68k: fix trigraph ignored warning in setox.S
      fbcon: remove broken mac vbl handler

Geert Uytterhoeven (1):
      fbcon: Protect free_irq() by MACH_IS_ATARI check

Harvey Harrison (1):
      m68k: use the new byteorder headers

Thanks and a Happy New Year!

 arch/m68k/fpsp040/setox.S       |    4 +-
 arch/m68k/mac/baboon.c          |   42 +++++++++++++++------
 arch/m68k/mac/config.c          |    3 -
 arch/m68k/mac/debug.c           |    1 
 arch/m68k/mac/macints.c         |    9 ++--
 arch/m68k/mac/misc.c            |   16 +++++---
 arch/m68k/mac/oss.c             |    1 
 arch/m68k/mac/via.c             |   80 ++++++++++++++++------------------------
 drivers/ide/macide.c            |    1 
 drivers/macintosh/via-cuda.c    |    1 
 drivers/macintosh/via-macii.c   |    1 
 drivers/macintosh/via-maciisi.c |    1 
 drivers/macintosh/via-pmu68k.c  |    1 
 drivers/scsi/mac_scsi.c         |    1 
 drivers/video/console/fbcon.c   |   78 ++-------------------------------------
 drivers/video/macfb.c           |   33 ++++++++--------
 include/asm-m68k/byteorder.h    |   16 ++------
 include/asm-m68k/machw.h        |   22 -----------
 18 files changed, 105 insertions(+), 206 deletions(-)

diff --git a/arch/m68k/fpsp040/setox.S b/arch/m68k/fpsp040/setox.S
index 145af54..f1acf7e 100644
--- a/arch/m68k/fpsp040/setox.S
+++ b/arch/m68k/fpsp040/setox.S
@@ -36,9 +36,9 @@
 |	depending on their values, the program may run faster or slower --
 |	but no worse than 10% slower even in the extreme cases.
 |
-|	The program setoxm1 takes approximately ???/??? cycles for input
+|	The program setoxm1 takes approximately ??? / ??? cycles for input
 |	argument X, 0.25 <= |X| < 70log2. For |X| < 0.25, it takes
-|	approximately ???/??? cycles. For the less common arguments,
+|	approximately ??? / ??? cycles. For the less common arguments,
 |	depending on their values, the program may run faster or slower --
 |	but no worse than 10% slower even in the extreme cases.
 |
diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index c7b25b0..245d16d 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -18,11 +18,14 @@
 #include <asm/macints.h>
 #include <asm/mac_baboon.h>
 
-/* #define DEBUG_BABOON */
 /* #define DEBUG_IRQS */
 
+extern void mac_enable_irq(unsigned int);
+extern void mac_disable_irq(unsigned int);
+
 int baboon_present;
 static volatile struct baboon *baboon;
+static unsigned char baboon_disabled;
 
 #if 0
 extern int macide_ack_intr(struct ata_channel *);
@@ -88,34 +91,51 @@ static irqreturn_t baboon_irq(int irq, void *dev_id)
 
 void __init baboon_register_interrupts(void)
 {
-	request_irq(IRQ_NUBUS_C, baboon_irq, IRQ_FLG_LOCK|IRQ_FLG_FAST,
-		    "baboon", (void *) baboon);
+	baboon_disabled = 0;
+	request_irq(IRQ_NUBUS_C, baboon_irq, 0, "baboon", (void *)baboon);
 }
 
-void baboon_irq_enable(int irq) {
+/*
+ * The means for masking individual baboon interrupts remains a mystery, so
+ * enable the umbrella interrupt only when no baboon interrupt is disabled.
+ */
+
+void baboon_irq_enable(int irq)
+{
+	int irq_idx = IRQ_IDX(irq);
+
 #ifdef DEBUG_IRQUSE
 	printk("baboon_irq_enable(%d)\n", irq);
 #endif
-	/* FIXME: figure out how to mask and unmask baboon interrupt sources */
-	enable_irq(IRQ_NUBUS_C);
+
+	baboon_disabled &= ~(1 << irq_idx);
+	if (!baboon_disabled)
+		mac_enable_irq(IRQ_NUBUS_C);
 }
 
-void baboon_irq_disable(int irq) {
+void baboon_irq_disable(int irq)
+{
+	int irq_idx = IRQ_IDX(irq);
+
 #ifdef DEBUG_IRQUSE
 	printk("baboon_irq_disable(%d)\n", irq);
 #endif
-	disable_irq(IRQ_NUBUS_C);
+
+	baboon_disabled |= 1 << irq_idx;
+	if (baboon_disabled)
+		mac_disable_irq(IRQ_NUBUS_C);
 }
 
-void baboon_irq_clear(int irq) {
-	int irq_idx	= IRQ_IDX(irq);
+void baboon_irq_clear(int irq)
+{
+	int irq_idx = IRQ_IDX(irq);
 
 	baboon->mb_ifr &= ~(1 << irq_idx);
 }
 
 int baboon_irq_pending(int irq)
 {
-	int irq_idx	= IRQ_IDX(irq);
+	int irq_idx = IRQ_IDX(irq);
 
 	return baboon->mb_ifr & (1 << irq_idx);
 }
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index c45e184..8819b97 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -162,10 +162,7 @@ void __init config_mac(void)
 	mach_init_IRQ = mac_init_IRQ;
 	mach_get_model = mac_get_model;
 	mach_gettimeoffset = mac_gettimeoffset;
-#warning move to adb/via init
-#if 0
 	mach_hwclk = mac_hwclk;
-#endif
 	mach_set_clock_mmss = mac_set_clock_mmss;
 	mach_reset = mac_reset;
 	mach_halt = mac_poweroff;
diff --git a/arch/m68k/mac/debug.c b/arch/m68k/mac/debug.c
index 2165740..65dd77a 100644
--- a/arch/m68k/mac/debug.c
+++ b/arch/m68k/mac/debug.c
@@ -24,7 +24,6 @@
 #define BOOTINFO_COMPAT_1_0
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
-#include <asm/machw.h>
 #include <asm/macints.h>
 
 extern unsigned long mac_videobase;
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index ecddac4..82e560c 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -127,7 +127,6 @@
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/bootinfo.h>
-#include <asm/machw.h>
 #include <asm/macintosh.h>
 #include <asm/mac_via.h>
 #include <asm/mac_psc.h>
@@ -215,8 +214,8 @@ irqreturn_t mac_debug_handler(int, void *);
 
 /* #define DEBUG_MACINTS */
 
-static void mac_enable_irq(unsigned int irq);
-static void mac_disable_irq(unsigned int irq);
+void mac_enable_irq(unsigned int irq);
+void mac_disable_irq(unsigned int irq);
 
 static struct irq_controller mac_irq_controller = {
 	.name		= "mac",
@@ -275,7 +274,7 @@ void __init mac_init_IRQ(void)
  * These routines are just dispatchers to the VIA/OSS/PSC routines.
  */
 
-static void mac_enable_irq(unsigned int irq)
+void mac_enable_irq(unsigned int irq)
 {
 	int irq_src = IRQ_SRC(irq);
 
@@ -308,7 +307,7 @@ static void mac_enable_irq(unsigned int irq)
 	}
 }
 
-static void mac_disable_irq(unsigned int irq)
+void mac_disable_irq(unsigned int irq)
 {
 	int irq_src = IRQ_SRC(irq);
 
diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index 56d1f56..a44c708 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -93,7 +93,7 @@ static void cuda_write_pram(int offset, __u8 data)
 #define cuda_write_pram NULL
 #endif
 
-#ifdef CONFIG_ADB_PMU68K
+#if 0 /* def CONFIG_ADB_PMU68K */
 static long pmu_read_time(void)
 {
 	struct adb_request req;
@@ -148,7 +148,7 @@ static void pmu_write_pram(int offset, __u8 data)
 #define pmu_write_pram NULL
 #endif
 
-#ifdef CONFIG_ADB_MACIISI
+#if 0 /* def CONFIG_ADB_MACIISI */
 extern int maciisi_request(struct adb_request *req,
 			void (*done)(struct adb_request *), int nbytes, ...);
 
@@ -717,13 +717,18 @@ int mac_hwclk(int op, struct rtc_time *t)
 		unmktime(now, 0,
 			 &t->tm_year, &t->tm_mon, &t->tm_mday,
 			 &t->tm_hour, &t->tm_min, &t->tm_sec);
+#if 0
 		printk("mac_hwclk: read %04d-%02d-%-2d %02d:%02d:%02d\n",
-			t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+			t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
+			t->tm_hour, t->tm_min, t->tm_sec);
+#endif
 	} else { /* write */
+#if 0
 		printk("mac_hwclk: tried to write %04d-%02d-%-2d %02d:%02d:%02d\n",
-			t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
+			t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
+			t->tm_hour, t->tm_min, t->tm_sec);
+#endif
 
-#if 0	/* it trashes my rtc */
 		now = mktime(t->tm_year + 1900, t->tm_mon + 1, t->tm_mday,
 			     t->tm_hour, t->tm_min, t->tm_sec);
 
@@ -742,7 +747,6 @@ int mac_hwclk(int op, struct rtc_time *t)
 		case MAC_ADB_IISI:
 			maciisi_write_time(now);
 		}
-#endif
 	}
 	return 0;
 }
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index 43d83e0..8426501 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -21,7 +21,6 @@
 #include <linux/init.h>
 
 #include <asm/bootinfo.h>
-#include <asm/machw.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_via.h>
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 1bdb03c..f01d418 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -32,15 +32,10 @@
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/machw.h>
 #include <asm/mac_via.h>
 #include <asm/mac_psc.h>
 
 volatile __u8 *via1, *via2;
-#if 0
-/* See note in mac_via.h about how this is possibly not useful */
-volatile long *via_memory_bogon=(long *)&via_memory_bogon;
-#endif
 int rbv_present;
 int via_alt_mapping;
 EXPORT_SYMBOL(via_alt_mapping);
@@ -66,7 +61,7 @@ static int gIER,gIFR,gBufA,gBufB;
 #define MAC_CLOCK_LOW		(MAC_CLOCK_TICK&0xFF)
 #define MAC_CLOCK_HIGH		(MAC_CLOCK_TICK>>8)
 
-/* To disable a NuBus slot on Quadras we make the slot IRQ lines outputs, set
+/* To disable a NuBus slot on Quadras we make that slot IRQ line an output set
  * high. On RBV we just use the slot interrupt enable register. On Macs with
  * genuine VIA chips we must use nubus_disabled to keep track of disabled slot
  * interrupts. When any slot IRQ is disabled we mask the (edge triggered) CA1
@@ -180,7 +175,7 @@ void __init via_init(void)
 	via1[vT1CH] = 0;
 	via1[vT2CL] = 0;
 	via1[vT2CH] = 0;
-	via1[vACR] &= 0x3F;
+	via1[vACR] &= ~0xC0; /* setup T1 timer with no PB7 output */
 	via1[vACR] &= ~0x03; /* disable port A & B latches */
 
 	/*
@@ -203,40 +198,41 @@ void __init via_init(void)
 
 	/* Everything below this point is VIA2/RBV only... */
 
-	if (oss_present) return;
+	if (oss_present)
+		return;
 
-#if 1
 	/* Some machines support an alternate IRQ mapping that spreads  */
 	/* Ethernet and Sound out to their own autolevel IRQs and moves */
 	/* VIA1 to level 6. A/UX uses this mapping and we do too.  Note */
 	/* that the IIfx emulates this alternate mapping using the OSS. */
 
-	switch(macintosh_config->ident) {
-		case MAC_MODEL_P475:
-		case MAC_MODEL_P475F:
-		case MAC_MODEL_P575:
-		case MAC_MODEL_Q605:
-		case MAC_MODEL_Q605_ACC:
-		case MAC_MODEL_C610:
-		case MAC_MODEL_Q610:
-		case MAC_MODEL_Q630:
-		case MAC_MODEL_C650:
-		case MAC_MODEL_Q650:
-		case MAC_MODEL_Q700:
-		case MAC_MODEL_Q800:
-		case MAC_MODEL_Q900:
-		case MAC_MODEL_Q950:
+	via_alt_mapping = 0;
+	if (macintosh_config->via_type == MAC_VIA_QUADRA)
+		switch (macintosh_config->ident) {
+		case MAC_MODEL_C660:
+		case MAC_MODEL_Q840:
+			/* not applicable */
+			break;
+		case MAC_MODEL_P588:
+		case MAC_MODEL_TV:
+		case MAC_MODEL_PB140:
+		case MAC_MODEL_PB145:
+		case MAC_MODEL_PB160:
+		case MAC_MODEL_PB165:
+		case MAC_MODEL_PB165C:
+		case MAC_MODEL_PB170:
+		case MAC_MODEL_PB180:
+		case MAC_MODEL_PB180C:
+		case MAC_MODEL_PB190:
+		case MAC_MODEL_PB520:
+			/* not yet tested */
+			break;
+		default:
 			via_alt_mapping = 1;
 			via1[vDirB] |= 0x40;
 			via1[vBufB] &= ~0x40;
 			break;
-		default:
-			via_alt_mapping = 0;
-			break;
-	}
-#else
-	via_alt_mapping = 0;
-#endif
+		}
 
 	/*
 	 * Now initialize VIA2. For RBV we just kill all interrupts;
@@ -252,14 +248,17 @@ void __init via_init(void)
 		via2[vT1CH] = 0;
 		via2[vT2CL] = 0;
 		via2[vT2CH] = 0;
-		via2[vACR] &= 0x3F;
+		via2[vACR] &= ~0xC0; /* setup T1 timer with no PB7 output */
 		via2[vACR] &= ~0x03; /* disable port A & B latches */
 	}
 
 	/*
-	 * Set vPCR for SCSI interrupts (but not on RBV)
+	 * Set vPCR for control line interrupts (but not on RBV)
 	 */
 	if (!rbv_present) {
+		/* For all VIA types, CA1 (SLOTS IRQ) and CB1 (ASC IRQ)
+		 * are made negative edge triggered here.
+		 */
 		if (macintosh_config->scsi_type == MAC_SCSI_OLD) {
 			/* CB2 (IRQ) indep. input, positive edge */
 			/* CA2 (DRQ) indep. input, positive edge */
@@ -466,21 +465,6 @@ irqreturn_t via1_irq(int irq, void *dev_id)
 		++irq_num;
 		irq_bit <<= 1;
 	} while (events >= irq_bit);
-
-#if 0 /* freakin' pmu is doing weird stuff */
-	if (!oss_present) {
-		/* This (still) seems to be necessary to get IDE
-		   working.  However, if you enable VBL interrupts,
-		   you're screwed... */
-		/* FIXME: should we check the SLOTIRQ bit before
-                   pulling this stunt? */
-		/* No, it won't be set. that's why we're doing this. */
-		via_irq_disable(IRQ_MAC_NUBUS);
-		via_irq_clear(IRQ_MAC_NUBUS);
-		m68k_handle_int(IRQ_MAC_NUBUS);
-		via_irq_enable(IRQ_MAC_NUBUS);
-	}
-#endif
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/ide/macide.c b/drivers/ide/macide.c
index 43f97cc..3c60064 100644
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -18,7 +18,6 @@
 #include <linux/delay.h>
 #include <linux/ide.h>
 
-#include <asm/machw.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_baboon.h>
diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 741a93a..62dd1fd 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -23,7 +23,6 @@
 #else
 #include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/machw.h>
 #include <asm/mac_via.h>
 #endif
 #include <asm/io.h>
diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index 6e6dd17..817f37a 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -33,7 +33,6 @@
 #include <linux/init.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/machw.h>
 #include <asm/mac_via.h>
 #include <asm/system.h>
 
diff --git a/drivers/macintosh/via-maciisi.c b/drivers/macintosh/via-maciisi.c
index 2dc7880..4d686c0 100644
--- a/drivers/macintosh/via-maciisi.c
+++ b/drivers/macintosh/via-maciisi.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/machw.h>
 #include <asm/mac_via.h>
 
 static volatile unsigned char *via;
diff --git a/drivers/macintosh/via-pmu68k.c b/drivers/macintosh/via-pmu68k.c
index b64741c..fb9fa61 100644
--- a/drivers/macintosh/via-pmu68k.c
+++ b/drivers/macintosh/via-pmu68k.c
@@ -35,7 +35,6 @@
 
 #include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/machw.h>
 #include <asm/mac_via.h>
 
 #include <asm/pgtable.h>
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 0248919..bf2a1c5 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -47,7 +47,6 @@
 
 #include <asm/macintosh.h>
 #include <asm/macints.h>
-#include <asm/machw.h>
 #include <asm/mac_via.h>
 
 #include "scsi.h"
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 0b2adef..4bcff81 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -81,9 +81,6 @@
 #ifdef CONFIG_ATARI
 #include <asm/atariints.h>
 #endif
-#ifdef CONFIG_MAC
-#include <asm/macints.h>
-#endif
 #if defined(__mc68000__)
 #include <asm/machdep.h>
 #include <asm/setup.h>
@@ -160,8 +157,6 @@ static int fbcon_set_origin(struct vc_data *);
 
 /* # VBL ints between cursor state changes */
 #define ATARI_CURSOR_BLINK_RATE		(42)
-#define MAC_CURSOR_BLINK_RATE		(32)
-#define DEFAULT_CURSOR_BLINK_RATE	(20)
 
 static int vbl_cursor_cnt;
 static int fbcon_cursor_noblink;
@@ -210,19 +205,6 @@ static void fbcon_start(void);
 static void fbcon_exit(void);
 static struct device *fbcon_device;
 
-#ifdef CONFIG_MAC
-/*
- * On the Macintoy, there may or may not be a working VBL int. We need to probe
- */
-static int vbl_detected;
-
-static irqreturn_t fb_vbl_detect(int irq, void *dummy)
-{
-	vbl_detected++;
-	return IRQ_HANDLED;
-}
-#endif
-
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_ROTATION
 static inline void fbcon_set_rotation(struct fb_info *info)
 {
@@ -421,7 +403,7 @@ static void fb_flashcursor(struct work_struct *work)
 	release_console_sem();
 }
 
-#if defined(CONFIG_ATARI) || defined(CONFIG_MAC)
+#ifdef CONFIG_ATARI
 static int cursor_blink_rate;
 static irqreturn_t fb_vbl_handler(int irq, void *dev_id)
 {
@@ -949,9 +931,7 @@ static const char *fbcon_startup(void)
 	struct fb_info *info = NULL;
 	struct fbcon_ops *ops;
 	int rows, cols;
-	int irqres;
 
-	irqres = 1;
 	/*
 	 *  If num_registered_fb is zero, this is a call for the dummy part.
 	 *  The frame buffer devices weren't initialized yet.
@@ -1040,56 +1020,11 @@ static const char *fbcon_startup(void)
 #ifdef CONFIG_ATARI
 	if (MACH_IS_ATARI) {
 		cursor_blink_rate = ATARI_CURSOR_BLINK_RATE;
-		irqres =
-		    request_irq(IRQ_AUTO_4, fb_vbl_handler,
+		(void)request_irq(IRQ_AUTO_4, fb_vbl_handler,
 				IRQ_TYPE_PRIO, "framebuffer vbl",
 				info);
 	}
-#endif				/* CONFIG_ATARI */
-
-#ifdef CONFIG_MAC
-	/*
-	 * On a Macintoy, the VBL interrupt may or may not be active. 
-	 * As interrupt based cursor is more reliable and race free, we 
-	 * probe for VBL interrupts.
-	 */
-	if (MACH_IS_MAC) {
-		int ct = 0;
-		/*
-		 * Probe for VBL: set temp. handler ...
-		 */
-		irqres = request_irq(IRQ_MAC_VBL, fb_vbl_detect, 0,
-				     "framebuffer vbl", info);
-		vbl_detected = 0;
-
-		/*
-		 * ... and spin for 20 ms ...
-		 */
-		while (!vbl_detected && ++ct < 1000)
-			udelay(20);
-
-		if (ct == 1000)
-			printk
-			    ("fbcon_startup: No VBL detected, using timer based cursor.\n");
-
-		free_irq(IRQ_MAC_VBL, fb_vbl_detect);
-
-		if (vbl_detected) {
-			/*
-			 * interrupt based cursor ok
-			 */
-			cursor_blink_rate = MAC_CURSOR_BLINK_RATE;
-			irqres =
-			    request_irq(IRQ_MAC_VBL, fb_vbl_handler, 0,
-					"framebuffer vbl", info);
-		} else {
-			/*
-			 * VBL not detected: fall through, use timer based cursor
-			 */
-			irqres = 1;
-		}
-	}
-#endif				/* CONFIG_MAC */
+#endif /* CONFIG_ATARI */
 
 	fbcon_add_cursor_timer(info);
 	fbcon_has_exited = 0;
@@ -3520,11 +3455,8 @@ static void fbcon_exit(void)
 		return;
 
 #ifdef CONFIG_ATARI
-	free_irq(IRQ_AUTO_4, fb_vbl_handler);
-#endif
-#ifdef CONFIG_MAC
-	if (MACH_IS_MAC && vbl_detected)
-		free_irq(IRQ_MAC_VBL, fb_vbl_handler);
+	if (MACH_IS_ATARI)
+		free_irq(IRQ_AUTO_4, fb_vbl_handler);
 #endif
 
 	kfree((void *)softback_buf);
diff --git a/drivers/video/macfb.c b/drivers/video/macfb.c
index ee380d5..d66887e 100644
--- a/drivers/video/macfb.c
+++ b/drivers/video/macfb.c
@@ -36,7 +36,6 @@
 #include <asm/irq.h>
 #include <asm/macintosh.h>
 #include <asm/io.h>
-#include <asm/machw.h>
 
 /* Common DAC base address for the LC, RBV, Valkyrie, and IIvx */
 #define DAC_BASE 0x50f24000
@@ -78,34 +77,34 @@ static int csc_setpalette (unsigned int regno, unsigned int red,
 			   unsigned int green, unsigned int blue,
 			   struct fb_info *fb_info);
 
-static volatile struct {
+static struct {
 	unsigned char addr;
 	/* Note: word-aligned */
 	char pad[3];
 	unsigned char lut;
-} *valkyrie_cmap_regs;
+} __iomem *valkyrie_cmap_regs;
 
-static volatile struct {
+static struct {
 	unsigned char addr;
 	unsigned char lut;
-} *v8_brazil_cmap_regs;
+} __iomem *v8_brazil_cmap_regs;
 
-static volatile struct {
+static struct {
 	unsigned char addr;
 	char pad1[3]; /* word aligned */
 	unsigned char lut;
 	char pad2[3]; /* word aligned */
 	unsigned char cntl; /* a guess as to purpose */
-} *rbv_cmap_regs;
+} __iomem *rbv_cmap_regs;
 
-static volatile struct {
+static struct {
 	unsigned long reset;
 	unsigned long pad1[3];
 	unsigned char pad2[3];
 	unsigned char lut;
-} *dafb_cmap_regs;
+} __iomem *dafb_cmap_regs;
 
-static volatile struct {
+static struct {
 	unsigned char addr;	/* OFFSET: 0x00 */
 	unsigned char pad1[15];
 	unsigned char lut;	/* OFFSET: 0x10 */
@@ -114,16 +113,16 @@ static volatile struct {
 	unsigned char pad3[7];
 	unsigned long vbl_addr;	/* OFFSET: 0x28 */
 	unsigned int  status2;	/* OFFSET: 0x2C */
-} *civic_cmap_regs;
+} __iomem *civic_cmap_regs;
 
-static volatile struct {
+static struct {
 	char    pad1[0x40];
         unsigned char	clut_waddr;	/* 0x40 */
         char    pad2;
         unsigned char	clut_data;	/* 0x42 */
         char	pad3[0x3];
         unsigned char	clut_raddr;	/* 0x46 */
-} *csc_cmap_regs;
+} __iomem *csc_cmap_regs;
 
 /* We will leave these the way they are for the time being */
 struct mdc_cmap_regs {
@@ -507,10 +506,10 @@ static int csc_setpalette (unsigned int regno, unsigned int red,
 			   struct fb_info *info)
 {
 	mdelay(1);
-	csc_cmap_regs->clut_waddr = regno;
-	csc_cmap_regs->clut_data = red;
-	csc_cmap_regs->clut_data = green;
-	csc_cmap_regs->clut_data = blue;
+	nubus_writeb(regno, &csc_cmap_regs->clut_waddr);
+	nubus_writeb(red,   &csc_cmap_regs->clut_data);
+	nubus_writeb(green, &csc_cmap_regs->clut_data);
+	nubus_writeb(blue,  &csc_cmap_regs->clut_data);
 	return 0;
 }
 
diff --git a/include/asm-m68k/byteorder.h b/include/asm-m68k/byteorder.h
index 81d420b..b354acd 100644
--- a/include/asm-m68k/byteorder.h
+++ b/include/asm-m68k/byteorder.h
@@ -4,22 +4,16 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 val)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
 	return val;
 }
-#define __arch__swab32(x) ___arch__swab32(x)
+#define __arch_swab32 __arch_swab32
 
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68K_BYTEORDER_H */
diff --git a/include/asm-m68k/machw.h b/include/asm-m68k/machw.h
index 3562499..2b4de0c 100644
--- a/include/asm-m68k/machw.h
+++ b/include/asm-m68k/machw.h
@@ -26,28 +26,6 @@
 #include <linux/types.h>
 
 #if 0
-/* Mac SCSI Controller 5380 */
-
-#define	MAC_5380_BAS	(0x50F10000) /* This is definitely wrong!! */
-struct MAC_5380 {
-	u_char	scsi_data;
-	u_char	char_dummy1;
-	u_char	scsi_icr;
-	u_char	char_dummy2;
-	u_char	scsi_mode;
-	u_char	char_dummy3;
-	u_char	scsi_tcr;
-	u_char	char_dummy4;
-	u_char	scsi_idstat;
-	u_char	char_dummy5;
-	u_char	scsi_dmastat;
-	u_char	char_dummy6;
-	u_char	scsi_targrcv;
-	u_char	char_dummy7;
-	u_char	scsi_inircv;
-};
-#define	mac_scsi       ((*(volatile struct MAC_5380 *)MAC_5380_BAS))
-
 /*
 ** SCC Z8530
 */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
