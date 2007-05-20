Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbXETMyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbXETMyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 08:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXETMyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 08:54:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:39781 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755066AbXETMyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 08:54:24 -0400
X-Authenticated: #276141
X-Provags-ID: V01U2FsdGVkX1/3iwlewLr3f7+HNG2GU02pGVF+6pN+MfDEG28ASP
	aSLdyF6tfpsVQ5
Message-ID: <465044FC.30204@gmx.net>
Date: Sun, 20 May 2007 14:54:20 +0200
From: Jimmy Jazz <Jimmy.Jazz@gmx.net>
Reply-To: Jimmy.Jazz@gmx.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.3) Gecko/20070517 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Luca Tettamanti <kronos.it@gmail.com>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: radeonfb and X800 cards
References: <464BB43D.2020407@gentoo.org>	 <1179367164.32247.256.camel@localhost.localdomain>	 <20070517195958.GA6489@dreamland.darkstar.lan> <1179451140.32247.326.camel@localhost.localdomain>
In-Reply-To: <1179451140.32247.326.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------070304020508030406000205"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070304020508030406000205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Benjamin Herrenschmidt a écrit :
>> This is what I'm using here, it's still the same old patch (Solomon's
>> plus my stuff). I think I can coordinate with Jimmy.Jazz@gmx.net to
>> create an incremental patch to fix radeonfb on his hardware (provided
>> that this mega-patch is suitable as baseline that is).
> 
> Yes, I would very much appreciate if you guys managed to turn that into
> some incremental patch serie. That would make it much easier for me to
> review properly and track down possible regressions in fact.
> 
> Ben.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hello,

i would be glad to help you to build an incremental patch.

Also, my goal was to make it possible to use the console radeon
framebuffer, to have a nice splash screen on a wide flat panel in its
native mode and to have it stay as much as possible compatible with xorg
dri and co. Also, it is working for me now.

Finally, i tried to modify/introduce as few codes as possible and make
it easier to X800 family card users to validate the patch, especially if
they use a flat panel connected to the dvi port without a vga
dongle/adaptator. If someone just tries it and tells if it works with
xorg without problem as it works for me, that would be great.

@Luca, if i remember well you have a X850, could you please try the
patch for me ?

The patch i introduced concerns the fact that my card doesn't handle
very well the dvi connector with the radeonfb kernel driver. The driver
just defaulted the connector to vga. However, the driver defines monid
but is never detected/used during auto detection. I just add it in
radeon_monitor.c. It seems pretty easy isn't it ;).
In fact, the code that made it possible to get something different than
a black screen, stays mostly in radeon_monitor.c:
@@ -552,6 +541,9 @@
 #endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 #ifdef CONFIG_FB_RADEON_I2C
 		if (rinfo->mon1_type == MT_NONE)
+			rinfo->mon1_type = radeon_probe_i2c_connector(rinfo, ddc_monid,
+								      &rinfo->mon1_EDID);
+		if (rinfo->mon1_type == MT_NONE)
 			rinfo->mon1_type = radeon_probe_i2c_connector(rinfo, ddc_dvi,
 								      &rinfo->mon1_EDID);
 		if (rinfo->mon1_type == MT_NONE) {
@@ -643,7 +635,7 @@

Also, radeon_accel.c is important to get xorg work as well. In fact, you
will get FIFO errors in xorg and dri won't be able to be initialized, if
radeon_accel.c doesn't understand your card.

I tried the patch with an old agp 9700 radeon card with a dvi connector,
connected to a flat panel. The patch does nothing as expected and seems
rather harmless in that case.
It works great, with a "ATI Radeon X800XT (R423) 5D57 (PCIE)" (ChipID =
0x5d57).

you can apply aty-2.6.22.diff to a 2.6.22-rc1-mm1 kernel and 2.6.21
kernels as well.

(The patch needs to be applied directly in the drivers/video/aty directory)

Thank you for you great work and your interest in the radeon framebuffer
driver :).

Jj



--------------070304020508030406000205
Content-Type: text/plain;
 name="aty-2.6.22.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aty-2.6.22.diff"

--- radeon_accel.c.ori	2007-05-09 17:09:00.000000000 +0200
+++ radeon_accel.c	2007-05-09 18:59:25.000000000 +0200
@@ -203,9 +203,7 @@
 	host_path_cntl = INREG(HOST_PATH_CNTL);
 	rbbm_soft_reset = INREG(RBBM_SOFT_RESET);
 
