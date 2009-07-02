Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZGBCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZGBCPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZGBCPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:15:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:50748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZGBCPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:15:34 -0400
Message-ID: <4A4C17FD.3080404@kernel.org>
Date: Wed, 01 Jul 2009 19:14:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: alex.shi@intel.com, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage unusable
 on non-NUMA machine
References: <bug-13690-10286@http.bugzilla.kernel.org/> <20090701183452.8660c8a9.akpm@linux-foundation.org>
In-Reply-To: <20090701183452.8660c8a9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that looks strange...

config is 32bit. 

the second patch only do save and restore. and should be right right.

please check following patch on today's linus tree. and send out /proc/iomem

Thanks

Yinghai

[PATCH] x86: add boundary check for 32bit res before expand e820 resource to alignment

fix hang with HIGHMEM_64G and 32bit resource.
according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.

analyized by hpa

Reported-and-tested-by: Mikael Pettersson <mikpe@it.uu.se>
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
 
