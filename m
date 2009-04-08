Return-Path: <linux-kernel-owner+w=401wt.eu-S934084AbZDHP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbZDHP22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbZDHP03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:26:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:52421 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933565AbZDHP00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:26:26 -0400
Date: Wed, 8 Apr 2009 15:25:06 GMT
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       galak@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
Subject: [tip:core/iommu] swiotlb: allow arch override of address_needs_mapping
Message-ID: <tip-ef5722f698bde01cfec2b98fff733a48663ebf55@git.kernel.org>
Git-Commit-ID: ef5722f698bde01cfec2b98fff733a48663ebf55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:25:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef5722f698bde01cfec2b98fff733a48663ebf55
Gitweb:     http://git.kernel.org/tip/ef5722f698bde01cfec2b98fff733a48663ebf55
Author:     Becky Bruce <beckyb@kernel.crashing.org>
AuthorDate: Wed, 8 Apr 2009 09:09:18 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 16:18:36 +0200

swiotlb: allow arch override of address_needs_mapping

Some architectures require additional checking to determine
if a device can dma to an address and need to provide their
own address_needs_mapping..

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: jeremy@goop.org
Cc: ian.campbell@citrix.com
LKML-Reference: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/swiotlb.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e8a47c8..d81afab 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -145,6 +145,12 @@ static void *swiotlb_bus_to_virt(dma_addr_t address)
 	return phys_to_virt(swiotlb_bus_to_phys(address));
 }
 
+int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
+					       dma_addr_t addr, size_t size)
+{
+	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+}
+
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
 {
 	return 0;
@@ -309,10 +315,10 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static int
+static inline int
 address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
 }
 
 static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
