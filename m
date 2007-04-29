Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXD2RlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXD2RlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030878AbXD2Rku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:40:50 -0400
Received: from gw.goop.org ([64.81.55.164]:57179 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030767AbXD2RbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:31:17 -0400
Message-Id: <20070429172914.949632000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: [patch 22/32] xen: Add Xen grant table support
Content-Disposition: inline; filename=xen-grant-table.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add Xen 'grant table' driver which allows granting of access to
selected local memory pages by other virtual machines and,
symmetrically, the mapping of remote memory pages which other virtual
machines have granted access to.

This driver is a prerequisite for many of the Xen virtual device
drivers, which grant the 'device driver domain' restricted and
temporary access to only those memory pages that are currently
involved in I/O operations.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/xen/Makefile                |    1 
 drivers/xen/grant-table.c           |  576 +++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h           |  107 ++++++
 include/xen/interface/grant_table.h |  112 +++++-
 4 files changed, 777 insertions(+), 19 deletions(-)

===================================================================
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,1 +1,2 @@ obj-y	+= hvc-console.o
+obj-y	+= grant-table.o
 obj-y	+= hvc-console.o
===================================================================
--- /dev/null
+++ b/drivers/xen/grant-table.c
@@ -0,0 +1,576 @@
+/******************************************************************************
+ * grant_table.c
+ *
+ * Granting foreign access to our memory reservation.
+ *
+ * Copyright (c) 2005-2006, Christopher Clark
+ * Copyright (c) 2004-2005, K A Fraser
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+
+#include <xen/interface/xen.h>
+#include <xen/page.h>
+#include <xen/grant_table.h>
+
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/sync_bitops.h>
+
+
+/* External tools reserve first few grant table entries. */
+#define NR_RESERVED_ENTRIES 8
+#define GNTTAB_LIST_END 0xffffffff
+#define GREFS_PER_GRANT_FRAME (PAGE_SIZE / sizeof(struct grant_entry))
+
+static grant_ref_t **gnttab_list;
+static unsigned int nr_grant_frames;
+static unsigned int boot_max_nr_grant_frames;
+static int gnttab_free_count;
+static grant_ref_t gnttab_free_head;
+static DEFINE_SPINLOCK(gnttab_list_lock);
+
+static struct grant_entry *shared;
+
+static struct gnttab_free_callback *gnttab_free_callback_list;
+
+static int gnttab_expand(unsigned int req_entries);
+
+#define RPP (PAGE_SIZE / sizeof(grant_ref_t))
+#define gnttab_entry(entry) (gnttab_list[(entry) / RPP][(entry) % RPP])
+
+static int get_free_entries(int count)
+{
+	unsigned long flags;
+	int ref, rc;
+	grant_ref_t head;
+
+	spin_lock_irqsave(&gnttab_list_lock, flags);
+
+	if ((gnttab_free_count < count) &&
+	    ((rc = gnttab_expand(count - gnttab_free_count)) < 0)) {
+		spin_unlock_irqrestore(&gnttab_list_lock, flags);
+		return rc;
+	}
+
+	ref = head = gnttab_free_head;
+	gnttab_free_count -= count;
+	while (count-- > 1)
+		head = gnttab_entry(head);
+ 	gnttab_free_head = gnttab_entry(head);
+	gnttab_entry(head) = GNTTAB_LIST_END;
+
+	spin_unlock_irqrestore(&gnttab_list_lock, flags);
+
+	return ref;
+}
+
+#define get_free_entry() get_free_entries(1)
+
+static void do_free_callbacks(void)
+{
+	struct gnttab_free_callback *callback, *next;
+
+	callback = gnttab_free_callback_list;
+	gnttab_free_callback_list = NULL;
+
+	while (callback != NULL) {
+		next = callback->next;
+		if (gnttab_free_count >= callback->count) {
+			callback->next = NULL;
+			callback->fn(callback->arg);
+		} else {
+			callback->next = gnttab_free_callback_list;
+			gnttab_free_callback_list = callback;
+		}
+		callback = next;
+	}
+}
+
+static inline void check_free_callbacks(void)
+{
+	if (unlikely(gnttab_free_callback_list))
+		do_free_callbacks();
+}
+
+static void put_free_entry(grant_ref_t ref)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&gnttab_list_lock, flags);
+	gnttab_entry(ref) = gnttab_free_head;
+	gnttab_free_head = ref;
+	gnttab_free_count++;
+	check_free_callbacks();
+	spin_unlock_irqrestore(&gnttab_list_lock, flags);
+}
+
+static void update_grant_entry(grant_ref_t ref, domid_t domid,
+			       unsigned long frame, unsigned flags)
+{
+	/*
+	 * Introducing a valid entry into the grant table:
+	 *  1. Write ent->domid.
+	 *  2. Write ent->frame:
+	 *      GTF_permit_access:   Frame to which access is permitted.
+	 *      GTF_accept_transfer: Pseudo-phys frame slot being filled by new
+	 *                           frame, or zero if none.
+	 *  3. Write memory barrier (WMB).
+	 *  4. Write ent->flags, inc. valid type.
+	 */
+	shared[ref].frame = frame;
+	shared[ref].domid = domid;
+	wmb();
+	shared[ref].flags = flags;
+}
+
+/*
+ * Public grant-issuing interface functions
+ */
+void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
+				     unsigned long frame, int readonly)
+{
+	update_grant_entry(ref, domid, frame,
+			   GTF_permit_access | (readonly ? GTF_readonly : 0));
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access_ref);
+
+int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
+				int readonly)
+{
+	int ref;
+
+	if (unlikely((ref = get_free_entry()) < 0))
+		return -ENOSPC;
+
+	gnttab_grant_foreign_access_ref(ref, domid, frame, readonly);
+
+	return ref;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
+
+int gnttab_query_foreign_access(grant_ref_t ref)
+{
+	u16 nflags;
+
+	nflags = shared[ref].flags;
+
+	return (nflags & (GTF_reading|GTF_writing));
+}
+EXPORT_SYMBOL_GPL(gnttab_query_foreign_access);
+
+int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly)
+{
+	u16 flags, nflags;
+
+	nflags = shared[ref].flags;
+	do {
+		if ((flags = nflags) & (GTF_reading|GTF_writing)) {
+			printk(KERN_ALERT "WARNING: g.e. still in use!\n");
+			return 0;
+		}
+	} while ((nflags = sync_cmpxchg(&shared[ref].flags, flags, 0)) !=
+		 flags);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(gnttab_end_foreign_access_ref);
+
+void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
+			       unsigned long page)
+{
+	if (gnttab_end_foreign_access_ref(ref, readonly)) {
+		put_free_entry(ref);
+		if (page != 0)
+			free_page(page);
+	} else {
+		/* XXX This needs to be fixed so that the ref and page are
+		   placed on a list to be freed up later. */
+		printk(KERN_WARNING
+		       "WARNING: leaking g.e. and page still in use!\n");
+	}
+}
+EXPORT_SYMBOL_GPL(gnttab_end_foreign_access);
+
+int gnttab_grant_foreign_transfer(domid_t domid, unsigned long pfn)
+{
+	int ref;
+
+	if (unlikely((ref = get_free_entry()) < 0))
+		return -ENOSPC;
+	gnttab_grant_foreign_transfer_ref(ref, domid, pfn);
+
+	return ref;
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_transfer);
+
+void gnttab_grant_foreign_transfer_ref(grant_ref_t ref, domid_t domid,
+				       unsigned long pfn)
+{
+	update_grant_entry(ref, domid, pfn, GTF_accept_transfer);
+}
+EXPORT_SYMBOL_GPL(gnttab_grant_foreign_transfer_ref);
+
+unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref)
+{
+	unsigned long frame;
+	u16           flags;
+
+	/*
+	 * If a transfer is not even yet started, try to reclaim the grant
+	 * reference and return failure (== 0).
+	 */
+	while (!((flags = shared[ref].flags) & GTF_transfer_committed)) {
+		if (sync_cmpxchg(&shared[ref].flags, flags, 0) == flags)
+			return 0;
+		cpu_relax();
+	}
+
+	/* If a transfer is in progress then wait until it is completed. */
+	while (!(flags & GTF_transfer_completed)) {
+		flags = shared[ref].flags;
+		cpu_relax();
+	}
+
+	rmb();	/* Read the frame number /after/ reading completion status. */
+	frame = shared[ref].frame;
+	BUG_ON(frame == 0);
+
+	return frame;
+}
+EXPORT_SYMBOL_GPL(gnttab_end_foreign_transfer_ref);
+
+unsigned long gnttab_end_foreign_transfer(grant_ref_t ref)
+{
+	unsigned long frame = gnttab_end_foreign_transfer_ref(ref);
+	put_free_entry(ref);
+	return frame;
+}
+EXPORT_SYMBOL_GPL(gnttab_end_foreign_transfer);
+
+void gnttab_free_grant_reference(grant_ref_t ref)
+{
+	put_free_entry(ref);
+}
+EXPORT_SYMBOL_GPL(gnttab_free_grant_reference);
+
+void gnttab_free_grant_references(grant_ref_t head)
+{
+	grant_ref_t ref;
+	unsigned long flags;
+	int count = 1;
+	if (head == GNTTAB_LIST_END)
+		return;
+	spin_lock_irqsave(&gnttab_list_lock, flags);
+	ref = head;
+	while (gnttab_entry(ref) != GNTTAB_LIST_END) {
+		ref = gnttab_entry(ref);
+		count++;
+	}
+	gnttab_entry(ref) = gnttab_free_head;
+	gnttab_free_head = head;
+	gnttab_free_count += count;
+	check_free_callbacks();
+	spin_unlock_irqrestore(&gnttab_list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(gnttab_free_grant_references);
+
+int gnttab_alloc_grant_references(u16 count, grant_ref_t *head)
+{
+	int h = get_free_entries(count);
+
+	if (h < 0)
+		return -ENOSPC;
+
+	*head = h;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gnttab_alloc_grant_references);
+
+int gnttab_empty_grant_references(const grant_ref_t *private_head)
+{
+	return (*private_head == GNTTAB_LIST_END);
+}
+EXPORT_SYMBOL_GPL(gnttab_empty_grant_references);
+
+int gnttab_claim_grant_reference(grant_ref_t *private_head)
+{
+	grant_ref_t g = *private_head;
+	if (unlikely(g == GNTTAB_LIST_END))
+		return -ENOSPC;
+	*private_head = gnttab_entry(g);
+	return g;
+}
+EXPORT_SYMBOL_GPL(gnttab_claim_grant_reference);
+
+void gnttab_release_grant_reference(grant_ref_t *private_head,
+				    grant_ref_t release)
+{
+	gnttab_entry(release) = *private_head;
+	*private_head = release;
+}
+EXPORT_SYMBOL_GPL(gnttab_release_grant_reference);
+
+void gnttab_request_free_callback(struct gnttab_free_callback *callback,
+				  void (*fn)(void *), void *arg, u16 count)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&gnttab_list_lock, flags);
+	if (callback->next)
+		goto out;
+	callback->fn = fn;
+	callback->arg = arg;
+	callback->count = count;
+	callback->next = gnttab_free_callback_list;
+	gnttab_free_callback_list = callback;
+	check_free_callbacks();
+out:
+	spin_unlock_irqrestore(&gnttab_list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(gnttab_request_free_callback);
+
+void gnttab_cancel_free_callback(struct gnttab_free_callback *callback)
+{
+	struct gnttab_free_callback **pcb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gnttab_list_lock, flags);
+	for (pcb = &gnttab_free_callback_list; *pcb; pcb = &(*pcb)->next) {
+		if (*pcb == callback) {
+			*pcb = callback->next;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&gnttab_list_lock, flags);
+}
+EXPORT_SYMBOL_GPL(gnttab_cancel_free_callback);
+
+static int grow_gnttab_list(unsigned int more_frames)
+{
+	unsigned int new_nr_grant_frames, extra_entries, i;
+
+	new_nr_grant_frames = nr_grant_frames + more_frames;
+	extra_entries       = more_frames * GREFS_PER_GRANT_FRAME;
+
+	for (i = nr_grant_frames; i < new_nr_grant_frames; i++)
+	{
+		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_ATOMIC);
+		if (!gnttab_list[i])
+			goto grow_nomem;
+	}
+
+
+	for (i = GREFS_PER_GRANT_FRAME * nr_grant_frames;
+	     i < GREFS_PER_GRANT_FRAME * new_nr_grant_frames - 1; i++)
+		gnttab_entry(i) = i + 1;
+
+	gnttab_entry(i) = gnttab_free_head;
+	gnttab_free_head = GREFS_PER_GRANT_FRAME * nr_grant_frames;
+	gnttab_free_count += extra_entries;
+
+	nr_grant_frames = new_nr_grant_frames;
+
+	check_free_callbacks();
+
+	return 0;
+
+grow_nomem:
+	for ( ; i >= nr_grant_frames; i--)
+		free_page((unsigned long) gnttab_list[i]);
+	return -ENOMEM;
+}
+
+static unsigned int __max_nr_grant_frames(void)
+{
+	struct gnttab_query_size query;
+	int rc;
+
+	query.dom = DOMID_SELF;
+
+	rc = HYPERVISOR_grant_table_op(GNTTABOP_query_size, &query, 1);
+	if ((rc < 0) || (query.status != GNTST_okay))
+		return 4; /* Legacy max supported number of frames */
+
+	return query.max_nr_frames;
+}
+
+static inline unsigned int max_nr_grant_frames(void)
+{
+	unsigned int xen_max = __max_nr_grant_frames();
+
+	if (xen_max > boot_max_nr_grant_frames)
+		return boot_max_nr_grant_frames;
+	return xen_max;
+}
+
+static int map_pte_fn(pte_t *pte, struct page *pmd_page,
+		      unsigned long addr, void *data)
+{
+	unsigned long **frames = (unsigned long **)data;
+
+	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
+	(*frames)++;
+	return 0;
+}
+
+static int unmap_pte_fn(pte_t *pte, struct page *pmd_page,
+			unsigned long addr, void *data)
+{
+
+	set_pte_at(&init_mm, addr, pte, __pte(0));
+	return 0;
+}
+
+static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
+{
+	struct gnttab_setup_table setup;
+	unsigned long *frames;
+	unsigned int nr_gframes = end_idx + 1;
+	int rc;
+
+	frames = kmalloc(nr_gframes * sizeof(unsigned long), GFP_ATOMIC);
+	if (!frames)
+		return -ENOMEM;
+
+	setup.dom        = DOMID_SELF;
+	setup.nr_frames  = nr_gframes;
+	setup.frame_list = frames;
+
+	rc = HYPERVISOR_grant_table_op(GNTTABOP_setup_table, &setup, 1);
+	if (rc == -ENOSYS) {
+		kfree(frames);
+		return -ENOSYS;
+	}
+
+	BUG_ON(rc || setup.status);
+
+	if (shared == NULL) {
+		struct vm_struct *area;
+		area = alloc_vm_area(PAGE_SIZE * max_nr_grant_frames());
+		BUG_ON(area == NULL);
+		shared = area->addr;
+	}
+	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
+				 PAGE_SIZE * nr_gframes,
+				 map_pte_fn, &frames);
+	BUG_ON(rc);
+	frames -= nr_gframes; /* adjust after map_pte_fn() */
+
+	kfree(frames);
+
+	return 0;
+}
+
+int gnttab_resume(void)
+{
+	if (max_nr_grant_frames() < nr_grant_frames)
+		return -ENOSYS;
+	return gnttab_map(0, nr_grant_frames - 1);
+}
+
+int gnttab_suspend(void)
+{
+	apply_to_page_range(&init_mm, (unsigned long)shared,
+			    PAGE_SIZE * nr_grant_frames,
+			    unmap_pte_fn, NULL);
+
+	return 0;
+}
+
+static int gnttab_expand(unsigned int req_entries)
+{
+	int rc;
+	unsigned int cur, extra;
+
+	cur = nr_grant_frames;
+	extra = ((req_entries + (GREFS_PER_GRANT_FRAME-1)) /
+		 GREFS_PER_GRANT_FRAME);
+	if (cur + extra > max_nr_grant_frames())
+		return -ENOSPC;
+
+	if ((rc = gnttab_map(cur, cur + extra - 1)) == 0)
+		rc = grow_gnttab_list(extra);
+
+	return rc;
+}
+
+static int __devinit gnttab_init(void)
+{
+	int i;
+	unsigned int max_nr_glist_frames;
+	unsigned int nr_init_grefs;
+
+	if (!is_running_on_xen())
+		return -ENODEV;
+
+	nr_grant_frames = 1;
+	boot_max_nr_grant_frames = __max_nr_grant_frames();
+
+	/* Determine the maximum number of frames required for the
+	 * grant reference free list on the current hypervisor.
+	 */
+	max_nr_glist_frames = (boot_max_nr_grant_frames *
+			       GREFS_PER_GRANT_FRAME /
+			       (PAGE_SIZE / sizeof(grant_ref_t)));
+
+	gnttab_list = kmalloc(max_nr_glist_frames * sizeof(grant_ref_t *),
+			      GFP_KERNEL);
+	if (gnttab_list == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_grant_frames; i++) {
+		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
+		if (gnttab_list[i] == NULL)
+			goto ini_nomem;
+	}
+
+	if (gnttab_resume() < 0)
+		return -ENODEV;
+
+	nr_init_grefs = nr_grant_frames * GREFS_PER_GRANT_FRAME;
+
+	for (i = NR_RESERVED_ENTRIES; i < nr_init_grefs - 1; i++)
+		gnttab_entry(i) = i + 1;
+
+	gnttab_entry(nr_init_grefs - 1) = GNTTAB_LIST_END;
+	gnttab_free_count = nr_init_grefs - NR_RESERVED_ENTRIES;
+	gnttab_free_head  = NR_RESERVED_ENTRIES;
+
+	printk("Grant table initialized\n");
+	return 0;
+
+ ini_nomem:
+	for (i--; i >= 0; i--)
+		free_page((unsigned long)gnttab_list[i]);
+	kfree(gnttab_list);
+	return -ENOMEM;
+}
+
+core_initcall(gnttab_init);
===================================================================
--- /dev/null
+++ b/include/xen/grant_table.h
@@ -0,0 +1,107 @@
+/******************************************************************************
+ * grant_table.h
+ *
+ * Two sets of functionality:
+ * 1. Granting foreign access to our memory reservation.
+ * 2. Accessing others' memory reservations via grant references.
+ * (i.e., mechanisms for both sender and recipient of grant references)
+ *
+ * Copyright (c) 2004-2005, K A Fraser
+ * Copyright (c) 2005, Christopher Clark
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __ASM_GNTTAB_H__
+#define __ASM_GNTTAB_H__
+
+#include <asm/xen/hypervisor.h>
+#include <xen/interface/grant_table.h>
+
+/* NR_GRANT_FRAMES must be less than or equal to that configured in Xen */
+#define NR_GRANT_FRAMES 4
+
+struct gnttab_free_callback {
+	struct gnttab_free_callback *next;
+	void (*fn)(void *);
+	void *arg;
+	u16 count;
+};
+
+int gnttab_grant_foreign_access(domid_t domid, unsigned long frame,
+				int readonly);
+
+/*
+ * End access through the given grant reference, iff the grant entry is no
+ * longer in use.  Return 1 if the grant entry was freed, 0 if it is still in
+ * use.
+ */
+int gnttab_end_foreign_access_ref(grant_ref_t ref, int readonly);
+
+/*
+ * Eventually end access through the given grant reference, and once that
+ * access has been ended, free the given page too.  Access will be ended
+ * immediately iff the grant entry is not in use, otherwise it will happen
+ * some time later.  page may be 0, in which case no freeing will occur.
+ */
+void gnttab_end_foreign_access(grant_ref_t ref, int readonly,
+			       unsigned long page);
+
+int gnttab_grant_foreign_transfer(domid_t domid, unsigned long pfn);
+
+unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref);
+unsigned long gnttab_end_foreign_transfer(grant_ref_t ref);
+
+int gnttab_query_foreign_access(grant_ref_t ref);
+
+/*
+ * operations on reserved batches of grant references
+ */
+int gnttab_alloc_grant_references(u16 count, grant_ref_t *pprivate_head);
+
+void gnttab_free_grant_reference(grant_ref_t ref);
+
+void gnttab_free_grant_references(grant_ref_t head);
+
+int gnttab_empty_grant_references(const grant_ref_t *pprivate_head);
+
+int gnttab_claim_grant_reference(grant_ref_t *pprivate_head);
+
+void gnttab_release_grant_reference(grant_ref_t *private_head,
+				    grant_ref_t release);
+
+void gnttab_request_free_callback(struct gnttab_free_callback *callback,
+				  void (*fn)(void *), void *arg, u16 count);
+void gnttab_cancel_free_callback(struct gnttab_free_callback *callback);
+
+void gnttab_grant_foreign_access_ref(grant_ref_t ref, domid_t domid,
+				     unsigned long frame, int readonly);
+
+void gnttab_grant_foreign_transfer_ref(grant_ref_t, domid_t domid,
+				       unsigned long pfn);
+
+#define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
+
+#endif /* __ASM_GNTTAB_H__ */
===================================================================
--- a/include/xen/interface/grant_table.h
+++ b/include/xen/interface/grant_table.h
@@ -1,8 +1,26 @@
 /******************************************************************************
  * grant_table.h
- *
+ *
  * Interface for granting foreign access to page frames, and receiving
  * page-ownership transfers.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
  *
  * Copyright (c) 2004, K A Fraser
  */
