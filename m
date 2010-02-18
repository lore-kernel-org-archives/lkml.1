Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab0BRQo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:44:26 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:49977 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab0BRQoY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 11:44:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/10] swiotlb: fix: Update 'setup_io_tlb_npages' to accept both arguments in either order.
Date: Thu, 18 Feb 2010 11:26:57 -0500
Message-Id: <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B7D6E32.0044:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch, if you specified 'swiotlb=force,1024' it would
ignore both arguments. This fixes it and allows the user specify it
in any order (or none at all).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 437eedb..e6d9e32 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -102,16 +102,18 @@ static int late_alloc;
 static int __init
 setup_io_tlb_npages(char *str)
 {
-	if (isdigit(*str)) {
-		io_tlb_nslabs = simple_strtoul(str, &str, 0);
-		/* avoid tail segment of size < IO_TLB_SEGSIZE */
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	while (*str) {
+		if (isdigit(*str)) {
+			io_tlb_nslabs = simple_strtoul(str, &str, 0);
+			/* avoid tail segment of size < IO_TLB_SEGSIZE */
+			io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+		}
+		if (!strncmp(str, "force", 5))
+			swiotlb_force = 1;
+		str += strcspn(str, ",");
+		if (*str == ',')
+			++str;
 	}
-	if (*str == ',')
-		++str;
-	if (!strcmp(str, "force"))
-		swiotlb_force = 1;
-
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
-- 
1.6.2.5

