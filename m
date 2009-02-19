Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZBSNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZBSNs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZBSNrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:47:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:49874 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbZBSNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:47:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LxZXhC1ItNmbfNUYjQCznbAA2jJAwnn5lVi70eHLsrpP1X9RGo+k6U3/lH50h+Mq0A
         BAIfQKJLXwIROhpb2H4gfLWycnBKh/b6tipVgvvuxJ4E6AGuhkek53iTd/vB/+P1/MXR
         QhOLBuwV80dvSNEce84yfFOwQpBNHMLEAg5qI=
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] [ARM] pxa: move common MFP handling code into plat-pxa
Date: Thu, 19 Feb 2009 21:45:52 +0800
Message-Id: <1235051161-8858-4-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
References: <1235051161-8858-1-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-2-git-send-email-eric.y.miao@gmail.com>
 <1235051161-8858-3-git-send-email-eric.y.miao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 arch/arm/mach-pxa/include/mach/mfp-pxa25x.h |    1 -
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h |    1 -
 arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h |    2 +-
 arch/arm/mach-pxa/include/mach/mfp-pxa300.h |    1 -
 arch/arm/mach-pxa/include/mach/mfp-pxa320.h |    1 -
 arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h |  130 ++--------
 arch/arm/mach-pxa/include/mach/mfp-pxa930.h |    1 -
 arch/arm/mach-pxa/mfp-pxa3xx.c              |  189 +--------------
 arch/arm/mach-pxa/pxa300.c                  |   10 +-
 arch/arm/mach-pxa/pxa320.c                  |    6 +-
 arch/arm/mach-pxa/pxa930.c                  |    6 +-
 arch/arm/plat-pxa/Makefile                  |    2 +-
 arch/arm/plat-pxa/include/plat/mfp.h        |  369 +++++++++++++++++++++++++++
 arch/arm/plat-pxa/mfp.c                     |  278 ++++++++++++++++++++
 14 files changed, 680 insertions(+), 317 deletions(-)
 create mode 100644 arch/arm/plat-pxa/include/plat/mfp.h
 create mode 100644 arch/arm/plat-pxa/mfp.c

diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa25x.h b/arch/arm/mach-pxa/include/mach/mfp-pxa25x.h
index a72869b..b13dc02 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa25x.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa25x.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_ARCH_MFP_PXA25X_H
 #define __ASM_ARCH_MFP_PXA25X_H
 
-#include <mach/mfp.h>
 #include <mach/mfp-pxa2xx.h>
 
 /* GPIO */
diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h b/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
index da4f85a..6543c05 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
@@ -8,7 +8,6 @@
  * specific controller, and this should work in most cases.
  */
 
-#include <mach/mfp.h>
 #include <mach/mfp-pxa2xx.h>
 
 /* Note: GPIO3/GPIO4 will be driven by Power I2C when PCFR/PI2C_EN
diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h b/arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h
index 3e92115..658b28e 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_ARCH_MFP_PXA2XX_H
 #define __ASM_ARCH_MFP_PXA2XX_H
 
-#include <mach/mfp.h>
+#include <plat/mfp.h>
 
 /*
  * the following MFP_xxx bit definitions in mfp.h are re-used for pxa2xx:
diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa300.h b/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
index bc1fb33..86d3312 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa300.h
@@ -15,7 +15,6 @@
 #ifndef __ASM_ARCH_MFP_PXA300_H
 #define __ASM_ARCH_MFP_PXA300_H
 
-#include <mach/mfp.h>
 #include <mach/mfp-pxa3xx.h>
 
 /* GPIO */
diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa320.h b/arch/arm/mach-pxa/include/mach/mfp-pxa320.h
index 67f8385..b8e2855 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa320.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa320.h
@@ -15,7 +15,6 @@
 #ifndef __ASM_ARCH_MFP_PXA320_H
 #define __ASM_ARCH_MFP_PXA320_H
 
-#include <mach/mfp.h>
 #include <mach/mfp-pxa3xx.h>
 
 /* GPIO */
diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h b/arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h
index 1f6b35c..d375195 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h
@@ -1,68 +1,9 @@
 #ifndef __ASM_ARCH_MFP_PXA3XX_H
 #define __ASM_ARCH_MFP_PXA3XX_H
 
-#define MFPR_BASE	(0x40e10000)
-#define MFPR_SIZE	(PAGE_SIZE)
-
-/* MFPR register bit definitions */
-#define MFPR_PULL_SEL		(0x1 << 15)
-#define MFPR_PULLUP_EN		(0x1 << 14)
-#define MFPR_PULLDOWN_EN	(0x1 << 13)
-#define MFPR_SLEEP_SEL		(0x1 << 9)
-#define MFPR_SLEEP_OE_N		(0x1 << 7)
-#define MFPR_EDGE_CLEAR		(0x1 << 6)
-#define MFPR_EDGE_FALL_EN	(0x1 << 5)
-#define MFPR_EDGE_RISE_EN	(0x1 << 4)
-
-#define MFPR_SLEEP_DATA(x)	((x) << 8)
-#define MFPR_DRIVE(x)		(((x) & 0x7) << 10)
-#define MFPR_AF_SEL(x)		(((x) & 0x7) << 0)
+#include <plat/mfp.h>
 
