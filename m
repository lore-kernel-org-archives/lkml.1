Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZHULID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZHULID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZHULIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:08:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:45008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbZHULIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:08:00 -0400
Date: Fri, 21 Aug 2009 11:07:04 GMT
From: tip-bot for Casey Dahlin <cdahlin@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       cdahlin@redhat.com, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, tglx@linutronix.de,
       beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cdahlin@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <200908202327.n7KNRuqK001504@imap1.linux-foundation.org>
References: <200908202327.n7KNRuqK001504@imap1.linux-foundation.org>
Subject: [tip:core/iommu] lib/swiotlb.c: Fix strange panic message selection logic when swiotlb fills up
Message-ID: <tip-c7084b35eb1a4d3353a501508baf9d3d82822c93@git.kernel.org>
Git-Commit-ID: c7084b35eb1a4d3353a501508baf9d3d82822c93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 11:07:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7084b35eb1a4d3353a501508baf9d3d82822c93
Gitweb:     http://git.kernel.org/tip/c7084b35eb1a4d3353a501508baf9d3d82822c93
Author:     Casey Dahlin <cdahlin@redhat.com>
AuthorDate: Thu, 20 Aug 2009 16:27:56 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 Aug 2009 10:36:03 +0200

lib/swiotlb.c: Fix strange panic message selection logic when swiotlb fills up

swiotlb_full() in lib/swiotlb.c throws one of two panic messages
based on whether the direction of transfer is from the device
or to the device. The logic around this is somewhat weird in
the case of bidirectional transfers. It appears to want to
throw both in succession, but since its a panic only the first
makes it.

This patch adds a third, separate error for DMA_BIDIRECTIONAL
to make things a bit clearer.

Signed-off-by: Casey Dahlin <cdahlin@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
[ further fixed the error message ]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <200908202327.n7KNRuqK001504@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/swiotlb.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 9e2fe3e..ac25cd2 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -581,12 +581,15 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
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
+		panic("DMA: Random memory could be DMA accessed\n");
+	if (dir == DMA_FROM_DEVICE)
+		panic("DMA: Random memory could be DMA written\n");
+	if (dir == DMA_TO_DEVICE)
+		panic("DMA: Random memory could be DMA read\n");
 }
 
 /*
