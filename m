Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZGBSLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZGBSLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZGBSLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:11:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:50902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbZGBSLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:11:31 -0400
Message-ID: <4A4CF830.6000206@kernel.org>
Date: Thu, 02 Jul 2009 11:10:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, alex.shi@intel.com,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] x86: add boundary check for 32bit res before expand e820
 resource to alignment -v2
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain> <4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com> <4A4A6888.30001@kernel.org> <4A4A6B1C.7030405@zytor.com> <4A4A701F.3050700@kernel.org> <4A4A81C9.9070008@zytor.com> <4A4A88A2.7010509@kernel.org> <alpine.LFD.2.01.0906301456170.3605@localhost.localdomain> <4A4A921F.7080100@kernel.org> <alpine.LFD.2.01.0906301559390.3605@localhost.localdomain> <alpine.LFD.2.01.0906301603280.3605@localhost.localdomain> <4A4A9C2F.80808@kernel.org> <4A4A9D8E.5080500@zytor.com> <4A4BB9C2.8020304@kernel.org>
In-Reply-To: <4A4BB9C2.8020304@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix hang with HIGHMEM_64G and 32bit resource.
according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.
analyized by hpa

Alex found:
for i386 machine the specjbb2005 still can not run with hugepage

-v2: it also fix hugepage problem

Reported-and-tested-by: Mikael Pettersson <mikpe@it.uu.se>
Reported-and-Tested-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/proto.h |    3 ---
 arch/x86/kernel/e820.c       |   20 ++++++++++++--------
 include/linux/kernel.h       |    5 +++++
 3 files changed, 17 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1367,9 +1367,9 @@ void __init e820_reserve_resources(void)
 }
 
 /* How much should we pad RAM ending depending on where it is? */
-static unsigned long ram_alignment(resource_size_t pos)
+static u64 ram_alignment(u64 pos)
 {
-	unsigned long mb = pos >> 20;
+	u64 mb = pos >> 20;
 
 	/* To 64kB in the first megabyte */
 	if (!mb)
@@ -1383,6 +1383,8 @@ static unsigned long ram_alignment(resou
 	return 32*1024*1024;
 }
 
+#define MAX_RESOURCE_SIZE ((resource_size_t)-1)
+
 void __init e820_reserve_resources_late(void)
 {
 	int i;
@@ -1400,17 +1402,19 @@ void __init e820_reserve_resources_late(
 	 * avoid stolen RAM:
 	 */
 	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *entry = &e820_saved.map[i];
-		resource_size_t start, end;
+		struct e820entry *entry = &e820.map[i];
+		u64 start, end;
 
 		if (entry->type != E820_RAM)
 			continue;
 		start = entry->addr + entry->size;
-		end = round_up(start, ram_alignment(start));
-		if (start == end)
+		end = round_up(start, ram_alignment(start)) - 1;
+		if (end > MAX_RESOURCE_SIZE)
+			end = MAX_RESOURCE_SIZE;
+		if (start > end)
 			continue;
-		reserve_region_with_split(&iomem_resource, start,
-						  end - 1, "RAM buffer");
+		reserve_region_with_split(&iomem_resource, start, end,
+					  "RAM buffer");
 	}
 }
 
