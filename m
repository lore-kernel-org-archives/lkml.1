Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZDRPdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZDRPdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 11:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZDRPdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 11:33:21 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:41756 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121AbZDRPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 11:33:18 -0400
Date: Sat, 18 Apr 2009 16:15:54 +0100
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 4/3] rt2860sta: call release_firmware on module exit, else resume is broken
Message-ID: <505368DED8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1239590029.18110.122.camel@deadeye.i.decadent.org.uk>
References: <1239590029.18110.122.camel@deadeye.i.decadent.org.uk>
Mail-Followup-To: Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman 
 <gregkh@suse.de>, linux-kernel@vger.kernel.org, David Woodhouse 
 <dwmw2@infradead.org>, Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-NuLabour-Date: Sat, 8905 Dec 1984 16:15:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resume breakage is as follows: it takes somewhat longer (firmware request
timeout), as a result of which the firmware isn't reloaded; and any
subsequent attempt to trying to bring down the interface results in a panic &
lockup (SysRq failure on my 901).

Consequently, it's better to request the firmware once and hang onto it until
the module is unloaded.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

diff -pur a/drivers/staging/rt2860/2860_main_dev.c b/drivers/staging/rt2860/2860_main_dev.c
--- a/drivers/staging/rt2860/2860_main_dev.c
+++ b/drivers/staging/rt2860/2860_main_dev.c
@@ -289,6 +289,7 @@ static INT __init rt2860_init_module(VOI
 static VOID __exit rt2860_cleanup_module(VOID)
 {
     pci_unregister_driver(&rt2860_driver);
+    NICForgetFirmware();
 }
 
 module_init(rt2860_init_module);
diff -pur a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -144,6 +144,8 @@ RTMP_REG_PAIR	STAMACRegTable[] =	{
 #define FW_FILENAME "rt2860.bin"
 MODULE_FIRMWARE(FW_FILENAME);
 
+const struct firmware *fw = NULL;
+
 #define FIRMWAREIMAGE_MAX_LENGTH	0x2000
 #define FIRMWARE_MAJOR_VERSION	0
 #define FIRMWARE_MINOR_VERSION	2
@@ -2583,6 +2585,12 @@ VOID NICEraseFirmware(
 
 }/* End of NICEraseFirmware */
 
+VOID NICForgetFirmware(void)
+{
+	release_firmware(fw);
+	fw = NULL;
+}
+
 /*
 	========================================================================
 
@@ -2603,11 +2611,11 @@ VOID NICEraseFirmware(
 NDIS_STATUS NICLoadFirmware(
 	IN PRTMP_ADAPTER pAd)
 {
-	const struct firmware *fw;
 	int ret, i;
 	NDIS_STATUS Status = NDIS_STATUS_SUCCESS;
 
-	ret = request_firmware(&fw, FW_FILENAME,
+	ret = fw ? 0 :
+	      request_firmware(&fw, FW_FILENAME,
 			       &((POS_COOKIE)pAd->OS_Cookie)->pci_dev->dev);
 	if (ret) {
 		printk(KERN_ERR "rt2860sta: firmware file %s request failed (%d)\n",
@@ -2659,7 +2667,7 @@ NDIS_STATUS NICLoadFirmware(
 	RTMP_IO_WRITE32(pAd, H2M_BBP_AGENT, 0);
 	RTMP_IO_WRITE32(pAd, H2M_MAILBOX_CSR, 0);
 
-	release_firmware(fw);
+	/*release_firmware(fw);*/
 
 	/* Check if MCU is ready - this may work even if firmware load
 	 * failed: specifically, if firmware was loaded some time ago & the
@@ -2689,7 +2697,7 @@ NDIS_STATUS NICLoadFirmware(
 	return Status;
 
 fail:
-	release_firmware(fw);
+	/*release_firmware(fw);*/
 	return NDIS_STATUS_FAILURE;
 } /* End of NICLoadFirmware */
 
diff -pur a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -3571,6 +3571,8 @@ VOID NICEraseFirmware(
 NDIS_STATUS NICLoadFirmware(
 	IN  PRTMP_ADAPTER   pAd);
 
+VOID NICForgetFirmware(void);
+
 NDIS_STATUS NICLoadRateSwitchingParams(
 	IN PRTMP_ADAPTER pAd);
 
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Burn less waste. Use less packaging. Waste less.     USE FEWER RESOURCES.

Your society will be sought by people of taste and refinement.
