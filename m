Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZLNJtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZLNJtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZLNJtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:49:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:48369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZLNJti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:49:38 -0500
Date: Mon, 14 Dec 2009 09:49:01 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1260759135-6450-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1260759135-6450-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Gart: fix breakage due to IOMMU initialization cleanup
Message-ID: <tip-f3eee54276dfd1117fd94259f2b4a38388264724@git.kernel.org>
Git-Commit-ID: f3eee54276dfd1117fd94259f2b4a38388264724
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3eee54276dfd1117fd94259f2b4a38388264724
Gitweb:     http://git.kernel.org/tip/f3eee54276dfd1117fd94259f2b4a38388264724
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 14 Dec 2009 11:52:15 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 08:57:40 +0100

x86: Gart: fix breakage due to IOMMU initialization cleanup

This fixes the following breakage of the commit
75f1cdf1dda92cae037ec848ae63690d91913eac:

- GART systems that don't AGP with broken BIOS and more than 4GB
  memory are forced to use swiotlb. They can allocate aperture by
  hand and use GART.

- GART systems without GAP must disable GART on shutdown.

- swiotlb usage is forced by the boot option,
  gart_iommu_hole_init() is not called, so we disable GART
  early_gart_iommu_check().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
LKML-Reference: <1260759135-6450-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/aperture_64.c |   11 ++++++-----
 arch/x86/kernel/pci-gart_64.c |    3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index e0dfb68..3704997 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -280,7 +280,8 @@ void __init early_gart_iommu_check(void)
 	 * or BIOS forget to put that in reserved.
 	 * try to update e820 to make that region as reserved.
 	 */
-	int i, fix, slot;
+	u32 agp_aper_base = 0, agp_aper_order = 0;
+	int i, fix, slot, valid_agp = 0;
 	u32 ctl;
 	u32 aper_size = 0, aper_order = 0, last_aper_order = 0;
 	u64 aper_base = 0, last_aper_base = 0;
@@ -290,6 +291,8 @@ void __init early_gart_iommu_check(void)
 		return;
 
 	/* This is mostly duplicate of iommu_hole_init */
+	agp_aper_base = search_agp_bridge(&agp_aper_order, &valid_agp);
+
 	fix = 0;
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
@@ -342,10 +345,10 @@ void __init early_gart_iommu_check(void)
 		}
 	}
 
-	if (!fix)
+	if (valid_agp)
 		return;
 
-	/* different nodes have different setting, disable them all at first*/
+	/* disable them all at first */
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
 		int dev_base, dev_limit;
@@ -458,8 +461,6 @@ out:
 
 	if (aper_alloc) {
 		/* Got the aperture from the AGP bridge */
-	} else if (!valid_agp) {
-		/* Do nothing */
 	} else if ((!no_iommu && max_pfn > MAX_DMA32_PFN) ||
 		   force_iommu ||
 		   valid_agp ||
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index e6a0d40..56c0e73 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -710,7 +710,8 @@ static void gart_iommu_shutdown(void)
 	struct pci_dev *dev;
 	int i;
 
-	if (no_agp)
+	/* don't shutdown it if there is AGP installed */
+	if (!no_agp)
 		return;
 
 	for (i = 0; i < num_k8_northbridges; i++) {
