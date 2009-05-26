Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbZEZWvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbZEZWvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbZEZWtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:49:47 -0400
Received: from mga06.intel.com ([134.134.136.21]:8675 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760258AbZEZWtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:49:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="415865915"
Message-Id: <20090526225155.452895924@linux.intel.com>
References: <20090526224930.145059254@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 00:49:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: inux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 6/7 v2] wireless/libertas: prepare for FIRMWARE_NAME_MAX removal
Content-Disposition: inline; filename=firmware-libertas.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John W. Linville <linville@tuxdriver.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch eplaces the shared FIRMWARE_NAME_MAX definition with a libertas
local one.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Dan Williams <dcbw@redhat.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/libertas/if_spi.c |    8 ++++----
 drivers/net/wireless/libertas/if_spi.h |    3 +++
 drivers/net/wireless/libertas/if_usb.c |    8 ++------
 3 files changed, 9 insertions(+), 10 deletions(-)

Index: iwm-2.6/drivers/net/wireless/libertas/if_spi.c
===================================================================
--- iwm-2.6.orig/drivers/net/wireless/libertas/if_spi.c	2009-05-25 20:48:40.000000000 +0200
+++ iwm-2.6/drivers/net/wireless/libertas/if_spi.c	2009-05-27 00:29:57.000000000 +0200
@@ -44,8 +44,8 @@ struct if_spi_card {
 	struct lbs_private		*priv;
 	struct libertas_spi_platform_data *pdata;
 
-	char				helper_fw_name[FIRMWARE_NAME_MAX];
-	char				main_fw_name[FIRMWARE_NAME_MAX];
+	char				helper_fw_name[IF_SPI_FW_NAME_MAX];
+	char				main_fw_name[IF_SPI_FW_NAME_MAX];
 
 	/* The card ID and card revision, as reported by the hardware. */
 	u16				card_id;
@@ -1013,9 +1013,9 @@ static int if_spi_calculate_fw_names(u16
 		lbs_pr_err("Unsupported chip_id: 0x%02x\n", card_id);
 		return -EAFNOSUPPORT;
 	}
-	snprintf(helper_fw, FIRMWARE_NAME_MAX, "libertas/gspi%d_hlp.bin",
+	snprintf(helper_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d_hlp.bin",
 		 chip_id_to_device_name[i].name);
-	snprintf(main_fw, FIRMWARE_NAME_MAX, "libertas/gspi%d.bin",
+	snprintf(main_fw, IF_SPI_FW_NAME_MAX, "libertas/gspi%d.bin",
 		 chip_id_to_device_name[i].name);
 	return 0;
 }
Index: iwm-2.6/drivers/net/wireless/libertas/if_spi.h
===================================================================
--- iwm-2.6.orig/drivers/net/wireless/libertas/if_spi.h	2009-05-19 23:40:51.000000000 +0200
+++ iwm-2.6/drivers/net/wireless/libertas/if_spi.h	2009-05-27 00:29:57.000000000 +0200
@@ -22,6 +22,9 @@
 #define IF_SPI_CMD_BUF_SIZE 2400
 
 /***************** Firmware *****************/
+
+#define IF_SPI_FW_NAME_MAX 30
+
 struct chip_ident {
 	u16 chip_id;
 	u16 name;
Index: iwm-2.6/drivers/net/wireless/libertas/if_usb.c
===================================================================
--- iwm-2.6.orig/drivers/net/wireless/libertas/if_usb.c	2009-05-19 23:40:51.000000000 +0200
+++ iwm-2.6/drivers/net/wireless/libertas/if_usb.c	2009-05-27 00:29:57.000000000 +0200
@@ -61,11 +61,9 @@ static ssize_t if_usb_firmware_set(struc
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct if_usb_card *cardp = priv->card;
-	char fwname[FIRMWARE_NAME_MAX];
 	int ret;
 
-	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
-	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_FW);
+	ret = if_usb_prog_firmware(cardp, buf, BOOT_CMD_UPDATE_FW);
 	if (ret == 0)
 		return count;
 
@@ -88,11 +86,9 @@ static ssize_t if_usb_boot2_set(struct d
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
 	struct if_usb_card *cardp = priv->card;
-	char fwname[FIRMWARE_NAME_MAX];
 	int ret;
 
-	sscanf(buf, "%29s", fwname); /* FIRMWARE_NAME_MAX - 1 = 29 */
-	ret = if_usb_prog_firmware(cardp, fwname, BOOT_CMD_UPDATE_BOOT2);
+	ret = if_usb_prog_firmware(cardp, buf, BOOT_CMD_UPDATE_BOOT2);
 	if (ret == 0)
 		return count;
 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
