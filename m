Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYA0GFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYA0GFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbYA0GEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:04:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757913AbYA0GEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:04:23 -0500
Date: Sat, 26 Jan 2008 22:03:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] some page can't be migrated
Message-Id: <20080126220351.a04819f9.akpm@linux-foundation.org>
In-Reply-To: <1201241005.24290.5.camel@sli10-desk.sh.intel.com>
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com>
	<1201233590.28282.13.camel@sli10-desk.sh.intel.com>
	<Pine.LNX.4.64.0801242000320.1932@schroedinger.engr.sgi.com>
	<200801251517.02287.nickpiggin@yahoo.com.au>
	<1201241005.24290.5.camel@sli10-desk.sh.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 25 Jan 2008 14:03:25 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> -	if (!page->mapping)
> +	if (!page->mapping) {
> +		if (!PageAnon(page) && PagePrivate(page))
> +			try_to_release_page(page, GFP_KERNEL);
>  		goto rcu_unlock;
> +	}

We call something(GFP_KERNEL) under rcu_read_lock()?  I've lost track of
the myriad flavours of rcu which we purport to support, but I don't think
they'll all like us blocking under rcu_read_lock().

We _won't_ block, because try_to_release_page() will see the NULL ->mapping
and will call the non-blocking try_to_free_buffers().  But still, it looks
bad, and will cause problems if someone decides to add a might_sleep_if()
to try_to_release_page().

So...  I'd suggest that it would be better to add an apologetic comment and
call direct into try_to_free_buffers().

> -	 * This is a corner case handling.
> -	 * When a new swap-cache is read into, it is linked to LRU
> +	 * There are corner cases handling.
> +	 * 1. When a new swap-cache is read into, it is linked to LRU

hm, that didn't improve the rather flakey grammar in there.  Oh well.

> Acked-by: Nick Piggin <npiggin@suse.de>
> Acked-by: Christoph Lameter <clameter@sgi.com>

hm.



Please review and test....

--- a/mm/migrate.c~page-migraton-handle-orphaned-pages-fix
+++ a/mm/migrate.c
@@ -650,20 +650,28 @@ static int unmap_and_move(new_page_t get
 	}
 
 	/*
-	 * There are corner cases handling.
-	 * 1. When a new swap-cache is read into, it is linked to LRU
-	 * and treated as swapcache but has no rmap yet.
-	 * Calling try_to_unmap() against a page->mapping==NULL page is
-	 * BUG. So handle it here.
-	 * 2. Orphaned page (see truncate_complete_page) might have
-	 * fs-private metadata, the page is truncated. The page can be picked
-	 * up due to memory offlineing. Everywhere else except page reclaim,
-	 * the page is invisible to the vm, so the page can't be migrated. Try
-	 * to free metadata, so the page can be freed.
+	 * Corner case handling:
+	 * 1. When a new swap-cache page is read into, it is added to the LRU
+	 * and treated as swapcache but it has no rmap yet.
+	 * Calling try_to_unmap() against a page->mapping==NULL page will
+	 * trigger a BUG.  So handle it here.
+	 * 2. An orphaned page (see truncate_complete_page) might have
+	 * fs-private metadata. The page can be picked up due to memory
+	 * offlining.  Everywhere else except page reclaim, the page is
+	 * invisible to the vm, so the page can not be migrated.  So try to
+	 * free the metadata, so the page can be freed.
 	 */
 	if (!page->mapping) {
-		if (!PageAnon(page) && PagePrivate(page))
-			try_to_release_page(page, GFP_KERNEL);
+		if (!PageAnon(page) && PagePrivate(page)) {
+			/*
+			 * Go direct to try_to_free_buffers() here because
+			 * a) that's what try_to_release_page() would do anyway
+			 * b) we may be under rcu_read_lock() here, so we can't
+			 *    use GFP_KERNEL which is what try_to_release_page()
+			 *    needs to be effective.
+			 */
+			try_to_release_buffers(page);
+		}
 		goto rcu_unlock;
 	}
 

