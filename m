Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYIMI1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYIMI1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYIMI1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:27:34 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43675 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYIMI12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:27:28 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Sep 2008 04:27:25 EDT
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm@vger.kernel.org
Cc: Eric Miao <eric.miao@marvell.com>, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@linux.it>
Date: Wed, 10 Sep 2008 10:07:35 +0200
Message-Id: <1221034056-16587-2-git-send-email-giometti@enneenne.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1221034056-16587-1-git-send-email-giometti@enneenne.com>
References: <1221034056-16587-1-git-send-email-giometti@enneenne.com>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 1/2] pxafb: frame buffer overlay support for PXA27x.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 arch/arm/mach-pxa/include/mach/regs-lcd.h |   39 +
 drivers/video/Kconfig                     |    6 +
 drivers/video/Makefile                    |    1 +
 drivers/video/pxafb.c                     |   75 ++-
 drivers/video/pxafb.h                     |   74 ++
 drivers/video/pxafb_overlay.c             | 1476 +++++++++++++++++++++++++++++
 6 files changed, 1654 insertions(+), 17 deletions(-)
 create mode 100644 drivers/video/pxafb_overlay.c

diff --git a/arch/arm/mach-pxa/include/mach/regs-lcd.h b/arch/arm/mach-pxa/include/mach/regs-lcd.h
index c689c4e..7439bfb 100644
--- a/arch/arm/mach-pxa/include/mach/regs-lcd.h
+++ b/arch/arm/mach-pxa/include/mach/regs-lcd.h
@@ -14,10 +14,21 @@
 #define LCCR5		(0x014)	/* LCD Controller Control Register 5 */
 #define DFBR0		(0x020)	/* DMA Channel 0 Frame Branch Register */
 #define DFBR1		(0x024)	/* DMA Channel 1 Frame Branch Register */
+#define DFBR2		(0x028)	/* DMA Channel 2 Frame Branch Register */
+#define DFBR3		(0x02C)	/* DMA Channel 3 Frame Branch Register */
+#define DFBR4		(0x030)	/* DMA Channel 4 Frame Branch Register */
+#define DFBR5		(0x110)	/* DMA Channel 5 Frame Branch Register */
+#define DFBR6		(0x114)	/* DMA Channel 6 Frame Branch Register */
+#define LCSR1		(0x034)	/* LCD Controller Status Register 1 */
 #define LCSR		(0x038)	/* LCD Controller Status Register */
 #define LIIDR		(0x03C)	/* LCD Controller Interrupt ID Register */
 #define TMEDRGBR	(0x040)	/* TMED RGB Seed Register */
 #define TMEDCR		(0x044)	/* TMED Control Register */
+#define OVL1C1		(0x050)	/* Overlay 1 Control Register 1 */
+#define OVL1C2		(0x060)	/* Overlay 1 Control Register 2 */
+#define OVL2C1		(0x070)	/* Overlay 2 Control Register 1 */
+#define OVL2C2		(0x080)	/* Overlay 2 Control Register 2 */
+#define CCR		(0x090)	/* Cursor Control Register */
 
 #define CMDCR		(0x100)	/* Command Control Register */
 #define PRSR		(0x104)	/* Panel Read Status Register */
@@ -52,6 +63,21 @@
 #define FSADR1		(0x214)	/* DMA Channel 1 Frame Source Address Register */
 #define FIDR1		(0x218)	/* DMA Channel 1 Frame ID Register */
 #define LDCMD1		(0x21C)	/* DMA Channel 1 Command Register */
+#define FDADR2		(0x220)	/* DMA Channel 2 Frame Descriptor Address Register */
+#define FSADR2		(0x224)	/* DMA Channel 2 Frame Source Address Register */
+#define FIDR2		(0x228)	/* DMA Channel 2 Frame ID Register */
+#define FDADR3		(0x230)	/* DMA Channel 3 Frame Descriptor Address Register */
+#define FSADR3		(0x234)	/* DMA Channel 3 Frame Source Address Register */
+#define FIDR3		(0x238)	/* DMA Channel 3 Frame ID Register */
+#define LDCMD3		(0x23C)	/* DMA Channel 3 Command Register */
+#define FDADR4		(0x240)	/* DMA Channel 4 Frame Descriptor Address Register */
+#define FSADR4		(0x244)	/* DMA Channel 4 Frame Source Address Register */
+#define FIDR4		(0x248)	/* DMA Channel 4 Frame ID Register */
+#define LDCMD4		(0x24C)	/* DMA Channel 4 Command Register */
+#define FDADR5		(0x250)	/* DMA Channel 5 Frame Descriptor Address Register */
+#define FSADR5		(0x254)	/* DMA Channel 5 Frame Source Address Register */
+#define FIDR5		(0x258)	/* DMA Channel 5 Frame ID Register */
+#define LDCMD5		(0x25C)	/* DMA Channel 5 Command Register */
 #define FDADR6		(0x260) /* DMA Channel 6 Frame Descriptor Address Register */
 #define FSADR6		(0x264) /* DMA Channel 6 Frame Source Address Register */
 #define FIDR6		(0x268) /* DMA Channel 6 Frame ID Register */
@@ -143,6 +169,10 @@
 #define LCCR5_EOFM(x)	(1 << ((x) + 7))  /* end of frame mask */
 #define LCCR5_SOFM(x)	(1 << ((x) + 0))  /* start of frame mask */
 
+#define OVL1C1_O1EN	(1 << 31)	/* Enable bit for Overlay 1 */
+#define OVL2C1_O2EN	(1 << 31)	/* Enable bit for Overlay 2 */
+#define CCR_CEN		(1 << 31)	/* Enable bit for Cursor */
+
 #define LCSR_LDD	(1 << 0)	/* LCD Disable Done */
 #define LCSR_SOF	(1 << 1)	/* Start of frame */
 #define LCSR_BER	(1 << 2)	/* Bus error */
@@ -159,6 +189,15 @@
 
 #define LDCMD_PAL	(1 << 26)	/* instructs DMA to load palette buffer */
 
+/* Overlay1 & Overlay2 & Hardware Cursor */
+#define LCSR1_SOF(x)	(1 << ((x) + 0))  /* start of frame */
+#define LCSR1_EOF(x)	(1 << ((x) + 7))  /* end of frame */
+#define LCSR1_BS(x)	(1 << ((x) + 15)) /* branch status */
+#define LCSR1_IU(x)	(1 << ((x) + 23)) /* input FIFO underrun */
+
+#define LDCMD_SOFINT	(1 << 22)
+#define LDCMD_EOFINT	(1 << 21)
+
 /* smartpanel related */
 #define PRSR_DATA(x)	((x) & 0xff)	/* Panel Data */
 #define PRSR_A0		(1 << 8)	/* Read Data Source */
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 70d135e..5d5c8c8 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1802,6 +1802,12 @@ config FB_PXA_SMARTPANEL
 	default n
 	depends on FB_PXA
 
+config FB_PXA_OVERLAY
+	bool "PXA LCD overlay support"
+	depends on FB_PXA && PXA27x
+	---help---
+	  Frame buffer overlay driver for PXA27x
+
 config FB_PXA_PARAMETERS
 	bool "PXA LCD command line parameters"
 	default n
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index a6b5529..4968776 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_FB_GBE)              += gbefb.o
 obj-$(CONFIG_FB_CIRRUS)		  += cirrusfb.o
 obj-$(CONFIG_FB_ASILIANT)	  += asiliantfb.o
 obj-$(CONFIG_FB_PXA)		  += pxafb.o
+obj-$(CONFIG_FB_PXA_OVERLAY)	  += pxafb_overlay.o
 obj-$(CONFIG_FB_W100)		  += w100fb.o
 obj-$(CONFIG_FB_AU1100)		  += au1100fb.o
 obj-$(CONFIG_FB_AU1200)		  += au1200fb.o
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 9720449..c17a6f3 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -74,19 +74,6 @@ static void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
 
 static int pxafb_activate_var(struct fb_var_screeninfo *var,
 				struct pxafb_info *);
-static void set_ctrlr_state(struct pxafb_info *fbi, u_int state);
-
-static inline unsigned long
-lcd_readl(struct pxafb_info *fbi, unsigned int off)
-{
-	return __raw_readl(fbi->mmio_base + off);
-}
-
-static inline void
-lcd_writel(struct pxafb_info *fbi, unsigned int off, unsigned long val)
-{
-	__raw_writel(val, fbi->mmio_base + off);
-}
 
 static inline void pxafb_schedule_work(struct pxafb_info *fbi, u_int state)
 {
@@ -488,7 +475,7 @@ static int pxafb_blank(int blank, struct fb_info *info)
 			for (i = 0; i < fbi->palette_size; i++)
 				pxafb_setpalettereg(i, 0, 0, 0, 0, info);
 
-		pxafb_schedule_work(fbi, C_DISABLE);
+		pxafb_schedule_work(fbi, C_BLANK);
 		/* TODO if (pxafb_blank_helper) pxafb_blank_helper(blank); */
 		break;
 
@@ -497,7 +484,7 @@ static int pxafb_blank(int blank, struct fb_info *info)
 		if (fbi->fb.fix.visual == FB_VISUAL_PSEUDOCOLOR ||
 		    fbi->fb.fix.visual == FB_VISUAL_STATIC_PSEUDOCOLOR)
 			fb_set_cmap(&fbi->fb.cmap, info);
-		pxafb_schedule_work(fbi, C_ENABLE);
+		pxafb_schedule_work(fbi, C_UNBLANK);
 	}
 	return 0;
 }
