Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZFPUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZFPUMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFPUMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:12:01 -0400
Received: from cmpxchg.org ([85.214.51.133]:43136 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZFPUMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:12:00 -0400
Date: Tue, 16 Jun 2009 22:08:52 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
Message-ID: <20090616200852.GA16265@cmpxchg.org>
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906161930050.24878@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 07:38:39PM +0100, Hugh Dickins wrote:
> On Tue, 16 Jun 2009, Andrea Arcangeli wrote:
> > On Tue, Jun 16, 2009 at 09:05:27PM +0300, Izik Eidus wrote:
> > > So the question is: is this thing is by desgin? (that kernel thread cant 
> > > call get_user_pages???), should i use something like switch_mm()??
> > 
> > I think switch_mm trick should be used for page faults, but gup
> > shouldn't require it because it gets the 'mm' as parameter and the
> > current->mm has to be irrelevant. current->mm is only relevant for
> > gup-fast (obviously :). So I think the only bit that needs fixing is
> > grab_swap_token to not run if current->mm is null.
> 
> Looks like Izik and I hit the same problem (otherwise running well):
> I too decided we needn't do more than avoid the issue in grab_swap_token.
> (I've a feeling someone has hit this issue before with some other thread,
> though I've no idea which - does RHEL include a patch like this perhaps?).
> 
> [PATCH] mm: grab_swap_token back out if no mm
> 
> If a kthread happens to use get_user_pages() on an mm (as KSM does),
> there's a chance that it will end up trying to read in a swap page,
> and oops in grab_swap_token() because the kthread has no mm:
> nothing clever, just avoid that case.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  mm/thrash.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- 2.6.30-mm1/mm/thrash.c	2007-07-09 00:32:17.000000000 +0100
> +++ linux/mm/thrash.c	2009-06-15 19:44:53.000000000 +0100
> @@ -30,6 +30,9 @@ void grab_swap_token(void)
>  {
>  	int current_interval;
>  
> +	if (!current->mm)	/* kthread doing get_user_pages on an mm */
> +		return;
> +

Did you have a particular reason not to pass in the faulting mm
instead?

As the swap token should only care about the faulting address space
leading to swap io and not about the running process anyway, we could
do it like below and remove all those pesky current->derefs in the
same go.  What do you think?

	Hannes

---
Subject: mm: remove task assumptions from swap token

grab_swap_token() should not make any assumptions about the running
process as the swap token is an attribute of the address space and the
faulting mm is not necessarily current->mm.

This fixes get_user_pages() from kernel threads which would blow up
when encountering a swapped out page and grab_swap_token()
dereferencing the unset for kernel threads current->mm.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d476aad..9fe314b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -315,7 +315,7 @@ struct backing_dev_info;
 
 /* linux/mm/thrash.c */
 extern struct mm_struct * swap_token_mm;
-extern void grab_swap_token(void);
+extern void grab_swap_token(struct mm_struct *);
 extern void __put_swap_token(struct mm_struct *);
 
 static inline int has_swap_token(struct mm_struct *mm)
@@ -427,7 +427,7 @@ static inline swp_entry_t get_swap_page(void)
 
 /* linux/mm/thrash.c */
 #define put_swap_token(x) do { } while(0)
-#define grab_swap_token()  do { } while(0)
+#define grab_swap_token(x)  do { } while(0)
 #define has_swap_token(x) 0
 #define disable_swap_token() do { } while(0)
 
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
