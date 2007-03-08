Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXCHTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXCHTZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXCHTZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:25:31 -0500
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:39999 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933106AbXCHTZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:25:30 -0500
Message-ID: <45F062E1.8050007@gmail.com>
Date: Thu, 08 Mar 2007 20:24:17 +0100
From: johan henriksson <jhn98032@gmail.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [patch 2.6.20-1] radeonfb: Add support for Radeon xpress 200m
References: <45ECB2D0.3080205@telia.com> <45EEEBC9.1010002@redhat.com> <45EF275E.4060300@gmail.com> <45F03305.8040507@redhat.com>
In-Reply-To: <45F03305.8040507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Added support for radeon xpress 200m(rs480).
Note that the card doesn't like dynclk turned on.


Please CC replies to jhn98032@gmail.com


Signed-off-by: Johan Henriksson <jhn98032@gmail.com>
---

diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/ati_ids.h linux-2.6.20.1/drivers/video/aty/ati_ids.h
--- linux-2.6.20.1-vanilla/drivers/video/aty/ati_ids.h	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/ati_ids.h	Thu Mar  8 19:13:04 2007
@@ -209,4 +209,4 @@
 #define PCI_CHIP_R423_5D57              0x5D57
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
-
+#define PCI_CHIP_RS480_5955             0x5955
diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/radeon_base.c linux-2.6.20.1/drivers/video/aty/radeon_base.c
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeon_base.c	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeon_base.c	Thu Mar  8 19:13:04 2007
@@ -100,6 +100,8 @@
 	{ PCI_VENDOR_ID_ATI, id, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (flags) | (CHIP_FAMILY_##family) }
 
 static struct pci_device_id radeonfb_pci_table[] = {
+        /* Radeon Xpress 200m */
+	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
 	/* Mobility M6 */
 	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
 	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
@@ -1990,7 +1992,8 @@ static void radeon_identify_vram(struct 
 	/* framebuffer size */
         if ((rinfo->family == CHIP_FAMILY_RS100) ||
             (rinfo->family == CHIP_FAMILY_RS200) ||
-            (rinfo->family == CHIP_FAMILY_RS300)) {
+            (rinfo->family == CHIP_FAMILY_RS300) ||
+	    (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
 
@@ -2329,7 +2332,7 @@ static int __devinit radeonfb_pci_regist
 		/* -2 is special: means  ON on mobility chips and do not
 		 * change on others
 		 */
-		radeonfb_pm_init(rinfo, rinfo->is_mobility ? 1 : -1, ignore_devlist, force_sleep);
+		radeonfb_pm_init(rinfo, rinfo->is_mobility && rinfo->family != CHIP_FAMILY_RS480 ? 1 : -1, ignore_devlist, force_sleep);
 	} else
 		radeonfb_pm_init(rinfo, default_dynclk, ignore_devlist, force_sleep);
 
diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/radeonfb.h linux-2.6.20.1/drivers/video/aty/radeonfb.h
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeonfb.h	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeonfb.h	Thu Mar  8 19:13:04 2007
@@ -48,6 +48,7 @@ enum radeon_family {
 	CHIP_FAMILY_RV350,
 	CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
 	CHIP_FAMILY_R420,     /* R420/R423/M18 */
+	CHIP_FAMILY_RS480,
 	CHIP_FAMILY_LAST,
 };
 
@@ -64,7 +65,8 @@ enum radeon_family {
 				((rinfo)->family == CHIP_FAMILY_RV350) || \
 				((rinfo)->family == CHIP_FAMILY_R350)  || \
 				((rinfo)->family == CHIP_FAMILY_RV380) || \
-				((rinfo)->family == CHIP_FAMILY_R420))
+				((rinfo)->family == CHIP_FAMILY_R420)  || \
+		                ((rinfo)->family == CHIP_FAMILY_RS480) )
 
 /*
  * Chip flags
