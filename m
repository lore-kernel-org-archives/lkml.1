Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYJXLIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYJXLIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYJXLId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:08:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYJXLIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:08:32 -0400
Date: Fri, 24 Oct 2008 13:08:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, tony.luck@intel.com
Subject: Re: [GIT *] iommu fixes for 2.6.28
Message-ID: <20081024110815.GA3933@elte.hu>
References: <1224616464.16910.103.camel@macbook.infradead.org> <20081024110125.GA18869@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024110125.GA18869@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> hm, i just updated to v2.6.28-rc1, and these changes broke the x86 
> 32-bit build:
> 
>   arch/x86/kernel/built-in.o: In function `dma_supported':
>   (.text+0x5797): undefined reference to `forbid_dac'
>   arch/x86/kernel/built-in.o: In function `iommu_setup':
>   pci-dma.c:(.init.text+0x326c): undefined reference to `forbid_dac'

i've applied the fix below to tip/x86/urgent.

	Ingo

------------->
>From 20c00ed26a47619647458effc795041d5101ebd9 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 24 Oct 2008 13:12:10 +0200
Subject: [PATCH] iommu, x86: fix build failure

this iommu patch:

  5b6985c: intel-iommu: IA64 support

broke the !CONFIG_PCI build on x86:

  arch/x86/kernel/built-in.o: In function `dma_supported':
  (.text+0x5797): undefined reference to `forbid_dac'
  arch/x86/kernel/built-in.o: In function `iommu_setup':
  pci-dma.c:(.init.text+0x326c): undefined reference to `forbid_dac'
  pci-dma.c:(.init.text+0x328b): undefined reference to `forbid_dac'
  pci-dma.c:(.init.text+0x32aa): undefined reference to `forbid_dac'

because the forbid_dac variable is only available on CONFIG_PCI,
while the x86 DMA code is built-in.

Fix it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-dma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1972266..47c5a7a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -202,6 +202,7 @@ static __init int iommu_setup(char *p)
 			iommu_merge = 0;
 		if (!strncmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
+#ifdef CONFIG_PCI
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
@@ -210,6 +211,7 @@ static __init int iommu_setup(char *p)
 			forbid_dac = -1;
 			return 1;
 		}
+#endif
 #ifdef CONFIG_SWIOTLB
 		if (!strncmp(p, "soft", 4))
 			swiotlb = 1;
