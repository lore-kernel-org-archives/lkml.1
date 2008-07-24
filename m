Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYGXX3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYGXX3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYGXX2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:28:06 -0400
Received: from gw.goop.org ([64.81.55.164]:38215 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbYGXX2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:28:04 -0400
Message-ID: <48891000.1040106@goop.org>
Date: Thu, 24 Jul 2008 16:28:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] xen-balloon: clean up unused functions
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unused functions:

balloon_update_driver_allowance
balloon_release_driver_page
	only used on the (obsolete, removed) flip path in netfront
alloc_empty_pages_and_pagevec
free_empty_pages_and_pagevec
	only used in backend drivers; can be reintroduced when needed

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/balloon.c |  147 +------------------------------------------------
 1 file changed, 3 insertions(+), 144 deletions(-)

===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -226,9 +226,8 @@
 	}
 
 	set_xen_guest_handle(reservation.extent_start, frame_list);
-	reservation.nr_extents   = nr_pages;
-	rc = HYPERVISOR_memory_op(
-		XENMEM_populate_physmap, &reservation);
+	reservation.nr_extents = nr_pages;
+	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
 	if (rc < nr_pages) {
 		if (rc > 0) {
 			int ret;
@@ -236,7 +235,7 @@
 			/* We hit the Xen hard limit: reprobe. */
 			reservation.nr_extents = rc;
 			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-					&reservation);
+						   &reservation);
 			BUG_ON(ret != rc);
 		}
 		if (rc >= 0)
@@ -464,130 +463,6 @@
 
 module_exit(balloon_exit);
 
-static void balloon_update_driver_allowance(long delta)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&balloon_lock, flags);
-	balloon_stats.driver_pages += delta;
-	spin_unlock_irqrestore(&balloon_lock, flags);
-}
-
-static int dealloc_pte_fn(
-	pte_t *pte, struct page *pmd_page, unsigned long addr, void *data)
-{
-	unsigned long mfn = pte_mfn(*pte);
-	int ret;
-	struct xen_memory_reservation reservation = {
-		.nr_extents   = 1,
-		.extent_order = 0,
-		.domid        = DOMID_SELF
-	};
-	set_xen_guest_handle(reservation.extent_start, &mfn);
-	set_pte_at(&init_mm, addr, pte, __pte_ma(0ull));
-	set_phys_to_machine(__pa(addr) >> PAGE_SHIFT, INVALID_P2M_ENTRY);
-	ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
-	BUG_ON(ret != 1);
-	return 0;
-}
-
-static struct page **alloc_empty_pages_and_pagevec(int nr_pages)
-{
-	unsigned long vaddr, flags;
-	struct page *page, **pagevec;
-	int i, ret;
-
-	pagevec = kmalloc(sizeof(page) * nr_pages, GFP_KERNEL);
-	if (pagevec == NULL)
-		return NULL;
-
-	for (i = 0; i < nr_pages; i++) {
-		page = pagevec[i] = alloc_page(GFP_KERNEL);
-		if (page == NULL)
-			goto err;
-
-		vaddr = (unsigned long)page_address(page);
-
-		scrub_page(page);
-
-		spin_lock_irqsave(&balloon_lock, flags);
-
-		if (xen_feature(XENFEAT_auto_translated_physmap)) {
-			unsigned long gmfn = page_to_pfn(page);
-			struct xen_memory_reservation reservation = {
-				.nr_extents   = 1,
-				.extent_order = 0,
-				.domid        = DOMID_SELF
-			};
-			set_xen_guest_handle(reservation.extent_start, &gmfn);
-			ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-						   &reservation);
-			if (ret == 1)
-				ret = 0; /* success */
-		} else {
-			ret = apply_to_page_range(&init_mm, vaddr, PAGE_SIZE,
-						  dealloc_pte_fn, NULL);
-		}
-
-		if (ret != 0) {
-			spin_unlock_irqrestore(&balloon_lock, flags);
-			__free_page(page);
-			goto err;
-		}
-
-		totalram_pages = --balloon_stats.current_pages;
-
-		spin_unlock_irqrestore(&balloon_lock, flags);
-	}
-
- out:
-	schedule_work(&balloon_worker);
-	flush_tlb_all();
-	return pagevec;
-
- err:
-	spin_lock_irqsave(&balloon_lock, flags);
-	while (--i >= 0)
-		balloon_append(pagevec[i]);
-	spin_unlock_irqrestore(&balloon_lock, flags);
-	kfree(pagevec);
-	pagevec = NULL;
-	goto out;
-}
-
-static void free_empty_pages_and_pagevec(struct page **pagevec, int nr_pages)
-{
-	unsigned long flags;
-	int i;
-
-	if (pagevec == NULL)
-		return;
-
-	spin_lock_irqsave(&balloon_lock, flags);
-	for (i = 0; i < nr_pages; i++) {
-		BUG_ON(page_count(pagevec[i]) != 1);
-		balloon_append(pagevec[i]);
-	}
-	spin_unlock_irqrestore(&balloon_lock, flags);
-
-	kfree(pagevec);
-
-	schedule_work(&balloon_worker);
-}
-
-static void balloon_release_driver_page(struct page *page)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&balloon_lock, flags);
-	balloon_append(page);
-	balloon_stats.driver_pages--;
-	spin_unlock_irqrestore(&balloon_lock, flags);
-
-	schedule_work(&balloon_worker);
-}
-
-
 #define BALLOON_SHOW(name, format, args...)				\
 	static ssize_t show_##name(struct sys_device *dev,		\
 				   struct sysdev_attribute *attr,	\
@@ -691,20 +566,4 @@
 	return error;
 }
 
-static void unregister_balloon(struct sys_device *sysdev)
-{
-	int i;
-
-	sysfs_remove_group(&sysdev->kobj, &balloon_info_group);
-	for (i = 0; i < ARRAY_SIZE(balloon_attrs); i++)
-		sysdev_remove_file(sysdev, balloon_attrs[i]);
-	sysdev_unregister(sysdev);
-	sysdev_class_unregister(&balloon_sysdev_class);
-}
-
-static void balloon_sysfs_exit(void)
-{
-	unregister_balloon(&balloon_sysdev);
-}
-
 MODULE_LICENSE("GPL");


