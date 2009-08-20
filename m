Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZHTTvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZHTTvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 15:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbZHTTvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 15:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZHTTvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 15:51:45 -0400
Message-ID: <4A8DA97C.9020406@redhat.com>
Date: Thu, 20 Aug 2009 15:52:28 -0400
From: Casey Dahlin <cdahlin@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       beckyb@kernel.crashing.org
Subject: [PATCH,resend] Fix strange panic message selection logic when swiotlb
 fills up
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_full in lib/swiotlb.c throws one of two panic messages based on whether
the direction of transfer is from the device or to the device. The logic around
this is somewhat weird in the case of bidirectional transfers. It appears to
want to throw both in succession, but since its a panic only the first makes it.

This patch adds a third, separate error for DMA_BIDIRECTIONAL to make things a
bit clearer.

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>

---
 lib/swiotlb.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

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
