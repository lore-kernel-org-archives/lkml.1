Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYCXJu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYCXJu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 05:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYCXJut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 05:50:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34605
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbYCXJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 05:50:48 -0400
Date: Mon, 24 Mar 2008 02:50:48 -0700 (PDT)
Message-Id: <20080324.025048.162043544.davem@davemloft.net>
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [LMB]: Add lmb_alloc_nid()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This function will be used by the NUMA setup code on sparc64, and also
it can be used by powerpc, replacing it's hand crafted
"careful_allocation()" function in arch/powerpc/mm/numa.c

If x86 ever converts it's NUMA support over to using the LMB helpers,
it can use this too as it has something entirely similar.

[LMB]: Add lmb_alloc_nid()

A variant of lmb_alloc() that tries to allocate memory on a specified
NUMA node 'nid' but falls back to normal lmb_alloc() if that fails.

The caller provides a 'nid_range' function pointer which assists the
allocator.  It is given args 'start', 'end', and pointer to integer
'this_nid'.

It places at 'this_nid' the NUMA node id that corresponds to 'start',
and returns the end address within 'start' to 'end' at which memory
assosciated with 'nid' ends.

This callback allows a platform to use lmb_alloc_nid() in just
about any context, even ones in which early_pfn_to_nid() might
not be working yet.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/lmb.h |    2 +
 lib/lmb.c           |   86 +++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 632717c..271153d 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -42,6 +42,8 @@ extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
 extern long __init lmb_add(u64 base, u64 size);
 extern long __init lmb_reserve(u64 base, u64 size);
+extern u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
+				u64 (*nid_range)(u64, u64, int *));
 extern u64 __init lmb_alloc(u64 size, u64 align);
 extern u64 __init lmb_alloc_base(u64 size,
 		u64, u64 max_addr);
diff --git a/lib/lmb.c b/lib/lmb.c
index e3c8dcb..5e76b36 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -227,6 +227,82 @@ long __init lmb_overlaps_region(struct lmb_region *rgn, u64 base,
 	return (i < rgn->cnt) ? i : -1;
 }
 
+static u64 lmb_align_down(u64 addr, u64 size)
+{
+	return addr & ~(size - 1);
+}
+
+static u64 lmb_align_up(u64 addr, u64 size)
+{
+	return (addr + (size - 1)) & ~(size - 1);
+}
+
+static u64 __init lmb_alloc_nid_unreserved(u64 start, u64 end,
+					   u64 size, u64 align)
+{
+	u64 base;
+	long j;
+
+	base = lmb_align_down((end - size), align);
+	while (start <= base &&
+	       ((j = lmb_overlaps_region(&lmb.reserved, base, size)) >= 0))
+		base = lmb_align_down(lmb.reserved.region[j].base - size,
+				      align);
+
+	if (base != 0 && start <= base) {
+		if (lmb_add_region(&lmb.reserved, base,
+				   lmb_align_up(size, align)) < 0)
+			base = ~(u64)0;
+		return base;
+	}
+
+	return ~(u64)0;
+}
+
+static u64 __init lmb_alloc_nid_region(struct lmb_property *mp,
+				       u64 (*nid_range)(u64, u64, int *),
+				       u64 size, u64 align, int nid)
+{
+	u64 start, end;
+
+	start = mp->base;
+	end = start + mp->size;
+
+	start = lmb_align_up(start, align);
+	while (start < end) {
+		u64 this_end;
+		int this_nid;
+
+		this_end = nid_range(start, end, &this_nid);
+		if (this_nid == nid) {
+			u64 ret = lmb_alloc_nid_unreserved(start, this_end,
+							   size, align);
+			if (ret != ~(u64)0)
+				return ret;
+		}
+		start = this_end;
+	}
+
+	return ~(u64)0;
+}
+
+u64 __init lmb_alloc_nid(u64 size, u64 align, int nid,
+			 u64 (*nid_range)(u64 start, u64 end, int *nid))
+{
+	struct lmb_region *mem = &lmb.memory;
+	int i;
+
+	for (i = 0; i < mem->cnt; i++) {
+		u64 ret = lmb_alloc_nid_region(&mem->region[i],
+					       nid_range,
+					       size, align, nid);
+		if (ret != ~(u64)0)
+			return ret;
+	}
+
+	return lmb_alloc(size, align);
+}
+
 u64 __init lmb_alloc(u64 size, u64 align)
 {
 	return lmb_alloc_base(size, align, LMB_ALLOC_ANYWHERE);
@@ -245,16 +321,6 @@ u64 __init lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 	return alloc;
 }
 
-static u64 lmb_align_down(u64 addr, u64 size)
-{
-	return addr & ~(size - 1);
-}
-
-static u64 lmb_align_up(u64 addr, u64 size)
-{
-	return (addr + (size - 1)) & ~(size - 1);
-}
-
 u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 {
 	long i, j;
-- 
1.5.4.rc3.14.g44397

