Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbXEQUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbXEQUAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756400AbXEQUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 16:00:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:36495 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbXEQUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 16:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=GU5+BunT7hY95XMbCq+qiOXlM970ucwJdoFNOw3NTzDCUAuPber9fHE4FhM2YbiiLs4Dc394WHB8vjaH+zl+oQVFoJwrwsif/HUf9nl6xiFTElLwfUMt3mEDbqbNPjJIag3T+21Iz4sx4+Cip/6/DORTFjmN8ZBcl6tfJSFmhKY=
Date: Thu, 17 May 2007 21:59:59 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Daniel Drake <dsd@gentoo.org>, linux list <linux-kernel@vger.kernel.org>,
       Jimmy.Jazz@gmx.net
Subject: Re: radeonfb and X800 cards
Message-ID: <20070517195958.GA6489@dreamland.darkstar.lan>
References: <464BB43D.2020407@gentoo.org> <1179367164.32247.256.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179367164.32247.256.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Thu, May 17, 2007 at 11:59:23AM +1000, Benjamin Herrenschmidt ha scritto: 
> On Wed, 2007-05-16 at 21:47 -0400, Daniel Drake wrote:
> > Hi,
> > 
> > Did anything happen to the patch titled "radeonfb: add support for newer 
> > cards"?
> > http://lwn.net/Articles/215965/
> > 
> > Jimmy at http://bugs.gentoo.org/174063 has extended upon this with some 
> > further fixes based on code the in X11 driver. The patches are on the 
> > bug report.
> > 
> > Ben, where can the most up-to-date radeonfb code be found?
> 
> upstream. I haven't released anything else so far. Does the patch still
> apply ?

This is what I'm using here, it's still the same old patch (Solomon's
plus my stuff). I think I can coordinate with Jimmy.Jazz@gmx.net to
create an incremental patch to fix radeonfb on his hardware (provided
that this mega-patch is suitable as baseline that is).

---
  Applies to current git

 drivers/video/aty/ati_ids.h          |   32 
 drivers/video/aty/radeon_accel.c     |   19 
 drivers/video/aty/radeon_backlight.c |    4 
 drivers/video/aty/radeon_base.c      |  494 +++++++----
 drivers/video/aty/radeon_i2c.c       |   66 -
 drivers/video/aty/radeon_monitor.c   | 1339 +++++++++++++++++++++---------
 drivers/video/aty/radeonfb.h         |  163 ++-
 7 files changed, 1516 insertions(+), 601 deletions(-)

diff --git a/drivers/video/aty/ati_ids.h b/drivers/video/aty/ati_ids.h
index 90e7df2..7b701cc 100644
--- a/drivers/video/aty/ati_ids.h
+++ b/drivers/video/aty/ati_ids.h
@@ -31,6 +31,7 @@
 #define PCI_CHIP_RV360_AR               0x4152
 #define PCI_CHIP_RV350_AS               0x4153
 #define PCI_CHIP_RV350_AT               0x4154
+#define PCI_CHIP_RV350_AU 		0x4155
 #define PCI_CHIP_RV350_AV               0x4156
 #define PCI_CHIP_MACH32			0x4158
 #define PCI_CHIP_RS250_4237		0x4237
@@ -71,7 +72,13 @@
 #define PCI_CHIP_R420_JL                0x4A4C
 #define PCI_CHIP_R420_JM                0x4A4D
 #define PCI_CHIP_R420_JN                0x4A4E
+#define PCI_CHIP_R420_JO 		0x4A4F
 #define PCI_CHIP_R420_JP                0x4A50
+#define PCI_CHIP_R420_JT 		0x4A54
+#define PCI_CHIP_R480_KI 		0x4B49
+#define PCI_CHIP_R480_KJ 		0x4B4A
+#define PCI_CHIP_R480_KK                0x4B4B
+#define PCI_CHIP_R480_KL 		0x4B4C
 #define PCI_CHIP_MACH64LB		0x4C42
 #define PCI_CHIP_MACH64LD		0x4C44
 #define PCI_CHIP_RAGE128LE		0x4C45
@@ -182,9 +189,19 @@
 #define PCI_CHIP_R423_UI                0x5549
 #define PCI_CHIP_R423_UJ                0x554A
 #define PCI_CHIP_R423_UK                0x554B
+#define PCI_CHIP_R423_UL 		0x554C
+#define PCI_CHIP_R423_UM 		0x554D
+#define PCI_CHIP_R423_UN 		0x554E
+#define PCI_CHIP_R423_UO 		0x554F
+#define PCI_CHIP_R423_UP 	       	0x5550
 #define PCI_CHIP_R423_UQ                0x5551
 #define PCI_CHIP_R423_UR                0x5552
 #define PCI_CHIP_R423_UT                0x5554
+#define PCI_CHIP_RV410_VJ 		0x564A
+#define PCI_CHIP_RV410_VK 		0x564B
+#define PCI_CHIP_RV410_VO 		0x564F
+#define PCI_CHIP_RV410_VR 		0x5652
+#define PCI_CHIP_RV410_VS 		0x5653
 #define PCI_CHIP_MACH64VT		0x5654
 #define PCI_CHIP_MACH64VU		0x5655
 #define PCI_CHIP_MACH64VV		0x5656
@@ -206,7 +223,22 @@
 #define PCI_CHIP_RV280_5964		0x5964
 #define PCI_CHIP_RV280_5C61		0x5C61
 #define PCI_CHIP_RV280_5C63		0x5C63
+#define PCI_CHIP_R423_5D48		0x5D48
+#define PCI_CHIP_R423_5D49		0x5D49
+#define PCI_CHIP_R423_5D4A		0x5D4A
+#define PCI_CHIP_R480_5D4C		0x5D4C
+#define PCI_CHIP_R480_5D4D		0x5D4D
+#define PCI_CHIP_R480_5D4E		0x5D4E
+#define PCI_CHIP_R480_5D4F		0x5D4F
+#define PCI_CHIP_R480_5D50		0x5D50
+#define PCI_CHIP_R480_5D52		0x5D52
 #define PCI_CHIP_R423_5D57              0x5D57
+#define PCI_CHIP_RV410_5E48		0x5E48
+#define PCI_CHIP_RV410_5E4A		0x5E4A
+#define PCI_CHIP_RV410_5E4B		0x5E4B
+#define PCI_CHIP_RV410_5E4C		0x5E4C
+#define PCI_CHIP_RV410_5E4D		0x5E4D
+#define PCI_CHIP_RV410_5E4F		0x5E4F
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
 #define PCI_CHIP_RS480_5955             0x5955
diff --git a/drivers/video/aty/radeon_accel.c b/drivers/video/aty/radeon_accel.c
index 3ca27cb..529f158 100644
--- a/drivers/video/aty/radeon_accel.c
+++ b/drivers/video/aty/radeon_accel.c
@@ -203,9 +203,7 @@ void radeonfb_engine_reset(struct radeonfb_info *rinfo)
 	host_path_cntl = INREG(HOST_PATH_CNTL);
 	rbbm_soft_reset = INREG(RBBM_SOFT_RESET);
 
