Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbZJIIhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbZJIIhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbZJIIhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:37:18 -0400
Received: from mail-yw0-f182.google.com ([209.85.211.182]:35230 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbZJIIhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=StAxfXqaE8F2E3W3TZlma2LMot4cA4PVED/OSUnDZsMN9Se8+BcImu6BTYkK6EmarU
         RnSNspueDxQ4gu8g0ZRo/FwqzpzSKKksEymxqJyfhWlDdQ94/BPhRuQixbHsAZWqDR71
         EAUxCdw6XM5bK3LYUqpIEw7RKL8VinWeFB7VI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Lothar Wassmann <LW@KARO-electronics.de>, linux-usb@vger.kernel.org
Subject: [PATCH 4/8] isp1362-hcd: Use bitmap_find_next_zero_area
Date: Fri,  9 Oct 2009 17:29:17 +0900
Message-Id: <1255076961-21325-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1255076961-21325-3-git-send-email-akinobu.mita@gmail.com>
References: <>
 <1255076961-21325-1-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-2-git-send-email-akinobu.mita@gmail.com>
 <1255076961-21325-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lothar Wassmann <LW@KARO-electronics.de>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/usb/host/isp1362-hcd.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index e35d828..f9221fe 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -80,7 +80,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/io.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 
 #include <asm/irq.h>
 #include <asm/system.h>
@@ -190,10 +190,8 @@ static int claim_ptd_buffers(struct isp1362_ep_queue *epq,
 			     struct isp1362_ep *ep, u16 len)
 {
 	int ptd_offset = -EINVAL;
-	int index;
 	int num_ptds = ((len + PTD_HEADER_SIZE - 1) / epq->blk_size) + 1;
-	int found = -1;
-	int last = -1;
+	int found;
 
 	BUG_ON(len > epq->buf_size);
 
@@ -205,20 +203,9 @@ static int claim_ptd_buffers(struct isp1362_ep_queue *epq,
 		    epq->name, len, epq->blk_size, num_ptds, epq->buf_map, epq->skip_map);
 	BUG_ON(ep->num_ptds != 0);
 
-	for (index = 0; index <= epq->buf_count - num_ptds; index++) {
-		if (test_bit(index, &epq->buf_map))
-			continue;
-		found = index;
-		for (last = index + 1; last < index + num_ptds; last++) {
-			if (test_bit(last, &epq->buf_map)) {
-				found = -1;
-				break;
-			}
-		}
-		if (found >= 0)
-			break;
-	}
-	if (found < 0)
+	found = bitmap_find_next_zero_area(&epq->buf_map, epq->buf_count, 0,
+						num_ptds, 0);
+	if (found >= epq->buf_count)
 		return -EOVERFLOW;
 
 	DBG(1, "%s: Found %d PTDs[%d] for %d/%d byte\n", __func__,
@@ -230,8 +217,7 @@ static int claim_ptd_buffers(struct isp1362_ep_queue *epq,
 	epq->buf_avail -= num_ptds;
 	BUG_ON(epq->buf_avail > epq->buf_count);
 	ep->ptd_index = found;
-	for (index = found; index < last; index++)
-		__set_bit(index, &epq->buf_map);
+	bitmap_set(&epq->buf_map, found, num_ptds);
 	DBG(1, "%s: Done %s PTD[%d] $%04x, avail %d count %d claimed %d %08lx:%08lx\n",
 	    __func__, epq->name, ep->ptd_index, ep->ptd_offset,
 	    epq->buf_avail, epq->buf_count, num_ptds, epq->buf_map, epq->skip_map);
-- 
1.5.4.3

