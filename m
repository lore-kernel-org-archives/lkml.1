Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZK0Nzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZK0Nzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZK0Nzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:55:53 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45948 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZK0Nzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:52 -0500
X-SpamScore: -14
X-BigFish: VPS-14(z21eWzzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD0-01-6RI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] IOMMU updates for 2.6.33
Date: Fri, 27 Nov 2009 14:55:11 +0100
Message-ID: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
X-OriginalArrivalTime: 27 Nov 2009 13:55:47.0748 (UTC) FILETIME=[525BD640:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,


The following changes since commit 273bee27fa9f79d94b78c83506016f2e41e78983:
  FUJITA Tomonori (1):
        x86: Fix iommu=soft boot option

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.33

Joerg Roedel (35):
      x86/amd-iommu: Separate internal interface definitions
      x86/amd-iommu: Update copyright headers
      x86/amd-iommu: Add an index field to struct amd_iommu
      x86/amd-iommu: Add per IOMMU reference counting
      x86/amd-iommu: Add function to complete a tlb flush
      x86/amd-iommu: Make iommu_flush_pages aware of multiple IOMMUs
      x86/amd-iommu: Use __iommu_flush_pages for tlb flushes
      x86/amd-iommu: Remove iommu_flush_domain function
      x86/amd-iommu: Implement protection domain list
      x86/amd-iommu: Reimplement amd_iommu_flush_all_domains()
      x86/amd-iommu: Reimplement flush_all_domains_on_iommu()
      x86/amd-iommu: Make np-cache a global flag
      x86/amd-iommu: Use check_device for amd_iommu_dma_supported
      x86/amd-iommu: Use check_device in get_device_resources
      x86/amd-iommu: Remove iommu parameter from dma_ops_domain_(un)map
      x86/amd-iommu: Make alloc_new_range aware of multiple IOMMUs
      x86/amd-iommu: Remove iommu parameter from __(un)map_single
      x86/amd-iommu: Remove iommu specific handling from dma_ops path
      x86/amd-iommu: Let domain_for_device handle aliases
      x86/amd-iommu: Simplify get_device_resources()
      x86/amd-iommu: Move find_protection_domain to helper functions
      x86/amd-iommu: Use get_device_id and check_device where appropriate
      x86/amd-iommu: Remove iommu parameter from dma_ops_domain_alloc
      x86/amd-iommu: Move some pte allocation functions in the right section
      x86/amd-iommu: Rearrange dma_ops related functions
      x86/amd-iommu: Remove support for domain sharing
      x86/amd-iommu: Use dev->arch->iommu to store iommu related information
      x86/amd-iommu: Add device bind reference counting
      x86/amd-iommu: Keep devices per domain in a list
      x86/amd-iommu: Cleanup attach/detach_device code
      x86/amd-iommu: Introduce iommu_flush_device() function
      x86/amd-iommu: Cleanup DTE flushing code
      x86/amd-iommu: Move reset_iommu_command_buffer out of locked code
      x86/amd-iommu: Remove amd_iommu_pd_table
      Merge branch 'gart/fixes' into amd-iommu/2.6.33

Pavel Vasilyev (1):
      agp/amd64: Remove GART dependency on AGP_AMD64

 arch/x86/include/asm/amd_iommu.h       |   12 +-
 arch/x86/include/asm/amd_iommu_proto.h |   38 +
 arch/x86/include/asm/amd_iommu_types.h |   54 ++-
 arch/x86/include/asm/device.h          |    2 +-
 arch/x86/kernel/amd_iommu.c            | 1230 +++++++++++++++++---------------
 arch/x86/kernel/amd_iommu_init.c       |   67 +-
 drivers/char/agp/Kconfig               |    3 +-
 7 files changed, 777 insertions(+), 629 deletions(-)
 create mode 100644 arch/x86/include/asm/amd_iommu_proto.h

Most of the changes are for AMD IOMMU driver. The changes there are bigger than
usual because I did a lot of changes to the data structures storing the
relations between devices, protection domains and iommus. A major change is
that the amd_iommu_pd_table is now gone and replaced by a struct iommu_dev_data
for each device stored in dev->archdata->iommu.
These changes result in a more robust reference counting, especially for
devices with an alias and simplified code in many places.
Also included are some related cleanups which separated the internal function
prototypes to a several header and code movement to get rid of most function
forward declarations. Please pull.

	Joerg


