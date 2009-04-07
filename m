Return-Path: <linux-kernel-owner+w=401wt.eu-S1761228AbZDGPXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228AbZDGPXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbZDGPKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:10:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41308 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311AbZDGPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:10:17 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
In-Reply-To: <20090407509.382219156@firstfloor.org>
To: Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       x86@kernel.org
Subject: [PATCH] [11/16] POISON: Handle poisoned pages in try_to_unmap
Message-Id: <20090407151008.AA5A21D0470@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:10:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When a page has the poison bit set replace the PTE with a poison entry. 
This causes the right error handling to be done later when a process runs 
into it.

Cc: Lee.Schermerhorn@hp.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/rmap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/mm/rmap.c
===================================================================
--- linux.orig/mm/rmap.c	2009-04-07 16:39:39.000000000 +0200
+++ linux/mm/rmap.c	2009-04-07 16:39:39.000000000 +0200
@@ -801,7 +801,14 @@
 	/* Update high watermark before we lower rss */
 	update_hiwater_rss(mm);
 
-	if (PageAnon(page)) {
+	if (PagePoison(page)) {
+		if (PageAnon(page))
+			dec_mm_counter(mm, anon_rss);
+		else if (!is_migration_entry(pte_to_swp_entry(*pte)))
+			dec_mm_counter(mm, file_rss);
+		set_pte_at(mm, address, pte,
+				swp_entry_to_pte(make_poison_entry(page)));
+	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
 		if (PageSwapCache(page)) {
