Return-Path: <linux-kernel-owner+w=401wt.eu-S1763185AbYCXSYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763185AbYCXSYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbYCXSYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:24:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23366 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999AbYCXSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:24:21 -0400
Message-ID: <47E7F1D1.6010407@ct.jp.nec.com>
Date: Mon, 24 Mar 2008 11:24:17 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -rt] avoid deadlock related with PG_nonewrefs and swap_lock
References: <47DEB7F0.8040207@ct.jp.nec.com>	 <47DF097B.4090200@ct.jp.nec.com>	 <Pine.LNX.4.58.0803172150360.8231@gandalf.stny.rr.com> <1205833218.8514.338.camel@twins>
In-Reply-To: <1205833218.8514.338.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I've updated the patch. Could you please review it?

I'm also thinking that it can be in the mainline because it makes
the lock period shorter, correct?

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

There is a deadlock scenario; remove_mapping() vs free_swap_and_cache().
remove_mapping() turns PG_nonewrefs bit on, then locks swap_lock.
free_swap_and_cache() locks swap_lock, then wait to turn PG_nonewrefs bit
off in find_get_page().

swap_lock can be unlocked before calling find_get_page().

In remove_exclusive_swap_page(), there is similar lock sequence;
swap_lock, then PG_nonewrefs bit. swap_lock can be unlocked before
turning PG_nonewrefs bit on.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 mm/swapfile.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5036b70..6fbc77e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -366,6 +366,7 @@ int remove_exclusive_swap_page(struct page *page)
 	/* Is the only swap cache user the cache itself? */
 	retval = 0;
 	if (p->swap_map[swp_offset(entry)] == 1) {
+		spin_unlock(&swap_lock);
 		/* Recheck the page count with the swapcache lock held.. */
 		lock_page_ref_irq(page);
 		if ((page_count(page) == 2) && !PageWriteback(page)) {
@@ -374,8 +375,8 @@ int remove_exclusive_swap_page(struct page *page)
 			retval = 1;
 		}
 		unlock_page_ref_irq(page);
-	}
-	spin_unlock(&swap_lock);
+	} else
+		spin_unlock(&swap_lock);
 
 	if (retval) {
 		swap_free(entry);
@@ -400,13 +401,14 @@ void free_swap_and_cache(swp_entry_t entry)
 	p = swap_info_get(entry);
 	if (p) {
 		if (swap_entry_free(p, swp_offset(entry)) == 1) {
+			spin_unlock(&swap_lock);
 			page = find_get_page(&swapper_space, entry.val);
 			if (page && unlikely(TestSetPageLocked(page))) {
 				page_cache_release(page);
 				page = NULL;
 			}
-		}
-		spin_unlock(&swap_lock);
+		} else
+			spin_unlock(&swap_lock);
 	}
 	if (page) {
 		int one_user;
-- 
1.5.4.1


