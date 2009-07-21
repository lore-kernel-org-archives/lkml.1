Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZGUK2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZGUK2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZGUK2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:36976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZGUK1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:49 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/20] vmalloc: implement pcpu_get_vm_areas()
Date: Tue, 21 Jul 2009 19:26:13 +0900
Message-Id: <1248171979-29166-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To directly use spread NUMA memories for percpu units, percpu
allocator will be updated to allow sparsely mapping units in a chunk.
As the distances between units can be very large, this makes
allocating single vmap area for each chunk undesirable.  This patch
implements pcpu_get_vm_areas() and pcpu_free_vm_areas() which
allocates and frees sparse congruent vmap areas.

pcpu_get_vm_areas() take @offsets and @sizes array which define
distances and sizes of vmap areas.  It scans down from the top of
vmalloc area looking for the top-most address which can accomodate all
the areas.  The top-down scan is to avoid interacting with regular
vmallocs which can push up these congruent areas up little by little
ending up wasting address space and page table.

To speed up top-down scan, the highest possible address hint is
maintained.  Although the scan is linear from the hint, given the
usual large holes between memory addresses between NUMA nodes, the
scanning is highly likely to finish after finding the first hole for
the last unit which is scanned first.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
---
 include/linux/vmalloc.h |    6 +
 mm/vmalloc.c            |  293 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 299 insertions(+), 0 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index a43ebec..227c2a5 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -115,4 +115,10 @@ extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);
 
+struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
+				     const size_t *sizes, int nr_vms,
+				     size_t align, gfp_t gfp_mask);
+
+void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
+
 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2eb461c..ebe3470 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -265,6 +265,7 @@ struct vmap_area {
 static DEFINE_SPINLOCK(vmap_area_lock);
 static struct rb_root vmap_area_root = RB_ROOT;
 static LIST_HEAD(vmap_area_list);
+static unsigned long vmap_area_pcpu_hole;
 
 static struct vmap_area *__find_vmap_area(unsigned long addr)
 {
@@ -431,6 +432,15 @@ static void __free_vmap_area(struct vmap_area *va)
 	RB_CLEAR_NODE(&va->rb_node);
 	list_del_rcu(&va->list);
 
+	/*
+	 * Track the highest possible candidate for pcpu area
+	 * allocation.  Areas outside of vmalloc area can be returned
+	 * here too, consider only end addresses which fall inside
+	 * vmalloc area proper.
+	 */
+	if (va->va_end > VMALLOC_START && va->va_end <= VMALLOC_END)
+		vmap_area_pcpu_hole = max(vmap_area_pcpu_hole, va->va_end);
+
 	call_rcu(&va->rcu_head, rcu_free_va);
 }
 
@@ -1038,6 +1048,9 @@ void __init vmalloc_init(void)
 		va->va_end = va->va_start + tmp->size;
 		__insert_vmap_area(va);
 	}
+
+	vmap_area_pcpu_hole = VMALLOC_END;
+
 	vmap_initialized = true;
 }
 
@@ -1821,6 +1834,286 @@ void free_vm_area(struct vm_struct *area)
 }
 EXPORT_SYMBOL_GPL(free_vm_area);
 
