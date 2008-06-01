Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYFAF5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYFAF5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 01:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYFAF5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 01:57:02 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:9694 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYFAF5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 01:57:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EJrT05fqQFzi0f+djGxeqQricL/ezarVDcfUgg56karPTONZ3CJ8FocWfavAgoc5kqWK98eLr6Zphawkx0YxFj9YskpAQLeuNg69nliO3zB58cz80w6MvuwvypeGTjb7VrV75k+z8IoMLb3Prht0vwkn7qaNBmNMBz5Xt42MbS8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: 32bit numa increase max_elements to 1024
Date: Sat, 31 May 2008 22:51:51 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805251000.10205.yhlu.kernel@gmail.com> <200805291625.56942.yhlu.kernel@gmail.com>
In-Reply-To: <200805291625.56942.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805312251.52297.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so every element will repsent to 64M instead of 256M.

AMD opteron later based could have HW memory hole remapping. so could have
[0, 8g + 64M) on node0. reduce element size to 64M could keep that on node 0

later need to use find_e820_area to allocate memory_node_map like 64bit.
but need to move memory_present out of populate_mem_map...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 0c1a1bf..0ea4854 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -59,14 +59,14 @@ unsigned long node_end_pfn[MAX_NUMNODES] __read_mostly;
 /*
  * 4) physnode_map     - the mapping between a pfn and owning node
  * physnode_map keeps track of the physical memory layout of a generic
- * numa node on a 256Mb break (each element of the array will
- * represent 256Mb of memory and will be marked by the node id.  so,
+ * numa node on a 64Mb break (each element of the array will
+ * represent 64Mb of memory and will be marked by the node id.  so,
  * if the first gig is on node 0, and the second gig is on node 1
  * physnode_map will contain:
  *
- *     physnode_map[0-3] = 0;
- *     physnode_map[4-7] = 1;
- *     physnode_map[8- ] = -1;
+ *     physnode_map[0-15] = 0;
+ *     physnode_map[16-31] = 1;
+ *     physnode_map[32- ] = -1;
  */
 s8 physnode_map[MAX_ELEMENTS] __read_mostly = { [0 ... (MAX_ELEMENTS - 1)] = -1};
 EXPORT_SYMBOL(physnode_map);
@@ -81,9 +81,9 @@ void memory_present(int nid, unsigned long start, unsigned long end)
 	printk(KERN_DEBUG "  ");
 	for (pfn = start; pfn < end; pfn += PAGES_PER_ELEMENT) {
 		physnode_map[pfn / PAGES_PER_ELEMENT] = nid;
-		printk("%ld ", pfn);
+		printk(KERN_CONT "%ld ", pfn);
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
diff --git a/include/asm-x86/mmzone_32.h b/include/asm-x86/mmzone_32.h
index faef751..ab00128 100644
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -51,14 +51,14 @@ extern int early_pfn_to_nid(unsigned long pfn);
 /*
  * generic node memory support, the following assumptions apply:
  *
- * 1) memory comes in 256Mb contigious chunks which are either present or not
+ * 1) memory comes in 64Mb contigious chunks which are either present or not
  * 2) we will not have more than 64Gb in total
  *
  * for now assume that 64Gb is max amount of RAM for whole system
  *    64Gb / 4096bytes/page = 16777216 pages
  */
 #define MAX_NR_PAGES 16777216
-#define MAX_ELEMENTS 256
+#define MAX_ELEMENTS 1024
 #define PAGES_PER_ELEMENT (MAX_NR_PAGES/MAX_ELEMENTS)
 
 extern s8 physnode_map[];
