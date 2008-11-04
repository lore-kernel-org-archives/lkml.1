Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYKDXsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYKDXsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbYKDXjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:25 -0500
Received: from mx1.suse.de ([195.135.220.2]:47568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbYKDXjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:24 -0500
Date: Tue, 4 Nov 2008 15:32:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 29/57] powerpc/numa: Make memory reserve code more robust
Message-ID: <20081104233201.GD659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-numa-make-memory-reserve-code-more-robust.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jon Tollefson <kniht@us.ibm.com>

commit e81703724a966120ace6504c993bda9e084cbf3e upstream.

Adjust amount to reserve based on previous nodes for reserves spanning
multiple nodes. Check if the node active range is empty before attempting
to pass the reserve to bootmem.  In practice the range shouldn't be empty,
but to be sure we check.

Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/numa.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -116,6 +116,7 @@ static int __init get_active_region_work
 
 /*
  * get_node_active_region - Return active region containing start_pfn
+ * Active range returned is empty if none found.
  * @start_pfn: The page to return the region for.
  * @node_ar: Returned set to the active region containing start_pfn
  */
@@ -126,6 +127,7 @@ static void __init get_node_active_regio
 
 	node_ar->nid = nid;
 	node_ar->start_pfn = start_pfn;
+	node_ar->end_pfn = start_pfn;
 	work_with_active_regions(nid, get_active_region_work_fn, node_ar);
 }
 
@@ -888,18 +890,20 @@ void __init do_init_bootmem(void)
 		struct node_active_region node_ar;
 
 		get_node_active_region(start_pfn, &node_ar);
-		while (start_pfn < end_pfn) {
+		while (start_pfn < end_pfn &&
+			node_ar.start_pfn < node_ar.end_pfn) {
+			unsigned long reserve_size = size;
 			/*
 			 * if reserved region extends past active region
 			 * then trim size to active region
 			 */
 			if (end_pfn > node_ar.end_pfn)
-				size = (node_ar.end_pfn << PAGE_SHIFT)
+				reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
 					- (start_pfn << PAGE_SHIFT);
-			dbg("reserve_bootmem %lx %lx nid=%d\n", physbase, size,
-				node_ar.nid);
+			dbg("reserve_bootmem %lx %lx nid=%d\n", physbase,
+				reserve_size, node_ar.nid);
 			reserve_bootmem_node(NODE_DATA(node_ar.nid), physbase,
-						size, BOOTMEM_DEFAULT);
+						reserve_size, BOOTMEM_DEFAULT);
 			/*
 			 * if reserved region is contained in the active region
 			 * then done.
@@ -914,6 +918,7 @@ void __init do_init_bootmem(void)
 			 */
 			start_pfn = node_ar.end_pfn;
 			physbase = start_pfn << PAGE_SHIFT;
+			size = size - reserve_size;
 			get_node_active_region(start_pfn, &node_ar);
 		}
 

-- 
