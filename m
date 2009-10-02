Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbZJBBe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbZJBBe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZJBBeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:22 -0400
Received: from kroah.org ([198.145.64.141]:33525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067AbZJBBeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:25 2009
Message-Id: <20091002012425.705773966@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: stable-review@kernel.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Lee.Schermerhorn@hp.com,
       lee.schermerhorn@hp.com, ak@linux.intel.com, eric.whitney@hp.com,
       mel@csn.ul.ie, rientjes@google.com, agl@us.ibm.com, apw@canonical.com
Subject: [118/136] hugetlb: restore interleaving of bootmem huge pages (2.6.31)
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Not upstream as it is fixed differently in .32

I noticed that alloc_bootmem_huge_page() will only advance to the next
node on failure to allocate a huge page.  I asked about this on linux-mm
and linux-numa, cc'ing the usual huge page suspects.  Mel Gorman
responded:

	I strongly suspect that the same node being used until allocation
	failure instead of round-robin is an oversight and not deliberate
	at all. It appears to be a side-effect of a fix made way back in
	commit 63b4613c3f0d4b724ba259dc6c201bb68b884e1a ["hugetlb: fix
	hugepage allocation with memoryless nodes"]. Prior to that patch
	it looked like allocations would always round-robin even when
	allocation was successful.

Andy Whitcroft countered that the existing behavior looked like Andi
Kleen's original implementation and suggested that we ask him.  We did and
Andy replied that his intention was to interleave the allocations.  So,
...

This patch moves the advance of the hstate next node from which to
allocate up before the test for success of the attempted allocation.  This
will unconditionally advance the next node from which to alloc,
interleaving successful allocations over the nodes with sufficient
contiguous memory, and skipping over nodes that fail the huge page
allocation attempt.

Note that alloc_bootmem_huge_page() will only be called for huge pages of
order > MAX_ORDER.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1010,6 +1010,7 @@ int __weak alloc_bootmem_huge_page(struc
 				NODE_DATA(h->hugetlb_next_nid),
 				huge_page_size(h), huge_page_size(h), 0);
 
+		hstate_next_node(h);
 		if (addr) {
 			/*
 			 * Use the beginning of the huge page to store the
@@ -1019,7 +1020,6 @@ int __weak alloc_bootmem_huge_page(struc
 			m = addr;
 			goto found;
 		}
-		hstate_next_node(h);
 		nr_nodes--;
 	}
 	return 0;