@@ -928,6 +915,9 @@ static int pxafb_activate_var(struct fb_var_screeninfo *var,
 
 	fbi->reg_lccr0 = fbi->lccr0 |
 		(LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM |
+#ifdef CONFIG_FB_PXA_OVERLAY
+		 LCCR0_OUC | LCCR0_CMDIM | LCCR0_RDSTM |
+#endif
 		 LCCR0_QDM | LCCR0_BM  | LCCR0_OUM);
 
 	fbi->reg_lccr3 |= pxafb_bpp_to_lccr3(var);
@@ -936,7 +926,8 @@ static int pxafb_activate_var(struct fb_var_screeninfo *var,
 
 	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual) {
 		nbytes = nbytes / 2;
-		setup_frame_dma(fbi, DMA_LOWER, PAL_NONE, nbytes, nbytes);
+		setup_frame_dma(fbi, DMA_LOWER, PAL_NONE, nbytes,
+					nbytes | LDCMD_EOFINT);
 	}
 
 	if ((var->bits_per_pixel >= 16) || (fbi->lccr0 & LCCR0_LCDT))
@@ -1116,7 +1107,7 @@ static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
  * sleep when disabling the LCD controller, or if we get two contending
  * processes trying to alter state.
  */
-static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
+void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 {
 	u_int old_state;
 
@@ -1139,6 +1130,8 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 		if (old_state != C_DISABLE && old_state != C_DISABLE_PM) {
 			fbi->state = state;
 			/* TODO __pxafb_lcd_power(fbi, 0); */
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_DISABLE);
 			pxafb_disable_controller(fbi);
 		}
 		break;
@@ -1152,6 +1145,8 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 			fbi->state = state;
 			__pxafb_backlight_power(fbi, 0);
 			__pxafb_lcd_power(fbi, 0);
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_DISABLE);
 			if (old_state != C_DISABLE_CLKCHANGE)
 				pxafb_disable_controller(fbi);
 		}
@@ -1166,6 +1161,8 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 			fbi->state = C_ENABLE;
 			pxafb_enable_controller(fbi);
 			/* TODO __pxafb_lcd_power(fbi, 1); */
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_ENABLE);
 		}
 		break;
 
@@ -1177,9 +1174,13 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 		 */
 		if (old_state == C_ENABLE) {
 			__pxafb_lcd_power(fbi, 0);
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_DISABLE);
 			pxafb_disable_controller(fbi);
 			pxafb_setup_gpio(fbi);
 			pxafb_enable_controller(fbi);
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_ENABLE);
 			__pxafb_lcd_power(fbi, 1);
 		}
 		break;
@@ -1205,8 +1206,42 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 			pxafb_enable_controller(fbi);
 			__pxafb_lcd_power(fbi, 1);
 			__pxafb_backlight_power(fbi, 1);
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_ENABLE);
 		}
 		break;
+
+	case C_BLANK:
+		/*
+		 * Disable controller, blank overlays if exist.
+		 */
+		if ((old_state != C_DISABLE) && (old_state != C_BLANK)) {
+			fbi->state = state;
+			__pxafb_backlight_power(fbi, 0);
+			__pxafb_lcd_power(fbi, 0);
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_BLANK);
+			if (old_state != C_DISABLE_CLKCHANGE)
+				pxafb_disable_controller(fbi);
+		}
+		break;
+
+	case C_UNBLANK:
+		/*
+		 * Power up the LCD screen, enable controller, and
+		 * turn on the backlight, unblank overlays if exist.
+		 */
+		if ((old_state != C_ENABLE) && (old_state != C_UNBLANK)) {
+			fbi->state = C_UNBLANK;
+			pxafb_setup_gpio(fbi);
+			pxafb_enable_controller(fbi);
+			__pxafb_lcd_power(fbi, 1);
+			__pxafb_backlight_power(fbi, 1);
+			if (fbi->set_overlay_ctrlr_state)
+				fbi->set_overlay_ctrlr_state(fbi, C_UNBLANK);
+		}
+		break;
+
 	}
 	mutex_unlock(&fbi->ctrlr_lock);
 }
@@ -1362,6 +1397,8 @@ static void pxafb_decode_mode_info(struct pxafb_info *fbi,
 		if (smemlen > fbi->fb.fix.smem_len)
 			fbi->fb.fix.smem_len = smemlen;
 	}
+
+	fbi->set_overlay_ctrlr_state = NULL;
 }
 
 static void pxafb_decode_mach_info(struct pxafb_info *fbi,
@@ -1839,6 +1876,10 @@ static int __devinit pxafb_probe(struct platform_device *dev)
 				CPUFREQ_POLICY_NOTIFIER);
 #endif
 
+#ifdef CONFIG_FB_PXA_OVERLAY
+	pxafb_overlay_probe(&dev->dev);
+#endif
+
 	/*
 	 * Ok, now enable the LCD controller
 	 */
diff --git a/drivers/video/pxafb.h b/drivers/video/pxafb.h
index 31541b8..16b12f4 100644
--- a/drivers/video/pxafb.h
+++ b/drivers/video/pxafb.h
@@ -61,6 +61,56 @@ struct pxafb_dma_buff {
 	struct pxafb_dma_descriptor dma_desc[DMA_MAX];
 };
 
