Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYCIQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYCIQ6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYCIQ6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 12:58:03 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34391 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYCIQ6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 12:58:01 -0400
Subject: [PATCH] drivers: fix dma_get_required_mask
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 11:57:56 -0500
Message-Id: <1205081877.3792.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a bug in the current implementation of dma_get_required_mask()
where it ands the returned mask with the current device mask.  This
rather defeats the purpose if you're using the call to determine what
your mask should be (since you will at that time have the default
DMA_32BIT_MASK).  This bug results in any driver that uses this function
*always* getting a 32 bit mask, which is wrong.

Fix by removing the and with dev->dma_mask.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

This is a pretty nasty bug which can cause mysterious slow downs and
panics on >4GB machines (we've just had one on an aic79xx production
system).

It probably also needs to be backported as far as it will go.

James

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index efaf282..911ec60 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -648,7 +648,7 @@ u64 dma_get_required_mask(struct device *dev)
 		high_totalram += high_totalram - 1;
 		mask = (((u64)high_totalram) << 32) + 0xffffffff;
 	}
-	return mask & *dev->dma_mask;
+	return mask;
 }
 EXPORT_SYMBOL_GPL(dma_get_required_mask);
 #endif


