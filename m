Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZFPI5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZFPI5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZFPI4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:56:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54259 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbZFPI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:56:37 -0400
X-SpamScore: -7
X-BigFish: VPS-7(z6c9Rzzz1202hzzz32i17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KLBQ5X-03-9VS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] amd-iommu: resume cleanup
Date: Tue, 16 Jun 2009 10:56:15 +0200
Message-ID: <1245142575-7166-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
References: <1245142575-7166-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:56:17.0850 (UTC) FILETIME=[4FB801A0:01C9EE60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Now that enable_iommus() will call iommu_disable() for each iommu,
the call to disable_iommus() during resume is redundant.  Also, the order
for an invalidation is to invalidate device table entries first, then
domain translations.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 068a356..10b2acc 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1079,12 +1079,6 @@ static void disable_iommus(void)
 
 static int amd_iommu_resume(struct sys_device *dev)
 {
-	/*
-	 * Disable IOMMUs before reprogramming the hardware registers.
-	 * IOMMU is still enabled from the resume kernel.
-	 */
-	disable_iommus();
-
 	/* re-load the hardware */
 	enable_iommus();
 
@@ -1092,8 +1086,8 @@ static int amd_iommu_resume(struct sys_device *dev)
 	 * we have to flush after the IOMMUs are enabled because a
 	 * disabled IOMMU will never execute the commands we send
 	 */
-	amd_iommu_flush_all_domains();
 	amd_iommu_flush_all_devices();
+	amd_iommu_flush_all_domains();
 
 	return 0;
 }
-- 
1.6.3.1


