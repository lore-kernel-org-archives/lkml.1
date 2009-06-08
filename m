Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbZFHQqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbZFHQqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZFHQq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:46:28 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:12022 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbZFHQq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:46:27 -0400
X-Trace: 208050801/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.53.96/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.53.96
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAGPdLEpPRTVg/2dsb2JhbACBT8xSgjyBTgU
X-IronPort-AV: E=Sophos;i="4.41,325,1241391600"; 
   d="scan'208";a="208050801"
Date: Mon, 8 Jun 2009 17:35:36 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: aarcange@redhat.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       chrisw@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH mmotm] ksm: stop scan skipping pages
In-Reply-To: <Pine.LNX.4.64.0906081555360.22943@sister.anvils>
Message-ID: <Pine.LNX.4.64.0906081733390.7729@sister.anvils>
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906081555360.22943@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KSM can be slow to identify all mergeable pages.  There's an off-by-one
in how ksm_scan_start() proceeds (see how it does a scan_get_next_index
at the head of its loop, but also on leaving its loop), which causes it
to skip over a page occasionally.  Fix that.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/ksm.c |   46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

--- mmotm/mm/ksm.c	2009-06-08 13:14:36.000000000 +0100
+++ fixed/mm/ksm.c	2009-06-08 13:18:30.000000000 +0100
@@ -1331,30 +1331,26 @@ out:
 /* return -EAGAIN - no slots registered, nothing to be done */
 static int scan_get_next_index(struct ksm_scan *ksm_scan)
 {
-	struct ksm_mem_slot *slot;
+	struct list_head *next;
 
 	if (list_empty(&slots))
 		return -EAGAIN;
 
-	slot = ksm_scan->slot_index;
-
 	/* Are there pages left in this slot to scan? */
-	if ((slot->npages - ksm_scan->page_index - 1) > 0) {
-		ksm_scan->page_index++;
+	ksm_scan->page_index++;
+	if (ksm_scan->page_index < ksm_scan->slot_index->npages)
 		return 0;
-	}
 
-	list_for_each_entry_from(slot, &slots, link) {
-		if (slot == ksm_scan->slot_index)
-			continue;
-		ksm_scan->page_index = 0;
-		ksm_scan->slot_index = slot;
+	ksm_scan->page_index = 0;
+	next = ksm_scan->slot_index->link.next;
+	if (next != &slots) {
+		ksm_scan->slot_index =
+			list_entry(next, struct ksm_mem_slot, link);
 		return 0;
 	}
 
 	/* look like we finished scanning the whole memory, starting again */
 	root_unstable_tree = RB_ROOT;
-	ksm_scan->page_index = 0;
 	ksm_scan->slot_index = list_first_entry(&slots,
 						struct ksm_mem_slot, link);
 	return 0;
@@ -1366,21 +1362,22 @@ static int scan_get_next_index(struct ks
  * pointed to was released so we have to call this function every time after
  * taking the slots_lock
  */
-static void scan_update_old_index(struct ksm_scan *ksm_scan)
+static int scan_update_old_index(struct ksm_scan *ksm_scan)
 {
 	struct ksm_mem_slot *slot;
 
 	if (list_empty(&slots))
-		return;
+		return -EAGAIN;
 
 	list_for_each_entry(slot, &slots, link) {
 		if (ksm_scan->slot_index == slot)
-			return;
+			return 0;
 	}
 
 	ksm_scan->slot_index = list_first_entry(&slots,
 						struct ksm_mem_slot, link);
 	ksm_scan->page_index = 0;
+	return 0;
 }
 
 /**
@@ -1399,20 +1396,14 @@ static int ksm_scan_start(struct ksm_sca
 	struct ksm_mem_slot *slot;
 	struct page *page[1];
 	int val;
-	int ret = 0;
+	int ret;
 
 	down_read(&slots_lock);
+	ret = scan_update_old_index(ksm_scan);
 
-	scan_update_old_index(ksm_scan);
-
-	while (scan_npages > 0) {
-		ret = scan_get_next_index(ksm_scan);
-		if (ret)
-			goto out;
-
-		slot = ksm_scan->slot_index;
-
+	while (scan_npages && !ret) {
 		cond_resched();
+		slot = ksm_scan->slot_index;
 
 		/*
 		 * If the page is swapped out or in swap cache, we don't want to
@@ -1433,10 +1424,11 @@ static int ksm_scan_start(struct ksm_sca
 		} else {
 			up_read(&slot->mm->mmap_sem);
 		}
+
+		ret = scan_get_next_index(ksm_scan);
 		scan_npages--;
 	}
-	scan_get_next_index(ksm_scan);
-out:
+
 	up_read(&slots_lock);
 	return ret;
 }
