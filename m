Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZCXHnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZCXHnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbZCXHnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:43:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:56058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbZCXHnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:43:07 -0400
Date: Tue, 24 Mar 2009 07:42:26 GMT
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237818908-26516-1-git-send-email-joerg.roedel@amd.com>
References: <1237818908-26516-1-git-send-email-joerg.roedel@amd.com>
Subject: [tip:core/iommu] dma-debug: make memory range checks more consistent
Message-ID: <tip-9537a48ed4b9e4b738943d6da0a0fd4278adf905@git.kernel.org>
Git-Commit-ID: 9537a48ed4b9e4b738943d6da0a0fd4278adf905
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Mar 2009 07:42:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9537a48ed4b9e4b738943d6da0a0fd4278adf905
Gitweb:     http://git.kernel.org/tip/9537a48ed4b9e4b738943d6da0a0fd4278adf905
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Mon, 23 Mar 2009 15:35:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Mar 2009 08:39:32 +0100

dma-debug: make memory range checks more consistent

Impact: extend on-kernel-stack DMA debug checks to all !highmem pages

We only checked dma_map_single() - extend it to dma_map_page()
and dma_map_sg() as well.

Also, fix dma_map_single() corner case bug: make sure we dont
stack-check highmem (not mapped) pages.

Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org
LKML-Reference: <1237818908-26516-1-git-send-email-joerg.roedel@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/dma-debug.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index f9e6d38..1a99208 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -722,10 +722,11 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 	entry->size      = size;
 	entry->direction = direction;
 
-	if (map_single) {
-		void *addr = ((char *)page_address(page)) + offset;
-
+	if (map_single)
 		entry->type = dma_debug_single;
+
+	if (!PageHighMem(page)) {
+		void *addr = ((char *)page_address(page)) + offset;
 		check_for_stack(dev, addr);
 		check_for_illegal_area(dev, addr, size);
 	}
@@ -779,8 +780,10 @@ void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 		entry->sg_call_ents   = nents;
 		entry->sg_mapped_ents = mapped_ents;
 
-		check_for_stack(dev, sg_virt(s));
-		check_for_illegal_area(dev, sg_virt(s), s->length);
+		if (!PageHighMem(sg_page(s))) {
+			check_for_stack(dev, sg_virt(s));
+			check_for_illegal_area(dev, sg_virt(s), s->length);
+		}
 
 		add_dma_entry(entry);
 	}