+static struct vmap_area *node_to_va(struct rb_node *n)
+{
+	return n ? rb_entry(n, struct vmap_area, rb_node) : NULL;
+}
+
+/**
+ * pvm_find_next_prev - find the next and prev vmap_area surrounding @end
+ * @end: target address
+ * @pnext: out arg for the next vmap_area
+ * @pprev: out arg for the previous vmap_area
+ *
+ * Returns: %true if either or both of next and prev are found,
+ *	    %false if no vmap_area exists
+ *
+ * Find vmap_areas end addresses of which enclose @end.  ie. if not
+ * NULL, *pnext->va_end > @end and *pprev->va_end <= @end.
+ */
+static bool pvm_find_next_prev(unsigned long end,
+			       struct vmap_area **pnext,
+			       struct vmap_area **pprev)
+{
+	struct rb_node *n = vmap_area_root.rb_node;
+	struct vmap_area *va = NULL;
+
+	while (n) {
+		va = rb_entry(n, struct vmap_area, rb_node);
+		if (end < va->va_end)
+			n = n->rb_left;
+		else if (end > va->va_end)
+			n = n->rb_right;
+		else
+			break;
+	}
+
+	if (!va)
+		return false;
+
+	if (va->va_end > end) {
+		*pnext = va;
+		*pprev = node_to_va(rb_prev(&(*pnext)->rb_node));
+	} else {
+		*pprev = va;
+		*pnext = node_to_va(rb_next(&(*pprev)->rb_node));
+	}
+	return true;
+}
+
+/**
+ * pvm_determine_end - find the highest aligned address between two vmap_areas
+ * @pnext: in/out arg for the next vmap_area
+ * @pprev: in/out arg for the previous vmap_area
+ * @align: alignment
+ *
+ * Returns: determined end address
+ *
+ * Find the highest aligned address between *@pnext and *@pprev below
+ * VMALLOC_END.  *@pnext and *@pprev are adjusted so that the aligned
+ * down address is between the end addresses of the two vmap_areas.
+ *
+ * Please note that the address returned by this function may fall
+ * inside *@pnext vmap_area.  The caller is responsible for checking
+ * that.
+ */
+static unsigned long pvm_determine_end(struct vmap_area **pnext,
+				       struct vmap_area **pprev,
+				       unsigned long align)
+{
+	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	unsigned long addr;
+
+	if (*pnext)
+		addr = min((*pnext)->va_start & ~(align - 1), vmalloc_end);
+	else
+		addr = vmalloc_end;
+
+	while (*pprev && (*pprev)->va_end > addr) {
+		*pnext = *pprev;
+		*pprev = node_to_va(rb_prev(&(*pnext)->rb_node));
+	}
+
+	return addr;
+}
+
+/**
+ * pcpu_get_vm_areas - allocate vmalloc areas for percpu allocator
+ * @offsets: array containing offset of each area
+ * @sizes: array containing size of each area
+ * @nr_vms: the number of areas to allocate
+ * @align: alignment, all entries in @offsets and @sizes must be aligned to this
+ * @gfp_mask: allocation mask
+ *
+ * Returns: kmalloc'd vm_struct pointer array pointing to allocated
+ *	    vm_structs on success, %NULL on failure
+ *
+ * Percpu allocator wants to use congruent vm areas so that it can
+ * maintain the offsets among percpu areas.  This function allocates
+ * congruent vmalloc areas for it.  These areas tend to be scattered
+ * pretty far, distance between two areas easily going up to
+ * gigabytes.  To avoid interacting with regular vmallocs, these areas
+ * are allocated from top.
+ *
+ * Despite its complicated look, this allocator is rather simple.  It
+ * does everything top-down and scans areas from the end looking for
+ * matching slot.  While scanning, if any of the areas overlaps with
+ * existing vmap_area, the base address is pulled down to fit the
+ * area.  Scanning is repeated till all the areas fit and then all
+ * necessary data structres are inserted and the result is returned.
+ */
+struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
+				     const size_t *sizes, int nr_vms,
+				     size_t align, gfp_t gfp_mask)
+{
+	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
+	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
+	struct vmap_area **vas, *prev, *next;
+	struct vm_struct **vms;
+	int area, area2, last_area, term_area;
+	unsigned long base, start, end, last_end;
+	bool purged = false;
+
+	gfp_mask &= GFP_RECLAIM_MASK;
+
+	/* verify parameters and allocate data structures */
+	BUG_ON(align & ~PAGE_MASK || !is_power_of_2(align));
+	for (last_area = 0, area = 0; area < nr_vms; area++) {
+		start = offsets[area];
+		end = start + sizes[area];
+
+		/* is everything aligned properly? */
+		BUG_ON(!IS_ALIGNED(offsets[area], align));
+		BUG_ON(!IS_ALIGNED(sizes[area], align));
+
+		/* detect the area with the highest address */
+		if (start > offsets[last_area])
+			last_area = area;
+
+		for (area2 = 0; area2 < nr_vms; area2++) {
+			unsigned long start2 = offsets[area2];
+			unsigned long end2 = start2 + sizes[area2];
+
+			if (area2 == area)
+				continue;
+
+			BUG_ON(start2 >= start && start2 < end);
+			BUG_ON(end2 <= end && end2 > start);
+		}
+	}
+	last_end = offsets[last_area] + sizes[last_area];
+
+	if (vmalloc_end - vmalloc_start < last_end) {
+		WARN_ON(true);
+		return NULL;
+	}
+
+	vms = kzalloc(sizeof(vms[0]) * nr_vms, gfp_mask);
+	vas = kzalloc(sizeof(vas[0]) * nr_vms, gfp_mask);
+	if (!vas || !vms)
+		goto err_free;
+
+	for (area = 0; area < nr_vms; area++) {
+		vas[area] = kzalloc(sizeof(struct vmap_area), gfp_mask);
+		vms[area] = kzalloc(sizeof(struct vm_struct), gfp_mask);
+		if (!vas[area] || !vms[area])
+			goto err_free;
+	}
+retry:
+	spin_lock(&vmap_area_lock);
+
+	/* start scanning - we scan from the top, begin with the last area */
+	area = term_area = last_area;
+	start = offsets[area];
+	end = start + sizes[area];
+
+	if (!pvm_find_next_prev(vmap_area_pcpu_hole, &next, &prev)) {
+		base = vmalloc_end - last_end;
+		goto found;
+	}
+	base = pvm_determine_end(&next, &prev, align) - end;
+
+	while (true) {
+		BUG_ON(next && next->va_end <= base + end);
+		BUG_ON(prev && prev->va_end > base + end);
+
+		/*
+		 * base might have underflowed, add last_end before
+		 * comparing.
+		 */
+		if (base + last_end < vmalloc_start + last_end) {
+			spin_unlock(&vmap_area_lock);
+			if (!purged) {
+				purge_vmap_area_lazy();
+				purged = true;
+				goto retry;
+			}
+			goto err_free;
+		}
+
+		/*
+		 * If next overlaps, move base downwards so that it's
+		 * right below next and then recheck.
+		 */
+		if (next && next->va_start < base + end) {
+			base = pvm_determine_end(&next, &prev, align) - end;
+			term_area = area;
+			continue;
+		}
+
+		/*
+		 * If prev overlaps, shift down next and prev and move
+		 * base so that it's right below new next and then
+		 * recheck.
+		 */
+		if (prev && prev->va_end > base + start)  {
+			next = prev;
+			prev = node_to_va(rb_prev(&next->rb_node));
+			base = pvm_determine_end(&next, &prev, align) - end;
+			term_area = area;
+			continue;
+		}
+
+		/*
+		 * This area fits, move on to the previous one.  If
+		 * the previous one is the terminal one, we're done.
+		 */
+		area = (area + nr_vms - 1) % nr_vms;
+		if (area == term_area)
+			break;
+		start = offsets[area];
+		end = start + sizes[area];
+		pvm_find_next_prev(base + end, &next, &prev);
+	}
+found:
+	/* we've found a fitting base, insert all va's */
+	for (area = 0; area < nr_vms; area++) {
+		struct vmap_area *va = vas[area];
+
+		va->va_start = base + offsets[area];
+		va->va_end = va->va_start + sizes[area];
+		__insert_vmap_area(va);
+	}
+
+	vmap_area_pcpu_hole = base + offsets[last_area];
+
+	spin_unlock(&vmap_area_lock);
+
+	/* insert all vm's */
+	for (area = 0; area < nr_vms; area++)
+		insert_vmalloc_vm(vms[area], vas[area], 0,
+				  pcpu_get_vm_areas);
+
+	kfree(vas);
+	return vms;
+
+err_free:
+	for (area = 0; area < nr_vms; area++) {
+		if (vas)
+			kfree(vas[area]);
+		if (vms)
+			kfree(vms[area]);
+	}
+	kfree(vas);
+	kfree(vms);
+	return NULL;
+}
+
+/**
+ * pcpu_free_vm_areas - free vmalloc areas for percpu allocator
+ * @vms: vm_struct pointer array returned by pcpu_get_vm_areas()
+ * @nr_vms: the number of allocated areas
+ *
+ * Free vm_structs and the array allocated by pcpu_get_vm_areas().
+ */
+void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
+{
+	int i;
+
+	for (i = 0; i < nr_vms; i++)
+		free_vm_area(vms[i]);
+	kfree(vms);
+}
 
 #ifdef CONFIG_PROC_FS
 static void *s_start(struct seq_file *m, loff_t *pos)
-- 
1.6.0.2

