Return-Path: <linux-kernel-owner+w=401wt.eu-S1945967AbXBCNz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967AbXBCNz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 08:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945995AbXBCNz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 08:55:26 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:37131 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945967AbXBCNzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 08:55:25 -0500
Message-ID: <45C49444.8020503@drzeus.cx>
Date: Sat, 03 Feb 2007 14:55:16 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-18092-1170510923-0001-2"
To: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH] Fix up needless kmap:s
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-18092-1170510923-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

Hi Alex,

I'd like you to test and comment on the following patch.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-18092-1170510923-0001-2
Content-Type: text/plain; name="0001-mmc-tifm-replace-kmap-with-page_address.txt"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-mmc-tifm-replace-kmap-with-page_address.txt"

>From c8467c6b0ea0443f948c0ece281e1ca8e92f6ea7 Mon Sep 17 00:00:00 2001
From: Pierre Ossman <drzeus@drzeus.cx>
Date: Sat, 3 Feb 2007 13:36:41 +0100
Subject: [PATCH] mmc: tifm: replace kmap with page_address

Since we actively avoid highmem, calling kmap_atomic() instead
of page_address() is effectively only obfuscation.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
---
 drivers/mmc/tifm_sd.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/tifm_sd.c b/drivers/mmc/tifm_sd.c
index 7e607b7..e65f8a0 100644
--- a/drivers/mmc/tifm_sd.c
+++ b/drivers/mmc/tifm_sd.c
@@ -107,14 +107,9 @@ struct tifm_sd {
 
 };
 
-static char* tifm_sd_kmap_atomic(struct mmc_data *data)
+static char* tifm_sd_data_buffer(struct mmc_data *data)
 {
-	return kmap_atomic(data->sg->page, KM_BIO_SRC_IRQ) + data->sg->offset;
-}
-
-static void tifm_sd_kunmap_atomic(char *buffer, struct mmc_data *data)
-{
-	kunmap_atomic(buffer - data->sg->offset, KM_BIO_SRC_IRQ);
+	return page_address(data->sg->page) + data->sg->offset;
 }
 
 static int tifm_sd_transfer_data(struct tifm_dev *sock, struct tifm_sd *host,
@@ -127,18 +122,17 @@ static int tifm_sd_transfer_data(struct tifm_dev *sock, struct tifm_sd *host,
 	if (host_status & TIFM_MMCSD_BRS) {
 		/* in non-dma rx mode BRS fires when fifo is still not empty */
 		if (no_dma && (cmd->data->flags & MMC_DATA_READ)) {
-			buffer = tifm_sd_kmap_atomic(host->req->data);
+			buffer = tifm_sd_data_buffer(host->req->data);
 			while (host->buffer_size > host->buffer_pos) {
 				t_val = readl(sock->addr + SOCK_MMCSD_DATA);
 				buffer[host->buffer_pos++] = t_val & 0xff;
 				buffer[host->buffer_pos++] =
 							(t_val >> 8) & 0xff;
 			}
-			tifm_sd_kunmap_atomic(buffer, host->req->data);
 		}
 		return 1;
 	} else if (no_dma) {
-		buffer = tifm_sd_kmap_atomic(host->req->data);
+		buffer = tifm_sd_data_buffer(host->req->data);
 		if ((cmd->data->flags & MMC_DATA_READ) &&
 				(host_status & TIFM_MMCSD_AF)) {
 			for (cnt = 0; cnt < TIFM_MMCSD_FIFO_SIZE; cnt++) {
@@ -163,7 +157,6 @@ static int tifm_sd_transfer_data(struct tifm_dev *sock, struct tifm_sd *host,
 				}
 			}
 		}
-		tifm_sd_kunmap_atomic(buffer, host->req->data);
 	}
 	return 0;
 }
-- 
1.4.4.2


--=_hera.drzeus.cx-18092-1170510923-0001-2--
