Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbYCEQIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbYCEQIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759808AbYCEQHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:07:14 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:55191 "EHLO
	outbound3-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760841AbYCEQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:07:07 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JX9M2Q-03-SFF-01
Date: Wed, 5 Mar 2008 17:00:20 +0100
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Adam Litke <aglitke@gmail.com>, nacc <nacc@linux.vnet.ibm.com>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] make /proc/pid/pagemap work with huge pages and return page size
Message-ID: <20080305160020.GA27109@escobedo.amd.com>
References: <1203791461.11305.135.camel@nimitz.home.sr71.net> <20080225120951.GA5963@escobedo.amd.com> <1203964750.28196.7.camel@nimitz.home.sr71.net> <20080226202533.GD5963@escobedo.amd.com> <1204134244.5207.28.camel@nimitz.home.sr71.net> <20080228120055
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204325172.4175.31.camel@cinder.waste.org>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 05 Mar 2008 15:59:26.0143 (UTC) FILETIME=[E2FF14F0:01C87ED9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 04:46:12PM -0600, Matt Mackall wrote:
> Well in any case, step 1 should be to finalize the interface. Let's
> start with a single patch that does nothing but move the exported bits
> around and makes room for the page shift bits. Are we agreed on what
> that should look like now?

Attached is a patch that changes the current pagemap code just to use
the pseudo-pte, which can now also include swap information. The
pseudo-pte is made available through the linux/pagemap_ppte.h header.
The x86-specific huge page support has been left out for now, so the
interface will return wrong information for huge pages.

There are a few reserved bits in the pte part of the union that could be
used to extend the pfn or add more status bits in future (a ronly bit,
indicating that a page is mapped read-only, has been added, but is
currently not set anywhere). The identical parts of the two bitfields in
the union are the present and swap bits, and the page shift.



Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>

---
 fs/proc/task_mmu.c           |   41 ++++++++++++++++--------------------
 include/linux/pagemap_ppte.h |   47 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 23 deletions(-)
 create mode 100644 include/linux/pagemap_ppte.h

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 49958cf..958a37a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -5,6 +5,7 @@
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
 #include <linux/pagemap.h>
+#include <linux/pagemap_ppte.h>
 #include <linux/ptrace.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
@@ -527,16 +528,10 @@ struct pagemapread {
 	char __user *out, *end;
 };
 
-#define PM_ENTRY_BYTES sizeof(u64)
-#define PM_RESERVED_BITS    3
-#define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
-#define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
-#define PM_NOT_PRESENT      PM_SPECIAL(1LL)
-#define PM_SWAP             PM_SPECIAL(2LL)
-#define PM_END_OF_BUFFER    1
+#define PM_ENTRY_BYTES   sizeof(pagemap_ppte_t)
+#define PM_END_OF_BUFFER 1
 
-static int add_to_pagemap(unsigned long addr, u64 pfn,
+static int add_to_pagemap(unsigned long addr, pagemap_ppte_t ppte,
 			  struct pagemapread *pm)
 {
 	/*
@@ -545,13 +540,13 @@ static int add_to_pagemap(unsigned long addr, u64 pfn,
 	 * the pfn.
 	 */
 	if (pm->out + PM_ENTRY_BYTES >= pm->end) {
-		if (copy_to_user(pm->out, &pfn, pm->end - pm->out))
+		if (copy_to_user(pm->out, &ppte, pm->end - pm->out))
 			return -EFAULT;
 		pm->out = pm->end;
 		return PM_END_OF_BUFFER;
 	}
 
-	if (put_user(pfn, pm->out))
+	if (copy_to_user(pm->out, &ppte, sizeof(ppte)))
 		return -EFAULT;
 	pm->out += PM_ENTRY_BYTES;
 	return 0;
@@ -571,12 +566,6 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 	return err;
 }
 
-u64 swap_pte_to_pagemap_entry(pte_t pte)
-{
-	swp_entry_t e = pte_to_swp_entry(pte);
-	return PM_SWAP | swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
-}
-
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     void *private)
 {
@@ -585,15 +574,21 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	int err = 0;
 
 	for (; addr != end; addr += PAGE_SIZE) {
-		u64 pfn = PM_NOT_PRESENT;
+                pagemap_ppte_t ppte = PM_NOT_PRESENT;
+
 		pte = pte_offset_map(pmd, addr);
-		if (is_swap_pte(*pte))
-			pfn = swap_pte_to_pagemap_entry(*pte);
-		else if (pte_present(*pte))
-			pfn = pte_pfn(*pte);
+		if (is_swap_pte(*pte)) {
+			swp_entry_t e = pte_to_swp_entry(*pte);
+			ppte.pm_swap   = 1;
+			ppte.pm_type   = swp_type(e);
+			ppte.pm_offset = swp_offset(e);
+		} else if (pte_present(*pte)) {
+			ppte.pm_present = 1;
+			ppte.pm_frame   = pte_pfn(*pte);
+		}
 		/* unmap so we're not in atomic when we copy to userspace */
 		pte_unmap(pte);
-		err = add_to_pagemap(addr, pfn, pm);
+		err = add_to_pagemap(addr, ppte, pm);
 		if (err)
 			return err;
 	}
diff --git a/include/linux/pagemap_ppte.h b/include/linux/pagemap_ppte.h
new file mode 100644
index 0000000..a983500
--- /dev/null
+++ b/include/linux/pagemap_ppte.h
@@ -0,0 +1,47 @@
+#ifndef _LINUX_PAGEMAP_PPTE_H
+#define _LINUX_PAGEMAP_PPTE_H
+
+#include <linux/types.h>
+
+/*
+ * structure used by /proc/pid/pagemap to describe mappings
+ */	
+
+union pagemap_ppte {
+	struct pagemap_ppte_pte {
+		__u64 _shift:6;
+		__u64 _frame:40;
+		__u64 _resvd:15;
+		__u64 _ronly:1;
+		__u64 _swap:1;
+		__u64 _present:1;
+	} pte;
+
+	struct pagemap_ppte_swp {
+		__u64 _shift:6;
+		__u64 _offset:51;
+		__u64 _type:5;
+		__u64 _swap:1;
+		__u64 _present:1;
+	} swp;
+
+	__u64 val;
+};
+
+#define pm_shift   pte._shift
+#define pm_frame   pte._frame
+#define pm_offset  swp._offset
+#define pm_type    swp._type
+#define pm_ronly   pte._ronly
+#define pm_swap    pte._swap
+#define pm_present pte._present
+
+typedef union pagemap_ppte pagemap_ppte_t;
+
+#define PM_NOT_PRESENT   ((pagemap_ppte_t) { .pm_present = 0,	 \
+					     .pm_swap    = 0, \
+					     .pm_offset  = 0, \
+					     .pm_type    = 0, \
+					     .pm_shift   = PAGE_SHIFT})
+
+#endif /* _LINUX_PAGEMAP_PPTE_H */
-- 
1.5.3.7


