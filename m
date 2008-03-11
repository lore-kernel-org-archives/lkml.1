Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYCKA4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYCKA4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYCKAzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:55:31 -0400
Received: from mx1.suse.de ([195.135.220.2]:60147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbYCKAza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:55:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/4] drivers: fix dma_get_required_mask
Date: Mon, 10 Mar 2008 17:55:14 -0700
Message-Id: <1205196914-17965-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004219.GA17890@suse.de>
References: <20080311004219.GA17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

There's a bug in the current implementation of dma_get_required_mask()
where it ands the returned mask with the current device mask.  This
rather defeats the purpose if you're using the call to determine what
your mask should be (since you will at that time have the default
DMA_32BIT_MASK).  This bug results in any driver that uses this function
*always* getting a 32 bit mask, which is wrong.

Fix by removing the and with dev->dma_mask.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.5.4.3

