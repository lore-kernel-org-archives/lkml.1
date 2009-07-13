Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZGMTbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZGMTbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZGMTbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:31:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52679 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbZGMTbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:31:48 -0400
Message-ID: <4A5B8CAC.3060906@redhat.com>
Date: Mon, 13 Jul 2009 15:36:12 -0400
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix strange panic message selection logic when swiotlb fills
 up
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_full in lib/swiotlb.c contains the following code snippet to produce a panic when the software iotlb is too full to handle a new allocation:

	if (size > io_tlb_overflow && do_panic) {
		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
			panic("DMA: Memory would be corrupted\n");
		if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
			panic("DMA: Random memory would be DMAed\n");
	}

Note the path when dir == DMA_BIDIRECTIONAL. The first panic() will be called always, yet the second if statement still checks for DMA_BIDIRECTIONAL. Unless we intend to panic twice, this is somewhat confusing.

This patch adds a third, separate error for DMA_BIDIRECTIONAL to make things a bit clearer.

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index bffe6d7..35e01b3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -625,12 +625,15 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
 	       "device %s\n", size, dev ? dev_name(dev) : "?");
 
-	if (size > io_tlb_overflow && do_panic) {
-		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
-			panic("DMA: Memory would be corrupted\n");
-		if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-			panic("DMA: Random memory would be DMAed\n");
-	}
+	if (size <= io_tlb_overflow || !do_panic)
+		return;
+
+	if (dir == DMA_BIDIRECTIONAL)
+		panic("DMA: Random memory could be corrupted or DMAed\n");
+	if (dir == DMA_FROM_DEVICE)
+		panic("DMA: Memory would be corrupted\n");
+	if (dir == DMA_TO_DEVICE)
+		panic("DMA: Random memory would be DMAed\n");
 }
 
 /*
