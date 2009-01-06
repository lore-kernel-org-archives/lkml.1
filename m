Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZAFUfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZAFUfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZAFUe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:34:58 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35620 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751915AbZAFUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:34:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eSf/JKfYjkTAQsPVXKOi1t3tWq5/9XYLcDucDF7MJ4Sl/TwW++P0i7DAn6ayRIRJEpMJJMpOpzsoMHVjMiWsVup/otIq18gN/t0csb6Jy6hrJbZO9HvxTcnXr7k55P6hgwFYckp9VHCUMBJnk6DbsrLmhd+3tD1l47EPayQ6VVE=  ;
X-YMail-OSG: nx92_TUVM1ky3gYieW.elr6YmS3JhUSQKi9ZE0PtYyELRrPmtP4cuNNizw6gYBAP_im_YclsUVFbciIn.U1yTHIfU2XRc85WRNejMn6kcZ7L5GtevOx0dnHMWuo89ZDCzwMgh_Hjt55U_reful8Im_C3FNj2kBVovjuwx5DXuU_r2IKBrfAkenHeaRSc9KJZ4sPbCFAnNgUSbO9JF6UBM7TX0wxqhRDO3f3fo4990BlxUHmm_JjfE.v.Cw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: [patch 2.6.28-git] mfd:  dm355 evm MMC/SD card detection
Date: Tue, 6 Jan 2009 12:34:55 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061234.55826.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Support card detect and writeprotect switches on DM355 EVM.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
I'd actually not intended that this driver merge until the
DM355 platform (and EVM board) support merged ... but since
it's in mainline already, best that it match the latest
code in the DaVinci tree (simplifies merge-with-mainline).

--- a/drivers/mfd/dm355evm_msp.c
+++ b/drivers/mfd/dm355evm_msp.c
@@ -107,6 +107,9 @@ static const u8 msp_gpios[] = {
 	MSP_GPIO(0, SWITCH1), MSP_GPIO(1, SWITCH1),
 	MSP_GPIO(2, SWITCH1), MSP_GPIO(3, SWITCH1),
 	MSP_GPIO(4, SWITCH1),
+	/* switches on MMC/SD sockets */
+	MSP_GPIO(1, SDMMC), MSP_GPIO(2, SDMMC),	/* mmc0 WP, nCD */
+	MSP_GPIO(3, SDMMC), MSP_GPIO(4, SDMMC),	/* mmc1 WP, nCD */
 };
 
 #define MSP_GPIO_REG(offset)	(msp_gpios[(offset)] >> 3)
@@ -304,6 +307,13 @@ static int add_children(struct i2c_client *client)
 		gpio_export(gpio, false);
 	}
 
+	/* MMC/SD inputs -- right after the last config input */
+	if (client->dev.platform_data) {
+		void (*mmcsd_setup)(unsigned) = client->dev.platform_data;
+
+		mmcsd_setup(dm355evm_msp_gpio.base + 8 + 5);
+	}
+
 	/* RTC is a 32 bit counter, no alarm */
 	if (msp_has_rtc()) {
 		child = add_child(client, "rtc-dm355evm",
