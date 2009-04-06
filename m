Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZDGA0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZDGA0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZDGAZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:25:57 -0400
Received: from host2.marvell.com ([65.219.4.2]:37739 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751354AbZDGAZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:25:56 -0400
Date: Mon, 6 Apr 2009 15:50:56 -0700 (PDT)
From: Bing Zhao <bzhao@marvell.com>
X-X-Sender: bzhao@localhost.localdomain
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.29-wl] libertas: add support for Marvell SD8688 chip
Message-ID: <alpine.LFD.0.9999.0904061540070.23010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libertas: add support for Marvell SD8688 chip

Use RxPD->pkt_ptr to locate eth803 header in the packet
received since SD8688/v10 firmware allows a gap between
RxPD and eth803 header.

Set SDIO block size to 256 for CMD53.
The maximum block size for SD8688 WLAN function is set
to 512 in TPLFE_MAX_BLK_SIZE. But using 512 as block size
results upto 2K bytes data (4 blocks) being transferred
and causes buffer overflow in firmware.

Both changes above are backward compatible with earlier
firmware versions for SD8385/SD8686.

The SDIO_DEVICE_IDs for SD8688 chip are added in
include/linux/mmc/sdio_ids.h

Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/Kconfig            |    4 ++--
 drivers/net/wireless/libertas/if_sdio.c |   17 +++++++++++++----
 drivers/net/wireless/libertas/if_sdio.h |    2 ++
 drivers/net/wireless/libertas/rx.c      |   15 ++++++++-------
 include/linux/mmc/sdio_ids.h            |    2 ++
 5 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8a08235..ac9c07b 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -146,10 +146,10 @@ config LIBERTAS_CS
 	  A driver for Marvell Libertas 8385 CompactFlash devices.
 
 config LIBERTAS_SDIO
-	tristate "Marvell Libertas 8385 and 8686 SDIO 802.11b/g cards"
+	tristate "Marvell Libertas 8385/8686/8688 SDIO 802.11b/g cards"
 	depends on LIBERTAS && MMC
 	---help---
-	  A driver for Marvell Libertas 8385 and 8686 SDIO devices.
+	  A driver for Marvell Libertas 8385/8686/8688 SDIO devices.
 
 config LIBERTAS_SPI
 	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 76f4c65..55864c1 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -48,8 +48,11 @@ static char *lbs_fw_name = NULL;
 module_param_named(fw_name, lbs_fw_name, charp, 0644);
 
 static const struct sdio_device_id if_sdio_ids[] = {
-	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_LIBERTAS) },
-	{ /* end: all zeroes */						},
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL,
+			SDIO_DEVICE_ID_MARVELL_LIBERTAS) },
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL,
+			SDIO_DEVICE_ID_MARVELL_8688WLAN) },
+	{ /* end: all zeroes */				},
 };
 
 MODULE_DEVICE_TABLE(sdio, if_sdio_ids);
@@ -73,6 +76,12 @@ static struct if_sdio_model if_sdio_models[] = {
 		.helper = "sd8686_helper.bin",
 		.firmware = "sd8686.bin",
 	},
+	{
+		/* 8688 */
+		.model = 0x10,
+		.helper = "sd8688_helper.bin",
+		.firmware = "sd8688.bin",
+	},
 };
 
 struct if_sdio_packet {
@@ -488,7 +497,7 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 	ret = 0;
 
 release:
-	sdio_set_block_size(card->func, 0);
+	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
 	sdio_release_host(card->func);
 	kfree(chunk_buffer);
 release_fw:
@@ -624,7 +633,7 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 	ret = 0;
 
 release:
-	sdio_set_block_size(card->func, 0);
+	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
 	sdio_release_host(card->func);
 	kfree(chunk_buffer);
 release_fw:
diff --git a/drivers/net/wireless/libertas/if_sdio.h b/drivers/net/wireless/libertas/if_sdio.h
index 533bdfb..37ada2c 100644
--- a/drivers/net/wireless/libertas/if_sdio.h
+++ b/drivers/net/wireless/libertas/if_sdio.h
@@ -42,4 +42,6 @@
 
 #define IF_SDIO_EVENT           0x80fc
 
+#define IF_SDIO_BLOCK_SIZE	256
+
 #endif
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index e661e10..1e9b4ff 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -25,7 +25,6 @@ struct rfc1042hdr {
 } __attribute__ ((packed));
 
 struct rxpackethdr {
-	struct rxpd rx_pd;
 	struct eth803hdr eth803_hdr;
 	struct rfc1042hdr rfc1042_hdr;
 } __attribute__ ((packed));
@@ -158,8 +157,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 	if (priv->monitormode)
 		return process_rxed_802_11_packet(priv, skb);
 
-	p_rx_pkt = (struct rxpackethdr *) skb->data;
-	p_rx_pd = &p_rx_pkt->rx_pd;
+	p_rx_pd = (struct rxpd *) skb->data;
+	p_rx_pkt = (struct rxpackethdr *) ((u8 *)p_rx_pd +
+		le32_to_cpu(p_rx_pd->pkt_ptr));
 	if (priv->mesh_dev && (p_rx_pd->rx_control & RxPD_MESH_FRAME))
 		dev = priv->mesh_dev;
 
@@ -184,8 +184,9 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 		goto done;
 	}
 
-	lbs_deb_rx("rx data: skb->len-sizeof(RxPd) = %d-%zd = %zd\n",
-	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
+	lbs_deb_rx("rx data: skb->len - pkt_ptr = %d-%zd = %zd\n",
+		skb->len, le32_to_cpu(p_rx_pd->pkt_ptr),
+		skb->len - le32_to_cpu(p_rx_pd->pkt_ptr));
 
 	lbs_deb_hex(LBS_DEB_RX, "RX Data: Dest", p_rx_pkt->eth803_hdr.dest_addr,
 		sizeof(p_rx_pkt->eth803_hdr.dest_addr));
@@ -219,14 +220,14 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 		/* Chop off the rxpd + the excess memory from the 802.2/llc/snap header
 		 *   that was removed
 		 */
-		hdrchop = (u8 *) p_ethhdr - (u8 *) p_rx_pkt;
+		hdrchop = (u8 *)p_ethhdr - (u8 *)p_rx_pd;
 	} else {
 		lbs_deb_hex(LBS_DEB_RX, "RX Data: LLC/SNAP",
 			(u8 *) & p_rx_pkt->rfc1042_hdr,
 			sizeof(p_rx_pkt->rfc1042_hdr));
 
 		/* Chop off the rxpd */
-		hdrchop = (u8 *) & p_rx_pkt->eth803_hdr - (u8 *) p_rx_pkt;
+		hdrchop = (u8 *)&p_rx_pkt->eth803_hdr - (u8 *)p_rx_pd;
 	}
 
 	/* Chop off the leading header bytes so the skb points to the start of
diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
index ea1bf5b..c7211ab 100644
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -25,5 +25,7 @@
 
 #define SDIO_VENDOR_ID_MARVELL			0x02df
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103
+#define SDIO_DEVICE_ID_MARVELL_8688WLAN		0x9104
+#define SDIO_DEVICE_ID_MARVELL_8688BT		0x9105
 
 #endif
-- 
1.5.3.6
