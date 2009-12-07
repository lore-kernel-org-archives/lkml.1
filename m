Return-Path: <linux-kernel-owner+w=401wt.eu-S935346AbZLGQYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935346AbZLGQYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbZLGQYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:24:02 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45222 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252AbZLGQYB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Mon, 7 Dec 2009 11:24:01 -0500
Message-Id: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 07 Dec 2009 16:24:03 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <tony.luck@intel.com>, <tj@kernel.org>, <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] mm/vmalloc: don't use vmalloc_end
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least on ia64 vmalloc_end is a global variable that VMALLOC_END
expands to. Hence having a local variable named vmalloc_end and
initialized from VMALLOC_END won't work on such platforms. Rename
these variables, and for consistency also rename vmalloc_start.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>

---
 mm/vmalloc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.32/mm/vmalloc.c
+++ 2.6.32-dont-use-vmalloc_end/mm/vmalloc.c
@@ -2060,13 +2060,13 @@ static unsigned long pvm_determine_end(s
 				       struct vmap_area **pprev,
 				       unsigned long align)
 {
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	const unsigned long end = VMALLOC_END & ~(align - 1);
 	unsigned long addr;
 
 	if (*pnext)
-		addr = min((*pnext)->va_start & ~(align - 1), vmalloc_end);
+		addr = min((*pnext)->va_start & ~(align - 1), end);
 	else
-		addr = vmalloc_end;
+		addr = end;
 
 	while (*pprev && (*pprev)->va_end > addr) {
 		*pnext = *pprev;
@@ -2105,8 +2105,8 @@ struct vm_struct **pcpu_get_vm_areas(con
 				     const size_t *sizes, int nr_vms,
 				     size_t align, gfp_t gfp_mask)
 {
-	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
-	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	const unsigned long vstart = ALIGN(VMALLOC_START, align);
+	const unsigned long vend = VMALLOC_END & ~(align - 1);
 	struct vmap_area **vas, *prev, *next;
 	struct vm_struct **vms;
 	int area, area2, last_area, term_area;
@@ -2142,7 +2142,7 @@ struct vm_struct **pcpu_get_vm_areas(con
 	}
 	last_end = offsets[last_area] + sizes[last_area];
 
-	if (vmalloc_end - vmalloc_start < last_end) {
+	if (vend - vstart < last_end) {
 		WARN_ON(true);
 		return NULL;
 	}
@@ -2167,7 +2167,7 @@ retry:
 	end = start + sizes[area];
 
 	if (!pvm_find_next_prev(vmap_area_pcpu_hole, &next, &prev)) {
-		base = vmalloc_end - last_end;
+		base = vend - last_end;
 		goto found;
 	}
 	base = pvm_determine_end(&next, &prev, align) - end;
@@ -2180,7 +2180,7 @@ retry:
 		 * base might have underflowed, add last_end before
 		 * comparing.
 		 */
-		if (base + last_end < vmalloc_start + last_end) {
+		if (base + last_end < vstart + last_end) {
 			spin_unlock(&vmap_area_lock);
 			if (!purged) {
 				purge_vmap_area_lazy();



