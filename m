Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXBETE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXBETE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933201AbXBETEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:04:55 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:60552 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932969AbXBETEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:04:54 -0500
Date: Mon, 5 Feb 2007 11:04:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Matt Mackall <mpm@selenic.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <20070205163847.GI16722@waste.org>
Message-ID: <Pine.LNX.4.64.0702051102150.20617@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
 <20070203005316.eb0b4042.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
 <20070203172242.e5bf2534.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
 <1170576977.3073.1100.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702042351040.23790@schroedinger.engr.sgi.com>
 <1170664774.3073.1236.camel@laptopd505.fenrus.org> <20070205163847.GI16722@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch seems to work and survives AIM7. However, we only know about 30% of 
the Mlocked pages after boot. With this additional patch to 
opportunistically move pages off the LRU immediately I can get the counter 
be accurate (for all practical purposes) like the non lazy version:


Index: current/mm/memory.c
===================================================================
--- current.orig/mm/memory.c	2007-02-05 10:44:10.000000000 -0800
+++ current/mm/memory.c	2007-02-05 11:01:46.000000000 -0800
@@ -919,6 +919,30 @@ void anon_add(struct vm_area_struct *vma
 }
 
 /*
+ * Opportunistically move the page off the LRU
+ * if possible. If we do not succeed then the LRU
+ * scans will take the page off.
+ */
+void try_to_set_mlocked(struct page *page)
+{
+	struct zone *zone;
+	unsigned long flags;
+
+	if (!PageLRU(page) || PageMlocked(page))
+		return;
+
+	zone = page_zone(page);
+	if (spin_trylock_irqsave(&zone->lru_lock, flags)) {
+		if (PageLRU(page) && !PageMlocked(page)) {
+			ClearPageLRU(page);
+			list_del(&page->lru);
+			SetPageMlocked(page);
+			__inc_zone_page_state(page, NR_MLOCK);
+		}
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+	}
+}
+/*
  * Do a quick page-table lookup for a single page.
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
@@ -978,6 +1002,8 @@ struct page *follow_page(struct vm_area_
 			set_page_dirty(page);
 		mark_page_accessed(page);
 	}
+	if (vma->vm_flags & VM_LOCKED)
+		try_to_set_mlocked(page);
 unlock:
 	pte_unmap_unlock(ptep, ptl);
 out:
@@ -2271,6 +2297,8 @@ retry:
 		else {
 			inc_mm_counter(mm, file_rss);
 			page_add_file_rmap(new_page);
+			if (vma->vm_flags & VM_LOCKED)
+				try_to_set_mlocked(new_page);
 			if (write_access) {
 				dirty_page = new_page;
 				get_page(dirty_page);
