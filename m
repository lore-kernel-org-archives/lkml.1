Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbZFPTq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbZFPTq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZFPTqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:46:20 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:36915 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbZFPTqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:46:20 -0400
X-Trace: 215940306/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.95.160/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.95.160
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEGAOSTN0pQKV+g/2dsb2JhbACBT9QjgkCBSwU
X-IronPort-AV: E=Sophos;i="4.42,231,1243810800"; 
   d="scan'208";a="215940306"
Date: Tue, 16 Jun 2009 20:45:05 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Rik van Riel <riel@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
In-Reply-To: <4A37EA92.7050509@redhat.com>
Message-ID: <Pine.LNX.4.64.0906162035240.2933@sister.anvils>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random>
 <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <4A37EA92.7050509@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Rik van Riel wrote:
> Hugh Dickins wrote:
> > 
> > Looks like Izik and I hit the same problem (otherwise running well):
> > I too decided we needn't do more than avoid the issue in grab_swap_token.
> > (I've a feeling someone has hit this issue before with some other thread,
> > though I've no idea which - does RHEL include a patch like this perhaps?).
> 
> It looks very familiar, indeed.
> 
> RHEL 4 and 5 both have code like this in the swap token
> code. I seem to remember submitting such code upstream,
> too.
> 
> I have no idea why it never got upstream, maybe I was
> drowned in Xen work at the time, or maybe the bug simply
> didn't happen upstream for whatever reason.

I've a suspicion it got triggered by some out-of-tree module,
and nobody saw the same problem with a vanilla kernel.

> 
> > Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks, Rik.  I don't want to be a nuisance, but somehow, in the hour
since I sent that, I've come to feel it was the right patch to get our
testing back on track, but not really quite the right patch to go forward.
Silly, really, it does not matter much what we do in this case, but I'm
liking the below better - what do you think?  If you approve, I'll send
it in to Andrew for mmotm: I can't quite justify it without KSM.
(checkpatch.pl didn't like "while(0)" so I cleaned up a little.)


[PATCH] mm: pass mm to grab_swap_token

If a kthread happens to use get_user_pages() on an mm (as KSM does),
there's a chance that it will end up trying to read in a swap page,
then oops in grab_swap_token() because the kthread has no mm: GUP
passes down the right mm, so grab_swap_token() ought to be using it.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 include/linux/swap.h |   12 ++++++------
 mm/memory.c          |    2 +-
 mm/thrash.c          |   32 +++++++++++++++-----------------
 3 files changed, 22 insertions(+), 24 deletions(-)

--- 2.6.30/include/linux/swap.h	2009-06-10 04:05:27.000000000 +0100
+++ linux/include/linux/swap.h	2009-06-16 20:29:13.000000000 +0100
@@ -314,8 +314,8 @@ extern int try_to_free_swap(struct page
 struct backing_dev_info;
 
 /* linux/mm/thrash.c */
-extern struct mm_struct * swap_token_mm;
-extern void grab_swap_token(void);
+extern struct mm_struct *swap_token_mm;
+extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
 
 static inline int has_swap_token(struct mm_struct *mm)
@@ -426,10 +426,10 @@ static inline swp_entry_t get_swap_page(
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
 
 static inline int mem_cgroup_cache_charge_swapin(struct page *page,
 			struct mm_struct *mm, gfp_t mask, bool locked)
--- 2.6.30/mm/memory.c	2009-06-10 04:05:27.000000000 +0100
+++ linux/mm/memory.c	2009-06-16 20:29:13.000000000 +0100
@@ -2466,7 +2466,7 @@ static int do_swap_page(struct mm_struct
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
-		grab_swap_token(); /* Contend for token _before_ read-in */
+		grab_swap_token(mm); /* Contend for token _before_ read-in */
 		page = swapin_readahead(entry,
 					GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!page) {
--- 2.6.30/mm/thrash.c	2007-07-09 00:32:17.000000000 +0100
+++ linux/mm/thrash.c	2009-06-16 20:29:13.000000000 +0100
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