+#ifdef CONFIG_FB_PXA_OVERLAY
+struct overlayfb_info
+{
+	struct fb_info		fb;
+
+	struct fb_var_screeninfo old_var;
+
+	atomic_t		refcount;
+
+	u_char *		map_cpu;
+	u_char *		screen_cpu;
+	u_int *			palette_cpu;
+	unsigned long		map_size;
+	unsigned long		palette_size;
+	ssize_t			video_offset;
+
+	dma_addr_t		screen_dma;
+	dma_addr_t		map_dma;
+	dma_addr_t		palette_dma;
+
+	volatile u_char		state;
+
+	/* Overlay specific info */
+	unsigned long		xpos;		/* screen position (x, y) */
+	unsigned long		ypos;
+	unsigned long		format;
+
+	/* Additional */
+	union {
+		struct pxafb_dma_descriptor *dma0;
+		struct pxafb_dma_descriptor *dma1;
+		struct {
+			struct pxafb_dma_descriptor *dma2;
+			struct pxafb_dma_descriptor *dma3;
+			struct pxafb_dma_descriptor *dma4;
+		};
+		struct {
+			struct pxafb_dma_descriptor *dma5_pal;
+			struct pxafb_dma_descriptor *dma5_frame;
+		};
+	};
+};
+
+#define o1_to_basefb(d)		container_of(d, struct pxafb_info, overlay1fb)
+#define o2_to_basefb(d)		container_of(d, struct pxafb_info, overlay2fb)
+#define cu_to_basefb(d)		container_of(d, struct pxafb_info, cursorfb)
+
+extern void pxafb_overlay_probe(struct device *dev);
+#endif
+
 struct pxafb_info {
 	struct fb_info		fb;
 	struct device		*dev;
@@ -120,6 +170,13 @@ struct pxafb_info {
 	struct task_struct	*smart_thread;
 #endif
 
+#ifdef CONFIG_FB_PXA_OVERLAY
+	struct overlayfb_info	overlay1fb;
+	struct overlayfb_info	overlay2fb;
+	struct overlayfb_info	cursorfb;
+#endif
+	void (*set_overlay_ctrlr_state)(struct pxafb_info *, u_int);
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 	struct notifier_block	freq_policy;
@@ -139,6 +196,11 @@ struct pxafb_info {
 #define C_DISABLE_PM		(5)
 #define C_ENABLE_PM		(6)
 #define C_STARTUP		(7)
+#define C_BLANK  		(8)
+#define C_UNBLANK		(9)
+
+extern void set_ctrlr_state(struct pxafb_info *fbi, u_int state);
+
 
 #define PXA_NAME	"PXA"
 
@@ -148,4 +210,16 @@ struct pxafb_info {
 #define MIN_XRES	64
 #define MIN_YRES	64
 
+static inline unsigned long
+lcd_readl(struct pxafb_info *fbi, unsigned int off)
+{
+	return __raw_readl(fbi->mmio_base + off);
+}
+
+static inline void
+lcd_writel(struct pxafb_info *fbi, unsigned int off, unsigned long val)
+{
+	__raw_writel(val, fbi->mmio_base + off);
+}
+
 #endif /* __PXAFB_H__ */
diff --git a/drivers/video/pxafb_overlay.c b/drivers/video/pxafb_overlay.c
new file mode 100644
index 0000000..25935b5
--- /dev/null
+++ b/drivers/video/pxafb_overlay.c
@@ -0,0 +1,1476 @@
+/*
+ *  linux/drivers/video/pxafb_overlay.c
+ *
+ *  Copyright (c) 2004, Intel Corporation
+ *
+ * 	Code Status:
+ * 	2008/07/21: Rodolfo Giometti <giometti@linux.it>
+ * 	- Ported to 2.6.26 kernel
+ * 	2004/10/28: <yan.yin@intel.com>
+ *      - Ported to 2.6 kernel
+ *      - Made overlay driver a loadable module
+ *      - Merged overlay optimized patch
+ * 	2004/03/10: <stanley.cai@intel.com>
+ *      - Fixed Bugs
+ *      - Added workaround for overlay1&2
+ * 	2003/08/27: <yu.tang@intel.com>
+ *      - Added Overlay 1 & Overlay2 & Hardware Cursor support
+ *
+ *
+ * 	This software program is licensed subject to the GNU Lesser General
+ * 	Public License (LGPL). Version 2.1, February 1999, available at
+ * 	http://www.gnu.org/copyleft/lesser.html
+ *
+ * 	Intel PXA27x LCD Controller Frame Buffer Overlay Driver
+ *
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/cpufreq.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <asm/hardware.h>
+#include <asm/irq.h>
+#include <asm/arch/bitfield.h>
+#include <asm/arch/pxafb.h>
+#include <asm/arch/pxa-regs.h>
+
+#include "pxafb.h"
+
+/* LCD enhancement : Overlay 1 & 2 & Hardware Cursor */
+
+/*
+ * LCD enhancement : Overlay 1
+ *
+ * Features:
+ * - support 16bpp (No palette)
+ */
+
+static int overlay1fb_enable(struct fb_info *info);
+static int overlay2fb_enable(struct fb_info *info);
+static int cursorfb_enable(struct fb_info *info);
+
+static int overlay1fb_disable(struct fb_info *info);
+static int overlay2fb_disable(struct fb_info *info);
+static int cursorfb_disable(struct fb_info *info);
+
+static int overlay1fb_blank(int blank, struct fb_info *info);
+static int overlay2fb_blank(int blank, struct fb_info *info);
+static int cursorfb_blank(int blank, struct fb_info *info);
+
+static struct pxafb_rgb def_rgb_18 = {
+	.red	= { offset: 12, length: 6, },
+	.green	= { offset: 6,  length: 6, },
+	.blue	= { offset: 0,  length: 6, },
+	.transp	= { offset: 0,  length: 0, },
+};
+
+static struct pxafb_rgb def_rgbt_16 = {
+	.red	= { offset: 10, length: 5, },
+	.green	= { offset: 5,  length: 5, },
+	.blue	= { offset: 0,  length: 5, },
+	.transp	= { offset: 15,  length: 1, },
+};
+
+static struct pxafb_rgb  def_rgbt_19 = {
+	.red	= { offset: 12, length: 6, },
+	.green	= { offset: 6,  length: 6, },
+	.blue	= { offset: 0,  length: 6, },
+	.transp	= { offset: 18, length: 1, },
+};
+
+static struct pxafb_rgb def_rgbt_24 = {
+	.red	= { offset: 16, length: 7, },
+	.green	= { offset: 8,  length: 8, },
+	.blue	= { offset: 0,  length: 8, },
+	.transp	= { offset: 0,  length: 0, },
+};
+
+static struct pxafb_rgb def_rgbt_25 = {
+	.red	= { offset: 16, length: 8, },
+	.green	= { offset: 8,  length: 8, },
+	.blue	= { offset: 0,  length: 8, },
+	.transp	= { offset: 24, length: 1, },
+};
+
+#define CLEAR_LCD_INTR(reg, intr) do {  \
+	reg = (intr);			\
+} while (0)
+
+#define WAIT_FOR_LCD_INTR(bfi, reg, intr, timeout) ({		\
+	int __done = 0;						\
+	int __t = timeout;					\
+	while (__t) {						\
+		__done = lcd_readl(bfi, reg) & (intr);		\
+		if (__done)					\
+			break;					\
+		mdelay(10);					\
+		__t--;						\
+	}							\
+	if (!__t)						\
+		dev_info(bfi->dev, "wait " #intr " timeount");	\
+	__done;							\
+})
+
+#define DISABLE_OVERLAYS(fbi) do {	 				\
+	if (fbi->overlay1fb.state == C_ENABLE)				\
+		overlay1fb_disable((struct fb_info *) &fbi->overlay1fb);\
+	if (fbi->overlay2fb.state == C_ENABLE)				\
+		overlay2fb_disable((struct fb_info *) &fbi->overlay2fb);\
+	if (fbi->cursorfb.state == C_ENABLE)				\
+		cursorfb_disable((struct fb_info *) &fbi->cursorfb);	\
+} while (0)
+
+#define ENABLE_OVERLAYS(fbi) do {					\
+	if (fbi->overlay1fb.state == C_DISABLE)				\
+		overlay1fb_enable((struct fb_info *) &fbi->overlay1fb);	\
+	if (fbi->overlay2fb.state == C_DISABLE)				\
+		overlay2fb_enable((struct fb_info *) &fbi->overlay2fb);	\
+	if (fbi->cursorfb.state == C_DISABLE)				\
+		cursorfb_enable((struct fb_info *) &fbi->cursorfb);	\
+} while (0)
+
+#define BLANK_OVERLAYS(fbi) do {	 				\
+	if (fbi->overlay1fb.state == C_ENABLE) {			\
+		overlay1fb_disable((struct fb_info *) &fbi->overlay1fb);\
+		fbi->overlay1fb.state = C_BLANK;			\
+	}								\
+	if (fbi->overlay2fb.state == C_ENABLE) {			\
+		overlay2fb_disable((struct fb_info *) &fbi->overlay2fb);\
+		fbi->overlay2fb.state = C_BLANK;			\
+	}								\
+	if (fbi->cursorfb.state == C_ENABLE) {				\
+		cursorfb_disable((struct fb_info *) &fbi->cursorfb);	\
+		fbi->cursorfb.state = C_BLANK;				\
+	}								\
+} while (0)
+
+#define UNBLANK_OVERLAYS(fbi) do {					\
+	if (fbi->overlay1fb.state == C_BLANK) {				\
+		overlay1fb_enable((struct fb_info *) &fbi->overlay1fb);	\
+		fbi->overlay1fb.state = C_ENABLE;			\
+	}								\
+	if (fbi->overlay2fb.state == C_BLANK) {				\
+		overlay2fb_enable((struct fb_info *) &fbi->overlay2fb);	\
+		fbi->overlay2fb.state = C_ENABLE;			\
+	}								\
+	if (fbi->cursorfb.state == C_BLANK) {				\
+		cursorfb_enable((struct fb_info *) &fbi->cursorfb);	\
+		fbi->cursorfb.state = C_ENABLE;				\
+	}								\
+} while (0)
+
+static int overlay1fb_open(struct fb_info *info, int user)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	int ret = 0;
+
+	if (!atomic_dec_and_test(&fbi->refcount)) {
+		atomic_inc(&fbi->refcount);
+		return -EACCES;
+	}
+
+	/* If basefb is disable, enable fb */
+	if (o1_to_basefb(fbi)->state != C_ENABLE)
+		o1_to_basefb(fbi)->fb.fbops->fb_blank(VESA_NO_BLANKING,
+				(struct fb_info *) o1_to_basefb(fbi));
+
+	/* Initialize the variables in overlay1 framebuffer */
+	fbi->fb.var.xres = fbi->fb.var.yres = 0;
+	fbi->fb.var.bits_per_pixel = 0;
+
+	return ret;
+}
+
+static int overlay1fb_release(struct fb_info *info, int user)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+
+	/* Disable overlay when released */
+	overlay1fb_blank(1, info);
+
+	atomic_inc(&fbi->refcount);
+
+	return 0;
+}
+
+static int overlay1fb_map_video_memory(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+
+	if (fbi->map_cpu)
+		dma_free_writecombine(o1_to_basefb(fbi)->dev, fbi->map_size,
+					(void *) fbi->map_cpu, fbi->map_dma);
+	fbi->video_offset = PAGE_ALIGN(sizeof(struct pxafb_dma_descriptor));
+	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + fbi->video_offset);
+	fbi->map_cpu = dma_alloc_writecombine(o1_to_basefb(fbi)->dev,
+						fbi->map_size, &fbi->map_dma,
+						GFP_KERNEL);
+	if (!fbi->map_cpu)
+		return -ENOMEM;
+
+	/* Prevent initial garbage on screen */
+	memset(fbi->map_cpu, 0, fbi->map_size);
+	fbi->fb.screen_base = fbi->map_cpu + fbi->video_offset;
+	fbi->screen_cpu = fbi->map_cpu + fbi->video_offset;
+	fbi->screen_dma = fbi->map_dma + fbi->video_offset;
+
+	fbi->fb.fix.smem_start = fbi->screen_dma;
+
+	/* Setup dma descriptor */
+	fbi->dma1 = (struct pxafb_dma_descriptor *)
+		(fbi->screen_cpu - sizeof(struct pxafb_dma_descriptor));
+
+	fbi->dma1->fdadr = (fbi->screen_dma -
+				sizeof(struct pxafb_dma_descriptor));
+	fbi->dma1->fsadr = fbi->screen_dma;
+	fbi->dma1->fidr  = 0;
+	fbi->dma1->ldcmd = fbi->fb.fix.smem_len;
+
+	return 0;
+}
+
+static int overlay1fb_enable(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+
+	unsigned long bpp1;
+	unsigned int lccr5;
+
+	if (!fbi->map_cpu)
+		return -EINVAL;
+
+	switch (fbi->fb.var.bits_per_pixel) {
+	case 16:
+		bpp1 = 0x4;
+		break;
+	case 18:
+		bpp1 = 0x6;
+		break;
+	case 19:
+		bpp1 = 0x8;
+		break;
+	case 24:
+		bpp1 = 0x9;
+		break;
+	case 25:
+		bpp1 = 0xa;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Disable branch/start/end of frame interrupt */
+	lccr5 = lcd_readl(o1_to_basefb(fbi), LCCR5);
+	lcd_writel(o1_to_basefb(fbi), LCCR5,
+				lccr5 | LCCR5_IUM(1) | LCCR5_BSM(1)
+					| LCCR5_EOFM(1) | LCCR5_SOFM(1));
+
+	if (fbi->state == C_DISABLE || fbi->state == C_BLANK)
+		lcd_writel(o1_to_basefb(fbi), FDADR1, fbi->dma1->fdadr);
+	else
+		lcd_writel(o1_to_basefb(fbi), DFBR1, fbi->dma1->fdadr | 0x1);
+
+	/* Enable overlay 1 window */
+	lcd_writel(o1_to_basefb(fbi), OVL1C2,
+				(fbi->ypos << 10) | fbi->xpos);;
+	lcd_writel(o1_to_basefb(fbi), OVL1C1,
+				OVL1C1_O1EN | (bpp1 << 20) |
+				((fbi->fb.var.yres-1)<<10) |
+				(fbi->fb.var.xres-1));
+
+	fbi->state = C_ENABLE;
+
+	return 0;
+}
+
+static int overlay1fb_disable(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	int done;
+	unsigned int ovl1c1;
+
+	if ((fbi->state == C_DISABLE) || (fbi->state == C_BLANK))
+		return 0;
+
+	fbi->state = C_DISABLE;
+
+	/* Clear O1EN */
+	ovl1c1 = lcd_readl(o1_to_basefb(fbi), OVL1C1);
+	lcd_writel(o1_to_basefb(fbi), OVL1C1, ovl1c1 & ~OVL1C1_O1EN);
+
+	lcd_writel(o1_to_basefb(fbi), LCSR1, LCSR1_BS(1));
+	lcd_writel(o1_to_basefb(fbi), DFBR1, 0x3);
+	done = WAIT_FOR_LCD_INTR(o1_to_basefb(fbi), LCSR1, LCSR1_BS(1), 100);
+
+	if (!done) {
+		dev_info(o1_to_basefb(fbi)->dev, "%s: timeout\n", __func__);
+		return -1;
+	}
+	return 0;
+}
+
+static int overlay1fb_blank(int blank, struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	int err = 0;
+
+	switch (blank) {
+	case 0:
+		err = overlay1fb_enable(info);
+		if (err) {
+			fbi->state = C_DISABLE;
+			set_ctrlr_state(o1_to_basefb(fbi), C_REENABLE);
+		}
+		break;
+	case 1:
+		err = overlay1fb_disable(info);
+		if (err) {
+			fbi->state = C_DISABLE;
+			set_ctrlr_state(o1_to_basefb(fbi), C_REENABLE);
+		}
+		break;
+	}
+
+	return err;
+}
+
+static int overlay1fb_check_var(struct fb_var_screeninfo *var,
+						struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	int xpos, ypos;
+
+	/* Must in base frame */
+	xpos = var->nonstd & 0x3ff;
+	ypos = (var->nonstd>>10) & 0x3ff;
+
+	if ((xpos + var->xres) > o1_to_basefb(fbi)->fb.var.xres)
+		return -EINVAL;
+
+	if ((ypos + var->yres) > o1_to_basefb(fbi)->fb.var.yres)
+		return -EINVAL;
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		if (var->xres & 0x1) {
+			dev_err(o1_to_basefb(fbi)->dev,
+				"xres should be a multiple of 2 pixels!\n");
+			return -EINVAL;
+		}
+		break;
+	case 18:
+	case 19:
+		if (var->xres & 0x7) {
+			dev_err(o1_to_basefb(fbi)->dev,
+				"xres should be a multiple of 8 pixels!\n");
+			return -EINVAL;
+		}
+		break;
+	}
+
+	fbi->old_var = *var;
+
+	var->activate = FB_ACTIVATE_NOW;
+
+	return 0;
+}
+
+static int overlay1fb_set_par(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	struct fb_var_screeninfo *var = &fbi->fb.var;
+	int nbytes = 0, err = 0, pixels_per_line = 0;
+
+	info->flags &= ~FBINFO_MISC_USEREVENT;
+
+	if (fbi->state == C_BLANK)
+		return 0;
+
+	if (fbi->state == C_DISABLE)
+		goto out1;
+
+	/* Only xpos & ypos change */
+	if ((var->xres == fbi->old_var.xres) &&
+		(var->yres == fbi->old_var.yres) &&
+		(var->bits_per_pixel == fbi->old_var.bits_per_pixel))
+		goto out2;
+
+out1:
+	switch (var->bits_per_pixel) {
+	case 16:
+		/* 2 pixels per line */
+		pixels_per_line = (fbi->fb.var.xres + 0x1) & (~0x1);
+		nbytes = 2;
+
+		var->red    = def_rgbt_16.red;
+		var->green  = def_rgbt_16.green;
+		var->blue   = def_rgbt_16.blue;
+		var->transp = def_rgbt_16.transp;
+
+		break;
+	case 18:
+		/* 8 pixels per line */
+		pixels_per_line = (fbi->fb.var.xres + 0x7) & (~0x7);
+		nbytes = 3;
+
+		var->red    = def_rgb_18.red;
+		var->green  = def_rgb_18.green;
+		var->blue   = def_rgb_18.blue;
+		var->transp = def_rgb_18.transp;
+
+		break;
+	case 19:
+		/* 8 pixels per line */
+		pixels_per_line = (fbi->fb.var.xres + 0x7) & (~0x7);
+		nbytes = 3;
+
+		var->red    = def_rgbt_19.red;
+		var->green  = def_rgbt_19.green;
+		var->blue   = def_rgbt_19.blue;
+		var->transp = def_rgbt_19.transp;
+
+		break;
+	case 24:
+		pixels_per_line = fbi->fb.var.xres;
+		nbytes = 4;
+
+		var->red    = def_rgbt_24.red;
+		var->green  = def_rgbt_24.green;
+		var->blue   = def_rgbt_24.blue;
+		var->transp = def_rgbt_24.transp;
+
+		break;
+	case 25:
+		pixels_per_line = fbi->fb.var.xres;
+		nbytes = 4;
+
+		var->red    = def_rgbt_25.red;
+		var->green  = def_rgbt_25.green;
+		var->blue   = def_rgbt_25.blue;
+		var->transp = def_rgbt_25.transp;
+
+		break;
+	}
+
+	fbi->fb.fix.line_length = nbytes * pixels_per_line;
+	fbi->fb.fix.smem_len = fbi->fb.fix.line_length * fbi->fb.var.yres;
+
+	err = overlay1fb_map_video_memory(info);
+	if (err)
+		return err;
+
+out2:
+	fbi->xpos = var->nonstd & 0x3ff;
+	fbi->ypos = (var->nonstd>>10) & 0x3ff;
+
+	overlay1fb_enable(info);
+
+	return 0;
+}
+
+static int overlay1fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+
+	if (off < info->fix.smem_len) {
+		vma->vm_pgoff += fbi->video_offset / PAGE_SIZE;
+		return dma_mmap_writecombine(o1_to_basefb(fbi)->dev, vma,
+					     fbi->map_cpu, fbi->map_dma,
+					     fbi->map_size);
+	}
+	return -EINVAL;
+}
+
+static struct fb_ops overlay1fb_ops = {
+	.owner			= THIS_MODULE,
+	.fb_open		= overlay1fb_open,
+	.fb_release		= overlay1fb_release,
+	.fb_check_var 		= overlay1fb_check_var,
+	.fb_set_par		= overlay1fb_set_par,
+	.fb_blank		= overlay1fb_blank,
+	.fb_fillrect		= cfb_fillrect,
+	.fb_copyarea		= cfb_copyarea,
+	.fb_imageblit		= cfb_imageblit,
+	.fb_mmap		= overlay1fb_mmap,
+};
+
+/*
+ * LCD enhancement : Overlay 2
+ *
+ * Features:
+ * - support planar YCbCr420/YCbCr422/YCbCr444;
+ */
+static int overlay2fb_open(struct fb_info *info, int user)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+
+	if (!atomic_dec_and_test(&fbi->refcount)) {
+		atomic_inc(&fbi->refcount);
+		return -EACCES;
+	}
+
+	/* If basefb is disable, enable fb */
+	if (o2_to_basefb(fbi)->state != C_ENABLE)
+		o2_to_basefb(fbi)->fb.fbops->fb_blank(VESA_NO_BLANKING,
+				(struct fb_info *) o2_to_basefb(fbi));
+
+	fbi->fb.var.xres = fbi->fb.var.yres = 0;
+
+	return 0;
+}
+
+static int overlay2fb_release(struct fb_info *info, int user)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+
+	/* Disable overlay when released */
+	overlay2fb_blank(1, info);
+
+	atomic_inc(&fbi->refcount);
+
+	return 0;
+}
+
+static int overlay2fb_map_YUV_memory(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned int ylen, cblen, crlen, aylen, acblen, acrlen;
+	unsigned int yoff, cboff, croff;
+	unsigned int xres, yres;
+	unsigned int nbytes;
+
+	ylen = cblen = crlen = aylen = acblen = acrlen = 0;
+	yoff = cboff = croff = 0;
+
+	if (fbi->map_cpu)
+		dma_free_writecombine(o2_to_basefb(fbi)->dev, fbi->map_size,
+					fbi->map_cpu, fbi->map_dma);
+
+	yres = fbi->fb.var.yres;
+
+	switch (fbi->format) {
+	case 0x4: /* YCbCr 4:2:0 planar */
+		dev_dbg(o2_to_basefb(fbi)->dev, "420 planar\n");
+		/* 16 pixels per line */
+		xres = (fbi->fb.var.xres + 0xf) & (~0xf);
+		fbi->fb.fix.line_length = xres;
+
+		nbytes = xres * yres;
+		ylen = nbytes;
+		cblen = crlen = (nbytes/4);
+
+		break;
+	case 0x3: /* YCbCr 4:2:2 planar */
+		/* 8 pixles per line */
+		dev_dbg(o2_to_basefb(fbi)->dev, "422 planar\n");
+		xres = (fbi->fb.var.xres + 0x7) & (~0x7);
+		fbi->fb.fix.line_length = xres;
+
+		nbytes = xres * yres;
+		ylen  = nbytes;
+		cblen = crlen = (nbytes/2);
+
+		break;
+	case 0x2: /* YCbCr 4:4:4 planar */
+		/* 4 pixels per line */
+		dev_dbg(o2_to_basefb(fbi)->dev, "444 planar\n");
+		xres = (fbi->fb.var.xres + 0x3) & (~0x3);
+		fbi->fb.fix.line_length = xres;
+
+		nbytes = xres * yres;
+		ylen  = cblen = crlen = nbytes;
+		break;
+	}
+
+	/* 16-bytes alignment for DMA */
+	aylen  = (ylen + 0xf) & (~0xf);
+	acblen = (cblen + 0xf) & (~0xf);
+	acrlen = (crlen + 0xf) & (~0xf);
+
+	fbi->fb.fix.smem_len = aylen + acblen + acrlen;
+
+	/* Alloc memory */
+
+	fbi->video_offset = PAGE_ALIGN(sizeof(struct pxafb_dma_descriptor));
+	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + fbi->video_offset);
+	fbi->map_cpu = dma_alloc_writecombine(o2_to_basefb(fbi)->dev,
+						fbi->map_size, &fbi->map_dma,
+						GFP_KERNEL);
+	if (!fbi->map_cpu)
+		return -ENOMEM;
+
+	/* Prevent initial garbage on screen */
+	memset(fbi->map_cpu, 0, fbi->map_size);
+	fbi->fb.screen_base = fbi->map_cpu + fbi->video_offset;
+	fbi->screen_cpu = fbi->map_cpu + fbi->video_offset;
+	fbi->screen_dma = fbi->map_dma + fbi->video_offset;
+
+	fbi->fb.fix.smem_start = fbi->screen_dma;
+
+	/* Setup dma for Planar format */
+	fbi->dma2 = (struct pxafb_dma_descriptor *)
+		(fbi->screen_cpu - sizeof(struct pxafb_dma_descriptor));
+	fbi->dma3 = fbi->dma2 - 1;
+	fbi->dma4 = fbi->dma3 - 1;
+
+	/* Offset */
+	yoff = 0;
+	cboff = aylen;
+	croff = cboff + acblen;
+
+	/* Y vector */
+	fbi->dma2->fdadr = (fbi->screen_dma -
+				sizeof(struct pxafb_dma_descriptor));
+	fbi->dma2->fsadr = fbi->screen_dma + yoff;
+	fbi->dma2->fidr  = 0;
+	fbi->dma2->ldcmd = ylen;
+
+	/* Cb vector */
+	fbi->dma3->fdadr = (fbi->dma2->fdadr -
+				sizeof(struct pxafb_dma_descriptor));
+	fbi->dma3->fsadr = fbi->screen_dma + cboff;
+	fbi->dma3->fidr  = 0;
+	fbi->dma3->ldcmd = cblen;
+
+	/* Cr vector */
+
+	fbi->dma4->fdadr = (fbi->dma3->fdadr -
+				sizeof(struct pxafb_dma_descriptor));
+	fbi->dma4->fsadr = fbi->screen_dma + croff;
+	fbi->dma4->fidr  = 0;
+	fbi->dma4->ldcmd = crlen;
+
+	/* Adjust for user */
+	fbi->fb.var.red.length   = ylen;
+	fbi->fb.var.red.offset   = yoff;
+	fbi->fb.var.green.length = cblen;
+	fbi->fb.var.green.offset = cboff;
+	fbi->fb.var.blue.length  = crlen;
+	fbi->fb.var.blue.offset  = croff;
+
+	return 0;
+};
+
+static int overlay2fb_map_RGB_memory(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	struct fb_var_screeninfo *var = &fbi->fb.var;
+	int pixels_per_line = 0 , nbytes = 0;
+
+	if (fbi->map_cpu)
+		dma_free_writecombine(o2_to_basefb(fbi)->dev, fbi->map_size,
+					fbi->map_cpu, fbi->map_dma);
+
+	switch (var->bits_per_pixel) {
+	case 16:
+		/* 2 pixels per line */
+		pixels_per_line = (fbi->fb.var.xres + 0x1) & (~0x1);
+		nbytes = 2;
+
+		var->red    = def_rgbt_16.red;
+		var->green  = def_rgbt_16.green;
+		var->blue   = def_rgbt_16.blue;
+		var->transp = def_rgbt_16.transp;
+		break;
+
+	case 18:
+		/* 8 pixels per line */
+		pixels_per_line = (fbi->fb.var.xres + 0x7) & (~0x7);
+		nbytes = 3;
+
+		var->red    = def_rgb_18.red;
+		var->green  = def_rgb_18.green;
+		var->blue   = def_rgb_18.blue;
+		var->transp = def_rgb_18.transp;
+
+		break;
+	case 19:
+		/* 8 pixels per line */
+		pixels_per_line = (fbi->fb.var.xres + 0x7) & (~0x7);
+		nbytes = 3;
+
+		var->red    = def_rgbt_19.red;
+		var->green  = def_rgbt_19.green;
+		var->blue   = def_rgbt_19.blue;
+		var->transp = def_rgbt_19.transp;
+
+		break;
+	case 24:
+		pixels_per_line = fbi->fb.var.xres;
+		nbytes = 4;
+
+		var->red    = def_rgbt_24.red;
+		var->green  = def_rgbt_24.green;
+		var->blue   = def_rgbt_24.blue;
+		var->transp = def_rgbt_24.transp;
+
+		break;
+
+	case 25:
+		pixels_per_line = fbi->fb.var.xres;
+		nbytes = 4;
+
+		var->red    = def_rgbt_25.red;
+		var->green  = def_rgbt_25.green;
+		var->blue   = def_rgbt_25.blue;
+		var->transp = def_rgbt_25.transp;
+
+		break;
+	}
+
+	fbi->fb.fix.line_length = nbytes * pixels_per_line ;
+	fbi->fb.fix.smem_len = fbi->fb.fix.line_length * fbi->fb.var.yres ;
+
+	fbi->video_offset = PAGE_ALIGN(sizeof(struct pxafb_dma_descriptor));
+	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + fbi->video_offset);
+	fbi->map_cpu = dma_alloc_writecombine(o2_to_basefb(fbi)->dev,
+						fbi->map_size, &fbi->map_dma,
+						GFP_KERNEL);
+	if (!fbi->map_cpu)
+		return -ENOMEM;
+
+	/* Prevent initial garbage on screen */
+	memset(fbi->map_cpu, 0, fbi->map_size);
+	fbi->fb.screen_base = fbi->map_cpu + fbi->video_offset;
+	fbi->screen_cpu = fbi->map_cpu + fbi->video_offset;
+	fbi->screen_dma = fbi->map_dma + fbi->video_offset;
+
+	fbi->fb.fix.smem_start = fbi->screen_dma;
+
+	/* Setup dma descriptor */
+	fbi->dma2 = (struct pxafb_dma_descriptor *)
+		(fbi->screen_cpu - sizeof(struct pxafb_dma_descriptor));
+
+	fbi->dma2->fdadr = (fbi->screen_dma -
+				sizeof(struct pxafb_dma_descriptor));
+	fbi->dma2->fsadr = fbi->screen_dma;
+	fbi->dma2->fidr  = 0;
+	fbi->dma2->ldcmd = fbi->fb.fix.smem_len;
+
+	return 0;
+}
+
+static int overlay2fb_enable(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned long bpp2;
+	unsigned int xres, yres;
+	unsigned int lccr5;
+
+	if (!fbi->map_cpu)
+		return -EINVAL;
+
+	switch (fbi->fb.var.bits_per_pixel) {
+	case 16:
+		bpp2 = 0x4;
+		break;
+	case 18:
+		bpp2 = 0x6;
+		break;
+	case 19:
+		bpp2 = 0x8;
+		break;
+	case 24:
+		bpp2 = 0x9;
+		break;
+	case 25:
+		bpp2 = 0xa;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Disable branch/start/end of frame interrupt */
+	lccr5 = lcd_readl(o2_to_basefb(fbi), LCCR5);
+	lcd_writel(o2_to_basefb(fbi), LCCR5, lccr5
+			| LCCR5_IUM(4) | LCCR5_IUM(3) | LCCR5_IUM(2)
+			| LCCR5_BSM(4) | LCCR5_BSM(3) | LCCR5_BSM(2)
+			| LCCR5_EOFM(4) | LCCR5_EOFM(3) | LCCR5_EOFM(2)
+			| LCCR5_SOFM(4) | LCCR5_SOFM(3) | LCCR5_SOFM(2));
+
+	if (fbi->format == 0) {
+		/* Overlay2 RGB resolution, RGB and YUV have different
+		 * xres value
+		 */
+		xres = fbi->fb.var.xres;
+		yres = fbi->fb.var.yres;
+
+		lcd_writel(o2_to_basefb(fbi), OVL2C2,
+			(fbi->format << 20) | (fbi->ypos << 10) | fbi->xpos);
+		lcd_writel(o2_to_basefb(fbi), OVL2C1,
+			OVL2C1_O2EN | (bpp2 << 20) | ((yres-1)<<10) | (xres-1));
+
+		/* Setup RGB DMA */
+		if (fbi->state == C_DISABLE || fbi->state == C_BLANK)
+			lcd_writel(o2_to_basefb(fbi), FDADR2,
+						fbi->dma2->fdadr);
+		else
+			lcd_writel(o2_to_basefb(fbi), DFBR2,
+						fbi->dma2->fdadr | 0x1);
+	} else {
+		/* Overlay2 YUV resolution */
+		xres = fbi->fb.fix.line_length;
+		yres = fbi->fb.var.yres;
+
+		lcd_writel(o2_to_basefb(fbi), OVL2C2,
+			(fbi->format << 20) | (fbi->ypos << 10) | fbi->xpos);
+		lcd_writel(o2_to_basefb(fbi), OVL2C1,
+			OVL2C1_O2EN | (bpp2 << 20) | ((yres-1)<<10) | (xres-1));
+
+		if (fbi->state == C_DISABLE || fbi->state == C_BLANK) {
+			lcd_writel(o2_to_basefb(fbi), FDADR2,
+						fbi->dma2->fdadr);
+			lcd_writel(o2_to_basefb(fbi), FDADR3,
+						fbi->dma3->fdadr);
+			lcd_writel(o2_to_basefb(fbi), FDADR4,
+						fbi->dma4->fdadr);
+		} else {
+			lcd_writel(o2_to_basefb(fbi), DFBR2,
+						fbi->dma2->fdadr | 0x01);
+			lcd_writel(o2_to_basefb(fbi), DFBR3,
+						fbi->dma3->fdadr | 0x01);
+			lcd_writel(o2_to_basefb(fbi), DFBR4,
+						fbi->dma4->fdadr | 0x01);
+		}
+	}
+
+	fbi->state = C_ENABLE;
+	return 0;
+}
+
+static int overlay2fb_disable(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned int ovl2c1;
+	int done;
+
+	if (fbi->state == C_DISABLE)
+		return 0;
+	if (fbi->state == C_BLANK) {
+		fbi->state = C_DISABLE;
+		return 0;
+	}
+
+	fbi->state = C_DISABLE;
+
+	/* Clear O2EN */
+	ovl2c1 = lcd_readl(o2_to_basefb(fbi), OVL2C1);
+	lcd_writel(o2_to_basefb(fbi), OVL2C1, ovl2c1 & ~OVL2C1_O2EN);
+
+	/* Make overlay2 can't disable/enable correctly sometimes */
+	lcd_writel(o2_to_basefb(fbi), LCSR1, LCSR1_BS(2));
+
+	if (fbi->format == 0)
+		lcd_writel(o2_to_basefb(fbi), DFBR2, 0x3);
+	else {
+		lcd_writel(o2_to_basefb(fbi), DFBR2, 0x3);
+		lcd_writel(o2_to_basefb(fbi), DFBR3, 0x3);
+		lcd_writel(o2_to_basefb(fbi), DFBR4, 0x3);
+	}
+
+	done = WAIT_FOR_LCD_INTR(o2_to_basefb(fbi), LCSR1, LCSR1_BS(2), 100);
+	if (!done) {
+		dev_info(o2_to_basefb(fbi)->dev, "%s: timeout\n", __func__);
+		return -1;
+	}
+	return 0;
+}
+
+static int overlay2fb_blank(int blank, struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	int err = 0;
+
+	switch (blank) {
+	case 0:
+		err = overlay2fb_enable(info);
+		if (err) {
+			fbi->state = C_DISABLE;
+			set_ctrlr_state(o2_to_basefb(fbi), C_REENABLE);
+		}
+		break;
+	case 1:
+		err = overlay2fb_disable(info);
+		if (err) {
+			fbi->state = C_DISABLE;
+			set_ctrlr_state(o2_to_basefb(fbi), C_REENABLE);
+		}
+		break;
+	}
+
+	return err;
+}
+
+
+static int overlay2fb_check_var(struct fb_var_screeninfo *var,
+						struct fb_info *info)
+{
+	int xpos, ypos, xres, yres;
+	int format;
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+
+	xres = yres = 0;
+
+	xpos = (var->nonstd & 0x3ff);
+	ypos = (var->nonstd >> 10) & 0x3ff;
+	format = (var->nonstd >> 20) & 0x7;
+
+
+	/* Palnar YCbCr444, YCbCr422, YCbCr420 */
+	if ((format != 0x4) && (format != 0x3) &&
+		(format != 0x2) && (format != 0x0))
+		return -EINVAL;
+
+	/* Dummy pixels */
+	switch (format) {
+	case 0x0: /* RGB */
+		xres = var->xres;
+		break;
+	case 0x2: /* 444 */
+		xres = (var->xres + 0x3) & ~(0x3);
+		break;
+	case 0x3: /* 422 */
+		xres = (var->xres + 0x7) & ~(0x7);
+		break;
+	case 0x4: /* 420 */
+		xres = (var->xres + 0xf) & ~(0xf);
+		break;
+	}
+	yres = var->yres;
+
+	if ((xpos + xres) > o2_to_basefb(fbi)->fb.var.xres)
+		return -EINVAL;
+
+	if ((ypos + yres) > o2_to_basefb(fbi)->fb.var.yres)
+		return -EINVAL;
+
+	fbi->old_var = *var;
+
+	var->activate = FB_ACTIVATE_NOW;
+
+	return 0;
+
+}
+
+
+/*
+ * overlay2fb_set_var()
+ *
+ * var.nonstd is used as YCbCr format.
+ * var.red/green/blue is used as (Y/Cb/Cr) vector
+ */
+
+static int overlay2fb_set_par(struct fb_info *info)
+{
+	unsigned int xpos, ypos;
+	int format, err;
+
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	struct fb_var_screeninfo *var = &fbi->fb.var;
+
+	info->flags &= ~FBINFO_MISC_USEREVENT;
+
+	if (fbi->state == C_BLANK)
+		return 0;
+
+	if (fbi->state == C_DISABLE)
+		goto out1;
+
+	if ((var->xres == fbi->old_var.xres) &&
+		(var->yres == fbi->old_var.yres) &&
+		(var->bits_per_pixel == fbi->old_var.bits_per_pixel) &&
+		(((var->nonstd>>20) & 0x7) == fbi->format))
+		goto out2;
+
+out1:
+	xpos = var->nonstd & 0x3ff;
+	ypos = (var->nonstd>>10) & 0x3ff;
+	format = (var->nonstd>>20) & 0x7;
+
+
+	fbi->format = format;
+	if (fbi->format == 0)
+		err = overlay2fb_map_RGB_memory(info);
+	else
+		err = overlay2fb_map_YUV_memory(info);
+
+	if (err)
+		return err;
+
+out2:
+	/* Position */
+	fbi->xpos = var->nonstd & 0x3ff;
+	fbi->ypos = (var->nonstd>>10) & 0x3ff;
+
+	overlay2fb_enable(info);
+
+	return 0;
+}
+
+static int overlay2fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+
+	if (off < info->fix.smem_len) {
+		vma->vm_pgoff += fbi->video_offset / PAGE_SIZE;
+		return dma_mmap_writecombine(o2_to_basefb(fbi)->dev, vma,
+					     fbi->map_cpu, fbi->map_dma,
+					     fbi->map_size);
+	}
+	return -EINVAL;
+}
+
+static struct fb_ops overlay2fb_ops = {
+	.owner			= THIS_MODULE,
+	.fb_open		= overlay2fb_open,
+	.fb_release		= overlay2fb_release,
+	.fb_check_var 		= overlay2fb_check_var,
+	.fb_set_par		= overlay2fb_set_par,
+	.fb_blank		= overlay2fb_blank,
+	.fb_fillrect		= cfb_fillrect,
+	.fb_copyarea		= cfb_copyarea,
+	.fb_imageblit		= cfb_imageblit,
+	.fb_mmap		= overlay2fb_mmap,
+};
+
+/* Hardware cursor */
+
+/* Bulverde Cursor Modes */
+struct cursorfb_mode {
+	int xres;
+	int yres;
+	int bpp;
+};
+
+static struct cursorfb_mode cursorfb_modes[] = {
+	{ 32,  32, 2},
+	{ 32,  32, 2},
+	{ 32,  32, 2},
+	{ 64,  64, 2},
+	{ 64,  64, 2},
+	{ 64,  64, 2},
+	{128, 128, 1},
+	{128, 128, 1}
+};
+
+static int cursorfb_enable(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned int ccr, lccr4, lccr5;
+
+	if (!fbi->map_cpu)
+		return -EINVAL;
+
+	ccr = lcd_readl(cu_to_basefb(fbi), CCR);
+	lcd_writel(cu_to_basefb(fbi), CCR, ccr & ~CCR_CEN);
+
+	/* Set palette format
+	 *
+	 * FIXME: if only cursor uses palette
+	 */
+	lccr4 = lcd_readl(cu_to_basefb(fbi), LCCR4);
+	lcd_writel(cu_to_basefb(fbi), LCCR4,
+			(lccr4 & (~(0x3 << 15))) | (0x1 << 15));
+
+	/* Disable branch/start/end of frame interrupt */
+	lccr5 = lcd_readl(cu_to_basefb(fbi), LCCR5);
+	lcd_writel(cu_to_basefb(fbi), LCCR5,
+				lccr5 | LCCR5_IUM(5) | LCCR5_BSM(5)
+					| LCCR5_EOFM(5) | LCCR5_SOFM(5));
+
+	/* Load palette and frame data */
+	if (fbi->state == C_DISABLE) {
+		lcd_writel(cu_to_basefb(fbi), FDADR5,
+					fbi->dma5_pal->fdadr);
+		udelay(1);
+		lcd_writel(cu_to_basefb(fbi), FDADR5,
+					fbi->dma5_frame->fdadr);
+		udelay(1);
+
+	} else {
+		lcd_writel(cu_to_basefb(fbi), DFBR5,
+					fbi->dma5_pal->fdadr | 0x1);
+		udelay(1);
+		lcd_writel(cu_to_basefb(fbi), DFBR5,
+					fbi->dma5_frame->fdadr | 0x1);
+		udelay(1);
+	}
+
+	lcd_writel(cu_to_basefb(fbi), CCR,
+		CCR_CEN | (fbi->ypos << 15) | (fbi->xpos << 5) | (fbi->format));
+
+	fbi->state = C_ENABLE;
+
+	return 0;
+}
+
+static int cursorfb_disable(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	unsigned int ccr;
+	int done, ret = 0;
+
+	fbi->state = C_DISABLE;
+
+	done = WAIT_FOR_LCD_INTR(cu_to_basefb(fbi), LCSR1, LCSR1_BS(5), 100);
+	if (!done)
+		ret = -1;
+
+	ccr = lcd_readl(cu_to_basefb(fbi), CCR);
+	lcd_writel(cu_to_basefb(fbi), CCR, ccr & ~CCR_CEN);
+
+	return ret;
+}
+
+static int cursorfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
+		       u_int trans, struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	u_int val, ret = 1;
+	u_int *pal = fbi->palette_cpu;
+
+	/* 25bit with Transparcy for 16bpp format */
+	if (regno < fbi->palette_size) {
+		val = ((trans << 24)  & 0x1000000);
+		val |= ((red << 16)  & 0x0ff0000);
+		val |= ((green << 8) & 0x000ff00);
+		val |= ((blue << 0) & 0x00000ff);
+
+		pal[regno] = val;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+int cursorfb_blank(int blank, struct fb_info *info)
+{
+	switch (blank) {
+	case 0:
+		cursorfb_enable(info);
+		break;
+	case 1:
+		cursorfb_disable(info);
+		break;
+	}
+
+	return 0;
+}
+
+static int cursorfb_check_var(struct fb_var_screeninfo *var,
+						struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	int xpos, ypos, xres, yres;
+	int mode;
+	struct cursorfb_mode *cursor;
+
+	mode = var->nonstd & 0x7;
+	xpos = (var->nonstd>>5) & 0x3ff;
+	ypos = (var->nonstd>>15) & 0x3ff;
+
+	if (mode > 7 || mode < 0)
+		return -EINVAL;
+
+	cursor = cursorfb_modes + mode;
+
+	xres = cursor->xres;
+	yres = cursor->yres;
+
+	if ((xpos + xres) > cu_to_basefb(fbi)->fb.var.xres)
+		return -EINVAL;
+
+	if ((ypos + yres) > cu_to_basefb(fbi)->fb.var.yres)
+		return -EINVAL;
+
+	return 0;
+
+}
+
+static int cursorfb_set_par(struct fb_info *info)
+{
+	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
+	struct fb_var_screeninfo *var = &fbi->fb.var;
+	struct cursorfb_mode *cursor;
+	int mode, xpos, ypos;
+	int err;
+
+	info->flags &= ~FBINFO_MISC_USEREVENT;
+
+	mode = var->nonstd & 0x7;
+	xpos = (var->nonstd>>5) & 0x3ff;
+	ypos = (var->nonstd>>15) & 0x3ff;
+
+	if (mode != fbi->format) {
+		cursor = cursorfb_modes + mode;
+
+		/* Update "var" info */
+		fbi->fb.var.xres = cursor->xres;
+		fbi->fb.var.yres = cursor->yres;
+		fbi->fb.var.bits_per_pixel = cursor->bpp;
+
+		/* Alloc video memory
+		 *
+		 * 4k is engouh for 128x128x1 cursor,
+		 * - 2k for cursor pixels,
+		 * - 2k for palette data, plus 2 dma descriptor
+		 */
+		if (!fbi->map_cpu) {
+			fbi->map_size = PAGE_SIZE;
+			fbi->map_cpu = dma_alloc_writecombine(NULL,
+						fbi->map_size, &fbi->map_dma,
+						GFP_KERNEL);
+			if (!fbi->map_cpu)
+				return -ENOMEM;
+		}
+
+		cursor = cursorfb_modes + mode;
+
+		/* Update overlay & fix "info" */
+		fbi->screen_cpu 	= fbi->map_cpu;
+		fbi->palette_cpu 	= (u_int *)
+						fbi->map_cpu + (PAGE_SIZE/2);
+		fbi->screen_dma  	= fbi->map_dma;
+		fbi->palette_dma 	= fbi->map_dma + (PAGE_SIZE/2);
+
+		fbi->format 		= mode;
+		fbi->palette_size 	= 1 << cursor->bpp;
+		fbi->fb.fix.smem_start 	= fbi->screen_dma;
+		fbi->fb.fix.smem_len 	= cursor->xres * cursor->yres *
+						cursor->bpp / 8;
+		fbi->fb.fix.line_length = cursor->xres * cursor->bpp / 8 ;
+
+		fbi->dma5_pal     	= (struct pxafb_dma_descriptor *)
+						(fbi->map_cpu + PAGE_SIZE - 16);
+		fbi->dma5_pal->fdadr 	= fbi->map_dma + PAGE_SIZE - 16;
+		fbi->dma5_pal->fsadr 	= fbi->palette_dma;
+		fbi->dma5_pal->fidr  	= 0;
+		fbi->dma5_pal->ldcmd 	= (fbi->palette_size << 2) | LDCMD_PAL;
+
+		fbi->dma5_frame		= (struct pxafb_dma_descriptor *)
+						(fbi->map_cpu + PAGE_SIZE - 32);
+		fbi->dma5_frame->fdadr 	= fbi->map_dma + PAGE_SIZE - 32;
+		fbi->dma5_frame->fsadr 	= fbi->screen_dma;
+		fbi->dma5_frame->fidr  	= 0;
+		fbi->dma5_frame->ldcmd 	= fbi->fb.fix.smem_len;
+
+		/* Alloc & set default cmap */
+		err = fb_alloc_cmap(&fbi->fb.cmap, fbi->palette_size, 0);
+		if (err)
+			return err;
+		err = fb_set_cmap(&fbi->fb.cmap, info);
+		if (err)
+			return err;
+	}
+
+	/* Update overlay info */
+	if ((xpos != fbi->xpos) || (ypos != fbi->ypos)) {
+		fbi->xpos = xpos;
+		fbi->ypos = ypos;
+	}
+
+	cursorfb_enable(info);
+	set_ctrlr_state(cu_to_basefb(fbi), C_REENABLE);
+
+	return 0;
+}
+
+static struct fb_ops cursorfb_ops = {
+	.owner			= THIS_MODULE,
+	.fb_check_var		= cursorfb_check_var,
+	.fb_set_par		= cursorfb_set_par,
+	.fb_blank		= cursorfb_blank,
+	.fb_fillrect		= cfb_fillrect,
+	.fb_copyarea		= cfb_copyarea,
+	.fb_imageblit		= cfb_imageblit,
+	.fb_setcolreg		= cursorfb_setcolreg,
+};
+
+static void __init overlay1fb_init_fbinfo(struct overlayfb_info *fbi)
+{
+	memset(fbi, 0, sizeof(struct overlayfb_info));
+
+	atomic_set(&fbi->refcount, 1);
+	strcpy(fbi->fb.fix.id, "overlay1");
+
+	fbi->fb.fix.type	= FB_TYPE_PACKED_PIXELS;
+	fbi->fb.fix.type_aux	= 0;
+	fbi->fb.fix.xpanstep	= 0;
+	fbi->fb.fix.ypanstep	= 0;
+	fbi->fb.fix.ywrapstep	= 0;
+	fbi->fb.fix.accel	= FB_ACCEL_NONE;
+
+	fbi->fb.var.nonstd	= 0;
+	fbi->fb.var.activate	= FB_ACTIVATE_NOW;
+	fbi->fb.var.height	= -1;
+	fbi->fb.var.width	= -1;
+	fbi->fb.var.accel_flags	= 0;
+	fbi->fb.var.vmode	= FB_VMODE_NONINTERLACED;
+
+	fbi->fb.fbops		= &overlay1fb_ops;
+	fbi->fb.flags		= FBINFO_FLAG_DEFAULT;
+	fbi->fb.node		= -1;
+	fbi->fb.pseudo_palette	= NULL;
+
+	fbi->xpos   		= 0;
+	fbi->ypos   		= 0;
+	fbi->format 		= -1;
+	fbi->state 		= C_DISABLE;
+}
+
+static void __init overlay2fb_init_fbinfo(struct overlayfb_info *fbi)
+{
+	memset(fbi, 0, sizeof(struct overlayfb_info));
+
+	atomic_set(&fbi->refcount, 1);
+	strcpy(fbi->fb.fix.id, "overlay2");
+
+	fbi->fb.fix.type	= FB_TYPE_PACKED_PIXELS;
+	fbi->fb.fix.type_aux	= 0;
+	fbi->fb.fix.xpanstep	= 0;
+	fbi->fb.fix.ypanstep	= 0;
+	fbi->fb.fix.ywrapstep	= 0;
+	fbi->fb.fix.accel	= FB_ACCEL_NONE;
+
+	fbi->fb.var.nonstd	= 0;
+	fbi->fb.var.activate	= FB_ACTIVATE_NOW;
+	fbi->fb.var.height	= -1;
+	fbi->fb.var.width	= -1;
+	fbi->fb.var.accel_flags	= 0;
+	fbi->fb.var.vmode	= FB_VMODE_NONINTERLACED;
+
+	fbi->fb.fbops		= &overlay2fb_ops;
+	fbi->fb.flags		= FBINFO_FLAG_DEFAULT;
+	fbi->fb.node		= -1;
+	fbi->fb.pseudo_palette	= NULL;
+
+	fbi->xpos   		= 0;
+	fbi->ypos   		= 0;
+	fbi->format 		= -1;
+	fbi->state 		= C_DISABLE;
+}
+
+static void __init cursorfb_init_fbinfo(struct overlayfb_info *fbi)
+{
+	memset(fbi, 0, sizeof(struct overlayfb_info));
+
+	atomic_set(&fbi->refcount, 1);
+	strcpy(fbi->fb.fix.id, "cursor");
+
+	fbi->fb.fix.type	= FB_TYPE_PACKED_PIXELS;
+	fbi->fb.fix.type_aux	= 0;
+	fbi->fb.fix.xpanstep	= 0;
+	fbi->fb.fix.ypanstep	= 0;
+	fbi->fb.fix.ywrapstep	= 0;
+	fbi->fb.fix.accel	= FB_ACCEL_NONE;
+
+	fbi->fb.var.nonstd	= 0;
+	fbi->fb.var.activate	= FB_ACTIVATE_NOW;
+	fbi->fb.var.height	= -1;
+	fbi->fb.var.width	= -1;
+	fbi->fb.var.accel_flags	= 0;
+	fbi->fb.var.vmode	= FB_VMODE_NONINTERLACED;
+
+	fbi->fb.fbops		= &cursorfb_ops;
+	fbi->fb.flags		= FBINFO_FLAG_DEFAULT;
+	fbi->fb.node		= -1;
+	fbi->fb.pseudo_palette	= NULL;
+
+	fbi->xpos   		= 0;
+	fbi->ypos   		= 0;
+	fbi->format 		= -1;
+	fbi->state 		= C_DISABLE;
+}
+
+
+void pxa_set_overlay_ctrlr_state(struct pxafb_info *fbi, u_int state)
+{
+	switch (state) {
+	case C_DISABLE:
+		DISABLE_OVERLAYS(fbi);
+		break;
+	case C_ENABLE:
+		ENABLE_OVERLAYS(fbi);
+		break;
+	case C_BLANK:
+		BLANK_OVERLAYS(fbi);
+		break;
+	case C_UNBLANK:
+		UNBLANK_OVERLAYS(fbi);
+		break;
+	}
+}
+
+void __init pxafb_overlay_probe(struct device *dev)
+{
+	struct pxafb_info *fbi;
+	int ret;
+
+	dev_dbg(dev, "pxafb_overlay_probe\n");
+
+	fbi = dev_get_drvdata(dev);
+	if (!fbi) {
+		dev_err(dev, "base framebuffer not initialized, "
+				"failed to load overlay driver!\n");
+		return;
+	}
+
+	/* Overlay 1 windows */
+	overlay1fb_init_fbinfo(&fbi->overlay1fb);
+	ret = register_framebuffer(&fbi->overlay1fb.fb);
+	if (ret < 0) {
+		dev_err(dev, "unable to register overlay 1 windows\n");
+		goto error_o1;
+	}
+
+	/* Overlay 2 window */
+	overlay2fb_init_fbinfo(&fbi->overlay2fb);
+	ret = register_framebuffer(&fbi->overlay2fb.fb);
+	if (ret < 0) {
+		dev_err(dev, "unable to register overlay 2 windows\n");
+		goto error_o2;
+	}
+
+	/* Hardware cursor window */
+	cursorfb_init_fbinfo(&fbi->cursorfb);
+	ret = register_framebuffer(&fbi->cursorfb.fb);
+	if (ret < 0) {
+		dev_err(dev, "unable to register hardware cursor windows\n");
+		goto error_cu;
+	}
+
+	fbi->set_overlay_ctrlr_state = pxa_set_overlay_ctrlr_state;
+
+	dev_info(dev, "PXA overlay driver enabled\n");
+
+	return;
+
+error_cu:
+	unregister_framebuffer(&fbi->overlay2fb.fb);
+error_o2:
+	unregister_framebuffer(&fbi->overlay1fb.fb);
+error_o1:
+	dev_info(dev, "PXA overlay driver failed\n");
+
+	return;
+}
+EXPORT_SYMBOL(pxafb_overlay_probe);
-- 
1.5.4.3

