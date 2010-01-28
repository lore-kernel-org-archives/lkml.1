Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858Ab0A1Ljf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0A1Ljf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 06:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762Ab0A1LjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 06:39:22 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9501 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab0A1Lij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 06:38:39 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i6bh87h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWYGBW-01-FXO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/11] Large Page Support for IOMMU-API and KVM
Date: Thu, 28 Jan 2010 12:37:51 +0100
Message-ID: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 28 Jan 2010 11:38:20.0680 (UTC) FILETIME=[6455A080:01CAA00E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch set which implements support for variable page sizes in the
IOMMU-API and changes the KVM device passthrough code to map the guest physical
memory with the best page sizes.

With this code a guest with 1GB of memory mapped with a 1GB page will not use
4kb PTEs in the IO page table but will map this memory with these page sizes:

512k, 128k, <io hole>, 1M, 2M, 4M, 8M, 16M, 32M, 64M, 128M, 256M and 512M

instead.

This code also changes the AMD IOMMU driver to implement these page sizes in
the IO page tables.
Please review these patches and send me any comments you might have :-)

To test this code some fixes in the AMD IOMMU driver are required which are
currently in the -tip tree and will probably hit upstream soon. If anybody want
to test this code please pull the code from 

git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/largepages

This branch is based on avi/master and contains the fixes and the patches from
this patchset.

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_types.h |   34 ++++++
 arch/x86/kernel/amd_iommu.c            |  195 ++++++++++++++++++++------------
 arch/x86/kvm/mmu.c                     |   18 +---
 drivers/base/iommu.c                   |   43 +++++---
 drivers/pci/intel-iommu.c              |   22 ++--
 include/linux/iommu.h                  |   24 ++--
 include/linux/kvm_host.h               |    1 +
 virt/kvm/iommu.c                       |  106 ++++++++++++++----
 virt/kvm/kvm_main.c                    |   25 ++++
 9 files changed, 323 insertions(+), 145 deletions(-)

Shortlog:

Joerg Roedel (11):
      iommu-api: Rename ->{un}map function pointers to ->{un}map_range
      iommu-api: Add iommu_map and iommu_unmap functions
      iommu-api: Add ->{un}map callbacks to iommu_ops
      VT-d: Change {un}map_range functions to implement {un}map interface
      kvm: Introduce kvm_host_page_size
      kvm: Change kvm_iommu_map_pages to map large pages
      x86/amd-iommu: Make iommu_map_page and alloc_pte aware of page sizes
      x86/amd-iommu: Make iommu_unmap_page and fetch_pte aware of page sizes
      x86/amd-iommu: Make amd_iommu_iova_to_phys aware of multiple page sizes
      x86/amd-iommu: Implement ->{un}map callbacks for iommu-api
      iommu-api: Remove iommu_{un}map_range functions



