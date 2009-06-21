Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZFUNC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZFUNC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZFUNCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:02:49 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:42079 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbZFUNCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:02:48 -0400
X-Trace: 218412043/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.3.39/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.3.39
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiUFAJ/MPUpQKQMn/2dsb2JhbACBUcpihAoF
X-IronPort-AV: E=Sophos;i="4.42,262,1243810800"; 
   d="scan'208";a="218412043"
Date: Sun, 21 Jun 2009 14:02:43 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: pass mm to grab_swap_token
In-Reply-To: <20090616215200.GA19781@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0906211326520.6124@sister.anvils>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random>
 <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <20090616200852.GA16265@cmpxchg.org>
 <Pine.LNX.4.64.0906162152250.12770@sister.anvils> <20090616215200.GA19781@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a kthread happens to use get_user_pages() on an mm (as KSM does),
there's a chance that it will end up trying to read in a swap page,
then oops in grab_swap_token() because the kthread has no mm: GUP
passes down the right mm, so grab_swap_token() ought to be using it.

We have not identified a stronger case than KSM's daemon (not yet
in mainline), but the issue must have come up before, since RHEL has
included a fix for this for years (though a different fix, they just
back out of grab_swap_token if current->mm is unset: which is what
we first proposed, but using the right mm here seems more correct).

Reported-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Rik van Riel <riel@redhat.com>
---
Includes a small swap.h tidyup inspired by checkpatch.pl.
Due to crossed mails and crossed wires, there's a competing
patch-pair from Hannes:

http://lkml.org/lkml/2009/6/16/623
http://lkml.org/lkml/2009/6/16/624

We're all agreed that either this or those should go into 2.6.31:
personally, I don't rate arg typechecking of null functions when
!CONFIG_SWAP very highly, and prefer the one-line macros of Rik's
original; but you may well disagree, and prefer to take Hannes's.

 include/linux/swap.h |   12 ++++++------
 mm/memory.c          |    2 +-
 mm/thrash.c          |   32 +++++++++++++++-----------------
 3 files changed, 22 insertions(+), 24 deletions(-)

--- 2.6.30-git17/include/linux/swap.h	2009-06-21 07:48:18.000000000 +0100
+++ linux/include/linux/swap.h	2009-06-21 09:35:51.000000000 +0100
@@ -298,8 +298,8 @@ extern int try_to_free_swap(struct page
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
-extern struct mm_struct * swap_token_mm;
-extern void grab_swap_token(void);
+extern struct mm_struct *swap_token_mm;
+extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
 
 static inline int has_swap_token(struct mm_struct *mm)
@@ -419,10 +419,10 @@ static inline swp_entry_t get_swap_page(
 }
 
 /* linux/mm/thrash.c */
-#define put_swap_token(x) do { } while(0)
-#define grab_swap_token()  do { } while(0)
-#define has_swap_token(x) 0
-#define disable_swap_token() do { } while(0)
+#define put_swap_token(mm)	do { } while (0)
+#define grab_swap_token(mm)	do { } while (0)
+#define has_swap_token(mm)	0
+#define disable_swap_token()	do { } while (0)
 
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
--- 2.6.30-git17/mm/memory.c	2009-06-21 07:48:19.000000000 +0100
+++ linux/mm/memory.c	2009-06-21 09:35:51.000000000 +0100
@@ -2516,7 +2516,7 @@ static int do_swap_page(struct mm_struct
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
-		grab_swap_token(); /* Contend for token _before_ read-in */
+		grab_swap_token(mm); /* Contend for token _before_ read-in */
 		page = swapin_readahead(entry,
 					GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!page) {
--- 2.6.30-git17/mm/thrash.c	2007-07-09 00:32:17.000000000 +0100
+++ linux/mm/thrash.c	2009-06-21 09:35:51.000000000 +0100
@@ -26,47 +26,45 @@ static DEFINE_SPINLOCK(swap_token_lock);
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
-				swap_token_mm->token_priority) {
-			current->mm->token_priority += 2;
-			swap_token_mm = current->mm;
+		if (mm->token_priority > swap_token_mm->token_priority) {
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