@@ -17,11 +35,11 @@
 
 /* Some rough guidelines on accessing and updating grant-table entries
  * in a concurrency-safe manner. For more information, Linux contains a
- * reference implementation for guest OSes (arch/i386/mach-xen/grant_table.c).
- *
+ * reference implementation for guest OSes (arch/xen/kernel/grant_table.c).
+ *
  * NB. WMB is a no-op on current-generation x86 processors. However, a
  *     compiler barrier will still be required.
- *
+ *
  * Introducing a valid entry into the grant table:
  *  1. Write ent->domid.
  *  2. Write ent->frame:
@@ -30,7 +48,7 @@
  *                           frame, or zero if none.
  *  3. Write memory barrier (WMB).
  *  4. Write ent->flags, inc. valid type.
- *
+ *
  * Invalidating an unused GTF_permit_access entry:
  *  1. flags = ent->flags.
  *  2. Observe that !(flags & (GTF_reading|GTF_writing)).
@@ -42,7 +60,7 @@
  *  This cannot be done directly. Request assistance from the domain controller
  *  which can set a timeout on the use of a grant entry and take necessary
  *  action. (NB. This is not yet implemented!).
- *
+ *
  * Invalidating an unused GTF_accept_transfer entry:
  *  1. flags = ent->flags.
  *  2. Observe that !(flags & GTF_transfer_committed). [*]
@@ -60,7 +78,7 @@
  *
  * Changing a GTF_permit_access from writable to read-only:
  *  Use SMP-safe CMPXCHG to set GTF_readonly, while checking !GTF_writing.
- *
+ *
  * Changing a GTF_permit_access from read-only to writable:
  *  Use SMP-safe bit-setting instruction.
  */
