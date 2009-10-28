Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbZJ1G4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbZJ1G4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbZJ1GyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:54:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:54074 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457AbZJ1GyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:54:19 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/10] x86: handle HW IOMMU initialization failure gracely
Date: Wed, 28 Oct 2009 15:47:34 +0900
Message-Id: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Oct 2009 15:53:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If HW IOMMU initialization fails (Intel VT-d often does typically due
to BIOS bugs), we fall back to nommu. It doesn't work for the majority
since nowadays we have more than 4GB memory so we must use swiotlb
instead of nommu.

The problem is that it's too late to initialize swiotlb when HW IOMMU
initialization fails. We need to allocate swiotlb memory earlier from
bootmem allocator. Chris explained the issue in detail:

http://marc.info/?l=linux-kernel&m=125657444317079&w=2


The current x86 IOMMU initialization sequence is too complicated and
handling the above issue makes it more hacky.

This series changes x86 IOMMU initialization sequence to handle the
above issue cleanly.

The new x86 IOMMU initialization sequence are:

1. initializing swiotlb (and setting swiotlb to 1) in the case of
(max_pfn > MAX_DMA32_PFN && !no_iommu). dma_ops is set to
swiotlb_dma_ops or nommu_dma_ops.

2. calling the detection functions of all the IOMMUs

3. the detection function sets x86_init.iommu.iommu_init to the IOMMU
initialization function (so we can avoid calling the initialization
functions of all the IOMMUs needlessly).

4. if the IOMMU initialization function doesn't need to swiotlb then
sets swiotlb to zero (e.g. the initialization is sucessful).

5. if we find that swiotlb is set to zero, we free swiotlb resource.

=
 arch/ia64/kernel/pci-swiotlb.c   |    4 +-
 arch/powerpc/kernel/setup_32.c   |    2 +-
 arch/powerpc/kernel/setup_64.c   |    2 +-
 arch/x86/include/asm/amd_iommu.h |    2 -
 arch/x86/include/asm/calgary.h   |    2 -
 arch/x86/include/asm/gart.h      |    5 +--
 arch/x86/include/asm/iommu.h     |    2 +-
 arch/x86/include/asm/x86_init.h  |    9 ++++
 arch/x86/kernel/amd_iommu.c      |    2 +-
 arch/x86/kernel/amd_iommu_init.c |   19 ++------
 arch/x86/kernel/aperture_64.c    |    4 +-
 arch/x86/kernel/pci-calgary_64.c |   19 ++-----
 arch/x86/kernel/pci-dma.c        |   23 ++++-----
 arch/x86/kernel/pci-gart_64.c    |   16 ++----
 arch/x86/kernel/pci-nommu.c      |    9 ----
 arch/x86/kernel/pci-swiotlb.c    |    8 ++--
 arch/x86/kernel/x86_init.c       |    5 ++
 drivers/pci/dmar.c               |    7 ++-
 drivers/pci/intel-iommu.c        |    4 +-
 include/linux/bootmem.h          |    1 +
 include/linux/dmar.h             |   10 ----
 include/linux/swiotlb.h          |    5 +-
 lib/swiotlb.c                    |   45 +++++++++++++++---
 mm/bootmem.c                     |   98 +++++++++++++++++++++++++++++---------
 24 files changed, 177 insertions(+), 126 deletions(-)




