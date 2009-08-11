Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZHKMTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZHKMTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZHKMS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:18:59 -0400
Received: from smtp.nokia.com ([192.100.122.230]:27449 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbZHKMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:18:56 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: [PATCH] wl1271: fix compiler warnings on 64 bit archs
Date: Tue, 11 Aug 2009 11:58:27 +0300
Message-Id: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 11 Aug 2009 08:58:30.0710 (UTC) FILETIME=[E60AD560:01CA1A61]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a few warnings when compiling the wl1271 driver on 64 bit
architectures.  This was due to size mismatch of integers.

This commit fixes the following warnings:

drivers/net/wireless/wl12xx/wl1271_main.c: In function 'wl1271_irq_work':
drivers/net/wireless/wl12xx/wl1271_main.c:184: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/wl12xx/wl1271_boot.c: In function 'wl1271_boot_upload_firmware_chunk':
drivers/net/wireless/wl12xx/wl1271_boot.c:103: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/net/wireless/wl12xx/wl1271_boot.c:150: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
drivers/net/wireless/wl12xx/wl1271_boot.c: In function 'wl1271_boot_enable_interrupts':
drivers/net/wireless/wl12xx/wl1271_boot.c:278: warning: large integer implicitly truncated to unsigned type

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    9 +++++----
 drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 4c22f25..2b5d101 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -100,8 +100,8 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 
 	wl1271_debug(DEBUG_BOOT, "starting firmware upload");
 
-	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d", fw_data_len,
-		CHUNK_SIZE);
+	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d",
+		     (u32) fw_data_len, CHUNK_SIZE);
 
 
 	if ((fw_data_len % 4) != 0) {
@@ -148,7 +148,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	addr = dest + chunk_num * CHUNK_SIZE;
 	p = buf + chunk_num * CHUNK_SIZE;
 	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%d B) 0x%p to 0x%x",
-		     fw_data_len % CHUNK_SIZE, p, addr);
+		     (u32) fw_data_len % CHUNK_SIZE, p, addr);
 	wl1271_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
 
 	return 0;
@@ -275,7 +275,8 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(WL1271_INTR_MASK));
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+			   WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
 	wl1271_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 3bb45ce..4102d59 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -181,7 +181,8 @@ static void wl1271_irq_work(struct work_struct *work)
 	} while (intr && --ctr);
 
 out_sleep:
-	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(WL1271_INTR_MASK));
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+			   WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
 	wl1271_ps_elp_sleep(wl);
 
 out:
-- 
1.6.0.4

