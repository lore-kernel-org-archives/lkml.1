Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbZLOTAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbZLOTAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbZLOTAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:00:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60557 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414AbZLOTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=LhwP42vQNpO7OZd0NSWQzuMdxcPoURdH8xTO+KaqumINlg8dI8ZGQxSP8uJubJSMCS
         olsYZcFcvNo8ELsi4wxRTLf11rR6ppsv8k+OUtzxpWnfdXkkKmRvnqaCtelRPp0hv0Lq
         ZVSGEYPRmtU77x4gue0zKtDmovcTu16K7QkI8=
Message-ID: <4B27DD2E.1020409@gmail.com>
Date: Tue, 15 Dec 2009 20:02:06 +0100
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
Subject: Re: [PATCH] e1000: Fix tests of unsigned in e1000_tx_map()
References: <4B27D302.5060905@gmail.com> <25e057c00912151047k436058ep2bcff69bdaedcc7a@mail.gmail.com>
In-Reply-To: <25e057c00912151047k436058ep2bcff69bdaedcc7a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables count and i are unsigned so the (<|>=) 0 tests do not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

This should be all with this pattern.
As before I wasn't able to test this patch, so please review.

 drivers/net/e1000/e1000_main.c |   10 +++++-----
 drivers/net/e1000e/netdev.c    |   10 +++++-----
 drivers/net/igb/igb_main.c     |   10 +++++-----
 drivers/net/igbvf/netdev.c     |   10 +++++-----
 drivers/net/ixgb/ixgb_main.c   |   10 +++++-----
 drivers/net/ixgbe/ixgbe_main.c |   10 +++++-----
 6 files changed, 30 insertions(+), 30 deletions(-)

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
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 78963a0..2b08fdd 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3627,14 +3627,14 @@ dma_error:
 	buffer_info->length = 0;
 	buffer_info->next_to_watch = 0;
 	buffer_info->mapped_as_page = false;
-	count--;
+	if (count)
+		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
-	while (count >= 0) {
-		count--;
-		i--;
-		if (i < 0)
+	while (count--) {
+		if (i == 0)
 			i += tx_ring->count;
+		i--;
 		buffer_info = &tx_ring->buffer_info[i];
 		igb_unmap_and_free_tx_resource(tx_ring, buffer_info);
 	}
diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
index e9dd95f..2eb95fe 100644
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -2163,14 +2163,14 @@ dma_error:
 	buffer_info->length = 0;
 	buffer_info->next_to_watch = 0;
 	buffer_info->mapped_as_page = false;
-	count--;
+	if (count)
+		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
-	while (count >= 0) {
-		count--;
-		i--;
-		if (i < 0)
+	while (count--) {
+		if (i == 0)
 			i += tx_ring->count;
+		i--;
 		buffer_info = &tx_ring->buffer_info[i];
 		igbvf_put_txbuf(adapter, buffer_info);
 	}
diff --git a/drivers/net/ixgb/ixgb_main.c b/drivers/net/ixgb/ixgb_main.c
index bcd0f01..fffd254 100644
--- a/drivers/net/ixgb/ixgb_main.c
+++ b/drivers/net/ixgb/ixgb_main.c
@@ -1363,13 +1363,13 @@ ixgb_tx_map(struct ixgb_adapter *adapter, struct sk_buff *skb,
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
 		ixgb_unmap_and_free_tx_resource(adapter, buffer_info);
 	}
diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 35ea8c9..60b3551 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -5143,14 +5143,14 @@ dma_error:
 	tx_buffer_info->dma = 0;
 	tx_buffer_info->time_stamp = 0;
 	tx_buffer_info->next_to_watch = 0;
-	count--;
+	if (count)
+		count--;
 
 	/* clear timestamp and dma mappings for remaining portion of packet */
-	while (count >= 0) {
-		count--;
-		i--;
-		if (i < 0)
+	while (count--) {
+		if (i == 0)
 			i += tx_ring->count;
+		i--;
 		tx_buffer_info = &tx_ring->tx_buffer_info[i];
 		ixgbe_unmap_and_free_tx_resource(adapter, tx_buffer_info);
 	}
