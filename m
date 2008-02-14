Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbYBNMfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbYBNMfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbYBNMfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:35:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59845 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754905AbYBNMfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:35:30 -0500
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, mel@csn.ul.ie, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Paul Jackson <pj@sgi.com>, clameter@sgi.com
Date: Thu, 14 Feb 2008 04:35:28 -0800
Message-Id: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] bitmap relative operator for mempolicy extensions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

[Beware - never tested, never booted.]

The following adds one more bitmap operator, with the usual
cpumask and nodemask wrappers.  This operator computes one
bitmap relative to another.  If the n-th bit in the origin
mask is set, then the m-th bit of the destination mask will
be set, where m is the position of the n-th set bit in the
relative mask.

This is initially to be used by the MPOL_F_RELATIVE_NODES
facility being considered for mm/mempolicy.c.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com
Cc: clameter@sgi.com
Cc: ak@suse.de
Cc: mel@csn.ul.ie

---
 include/linux/bitmap.h   |    3 ++
 include/linux/cpumask.h  |   12 ++++++++
 include/linux/nodemask.h |   12 ++++++++
 lib/bitmap.c             |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 2 deletions(-)

--- 2.6.24-mm1.orig/include/linux/nodemask.h	2008-02-04 10:41:13.360573666 -0800
+++ 2.6.24-mm1/include/linux/nodemask.h	2008-02-14 03:18:08.134310910 -0800
@@ -14,6 +14,7 @@
  * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
  * For details of node_remap(), see bitmap_bitremap in lib/bitmap.c.
  * For details of nodes_remap(), see bitmap_remap in lib/bitmap.c.
+ * For details of nodes_relative(), see bitmap_relative in lib/bitmap.c.
  *
  * The available nodemask operations are:
  *
@@ -55,7 +56,8 @@
  * int nodelist_scnprintf(buf, len, mask) Format nodemask as list for printing
  * int nodelist_parse(buf, map)		Parse ascii string as nodelist
  * int node_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
- * int nodes_remap(dst, src, old, new)	*dst = map(old, new)(dst)
+ * void nodes_remap(dst, src, old, new)	*dst = map(old, new)(src)
+ * void nodes_relative(dst, orig, relmap) *dst = orig relative to relmap
  *
  * for_each_node_mask(node, mask)	for-loop node over mask
  *
