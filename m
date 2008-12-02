Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYLBTQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYLBTQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYLBTQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:16:26 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38030 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLBTQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:16:25 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB9K6M-03-1NH-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: fix broken flushing in GART nofullflush path
Date: Tue, 2 Dec 2008 20:16:03 +0100
Message-ID: <1228245363-14909-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 02 Dec 2008 19:16:03.0256 (UTC) FILETIME=[6AFBAB80:01C954B2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the non-default nofullflush case the GART is only flushed when
next_bit wraps around. But it can happen that an unmap operation unmaps
memory which is behind the current next_bit location. If these addresses
are reused it may result in stale GART IO/TLB entries. Fix this by
setting the GART next_bit always behind an unmapped location.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a42b02b..ba7ad83 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -123,6 +123,8 @@ static void free_iommu(unsigned long offset, int size)
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	iommu_area_free(iommu_gart_bitmap, offset, size);
+	if (offset >= next_bit)
+		next_bit = offset + size;
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 }
 
-- 
1.5.6.4