-	if (rinfo->family == CHIP_FAMILY_R300 ||
-	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	if (IS_R300_VARIANT(rinfo)) {
 		u32 tmp;
 
 		OUTREG(RBBM_SOFT_RESET, (rbbm_soft_reset |
@@ -241,9 +239,7 @@ void radeonfb_engine_reset(struct radeonfb_info *rinfo)
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 ||
-	    rinfo->family != CHIP_FAMILY_R350 ||
-	    rinfo->family != CHIP_FAMILY_RV350)
+	if (IS_R300_VARIANT(rinfo))
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
 	OUTREG(CLOCK_CNTL_INDEX, clock_cntl_index);
@@ -254,16 +250,15 @@ void radeonfb_engine_init (struct radeonfb_info *rinfo)
 {
 	unsigned long temp;
 
-	/* disable 3D engine */
-	OUTREG(RB3D_CNTL, 0);
-
 	radeonfb_engine_reset(rinfo);
 
 	radeon_fifo_wait (1);
-	if ((rinfo->family != CHIP_FAMILY_R300) &&
-	    (rinfo->family != CHIP_FAMILY_R350) &&
-	    (rinfo->family != CHIP_FAMILY_RV350))
+	if (IS_R300_VARIANT(rinfo)) {
+		temp = INREG(RB2D_DSTCACHE_MODE);
+		OUTREG(RB2D_DSTCACHE_MODE, temp | (1<<17)); /* FIXME */
+	} else {
 		OUTREG(RB2D_DSTCACHE_MODE, 0);
+	}
 
 	radeon_fifo_wait (3);
 	/* We re-read MC_FB_LOCATION from card as it can have been
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 0be25fa..0c264f3 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -52,7 +52,7 @@ static int radeon_bl_update_status(struct backlight_device *bd)
 	u32 lvds_gen_cntl, tmpPixclksCntl;
 	int level;
 
-	if (rinfo->mon1_type != MT_LCD)
+	if (PRIMARY_MONITOR(rinfo) != MT_LCD)
 		return 0;
 
 	/* We turn off the LCD completely instead of just dimming the
@@ -138,7 +138,7 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 	struct radeon_bl_privdata *pdata;
 	char name[12];
 
-	if (rinfo->mon1_type != MT_LCD)
+	if (PRIMARY_MONITOR(rinfo) == MT_LCD)
 		return;
 
 #ifdef CONFIG_PMAC_BACKLIGHT
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 2ce0501..9616303 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -3,6 +3,7 @@
  *
  *	framebuffer driver for ATI Radeon chipset video boards
  *
+ *	Copyright 2006	Solomon Peachy <pizza@shaftnet.org>
  *	Copyright 2003	Ben. Herrenschmidt <benh@kernel.crashing.org>
  *	Copyright 2000	Ani Joshi <ajoshi@kernel.crashing.org>
  *
@@ -50,7 +51,7 @@
  */
 
 
-#define RADEON_VERSION	"0.2.0"
+#define RADEON_VERSION	"0.3.0"
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -112,7 +113,7 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	/* Radeon IGP320M (U1) */
 	CHIP_DEF(PCI_CHIP_RS100_4336,	RS100,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Radeon IGP320 (A3) */
-	CHIP_DEF(PCI_CHIP_RS100_4136,	RS100,	CHIP_HAS_CRTC2 | CHIP_IS_IGP), 
+	CHIP_DEF(PCI_CHIP_RS100_4136,	RS100,	CHIP_HAS_CRTC2 | CHIP_IS_IGP),
 	/* IGP330M/340M/350M (U2) */
 	CHIP_DEF(PCI_CHIP_RS200_4337,	RS200,	CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* IGP330/340/350 (A4) */
@@ -182,6 +183,7 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	CHIP_DEF(PCI_CHIP_RV360_AR,	RV350,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV350_AS,	RV350,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV350_AT,	RV350,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV350_AU, 	RV350,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV350_AV,	RV350,	CHIP_HAS_CRTC2),
 	/* 9800/Pro/FileGL X2 */
 	CHIP_DEF(PCI_CHIP_R350_AH,	R350,	CHIP_HAS_CRTC2),
@@ -192,7 +194,7 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	CHIP_DEF(PCI_CHIP_R350_NI,	R350,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R360_NJ,	R350,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R350_NK,	R350,	CHIP_HAS_CRTC2),
-	/* Newer stuff */
+	/* X300/X600 */
 	CHIP_DEF(PCI_CHIP_RV380_3E50,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV380_3E54,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV380_3150,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
@@ -203,6 +205,19 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	CHIP_DEF(PCI_CHIP_RV370_5B65,	RV380,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_RV370_5460,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RV370_5464,	RV380,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	/* X700 */
+	CHIP_DEF(PCI_CHIP_RV410_VJ, 	RV410,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RV410_VK, 	RV410,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RV410_VO, 	RV410,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RV410_VR, 	RV410,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RV410_VS, 	RV410,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_RV410_5E48,	RV410,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV410_5E4A,	RV410,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV410_5E4B,	RV410,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV410_5E4C,	RV410,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV410_5E4D,	RV410,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_RV410_5E4F,	RV410,	CHIP_HAS_CRTC2),
+	/* X800/X850 */
 	CHIP_DEF(PCI_CHIP_R420_JH,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R420_JI,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R420_JJ,	R420,	CHIP_HAS_CRTC2),
@@ -210,7 +225,9 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	CHIP_DEF(PCI_CHIP_R420_JL,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R420_JM,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R420_JN,	R420,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_R420_JO, 	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R420_JP,	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R420_JT, 	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R423_UH,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R423_UI,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R423_UJ,	R420,	CHIP_HAS_CRTC2),
@@ -219,6 +236,24 @@ static struct pci_device_id radeonfb_pci_table[] = {
 	CHIP_DEF(PCI_CHIP_R423_UR,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R423_UT,	R420,	CHIP_HAS_CRTC2),
 	CHIP_DEF(PCI_CHIP_R423_5D57,	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R423_UP, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R423_5D49, 	R420,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_R423_5D4A, 	R420,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_R423_5D48, 	R420,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
+	CHIP_DEF(PCI_CHIP_R423_UO, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R423_UM, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R423_UN, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R423_UL, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_5D4C, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_5D50, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_5D4E, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_5D4F, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_5D52, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_5D4D, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_KJ, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_KK,    R420,     CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_KI, 	R420,	CHIP_HAS_CRTC2),
+	CHIP_DEF(PCI_CHIP_R480_KL, 	R420,	CHIP_HAS_CRTC2),
 	/* Original Radeon/7200 */
 	CHIP_DEF(PCI_CHIP_RADEON_QD,	RADEON,	0),
 	CHIP_DEF(PCI_CHIP_RADEON_QE,	RADEON,	0),
@@ -239,7 +274,7 @@ typedef struct {
  * interfere with anything
  */
 static reg_val common_regs[] = {
-	{ OVR_CLR, 0 },	
+	{ OVR_CLR, 0 },
 	{ OVR_WID_LEFT_RIGHT, 0 },
 	{ OVR_WID_TOP_BOTTOM, 0 },
 	{ OV0_SCALE_CNTL, 0 },
@@ -254,13 +289,13 @@ static reg_val common_regs[] = {
 /*
  * globals
  */
-        
 static char *mode_option;
 static char *monitor_layout;
 static int noaccel = 0;
 static int default_dynclk = -2;
 static int nomodeset = 0;
 static int ignore_edid = 0;
+static int ignore_conntable = 0;
 static int mirror = 0;
 static int panel_yres = 0;
 static int force_dfp = 0;
@@ -276,6 +311,12 @@ static int backlight = 1;
 static int backlight = 0;
 #endif
 
+#ifdef CONFIG_FB_RADEON_DEBUG
+int radeonfb_debug = 1;
+#else
+int radeonfb_debug = 0;
+#endif
+
 /*
  * prototypes
  */
@@ -331,7 +372,7 @@ static int __devinit radeon_map_ROM(struct radeonfb_info *rinfo, struct pci_dev
 	 * to phase out Open Firmware images.
 	 *
 	 * Currently, we only look at the first PCI data, we could iteratre and deal with
-	 * them all, and we should use fb_bios_start relative to start of image and not
+	 * them all, and we should use fp_bios_start relative to start of image and not
 	 * relative start of ROM, but so far, I never found a dual-image ATI card
 	 *
 	 * typedef struct {
@@ -417,7 +458,7 @@ static int  __devinit radeon_find_mem_vbios(struct radeonfb_info *rinfo)
  * Read XTAL (ref clock), SCLK and MCLK from Open Firmware device
  * tree. Hopefully, ATI OF driver is kind enough to fill these
  */
-static int __devinit radeon_read_xtal_OF (struct radeonfb_info *rinfo)
+static int __devinit radeon_get_pll_info_openfirmware (struct radeonfb_info *rinfo)
 {
 	struct device_node *dp = rinfo->of_node;
 	const u32 *val;
@@ -440,7 +481,8 @@ static int __devinit radeon_read_xtal_OF (struct radeonfb_info *rinfo)
 	if (val && *val)
 		rinfo->pll.mclk = (*val) / 10;
 
-       	return 0;
+	RTRACE("Retrieved PLL infos from Open Firmware\n");
+	return 0;
 }
 #endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 
@@ -582,10 +624,87 @@ static int __devinit radeon_probe_pll_params(struct radeonfb_info *rinfo)
 	return 0;
 }
 
+static int __devinit radeon_get_pll_info_legacy(struct radeonfb_info *rinfo)
+{
+	u16 pll_info_block;
+
+	if (!rinfo->bios_seg)
+		return -EINVAL;
+
+	pll_info_block = BIOS_IN16(rinfo->fp_bios_start + 0x30);
+
+	rinfo->pll.sclk		= BIOS_IN16(pll_info_block + 0x08);
+	rinfo->pll.mclk		= BIOS_IN16(pll_info_block + 0x0a);
+	rinfo->pll.ref_clk	= BIOS_IN16(pll_info_block + 0x0e);
+	rinfo->pll.ref_div	= BIOS_IN16(pll_info_block + 0x10);
+	rinfo->pll.ppll_min	= BIOS_IN32(pll_info_block + 0x12);
+	rinfo->pll.ppll_max	= BIOS_IN32(pll_info_block + 0x16);
+
+	RTRACE("Retrieved PLL infos from Legacy BIOS\n");
+	return 0;
+}
+
+
+static int __devinit radeon_get_pll_info_atom(struct radeonfb_info *rinfo)
+{
+	u16 pll_info_block;
+
+	if (!rinfo->bios_seg)
+		return -EINVAL;
+
+	pll_info_block = BIOS_IN16(rinfo->atom_data_start + 12);
+
+	rinfo->pll.sclk = BIOS_IN32(pll_info_block + 8);
+	rinfo->pll.mclk = BIOS_IN32(pll_info_block + 12);
+	rinfo->pll.ref_clk = BIOS_IN16(pll_info_block + 82);
+	rinfo->pll.ref_div = 0; /* Have to get it elsewhere */
+	rinfo->pll.ppll_min = BIOS_IN16(pll_info_block + 78);
+	rinfo->pll.ppll_max = BIOS_IN32(pll_info_block + 32);
+
+	RTRACE("Retrieved PLL infos from ATOM BIOS\n");
+	return 0;
+}
+
+static void radeon_detect_bios_type(struct radeonfb_info *rinfo)
+{
+#if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
+	rinfo->is_atom_bios = 0;
+	rinfo->radeon_get_pll_info = radeon_get_pll_info_openfirmware;
+	rinfo->radeon_get_lvds_info = radeon_get_lvds_info_openfirmware;
+	rinfo->radeon_get_tmds_info = NULL;
+	rinfo->radeon_get_conn_info = radeon_get_conn_info_openfirmware;
+#else
+	int tmp = rinfo->fp_bios_start + 4;
+	unsigned char sign[4];
+
+	sign[0] = BIOS_IN8(tmp);
+	sign[1] = BIOS_IN8(tmp + 1);
+	sign[2] = BIOS_IN8(tmp + 2);
+	sign[3] = BIOS_IN8(tmp + 3);
+
+	if (!memcmp(sign, "ATOM", 4) || !memcmp(sign, "MOTA", 4)) {
+		rinfo->is_atom_bios = 1;
+
+		rinfo->atom_data_start = BIOS_IN16(rinfo->fp_bios_start + 32);
+		rinfo->radeon_get_pll_info = radeon_get_pll_info_atom;
+		rinfo->radeon_get_lvds_info = radeon_get_lvds_info_atom;
+		rinfo->radeon_get_conn_info = radeon_get_conn_info_atom;
+		rinfo->radeon_get_tmds_info = radeon_get_tmds_info_atom;
+	} else {
+		rinfo->is_atom_bios = 0;
+		rinfo->radeon_get_pll_info = radeon_get_pll_info_legacy;
+		rinfo->radeon_get_lvds_info = radeon_get_lvds_info_legacy;
+		rinfo->radeon_get_conn_info = radeon_get_conn_info_legacy;
+		rinfo->radeon_get_tmds_info = radeon_get_tmds_info_legacy;
+	}
+#endif  /* CONFIG_PPC_OF || defined(CONFIG_SPARC) */
+
+}
+
 /*
  * Retrieve PLL infos by different means (BIOS, Open Firmware, register probing...)
  */
-static void __devinit radeon_get_pllinfo(struct radeonfb_info *rinfo)
+static void __devinit radeon_get_pll_info(struct radeonfb_info *rinfo)
 {
 	/*
 	 * In the case nothing works, these are defaults; they are mostly
@@ -637,46 +756,30 @@ static void __devinit radeon_get_pllinfo(struct radeonfb_info *rinfo)
 	case PCI_DEVICE_ID_ATI_RADEON_QF:
 	case PCI_DEVICE_ID_ATI_RADEON_QG:
 	default:
-		rinfo->pll.ppll_max = 35000;
-		rinfo->pll.ppll_min = 12000;
+		if (rinfo->family == CHIP_FAMILY_R420) {
+			rinfo->pll.ppll_max = 50000;
+			rinfo->pll.ppll_min = 20000;
+		} else {
+			rinfo->pll.ppll_max = 35000;
+			rinfo->pll.ppll_min = 12000;
+		}
 		rinfo->pll.mclk = 16600;
 		rinfo->pll.sclk = 16600;
 		rinfo->pll.ref_clk = 2700;
 		break;
 	}
-	rinfo->pll.ref_div = INPLL(PPLL_REF_DIV) & PPLL_REF_DIV_MASK;
-
-
-#if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
-	/*
-	 * Retrieve PLL infos from Open Firmware first
-	 */
-       	if (!force_measure_pll && radeon_read_xtal_OF(rinfo) == 0) {
-       		printk(KERN_INFO "radeonfb: Retrieved PLL infos from Open Firmware\n");
-		goto found;
-	}
-#endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 
 	/*
-	 * Check out if we have an X86 which gave us some PLL informations
-	 * and if yes, retrieve them
+	 * If we have a way to retrieve the PLL information, do so.
 	 */
-	if (!force_measure_pll && rinfo->bios_seg) {
-		u16 pll_info_block = BIOS_IN16(rinfo->fp_bios_start + 0x30);
-
-		rinfo->pll.sclk		= BIOS_IN16(pll_info_block + 0x08);
-		rinfo->pll.mclk		= BIOS_IN16(pll_info_block + 0x0a);
-		rinfo->pll.ref_clk	= BIOS_IN16(pll_info_block + 0x0e);
-		rinfo->pll.ref_div	= BIOS_IN16(pll_info_block + 0x10);
-		rinfo->pll.ppll_min	= BIOS_IN32(pll_info_block + 0x12);
-		rinfo->pll.ppll_max	= BIOS_IN32(pll_info_block + 0x16);
-
-		printk(KERN_INFO "radeonfb: Retrieved PLL infos from BIOS\n");
-		goto found;
+	if (!force_measure_pll && rinfo->radeon_get_pll_info) {
+		if (!rinfo->radeon_get_pll_info(rinfo)) {
+			goto found;
+		}
 	}
 
 	/*
-	 * We didn't get PLL parameters from either OF or BIOS, we try to
+	 * If we don't get the PLL parameters handed to us, we try to
 	 * probe them
 	 */
 	if (radeon_probe_pll_params(rinfo) == 0) {
@@ -687,9 +790,25 @@ static void __devinit radeon_get_pllinfo(struct radeonfb_info *rinfo)
 	/*
 	 * Fall back to already-set defaults...
 	 */
-       	printk(KERN_INFO "radeonfb: Used default PLL infos\n");
+	printk(KERN_INFO "radeonfb: Used default PLL infos\n");
 
 found:
+
+	/* Check and fix-up the PLL divisor if necessary */
+	if (rinfo->pll.ref_div < 2) {
+		int tmp = INPLL(PPLL_REF_DIV);
+		if (rinfo->family == CHIP_FAMILY_RS300) {
+			rinfo->pll.ref_div = (tmp & R300_PPLL_REF_DIV_ACC_MASK) >> R300_PPLL_REF_DIV_ACC_SHIFT;
+		} else {
+			rinfo->pll.ref_div = tmp & PPLL_REF_DIV_MASK;
+		}
+
+		/* Sane default */
+		if (rinfo->pll.ref_div < 2) {
+			rinfo->pll.ref_div = 12;
+		}
+	}
+
 	/*
 	 * Some methods fail to retrieve SCLK and MCLK values, we apply default
 	 * settings in this case (200Mhz). If that really happne often, we could
@@ -705,7 +824,7 @@ found:
 	       rinfo->pll.ref_div,
 	       rinfo->pll.mclk / 100, rinfo->pll.mclk % 100,
 	       rinfo->pll.sclk / 100, rinfo->pll.sclk % 100);
-	printk("radeonfb: PLL min %d max %d\n", rinfo->pll.ppll_min, rinfo->pll.ppll_max);
+	RTRACE("PLL min %d max %d\n", rinfo->pll.ppll_min, rinfo->pll.ppll_max);
 }
 
 static int radeonfb_check_var (struct fb_var_screeninfo *var, struct fb_info *info)
@@ -846,7 +965,7 @@ static int radeonfb_pan_display (struct fb_var_screeninfo *var,
         if (rinfo->asleep)
         	return 0;
 
-	radeon_fifo_wait(2);
+	radeon_engine_idle();
         OUTREG(CRTC_OFFSET, ((var->yoffset * var->xres_virtual + var->xoffset)
 			     * var->bits_per_pixel / 8) & ~7);
         return 0;
@@ -927,9 +1046,10 @@ static int radeonfb_ioctl (struct fb_info *info, unsigned int cmd,
 
 int radeon_screen_blank(struct radeonfb_info *rinfo, int blank, int mode_switch)
 {
-        u32 val;
+	u32 val;
 	u32 tmp_pix_clks;
 	int unblank = 0;
+	int i;
 
 	if (rinfo->lock_blank)
 		return 0;
@@ -937,9 +1057,9 @@ int radeon_screen_blank(struct radeonfb_info *rinfo, int blank, int mode_switch)
 	radeon_engine_idle();
 
 	val = INREG(CRTC_EXT_CNTL);
-        val &= ~(CRTC_DISPLAY_DIS | CRTC_HSYNC_DIS |
+	val &= ~(CRTC_DISPLAY_DIS | CRTC_HSYNC_DIS |
                  CRTC_VSYNC_DIS);
-        switch (blank) {
+	switch (blank) {
 	case FB_BLANK_VSYNC_SUSPEND:
 		val |= (CRTC_DISPLAY_DIS | CRTC_VSYNC_DIS);
 		break;
@@ -956,81 +1076,84 @@ int radeon_screen_blank(struct radeonfb_info *rinfo, int blank, int mode_switch)
 	case FB_BLANK_UNBLANK:
 	default:
 		unblank = 1;
-        }
+	}
 	OUTREG(CRTC_EXT_CNTL, val);
 
+	for (i = 0 ; i < RADEON_MAX_CONNECTORS ; i++) {
+		if (rinfo->heads[i] == -1)
+			continue;
 
-	switch (rinfo->mon1_type) {
-	case MT_DFP:
-		if (unblank)
-			OUTREGP(FP_GEN_CNTL, (FP_FPON | FP_TMDS_EN),
-				~(FP_FPON | FP_TMDS_EN));
-		else {
-			if (mode_switch || blank == FB_BLANK_NORMAL)
-				break;
-			OUTREGP(FP_GEN_CNTL, 0, ~(FP_FPON | FP_TMDS_EN));
-		}
+		switch (rinfo->connectors[rinfo->heads[i]].mon_type) {
+		case MT_DFP:
+			if (unblank)
+				OUTREGP(FP_GEN_CNTL, (FP_FPON | FP_TMDS_EN),
+					~(FP_FPON | FP_TMDS_EN));
+			else {
+				if (mode_switch || blank == FB_BLANK_NORMAL)
+					break;
+				OUTREGP(FP_GEN_CNTL, 0, ~(FP_FPON | FP_TMDS_EN));
+			}
 		break;
-	case MT_LCD:
-		del_timer_sync(&rinfo->lvds_timer);
-		val = INREG(LVDS_GEN_CNTL);
-		if (unblank) {
-			u32 target_val = (val & ~LVDS_DISPLAY_DIS) | LVDS_BLON | LVDS_ON
-				| LVDS_EN | (rinfo->init_state.lvds_gen_cntl
-					     & (LVDS_DIGON | LVDS_BL_MOD_EN));
-			if ((val ^ target_val) == LVDS_DISPLAY_DIS)
-				OUTREG(LVDS_GEN_CNTL, target_val);
-			else if ((val ^ target_val) != 0) {
-				OUTREG(LVDS_GEN_CNTL, target_val
-				       & ~(LVDS_ON | LVDS_BL_MOD_EN));
-				rinfo->init_state.lvds_gen_cntl &= ~LVDS_STATE_MASK;
-				rinfo->init_state.lvds_gen_cntl |=
-					target_val & LVDS_STATE_MASK;
-				if (mode_switch) {
-					radeon_msleep(rinfo->panel_info.pwr_delay);
+		case MT_LCD:
+			del_timer_sync(&rinfo->lvds_timer);
+			val = INREG(LVDS_GEN_CNTL);
+			if (unblank) {
+				u32 target_val = (val & ~LVDS_DISPLAY_DIS) | LVDS_BLON | LVDS_ON
+					| LVDS_EN | (rinfo->init_state.lvds_gen_cntl
+						     & (LVDS_DIGON | LVDS_BL_MOD_EN));
+				if ((val ^ target_val) == LVDS_DISPLAY_DIS)
 					OUTREG(LVDS_GEN_CNTL, target_val);
+				else if ((val ^ target_val) != 0) {
+					OUTREG(LVDS_GEN_CNTL, target_val
+					       & ~(LVDS_ON | LVDS_BL_MOD_EN));
+					rinfo->init_state.lvds_gen_cntl &= ~LVDS_STATE_MASK;
+					rinfo->init_state.lvds_gen_cntl |=
+						target_val & LVDS_STATE_MASK;
+					if (mode_switch) {
+						radeon_msleep(rinfo->panel_info.pwr_delay);
+						OUTREG(LVDS_GEN_CNTL, target_val);
+					} else {
+						rinfo->pending_lvds_gen_cntl = target_val;
+						mod_timer(&rinfo->lvds_timer,
+							  jiffies +
+							  msecs_to_jiffies(rinfo->panel_info.pwr_delay));
+					}
 				}
-				else {
-					rinfo->pending_lvds_gen_cntl = target_val;
-					mod_timer(&rinfo->lvds_timer,
-					   jiffies +
-					   msecs_to_jiffies(rinfo->panel_info.pwr_delay));
-				}
+			} else {
+				val |= LVDS_DISPLAY_DIS;
+				OUTREG(LVDS_GEN_CNTL, val);
+
+				/* We don't do a full switch-off on a simple mode switch */
+				if (mode_switch || blank == FB_BLANK_NORMAL)
+					break;
+
+				/* Asic bug, when turning off LVDS_ON, we have to make sure
+				 * RADEON_PIXCLK_LVDS_ALWAYS_ON bit is off
+				 */
+				tmp_pix_clks = INPLL(PIXCLKS_CNTL);
+				if (rinfo->is_mobility || rinfo->is_IGP)
+					OUTPLLP(PIXCLKS_CNTL, 0, ~PIXCLK_LVDS_ALWAYS_ONb);
+				val &= ~(LVDS_BL_MOD_EN);
+				OUTREG(LVDS_GEN_CNTL, val);
+				udelay(100);
+				val &= ~(LVDS_ON | LVDS_EN);
+				OUTREG(LVDS_GEN_CNTL, val);
+				val &= ~LVDS_DIGON;
+				rinfo->pending_lvds_gen_cntl = val;
+				mod_timer(&rinfo->lvds_timer,
+					  jiffies +
+					  msecs_to_jiffies(rinfo->panel_info.pwr_delay));
+				rinfo->init_state.lvds_gen_cntl &= ~LVDS_STATE_MASK;
+				rinfo->init_state.lvds_gen_cntl |= val & LVDS_STATE_MASK;
+				if (rinfo->is_mobility || rinfo->is_IGP)
+					OUTPLL(PIXCLKS_CNTL, tmp_pix_clks);
 			}
-		} else {
-			val |= LVDS_DISPLAY_DIS;
-			OUTREG(LVDS_GEN_CNTL, val);
-
-			/* We don't do a full switch-off on a simple mode switch */
-			if (mode_switch || blank == FB_BLANK_NORMAL)
-				break;
-
-			/* Asic bug, when turning off LVDS_ON, we have to make sure
-			 * RADEON_PIXCLK_LVDS_ALWAYS_ON bit is off
-			 */
-			tmp_pix_clks = INPLL(PIXCLKS_CNTL);
-			if (rinfo->is_mobility || rinfo->is_IGP)
-				OUTPLLP(PIXCLKS_CNTL, 0, ~PIXCLK_LVDS_ALWAYS_ONb);
-			val &= ~(LVDS_BL_MOD_EN);
-			OUTREG(LVDS_GEN_CNTL, val);
-			udelay(100);
-			val &= ~(LVDS_ON | LVDS_EN);
-			OUTREG(LVDS_GEN_CNTL, val);
-			val &= ~LVDS_DIGON;
-			rinfo->pending_lvds_gen_cntl = val;
-			mod_timer(&rinfo->lvds_timer,
-				  jiffies +
-				  msecs_to_jiffies(rinfo->panel_info.pwr_delay));
-			rinfo->init_state.lvds_gen_cntl &= ~LVDS_STATE_MASK;
-			rinfo->init_state.lvds_gen_cntl |= val & LVDS_STATE_MASK;
-			if (rinfo->is_mobility || rinfo->is_IGP)
-				OUTPLL(PIXCLKS_CNTL, tmp_pix_clks);
+			break;
+		case MT_CRT:
+			// todo: powerdown DAC
+		default:
+			break;
 		}
-		break;
-	case MT_CRT:
-		// todo: powerdown DAC
-	default:
-		break;
 	}
 
 	return 0;
@@ -1260,7 +1383,7 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
 				~PPLL_DIV_SEL_MASK);
 			radeon_pll_errata_after_index(rinfo);
 			radeon_pll_errata_after_data(rinfo);
-            		return;
+			return;
 		}
 	}
 
@@ -1280,10 +1403,7 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
 	radeon_pll_errata_after_data(rinfo);
 
 	/* Set PPLL ref. div */
-	if (rinfo->family == CHIP_FAMILY_R300 ||
-	    rinfo->family == CHIP_FAMILY_RS300 ||
-	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	if (IS_R300_VARIANT(rinfo) || (rinfo->family == CHIP_FAMILY_RS300)) {
 		if (mode->ppll_ref_div & R300_PPLL_REF_DIV_ACC_MASK) {
 			/* When restoring console mode, use saved PPLL_REF_DIV
 			 * setting.
@@ -1292,7 +1412,7 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
 		} else {
 			/* R300 uses ref_div_acc field as real ref divider */
 			OUTPLLP(PPLL_REF_DIV,
-				(mode->ppll_ref_div << R300_PPLL_REF_DIV_ACC_SHIFT), 
+				(mode->ppll_ref_div << R300_PPLL_REF_DIV_ACC_SHIFT),
 				~R300_PPLL_REF_DIV_ACC_MASK);
 		}
 	} else
@@ -1380,6 +1500,7 @@ void radeon_write_mode (struct radeonfb_info *rinfo, struct radeon_regs *mode,
 	OUTREG(CRTC_OFFSET_CNTL, 0);
 	OUTREG(CRTC_PITCH, mode->crtc_pitch);
 	OUTREG(SURFACE_CNTL, mode->surface_cntl);
+	OUTREG(DISP_MERGE_CNTL, 0xffff0000);
 
 	radeon_write_pll_regs(rinfo, mode);
 
@@ -1890,7 +2011,7 @@ static int __devinit radeon_set_fbinfo (struct radeonfb_info *rinfo)
         info->fix.ywrapstep = 0;
         info->fix.type_aux = 0;
         info->fix.mmio_start = rinfo->mmio_base_phys;
-        info->fix.mmio_len = RADEON_REGSIZE;
+        info->fix.mmio_len = pci_resource_len(rinfo->pdev, 2);
 	info->fix.accel = FB_ACCEL_ATI_RADEON;
 
 	fb_alloc_cmap(&info->cmap, 256, 0);
@@ -1994,10 +2115,7 @@ static void radeon_identify_vram(struct radeonfb_info *rinfo)
 	u32 tmp;
 
 	/* framebuffer size */
-        if ((rinfo->family == CHIP_FAMILY_RS100) ||
-            (rinfo->family == CHIP_FAMILY_RS200) ||
-            (rinfo->family == CHIP_FAMILY_RS300) ||
-	    (rinfo->family == CHIP_FAMILY_RS480) ) {
+        if (rinfo->is_IGP) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
 
@@ -2025,6 +2143,10 @@ static void radeon_identify_vram(struct radeonfb_info *rinfo)
 	/* mem size is bits [28:0], mask off the rest */
 	rinfo->video_ram = tmp & CONFIG_MEMSIZE_MASK;
 
+	/* Limit memory to 128 megs for now */
+	if (rinfo->video_ram > MAX_VRAM)
+		rinfo->video_ram = MAX_VRAM;
+
 	/*
 	 * Hack to get around some busted production M6's
 	 * reporting no ram
@@ -2106,10 +2228,10 @@ static ssize_t radeon_show_edid1(struct kobject *kobj, char *buf, loff_t off, si
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
-        struct fb_info *info = pci_get_drvdata(pdev);
-        struct radeonfb_info *rinfo = info->par;
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct radeonfb_info *rinfo = info->par;
 
-	return radeon_show_one_edid(buf, off, count, rinfo->mon1_EDID);
+	return radeon_show_one_edid(buf, off, count, rinfo->connectors[rinfo->heads[0]].edid);
 }
 
 
@@ -2117,10 +2239,30 @@ static ssize_t radeon_show_edid2(struct kobject *kobj, char *buf, loff_t off, si
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
-        struct fb_info *info = pci_get_drvdata(pdev);
-        struct radeonfb_info *rinfo = info->par;
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct radeonfb_info *rinfo = info->par;
+
+	return radeon_show_one_edid(buf, off, count, rinfo->connectors[rinfo->heads[1]].edid);
+}
+
+static ssize_t radeon_show_edid3(struct kobject *kobj, char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct radeonfb_info *rinfo = info->par;
+
+	return radeon_show_one_edid(buf, off, count, rinfo->connectors[rinfo->heads[2]].edid);
+}
+
+static ssize_t radeon_show_edid4(struct kobject *kobj, char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct radeonfb_info *rinfo = info->par;
 
-	return radeon_show_one_edid(buf, off, count, rinfo->mon2_EDID);
+	return radeon_show_one_edid(buf, off, count, rinfo->connectors[rinfo->heads[3]].edid);
 }
 
 static struct bin_attribute edid1_attr = {
@@ -2143,6 +2285,25 @@ static struct bin_attribute edid2_attr = {
 	.read	= radeon_show_edid2,
 };
 
+static struct bin_attribute edid3_attr = {
+	.attr   = {
+		.name	= "edid3",
+		.owner	= THIS_MODULE,
+		.mode	= 0444,
+	},
+	.size	= EDID_LENGTH,
+	.read	= radeon_show_edid3,
+};
+
+static struct bin_attribute edid4_attr = {
+	.attr   = {
+		.name	= "edid4",
+		.owner	= THIS_MODULE,
+		.mode	= 0444,
+	},
+	.size	= EDID_LENGTH,
+	.read	= radeon_show_edid4,
+};
 
 static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
@@ -2150,9 +2311,10 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	struct fb_info *info;
 	struct radeonfb_info *rinfo;
 	int ret;
+	int i;
 
 	RTRACE("radeonfb_pci_register BEGIN\n");
-	
+
 	/* Enable device in PCI config */
 	ret = pci_enable_device(pdev);
 	if (ret < 0) {
@@ -2169,9 +2331,9 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 		goto err_disable;
 	}
 	rinfo = info->par;
-	rinfo->info = info;	
+	rinfo->info = info;
 	rinfo->pdev = pdev;
-	
+
 	spin_lock_init(&rinfo->reg_lock);
 	init_timer(&rinfo->lvds_timer);
 	rinfo->lvds_timer.function = radeon_lvds_timer_func;
@@ -2206,7 +2368,8 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	}
 
 	/* map the regions */
-	rinfo->mmio_base = ioremap(rinfo->mmio_base_phys, RADEON_REGSIZE);
+	rinfo->mmio_base = ioremap(rinfo->mmio_base_phys,
+				   pci_resource_len(rinfo->pdev, 2));
 	if (!rinfo->mmio_base) {
 		printk(KERN_ERR "radeonfb (%s): cannot map MMIO\n",
 		       pci_name(rinfo->pdev));
@@ -2258,7 +2421,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	rinfo->mapped_vram = min_t(unsigned long, MAX_MAPPED_VRAM, rinfo->video_ram);
 
 	do {
-		rinfo->fb_base = ioremap (rinfo->fb_base_phys,
+		rinfo->fb_base = ioremap(rinfo->fb_base_phys,
 					  rinfo->mapped_vram);
 	} while (   rinfo->fb_base == 0 &&
 		  ((rinfo->mapped_vram /=2) >= MIN_MAPPED_VRAM) );
@@ -2293,6 +2456,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	 * We probably need to make sure this is the primary display,
 	 * but that is difficult without some arch support.
 	 */
+
 #ifdef CONFIG_X86
 	if (rinfo->bios_seg == NULL)
 		radeon_find_mem_vbios(rinfo);
@@ -2304,14 +2468,23 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	if (rinfo->bios_seg == NULL && rinfo->is_mobility)
 		radeon_map_ROM(rinfo, pdev);
 
+	/* Check BIOS Type */
+	radeon_detect_bios_type(rinfo);
+
 	/* Get informations about the board's PLL */
-	radeon_get_pllinfo(rinfo);
+	radeon_get_pll_info(rinfo);
+
+	/* Get informations about internal TMDS controller if any */
+	radeon_get_tmds_info(rinfo);
 
 #ifdef CONFIG_FB_RADEON_I2C
 	/* Register I2C bus */
 	radeon_create_i2c_busses(rinfo);
 #endif
 
+	/* Get infos about connectors -- need I2C here! */
+	radeon_get_conn_info(rinfo, ignore_conntable);
+
 	/* set all the vital stuff */
 	radeon_set_fbinfo (rinfo);
 
@@ -2322,10 +2495,15 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	radeon_check_modes(rinfo, mode_option);
 
 	/* Register some sysfs stuff (should be done better) */
-	if (rinfo->mon1_EDID)
+
+	if ((rinfo->heads[0] != -1) && rinfo->connectors[rinfo->heads[0]].edid)
 		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
-	if (rinfo->mon2_EDID)
+	if ((rinfo->heads[1] != -1) && rinfo->connectors[rinfo->heads[1]].edid)
 		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+	if ((rinfo->heads[2] != -1) && rinfo->connectors[rinfo->heads[2]].edid)
+		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid3_attr);
+	if ((rinfo->heads[3] != -1) && rinfo->connectors[rinfo->heads[3]].edid)
+		sysfs_create_bin_file(&rinfo->pdev->dev.kobj, &edid4_attr);
 
 	/* save current mode regs before we switch into the new one
 	 * so we can restore this upon __exit
@@ -2371,10 +2549,12 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 err_unmap_fb:
 	iounmap(rinfo->fb_base);
 err_unmap_rom:
-	kfree(rinfo->mon1_EDID);
-	kfree(rinfo->mon2_EDID);
-	if (rinfo->mon1_modedb)
-		fb_destroy_modedb(rinfo->mon1_modedb);
+	for (i = 0 ; i < RADEON_MAX_CONNECTORS ; i++) {
+		kfree(rinfo->connectors[i].edid);
+		if (rinfo->connectors[i].modedb)
+			fb_destroy_modedb(rinfo->connectors[i].modedb);
+	}
+
 	fb_dealloc_cmap(&info->cmap);
 #ifdef CONFIG_FB_RADEON_I2C
 	radeon_delete_i2c_busses(rinfo);
@@ -2387,7 +2567,7 @@ err_release_pci2:
 err_release_pci0:
 	pci_release_region(pdev, 0);
 err_release_fb:
-        framebuffer_release(info);
+	framebuffer_release(info);
 err_disable:
 err_out:
 	return ret;
@@ -2399,16 +2579,21 @@ static void __devexit radeonfb_pci_unregister (struct pci_dev *pdev)
 {
         struct fb_info *info = pci_get_drvdata(pdev);
         struct radeonfb_info *rinfo = info->par;
+	int i;
  
         if (!rinfo)
                 return;
 
 	radeonfb_pm_exit(rinfo);
 
-	if (rinfo->mon1_EDID)
+	if ((rinfo->heads[0] != -1) && rinfo->connectors[rinfo->heads[0]].edid)
 		sysfs_remove_bin_file(&rinfo->pdev->dev.kobj, &edid1_attr);
-	if (rinfo->mon2_EDID)
+	if ((rinfo->heads[1] != -1) && rinfo->connectors[rinfo->heads[1]].edid)
 		sysfs_remove_bin_file(&rinfo->pdev->dev.kobj, &edid2_attr);
+	if ((rinfo->heads[2] != -1) && rinfo->connectors[rinfo->heads[2]].edid)
+		sysfs_remove_bin_file(&rinfo->pdev->dev.kobj, &edid3_attr);
+	if ((rinfo->heads[3] != -1) && rinfo->connectors[rinfo->heads[3]].edid)
+		sysfs_remove_bin_file(&rinfo->pdev->dev.kobj, &edid4_attr);
 
 #if 0
 	/* restore original state
@@ -2437,13 +2622,14 @@ static void __devexit radeonfb_pci_unregister (struct pci_dev *pdev)
 	pci_release_region(pdev, 2);
 	pci_release_region(pdev, 0);
 
-	kfree(rinfo->mon1_EDID);
-	kfree(rinfo->mon2_EDID);
-	if (rinfo->mon1_modedb)
-		fb_destroy_modedb(rinfo->mon1_modedb);
+	for (i = 0; i < RADEON_MAX_CONNECTORS; i++) {
+		kfree(rinfo->connectors[i].edid);
+		if (rinfo->connectors[i].modedb)
+			fb_destroy_modedb(rinfo->connectors[i].modedb);
+	}
 #ifdef CONFIG_FB_RADEON_I2C
 	radeon_delete_i2c_busses(rinfo);
-#endif        
+#endif
 	fb_dealloc_cmap(&info->cmap);
         framebuffer_release(info);
 }
@@ -2492,12 +2678,18 @@ static int __init radeonfb_setup (char *options)
 			force_measure_pll = 1;
 		} else if (!strncmp(this_opt, "ignore_edid", 11)) {
 			ignore_edid = 1;
+		} else if (!strncmp(this_opt, "ignore_conntable", 16)) {
+			ignore_conntable = 1;
+		} else if (!strncmp( this_opt, "default_dynclk:", 15)) {
+			default_dynclk = simple_strtoul((this_opt+15), NULL, 10);
 #if defined(CONFIG_PM) && defined(CONFIG_X86)
-	 	} else if (!strncmp(this_opt, "force_sleep", 11)) {
+		} else if (!strncmp(this_opt, "force_sleep", 11)) {
 			force_sleep = 1;
 		} else if (!strncmp(this_opt, "ignore_devlist", 14)) {
 			ignore_devlist = 1;
 #endif
+		} else if (!strncmp(this_opt, "debug", 5)) {
+			radeonfb_debug = 1;
 		} else
 			mode_option = this_opt;
 	}
@@ -2541,6 +2733,8 @@ module_param(force_dfp, bool, 0);
 MODULE_PARM_DESC(force_dfp, "bool: force display to dfp");
 module_param(ignore_edid, bool, 0);
 MODULE_PARM_DESC(ignore_edid, "bool: Ignore EDID data when doing DDC probe");
+module_param(ignore_conntable, bool, 0);
+MODULE_PARM_DESC(ignore_conntable, "bool: Ignore BIOS Connector table");
 module_param(monitor_layout, charp, 0);
 MODULE_PARM_DESC(monitor_layout, "Specify monitor mapping (like XFree86)");
 module_param(force_measure_pll, bool, 0);
@@ -2559,3 +2753,5 @@ MODULE_PARM_DESC(force_sleep, "bool: force D2 sleep mode on all hardware");
 module_param(ignore_devlist, bool, 0);
 MODULE_PARM_DESC(ignore_devlist, "bool: ignore workarounds for bugs in specific laptops");
 #endif
+module_param(radeonfb_debug, int, 0);
+MODULE_PARM_DESC(radeonfb_debug, "Enable full debugging text");
diff --git a/drivers/video/aty/radeon_i2c.c b/drivers/video/aty/radeon_i2c.c
index 7db9de6..e4bc267 100644
--- a/drivers/video/aty/radeon_i2c.c
+++ b/drivers/video/aty/radeon_i2c.c
@@ -134,35 +134,57 @@ void radeon_delete_i2c_busses(struct radeonfb_info *rinfo)
 	rinfo->i2c[3].rinfo = NULL;
 }
 
-int radeon_probe_i2c_connector(struct radeonfb_info *rinfo, int conn,
-			       u8 **out_edid)
+
+int radeon_probe_i2c_connector(struct radeonfb_info *rinfo, struct radeon_connector *conn)
 {
-	u32 reg = rinfo->i2c[conn-1].ddc_reg;
+	int mon_type = MT_NONE;
 	u8 *edid;
 
-	OUTREG(reg, INREG(reg) &
-			~(VGA_DDC_DATA_OUTPUT | VGA_DDC_CLK_OUTPUT));
+	if (!conn)
+		return 1;
+
+	if (rinfo->is_mobility && (conn->ddc_type == ddc_none) &&
+	    (INREG(LVDS_GEN_CNTL) & (LVDS_ON|LVDS_EN))) {
+			RTRACE("radeonfb: I2C (port %d) ... found LVDS panel\n", conn->ddc_type);
+			mon_type = MT_LCD;
+			edid = NULL;
+			goto done;
+	}
 
-	edid = fb_ddc_read(&rinfo->i2c[conn-1].adapter);
+	if (conn->ddc_type == ddc_none)
+		return 1;
+	edid = fb_ddc_read(&rinfo->i2c[conn->ddc_type].adapter);
 
-	if (out_edid)
-		*out_edid = edid;
 	if (!edid) {
-		RTRACE("radeonfb: I2C (port %d) ... not found\n", conn);
-		return MT_NONE;
+		/* what about the special case where we are a DFP/LVDS, but have a DDC connection
+		 * but no EDID? We should fall back to MT_LCD...?  XXXX
+		 */
+		RTRACE("radeonfb: I2C (port %d) ... not found\n", conn->ddc_type);
+		mon_type = MT_NONE;
+		goto done;
+	}
+	if ((edid[EDID_STRUCT_DISPLAY] & 0x80) && (conn->ddc_type == ddc_dvi)) {
+		RTRACE("radeonfb: I2C (port %d) ... found TMDS panel\n", conn->ddc_type);
+		mon_type = MT_DFP;
+		goto done;
 	}
-	if (edid[0x14] & 0x80) {
-		/* Fix detection using BIOS tables */
-		if (rinfo->is_mobility /*&& conn == ddc_dvi*/ &&
-		    (INREG(LVDS_GEN_CNTL) & LVDS_ON)) {
-			RTRACE("radeonfb: I2C (port %d) ... found LVDS panel\n", conn);
-			return MT_LCD;
-		} else {
-			RTRACE("radeonfb: I2C (port %d) ... found TMDS panel\n", conn);
-			return MT_DFP;
-		}
+
+	if (rinfo->is_mobility &&
+	    (conn->conn_type == conn_lvds) &&
+	    (edid[EDID_STRUCT_DISPLAY] & 0x80) &&  // ie EDID valid and marks us as a DFP...
+	    (INREG(LVDS_GEN_CNTL) & (LVDS_ON|LVDS_EN))) {
+		RTRACE("radeonfb: I2C (port %d) ... found LVDS panel\n", conn->ddc_type);
+		mon_type = MT_LCD;
+		goto done;
 	}
-       	RTRACE("radeonfb: I2C (port %d) ... found CRT display\n", conn);
-	return MT_CRT;
+
+	RTRACE("radeonfb: I2C (port %d) ... found CRT display\n", conn->ddc_type);
+	mon_type = MT_CRT;
+
+done:
+	conn->edid = edid;
+	conn->mon_type = mon_type;
+
+	return (mon_type == MT_NONE);
 }
 
diff --git a/drivers/video/aty/radeon_monitor.c b/drivers/video/aty/radeon_monitor.c
index 2030ed8..1b646d1 100644
--- a/drivers/video/aty/radeon_monitor.c
+++ b/drivers/video/aty/radeon_monitor.c
@@ -1,6 +1,29 @@
 #include "radeonfb.h"
 #include "../edid.h"
 
+/*
+ * TMDS PLL configuration table, taken from X.org
+ */
+static const struct radeon_tmds_pll_info default_tmds_pll[CHIP_FAMILY_LAST][4] =
+{
+	{{0, 0}, {0, 0}, {0, 0}, {0, 0}},				/*CHIP_FAMILY_UNKNOW*/
+	{{0, 0}, {0, 0}, {0, 0}, {0, 0}},				/*CHIP_FAMILY_LEGACY*/
+	{{12000, 0xa1b}, {0xffffffff, 0xa3f}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_RADEON*/
+	{{12000, 0xa1b}, {0xffffffff, 0xa3f}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_RV100*/
+	{{0, 0}, {0, 0}, {0, 0}, {0, 0}},				/*CHIP_FAMILY_RS100*/
+	{{15000, 0xa1b}, {0xffffffff, 0xa3f}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_RV200*/
+	{{12000, 0xa1b}, {0xffffffff, 0xa3f}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_RS200*/
+	{{15000, 0xa1b}, {0xffffffff, 0xa3f}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_R200*/
+	{{15500, 0x81b}, {0xffffffff, 0x83f}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_RV250*/
+	{{0, 0}, {0, 0}, {0, 0}, {0, 0}},				/*CHIP_FAMILY_RS300*/
+	{{13000, 0x400f4}, {15000, 0x400f7}, {0xffffffff, 0x400f7}, {0, 0}},	/*CHIP_FAMILY_RV280*/
+	{{0xffffffff, 0xb01cb}, {0, 0}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_R300*/
+	{{0xffffffff, 0xb01cb}, {0, 0}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_R350*/
+	{{15000, 0xb0155}, {0xffffffff, 0xb01cb}, {0, 0}, {0, 0}},	/*CHIP_FAMILY_RV350*/
+	{{15000, 0xb0155}, {0xffffffff, 0xb01cb}, {0, 0}, {0, 0}},	/*CHIP_FAMILY_RV380*/
+	{{0xffffffff, 0xb01cb}, {0, 0}, {0, 0}, {0, 0}},		/*CHIP_FAMILY_R420*/
+};
+
 static struct fb_var_screeninfo radeonfb_default_var = {
 	.xres		= 640,
 	.yres		= 480,
@@ -23,35 +46,311 @@ static struct fb_var_screeninfo radeonfb_default_var = {
 	.vmode		= FB_VMODE_NONINTERLACED
 };
 
-static char *radeon_get_mon_name(int type)
+
+int __devinit radeon_get_lvds_info_atom(struct radeonfb_info *rinfo)
 {
-	char *pret = NULL;
+	unsigned long tmp;
 
-	switch (type) {
-		case MT_NONE:
-			pret = "no";
-			break;
-		case MT_CRT:
-			pret = "CRT";
-			break;
-		case MT_DFP:
-			pret = "DFP";
-			break;
-		case MT_LCD:
-			pret = "LCD";
-			break;
-		case MT_CTV:
-			pret = "CTV";
-			break;
-		case MT_STV:
-			pret = "STV";
+	if (!rinfo->bios_seg)
+		return -ENODEV;
+
+	tmp = BIOS_IN16(rinfo->atom_data_start + 16);
+	if (!tmp) {
+		RTRACE("No LVDS panel info in ATOM BIOS\n");
+		rinfo->panel_info.pwr_delay = 200;
+		return -ENODEV;
+	}
+
+	rinfo->panel_info.xres = BIOS_IN16(tmp+6);
+	rinfo->panel_info.yres = BIOS_IN16(tmp+10);
+	printk("radeonfb: detected LVDS panel size from BIOS: %dx%d\n",
+	       rinfo->panel_info.xres, rinfo->panel_info.yres);
+	rinfo->panel_info.pwr_delay = BIOS_IN16(tmp+40);
+	RTRACE("BIOS provided panel power delay: %d\n", rinfo->panel_info.pwr_delay);
+	if (rinfo->panel_info.pwr_delay > 2000 || rinfo->panel_info.pwr_delay <= 0)
+		rinfo->panel_info.pwr_delay = 2000;
+
+	/* No special divider combinations? */
+
+	rinfo->panel_info.hblank = BIOS_IN16(tmp+8);
+	rinfo->panel_info.hOver_plus = BIOS_IN16(tmp+14);
+	rinfo->panel_info.hSync_width = BIOS_IN16(tmp+16);
+	rinfo->panel_info.vblank = BIOS_IN16(tmp+12);
+	rinfo->panel_info.vOver_plus = BIOS_IN16(tmp+18);
+	rinfo->panel_info.vSync_width = BIOS_IN16(tmp+20);
+	rinfo->panel_info.clock = BIOS_IN16(tmp+4);
+
+	/* Assume high active syncs for now until ATI tells me more... maybe we
+	 * can probe register values here ?
+	 */
+	rinfo->panel_info.hAct_high = 1;
+	rinfo->panel_info.vAct_high = 1;
+	/* Mark panel infos valid */
+	rinfo->panel_info.valid = 1;
+
+	return 0;
+}
+
+int __devinit radeon_get_lvds_info_legacy(struct radeonfb_info *rinfo)
+{
+	unsigned long tmp, tmp0;
+	char stmp[30];
+	int i;
+
+	if (!rinfo->bios_seg)
+		return -ENODEV;
+
+	if (!(tmp = BIOS_IN16(rinfo->fp_bios_start + 0x40))) {
+		RTRACE("No LVDS panel info in Legacy BIOS\n");
+		rinfo->panel_info.pwr_delay = 200;
+		return -ENODEV;
+	}
+
+	for(i = 0; i < 24; i++)
+		stmp[i] = BIOS_IN8(tmp + i + 1);
+	stmp[24] = 0;
+	printk("radeonfb: panel ID string: %s\n", stmp);
+	rinfo->panel_info.xres = BIOS_IN16(tmp + 25);
+	rinfo->panel_info.yres = BIOS_IN16(tmp + 27);
+	printk("radeonfb: detected LVDS panel size from BIOS: %dx%d\n",
+	       rinfo->panel_info.xres, rinfo->panel_info.yres);
+
+	rinfo->panel_info.pwr_delay = BIOS_IN16(tmp + 44);
+	RTRACE("BIOS provided panel power delay: %d\n", rinfo->panel_info.pwr_delay);
+	if (rinfo->panel_info.pwr_delay > 2000 || rinfo->panel_info.pwr_delay <= 0)
+		rinfo->panel_info.pwr_delay = 2000;
+
+	/*
+	 * Some panels only work properly with some divider combinations
+	 */
+	rinfo->panel_info.ref_divider = BIOS_IN16(tmp + 46);
+	rinfo->panel_info.post_divider = BIOS_IN8(tmp + 48);
+	rinfo->panel_info.fbk_divider = BIOS_IN16(tmp + 49);
+	if (rinfo->panel_info.ref_divider != 0 &&
+	    rinfo->panel_info.fbk_divider > 3) {
+		rinfo->panel_info.use_bios_dividers = 1;
+		printk(KERN_INFO "radeondb: BIOS provided dividers will be used\n");
+		RTRACE("ref_divider = %x\n", rinfo->panel_info.ref_divider);
+		RTRACE("post_divider = %x\n", rinfo->panel_info.post_divider);
+		RTRACE("fbk_divider = %x\n", rinfo->panel_info.fbk_divider);
+	}
+
+	RTRACE("Scanning BIOS table ...\n");
+	for(i = 0; i < 32; i++) {
+		tmp0 = BIOS_IN16(tmp + 64 + i*2);
+		if (tmp0 == 0)
 			break;
+		RTRACE(" %d x %d\n", BIOS_IN16(tmp0), BIOS_IN16(tmp0 + 2));
+		if ((BIOS_IN16(tmp0) == rinfo->panel_info.xres) &&
+		    (BIOS_IN16(tmp0 + 2) == rinfo->panel_info.yres)) {
+			rinfo->panel_info.hblank = (BIOS_IN16(tmp0 + 17) - BIOS_IN16(tmp0 + 19)) * 8;
+			rinfo->panel_info.hOver_plus = ((BIOS_IN16(tmp0 + 21) -
+							 BIOS_IN16(tmp0 + 19) -1) * 8) & 0x7fff;
+			rinfo->panel_info.hSync_width = BIOS_IN8(tmp0 + 23) * 8;
+			rinfo->panel_info.vblank = BIOS_IN16(tmp0 + 24) - BIOS_IN16(tmp0 + 26);
+			rinfo->panel_info.vOver_plus = (BIOS_IN16(tmp0 + 28) & 0x7ff) - BIOS_IN16(tmp0 + 26);
+			rinfo->panel_info.vSync_width = (BIOS_IN16(tmp0 + 28) & 0xf800) >> 11;
+			rinfo->panel_info.clock = BIOS_IN16(tmp0 + 9);
+			/* Assume high active syncs for now until ATI tells me more... maybe we
+			 * can probe register values here ?
+			 */
+			rinfo->panel_info.hAct_high = 1;
+			rinfo->panel_info.vAct_high = 1;
+			/* Mark panel infos valid */
+			rinfo->panel_info.valid = 1;
+
+			RTRACE("Found panel in BIOS table:\n");
+			RTRACE("  hblank: %d\n", rinfo->panel_info.hblank);
+			RTRACE("  hOver_plus: %d\n", rinfo->panel_info.hOver_plus);
+			RTRACE("  hSync_width: %d\n", rinfo->panel_info.hSync_width);
+			RTRACE("  vblank: %d\n", rinfo->panel_info.vblank);
+			RTRACE("  vOver_plus: %d\n", rinfo->panel_info.vOver_plus);
+			RTRACE("  vSync_width: %d\n", rinfo->panel_info.vSync_width);
+			RTRACE("  clock: %d\n", rinfo->panel_info.clock);
+
+			return 0;
+		}
+	}
+
+	RTRACE("Didn't find panel in BIOS table !\n");
+
+	return -ENODEV;
+}
+
+/*
+ * Get informations about TMDS controllers and their setup at
+ * different operating frequencies
+ */
+void __devinit radeon_get_tmds_info(struct radeonfb_info *rinfo)
+{
+	int i;
+	int family = rinfo->family;
+
+	/* Get default TMDS infos for this chip */
+	for (i = 0; i < 4; i++) {
+		rinfo->tmds_pll[i].value = default_tmds_pll[family][i].value;
+		rinfo->tmds_pll[i].freq = default_tmds_pll[family][i].freq;
+	}
+
+	/* Get whatever the firmware provides */
+	if (rinfo->radeon_get_tmds_info) {
+		rinfo->radeon_get_tmds_info(rinfo);
+		// XXX Do we care about the return value?
+	}
+}
+
+int __devinit radeon_get_tmds_info_legacy(struct radeonfb_info *rinfo)
+{
+	int offset, i, n, rev;
+
+	offset = BIOS_IN16(rinfo->fp_bios_start + 0x34);
+	if (offset == 0)
+		return -ENODEV;
+
+	rev = BIOS_IN8(offset);
+	RTRACE("DFP table revision: %d\n", rev);
+
+	switch(rev) {
+	case 3:
+		n = BIOS_IN8(offset + 5) + 1;
+		if (n > 4)
+			n = 4;
+		for (i = 0; i < n; i++) {
+			/* Looks bogus ... but that's what is in X.org */
+			rinfo->tmds_pll[i].value =
+				BIOS_IN32(offset + i*10 + 0x08);
+			rinfo->tmds_pll[i].freq =
+				BIOS_IN16(offset + i*10 + 0x10);
+		}
+		return 0;
+
+	/* revision 4 has some problem as it appears in RV280,
+	 * comment it off for now, use default instead
+	 */
+#if 0
+	case 4:
+		stride = 0;
+		n = BIOS_IN8(offset  5) + 1;
+		if (n > 4)
+			n = 4;
+		for (i = 0; i < n; i++) {
+			rinfo->tmds_pll[i].value =
+				BIOS_IN32(tmp + stride + 0x08);
+			rinfo->tmds_pll[i].freq =
+				BIOS_IN16(tmp + stride + 0x10);
+			if (i == 0)
+				stride += 10;
+			else
+				stride += 6;
+		}
+		return 0;
+#endif
 	}
+	return -ENODEV;
+}
+
+int __devinit radeon_get_tmds_info_atom(struct radeonfb_info *rinfo)
+{
+	int offset, i, maxfreq;
+
+	offset = BIOS_IN16(rinfo->atom_data_start + 18);
+	if (offset == 0)
+		return -ENODEV;
 
-	return pret;
+	maxfreq = BIOS_IN16(offset + 4);
+
+	for (i = 0; i < 4; i++) {
+		rinfo->tmds_pll[i].freq = BIOS_IN16(offset + i*6 + 6);
+		/* This assumes each field in TMDS_PLL has 6 bit as
+		 * in R300/R420
+		 */
+		rinfo->tmds_pll[i].value =
+			((BIOS_IN8(offset + i*6 + 8) & 0x3f) |
+			 ((BIOS_IN8(offset + i*6 + 10) & 0x3f)<<6) |
+			 ((BIOS_IN8(offset + i*6 + 9) & 0xf)<<12) |
+			 ((BIOS_IN8(offset + i*6 + 11) & 0xf)<<16));
+		RTRACE("TMDS PLL from BIOS: %ld %x\n",
+		       rinfo->tmds_pll[i].freq, rinfo->tmds_pll[i].value);
+
+		if (maxfreq == rinfo->tmds_pll[i].freq) {
+			rinfo->tmds_pll[i].freq = 0xffffffff;
+			break;
+		}
+	}
+	return 0;
 }
 
 
+static const char *conn_type_name[] = {
+	"NONE", "VGA", "DVI-I", "DVI-D", "DVI-A", "S-Video",
+	"Composite Video", "Internal Panel", "Digital",
+	"Unsupported", "Proprietary"
+};
+
+static const char *mon_type_name[] = {
+	"None", "CRT", "LVDS Flat panel",
+	"DVI Flat panel", "Composite TV", "S-Video TV"
+};
+
+static void __devinit radeon_fill_conn(struct radeon_connector *conn, int mon_type, int ddc_type, int *found_tmds, int *found_crt)
+{
+	conn->mon_type = mon_type;
+	conn->ddc_type = ddc_type;
+
+	// XXX what about reversed DAC/TMDS??
+
+	switch(mon_type) {
+	case MT_CRT:
+		conn->conn_type = conn_vga;
+		conn->tmds_type = tmds_unknown;
+		conn->dac_type = (*found_crt) ? dac_tvdac: dac_primary;
+		if (ddc_type == ddc_none)
+			conn->ddc_type = (*found_crt) ? ddc_crt2 : ddc_vga;
+		*found_crt = 1;
+		break;
+	case MT_DFP:
+		conn->conn_type = conn_dvi_i;
+		conn->tmds_type = (*found_tmds) ? tmds_external: tmds_internal;
+		conn->dac_type = dac_unknown;
+		if (ddc_type == ddc_none)
+			conn->ddc_type = ddc_dvi;
+		*found_tmds = 1;
+		break;
+	case MT_LCD:
+		conn->conn_type = conn_lvds;
+		conn->tmds_type = tmds_unknown;
+		conn->dac_type = dac_unknown;
+		if (ddc_type == ddc_none)
+			conn->ddc_type = ddc_none; //heh
+		break;
+	case MT_CTV:
+		conn->conn_type = conn_ctv;
+		conn->tmds_type = tmds_unknown;
+		conn->dac_type = dac_tvdac;
+		if (ddc_type == ddc_none)
+			conn->ddc_type = ddc_vga; // XXX ddc_crt2?
+		break;
+	case MT_STV:
+		conn->conn_type = conn_stv;
+		conn->tmds_type = tmds_unknown;
+		conn->dac_type = dac_tvdac;
+		if (ddc_type == ddc_none)
+			conn->ddc_type = ddc_vga; // XXX ddc_crt2?
+		break;
+	case MT_UNKNOWN:
+	case MT_NONE:
+		conn->conn_type = conn_none;
+		conn->tmds_type = tmds_unknown;
+		conn->mon_type = MT_NONE;
+		conn->ddc_type = ddc_none;
+		conn->dac_type = dac_unknown;
+		break;
+	default:
+		break;
+	}
+	// leaves conn_digital, conn_unsupported, conn_propritetary
+}
+
 #if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
 /*
  * Try to find monitor informations & EDID data out of the Open Firmware
@@ -59,33 +358,40 @@ static char *radeon_get_mon_name(int type)
  * models with broken OF probing by hard-coding known EDIDs for some Mac
  * laptops internal LVDS panel. (XXX: not done yet)
  */
-static int __devinit radeon_parse_montype_prop(struct device_node *dp, u8 **out_EDID,
+static int __devinit radeon_parse_montype_prop(struct radeonfb_info *rinfo,
+					       struct device_node *dp,
+					       struct radeon_connector *conn,
 					       int hdno)
 {
-        static char *propnames[] = { "DFP,EDID", "LCD,EDID", "EDID",
+	static char *propnames[] = { "DFP,EDID", "LCD,EDID", "EDID",
 				     "EDID1", "EDID2",  NULL };
 	const u8 *pedid = NULL;
 	const u8 *pmt = NULL;
 	u8 *tmp;
-        int i, mt = MT_NONE;  
-	
+	int i;
+
 	RTRACE("analyzing OF properties...\n");
 	pmt = of_get_property(dp, "display-type", NULL);
 	if (!pmt)
-		return MT_NONE;
+		return -1;
 	RTRACE("display-type: %s\n", pmt);
-	/* OF says "LCD" for DFP as well, we discriminate from the caller of this
-	 * function
-	 */
-	if (!strcmp(pmt, "LCD") || !strcmp(pmt, "DFP"))
-		mt = MT_DFP;
-	else if (!strcmp(pmt, "CRT"))
-		mt = MT_CRT;
-	else {
+	if (!strcmp(pmt, "LCD") || !strcmp(pmt, "DFP")) {
+		/* OF says "LCD" for DFP as well.*/
+		if (rinfo->is_mobility) {
+			conn->mon_type = MT_LCD;
+			/* Maybe check for LVDS_GEN_CNTL here ? I need to check out
+			 * what OF does when booting with lid closed
+			 */
+		} else{
+			conn->mon_type = MT_DFP;
+		}
+	} else if (!strcmp(pmt, "CRT")) {
+		conn->mon_type = MT_CRT;
+	} else {
 		if (strcmp(pmt, "NONE") != 0)
 			printk(KERN_WARNING "radeonfb: Unknown OF display-type: %s\n",
 			       pmt);
-		return MT_NONE;
+		return -1;
 	}
 
 	for (i = 0; propnames[i] != NULL; ++i) {
@@ -103,25 +409,36 @@ static int __devinit radeon_parse_montype_prop(struct device_node *dp, u8 **out_
 	if (pedid == NULL && dp->parent && (hdno == 0))
 		pedid = of_get_property(dp->parent, "EDID", NULL);
 	if (pedid == NULL)
-		return mt;
+		return -1;
 
 	tmp = kmemdup(pedid, EDID_LENGTH, GFP_KERNEL);
-	if (!tmp)
-		return mt;
-	*out_EDID = tmp;
-	return mt;
+	conn->edid = tmp;
+
+	{
+		int found_tmds = 0;
+		int found_crt = 0;
+		int ddc_type = ddc_none;
+		// XXX what about reversed DAC/TMDS??
+		radeon_fill_conn(conn, conn->mon_type, ddc_type, &found_crt, &found_tmds);
+	}
+
+	return 0;
 }
 
-static int __devinit radeon_probe_OF_head(struct radeonfb_info *rinfo, int head_no,
-					  u8 **out_EDID)
+/* return a -1 on error */
+static int __devinit radeon_probe_OF_head(struct radeonfb_info *rinfo, int head_no)
+
 {
-        struct device_node *dp;
+	struct radeon_connector *conn;
+	struct device_node *dp;
 
 	RTRACE("radeon_probe_OF_head\n");
 
-        dp = rinfo->of_node;
-        while (dp == NULL)
-		return MT_NONE;
+	conn = &rinfo->connectors[head_no];
+
+	dp = rinfo->of_node;
+	if (dp == NULL)
+		return -1;
 
 	if (rinfo->has_CRTC2) {
 		const char *pname;
@@ -130,116 +447,284 @@ static int __devinit radeon_probe_OF_head(struct radeonfb_info *rinfo, int head_
 		dp = dp->child;
 		do {
 			if (!dp)
-				return MT_NONE;
+				return -1;
+
 			pname = of_get_property(dp, "name", NULL);
-			if (!pname)
-				return MT_NONE;
+			if (!pname) 
+				return -1;
+
 			len = strlen(pname);
 			RTRACE("head: %s (letter: %c, head_no: %d)\n",
 			       pname, pname[len-1], head_no);
 			if (pname[len-1] == 'A' && head_no == 0) {
-				int mt = radeon_parse_montype_prop(dp, out_EDID, 0);
-				/* Maybe check for LVDS_GEN_CNTL here ? I need to check out
-				 * what OF does when booting with lid closed
-				 */
-				if (mt == MT_DFP && rinfo->is_mobility)
-					mt = MT_LCD;
-				return mt;
-			} else if (pname[len-1] == 'B' && head_no == 1)
-				return radeon_parse_montype_prop(dp, out_EDID, 1);
+				return radeon_parse_montype_prop(rinfo, dp, conn, 0);
+			} else if (pname[len-1] == 'B' && head_no == 1) {
+				return radeon_parse_montype_prop(rinfo, dp, conn, 1);
+			}
 			second = 1;
 			dp = dp->sibling;
 		} while(!second);
 	} else {
 		if (head_no > 0)
-			return MT_NONE;
-		return radeon_parse_montype_prop(dp, out_EDID, -1);
+			return -1;
+		return radeon_parse_montype_prop(rinfo, dp, conn, -1);
 	}
-        return MT_NONE;
+	return -1;
 }
 #endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 
-
-static int __devinit radeon_get_panel_info_BIOS(struct radeonfb_info *rinfo)
+/*
+ * Get informations about the various connectors on this card. This is
+ * the most prone to fail function as various firmwares tend to say
+ * crap or not give any info at all. The Open Firmware version is just
+ * a table of known cards for now for example. We'll probably need some
+ * additional module params to force different settings in case of
+ * misdetection here.
+ *
+ * This doesn _not_ try actual probing of whatever is plugged on those
+ * various connectors. This will be done later. We do store whatever
+ * probing info the firmware gives us though
+ */
+void __devinit radeon_get_conn_info(struct radeonfb_info *rinfo, int ignore_conntable)
 {
-	unsigned long tmp, tmp0;
-	char stmp[30];
 	int i;
 
-	if (!rinfo->bios_seg)
-		return 0;
-
-	if (!(tmp = BIOS_IN16(rinfo->fp_bios_start + 0x40))) {
-		printk(KERN_ERR "radeonfb: Failed to detect DFP panel info using BIOS\n");
-		rinfo->panel_info.pwr_delay = 200;
-		return 0;
+	/* Clear table */
+	for (i = 0; i < RADEON_MAX_CONNECTORS; i++) {
+		rinfo->connectors[i].conn_type	= conn_none;
+		rinfo->connectors[i].ddc_type	= ddc_none;
+		rinfo->connectors[i].dac_type	= dac_unknown;
+		rinfo->connectors[i].tmds_type	= tmds_unknown;
+		rinfo->connectors[i].mon_type	= MT_UNKNOWN;
+		rinfo->connectors[i].head       = -1;
+		rinfo->heads[i] = -1;
 	}
+	rinfo->num_heads = 0;
+
+	if (ignore_conntable) {
+#if defined(CONFIG_FB_RADEON_I2C)
+		struct radeon_connector conn;
+		int idx = 0;
+		int found_tmds = 0;
+		int found_crt = 0;
+
+		// XXX what about reversed DAC/TMDS??
+
+		for (i = 0; i < 4; i++) {
+			conn.ddc_type = i;
+			if (!radeon_probe_i2c_connector(rinfo, &conn)) {
+				radeon_fill_conn(&rinfo->connectors[idx++], conn.mon_type, conn.ddc_type,
+						 &found_tmds, &found_crt);
+			}
+		}
 
-	for(i=0; i<24; i++)
-		stmp[i] = BIOS_IN8(tmp+i+1);
-	stmp[24] = 0;
-	printk("radeonfb: panel ID string: %s\n", stmp);
-	rinfo->panel_info.xres = BIOS_IN16(tmp + 25);
-	rinfo->panel_info.yres = BIOS_IN16(tmp + 27);
-	printk("radeonfb: detected LVDS panel size from BIOS: %dx%d\n",
-		rinfo->panel_info.xres, rinfo->panel_info.yres);
+		/* If we failed to probe something.. */
+		if (idx)
+			goto found;
+#endif /* CONFIG_FB_RADEON_I2C */
+	} else {
+		/* Try to obtain infos from firmware */
+		if (rinfo->radeon_get_conn_info) {
+			if (!rinfo->radeon_get_conn_info(rinfo)) {
+				goto found;
+			}
+		}
+	}
 
-	rinfo->panel_info.pwr_delay = BIOS_IN16(tmp + 44);
-	RTRACE("BIOS provided panel power delay: %d\n", rinfo->panel_info.pwr_delay);
-	if (rinfo->panel_info.pwr_delay > 2000 || rinfo->panel_info.pwr_delay <= 0)
-		rinfo->panel_info.pwr_delay = 2000;
+	printk(KERN_INFO "radeonfb: No connector infos, using defaults...\n");
 
-	/*
-	 * Some panels only work properly with some divider combinations
+	/* Here, we use defaults that are common enough ... we hope
+	 * For a mobility chip, we assume LVDS is on primary
 	 */
-	rinfo->panel_info.ref_divider = BIOS_IN16(tmp + 46);
-	rinfo->panel_info.post_divider = BIOS_IN8(tmp + 48);
-	rinfo->panel_info.fbk_divider = BIOS_IN16(tmp + 49);
-	if (rinfo->panel_info.ref_divider != 0 &&
-	    rinfo->panel_info.fbk_divider > 3) {
-		rinfo->panel_info.use_bios_dividers = 1;
-		printk(KERN_INFO "radeondb: BIOS provided dividers will be used\n");
-		RTRACE("ref_divider = %x\n", rinfo->panel_info.ref_divider);
-		RTRACE("post_divider = %x\n", rinfo->panel_info.post_divider);
-		RTRACE("fbk_divider = %x\n", rinfo->panel_info.fbk_divider);
+	if (rinfo->is_mobility) {
+		rinfo->connectors[0].conn_type	= conn_lvds;
+		rinfo->connectors[0].ddc_type	= ddc_dvi;
+		rinfo->connectors[0].dac_type	= dac_primary;
+		rinfo->connectors[0].tmds_type	= tmds_unknown;
+		rinfo->connectors[0].mon_type	= MT_UNKNOWN;
+
+		rinfo->connectors[1].conn_type	= conn_dvi_d;
+		rinfo->connectors[1].ddc_type	= ddc_vga;
+		rinfo->connectors[1].dac_type	= dac_primary;
+		rinfo->connectors[1].tmds_type	= tmds_internal;
+		rinfo->connectors[1].mon_type	= MT_UNKNOWN;
+
+		rinfo->connectors[2].conn_type	= conn_stv;
+		rinfo->connectors[2].ddc_type	= ddc_none;
+		rinfo->connectors[2].dac_type	= dac_tvdac;
+		rinfo->connectors[2].tmds_type	= tmds_unknown;
+		rinfo->connectors[2].mon_type	= MT_UNKNOWN;
+	} else {
+		rinfo->connectors[0].conn_type	= conn_dvi_d;
+		rinfo->connectors[0].ddc_type	= ddc_dvi;
+		rinfo->connectors[0].dac_type	= dac_tvdac;
+		rinfo->connectors[0].tmds_type	= tmds_internal;
+		rinfo->connectors[0].mon_type	= MT_UNKNOWN;
+
+		rinfo->connectors[1].conn_type	= conn_vga;
+		rinfo->connectors[1].ddc_type	= ddc_vga;
+		rinfo->connectors[1].dac_type	= dac_primary;
+		rinfo->connectors[1].tmds_type	= tmds_unknown;
+		rinfo->connectors[1].mon_type	= MT_UNKNOWN;
+
+		if (rinfo->has_CRTC2) {
+			rinfo->connectors[1].conn_type	= conn_vga;
+			rinfo->connectors[1].ddc_type	= ddc_crt2;
+			rinfo->connectors[1].dac_type	= dac_tvdac;
+			rinfo->connectors[1].tmds_type	= tmds_unknown;
+			rinfo->connectors[1].mon_type	= MT_UNKNOWN;
+		}
 	}
-	RTRACE("Scanning BIOS table ...\n");
-	for(i=0; i<32; i++) {
-		tmp0 = BIOS_IN16(tmp+64+i*2);
-		if (tmp0 == 0)
-			break;
-		RTRACE(" %d x %d\n", BIOS_IN16(tmp0), BIOS_IN16(tmp0+2));
-		if ((BIOS_IN16(tmp0) == rinfo->panel_info.xres) &&
-		    (BIOS_IN16(tmp0+2) == rinfo->panel_info.yres)) {
-			rinfo->panel_info.hblank = (BIOS_IN16(tmp0+17) - BIOS_IN16(tmp0+19)) * 8;
-			rinfo->panel_info.hOver_plus = ((BIOS_IN16(tmp0+21) -
-							 BIOS_IN16(tmp0+19) -1) * 8) & 0x7fff;
-			rinfo->panel_info.hSync_width = BIOS_IN8(tmp0+23) * 8;
-			rinfo->panel_info.vblank = BIOS_IN16(tmp0+24) - BIOS_IN16(tmp0+26);
-			rinfo->panel_info.vOver_plus = (BIOS_IN16(tmp0+28) & 0x7ff) - BIOS_IN16(tmp0+26);
-			rinfo->panel_info.vSync_width = (BIOS_IN16(tmp0+28) & 0xf800) >> 11;
-			rinfo->panel_info.clock = BIOS_IN16(tmp0+9);
-			/* Assume high active syncs for now until ATI tells me more... maybe we
-			 * can probe register values here ?
-			 */
-			rinfo->panel_info.hAct_high = 1;
-			rinfo->panel_info.vAct_high = 1;
-			/* Mark panel infos valid */
-			rinfo->panel_info.valid = 1;
 
-			RTRACE("Found panel in BIOS table:\n");
-			RTRACE("  hblank: %d\n", rinfo->panel_info.hblank);
-			RTRACE("  hOver_plus: %d\n", rinfo->panel_info.hOver_plus);
-			RTRACE("  hSync_width: %d\n", rinfo->panel_info.hSync_width);
-			RTRACE("  vblank: %d\n", rinfo->panel_info.vblank);
-			RTRACE("  vOver_plus: %d\n", rinfo->panel_info.vOver_plus);
-			RTRACE("  vSync_width: %d\n", rinfo->panel_info.vSync_width);
-			RTRACE("  clock: %d\n", rinfo->panel_info.clock);
-				
-			return 1;
+found:
+	/* Now, we do additional fixups */
+
+	/* RS300 has only one DAC, force TV-DAC on VGA port */
+	if (rinfo->family == CHIP_FAMILY_RS300) {
+		for (i = 0; i < RADEON_MAX_CONNECTORS; i++) {
+			if (rinfo->connectors[i].conn_type == conn_vga)
+				rinfo->connectors[i].dac_type = dac_tvdac;
+			else if (rinfo->connectors[i].dac_type != dac_unknown)
+				rinfo->connectors[i].dac_type = dac_primary;
 		}
 	}
-	RTRACE("Didn't find panel in BIOS table !\n");
+
+	/* Single head chips all use primary DAC */
+	if (!rinfo->has_CRTC2)
+		rinfo->connectors[0].dac_type = dac_primary;
+
+	return;
+}
+
+#if defined CONFIG_PPC_OF || defined(CONFIG_SPARC)
+int __devinit radeon_get_conn_info_openfirmware(struct radeonfb_info *rinfo)
+{
+	int i;
+	int found = 0;
+
+	/* Only two heads for OF! */
+	for(i = 0 ; i < 2 ; i++) {
+		if (!radeon_probe_OF_head(rinfo, i))
+			found = 0;
+	}
+	return found;
+}
+#endif /* CONFIG_PPC_OF || CONFIG_SPARC */
+
+int __devinit radeon_get_conn_info_atom(struct radeonfb_info *rinfo)
+{
+	int i, j, offset, valids;
+	int ids[RADEON_MAX_CONNECTORS];
+	u16 portinfo, tmp0;
+	int conn_index = 0;
+	int conn_add = 2;
+	int idx = 0;
+	int ddc_type, dac_type, conn_type, tmds_type, port_id;
+	int connector_found = 0;
+	int shared;
+
+	offset = BIOS_IN16(rinfo->atom_data_start + 22);
+	if (offset == 0)
+		return -ENODEV;
+
+	/* Again, I slightly modified X.org algorithm. I assign "primary" outputs
+	 * to entries 0 and 1, and anything else goes after 2.
+	 *
+	 * Also, I keep an array of all port IDs matching connectors[] array,
+	 * unlike X which limits itself to "crtc"'s
+	 */
+	for (i = 0; i < RADEON_MAX_CONNECTORS; i++)
+		ids[i] = -1;
+
+	valids = BIOS_IN16(offset + 4);
+	for (i = 0; i < 8; i++) {
+		shared = 0;
+		if (!(valids & (1 << i)))
+			continue;
+		portinfo = BIOS_IN16(offset + 6 + i*2);
+
+		conn_type = (portinfo >> 4) & 0xf;
+		dac_type = (portinfo & 0xf) - 1;
+		port_id = (portinfo >> 8) & 0xf;
+		ddc_type = ddc_none;
+
+		if ((tmp0 = BIOS_IN16(rinfo->atom_data_start + 24))) {
+			switch(BIOS_IN16(tmp0 + 4 + (27 * port_id)) * 4) {
+			case GPIO_MONID:
+				ddc_type = ddc_monid;
+				break;
+			case GPIO_DVI_DDC:
+				ddc_type = ddc_dvi;
+				break;
+			case GPIO_VGA_DDC:
+				ddc_type = ddc_vga;
+				break;
+			case GPIO_CRT2_DDC:
+				ddc_type = ddc_crt2;
+				break;
+			default:
+				ddc_type = ddc_none;
+				break;
+			}
+		}
+
+		if (i == 3)
+			tmds_type = tmds_internal;
+		else if (i == 7)
+			tmds_type = tmds_external;
+		else
+			tmds_type = tmds_unknown;
+
+		RTRACE("index %d port %d conn %d dac %d ddc %d tmds %d\n", i, port_id, conn_type, dac_type, ddc_type, tmds_type);
+
+		/* Ok, now we have the port ID, look for an existing port
+		 * already using this ID
+		 */
+		for (j = 0; j < RADEON_MAX_CONNECTORS; j++) {
+			if (port_id != ids[j])
+				continue;
+
+			/* This port is shared. Update the values (if needed)
+			 * and probe next connector without creating a new
+			 * connector entry.
+			 */
+			if (tmds_type != tmds_unknown)
+				rinfo->connectors[j].tmds_type = tmds_type;
+			if (rinfo->connectors[j].dac_type == dac_unknown)
+				rinfo->connectors[j].dac_type = dac_type;
+			if (rinfo->connectors[j].ddc_type == ddc_none)
+				rinfo->connectors[j].ddc_type = ddc_type;
+
+			shared = 1;
+		}
+		if (shared)
+			continue;
+
+		conn_index = (ddc_type == ddc_dvi || conn_index == 1) ? 0 : 1;
+
+		/* if the port is a TV port, or both connectors are already
+		 * assigned, assign it after further in the table
+		 */
+		if (conn_type == conn_ctv || conn_type == conn_stv ||
+		    (rinfo->connectors[0].conn_type != conn_none &&
+		     rinfo->connectors[1].conn_type != conn_none))
+			idx = conn_add++;
+		else
+			idx = conn_index;
+
+		rinfo->connectors[idx].tmds_type = tmds_type;
+		rinfo->connectors[idx].dac_type = dac_type;
+		rinfo->connectors[idx].ddc_type = ddc_type;
+		rinfo->connectors[idx].conn_type = conn_type;
+		ids[idx] = port_id;
+
+		/* increment connector_found for primary connectors only */
+		if (idx < 2)
+			connector_found += (idx + 1);
+	}
+
+	if (connector_found == 0)
+		return -ENODEV;
 
 	return 0;
 }
@@ -248,44 +733,167 @@ static int __devinit radeon_get_panel_info_BIOS(struct radeonfb_info *rinfo)
  * doesn't quite work yet, but it's output is still useful for
  * debugging
  */
-static void __devinit radeon_parse_connector_info(struct radeonfb_info *rinfo)
+int __devinit radeon_get_conn_info_legacy(struct radeonfb_info *rinfo)
 {
-	int offset, chips, connectors, tmp, i, conn, type;
-
-	static char* __conn_type_table[16] = {
-		"NONE", "Proprietary", "CRT", "DVI-I", "DVI-D", "Unknown", "Unknown",
-		"Unknown", "Unknown", "Unknown", "Unknown", "Unknown", "Unknown",
-		"Unknown", "Unknown", "Unknown"
+	int offset, i, entry, tmp;
+	int ddc_type, dac_type, conn_type, tmds_type;
+	int conn_index = 0;
+	int conn_add = 2;
+	int idx = 0;
+
+	/* Convert legacy to real connector types */
+	const enum radeon_conn_type legacy_conn_to_type[] = {
+		conn_none,
+		conn_proprietary,
+		conn_vga,
+		conn_dvi_i,
+		conn_dvi_d,
+		conn_ctv,
+		conn_stv,
+		conn_unsupported,
 	};
 
-	if (!rinfo->bios_seg)
-		return;
+	/* Some laptops only have one connector (VGA) listed in the connector
+	 * table, we need to add LVDS in as a non-DDC display.
+	 * Note, we can't assume the listed VGA will be filled in PortInfo[0],
+	 * when walking through connector table. connector_found has following
+	 * meaning:
+	 * 0 -- nothing found,
+	 * 1 -- only connectors[0] filled,
+	 * 2 -- only connectors[1] filled,
+	 * 3 -- both are filled.
+	 *
+	 * Note: I modified X.org algorithm to add additional entries if any
+	 * after the second table slot. Those entries do not affect the value
+	 * of connector_found. --BenH.
+	 */
+	int connector_found = 0;
 
 	offset = BIOS_IN16(rinfo->fp_bios_start + 0x50);
-	if (offset == 0) {
-		printk(KERN_WARNING "radeonfb: No connector info table detected\n");
-		return;
+	if (offset == 0)
+		return -ENODEV;
+
+	for (i = 1; i < 4; i++) {
+		entry = offset + i*2;
+
+		/* End of table */
+		if (!BIOS_IN8(entry) && i > 1)
+			break;
+
+		/* Read table entry, check connector type */
+		tmp = BIOS_IN16(entry);
+		conn_type = (tmp >> 12) & 0xf;
+		if (conn_type == legacy_conn_none)
+			continue;
+		ddc_type = (tmp >> 8) & 0xf;
+		dac_type = (tmp & 0x01) ? dac_tvdac : dac_primary;
+		tmds_type = (tmp & 0x10) ? tmds_external : tmds_internal;
+
+		/* same connector */
+		if (connector_found > 0) {
+			if (rinfo->connectors[conn_index].ddc_type == ddc_type)
+				continue;
+		}
+
+		/* sanity checks */
+		if (ddc_type > ddc_crt2)
+			ddc_type = ddc_none;
+		if (conn_type > legacy_conn_unsupported)
+			conn_type = legacy_conn_unsupported;
+		if (conn_type != legacy_conn_dvi_d &&
+		    conn_type != legacy_conn_dvi_i &&
+		    tmds_type == tmds_internal)
+			tmds_type= tmds_unknown;
+
+		/* convert connector type */
+		conn_type = legacy_conn_to_type[conn_type];
+
+		/* internal DDC_DVI port will get assigned to connector[0], or
+		 * if there is no DDC_DVI (like in some IGPs).
+		 */
+		conn_index = (ddc_type == ddc_dvi || conn_index == 1) ? 0 : 1;
+
+		/* if the port is a TV port, or both connectors are already
+		 * assigned, assign it after further in the table
+		 */
+		if (conn_type == conn_ctv || conn_type == conn_stv ||
+		    (rinfo->connectors[0].conn_type != conn_none &&
+		     rinfo->connectors[1].conn_type))
+			idx = conn_add++;
+		else
+			idx = conn_index;
+
+		/* if table full, exit */
+		if (idx >= RADEON_MAX_CONNECTORS) {
+			printk(KERN_WARNING "radeonfb: Connector table full !\n");
+			break;
+		}
+		rinfo->connectors[idx].conn_type	= conn_type;
+		rinfo->connectors[idx].ddc_type		= ddc_type;
+		rinfo->connectors[idx].dac_type		= dac_type;
+		rinfo->connectors[idx].tmds_type	= tmds_type;
+
+		/* increment connector_found for primary connectors only */
+		if (idx < 2)
+			connector_found += (idx + 1);
 	}
 
-	/* Don't do much more at this point but displaying the data if
-	 * DEBUG is enabled
-	 */
-	chips = BIOS_IN8(offset++) >> 4;
-	RTRACE("%d chips in connector info\n", chips);
-	for (i = 0; i < chips; i++) {
-		tmp = BIOS_IN8(offset++);
-		connectors = tmp & 0x0f;
-		RTRACE(" - chip %d has %d connectors\n", tmp >> 4, connectors);
-		for (conn = 0; ; conn++) {
-			tmp = BIOS_IN16(offset);
-			if (tmp == 0)
-				break;
-			offset += 2;
-			type = (tmp >> 12) & 0x0f;
-			RTRACE("  * connector %d of type %d (%s) : %04x\n",
-			       conn, type, __conn_type_table[type], tmp);
+	if (rinfo->is_mobility) {
+		/* For the cases where only one VGA connector is found,
+		 * we assume LVDS is not listed in the connector table,
+		 * add it in here as the first port.
+		 *
+		 * TODO: Check what's up with laptops that have a DVI output
+		 * and no LVDS entry in the table. I suspect some thinkpads
+		 * may play trick with us here... We may want to check the
+		 * presence of a panel via LVDS_GEN_CNTL to be sure...
+		 */
+		if ((connector_found < 3) &&
+		    (rinfo->connectors[idx].conn_type == conn_vga)) {
+			if (connector_found == 1) {
+				memcpy(&rinfo->connectors[1], &rinfo->connectors[0],
+						sizeof(struct radeon_connector));
+			}
+
+			/* Fixme: TV DAC is probably elsewhere ... */
+			rinfo->connectors[0].dac_type = dac_tvdac;
+			rinfo->connectors[0].tmds_type = tmds_unknown;
+			rinfo->connectors[0].ddc_type = ddc_none;
+			rinfo->connectors[0].conn_type = conn_proprietary;
+
+			printk(KERN_WARNING "radeonfb: LVDS port is not in connector table, added in.\n");
+			if (connector_found == 0)
+				connector_found = 1;
+			else
+				connector_found = 3;
 		}
+
+		/* Check for LCD DDC info table */
+		if ((offset = BIOS_IN16(rinfo->fp_bios_start + 0x42))) {
+			if ((tmp = BIOS_IN16(offset + 0x15))) {
+				if ((ddc_type = BIOS_IN8(tmp+2) & 0x07)) {
+					rinfo->connectors[0].ddc_type = ddc_type;
+					printk(KERN_WARNING "radeonfb: LCD DDC Info Table found, "
+						"forcing primary port to %d\n",
+						ddc_type);
+				}
+			}
+		}
+	} else if (connector_found == 2) {
+		memcpy(&rinfo->connectors[0], &rinfo->connectors[1],
+			sizeof (struct radeon_connector));
+		rinfo->connectors[1].dac_type = dac_unknown;
+		rinfo->connectors[1].tmds_type = tmds_unknown;
+		rinfo->connectors[1].ddc_type = ddc_none;
+		rinfo->connectors[1].conn_type = conn_none;
+		connector_found = 1;
 	}
+
+	if (connector_found == 0)
+		return -ENODEV;
+
+	/* External TMDS Table, not used now */
+	return 0;
 }
 
 
@@ -362,6 +970,51 @@ static int __devinit radeon_crt_is_connected(struct radeonfb_info *rinfo, int is
     return connected ? MT_CRT : MT_NONE;
 }
 
+/* Find if the desired connector and monitor are compatible */
+static int __devinit radeon_conn_monitor_compatible(int mon_type, int conn_type)
+{
+	switch(mon_type) {
+	case MT_CRT:
+		return ((conn_type == conn_vga) || (conn_type == conn_dvi_a));
+	case MT_DFP:
+		return ((conn_type == conn_dvi_i) || (conn_type == conn_dvi_d));
+	case MT_LCD:
+		return (conn_type == conn_lvds);
+	case MT_CTV:
+		return (conn_type == conn_ctv);
+	case MT_STV:
+		return (conn_type == conn_stv);
+	case MT_UNKNOWN:
+	case MT_NONE:
+	default:
+		return 0;
+	}
+	// leaves conn_digital, conn_unsupported, conn_propritetary
+}
+
+/* Find a suitable connector for this display type */
+static int __devinit radeon_find_connector_for_mon(struct radeonfb_info *rinfo, int mon_type)
+{
+	int i;
+
+	if (mon_type <= MT_NONE)
+		return 0;
+
+	for (i = 0; i < RADEON_MAX_CONNECTORS ; i++) {
+		if (radeon_conn_monitor_compatible(mon_type, rinfo->connectors[i].conn_type) &&
+		    (rinfo->connectors[i].mon_type <= MT_NONE)) {
+			rinfo->connectors[i].mon_type = mon_type;
+			rinfo->connectors[i].head = rinfo->num_heads;
+			rinfo->heads[rinfo->num_heads] = i;
+			rinfo->num_heads++;
+			return 0;
+		}
+	}
+
+	printk(KERN_INFO "radeonfb: couldn't find a connector for monitor %d\n", mon_type);
+	return -1;
+}
+
 /*
  * Parse the "monitor_layout" string if any. This code is mostly
  * copied from XFree's radeon driver
@@ -407,19 +1060,20 @@ static int __devinit radeon_parse_monitor_layout(struct radeonfb_info *rinfo,
 		s1[i] = 0;
 		s2[0] = 0;
 	}
+
 	if (strcmp(s1, "CRT") == 0)
-		rinfo->mon1_type = MT_CRT;
+		radeon_find_connector_for_mon(rinfo, MT_CRT);
 	else if (strcmp(s1, "TMDS") == 0)
-		rinfo->mon1_type = MT_DFP;
+		radeon_find_connector_for_mon(rinfo, MT_DFP);
 	else if (strcmp(s1, "LVDS") == 0)
-		rinfo->mon1_type = MT_LCD;
+		radeon_find_connector_for_mon(rinfo, MT_LCD);
 
 	if (strcmp(s2, "CRT") == 0)
-		rinfo->mon2_type = MT_CRT;
+		radeon_find_connector_for_mon(rinfo, MT_CRT);
 	else if (strcmp(s2, "TMDS") == 0)
-		rinfo->mon2_type = MT_DFP;
+		radeon_find_connector_for_mon(rinfo, MT_DFP);
 	else if (strcmp(s2, "LVDS") == 0)
-		rinfo->mon2_type = MT_LCD;
+		radeon_find_connector_for_mon(rinfo, MT_LCD);
 
 	return 1;
 }
@@ -433,12 +1087,7 @@ static int __devinit radeon_parse_monitor_layout(struct radeonfb_info *rinfo,
 void __devinit radeon_probe_screens(struct radeonfb_info *rinfo,
 				    const char *monitor_layout, int ignore_edid)
 {
-#ifdef CONFIG_FB_RADEON_I2C
-	int ddc_crt2_used = 0;	
-#endif
-	int tmp, i;
-
-	radeon_parse_connector_info(rinfo);
+	int i;
 
 	if (radeon_parse_monitor_layout(rinfo, monitor_layout)) {
 
@@ -449,214 +1098,142 @@ void __devinit radeon_probe_screens(struct radeonfb_info *rinfo,
 		 * a layout for each card ?
 		 */
 
-		RTRACE("Using specified monitor layout: %s", monitor_layout);
+		RTRACE("Using specified monitor layout: %s\n", monitor_layout);
 #ifdef CONFIG_FB_RADEON_I2C
 		if (!ignore_edid) {
-			if (rinfo->mon1_type != MT_NONE)
-				if (!radeon_probe_i2c_connector(rinfo, ddc_dvi, &rinfo->mon1_EDID)) {
-					radeon_probe_i2c_connector(rinfo, ddc_crt2, &rinfo->mon1_EDID);
-					ddc_crt2_used = 1;
+			int mon_type;
+
+			/* If the DDC detection fails, 
+			   we still want to use the user's specified layout! */
+			mon_type = PRIMARY_MONITOR(rinfo);
+
+			if (PRIMARY_MONITOR(rinfo) > MT_NONE)
+				if (radeon_probe_i2c_connector(rinfo, &PRIMARY_HEAD(rinfo)))
+					PRIMARY_MONITOR(rinfo) = mon_type;
+			if (SECONDARY_HEAD_PRESENT(rinfo)) {
+				mon_type = SECONDARY_MONITOR(rinfo);
+				if (SECONDARY_MONITOR(rinfo) > MT_NONE) {
+					if (radeon_probe_i2c_connector(rinfo, &SECONDARY_HEAD(rinfo)))
+						rinfo->connectors[rinfo->heads[1]].mon_type = mon_type;
 				}
-			if (rinfo->mon2_type != MT_NONE)
-				if (!radeon_probe_i2c_connector(rinfo, ddc_vga, &rinfo->mon2_EDID) &&
-				    !ddc_crt2_used)
-					radeon_probe_i2c_connector(rinfo, ddc_crt2, &rinfo->mon2_EDID);
+			}
 		}
 #endif /* CONFIG_FB_RADEON_I2C */
-		if (rinfo->mon1_type == MT_NONE) {
-			if (rinfo->mon2_type != MT_NONE) {
-				rinfo->mon1_type = rinfo->mon2_type;
-				rinfo->mon1_EDID = rinfo->mon2_EDID;
-			} else {
-				rinfo->mon1_type = MT_CRT;
-				printk(KERN_INFO "radeonfb: No valid monitor, assuming CRT on first port\n");
-			}
-			rinfo->mon2_type = MT_NONE;
-			rinfo->mon2_EDID = NULL;
+
+		/* If the user specified a bogus monitor layout... */
+		if (PRIMARY_MONITOR(rinfo) <= MT_NONE) {
+			radeon_find_connector_for_mon(rinfo, MT_CRT);
+			printk(KERN_INFO "radeonfb: No valid monitor, assuming CRT on first port\n");
 		}
 	} else {
 		/*
 		 * Auto-detecting display type (well... trying to ...)
 		 */
-		
-		RTRACE("Starting monitor auto detection...\n");
 
-#if DEBUG && defined(CONFIG_FB_RADEON_I2C)
-		{
-			u8 *EDIDs[4] = { NULL, NULL, NULL, NULL };
-			int mon_types[4] = {MT_NONE, MT_NONE, MT_NONE, MT_NONE};
-			int i;
+		RTRACE("Starting monitor auto detection...\n");
 
-			for (i = 0; i < 4; i++)
-				mon_types[i] = radeon_probe_i2c_connector(rinfo,
-									  i+1, &EDIDs[i]);
-		}
-#endif /* DEBUG */
 		/*
 		 * Old single head cards
 		 */
 		if (!rinfo->has_CRTC2) {
-#if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
-			if (rinfo->mon1_type == MT_NONE)
-				rinfo->mon1_type = radeon_probe_OF_head(rinfo, 0,
-									&rinfo->mon1_EDID);
-#endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 #ifdef CONFIG_FB_RADEON_I2C
-			if (rinfo->mon1_type == MT_NONE)
-				rinfo->mon1_type =
-					radeon_probe_i2c_connector(rinfo, ddc_dvi,
-								   &rinfo->mon1_EDID);
-			if (rinfo->mon1_type == MT_NONE)
-				rinfo->mon1_type =
-					radeon_probe_i2c_connector(rinfo, ddc_vga,
-								   &rinfo->mon1_EDID);
-			if (rinfo->mon1_type == MT_NONE)
-				rinfo->mon1_type =
-					radeon_probe_i2c_connector(rinfo, ddc_crt2,
-								   &rinfo->mon1_EDID);	
-#endif /* CONFIG_FB_RADEON_I2C */
-			if (rinfo->mon1_type == MT_NONE)
-				rinfo->mon1_type = MT_CRT;
-			goto bail;
-		}
-
-		/*
-		 * Check for cards with reversed DACs or TMDS controllers using BIOS
-		 */
-		if (rinfo->bios_seg &&
-		    (tmp = BIOS_IN16(rinfo->fp_bios_start + 0x50))) {
-			for (i = 1; i < 4; i++) {
-				unsigned int tmp0;
-
-				if (!BIOS_IN8(tmp + i*2) && i > 1)
+			/* Probe each connector */
+			for(i = 0 ; i < RADEON_MAX_CONNECTORS ; i++) {
+				if (PRIMARY_MONITOR(rinfo) > MT_NONE)
+					/* only one head */
 					break;
-				tmp0 = BIOS_IN16(tmp + i*2);
-				if ((!(tmp0 & 0x01)) && (((tmp0 >> 8) & 0x0f) == ddc_dvi)) {
-					rinfo->reversed_DAC = 1;
-					printk(KERN_INFO "radeonfb: Reversed DACs detected\n");
-				}
-				if ((((tmp0 >> 8) & 0x0f) == ddc_dvi) && ((tmp0 >> 4) & 0x01)) {
-					rinfo->reversed_TMDS = 1;
-					printk(KERN_INFO "radeonfb: Reversed TMDS detected\n");
+				if (!radeon_probe_i2c_connector(rinfo, &rinfo->connectors[i])) {
+					rinfo->heads[rinfo->num_heads] = i;
+					rinfo->connectors[i].head = rinfo->num_heads++;
 				}
 			}
+#endif /* CONFIG_FB_RADEON_I2C */
+			if (PRIMARY_MONITOR(rinfo) <= MT_NONE) {
+				radeon_find_connector_for_mon(rinfo, MT_CRT);
+			}
+			goto bail;
 		}
 
-		/*
-		 * Probe primary head (DVI or laptop internal panel)
-		 */
-#if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
-		if (rinfo->mon1_type == MT_NONE)
-			rinfo->mon1_type = radeon_probe_OF_head(rinfo, 0,
-								&rinfo->mon1_EDID);
-#endif /* CONFIG_PPC_OF || CONFIG_SPARC */
+		/* Probe heads */
 #ifdef CONFIG_FB_RADEON_I2C
-		if (rinfo->mon1_type == MT_NONE)
-			rinfo->mon1_type = radeon_probe_i2c_connector(rinfo, ddc_dvi,
-								      &rinfo->mon1_EDID);
-		if (rinfo->mon1_type == MT_NONE) {
-			rinfo->mon1_type = radeon_probe_i2c_connector(rinfo, ddc_crt2,
-								      &rinfo->mon1_EDID);
-			if (rinfo->mon1_type != MT_NONE)
-				ddc_crt2_used = 1;
-		}
-#endif /* CONFIG_FB_RADEON_I2C */
-		if (rinfo->mon1_type == MT_NONE && rinfo->is_mobility &&
-		    ((rinfo->bios_seg && (INREG(BIOS_4_SCRATCH) & 4))
-		     || (INREG(LVDS_GEN_CNTL) & LVDS_ON))) {
-			rinfo->mon1_type = MT_LCD;
-			printk("Non-DDC laptop panel detected\n");
+		/* Probe each connector in turn. */
+		for(i = 0; i < RADEON_MAX_CONNECTORS; i++) {
+			if (rinfo->connectors[i].mon_type > MT_NONE)
+				/* Don't probe "detected" stuff again */
+				continue;
+			if (!radeon_probe_i2c_connector(rinfo, &rinfo->connectors[i])) {
+				rinfo->heads[rinfo->num_heads] = i;
+				rinfo->connectors[i].head = rinfo->num_heads++;
+			}
 		}
-		if (rinfo->mon1_type == MT_NONE)
-			rinfo->mon1_type = radeon_crt_is_connected(rinfo, rinfo->reversed_DAC);
 
-		/*
-		 * Probe secondary head (mostly VGA, can be DVI)
-		 */
-#if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
-		if (rinfo->mon2_type == MT_NONE)
-			rinfo->mon2_type = radeon_probe_OF_head(rinfo, 1,
-								&rinfo->mon2_EDID);
-#endif /* CONFIG_PPC_OF || defined(CONFIG_SPARC) */
-#ifdef CONFIG_FB_RADEON_I2C
-		if (rinfo->mon2_type == MT_NONE)
-			rinfo->mon2_type = radeon_probe_i2c_connector(rinfo, ddc_vga,
-								      &rinfo->mon2_EDID);
-		if (rinfo->mon2_type == MT_NONE && !ddc_crt2_used)
-			rinfo->mon2_type = radeon_probe_i2c_connector(rinfo, ddc_crt2,
-								      &rinfo->mon2_EDID);
 #endif /* CONFIG_FB_RADEON_I2C */
-		if (rinfo->mon2_type == MT_NONE)
-			rinfo->mon2_type = radeon_crt_is_connected(rinfo, !rinfo->reversed_DAC);
 
-		/*
-		 * If we only detected port 2, we swap them, if none detected,
-		 * assume CRT (maybe fallback to old BIOS_SCRATCH stuff ? or look
-		 * at FP registers ?)
-		 */
-		if (rinfo->mon1_type == MT_NONE) {
-			if (rinfo->mon2_type != MT_NONE) {
-				rinfo->mon1_type = rinfo->mon2_type;
-				rinfo->mon1_EDID = rinfo->mon2_EDID;
-			} else
-				rinfo->mon1_type = MT_CRT;
-			rinfo->mon2_type = MT_NONE;
-			rinfo->mon2_EDID = NULL;
+		/* Mobility chips usually have LCDs... */
+		if ((PRIMARY_MONITOR(rinfo) <= MT_NONE) &&
+		    rinfo->is_mobility &&
+		    ((rinfo->bios_seg && (INREG(BIOS_4_SCRATCH) & 4)) ||
+		     (INREG(LVDS_GEN_CNTL) & (LVDS_EN|LVDS_ON)))) {
+			printk(KERN_INFO "radeonfb: Non-DDC laptop panel detected\n");
+			radeon_find_connector_for_mon(rinfo, MT_LCD);
+			if (rinfo->radeon_get_lvds_info) {
+				rinfo->radeon_get_lvds_info(rinfo);
+			}
 		}
 
-		/*
-		 * Deal with reversed TMDS
-		 */
-		if (rinfo->reversed_TMDS) {
-			/* Always keep internal TMDS as primary head */
-			if (rinfo->mon1_type == MT_DFP || rinfo->mon2_type == MT_DFP) {
-				int tmp_type = rinfo->mon1_type;
-				u8 *tmp_EDID = rinfo->mon1_EDID;
-				rinfo->mon1_type = rinfo->mon2_type;
-				rinfo->mon1_EDID = rinfo->mon2_EDID;
-				rinfo->mon2_type = tmp_type;
-				rinfo->mon2_EDID = tmp_EDID;
-				if (rinfo->mon1_type == MT_CRT || rinfo->mon2_type == MT_CRT)
-					rinfo->reversed_DAC ^= 1;
-			}
+		/* Probe for monitors on the primary and secondary crtc heads */
+		if (PRIMARY_MONITOR(rinfo) <= MT_NONE)
+			radeon_find_connector_for_mon(rinfo, radeon_crt_is_connected(rinfo, 1));
+
+		/* If we still haven't found anything, just force it to be on the CRT.. */
+		if (PRIMARY_MONITOR(rinfo) <= MT_NONE)
+			radeon_find_connector_for_mon(rinfo, MT_CRT);
+
+		/* Always keep internal TMDS as primary head */
+		if (SECONDARY_HEAD_PRESENT(rinfo) &&
+		    (SECONDARY_HEAD(rinfo).tmds_type == tmds_internal) &&
+		    (SECONDARY_MONITOR(rinfo) == MT_DFP)) {
+			int head = rinfo->heads[0];
+			rinfo->heads[0] = rinfo->heads[1];
+			rinfo->heads[1] = head;
 		}
 	}
-	if (ignore_edid) {
-		kfree(rinfo->mon1_EDID);
-		rinfo->mon1_EDID = NULL;
-		kfree(rinfo->mon2_EDID);
-		rinfo->mon2_EDID = NULL;
+bail:
+
+	/* Dump out the heads we've found so far */
+	for (i = 0; i < RADEON_MAX_CONNECTORS; i++) {
+		if (rinfo->connectors[i].conn_type == conn_none)
+			continue;
+		printk(KERN_INFO " * Connector %d is %s. Head %d, Monitor: %s ", i + 1,
+			conn_type_name[rinfo->connectors[i].conn_type],
+			rinfo->connectors[i].head,
+			rinfo->connectors[i].mon_type == MT_UNKNOWN  ?
+				"Not Probed Yet" :
+				mon_type_name[rinfo->connectors[i].mon_type]);
+
+		if (rinfo->connectors[i].edid)
+			printk("(EDID probed)\n");
+		else
+			printk("\n");
+
+		printk(KERN_INFO "   ddc port: %d, dac: %d, tmds: %d\n",
+			rinfo->connectors[i].ddc_type,
+			rinfo->connectors[i].dac_type,
+			rinfo->connectors[i].tmds_type);
 	}
-
- bail:
-	printk(KERN_INFO "radeonfb: Monitor 1 type %s found\n",
-	       radeon_get_mon_name(rinfo->mon1_type));
-	if (rinfo->mon1_EDID)
-		printk(KERN_INFO "radeonfb: EDID probed\n");
-	if (!rinfo->has_CRTC2)
-		return;
-	printk(KERN_INFO "radeonfb: Monitor 2 type %s found\n",
-	       radeon_get_mon_name(rinfo->mon2_type));
-	if (rinfo->mon2_EDID)
-		printk(KERN_INFO "radeonfb: EDID probed\n");
 }
 
 
-/*
- * This functions applyes any arch/model/machine specific fixups
- * to the panel info. It may eventually alter EDID block as
- * well or whatever is specific to a given model and not probed
- * properly by the default code
- */
-static void radeon_fixup_panel_info(struct radeonfb_info *rinfo)
-{
 #ifdef CONFIG_PPC_OF
+int __devinit radeon_get_lvds_info_openfirmware(struct radeonfb_info *rinfo)
+{
+
 	/*
 	 * LCD Flat panels should use fixed dividers, we enfore that on
 	 * PPC only for now...
 	 */
-	if (!rinfo->panel_info.use_bios_dividers && rinfo->mon1_type == MT_LCD
-	    && rinfo->is_mobility) {
+	if (!rinfo->panel_info.use_bios_dividers && (PRIMARY_MONITOR(rinfo) == MT_LCD) &&
+	    rinfo->is_mobility) {
 		int ppll_div_sel;
 		u32 ppll_divn;
 		ppll_div_sel = INREG8(CLOCK_CNTL_INDEX + 1) & 0x3;
@@ -667,15 +1244,16 @@ static void radeon_fixup_panel_info(struct radeonfb_info *rinfo)
 		rinfo->panel_info.post_divider = (ppll_divn >> 16) & 0x7;
 		rinfo->panel_info.use_bios_dividers = 1;
 
-		printk(KERN_DEBUG "radeonfb: Using Firmware dividers 0x%08x "
+		printk(KERN_INFO "Using Firmware dividers 0x%08x "
 		       "from PPLL %d\n",
 		       rinfo->panel_info.fbk_divider |
 		       (rinfo->panel_info.post_divider << 16),
 		       ppll_div_sel);
+		return 0;
 	}
-#endif /* CONFIG_PPC_OF */
+	return -ENODEV;
 }
-
+#endif /* CONFIG_PPC_OF */
 
 /*
  * Fill up panel infos from a mode definition, either returned by the EDID
@@ -688,18 +1266,18 @@ static void radeon_var_to_panel_info(struct radeonfb_info *rinfo, struct fb_var_
 	rinfo->panel_info.clock = 100000000 / var->pixclock;
 	rinfo->panel_info.hOver_plus = var->right_margin;
 	rinfo->panel_info.hSync_width = var->hsync_len;
-       	rinfo->panel_info.hblank = var->left_margin +
+	rinfo->panel_info.hblank = var->left_margin +
 		(var->right_margin + var->hsync_len);
 	rinfo->panel_info.vOver_plus = var->lower_margin;
 	rinfo->panel_info.vSync_width = var->vsync_len;
-       	rinfo->panel_info.vblank = var->upper_margin +
+	rinfo->panel_info.vblank = var->upper_margin +
 		(var->lower_margin + var->vsync_len);
 	rinfo->panel_info.hAct_high =
 		(var->sync & FB_SYNC_HOR_HIGH_ACT) != 0;
 	rinfo->panel_info.vAct_high =
 		(var->sync & FB_SYNC_VERT_HIGH_ACT) != 0;
 	rinfo->panel_info.valid = 1;
-	/* We use a default of 200ms for the panel power delay, 
+	/* We use a default of 200ms for the panel power delay,
 	 * I need to have a real schedule() instead of mdelay's in the panel code.
 	 * we might be possible to figure out a better power delay either from
 	 * MacOS OF tree or from the EDID block (proprietary extensions ?)
@@ -742,22 +1320,34 @@ void __devinit radeon_check_modes(struct radeonfb_info *rinfo, const char *mode_
 	info->var = radeonfb_default_var;
 	INIT_LIST_HEAD(&info->modelist);
 
-	/*
-	 * First check out what BIOS has to say
-	 */
-	if (rinfo->mon1_type == MT_LCD)
-		radeon_get_panel_info_BIOS(rinfo);
+	/* If we're an LCD and don't have a valid setup... */
+	if ((PRIMARY_MONITOR(rinfo) == MT_LCD) &&
+	    !rinfo->panel_info.valid &&
+	    rinfo->radeon_get_lvds_info) {
+		rinfo->radeon_get_lvds_info(rinfo);
+	}
+
+#if 0
+	/* If we're a mobility and still haven't detected a screen..? */
+	if ((PRIMARY_MONITOR(rinfo) <= MT_NONE) &&
+	    rinfo->is_mobility &&
+	    rinfo->radeon_get_lvds_info) {
+		if (!rinfo->radeon_get_lvds_info(rinfo))
+			radeon_find_connector_for_mon(rinfo, MT_LCD);
+	}
+#endif
 
 	/*
 	 * Parse EDID detailed timings and deduce panel infos if any. Right now
 	 * we only deal with first entry returned by parse_EDID, we may do better
 	 * some day...
 	 */
-	if (!rinfo->panel_info.use_bios_dividers && rinfo->mon1_type != MT_CRT
-	    && rinfo->mon1_EDID) {
+	if (!rinfo->panel_info.use_bios_dividers &&
+	    (PRIMARY_MONITOR(rinfo) != MT_CRT) &&
+	    PRIMARY_HEAD(rinfo).edid) {
 		struct fb_var_screeninfo var;
 		RTRACE("Parsing EDID data for panel info\n");
-		if (fb_parse_edid(rinfo->mon1_EDID, &var) == 0) {
+		if (fb_parse_edid(PRIMARY_HEAD(rinfo).edid, &var) == 0) {
 			if (var.xres >= rinfo->panel_info.xres &&
 			    var.yres >= rinfo->panel_info.yres)
 				radeon_var_to_panel_info(rinfo, &var);
@@ -765,15 +1355,10 @@ void __devinit radeon_check_modes(struct radeonfb_info *rinfo, const char *mode_
 	}
 
 	/*
-	 * Do any additional platform/arch fixups to the panel infos
-	 */
-	radeon_fixup_panel_info(rinfo);
-
-	/*
 	 * If we have some valid panel infos, we setup the default mode based on
 	 * those
 	 */
-	if (rinfo->mon1_type != MT_CRT && rinfo->panel_info.valid) {
+	if ((PRIMARY_MONITOR(rinfo) != MT_CRT) && rinfo->panel_info.valid) {
 		struct fb_var_screeninfo *var = &info->var;
 
 		RTRACE("Setting up default mode based on panel info\n");
@@ -804,22 +1389,21 @@ void __devinit radeon_check_modes(struct radeonfb_info *rinfo, const char *mode_
 	/*
 	 * Now build modedb from EDID
 	 */
-	if (rinfo->mon1_EDID) {
-		fb_edid_to_monspecs(rinfo->mon1_EDID, &info->monspecs);
+	if (PRIMARY_HEAD(rinfo).edid) {
+		fb_edid_to_monspecs(PRIMARY_HEAD(rinfo).edid, &info->monspecs);
 		fb_videomode_to_modelist(info->monspecs.modedb,
 					 info->monspecs.modedb_len,
 					 &info->modelist);
-		rinfo->mon1_modedb = info->monspecs.modedb;
-		rinfo->mon1_dbsize = info->monspecs.modedb_len;
+		PRIMARY_HEAD(rinfo).modedb = info->monspecs.modedb;
+		PRIMARY_HEAD(rinfo).modedb_size = info->monspecs.modedb_len;
 	}
 
-	
 	/*
 	 * Finally, if we don't have panel infos we need to figure some (or
 	 * we try to read it from card), we try to pick a default mode
 	 * and create some panel infos. Whatever...
 	 */
-	if (rinfo->mon1_type != MT_CRT && !rinfo->panel_info.valid) {
+	if ((PRIMARY_MONITOR(rinfo) != MT_CRT) && !rinfo->panel_info.valid) {
 		struct fb_videomode	*modedb;
 		int			dbsize;
 		char			modename[32];
@@ -833,25 +1417,26 @@ void __devinit radeon_check_modes(struct radeonfb_info *rinfo, const char *mode_
 		}
 		if (rinfo->panel_info.xres == 0 || rinfo->panel_info.yres == 0) {
 			printk(KERN_WARNING "radeonfb: Can't find panel size, going back to CRT\n");
-			rinfo->mon1_type = MT_CRT;
+			radeon_find_connector_for_mon(rinfo, MT_CRT);
 			goto pickup_default;
 		}
 		printk(KERN_WARNING "radeonfb: Assuming panel size %dx%d\n",
 		       rinfo->panel_info.xres, rinfo->panel_info.yres);
-		modedb = rinfo->mon1_modedb;
-		dbsize = rinfo->mon1_dbsize;
+		modedb = PRIMARY_HEAD(rinfo).modedb;
+		dbsize = PRIMARY_HEAD(rinfo).modedb_size;
 		snprintf(modename, 31, "%dx%d", rinfo->panel_info.xres, rinfo->panel_info.yres);
 		if (fb_find_mode(&info->var, info, modename,
 				 modedb, dbsize, NULL, 8) == 0) {
 			printk(KERN_WARNING "radeonfb: Can't find mode for panel size, going back to CRT\n");
-			rinfo->mon1_type = MT_CRT;
+			radeon_find_connector_for_mon(rinfo, MT_CRT);
 			goto pickup_default;
 		}
 		has_default_mode = 1;
+		radeon_find_connector_for_mon(rinfo, MT_LCD);
 		radeon_var_to_panel_info(rinfo, &info->var);
 	}
 
- pickup_default:
+pickup_default:
 	/*
 	 * Apply passed-in mode option if any
 	 */
@@ -860,7 +1445,7 @@ void __devinit radeon_check_modes(struct radeonfb_info *rinfo, const char *mode_
 				 info->monspecs.modedb,
 				 info->monspecs.modedb_len, NULL, 8) != 0)
 			has_default_mode = 1;
- 	}
+	}
 
 	/*
 	 * Still no mode, let's pick up a default from the db
@@ -947,14 +1532,14 @@ int  radeon_match_mode(struct radeonfb_info *rinfo,
 	memcpy(dest, src, sizeof(struct fb_var_screeninfo));
 
 	/* Check if we have a modedb built from EDID */
-	if (rinfo->mon1_modedb) {
-		db = rinfo->mon1_modedb;
-		dbsize = rinfo->mon1_dbsize;
+	if (PRIMARY_HEAD(rinfo).modedb) {
+		db = PRIMARY_HEAD(rinfo).modedb;
+		dbsize = PRIMARY_HEAD(rinfo).modedb_size;
 		native_db = 1;
 	}
 
 	/* Check if we have a scaler allowing any fancy mode */
-	has_rmx = rinfo->mon1_type == MT_LCD || rinfo->mon1_type == MT_DFP;
+	has_rmx = (PRIMARY_MONITOR(rinfo) == MT_LCD) || (PRIMARY_MONITOR(rinfo) == MT_DFP);
 
 	/* If we have a scaler and are passed FB_ACTIVATE_TEST or
 	 * FB_ACTIVATE_NOW, just do basic checking and return if the
@@ -967,7 +1552,7 @@ int  radeon_match_mode(struct radeonfb_info *rinfo,
 		 * 640x480-60, but I assume userland knows what it's doing here
 		 * (though I may be proven wrong...)
 		 */
-		if (has_rmx == 0 && rinfo->mon1_modedb)
+		if (has_rmx == 0 && PRIMARY_HEAD(rinfo).modedb)
 			if (fb_validate_mode((struct fb_var_screeninfo *)src, rinfo->info))
 				return -EINVAL;
 		return 0;
@@ -979,7 +1564,7 @@ int  radeon_match_mode(struct radeonfb_info *rinfo,
 			int d;
 
 			if (db[i].yres < src->yres)
-				continue;	
+				continue;
 			if (db[i].xres < src->xres)
 				continue;
 			d = radeon_compare_modes(src, &db[i]);
diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/aty/radeonfb.h
index 7ebffcd..9d0b161 100644
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -26,6 +26,8 @@
  * Most of the definitions here are adapted right from XFree86 *
  ***************************************************************/
 
+/* Sorry, we have to limit video ram to 128M */
+#define MAX_VRAM		(128*1024*1024)
 
 /*
  * Chip families. Must fit in the low 16 bits of a long word
@@ -47,7 +49,8 @@ enum radeon_family {
 	CHIP_FAMILY_R350,
 	CHIP_FAMILY_RV350,
 	CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
-	CHIP_FAMILY_R420,     /* R420/R423/M18 */
+	CHIP_FAMILY_RV410,    /* RV410/M26 */
+	CHIP_FAMILY_R420,     /* R420/R423/R480/M18 */
 	CHIP_FAMILY_RS480,
 	CHIP_FAMILY_LAST,
 };
@@ -65,6 +68,7 @@ enum radeon_family {
 				((rinfo)->family == CHIP_FAMILY_RV350) || \
 				((rinfo)->family == CHIP_FAMILY_R350)  || \
 				((rinfo)->family == CHIP_FAMILY_RV380) || \
+				((rinfo)->family == CHIP_FAMILY_RV410) || \
 				((rinfo)->family == CHIP_FAMILY_R420)  || \
 		                ((rinfo)->family == CHIP_FAMILY_RS480) )
 
@@ -88,11 +92,50 @@ enum radeon_errata {
 	CHIP_ERRATA_PLL_DELAY		= 0x00000004,
 };
 
+/*
+ * DDC i2c ports
+ */
+enum radeon_ddc_type {
+	ddc_none = -1,
+	ddc_monid = 0,
+	ddc_dvi,
+	ddc_vga,
+	ddc_crt2,
+};
+
+/*
+ * Connector types
+ */
+enum radeon_legacy_conn_type {
+	legacy_conn_none = 0,
+	legacy_conn_proprietary,
+	legacy_conn_crt,
+	legacy_conn_dvi_i,
+	legacy_conn_dvi_d,
+	legacy_conn_ctv,
+	legacy_conn_stv,
+	legacy_conn_unsupported,
+};
+
+enum radeon_conn_type {
+	conn_none = 0,
+	conn_vga,
+	conn_dvi_i,
+	conn_dvi_d,
+	conn_dvi_a,
+	conn_stv,
+	conn_ctv,
+	conn_lvds,
+	conn_digital,
+	conn_unsupported,
+	conn_proprietary,
+};
 
 /*
  * Monitor types
  */
-enum radeon_montype {
+enum radeon_mon_type {
+	MT_UNKNOWN = -1,
 	MT_NONE = 0,
 	MT_CRT,		/* CRT */
 	MT_LCD,		/* LCD */
@@ -102,27 +145,45 @@ enum radeon_montype {
 };
 
 /*
- * DDC i2c ports
+ * DAC types
  */
-enum ddc_type {
-	ddc_none,
-	ddc_monid,
-	ddc_dvi,
-	ddc_vga,
-	ddc_crt2,
+enum radeon_dac_type {
+	dac_unknown = -1,
+	dac_primary = 0,
+	dac_tvdac = 1,
 };
 
 /*
- * Connector types
+ * TMDS types
  */
-enum conn_type {
-	conn_none,
-	conn_proprietary,
-	conn_crt,
-	conn_DVI_I,
-	conn_DVI_D,
+enum radeon_tmds_type {
+	tmds_unknown = -1,
+	tmds_internal = 0,
+	tmds_external = 1,
 };
 
+/*
+ * Each connector gets this structure associated with it,
+ * containing infos about the connector wiring and about
+ * whatever has been detected on it
+ */
+struct radeon_connector {
+	enum radeon_conn_type	conn_type;
+	enum radeon_ddc_type	ddc_type;
+	enum radeon_dac_type	dac_type;
+	enum radeon_tmds_type	tmds_type;
+	enum radeon_mon_type	mon_type;
+	u8			*edid;
+	struct fb_videomode	*modedb;
+	unsigned int		modedb_size;
+
+	int head;
+};
+
+/*
+ * Currently, the driver deals with at most 4 connectors
+ */
+#define RADEON_MAX_CONNECTORS	4
 
 /*
  * PLL infos
@@ -130,11 +191,19 @@ enum conn_type {
 struct pll_info {
 	int ppll_max;
 	int ppll_min;
-	int sclk, mclk;
+	int sclk;
+	int mclk;
 	int ref_div;
 	int ref_clk;
 };
 
+/*
+ * TMDS PLL infos
+ */
+struct radeon_tmds_pll_info {
+	long	freq;
+	u32	value;
+};
 
 /*
  * This structure contains the various registers manipulated by this
@@ -301,6 +370,20 @@ struct radeonfb_info {
 	void __iomem		*bios_seg;
 	int			fp_bios_start;
 
+	int                     is_atom_bios;
+	int                     atom_data_start;
+
+	/* BIOS Functions */
+	int                     (*radeon_get_pll_info)(struct radeonfb_info *rinfo);
+	int                     (*radeon_get_lvds_info)(struct radeonfb_info *rinfo);
+	int                     (*radeon_get_conn_info)(struct radeonfb_info *rinfo);
+	int                     (*radeon_get_tmds_info)(struct radeonfb_info *rinfo);
+
+	/* Connector infos */
+	struct radeon_connector		connectors[RADEON_MAX_CONNECTORS];
+	int                     heads[RADEON_MAX_CONNECTORS];  // index into connectors.
+	int                     num_heads;  // number of heads.
+
 	u32			pseudo_palette[17];
 	struct { u8 red, green, blue, pad; }
 				palette[256];
@@ -319,15 +402,8 @@ struct radeonfb_info {
 	int			has_CRTC2;
 	int			is_mobility;
 	int			is_IGP;
-	int			reversed_DAC;
-	int			reversed_TMDS;
 	struct panel_info	panel_info;
-	int			mon1_type;
-	u8			*mon1_EDID;
-	struct fb_videomode	*mon1_modedb;
-	int			mon1_dbsize;
-	int			mon2_type;
-	u8		        *mon2_EDID;
+	struct radeon_tmds_pll_info	tmds_pll[4];
 
 	u32			dp_gui_master_cntl;
 
@@ -359,24 +435,19 @@ struct radeonfb_info {
 };
 
 
-#define PRIMARY_MONITOR(rinfo)	(rinfo->mon1_type)
+#define PRIMARY_HEAD(rinfo)      (rinfo->connectors[rinfo->heads[0]])
+#define SECONDARY_HEAD(rinfo)    (rinfo->connectors[rinfo->heads[1]])
+
+#define SECONDARY_HEAD_PRESENT(rinfo) (rinfo->heads[1] != -1)
 
+#define PRIMARY_MONITOR(rinfo)	 (rinfo->connectors[rinfo->heads[0]].mon_type)
+#define SECONDARY_MONITOR(rinfo) ((SECONDARY_HEAD_PRESENT(rinfo) ? (rinfo->connectors[rinfo->heads[1]].mon_type) : MT_NONE))
 
 /*
  * Debugging stuffs
  */
-#ifdef CONFIG_FB_RADEON_DEBUG
-#define DEBUG		1
-#else
-#define DEBUG		0
-#endif
-
-#if DEBUG
-#define RTRACE		printk
-#else
-#define RTRACE		if(0) printk
-#endif
-
+extern int radeonfb_debug;
+#define RTRACE		if(radeonfb_debug) printk
 
 /*
  * IO macros
@@ -599,7 +670,7 @@ static inline void _radeon_engine_idle(struct radeonfb_info *rinfo)
 /* I2C Functions */
 extern void radeon_create_i2c_busses(struct radeonfb_info *rinfo);
 extern void radeon_delete_i2c_busses(struct radeonfb_info *rinfo);
-extern int radeon_probe_i2c_connector(struct radeonfb_info *rinfo, int conn, u8 **out_edid);
+extern int radeon_probe_i2c_connector(struct radeonfb_info *rinfo, struct radeon_connector *conn);
 
 /* PM Functions */
 extern int radeonfb_pci_suspend(struct pci_dev *pdev, pm_message_t state);
@@ -637,4 +708,18 @@ static inline void radeonfb_bl_init(struct radeonfb_info *rinfo) {}
 static inline void radeonfb_bl_exit(struct radeonfb_info *rinfo) {}
 #endif
 
+/* Bios functions.  Fix this. */
+extern void __devinit radeon_get_conn_info(struct radeonfb_info *rinfo, int ignore_conntable);
+extern void __devinit radeon_get_tmds_info(struct radeonfb_info *rinfo);
+
+extern int __devinit radeon_get_lvds_info_atom(struct radeonfb_info *rinfo);
+extern int __devinit radeon_get_lvds_info_legacy(struct radeonfb_info *rinfo);
+extern int __devinit radeon_get_conn_info_atom(struct radeonfb_info *rinfo);
+extern int __devinit radeon_get_conn_info_legacy(struct radeonfb_info *rinfo);
+extern int __devinit radeon_get_tmds_info_legacy(struct radeonfb_info *rinfo);
+extern int __devinit radeon_get_tmds_info_atom(struct radeonfb_info *rinfo);
+#ifdef CONFIG_PPC_OF
+extern int __devinit radeon_get_lvds_info_openfirmware(struct radeonfb_info *rinfo);
+extern int __devinit radeon_get_conn_info_openfirmware(struct radeonfb_info *rinfo);
+#endif
 #endif /* __RADEONFB_H__ */



Luca
-- 
"New processes are created by other processes, just like new
 humans. New humans are created by other humans, of course,
 not by processes." -- Unix System Administration Handbook
