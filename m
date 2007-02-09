Return-Path: <linux-kernel-owner+w=401wt.eu-S1423178AbXBIAlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423178AbXBIAlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423156AbXBIAlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:41:55 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:17954 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423178AbXBIAly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:41:54 -0500
X-AuditID: d80ac287-a02ebbb000007e48-be-45cbc6045465 
Date: Fri, 9 Feb 2007 00:41:51 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@osdl.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] 2.6.20 fix for PageUptodate memorder problem (try
 2)
In-Reply-To: <20070208111421.30513.77904.sendpatchset@linux.site>
Message-ID: <Pine.LNX.4.64.0702090027580.29905@blonde.wat.veritas.com>
References: <20070208111421.30513.77904.sendpatchset@linux.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 09 Feb 2007 00:41:52.0725 (UTC) FILETIME=[177FA850:01C74BE3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Nick Piggin wrote:
> Still no independent confirmation as to whether this is a problem or not.

I'm trying to convince myself none of your patch is necessary.  Probably
shall fail.  But how come we've survived for years with such an issue?

> Updated some comments, added diffstats to patches, don't use
> __SetPageUptodate as an internal page-flags.h private function.

Depressed by profusion of PageUptodate_UpperAndlowercasevariants.
Those rmbs, you really only want them when it says "yes", don't you?

> 
> I would like to eventually get an ack from Hugh regarding the anon memory
> and especially swap side of the equation,

Plea noted.  I'm pondering.  "Eventually" indeed.  OTOH I expect you're
right to criticize anon/swap PageUptodate being set where it was needed
to get by, rather than where it was natural to do so.

> and a glance from whoever put the
> smp_wmb()s into the copy functions (Was it Ben H or Anton maybe?)

From: Linus Torvalds <torvalds@ppc970.osdl.org>
Date: Thu, 14 Oct 2004 04:00:06 +0000 (-0700)
Subject: Fix threaded user page write memory ordering
X-Git-Tag: v2.6.9-final~3
X-Git-Url: http://127.0.0.1:1234/?p=.git;a=commitdiff_plain;h=538ce05c0ef4055cf29a92a4abcdf139d180a0f9;hp=8c225dbc5a7b13801a8254aae0ccebab8e4bece7

Fix threaded user page write memory ordering

Make sure we order the writes to a newly created page
with the page table update that potentially exposes the
page to another CPU.

This is a no-op on any architecture where getting the
page table spinlock will already do the ordering (notably
x86), but other architectures can care.
---

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 232d8fd..7153aef 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -40,6 +40,8 @@ static inline void clear_user_highpage(s
 	void *addr = kmap_atomic(page, KM_USER0);
 	clear_user_page(addr, vaddr, page);
 	kunmap_atomic(addr, KM_USER0);
+	/* Make sure this page is cleared on other CPU's too before using it */
+	smp_wmb();
 }
 
 static inline void clear_highpage(struct page *page)
@@ -73,6 +75,8 @@ static inline void copy_user_highpage(st
 	copy_user_page(vto, vfrom, vaddr, to);
 	kunmap_atomic(vfrom, KM_USER0);
 	kunmap_atomic(vto, KM_USER1);
+	/* Make sure this page is cleared on other CPU's too before using it */
+	smp_wmb();
 }
 
 static inline void copy_highpage(struct page *to, struct page *from)
