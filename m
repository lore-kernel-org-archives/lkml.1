Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0BRQyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:54:22 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:52470 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab0BRQyU (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 11:54:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/10] swiotlb: Make 'setup_io_tlb_npages' accept new 'swiotlb=' syntax.
Date: Thu, 18 Feb 2010 11:26:58 -0500
Message-Id: <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B7D6E9D.0186:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old syntax for 'swiotlb' is still in effect, and we extend it
now to include the overflow buffer size. The syntax is now:

swiotlb=[force,][nslabs=<pages>,][overflow=<size>] or more
commonly know as:

swiotlb=[force]
swiotlb=[nslabs=<pages>]
swiotlb=[overflow=<size>]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/x86/x86_64/boot-options.txt |    6 ++++-
 lib/swiotlb.c                             |   36 +++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 29a6ff8..81f9b94 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -267,10 +267,14 @@ IOMMU (input/output memory management unit)
 
   iommu options only relevant to the software bounce buffering (SWIOTLB) IOMMU
   implementation:
-    swiotlb=<pages>[,force]
+    swiotlb=[npages=<pages>]
+    swiotlb=[force]
+    swiotlb=[overflow=<size>]
+
     <pages>            Prereserve that many 128K pages for the software IO
                        bounce buffering.
     force              Force all IO through the software TLB.
+    <size>             Size in bytes of the overflow buffer.
 
   Settings for the IBM Calgary hardware IOMMU currently found in IBM
   pSeries and xSeries machines:
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e6d9e32..0663879 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -102,7 +102,27 @@ static int late_alloc;
 static int __init
 setup_io_tlb_npages(char *str)
 {
+	int get_value(const char *token, char *str, char **endp)
+	{
+		ssize_t len;
+		int val = 0;
+
+		len = strlen(token);
+		if (!strncmp(str, token, len)) {
+			str += len;
+			if (*str == '=')
+				++str;
+			if (*str != '\0')
+				val = simple_strtoul(str, endp, 0);
+		}
+		*endp = str;
+		return val;
+	}
+
+	int val;
+
 	while (*str) {
+		/* The old syntax */
 		if (isdigit(*str)) {
 			io_tlb_nslabs = simple_strtoul(str, &str, 0);
 			/* avoid tail segment of size < IO_TLB_SEGSIZE */
@@ -110,14 +130,22 @@ setup_io_tlb_npages(char *str)
 		}
 		if (!strncmp(str, "force", 5))
 			swiotlb_force = 1;
-		str += strcspn(str, ",");
-		if (*str == ',')
-			++str;
+		/* The new syntax: swiotlb=nslabs=16384,overflow=32768,force */
+		val = get_value("nslabs", str, &str);
+		if (val)
+			io_tlb_nslabs = ALIGN(val, IO_TLB_SEGSIZE);
+
+		val = get_value("overflow", str, &str);
+		if (val)
+			io_tlb_overflow = val;
+		str = strpbrk(str, ",");
+		if (!str)
+			break;
+		str++; /* skip ',' */
 	}
 	return 1;
 }
 __setup("swiotlb=", setup_io_tlb_npages);
-/* make io_tlb_overflow tunable too? */
 
 /* Note that this doesn't work with highmem page */
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
-- 
1.6.2.5

