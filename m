Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbXIKKHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbXIKKHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761548AbXIKKH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:07:26 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:57716 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbXIKKHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:07:25 -0400
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 06:07:25 EDT
Message-Id: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 11 Sep 2007 18:31:12 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] mm: use pagevec to rotate reclaimable page
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
While running some memory intensive load, system response
deteriorated just after swap-out started.

The cause of this problem is that when a PG_reclaim page is
moved to the tail of the inactive LRU list in rotate_reclaimable_page(),
lru_lock spin lock is acquired every page writeback . This deteriorates
system performance and makes interrupt hold off time longer when
swap-out started.

Following patch solves this problem. I use pagevec in rotating reclaimable
pages to mitigate LRU spin lock contention and reduce interrupt
hold off time.

I did a test that allocating and touching pages in multiple processes, and
pinging to the test machine in flooding mode to measure response under
memory intensive load.
The test result is:

	-2.6.23-rc5
	--- testmachine ping statistics ---
	3000 packets transmitted, 3000 received, 0% packet loss, time 53222ms
	rtt min/avg/max/mdev = 0.074/0.652/172.228/7.176 ms, pipe 11, ipg/ewma 
17.746/0.092 ms

	-2.6.23-rc5-patched
	--- testmachine ping statistics ---
	3000 packets transmitted, 3000 received, 0% packet loss, time 51924ms
	rtt min/avg/max/mdev = 0.072/0.108/3.884/0.114 ms, pipe 2, ipg/ewma 
17.314/0.091 ms

Max round-trip-time was improved.

The test machine spec is that 4CPU(3.16GHz, Hyper-threading enabled)
8GB memory , 8GB swap.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.23-rc5.org/include/linux/swap.h 
linux-2.6.23-rc5/include/linux/swap.h
--- linux-2.6.23-rc5.org/include/linux/swap.h	2007-09-06 18:44:06.000000000 +0900
+++ linux-2.6.23-rc5/include/linux/swap.h	2007-09-06 18:45:28.000000000 +0900
@@ -185,6 +185,7 @@ extern void FASTCALL(mark_page_accessed(
  extern void lru_add_drain(void);
  extern int lru_add_drain_all(void);
  extern int rotate_reclaimable_page(struct page *page);
+extern void move_tail_pages(void);
  extern void swap_setup(void);

  /* linux/mm/vmscan.c */
diff -Nrup linux-2.6.23-rc5.org/mm/swap.c linux-2.6.23-rc5/mm/swap.c
--- linux-2.6.23-rc5.org/mm/swap.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.23-rc5/mm/swap.c	2007-09-06 18:45:28.000000000 +0900
@@ -93,25 +93,56 @@ void put_pages_list(struct list_head *pa
  }
  EXPORT_SYMBOL(put_pages_list);

+static void pagevec_move_tail(struct pagevec *pvec)
+{
+	int i;
+	struct zone *zone = NULL;
+	unsigned long flags = 0;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (!PageLRU(page) || !page_count(page))
+			continue;
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+			zone = pagezone;
+			spin_lock_irqsave(&zone->lru_lock, flags);
+		}
+		if (PageLRU(page) && !PageActive(page) && page_count(page)) {
+			list_move_tail(&page->lru, &zone->inactive_list);
+			__count_vm_event(PGROTATED);
+		}
+	}
+	if (zone)
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+	pagevec_reinit(pvec);
+}
+
+static DEFINE_PER_CPU(struct pagevec, rotate_pvecs) = { 0, };
+
+void move_tail_pages()
+{
+	struct pagevec *pvec = &per_cpu(rotate_pvecs, get_cpu());
+
+	if (pagevec_count(pvec))
+		pagevec_move_tail(pvec);
+	put_cpu();
+}
+
  /*
   * Writeback is about to end against a page which has been marked for immediate
   * reclaim.  If it still appears to be reclaimable, move it to the tail of the
- * inactive list.  The page still has PageWriteback set, which will pin it.
- *
- * We don't expect many pages to come through here, so don't bother batching
- * things up.
- *
- * To avoid placing the page at the tail of the LRU while PG_writeback is still
- * set, this function will clear PG_writeback before performing the page
- * motion.  Do that inside the lru lock because once PG_writeback is cleared
- * we may not touch the page.
+ * inactive list.
   *
   * Returns zero if it cleared PG_writeback.
   */
  int rotate_reclaimable_page(struct page *page)
  {
-	struct zone *zone;
-	unsigned long flags;
+	struct pagevec *pvec;

  	if (PageLocked(page))
  		return 1;
@@ -122,15 +153,16 @@ int rotate_reclaimable_page(struct page
  	if (!PageLRU(page))
  		return 1;

-	zone = page_zone(page);
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(page) && !PageActive(page)) {
-		list_move_tail(&page->lru, &zone->inactive_list);
-		__count_vm_event(PGROTATED);
-	}
  	if (!test_clear_page_writeback(page))
  		BUG();
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+
+	if (PageLRU(page) && !PageActive(page) && page_count(page)) {
+		pvec = &get_cpu_var(rotate_pvecs);
+		if (!pagevec_add(pvec, page))
+			pagevec_move_tail(pvec);
+		put_cpu_var(rotate_pvecs);
+	}
+
  	return 0;
  }

@@ -315,6 +347,7 @@ void release_pages(struct page **pages,
   */
  void __pagevec_release(struct pagevec *pvec)
  {
+	move_tail_pages();
  	lru_add_drain();
  	release_pages(pvec->pages, pagevec_count(pvec), pvec->cold);
  	pagevec_reinit(pvec);
diff -Nrup linux-2.6.23-rc5.org/mm/vmscan.c linux-2.6.23-rc5/mm/vmscan.c
--- linux-2.6.23-rc5.org/mm/vmscan.c	2007-09-06 18:44:06.000000000 +0900
+++ linux-2.6.23-rc5/mm/vmscan.c	2007-09-06 18:45:28.000000000 +0900
@@ -792,6 +792,7 @@ static unsigned long shrink_inactive_lis

  	pagevec_init(&pvec, 1);

+	move_tail_pages();
  	lru_add_drain();
  	spin_lock_irq(&zone->lru_lock);
  	do { 

