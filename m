Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965Ab0AVRSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0AVRSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948Ab0AVRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:18:35 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54876 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab0AVRSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:18:33 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KWNS2F-02-7FD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
       stable@kernel.org
Subject: [PATCH 4/5] x86/amd-iommu: Fix deassignment of a device from the pt_domain
Date: Fri, 22 Jan 2010 18:18:12 +0100
Message-ID: <1264180693-27197-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
References: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 17:18:15.0766 (UTC) FILETIME=[E2464760:01CA9B86]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deassigning a device from the passthrough domain does not
work and breaks device assignment to kvm guests. This patch
fixes the issue.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 751ce73..adb0ba0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1511,9 +1511,11 @@ static void __detach_device(struct device *dev)
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
-	 * passthrough domain if it is detached from any other domain
+	 * passthrough domain if it is detached from any other domain.
+	 * Make sure we can deassign from the pt_domain itself.
 	 */
-	if (iommu_pass_through && dev_data->domain == NULL)
+	if (iommu_pass_through &&
+	    (dev_data->domain == NULL && domain != pt_domain))
 		__attach_device(dev, pt_domain);
 }
 
-- 
1.6.6