@@ -144,12 +162,12 @@ typedef uint32_t grant_handle_t;
  * that must be presented later to destroy the mapping(s). On error, <handle>
  * is a negative status code.
  * NOTES:
- *  1. If GNTPIN_map_for_dev is specified then <dev_bus_addr> is the address
+ *  1. If GNTMAP_device_map is specified then <dev_bus_addr> is the address
  *     via which I/O devices may access the granted frame.
- *  2. If GNTPIN_map_for_host is specified then a mapping will be added at
+ *  2. If GNTMAP_host_map is specified then a mapping will be added at
  *     either a host virtual address in the current address space, or at
  *     a PTE at the specified machine address.  The type of mapping to
- *     perform is selected through the GNTMAP_contains_pte flag, and the
+ *     perform is selected through the GNTMAP_contains_pte flag, and the
  *     address is specified in <host_addr>.
  *  3. Mappings should only be destroyed via GNTTABOP_unmap_grant_ref. If a
  *     host mapping is destroyed by other means then it is *NOT* guaranteed
@@ -167,7 +185,6 @@ struct gnttab_map_grant_ref {
     grant_handle_t handle;
     uint64_t dev_bus_addr;
 };
-DEFINE_GUEST_HANDLE_STRUCT(gnttab_map_grant_ref);
 
 /*
  * GNTTABOP_unmap_grant_ref: Destroy one or more grant-reference mappings
@@ -189,7 +206,6 @@ struct gnttab_unmap_grant_ref {
     /* OUT parameters. */
     int16_t  status;              /* GNTST_* */
 };
-DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_grant_ref);
 
 /*
  * GNTTABOP_setup_table: Set up a grant table for <dom> comprising at least
@@ -207,9 +223,8 @@ struct gnttab_setup_table {
     uint32_t nr_frames;
     /* OUT parameters. */
     int16_t  status;              /* GNTST_* */
-    GUEST_HANDLE(ulong) frame_list;
-};
-DEFINE_GUEST_HANDLE_STRUCT(gnttab_setup_table);
+    ulong *frame_list;
+};
 
 /*
  * GNTTABOP_dump_table: Dump the contents of the grant table to the
@@ -222,13 +237,12 @@ struct gnttab_dump_table {
     /* OUT parameters. */
     int16_t status;               /* GNTST_* */
 };
-DEFINE_GUEST_HANDLE_STRUCT(gnttab_dump_table);
 
 /*
  * GNTTABOP_transfer_grant_ref: Transfer <frame> to a foreign domain. The
  * foreign domain has previously registered its interest in the transfer via
  * <domid, ref>.
- *
+ *
  * Note that, even if the transfer fails, the specified page no longer belongs
  * to the calling domain *unless* the error is GNTST_bad_page.
  */
@@ -241,7 +255,65 @@ struct gnttab_transfer {
     /* OUT parameters. */
     int16_t       status;
 };