-#define MFPR_EDGE_NONE		(0)
-#define MFPR_EDGE_RISE		(MFPR_EDGE_RISE_EN)
-#define MFPR_EDGE_FALL		(MFPR_EDGE_FALL_EN)
-#define MFPR_EDGE_BOTH		(MFPR_EDGE_RISE | MFPR_EDGE_FALL)
-
-/*
- * Table that determines the low power modes outputs, with actual settings
- * used in parentheses for don't-care values. Except for the float output,
- * the configured driven and pulled levels match, so if there is a need for
- * non-LPM pulled output, the same configuration could probably be used.
- *
- * Output value  sleep_oe_n  sleep_data  pullup_en  pulldown_en  pull_sel
- *                 (bit 7)    (bit 8)    (bit 14)     (bit 13)   (bit 15)
- *
- * Input            0          X(0)        X(0)        X(0)       0
- * Drive 0          0          0           0           X(1)       0
- * Drive 1          0          1           X(1)        0	  0
- * Pull hi (1)      1          X(1)        1           0	  0
- * Pull lo (0)      1          X(0)        0           1	  0
- * Z (float)        1          X(0)        0           0	  0
- */
-#define MFPR_LPM_INPUT		(0)
-#define MFPR_LPM_DRIVE_LOW	(MFPR_SLEEP_DATA(0) | MFPR_PULLDOWN_EN)
-#define MFPR_LPM_DRIVE_HIGH    	(MFPR_SLEEP_DATA(1) | MFPR_PULLUP_EN)
-#define MFPR_LPM_PULL_LOW      	(MFPR_LPM_DRIVE_LOW  | MFPR_SLEEP_OE_N)
-#define MFPR_LPM_PULL_HIGH     	(MFPR_LPM_DRIVE_HIGH | MFPR_SLEEP_OE_N)
-#define MFPR_LPM_FLOAT         	(MFPR_SLEEP_OE_N)
-#define MFPR_LPM_MASK		(0xe080)
-
-/*
- * The pullup and pulldown state of the MFP pin at run mode is by default
- * determined by the selected alternate function. In case that some buggy
- * devices need to override this default behavior,  the definitions below
- * indicates the setting of corresponding MFPR bits
- *
- * Definition       pull_sel  pullup_en  pulldown_en
- * MFPR_PULL_NONE       0         0        0
- * MFPR_PULL_LOW        1         0        1
- * MFPR_PULL_HIGH       1         1        0
- * MFPR_PULL_BOTH       1         1        1
- */
-#define MFPR_PULL_NONE		(0)
-#define MFPR_PULL_LOW		(MFPR_PULL_SEL | MFPR_PULLDOWN_EN)
-#define MFPR_PULL_BOTH		(MFPR_PULL_LOW | MFPR_PULLUP_EN)
-#define MFPR_PULL_HIGH		(MFPR_PULL_SEL | MFPR_PULLUP_EN)
+#define MFPR_BASE	(0x40e10000)
 
 /* PXA3xx common MFP configurations - processor specific ones defined
  * in mfp-pxa300.h and mfp-pxa320.h
@@ -197,56 +138,21 @@
 #define GPIO5_2_GPIO		MFP_CFG(GPIO5_2, AF0)
 #define GPIO6_2_GPIO		MFP_CFG(GPIO6_2, AF0)
 
-/*
- * each MFP pin will have a MFPR register, since the offset of the
- * register varies between processors, the processor specific code
- * should initialize the pin offsets by pxa3xx_mfp_init_addr()
- *
- * pxa3xx_mfp_init_addr - accepts a table of "pxa3xx_mfp_addr_map"
- * structure, which represents a range of MFP pins from "start" to
- * "end", with the offset begining at "offset", to define a single
- * pin, let "end" = -1
- *
- * use
- *
- * MFP_ADDR_X() to define a range of pins
- * MFP_ADDR()   to define a single pin
- * MFP_ADDR_END to signal the end of pin offset definitions
- */
-struct pxa3xx_mfp_addr_map {
-	unsigned int	start;
-	unsigned int	end;
-	unsigned long	offset;
-};
-
-#define MFP_ADDR_X(start, end, offset) \
-	{ MFP_PIN_##start, MFP_PIN_##end, offset }
-
-#define MFP_ADDR(pin, offset) \
-	{ MFP_PIN_##pin, -1, offset }
-
-#define MFP_ADDR_END	{ MFP_PIN_INVALID, 0 }
-
-/*
- * pxa3xx_mfp_read()/pxa3xx_mfp_write() - for direct read/write access
- * to the MFPR register
- */
-unsigned long pxa3xx_mfp_read(int mfp);
-void pxa3xx_mfp_write(int mfp, unsigned long mfpr_val);
-
-/*
- * pxa3xx_mfp_config - configure the MFPR registers
- *
- * used by board specific initialization code
- */
-void pxa3xx_mfp_config(unsigned long *mfp_cfgs, int num);
-
-/*
- * pxa3xx_mfp_init_addr() - initialize the mapping between mfp pin
- * index and MFPR register offset
- *
- * used by processor specific code
+/* NOTE: usage of these two functions is not recommended,
+ * use pxa3xx_mfp_config() instead.
  */
-void __init pxa3xx_mfp_init_addr(struct pxa3xx_mfp_addr_map *);
-void __init pxa3xx_init_mfp(void);
+static inline unsigned long pxa3xx_mfp_read(int mfp)
+{
+	return mfp_read(mfp);
+}
+
+static inline void pxa3xx_mfp_write(int mfp, unsigned long val)
+{
+	mfp_write(mfp, val);
+}
+
+static inline void pxa3xx_mfp_config(unsigned long *mfp_cfg, int num)
+{
+	mfp_config(mfp_cfg, num);
+}
 #endif /* __ASM_ARCH_MFP_PXA3XX_H */
diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa930.h b/arch/arm/mach-pxa/include/mach/mfp-pxa930.h
index fa73f56..0d119d3 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa930.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa930.h
@@ -13,7 +13,6 @@
 #ifndef __ASM_ARCH_MFP_PXA9xx_H
 #define __ASM_ARCH_MFP_PXA9xx_H
 
-#include <mach/mfp.h>
 #include <mach/mfp-pxa3xx.h>
 
 /* GPIO */
diff --git a/arch/arm/mach-pxa/mfp-pxa3xx.c b/arch/arm/mach-pxa/mfp-pxa3xx.c
index eb197a6..7a270ee 100644
--- a/arch/arm/mach-pxa/mfp-pxa3xx.c
+++ b/arch/arm/mach-pxa/mfp-pxa3xx.c
@@ -20,183 +20,9 @@
 #include <linux/sysdev.h>
 
 #include <mach/hardware.h>
-#include <mach/mfp.h>
 #include <mach/mfp-pxa3xx.h>
 #include <mach/pxa3xx-regs.h>
 
-/* mfp_spin_lock is used to ensure that MFP register configuration
- * (most likely a read-modify-write operation) is atomic, and that
- * mfp_table[] is consistent
- */
-static DEFINE_SPINLOCK(mfp_spin_lock);
-
-static void __iomem *mfpr_mmio_base = (void __iomem *)&__REG(MFPR_BASE);
-
-struct pxa3xx_mfp_pin {
-	unsigned long	config;		/* -1 for not configured */
-	unsigned long	mfpr_off;	/* MFPRxx Register offset */
-	unsigned long	mfpr_run;	/* Run-Mode Register Value */
-	unsigned long	mfpr_lpm;	/* Low Power Mode Register Value */
-};
-
-static struct pxa3xx_mfp_pin mfp_table[MFP_PIN_MAX];
-
-/* mapping of MFP_LPM_* definitions to MFPR_LPM_* register bits */
-static const unsigned long mfpr_lpm[] = {
-	MFPR_LPM_INPUT,
-	MFPR_LPM_DRIVE_LOW,
-	MFPR_LPM_DRIVE_HIGH,
-	MFPR_LPM_PULL_LOW,
-	MFPR_LPM_PULL_HIGH,
-	MFPR_LPM_FLOAT,
-};
-
-/* mapping of MFP_PULL_* definitions to MFPR_PULL_* register bits */
-static const unsigned long mfpr_pull[] = {
-	MFPR_PULL_NONE,
-	MFPR_PULL_LOW,
-	MFPR_PULL_HIGH,
-	MFPR_PULL_BOTH,
-};
-
-/* mapping of MFP_LPM_EDGE_* definitions to MFPR_EDGE_* register bits */
-static const unsigned long mfpr_edge[] = {
-	MFPR_EDGE_NONE,
-	MFPR_EDGE_RISE,
-	MFPR_EDGE_FALL,
-	MFPR_EDGE_BOTH,
-};
-
-#define mfpr_readl(off)			\
-	__raw_readl(mfpr_mmio_base + (off))
-
-#define mfpr_writel(off, val)		\
-	__raw_writel(val, mfpr_mmio_base + (off))
-
-#define mfp_configured(p)	((p)->config != -1)
-
-/*
- * perform a read-back of any MFPR register to make sure the
- * previous writings are finished
- */
-#define mfpr_sync()	(void)__raw_readl(mfpr_mmio_base + 0)
-
-static inline void __mfp_config_run(struct pxa3xx_mfp_pin *p)
-{
-	if (mfp_configured(p))
-		mfpr_writel(p->mfpr_off, p->mfpr_run);
-}
-
-static inline void __mfp_config_lpm(struct pxa3xx_mfp_pin *p)
-{
-	if (mfp_configured(p)) {
-		unsigned long mfpr_clr = (p->mfpr_run & ~MFPR_EDGE_BOTH) | MFPR_EDGE_CLEAR;
-		if (mfpr_clr != p->mfpr_run)
-			mfpr_writel(p->mfpr_off, mfpr_clr);
-		if (p->mfpr_lpm != mfpr_clr)
-			mfpr_writel(p->mfpr_off, p->mfpr_lpm);
-	}
-}
-
-void pxa3xx_mfp_config(unsigned long *mfp_cfgs, int num)
-{
-	unsigned long flags;
-	int i;
-
-	spin_lock_irqsave(&mfp_spin_lock, flags);
-
-	for (i = 0; i < num; i++, mfp_cfgs++) {
-		unsigned long tmp, c = *mfp_cfgs;
-		struct pxa3xx_mfp_pin *p;
-		int pin, af, drv, lpm, edge, pull;
-
-		pin = MFP_PIN(c);
-		BUG_ON(pin >= MFP_PIN_MAX);
-		p = &mfp_table[pin];
-
-		af  = MFP_AF(c);
-		drv = MFP_DS(c);
-		lpm = MFP_LPM_STATE(c);
-		edge = MFP_LPM_EDGE(c);
-		pull = MFP_PULL(c);
-
-		/* run-mode pull settings will conflict with MFPR bits of
-		 * low power mode state,  calculate mfpr_run and mfpr_lpm
-		 * individually if pull != MFP_PULL_NONE
-		 */
-		tmp = MFPR_AF_SEL(af) | MFPR_DRIVE(drv);
-
-		if (likely(pull == MFP_PULL_NONE)) {
-			p->mfpr_run = tmp | mfpr_lpm[lpm] | mfpr_edge[edge];
-			p->mfpr_lpm = p->mfpr_run;
-		} else {
-			p->mfpr_lpm = tmp | mfpr_lpm[lpm] | mfpr_edge[edge];
-			p->mfpr_run = tmp | mfpr_pull[pull];
-		}
-
-		p->config = c; __mfp_config_run(p);
-	}
-
-	mfpr_sync();
-	spin_unlock_irqrestore(&mfp_spin_lock, flags);
-}
-
-unsigned long pxa3xx_mfp_read(int mfp)
-{
-	unsigned long val, flags;
-
-	BUG_ON(mfp >= MFP_PIN_MAX);
-
-	spin_lock_irqsave(&mfp_spin_lock, flags);
-	val = mfpr_readl(mfp_table[mfp].mfpr_off);
-	spin_unlock_irqrestore(&mfp_spin_lock, flags);
-
-	return val;
-}
-
-void pxa3xx_mfp_write(int mfp, unsigned long val)
-{
-	unsigned long flags;
-
-	BUG_ON(mfp >= MFP_PIN_MAX);
-
-	spin_lock_irqsave(&mfp_spin_lock, flags);
-	mfpr_writel(mfp_table[mfp].mfpr_off, val);
-	mfpr_sync();
-	spin_unlock_irqrestore(&mfp_spin_lock, flags);
-}
-
-void __init pxa3xx_mfp_init_addr(struct pxa3xx_mfp_addr_map *map)
-{
-	struct pxa3xx_mfp_addr_map *p;
-	unsigned long offset, flags;
-	int i;
-
-	spin_lock_irqsave(&mfp_spin_lock, flags);
-
-	for (p = map; p->start != MFP_PIN_INVALID; p++) {
-		offset = p->offset;
-		i = p->start;
-
-		do {
-			mfp_table[i].mfpr_off = offset;
-			mfp_table[i].mfpr_run = 0;
-			mfp_table[i].mfpr_lpm = 0;
-			offset += 4; i++;
-		} while ((i <= p->end) && (p->end != -1));
-	}
-
-	spin_unlock_irqrestore(&mfp_spin_lock, flags);
-}
-
-void __init pxa3xx_init_mfp(void)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mfp_table); i++)
-		mfp_table[i].config = -1;
-}
-
 #ifdef CONFIG_PM
 /*
  * Configure the MFPs appropriately for suspend/resume.
@@ -207,23 +33,13 @@ void __init pxa3xx_init_mfp(void)
  */
 static int pxa3xx_mfp_suspend(struct sys_device *d, pm_message_t state)
 {
-	int pin;
-
-	for (pin = 0; pin < ARRAY_SIZE(mfp_table); pin++) {
-		struct pxa3xx_mfp_pin *p = &mfp_table[pin];
-		__mfp_config_lpm(p);
-	}
+	mfp_config_lpm();
 	return 0;
 }
 
 static int pxa3xx_mfp_resume(struct sys_device *d)
 {
-	int pin;
-
-	for (pin = 0; pin < ARRAY_SIZE(mfp_table); pin++) {
-		struct pxa3xx_mfp_pin *p = &mfp_table[pin];
-		__mfp_config_run(p);
-	}
+	mfp_config_run();
 
 	/* clear RDH bit when MFP settings are restored
 	 *
@@ -231,7 +47,6 @@ static int pxa3xx_mfp_resume(struct sys_device *d)
 	 * preserve them here in case they will be referenced later
 	 */
 	ASCR &= ~(ASCR_RDH | ASCR_D1S | ASCR_D2S | ASCR_D3S);
-
 	return 0;
 }
 #else
