Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbYLYHgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbYLYHgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 02:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLYHgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 02:36:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbYLYHgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 02:36:21 -0500
Date: Wed, 24 Dec 2008 23:35:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandru <chandru@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Message-Id: <20081224233536.b067c9da.akpm@linux-foundation.org>
In-Reply-To: <200812241325.49404.chandru@in.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Wed, 24 Dec 2008 13:25:49 +0530 Chandru <chandru@in.ibm.com> wrote:

> On a ppc machine booting linux-2.6.28-rc9 with crashkernel=256M@32M boot 
> parameter causes the kernel to panic while booting. __Following are the console 
> messages...

- Please put [patch] in the Subject: line of patches

- Please choose a suitable title, as per
  Documentation/SubmittingPatches, section 15.

- Please cc suitable mailing lists and maintainers on bug reports and
  on patches.



From: Chandru <chandru@in.ibm.com>

When booted with crashkernel=224M@32M or any memory size less than this,
the system boots properly.  The following was the observation..  The
system comes up with two nodes (0-256M and 256M-4GB).  _The crashkernel
memory reservation spans across these two nodes.  _The
mark_reserved_regions_for_nid() in arch/powerpc/mm/numa.c resizes the
reserved part of the memory within it as:

_ _ _ _ _ _ if (end_pfn > node_ar.end_pfn)
_ _ _ _ _ _ _ _ reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
_ _ _ _ _ _ _ _ _ _ - (start_pfn << PAGE_SHIFT);


but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of end 

_ _ end = PFN_UP(physaddr + size);

This causes end to get a value past the last page in the 0-256M node. 
_Again when reserve_bootmem_node() returns,
_mark_reserved_regions_for_nid() loops around to set the rest of the
crashkernel memory in the next node as reserved.  _ It references
NODE_DATA(node_ar.nid) and this causes another 'Oops: kernel access of bad
area' problem.  The following changes made the system to boot with any
amount of crashkernel memory size.

Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    7 ++++---
 mm/bootmem.c           |    4 ++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/numa.c~2628-rc9-panics-with-crashkernel=256m-while-booting arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~2628-rc9-panics-with-crashkernel=256m-while-booting
+++ a/arch/powerpc/mm/numa.c
@@ -995,10 +995,11 @@ void __init do_init_bootmem(void)
 				  start_pfn, end_pfn);
 
 		free_bootmem_with_active_regions(nid, end_pfn);
+	}
+
+	for_each_online_node(nid) {
 		/*
-		 * Be very careful about moving this around.  Future
-		 * calls to careful_allocation() depend on this getting
-		 * done correctly.
+		 * Be very careful about moving this around.
 		 */
 		mark_reserved_regions_for_nid(nid);
 		sparse_memory_present_with_active_regions(nid);
diff -puN mm/bootmem.c~2628-rc9-panics-with-crashkernel=256m-while-booting mm/bootmem.c
--- a/mm/bootmem.c~2628-rc9-panics-with-crashkernel=256m-while-booting
+++ a/mm/bootmem.c
@@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
 				 unsigned long size, int flags)
 {
 	unsigned long start, end;
+	bootmem_data_t *bdata = pgdat->bdata;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
+	if (end > bdata->node_low_pfn)
+		end = bdata->node_low_pfn;
+
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
 }
 
_

