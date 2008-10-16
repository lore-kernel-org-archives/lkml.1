Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYJPO21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYJPO21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJPO2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:28:19 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:9693 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYJPO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:28:18 -0400
X-BigFish: VPS26(z1857r4d4rz3117K8b9dnzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K8U5IN-01-4GN-01
Date: Thu, 16 Oct 2008 16:27:36 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: amd_iommu: fix nasty bug that caused
	ILLEGAL_DEVICE_TABLE_ENTRY errors
Message-ID: <20081016142736.GN4706@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Oct 2008 14:28:02.0141 (UTC) FILETIME=[653888D0:01C92F9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are on 64-bit so better use u64 instead of u32 to deal with
addresses:

static void __init iommu_set_device_table(struct amd_iommu *iommu)
{
        u64 entry;
  ...
        entry = virt_to_phys(amd_iommu_dev_table);
  ...

(I am wondering why gcc 4.2.x did not warn about the assignment
between u32 and unsigned long.)

Cc: iommu@lists.linux-foundation.org
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Patch is against today's tip/x86/amd-iommu
Joerg is on vacation. That is why I post this patch
directly to you.

Regards,

Andreas

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index a69cc0f..bccd0ef 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -210,7 +210,7 @@ static void __init iommu_set_exclusion_range(struct amd_iommu *iommu)
 /* Programs the physical address of the device table into the IOMMU hardware */
 static void __init iommu_set_device_table(struct amd_iommu *iommu)
 {
-	u32 entry;
+	u64 entry;
 
 	BUG_ON(iommu->mmio_base == NULL);
 
-- 
1.6.0.2



