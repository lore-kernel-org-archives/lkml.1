Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZLNJty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZLNJty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZLNJtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:49:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:48373 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZLNJtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:49:39 -0500
Date: Mon, 14 Dec 2009 09:48:46 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Move swiotlb initialization before dma32_free_bootmem
Message-ID: <tip-f4780ca005404166cc40af77ef0e86132ab98a81@git.kernel.org>
Git-Commit-ID: f4780ca005404166cc40af77ef0e86132ab98a81
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4780ca005404166cc40af77ef0e86132ab98a81
Gitweb:     http://git.kernel.org/tip/f4780ca005404166cc40af77ef0e86132ab98a81
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Mon, 14 Dec 2009 11:52:14 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Dec 2009 08:57:40 +0100

x86: Move swiotlb initialization before dma32_free_bootmem

The commit 75f1cdf1dda92cae037ec848ae63690d91913eac introduced a
bug that we initialize SWIOTLB right after dma32_free_bootmem so
we wrongly steal memory area allocated for GART with broken BIOS
earlier.

This moves swiotlb initialization before dma32_free_bootmem().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org
LKML-Reference: <1260759135-6450-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index afcc58b..fcc2f2b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -120,11 +120,14 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	int use_swiotlb;
+
+	use_swiotlb = pci_swiotlb_init();
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (pci_swiotlb_init())
+	if (use_swiotlb)
 		return;
 
 	gart_iommu_hole_init();
