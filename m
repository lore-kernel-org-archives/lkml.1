Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbZLOSQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbZLOSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760690AbZLOSQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:16:56 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:57205 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZLOSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QxtY9HhpxwC3g7M3E/JwHvjfpAd2XFE4QOoGL/V0UsMDWkW0eSssiZkuaJVrJs2VTG
         NKAKzAsFLmXanMqvs6+K4y0fSvX1Q78QUG3c30pGbZ9siiFox/RGD7M834F+y95+tvra
         dMmMEXHDzpz6Yi9E3nLk43LjdNnHQ+1pAHrL4=
Message-ID: <4B27D302.5060905@gmail.com>
Date: Tue, 15 Dec 2009 19:18:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] e1000: Fix tests of unsigned in e1000_tx_map()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables count and i are unsigned so the (<|>=) 0 tests do not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

I wasn't able to test this, so please review.

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 7e855f9..8d9da69 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -2802,13 +2802,13 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 dma_error:
 	dev_err(&pdev->dev, "TX DMA map failed\n");
 	buffer_info->dma = 0;
-	count--;
-
-	while (count >= 0) {
+	if (count)
 		count--;
-		i--;
-		if (i < 0)
+
+	while (count--) {
+		if (i == 0)
 			i += tx_ring->count;
+		i--;
 		buffer_info = &tx_ring->buffer_info[i];
 		e1000_unmap_and_free_tx_resource(adapter, buffer_info);
 	}
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 762b697..9be8d5d 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -3962,13 +3962,13 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 dma_error:
 	dev_err(&pdev->dev, "TX DMA map failed\n");
 	buffer_info->dma = 0;
-	count--;
-
-	while (count >= 0) {
+	if (count)
 		count--;
-		i--;
-		if (i < 0)
+
+	while (count--) {
+		if (i == 0)
 			i += tx_ring->count;
+		i--;
 		buffer_info = &tx_ring->buffer_info[i];
 		e1000_put_txbuf(adapter, buffer_info);;
 	}
