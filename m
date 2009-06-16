Return-Path: <linux-kernel-owner+w=401wt.eu-S937593AbZFPGJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937593AbZFPGJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935001AbZFPFwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:30 -0400
Received: from kroah.org ([198.145.64.141]:48357 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934847AbZFPFvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:08 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/64] firmware: wireless/libertas: prepare for FIRMWARE_NAME_MAX removal
Date: Mon, 15 Jun 2009 22:46:10 -0700
Message-Id: <1245131213-24168-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/libertas/if_spi.c |    8 ++++----
 drivers/net/wireless/libertas/if_spi.h |    3 +++
 drivers/net/wireless/libertas/if_usb.c |    8 ++------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index f8c2898..06a46d7 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -43,8 +43,8 @@ struct if_spi_card {
 	struct lbs_private		*priv;
 	struct libertas_spi_platform_data *pdata;
 
-	char				helper_fw_name[FIRMWARE_NAME_MAX];
-	char				main_fw_name[FIRMWARE_NAME_MAX];
+	char				helper_fw_name[IF_SPI_FW_NAME_MAX];
+	char				main_fw_name[IF_SPI_FW_NAME_MAX];
 
 	/* The card ID and card revision, as reported by the hardware. */
 	u16				card_id;
@@ -1019,9 +1019,9 @@ static int if_spi_calculate_fw_names(u16 card_id,
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
diff --git a/drivers/net/wireless/libertas/if_spi.h b/drivers/net/wireless/libertas/if_spi.h
index 2103869..f87eec4 100644
--- a/drivers/net/wireless/libertas/if_spi.h
+++ b/drivers/net/wireless/libertas/if_spi.h
@@ -22,6 +22,9 @@
 #define IF_SPI_CMD_BUF_SIZE 2400
 
 /***************** Firmware *****************/
+
+#define IF_SPI_FW_NAME_MAX 30
+
 struct chip_ident {
 	u16 chip_id;
 	u16 name;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index d649cae..1844c5a 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -61,11 +61,9 @@ static ssize_t if_usb_firmware_set(struct device *dev,
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
 
@@ -88,11 +86,9 @@ static ssize_t if_usb_boot2_set(struct device *dev,
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
1.6.3.2

