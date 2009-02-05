Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZBEH2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZBEH2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZBEH2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:28:11 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:59197 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZBEH2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:28:09 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82344178"
From: Bryan Wu <cooloney@kernel.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] wireless: introduce POWEROF2_BLOCKSIZE_ONLY option
Date: Thu,  5 Feb 2009 15:30:02 +0800
Message-Id: <1233819002-6912-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Introduce POWEROF2_BLOCKSIZE_ONLY option for those SD/SDIO host
which only support transferring block with size of power-of-2

[ Bryan Wu <cooloney@kernel.org>:
 - remove some useless coding style cleanup
 - using roundup() function as upstream does
]

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/wireless/Kconfig            |    6 ++++++
 drivers/net/wireless/libertas/if_sdio.c |   16 ++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index e4f9f74..a2685fa 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -151,6 +151,12 @@ config LIBERTAS_SDIO
 	---help---
 	  A driver for Marvell Libertas 8385 and 8686 SDIO devices.
 
+config POWEROF2_BLOCKSIZE_ONLY
+	bool "Support transferring block with size of power-of-2 only"
+	depends on LIBERTAS_SDIO
+	---help---
+	  For SD/SDIO host which only supports transferring block with size of power-of-2.
+
 config LIBERTAS_DEBUG
 	bool "Enable full debugging output in the Libertas module."
 	depends on LIBERTAS
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 4519d73..5efc056 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -272,6 +272,11 @@ static int if_sdio_card_to_host(struct if_sdio_card *card)
 	 */
 	chunk = sdio_align_size(card->func, size);
 
+/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
+#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
+	chunk = (chunk + card->func->cur_blksize - 1) /
+			card->func->cur_blksize * card->func->cur_blksize;
+#endif
 	ret = sdio_readsb(card->func, card->buffer, card->ioport, chunk);
 	if (ret)
 		goto out;
@@ -581,8 +586,14 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
 			lbs_deb_sdio("sending %d bytes (%d bytes) chunk\n",
 				chunk_size, (chunk_size + 31) / 32 * 32);
 */
+/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
+#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
+  			ret = sdio_writesb(card->func, card->ioport,
+ 				chunk_buffer, roundup(chunk_size, 256);
+#else
 			ret = sdio_writesb(card->func, card->ioport,
 				chunk_buffer, roundup(chunk_size, 32));
+#endif
 			if (ret)
 				goto release;
 
@@ -699,6 +710,11 @@ static int if_sdio_host_to_card(struct lbs_private *priv,
 	 */
 	size = sdio_align_size(card->func, nb + 4);
 
+/* For SD/SDIO host which only supports transferring block with size of power-of-2 */
+#if defined(CONFIG_POWEROF2_BLOCKSIZE_ONLY)
+	size = (size + card->func->cur_blksize - 1) /
+			card->func->cur_blksize * card->func->cur_blksize;
+#endif
 	packet = kzalloc(sizeof(struct if_sdio_packet) + size,
 			GFP_ATOMIC);
 	if (!packet) {
-- 
1.5.6.3
