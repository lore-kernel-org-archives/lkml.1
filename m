Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZFPVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZFPVyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbZFPVyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:54:13 -0400
Received: from cmpxchg.org ([85.214.51.133]:53274 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbZFPVyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:54:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 2/2] mm: remove task assumptions from swap token
Date: Tue, 16 Jun 2009 23:50:37 +0200
Message-Id: <1245189037-22961-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
References: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

grab_swap_token() should not make any assumptions about the running
process as the swap token is an attribute of the address space and the
faulting mm is not necessarily current->mm.

This fixes get_user_pages() from kernel threads which would blow up
when encountering a swapped out page and grab_swap_token()
dereferencing the unset for kernel threads current->mm.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/swap.h |    4 ++--
 mm/memory.c          |    2 +-
 mm/thrash.c          |   31 +++++++++++++++----------------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3c6e856..e73ea8a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -315,7 +315,7 @@ struct backing_dev_info;
 
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
-extern void grab_swap_token(void);
+extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
 
 static inline int has_swap_token(struct mm_struct *mm)
@@ -430,7 +430,7 @@ static inline void put_swap_token(struct mm_struct *mm)
 {
 }
 
-static inline void grab_swap_token(void)
+static inline void grab_swap_token(struct mm_struct *mm)
 {
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 4126dd1..862e120 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2466,7 +2466,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
-		grab_swap_token(); /* Contend for token _before_ read-in */
+		grab_swap_token(mm); /* Contend for token _before_ read-in */
 		page = swapin_readahead(entry,
 					GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!page) {
diff --git a/mm/thrash.c b/mm/thrash.c
index c4c5205..8b864ae 100644
--- a/mm/thrash.c
+++ b/mm/thrash.c
@@ -26,47 +26,46 @@ static DEFINE_SPINLOCK(swap_token_lock);
 struct mm_struct *swap_token_mm;
 static unsigned int global_faults;
 
-void grab_swap_token(void)
+void grab_swap_token(struct mm_struct *mm)
 {
 	int current_interval;
 
 	global_faults++;
 
-	current_interval = global_faults - current->mm->faultstamp;
+	current_interval = global_faults - mm->faultstamp;
 
 	if (!spin_trylock(&swap_token_lock))
 		return;
 
 	/* First come first served */
 	if (swap_token_mm == NULL) {
-		current->mm->token_priority = current->mm->token_priority + 2;
-		swap_token_mm = current->mm;
+		mm->token_priority = mm->token_priority + 2;
+		swap_token_mm = mm;
 		goto out;
 	}
 
-	if (current->mm != swap_token_mm) {
-		if (current_interval < current->mm->last_interval)
-			current->mm->token_priority++;
+	if (mm != swap_token_mm) {
+		if (current_interval < mm->last_interval)
+			mm->token_priority++;
 		else {
-			if (likely(current->mm->token_priority > 0))
-				current->mm->token_priority--;
+			if (likely(mm->token_priority > 0))
+				mm->token_priority--;
 		}
 		/* Check if we deserve the token */
-		if (current->mm->token_priority >
+		if (mm->token_priority >
 				swap_token_mm->token_priority) {
-			current->mm->token_priority += 2;
-			swap_token_mm = current->mm;
+			mm->token_priority += 2;
+			swap_token_mm = mm;
 		}
 	} else {
 		/* Token holder came in again! */
-		current->mm->token_priority += 2;
+		mm->token_priority += 2;
 	}
 
 out:
-	current->mm->faultstamp = global_faults;
-	current->mm->last_interval = current_interval;
+	mm->faultstamp = global_faults;
+	mm->last_interval = current_interval;
 	spin_unlock(&swap_token_lock);
-return;
 }
 
 /* Called on process exit. */
-- 
1.6.3

