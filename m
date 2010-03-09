Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0CIWMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:12:38 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:45247 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0CIWMd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 9 Mar 2010 17:12:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, alex.williamson@hp.com,
       dwmw2@infradead.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] swiotlb: fix: Update 'setup_io_tlb_npages' to accept both arguments in either order.
Date: Tue,  9 Mar 2010 16:54:19 -0500
Message-Id: <1268171662-12701-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268171662-12701-1-git-send-email-konrad.wilk@oracle.com>
References: <1268171662-12701-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B96C78C.0200:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch, if you specified 'swiotlb=force,1024' it would
ignore both arguments. This fixes it and allows the user specify it
in any order (or none at all).

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/x86/x86_64/boot-options.txt |    4 +++-
 lib/swiotlb.c                             |   20 +++++++++++---------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 7fbbaf8..7055341 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -261,7 +261,9 @@ IOMMU (input/output memory management unit)
 
   iommu options only relevant to the software bounce buffering (SWIOTLB) IOMMU
   implementation:
-    swiotlb=<pages>[,force]
+    swiotlb=[npages=<pages>]
+    swiotlb=[force]
+
     <pages>            Prereserve that many 128K pages for the software IO
                        bounce buffering.
     force              Force all IO through the software TLB.
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