-DEFINE_GUEST_HANDLE_STRUCT(gnttab_transfer);
+
+
+/*
+ * GNTTABOP_copy: Hypervisor based copy
+ * source and destinations can be eithers MFNs or, for foreign domains,
+ * grant references. the foreign domain has to grant read/write access
+ * in its grant table.
+ *
+ * The flags specify what type source and destinations are (either MFN
+ * or grant reference).
+ *
+ * Note that this can also be used to copy data between two domains
+ * via a third party if the source and destination domains had previously
+ * grant appropriate access to their pages to the third party.
+ *
+ * source_offset specifies an offset in the source frame, dest_offset
+ * the offset in the target frame and  len specifies the number of
+ * bytes to be copied.
+ */
+
+#define _GNTCOPY_source_gref      (0)
+#define GNTCOPY_source_gref       (1<<_GNTCOPY_source_gref)
+#define _GNTCOPY_dest_gref        (1)
+#define GNTCOPY_dest_gref         (1<<_GNTCOPY_dest_gref)
+
+#define GNTTABOP_copy                 5
+struct gnttab_copy {
+    /* IN parameters. */
+    struct {
+        union {
+            grant_ref_t ref;
+            unsigned long   gmfn;
+        } u;
+        domid_t  domid;
+        uint16_t offset;
+    } source, dest;
+    uint16_t      len;
+    uint16_t      flags;          /* GNTCOPY_* */
+    /* OUT parameters. */
+    int16_t       status;
+};
+
+/*
+ * GNTTABOP_query_size: Query the current and maximum sizes of the shared
+ * grant table.
+ * NOTES:
+ *  1. <dom> may be specified as DOMID_SELF.
+ *  2. Only a sufficiently-privileged domain may specify <dom> != DOMID_SELF.
+ */
+#define GNTTABOP_query_size           6
+struct gnttab_query_size {
+    /* IN parameters. */
+    domid_t  dom;
+    /* OUT parameters. */
+    uint32_t nr_frames;
+    uint32_t max_nr_frames;
+    int16_t  status;              /* GNTST_* */
+};
+
 
 /*
  * Bitfield values for update_pin_status.flags.
@@ -284,6 +356,7 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_transf
 #define GNTST_no_device_space  (-7) /* Out of space in I/O MMU.              */
 #define GNTST_permission_denied (-8) /* Not enough privilege for operation.  */
 #define GNTST_bad_page         (-9) /* Specified page was invalid for op.    */
+#define GNTST_bad_copy_arg    (-10) /* copy arguments cross page boundary */
 
 #define GNTTABOP_error_msgs {                   \
     "okay",                                     \
@@ -295,7 +368,8 @@ DEFINE_GUEST_HANDLE_STRUCT(gnttab_transf
     "invalid device address",                   \
     "no spare translation slot in the I/O MMU", \
     "permission denied",                        \
-    "bad page"                                  \
+    "bad page",                                 \
+    "copy arguments cross page boundary"        \
 }
 
 #endif /* __XEN_PUBLIC_GRANT_TABLE_H__ */

-- 

