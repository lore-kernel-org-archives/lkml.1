Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbYIQRAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbYIQRAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYIQQxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:12229 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbYIQQx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:29 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K7CMWD-03-U9G-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/23] AMD IOMMU: free domain bitmap with its allocation order
Date: Wed, 17 Sep 2008 18:52:53 +0200
Message-ID: <1221670377-19295-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0189 (UTC) FILETIME=[D67D67D0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amd_iommu_pd_alloc_bitmap is allocated with a calculated order and
freed with order 1. This is not a bug since the calculated order always
evaluates to 1, but its unclean code. So replace the 1 with the
calculation in the release path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index d8c1a45..a307cf6 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1145,7 +1145,8 @@ out:
 	return ret;
 
 free:
-	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap, 1);
+	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
+		   get_order(MAX_DOMAIN_ID/8));
 
 	free_pages((unsigned long)amd_iommu_pd_table,
 		   get_order(rlookup_table_size));
-- 
1.5.6.4


