Return-Path: <linux-kernel-owner+w=401wt.eu-S1767526AbXCIT51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767526AbXCIT51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767529AbXCIT51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:57:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:25955 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767526AbXCIT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:57:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Un/Avn5hLwI1DsK7OcM9e6MZ+urWazW5dYkoQpQr6IeFymykN5ViGCYE/H0bPaQ4y/fgib3AIB96vhpsjLtJZSYJ7EG1G7qnDr9Ddk/+IadhSqxEagpYljKnxyf/nb7F/E1Ke2XqxSlML11LwUunqD4XoOloZTVC+d3062cTxcQ=
Message-ID: <45F1BC20.1090908@gmail.com>
Date: Fri, 09 Mar 2007 20:57:20 +0100
From: johan henriksson <jhn98032@gmail.com>
User-Agent: Mail/News 1.5.0.8 (X11/20061119)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [patch 2.6.20-1] radeonfb: Add support for Radeon xpress 200m
References: <45ECB2D0.3080205@telia.com> <45EEEBC9.1010002@redhat.com>	 <45EF275E.4060300@gmail.com> <45F03305.8040507@redhat.com>	 <45F062E1.8050007@gmail.com> <1173445234.24454.13.camel@localhost.localdomain>
In-Reply-To: <1173445234.24454.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>> -		radeonfb_pm_init(rinfo, rinfo->is_mobility ? 1 : -1, ignore_devlist, force_sleep);
>> +		radeonfb_pm_init(rinfo, rinfo->is_mobility && rinfo->family != CHIP_FAMILY_RS480 ? 1 : -1, ignore_devlist, force_sleep);
> 
> I'd rather you add a check for RS480 inside radeonfb_pm_*
> 
> Ben.
> 
> 

Something like this?


---
diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/ati_ids.h linux-2.6.20.1/drivers/video/aty/ati_ids.h
--- linux-2.6.20.1-vanilla/drivers/video/aty/ati_ids.h	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/ati_ids.h	Fri Mar  9 20:30:09 2007
@@ -209,4 +209,4 @@
 #define PCI_CHIP_R423_5D57              0x5D57
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
-
+#define PCI_CHIP_RS480_5955             0x5955
diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/radeon_base.c linux-2.6.20.1/drivers/video/aty/radeon_base.c
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeon_base.c	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeon_base.c	Fri Mar  9 20:42:31 2007
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
 
diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/radeon_pm.c linux-2.6.20.1/drivers/video/aty/radeon_pm.c
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeon_pm.c	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeon_pm.c	Fri Mar  9 20:39:54 2007
@@ -2826,11 +2826,15 @@ void radeonfb_pm_init(struct radeonfb_in
 	rinfo->pm_reg = pci_find_capability(rinfo->pdev, PCI_CAP_ID_PM);
 
 	/* Enable/Disable dynamic clocks: TODO add sysfs access */
-	rinfo->dynclk = dynclk;
-	if (dynclk == 1) {
+	if (rinfo->family == CHIP_FAMILY_RS480)
+		rinfo->dynclk = -1;
+	else
+		rinfo->dynclk = dynclk; 
+	
+	if (rinfo->dynclk == 1) {
 		radeon_pm_enable_dynamic_mode(rinfo);
 		printk("radeonfb: Dynamic Clock Power Management enabled\n");
-	} else if (dynclk == 0) {
+	} else if (rinfo->dynclk == 0) {
 		radeon_pm_disable_dynamic_mode(rinfo);
 		printk("radeonfb: Dynamic Clock Power Management disabled\n");
 	}
diff -upr linux-2.6.20.1-vanilla/drivers/video/aty/radeonfb.h linux-2.6.20.1/drivers/video/aty/radeonfb.h
--- linux-2.6.20.1-vanilla/drivers/video/aty/radeonfb.h	Tue Feb 20 07:34:32 2007
+++ linux-2.6.20.1/drivers/video/aty/radeonfb.h	Fri Mar  9 20:30:09 2007
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