-	if (rinfo->family == CHIP_FAMILY_R300 ||
-	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	if (IS_R300_VARIANT(rinfo)) {
 		u32 tmp;
 
 		OUTREG(RBBM_SOFT_RESET, (rbbm_soft_reset |
@@ -241,9 +239,7 @@
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 ||
-	    rinfo->family != CHIP_FAMILY_R350 ||
-	    rinfo->family != CHIP_FAMILY_RV350)
+	if (IS_R300_VARIANT(rinfo))
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
 	OUTREG(CLOCK_CNTL_INDEX, clock_cntl_index);
@@ -254,16 +250,15 @@
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
--- radeon_base.c.ori	2007-05-09 17:09:00.000000000 +0200
+++ radeon_base.c	2007-05-09 19:07:19.000000000 +0200
@@ -582,6 +582,32 @@
 	return 0;
 }
 
+static void radeon_detect_bios_type(struct radeonfb_info *rinfo)
+{
+#ifndef CONFIG_PPC_OF
+          int offset = rinfo->fp_bios_start + 4;
+          unsigned char sign[4];
+
+                  sign[0] = BIOS_IN8(offset);
+                  sign[1] = BIOS_IN8(offset + 1);
+                  sign[2] = BIOS_IN8(offset + 2);
+                  sign[3] = BIOS_IN8(offset + 3);
+
+          if (!memcmp(sign, "ATOM", 4) || !memcmp(sign, "MOTA", 4)) {
+                rinfo->is_atom_bios = 1;
+                rinfo->atom_data_start = BIOS_IN16(rinfo->fp_bios_start + 32);
+
+       		printk(KERN_INFO "radeonfb: ATOM BIOS signature found\n");
+
+		return;
+          } 
+#endif  /* NOT CONFIG_PPC_OF */
+
+          rinfo->is_atom_bios = 0;
+
+	  return;
+}
+
 /*
  * Retrieve PLL infos by different means (BIOS, Open Firmware, register probing...)
  */
@@ -658,20 +684,38 @@
 #endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 
 	/*
-	 * Check out if we have an X86 which gave us some PLL informations
+	 * Check out if we have an ATOM BIOS which gave us some PLL informations
 	 * and if yes, retrieve them
 	 */
+
 	if (!force_measure_pll && rinfo->bios_seg) {
-		u16 pll_info_block = BIOS_IN16(rinfo->fp_bios_start + 0x30);
+        	u16 pll_info_block;
 
-		rinfo->pll.sclk		= BIOS_IN16(pll_info_block + 0x08);
-		rinfo->pll.mclk		= BIOS_IN16(pll_info_block + 0x0a);
-		rinfo->pll.ref_clk	= BIOS_IN16(pll_info_block + 0x0e);
-		rinfo->pll.ref_div	= BIOS_IN16(pll_info_block + 0x10);
-		rinfo->pll.ppll_min	= BIOS_IN32(pll_info_block + 0x12);
-		rinfo->pll.ppll_max	= BIOS_IN32(pll_info_block + 0x16);
+		if(rinfo->is_atom_bios) {
+        		pll_info_block = BIOS_IN16(rinfo->atom_data_start + 12);
 
+        		rinfo->pll.sclk = BIOS_IN32(pll_info_block + 8);
+        		rinfo->pll.mclk = BIOS_IN32(pll_info_block + 12);
+        		rinfo->pll.ref_clk = BIOS_IN16(pll_info_block + 82);
+        		rinfo->pll.ref_div = 0; /* Have to get it elsewhere */
+        		rinfo->pll.ppll_min = BIOS_IN16(pll_info_block + 78);
+        		rinfo->pll.ppll_max = BIOS_IN32(pll_info_block + 32);
+		} else {
+	/*
+	 * Check out if we have an X86 which gave us some PLL informations
+	 * and if yes, retrieve them
+	 */
+			pll_info_block = BIOS_IN16(rinfo->fp_bios_start + 0x30);
+
+			rinfo->pll.sclk		= BIOS_IN16(pll_info_block + 0x08);
+			rinfo->pll.mclk		= BIOS_IN16(pll_info_block + 0x0a);
+			rinfo->pll.ref_clk	= BIOS_IN16(pll_info_block + 0x0e);
+			rinfo->pll.ref_div	= BIOS_IN16(pll_info_block + 0x10);
+			rinfo->pll.ppll_min	= BIOS_IN32(pll_info_block + 0x12);
+			rinfo->pll.ppll_max	= BIOS_IN32(pll_info_block + 0x16);
+		}
 		printk(KERN_INFO "radeonfb: Retrieved PLL infos from BIOS\n");
+
 		goto found;
 	}
 
@@ -687,18 +731,38 @@
 	/*
 	 * Fall back to already-set defaults...
 	 */
-       	printk(KERN_INFO "radeonfb: Used default PLL infos\n");
+       	printk(KERN_INFO "radeonfb: Fall back to default PLL infos\n");
 
 found:
+       /* Check and fix-up the PLL divisor if necessary */
+        if (rinfo->pll.ref_div < 2) {
+                int tmp = INPLL(PPLL_REF_DIV);
+                if (rinfo->family == CHIP_FAMILY_RS300) {
+                        rinfo->pll.ref_div = (tmp & R300_PPLL_REF_DIV_ACC_MASK) >> R300_PPLL_REF_DIV_ACC_SHIFT;
+                } else {
+                        rinfo->pll.ref_div = tmp & PPLL_REF_DIV_MASK;
+                }
+
+                /* Sane default */
+                if (rinfo->pll.ref_div < 2) {
+       			printk(KERN_INFO "radeonfb: Set a sane default PLL divisor\n");
+                        rinfo->pll.ref_div = 12;
+                }
+        }
+
 	/*
 	 * Some methods fail to retrieve SCLK and MCLK values, we apply default
-	 * settings in this case (200Mhz). If that really happne often, we could
+	 * settings in this case (200Mhz). If that really happen often, we could
 	 * fetch from registers instead...
 	 */
-	if (rinfo->pll.mclk == 0)
+	if (rinfo->pll.mclk == 0) {
+       		printk(KERN_INFO "radeonfb: Set a sane default MCLK value\n");
 		rinfo->pll.mclk = 20000;
-	if (rinfo->pll.sclk == 0)
+	}
+	if (rinfo->pll.mclk == 0) {
+       		printk(KERN_INFO "radeonfb: Set a sane default SCLK value\n");
 		rinfo->pll.sclk = 20000;
+	}
 
 	printk("radeonfb: Reference=%d.%02d MHz (RefDiv=%d) Memory=%d.%02d Mhz, System=%d.%02d MHz\n",
 	       rinfo->pll.ref_clk / 100, rinfo->pll.ref_clk % 100,
@@ -2302,6 +2366,9 @@
 	if (rinfo->bios_seg == NULL && rinfo->is_mobility)
 		radeon_map_ROM(rinfo, pdev);
 
+        /* Check BIOS Type */
+        radeon_detect_bios_type(rinfo);
+
 	/* Get informations about the board's PLL */
 	radeon_get_pllinfo(rinfo);
 
@@ -2429,6 +2496,8 @@
 
         radeonfb_bl_exit(rinfo);
 
+        radeonfb_bl_exit(rinfo);
+
         iounmap(rinfo->mmio_base);
         iounmap(rinfo->fb_base);
  
--- radeonfb.h.ori	2007-05-09 17:09:00.000000000 +0200
+++ radeonfb.h	2007-05-09 19:17:11.000000000 +0200
@@ -301,6 +301,9 @@
 	void __iomem		*bios_seg;
 	int			fp_bios_start;
 
+	int			is_atom_bios;
+        int                     atom_data_start;
+
 	u32			pseudo_palette[17];
 	struct { u8 red, green, blue, pad; }
 				palette[256];
--- radeon_monitor.c.ori	2007-05-09 18:56:37.000000000 +0200
+++ radeon_monitor.c	2007-05-09 19:18:14.000000000 +0200
@@ -481,17 +481,6 @@
 		
 		RTRACE("Starting monitor auto detection...\n");
 
-#if DEBUG && defined(CONFIG_FB_RADEON_I2C)
-		{
-			u8 *EDIDs[4] = { NULL, NULL, NULL, NULL };
-			int mon_types[4] = {MT_NONE, MT_NONE, MT_NONE, MT_NONE};
-			int i;
-
-			for (i = 0; i < 4; i++)
-				mon_types[i] = radeon_probe_i2c_connector(rinfo,
-									  i+1, &EDIDs[i]);
-		}
-#endif /* DEBUG */
 		/*
 		 * Old single head cards
 		 */
@@ -531,11 +520,11 @@
 				if (!BIOS_IN8(tmp + i*2) && i > 1)
 					break;
 				tmp0 = BIOS_IN16(tmp + i*2);
-				if ((!(tmp0 & 0x01)) && (((tmp0 >> 8) & 0x0f) == ddc_dvi)) {
+				if ((!(tmp0 & 0x01)) && ((((tmp0 >> 8) & 0x0f) == ddc_dvi) || (((tmp0 >> 8) & 0x0f) == ddc_monid))) {
 					rinfo->reversed_DAC = 1;
 					printk(KERN_INFO "radeonfb: Reversed DACs detected\n");
 				}
-				if ((((tmp0 >> 8) & 0x0f) == ddc_dvi) && ((tmp0 >> 4) & 0x01)) {
+				if ((((tmp0 >> 8) & 0x0f) == ddc_dvi || (((tmp0 >> 8) & 0x0f) == ddc_monid)) && ((tmp0 >> 4) & 0x01)) {
 					rinfo->reversed_TMDS = 1;
 					printk(KERN_INFO "radeonfb: Reversed TMDS detected\n");
 				}
@@ -552,6 +541,9 @@
 #endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 #ifdef CONFIG_FB_RADEON_I2C
 		if (rinfo->mon1_type == MT_NONE)
+			rinfo->mon1_type = radeon_probe_i2c_connector(rinfo, ddc_monid,
+								      &rinfo->mon1_EDID);
+		if (rinfo->mon1_type == MT_NONE)
 			rinfo->mon1_type = radeon_probe_i2c_connector(rinfo, ddc_dvi,
 								      &rinfo->mon1_EDID);
 		if (rinfo->mon1_type == MT_NONE) {
@@ -643,7 +635,7 @@
 
 
 /*
- * This functions applyes any arch/model/machine specific fixups
+ * This functions applies any arch/model/machine specific fixups
  * to the panel info. It may eventually alter EDID block as
  * well or whatever is specific to a given model and not probed
  * properly by the default code

--------------070304020508030406000205--
