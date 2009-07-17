Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbZGQIGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbZGQIGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934196AbZGQIGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:06:06 -0400
Received: from exchtp08.via.com.tw ([61.66.243.7]:53834 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934195AbZGQIGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:06:02 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: CONFIG_FB_VIA made the screen go black
Date: Fri, 17 Jul 2009 16:05:49 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8099666A3@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CONFIG_FB_VIA made the screen go black
Thread-Index: AcnwPm2ScXT/eQGgRfez8niYP7vTegF0wBTwBCjlzyA=
From: <JosephChan@via.com.tw>
To: <vegard.nossum@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <HaraldWelte@viatech.com>,
       <linux-fbdev-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 17 Jul 2009 08:05:51.0737 (UTC) FILETIME=[66D20E90:01CA06B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6H86WJ7020621

 Vegard,

We've patched this issue already. I also checked this patch with 2.6.31-rc2 kernel. It looks fine.
Would you please try this patch? Thanks.

BRs,
Joseph Chan 
========

diff -ruN a/drivers/video/via/hw.c b/drivers/video/via/hw.c
--- a/drivers/video/via/hw.c	2009-06-10 11:05:27.000000000 +0800
+++ b/drivers/video/via/hw.c	2009-07-13 15:41:52.000000000 +0800
@@ -508,7 +508,6 @@
 static void set_lcd_output_path(int set_iga, int output_interface);
 static int search_mode_setting(int ModeInfoIndex);
 static void load_fix_bit_crtc_reg(void);
-static void init_gfx_chip_info(void);
 static void init_tmds_chip_info(void);
 static void init_lvds_chip_info(void);
 static void device_screen_off(void);
@@ -1935,7 +1934,6 @@
 
 void viafb_init_chip_info(void)
 {
-	init_gfx_chip_info();
 	init_tmds_chip_info();
 	init_lvds_chip_info();
 
@@ -2008,7 +2006,7 @@
 	}
 }
 
-static void init_gfx_chip_info(void)
+bool viafb_init_gfx_chip_info(void)
 {
 	struct pci_dev *pdev = NULL;
 	u32 i;
@@ -2023,7 +2021,7 @@
 	}
 
 	if (!pciidlist[i].vendor)
-		return ;
+		return false;
 
 	viaparinfo->chip_info->gfx_chip_name = pciidlist[i].chip_index;
 
@@ -2058,6 +2056,8 @@
 	}
 
 	pci_dev_put(pdev);
+
+	return true;
 }
 
 static void init_tmds_chip_info(void)
diff -ruN a/drivers/video/via/hw.h b/drivers/video/via/hw.h
--- a/drivers/video/via/hw.h	2009-06-10 11:05:27.000000000 +0800
+++ b/drivers/video/via/hw.h	2009-07-13 15:35:29.000000000 +0800
@@ -929,5 +929,6 @@
 void viafb_set_iga_path(void);
 void viafb_set_start_addr(void);
 void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
+bool viafb_init_gfx_chip_info(void);
 
 #endif /* __HW_H__ */
diff -ruN a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c	2009-06-10 11:05:27.000000000 +0800
+++ b/drivers/video/via/viafbdev.c	2009-07-13 15:41:31.000000000 +0800
@@ -2142,6 +2142,13 @@
 	viaparinfo->chip_info = (struct chip_information *)
 		((unsigned long)viaparinfo->crt_setting_info + crt_length);
 
+	/* Identify via chip first */
+	if (!viafb_init_gfx_chip_info()) {
+		DEBUG_MSG(KERN_INFO "Not a via graphic chip \n");
+		framebuffer_release(viafbinfo);
+		return false;
+	}
+
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
 	parse_active_dev();
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