diff --git a/arch/arm/mach-pxa/pxa300.c b/arch/arm/mach-pxa/pxa300.c
index 37bb12d..4ba6d21 100644
--- a/arch/arm/mach-pxa/pxa300.c
+++ b/arch/arm/mach-pxa/pxa300.c
@@ -23,7 +23,7 @@
 #include "devices.h"
 #include "clock.h"
 
-static struct pxa3xx_mfp_addr_map pxa300_mfp_addr_map[] __initdata = {
+static struct mfp_addr_map pxa300_mfp_addr_map[] __initdata = {
 
 	MFP_ADDR_X(GPIO0,   GPIO2,   0x00b4),
 	MFP_ADDR_X(GPIO3,   GPIO26,  0x027c),
@@ -72,7 +72,7 @@ static struct pxa3xx_mfp_addr_map pxa300_mfp_addr_map[] __initdata = {
 };
 
 /* override pxa300 MFP register addresses */
-static struct pxa3xx_mfp_addr_map pxa310_mfp_addr_map[] __initdata = {
+static struct mfp_addr_map pxa310_mfp_addr_map[] __initdata = {
 	MFP_ADDR_X(GPIO30,  GPIO98,   0x0418),
 	MFP_ADDR_X(GPIO7_2, GPIO12_2, 0x052C),
 
@@ -98,13 +98,13 @@ static struct clk_lookup pxa310_clkregs[] = {
 static int __init pxa300_init(void)
 {
 	if (cpu_is_pxa300() || cpu_is_pxa310()) {
-		pxa3xx_init_mfp();
-		pxa3xx_mfp_init_addr(pxa300_mfp_addr_map);
+		mfp_init_base(io_p2v(MFPR_BASE));
+		mfp_init_addr(pxa300_mfp_addr_map);
 		clks_register(ARRAY_AND_SIZE(common_clkregs));
 	}
 
 	if (cpu_is_pxa310()) {
-		pxa3xx_mfp_init_addr(pxa310_mfp_addr_map);
+		mfp_init_addr(pxa310_mfp_addr_map);
 		clks_register(ARRAY_AND_SIZE(pxa310_clkregs));
 	}
 
diff --git a/arch/arm/mach-pxa/pxa320.c b/arch/arm/mach-pxa/pxa320.c
index e708f4e..8b3d97e 100644
--- a/arch/arm/mach-pxa/pxa320.c
+++ b/arch/arm/mach-pxa/pxa320.c
@@ -23,7 +23,7 @@
 #include "devices.h"
 #include "clock.h"
 
-static struct pxa3xx_mfp_addr_map pxa320_mfp_addr_map[] __initdata = {
+static struct mfp_addr_map pxa320_mfp_addr_map[] __initdata = {
 
 	MFP_ADDR_X(GPIO0,  GPIO4,   0x0124),
 	MFP_ADDR_X(GPIO5,  GPIO9,   0x028C),
@@ -86,8 +86,8 @@ static struct clk_lookup pxa320_clkregs[] = {
 static int __init pxa320_init(void)
 {
 	if (cpu_is_pxa320()) {
-		pxa3xx_init_mfp();
-		pxa3xx_mfp_init_addr(pxa320_mfp_addr_map);
+		mfp_init_base(io_p2v(MFPR_BASE));
+		mfp_init_addr(pxa320_mfp_addr_map);
 		clks_register(ARRAY_AND_SIZE(pxa320_clkregs));
 	}
 
diff --git a/arch/arm/mach-pxa/pxa930.c b/arch/arm/mach-pxa/pxa930.c
index f15dfa5..7113174 100644
--- a/arch/arm/mach-pxa/pxa930.c
+++ b/arch/arm/mach-pxa/pxa930.c
@@ -18,7 +18,7 @@
 
 #include <mach/pxa930.h>
 
-static struct pxa3xx_mfp_addr_map pxa930_mfp_addr_map[] __initdata = {
+static struct mfp_addr_map pxa930_mfp_addr_map[] __initdata = {
 
 	MFP_ADDR(GPIO0, 0x02e0),
 	MFP_ADDR(GPIO1, 0x02dc),
@@ -179,8 +179,8 @@ static struct pxa3xx_mfp_addr_map pxa930_mfp_addr_map[] __initdata = {
 static int __init pxa930_init(void)
 {
 	if (cpu_is_pxa930()) {
-		pxa3xx_init_mfp();
-		pxa3xx_mfp_init_addr(pxa930_mfp_addr_map);
+		mfp_init_base(io_p2v(MFPR_BASE));
+		mfp_init_addr(pxa930_mfp_addr_map);
 	}
 
 	return 0;
diff --git a/arch/arm/plat-pxa/Makefile b/arch/arm/plat-pxa/Makefile
index b837df4..4be3723 100644
--- a/arch/arm/plat-pxa/Makefile
+++ b/arch/arm/plat-pxa/Makefile
@@ -2,6 +2,6 @@
 # Makefile for code common across different PXA processor families
 #
 
-obj-y	:= dma.o
+obj-y	:= dma.o mfp.o
 
 obj-$(CONFIG_GENERIC_GPIO)	+= gpio.o
diff --git a/arch/arm/plat-pxa/include/plat/mfp.h b/arch/arm/plat-pxa/include/plat/mfp.h
new file mode 100644
index 0000000..a22229c
--- /dev/null
+++ b/arch/arm/plat-pxa/include/plat/mfp.h
@@ -0,0 +1,369 @@
+/*
+ * arch/arm/plat-pxa/include/plat/mfp.h
+ *
+ *   Common Multi-Function Pin Definitions
+ *
+ * Copyright (C) 2007 Marvell International Ltd.
+ *
+ * 2007-8-21: eric miao <eric.miao@marvell.com>
+ *            initial version
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_PLAT_MFP_H
+#define __ASM_PLAT_MFP_H
+
+#define mfp_to_gpio(m)	((m) % 128)
+
+/* list of all the configurable MFP pins */
+enum {
+	MFP_PIN_INVALID = -1,
+
+	MFP_PIN_GPIO0 = 0,
+	MFP_PIN_GPIO1,
+	MFP_PIN_GPIO2,
+	MFP_PIN_GPIO3,
+	MFP_PIN_GPIO4,
+	MFP_PIN_GPIO5,
+	MFP_PIN_GPIO6,
+	MFP_PIN_GPIO7,
+	MFP_PIN_GPIO8,
+	MFP_PIN_GPIO9,
+	MFP_PIN_GPIO10,
+	MFP_PIN_GPIO11,
+	MFP_PIN_GPIO12,
+	MFP_PIN_GPIO13,
+	MFP_PIN_GPIO14,
+	MFP_PIN_GPIO15,
+	MFP_PIN_GPIO16,
+	MFP_PIN_GPIO17,
+	MFP_PIN_GPIO18,
+	MFP_PIN_GPIO19,
+	MFP_PIN_GPIO20,
+	MFP_PIN_GPIO21,
+	MFP_PIN_GPIO22,
+	MFP_PIN_GPIO23,
+	MFP_PIN_GPIO24,
+	MFP_PIN_GPIO25,
+	MFP_PIN_GPIO26,
+	MFP_PIN_GPIO27,
+	MFP_PIN_GPIO28,
+	MFP_PIN_GPIO29,
+	MFP_PIN_GPIO30,
+	MFP_PIN_GPIO31,
+	MFP_PIN_GPIO32,
+	MFP_PIN_GPIO33,
+	MFP_PIN_GPIO34,
+	MFP_PIN_GPIO35,
+	MFP_PIN_GPIO36,
+	MFP_PIN_GPIO37,
+	MFP_PIN_GPIO38,
+	MFP_PIN_GPIO39,
+	MFP_PIN_GPIO40,
+	MFP_PIN_GPIO41,
+	MFP_PIN_GPIO42,
+	MFP_PIN_GPIO43,
+	MFP_PIN_GPIO44,
+	MFP_PIN_GPIO45,
+	MFP_PIN_GPIO46,
+	MFP_PIN_GPIO47,
+	MFP_PIN_GPIO48,
+	MFP_PIN_GPIO49,
+	MFP_PIN_GPIO50,
+	MFP_PIN_GPIO51,
+	MFP_PIN_GPIO52,
+	MFP_PIN_GPIO53,
+	MFP_PIN_GPIO54,
+	MFP_PIN_GPIO55,
+	MFP_PIN_GPIO56,
+	MFP_PIN_GPIO57,
+	MFP_PIN_GPIO58,
+	MFP_PIN_GPIO59,
+	MFP_PIN_GPIO60,
+	MFP_PIN_GPIO61,
+	MFP_PIN_GPIO62,
+	MFP_PIN_GPIO63,
+	MFP_PIN_GPIO64,
+	MFP_PIN_GPIO65,
+	MFP_PIN_GPIO66,
+	MFP_PIN_GPIO67,
+	MFP_PIN_GPIO68,
+	MFP_PIN_GPIO69,
+	MFP_PIN_GPIO70,
+	MFP_PIN_GPIO71,
+	MFP_PIN_GPIO72,
+	MFP_PIN_GPIO73,
+	MFP_PIN_GPIO74,
+	MFP_PIN_GPIO75,
+	MFP_PIN_GPIO76,
+	MFP_PIN_GPIO77,
+	MFP_PIN_GPIO78,
+	MFP_PIN_GPIO79,
+	MFP_PIN_GPIO80,
+	MFP_PIN_GPIO81,
+	MFP_PIN_GPIO82,
+	MFP_PIN_GPIO83,
+	MFP_PIN_GPIO84,
+	MFP_PIN_GPIO85,
+	MFP_PIN_GPIO86,
+	MFP_PIN_GPIO87,
+	MFP_PIN_GPIO88,
+	MFP_PIN_GPIO89,
+	MFP_PIN_GPIO90,
+	MFP_PIN_GPIO91,
+	MFP_PIN_GPIO92,
+	MFP_PIN_GPIO93,
+	MFP_PIN_GPIO94,
+	MFP_PIN_GPIO95,
+	MFP_PIN_GPIO96,
+	MFP_PIN_GPIO97,
+	MFP_PIN_GPIO98,
+	MFP_PIN_GPIO99,
+	MFP_PIN_GPIO100,
+	MFP_PIN_GPIO101,
+	MFP_PIN_GPIO102,
+	MFP_PIN_GPIO103,
+	MFP_PIN_GPIO104,
+	MFP_PIN_GPIO105,
+	MFP_PIN_GPIO106,
+	MFP_PIN_GPIO107,
+	MFP_PIN_GPIO108,
+	MFP_PIN_GPIO109,
+	MFP_PIN_GPIO110,
+	MFP_PIN_GPIO111,
+	MFP_PIN_GPIO112,
+	MFP_PIN_GPIO113,
+	MFP_PIN_GPIO114,
+	MFP_PIN_GPIO115,
+	MFP_PIN_GPIO116,
+	MFP_PIN_GPIO117,
+	MFP_PIN_GPIO118,
+	MFP_PIN_GPIO119,
+	MFP_PIN_GPIO120,
+	MFP_PIN_GPIO121,
+	MFP_PIN_GPIO122,
+	MFP_PIN_GPIO123,
+	MFP_PIN_GPIO124,
+	MFP_PIN_GPIO125,
+	MFP_PIN_GPIO126,
+	MFP_PIN_GPIO127,
+	MFP_PIN_GPIO0_2,
+	MFP_PIN_GPIO1_2,
+	MFP_PIN_GPIO2_2,
+	MFP_PIN_GPIO3_2,
+	MFP_PIN_GPIO4_2,
+	MFP_PIN_GPIO5_2,
+	MFP_PIN_GPIO6_2,
+	MFP_PIN_GPIO7_2,
+	MFP_PIN_GPIO8_2,
+	MFP_PIN_GPIO9_2,
+	MFP_PIN_GPIO10_2,
+	MFP_PIN_GPIO11_2,
+	MFP_PIN_GPIO12_2,
+	MFP_PIN_GPIO13_2,
+	MFP_PIN_GPIO14_2,
+	MFP_PIN_GPIO15_2,
+	MFP_PIN_GPIO16_2,
+	MFP_PIN_GPIO17_2,
+
+	MFP_PIN_ULPI_STP,
+	MFP_PIN_ULPI_NXT,
+	MFP_PIN_ULPI_DIR,
+
+	MFP_PIN_nXCVREN,
+	MFP_PIN_DF_CLE_nOE,
+	MFP_PIN_DF_nADV1_ALE,
+	MFP_PIN_DF_SCLK_E,
+	MFP_PIN_DF_SCLK_S,
+	MFP_PIN_nBE0,
+	MFP_PIN_nBE1,
+	MFP_PIN_DF_nADV2_ALE,
+	MFP_PIN_DF_INT_RnB,
+	MFP_PIN_DF_nCS0,
+	MFP_PIN_DF_nCS1,
+	MFP_PIN_nLUA,
+	MFP_PIN_nLLA,
+	MFP_PIN_DF_nWE,
+	MFP_PIN_DF_ALE_nWE,
+	MFP_PIN_DF_nRE_nOE,
+	MFP_PIN_DF_ADDR0,
+	MFP_PIN_DF_ADDR1,
+	MFP_PIN_DF_ADDR2,
+	MFP_PIN_DF_ADDR3,
+	MFP_PIN_DF_IO0,
+	MFP_PIN_DF_IO1,
+	MFP_PIN_DF_IO2,
+	MFP_PIN_DF_IO3,
+	MFP_PIN_DF_IO4,
+	MFP_PIN_DF_IO5,
+	MFP_PIN_DF_IO6,
+	MFP_PIN_DF_IO7,
+	MFP_PIN_DF_IO8,
+	MFP_PIN_DF_IO9,
+	MFP_PIN_DF_IO10,
+	MFP_PIN_DF_IO11,
+	MFP_PIN_DF_IO12,
+	MFP_PIN_DF_IO13,
+	MFP_PIN_DF_IO14,
+	MFP_PIN_DF_IO15,
+
+	/* additional pins on PXA930 */
+	MFP_PIN_GSIM_UIO,
+	MFP_PIN_GSIM_UCLK,
+	MFP_PIN_GSIM_UDET,
+	MFP_PIN_GSIM_nURST,
+	MFP_PIN_PMIC_INT,
+	MFP_PIN_RDY,
+
+	MFP_PIN_MAX,
+};
+
+/*
+ * a possible MFP configuration is represented by a 32-bit integer
+ *
+ * bit  0.. 9 - MFP Pin Number (1024 Pins Maximum)
+ * bit 10..12 - Alternate Function Selection
+ * bit 13..15 - Drive Strength
+ * bit 16..18 - Low Power Mode State
+ * bit 19..20 - Low Power Mode Edge Detection
+ * bit 21..22 - Run Mode Pull State
+ *
+ * to facilitate the definition, the following macros are provided
+ *
+ * MFP_CFG_DEFAULT - default MFP configuration value, with
+ * 		  alternate function = 0,
+ * 		  drive strength = fast 3mA (MFP_DS03X)
+ * 		  low power mode = default
+ * 		  edge detection = none
+ *
+ * MFP_CFG	- default MFPR value with alternate function
+ * MFP_CFG_DRV	- default MFPR value with alternate function and
+ * 		  pin drive strength
+ * MFP_CFG_LPM	- default MFPR value with alternate function and
+ * 		  low power mode
+ * MFP_CFG_X	- default MFPR value with alternate function,
+ * 		  pin drive strength and low power mode
+ */
+
+typedef unsigned long mfp_cfg_t;
+
+#define MFP_PIN(x)		((x) & 0x3ff)
+
+#define MFP_AF0			(0x0 << 10)
+#define MFP_AF1			(0x1 << 10)
+#define MFP_AF2			(0x2 << 10)
+#define MFP_AF3			(0x3 << 10)
+#define MFP_AF4			(0x4 << 10)
+#define MFP_AF5			(0x5 << 10)
+#define MFP_AF6			(0x6 << 10)
+#define MFP_AF7			(0x7 << 10)
+#define MFP_AF_MASK		(0x7 << 10)
+#define MFP_AF(x)		(((x) >> 10) & 0x7)
+
+#define MFP_DS01X		(0x0 << 13)
+#define MFP_DS02X		(0x1 << 13)
+#define MFP_DS03X		(0x2 << 13)
+#define MFP_DS04X		(0x3 << 13)
+#define MFP_DS06X		(0x4 << 13)
+#define MFP_DS08X		(0x5 << 13)
+#define MFP_DS10X		(0x6 << 13)
+#define MFP_DS13X		(0x7 << 13)
+#define MFP_DS_MASK		(0x7 << 13)
+#define MFP_DS(x)		(((x) >> 13) & 0x7)
+
+#define MFP_LPM_DEFAULT		(0x0 << 16)
+#define MFP_LPM_DRIVE_LOW	(0x1 << 16)
+#define MFP_LPM_DRIVE_HIGH	(0x2 << 16)
+#define MFP_LPM_PULL_LOW	(0x3 << 16)
+#define MFP_LPM_PULL_HIGH	(0x4 << 16)
+#define MFP_LPM_FLOAT		(0x5 << 16)
+#define MFP_LPM_INPUT		(0x6 << 16)
+#define MFP_LPM_STATE_MASK	(0x7 << 16)
+#define MFP_LPM_STATE(x)	(((x) >> 16) & 0x7)
+
+#define MFP_LPM_EDGE_NONE	(0x0 << 19)
+#define MFP_LPM_EDGE_RISE	(0x1 << 19)
+#define MFP_LPM_EDGE_FALL	(0x2 << 19)
+#define MFP_LPM_EDGE_BOTH	(0x3 << 19)
+#define MFP_LPM_EDGE_MASK	(0x3 << 19)
+#define MFP_LPM_EDGE(x)		(((x) >> 19) & 0x3)
+
+#define MFP_PULL_NONE		(0x0 << 21)
+#define MFP_PULL_LOW		(0x1 << 21)
+#define MFP_PULL_HIGH		(0x2 << 21)
+#define MFP_PULL_BOTH		(0x3 << 21)
+#define MFP_PULL_MASK		(0x3 << 21)
+#define MFP_PULL(x)		(((x) >> 21) & 0x3)
+
+#define MFP_CFG_DEFAULT		(MFP_AF0 | MFP_DS03X | MFP_LPM_DEFAULT |\
+				 MFP_LPM_EDGE_NONE | MFP_PULL_NONE)
+
+#define MFP_CFG(pin, af)		\
+	((MFP_CFG_DEFAULT & ~MFP_AF_MASK) |\
+	 (MFP_PIN(MFP_PIN_##pin) | MFP_##af))
+
+#define MFP_CFG_DRV(pin, af, drv)	\
+	((MFP_CFG_DEFAULT & ~(MFP_AF_MASK | MFP_DS_MASK)) |\
+	 (MFP_PIN(MFP_PIN_##pin) | MFP_##af | MFP_##drv))
+
+#define MFP_CFG_LPM(pin, af, lpm)	\
+	((MFP_CFG_DEFAULT & ~(MFP_AF_MASK | MFP_LPM_STATE_MASK)) |\
+	 (MFP_PIN(MFP_PIN_##pin) | MFP_##af | MFP_LPM_##lpm))
+
+#define MFP_CFG_X(pin, af, drv, lpm)	\
+	((MFP_CFG_DEFAULT & ~(MFP_AF_MASK | MFP_DS_MASK | MFP_LPM_STATE_MASK)) |\
+	 (MFP_PIN(MFP_PIN_##pin) | MFP_##af | MFP_##drv | MFP_LPM_##lpm))
+
+#if defined(CONFIG_PXA3xx) || defined(CONFIG_ARCH_MMP)
+/*
+ * each MFP pin will have a MFPR register, since the offset of the
+ * register varies between processors, the processor specific code
+ * should initialize the pin offsets by mfp_init()
+ *
+ * mfp_init_base() - accepts a virtual base for all MFPR registers and
+ * initialize the MFP table to a default state
+ *
+ * mfp_init_addr() - accepts a table of "mfp_addr_map" structure, which
+ * represents a range of MFP pins from "start" to "end", with the offset
+ * begining at "offset", to define a single pin, let "end" = -1.
+ *
+ * use
+ *
+ * MFP_ADDR_X() to define a range of pins
+ * MFP_ADDR()   to define a single pin
+ * MFP_ADDR_END to signal the end of pin offset definitions
+ */
+struct mfp_addr_map {
+	unsigned int	start;
+	unsigned int	end;
+	unsigned long	offset;
+};
+
+#define MFP_ADDR_X(start, end, offset) \
+	{ MFP_PIN_##start, MFP_PIN_##end, offset }
+
+#define MFP_ADDR(pin, offset) \
+	{ MFP_PIN_##pin, -1, offset }
+
+#define MFP_ADDR_END	{ MFP_PIN_INVALID, 0 }
+
+void __init mfp_init_base(unsigned long mfpr_base);
+void __init mfp_init_addr(struct mfp_addr_map *map);
+
+/*
+ * mfp_{read, write}()	- for direct read/write access to the MFPR register
+ * mfp_config()		- for configuring a group of MFPR registers
+ * mfp_config_lpm()	- configuring all low power MFPR registers for suspend
+ * mfp_config_run()	- configuring all run time  MFPR registers after resume
+ */
+unsigned long mfp_read(int mfp);
+void mfp_write(int mfp, unsigned long mfpr_val);
+void mfp_config(unsigned long *mfp_cfgs, int num);
+void mfp_config_run(void);
+void mfp_config_lpm(void);
+#endif /* CONFIG_PXA3xx || CONFIG_ARCH_MMP */
+
+#endif /* __ASM_PLAT_MFP_H */
diff --git a/arch/arm/plat-pxa/mfp.c b/arch/arm/plat-pxa/mfp.c
new file mode 100644
index 0000000..e716c62
--- /dev/null
+++ b/arch/arm/plat-pxa/mfp.c
@@ -0,0 +1,278 @@
+/*
+ * linux/arch/arm/plat-pxa/mfp.c
+ *
+ *   Multi-Function Pin Support
+ *
+ * Copyright (C) 2007 Marvell Internation Ltd.
+ *
+ * 2007-08-21: eric miao <eric.miao@marvell.com>
+ *             initial version
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/sysdev.h>
+
+#include <plat/mfp.h>
+
+#define MFPR_SIZE	(PAGE_SIZE)
+
+/* MFPR register bit definitions */
+#define MFPR_PULL_SEL		(0x1 << 15)
+#define MFPR_PULLUP_EN		(0x1 << 14)
+#define MFPR_PULLDOWN_EN	(0x1 << 13)
+#define MFPR_SLEEP_SEL		(0x1 << 9)
+#define MFPR_SLEEP_OE_N		(0x1 << 7)
+#define MFPR_EDGE_CLEAR		(0x1 << 6)
+#define MFPR_EDGE_FALL_EN	(0x1 << 5)
+#define MFPR_EDGE_RISE_EN	(0x1 << 4)
+
+#define MFPR_SLEEP_DATA(x)	((x) << 8)
+#define MFPR_DRIVE(x)		(((x) & 0x7) << 10)
+#define MFPR_AF_SEL(x)		(((x) & 0x7) << 0)
+
+#define MFPR_EDGE_NONE		(0)
+#define MFPR_EDGE_RISE		(MFPR_EDGE_RISE_EN)
+#define MFPR_EDGE_FALL		(MFPR_EDGE_FALL_EN)
+#define MFPR_EDGE_BOTH		(MFPR_EDGE_RISE | MFPR_EDGE_FALL)
+
+/*
+ * Table that determines the low power modes outputs, with actual settings
+ * used in parentheses for don't-care values. Except for the float output,
+ * the configured driven and pulled levels match, so if there is a need for
+ * non-LPM pulled output, the same configuration could probably be used.
+ *
+ * Output value  sleep_oe_n  sleep_data  pullup_en  pulldown_en  pull_sel
+ *                 (bit 7)    (bit 8)    (bit 14)     (bit 13)   (bit 15)
+ *
+ * Input            0          X(0)        X(0)        X(0)       0
+ * Drive 0          0          0           0           X(1)       0
+ * Drive 1          0          1           X(1)        0	  0
+ * Pull hi (1)      1          X(1)        1           0	  0
+ * Pull lo (0)      1          X(0)        0           1	  0
+ * Z (float)        1          X(0)        0           0	  0
+ */
+#define MFPR_LPM_INPUT		(0)
+#define MFPR_LPM_DRIVE_LOW	(MFPR_SLEEP_DATA(0) | MFPR_PULLDOWN_EN)
+#define MFPR_LPM_DRIVE_HIGH    	(MFPR_SLEEP_DATA(1) | MFPR_PULLUP_EN)
+#define MFPR_LPM_PULL_LOW      	(MFPR_LPM_DRIVE_LOW  | MFPR_SLEEP_OE_N)
+#define MFPR_LPM_PULL_HIGH     	(MFPR_LPM_DRIVE_HIGH | MFPR_SLEEP_OE_N)
+#define MFPR_LPM_FLOAT         	(MFPR_SLEEP_OE_N)
+#define MFPR_LPM_MASK		(0xe080)
+
+/*
+ * The pullup and pulldown state of the MFP pin at run mode is by default
+ * determined by the selected alternate function. In case that some buggy
+ * devices need to override this default behavior,  the definitions below
+ * indicates the setting of corresponding MFPR bits
+ *
+ * Definition       pull_sel  pullup_en  pulldown_en
+ * MFPR_PULL_NONE       0         0        0
+ * MFPR_PULL_LOW        1         0        1
+ * MFPR_PULL_HIGH       1         1        0
+ * MFPR_PULL_BOTH       1         1        1
+ */
+#define MFPR_PULL_NONE		(0)
+#define MFPR_PULL_LOW		(MFPR_PULL_SEL | MFPR_PULLDOWN_EN)
+#define MFPR_PULL_BOTH		(MFPR_PULL_LOW | MFPR_PULLUP_EN)
+#define MFPR_PULL_HIGH		(MFPR_PULL_SEL | MFPR_PULLUP_EN)
+
+/* mfp_spin_lock is used to ensure that MFP register configuration
+ * (most likely a read-modify-write operation) is atomic, and that
+ * mfp_table[] is consistent
+ */
+static DEFINE_SPINLOCK(mfp_spin_lock);
+
+static void __iomem *mfpr_mmio_base;
+
+struct mfp_pin {
+	unsigned long	config;		/* -1 for not configured */
+	unsigned long	mfpr_off;	/* MFPRxx Register offset */
+	unsigned long	mfpr_run;	/* Run-Mode Register Value */
+	unsigned long	mfpr_lpm;	/* Low Power Mode Register Value */
+};
+
+static struct mfp_pin mfp_table[MFP_PIN_MAX];
+
+/* mapping of MFP_LPM_* definitions to MFPR_LPM_* register bits */
+static const unsigned long mfpr_lpm[] = {
+	MFPR_LPM_INPUT,
+	MFPR_LPM_DRIVE_LOW,
+	MFPR_LPM_DRIVE_HIGH,
+	MFPR_LPM_PULL_LOW,
+	MFPR_LPM_PULL_HIGH,
+	MFPR_LPM_FLOAT,
+};
+
+/* mapping of MFP_PULL_* definitions to MFPR_PULL_* register bits */
+static const unsigned long mfpr_pull[] = {
+	MFPR_PULL_NONE,
+	MFPR_PULL_LOW,
+	MFPR_PULL_HIGH,
+	MFPR_PULL_BOTH,
+};
+
+/* mapping of MFP_LPM_EDGE_* definitions to MFPR_EDGE_* register bits */
+static const unsigned long mfpr_edge[] = {
+	MFPR_EDGE_NONE,
+	MFPR_EDGE_RISE,
+	MFPR_EDGE_FALL,
+	MFPR_EDGE_BOTH,
+};
+
+#define mfpr_readl(off)			\
+	__raw_readl(mfpr_mmio_base + (off))
+
+#define mfpr_writel(off, val)		\
+	__raw_writel(val, mfpr_mmio_base + (off))
+
+#define mfp_configured(p)	((p)->config != -1)
+
+/*
+ * perform a read-back of any MFPR register to make sure the
+ * previous writings are finished
+ */
+#define mfpr_sync()	(void)__raw_readl(mfpr_mmio_base + 0)
+
+static inline void __mfp_config_run(struct mfp_pin *p)
+{
+	if (mfp_configured(p))
+		mfpr_writel(p->mfpr_off, p->mfpr_run);
+}
+
+static inline void __mfp_config_lpm(struct mfp_pin *p)
+{
+	if (mfp_configured(p)) {
+		unsigned long mfpr_clr = (p->mfpr_run & ~MFPR_EDGE_BOTH) | MFPR_EDGE_CLEAR;
+		if (mfpr_clr != p->mfpr_run)
+			mfpr_writel(p->mfpr_off, mfpr_clr);
+		if (p->mfpr_lpm != mfpr_clr)
+			mfpr_writel(p->mfpr_off, p->mfpr_lpm);
+	}
+}
+
+void mfp_config(unsigned long *mfp_cfgs, int num)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&mfp_spin_lock, flags);
+
+	for (i = 0; i < num; i++, mfp_cfgs++) {
+		unsigned long tmp, c = *mfp_cfgs;
+		struct mfp_pin *p;
+		int pin, af, drv, lpm, edge, pull;
+
+		pin = MFP_PIN(c);
+		BUG_ON(pin >= MFP_PIN_MAX);
+		p = &mfp_table[pin];
+
+		af  = MFP_AF(c);
+		drv = MFP_DS(c);
+		lpm = MFP_LPM_STATE(c);
+		edge = MFP_LPM_EDGE(c);
+		pull = MFP_PULL(c);
+
+		/* run-mode pull settings will conflict with MFPR bits of
+		 * low power mode state,  calculate mfpr_run and mfpr_lpm
+		 * individually if pull != MFP_PULL_NONE
+		 */
+		tmp = MFPR_AF_SEL(af) | MFPR_DRIVE(drv);
+
+		if (likely(pull == MFP_PULL_NONE)) {
+			p->mfpr_run = tmp | mfpr_lpm[lpm] | mfpr_edge[edge];
+			p->mfpr_lpm = p->mfpr_run;
+		} else {
+			p->mfpr_lpm = tmp | mfpr_lpm[lpm] | mfpr_edge[edge];
+			p->mfpr_run = tmp | mfpr_pull[pull];
+		}
+
+		p->config = c; __mfp_config_run(p);
+	}
+
+	mfpr_sync();
+	spin_unlock_irqrestore(&mfp_spin_lock, flags);
+}
+
+unsigned long mfp_read(int mfp)
+{
+	unsigned long val, flags;
+
+	BUG_ON(mfp >= MFP_PIN_MAX);
+
+	spin_lock_irqsave(&mfp_spin_lock, flags);
+	val = mfpr_readl(mfp_table[mfp].mfpr_off);
+	spin_unlock_irqrestore(&mfp_spin_lock, flags);
+
+	return val;
+}
+
+void mfp_write(int mfp, unsigned long val)
+{
+	unsigned long flags;
+
+	BUG_ON(mfp >= MFP_PIN_MAX);
+
+	spin_lock_irqsave(&mfp_spin_lock, flags);
+	mfpr_writel(mfp_table[mfp].mfpr_off, val);
+	mfpr_sync();
+	spin_unlock_irqrestore(&mfp_spin_lock, flags);
+}
+
+void __init mfp_init_base(unsigned long mfpr_base)
+{
+	int i;
+
+	/* initialize the table with default - unconfigured */
+	for (i = 0; i < ARRAY_SIZE(mfp_table); i++)
+		mfp_table[i].config = -1;
+
+	mfpr_mmio_base = (void __iomem *)mfpr_base;
+}
+
+void __init mfp_init_addr(struct mfp_addr_map *map)
+{
+	struct mfp_addr_map *p;
+	unsigned long offset, flags;
+	int i;
+
+	spin_lock_irqsave(&mfp_spin_lock, flags);
+
+	for (p = map; p->start != MFP_PIN_INVALID; p++) {
+		offset = p->offset;
+		i = p->start;
+
+		do {
+			mfp_table[i].mfpr_off = offset;
+			mfp_table[i].mfpr_run = 0;
+			mfp_table[i].mfpr_lpm = 0;
+			offset += 4; i++;
+		} while ((i <= p->end) && (p->end != -1));
+	}
+
+	spin_unlock_irqrestore(&mfp_spin_lock, flags);
+}
+
+void mfp_config_lpm(void)
+{
+	struct mfp_pin *p = &mfp_table[0];
+	int pin;
+
+	for (pin = 0; pin < ARRAY_SIZE(mfp_table); pin++, p++)
+		__mfp_config_lpm(p);
+}
+
+void mfp_config_run(void)
+{
+	struct mfp_pin *p = &mfp_table[0];
+	int pin;
+
+	for (pin = 0; pin < ARRAY_SIZE(mfp_table); pin++, p++)
+		__mfp_config_run(p);
+}
-- 
1.6.0.4

