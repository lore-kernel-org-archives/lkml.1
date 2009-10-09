Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZJICWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZJICWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 22:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbZJICWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 22:22:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43756 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690AbZJICWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 22:22:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Oleg Nesterov <onestero@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [resend][PATCH v2] mlock() doesn't wait to finish lru_add_drain_all()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20091009111709.1291.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Oct 2009 11:21:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changelog
  since v1
    - rewrote description
    - fold patch 1/2 and 2/2

==========================================================
Recently, Mike Galbraith reported mlock() makes hang-up very long time in
his system. Peter Zijlstra explainted the reason.

  Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
  cpu0 does mlock()->lru_add_drain_all(), which does
  schedule_on_each_cpu(), which then waits for all cpus to complete the
  work. Except that cpu1, which is busy with the RT task, will never run
  keventd until the RT load goes away.

  This is not so much an actual deadlock as a serious starvation case.

His system has two partions using cpusets and RT-task partion cpu doesn't
have any PCP cache. thus, this result was pretty unexpected.

The fact is, mlock() doesn't need to wait to finish lru_add_drain_all().
if mlock() can't turn on PG_mlock, vmscan turn it on later.

Thus, this patch replace it with lru_add_drain_all_async().


Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Reported-by: Mike Galbraith <efault@gmx.de> 
Cc: Oleg Nesterov <onestero@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/swap.h |    1 +
 mm/mlock.c           |    4 ++--
 mm/swap.c            |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

Index: b/include/linux/swap.h
===================================================================
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -204,6 +204,7 @@ extern void activate_page(struct page *)
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
+extern int lru_add_drain_all_async(void);
 extern void rotate_reclaimable_page(struct page *page);
 extern void swap_setup(void);
 
Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -38,6 +38,7 @@ int page_cluster;
 
 static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
+static DEFINE_PER_CPU(struct work_struct, lru_drain_work);
 
 /*
  * This path almost never happens for VM activity - pages are normally
@@ -312,6 +313,24 @@ int lru_add_drain_all(void)
 }
 
 /*
+ * Returns 0 for success
+ */
+int lru_add_drain_all_async(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		struct work_struct *work = &per_cpu(lru_drain_work, cpu);
+		schedule_work_on(cpu, work);
+	}
+	put_online_cpus();
+
+	return 0;
+}
+
+
+/*
  * Batched page_cache_release().  Decrement the reference count on all the
  * passed pages.  If it fell to zero then remove the page from the LRU and
  * free it.
@@ -497,6 +516,7 @@ EXPORT_SYMBOL(pagevec_lookup_tag);
 void __init swap_setup(void)
 {
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
+	int cpu;
 
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
@@ -511,4 +531,8 @@ void __init swap_setup(void)
 	 * Right now other parts of the system means that we
 	 * _really_ don't want to cluster much more
 	 */
+
+	for_each_possible_cpu(cpu) {
+		INIT_WORK(&per_cpu(lru_drain_work, cpu), lru_add_drain_per_cpu);
+	}
 }
Index: b/mm/mlock.c
===================================================================
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -481,7 +481,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, st
 	if (!can_do_mlock())
 		return -EPERM;
 
-	lru_add_drain_all();	/* flush pagevec */
+	lru_add_drain_all_async();	/* flush pagevec */
 
 	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
@@ -549,7 +549,7 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		goto out;
 
-	lru_add_drain_all();	/* flush pagevec */
+	lru_add_drain_all_async();	/* flush pagevec */
 
 	down_write(&current->mm->mmap_sem);
 


