Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYDLIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYDLIQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYDLIQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:16:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13642 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbYDLIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=l4zwqSXdxCPsx+uHqrdjsUn9JmA9NQ4T63eofeBIMfUxcodQ3KcLI6ybw8V4x9Zl2PqhRuFWxOLL8e/e5esMK8CjiP9Vyeeq3C+uf4TSLv3vfJWuwEaoWthfkERtngPfeFARYZhvhc8Ikx30vot8y+heT/jnPh+Fi8KVMIwbF1M=
Reply-To: yhlu.kernel@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH] x86_64/mm: check and print vmemmap allocation continuous
Date: Sat, 12 Apr 2008 01:19:24 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804120119.24868.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So for big system with a lot memory, don't print out too much, and easy found
out if it is continuous

on 256G 8 sockets system will get
 [ffffe20000000000-ffffe20002bfffff] PMD -> [ffff810001400000-ffff810003ffffff] on node 0
[ffffe2001c700000-ffffe2001c7fffff] potential offnode page_structs
 [ffffe20002c00000-ffffe2001c7fffff] PMD -> [ffff81000c000000-ffff8100255fffff] on node 0
[ffffe20038700000-ffffe200387fffff] potential offnode page_structs
 [ffffe2001c800000-ffffe200387fffff] PMD -> [ffff810820200000-ffff81083c1fffff] on node 1
 [ffffe20040000000-ffffe2007fffffff] PUD ->ffff811027a00000 on node 2
 [ffffe20038800000-ffffe2003fffffff] PMD -> [ffff811020200000-ffff8110279fffff] on node 2
[ffffe20054700000-ffffe200547fffff] potential offnode page_structs
 [ffffe20040000000-ffffe200547fffff] PMD -> [ffff811027c00000-ffff81103c3fffff] on node 2
[ffffe20070700000-ffffe200707fffff] potential offnode page_structs
 [ffffe20054800000-ffffe200707fffff] PMD -> [ffff811820200000-ffff81183c1fffff] on node 3
 [ffffe20080000000-ffffe200bfffffff] PUD ->ffff81202fa00000 on node 4
 [ffffe20070800000-ffffe2007fffffff] PMD -> [ffff812020200000-ffff81202f9fffff] on node 4
[ffffe2008c700000-ffffe2008c7fffff] potential offnode page_structs
 [ffffe20080000000-ffffe2008c7fffff] PMD -> [ffff81202fc00000-ffff81203c3fffff] on node 4
[ffffe200a8700000-ffffe200a87fffff] potential offnode page_structs
 [ffffe2008c800000-ffffe200a87fffff] PMD -> [ffff812820200000-ffff81283c1fffff] on node 5
 [ffffe200c0000000-ffffe200ffffffff] PUD ->ffff813037a00000 on node 6
 [ffffe200a8800000-ffffe200bfffffff] PMD -> [ffff813020200000-ffff8130379fffff] on node 6
[ffffe200c4700000-ffffe200c47fffff] potential offnode page_structs
 [ffffe200c0000000-ffffe200c47fffff] PMD -> [ffff813037c00000-ffff81303c3fffff] on node 6
 [ffffe200c4800000-ffffe200e07fffff] PMD -> [ffff813820200000-ffff81383c1fffff] on node 7

instead of a long print out...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -931,6 +931,10 @@ const char *arch_vma_name(struct vm_area
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
  */
+static long __meminitdata addr_start, addr_end;
+static void __meminitdata *p_start, *p_end;
+static int __meminitdata node_start;
+
 int __meminit
 vmemmap_populate(struct page *start_page, unsigned long size, int node)
 {
@@ -965,12 +969,32 @@ vmemmap_populate(struct page *start_page
 							PAGE_KERNEL_LARGE);
 			set_pmd(pmd, __pmd(pte_val(entry)));
 
-			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
-				addr, addr + PMD_SIZE - 1, p, node);
+			/* check if we got continous */
+			if (p_end != p || node_start != node) {
+				if (p_start)
+					printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+						addr_start, addr_end-1, p_start, p_end-1, node_start);
+				addr_start = addr;
+				node_start = node;
+				p_start = p;
+			}
+			addr_end = addr + PMD_SIZE;
+			p_end = p + PMD_SIZE;
 		} else {
 			vmemmap_verify((pte_t *)pmd, node, addr, next);
 		}
 	}
 	return 0;
 }
+
+void __meminit vmemmap_populate_print_last(void)
+{
+	if (p_start) {
+		printk(KERN_DEBUG " [%lx-%lx] PMD -> [%p-%p] on node %d\n",
+			addr_start, addr_end-1, p_start, p_end-1, node_start);
+		p_start = NULL;
+		p_end = NULL;
+		node_start = 0;
+	}
+}
 #endif
Index: linux-2.6/mm/sparse.c
===================================================================
--- linux-2.6.orig/mm/sparse.c
+++ linux-2.6/mm/sparse.c
@@ -285,6 +285,9 @@ struct page __init *sparse_early_mem_map
 	return NULL;
 }
 
+void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
+{
+}
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -337,6 +340,8 @@ void __init sparse_init(void)
 								usemap);
 	}
 
+	vmemmap_populate_print_last();
+
 	free_bootmem(__pa(usemap_map), size);
 }
 