@@ -326,6 +328,14 @@ static inline void __nodes_remap(nodemas
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
+#define nodes_relative(dst, orig, relmap) \
+		__nodes_relative(&(dst), &(orig), &(relmap), MAX_NUMNODES)
+static inline void __nodes_relative(nodemask_t *dstp, const nodemask_t *origp,
+		const nodemask_t *relmapp, int nbits)
+{
+	bitmap_relative(dstp->bits, origp->bits, relmapp->bits, nbits);
+}
+
 #if MAX_NUMNODES > 1
 #define for_each_node_mask(node, mask)			\
 	for ((node) = first_node(mask);			\
--- 2.6.24-mm1.orig/include/linux/bitmap.h	2008-02-04 10:41:02.440391382 -0800
+++ 2.6.24-mm1/include/linux/bitmap.h	2008-02-14 03:18:08.150311160 -0800
@@ -46,6 +46,7 @@
  * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
  * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
  * bitmap_bitremap(oldbit, old, new, nbits)	newbit = map(old, new)(oldbit)
+ * bitmap_relative(dst, orig, relmap, nbits)	*dst = orig relative to relmap
  * bitmap_scnprintf(buf, len, src, nbits)	Print bitmap src to buf
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
@@ -120,6 +121,8 @@ extern void bitmap_remap(unsigned long *
 		const unsigned long *old, const unsigned long *new, int bits);
 extern int bitmap_bitremap(int oldbit,
 		const unsigned long *old, const unsigned long *new, int bits);
+extern void bitmap_relative(unsigned long *dst, const unsigned long *orig,
+		const unsigned long *relmap, int bits);
 extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
--- 2.6.24-mm1.orig/include/linux/cpumask.h	2008-02-04 10:53:59.229364809 -0800
+++ 2.6.24-mm1/include/linux/cpumask.h	2008-02-14 03:18:08.174311535 -0800
@@ -14,6 +14,7 @@
  * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
  * For details of cpu_remap(), see bitmap_bitremap in lib/bitmap.c
  * For details of cpus_remap(), see bitmap_remap in lib/bitmap.c.
+ * For details of cpus_relative(), see bitmap_relative in lib/bitmap.c.
  *
  * The available cpumask operations are:
  *
@@ -53,7 +54,8 @@
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
  * int cpulist_parse(buf, map)		Parse ascii string as cpulist
  * int cpu_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
- * int cpus_remap(dst, src, old, new)	*dst = map(old, new)(src)
+ * void cpus_remap(dst, src, old, new)	*dst = map(old, new)(src)
+ * void cpus_relative(dst, orig, relmap) *dst = orig relative to relmap
  *
  * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask
  *
@@ -311,6 +313,14 @@ static inline void __cpus_remap(cpumask_
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
+#define cpus_relative(dst, orig, relmap) \
+		__cpus_relative(&(dst), &(orig), &(relmap), NR_CPUS)
+static inline void __cpus_relative(cpumask_t *dstp, const cpumask_t *origp,
+		const cpumask_t *relmapp, int nbits)
+{
+	bitmap_relative(dstp->bits, origp->bits, relmapp->bits, nbits);
+}
+
 #if NR_CPUS > 1
 #define for_each_cpu_mask(cpu, mask)		\
 	for ((cpu) = first_cpu(mask);		\
--- 2.6.24-mm1.orig/lib/bitmap.c	2008-02-04 10:41:35.656945848 -0800
+++ 2.6.24-mm1/lib/bitmap.c	2008-02-14 03:18:08.190311785 -0800
@@ -698,6 +698,69 @@ int bitmap_bitremap(int oldbit, const un
 }
 EXPORT_SYMBOL(bitmap_bitremap);
 
+/**
+ * bitmap_relative - translate one bitmap relative to another
+ *	@dst: resulting translated bitmap
+ * 	@orig: original untranslated bitmap
+ * 	@relmap: bitmap relative to which translated
+ *	@bits: number of bits in each of these bitmaps
+ *
+ * Set the n-th bit of @dst iff there exists some m such that the
+ * n-th bit of @relmap is set, the m-th bit of @orig is is set,
+ * and the n-th bit of @relmap is the m-th set bit of @relmap.
+ * (If you understood the previous sentence the first time your
+ * read it, you're overqualified for your current job.)
+ *
+ * Example:
+ *  Let's say @relmap has bits 30-39 set, and @orig has bits
+ *  1, 3, 5, 7, 9 and 11 set.  Then on return from this routine,
+ *  @dst will have bits 31, 33, 35, 37 and 39 set.
+ *
+ *  When bit 0 is set in @orig, it means turn on the bit in
+ *  @dst corresponding to whatever is the first bit (if any)
+ *  that is turned on in @relmap.  Since bit 0 was off in the
+ *  above example, we leave off that bit (bit 30) in @dst.
+ *
+ *  When bit 1 is set in @orig (as in the above example), it
+ *  means turn on the bit in @dst corresponding to whatever
+ *  is the second bit that is turned on in @relmap.  The second
+ *  bit in @relmap that was turned on in the above example was
+ *  bit 31, so we turned on bit 31 in @dst.
+ *
+ *  Similarly, we turned on bits 33, 35, 37 and 39 in @dst,
+ *  because they were the 4th, 6th, 8th and 10th set bits
+ *  set in @relmap, and the 4th, 6th, 8th and 10th bits of
+ *  @orig (i.e. bits 3, 5, 7 and 9) were also set.
+ *
+ *  When bit 11 is set in @orig, it means turn on the bit in
+ *  @dst corresponding to whatever is the twelth bit that is
+ *  turned on in @relmap.  In the above example, there were
+ *  only ten bits turned on in @relmap (30..39), so that bit
+ *  11 was set in @orig had no affect on @dst.
+ *
+ * If either of @orig or @relmap is empty (no set bits), then
+ * @dst will be returned empty.
+ *
+ * All bits in @dst not set by the above rule are cleared.
+ */
+void bitmap_relative(unsigned long *dst, const unsigned long *orig,
+			const unsigned long *relmap, int bits)
+{
+	int n, m;	/* same meaning as in above comment */
+
+	bitmap_zero(dst, bits);
+
+	m = 0;
+	for (n = find_first_bit(relmap, bits);
+	     n < bits;
+	     n = find_next_bit(relmap, bits, n + 1)) {
+		/* m == bitmap_pos_to_ord(relmap, n, bits) */
+		if (test_bit(m, orig))
+			set_bit(n, dst);
+		m++;
+	}
+}
+
 /*
  * Common code for bitmap_*_region() routines.
  *	bitmap: array of unsigned longs corresponding to the bitmap

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
