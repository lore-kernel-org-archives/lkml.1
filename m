Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbXHTBjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbXHTBjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXHTBjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:39:10 -0400
Received: from [203.171.70.205] ([203.171.70.205]:49587 "EHLO
	home.nigel.suspend2.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbXHTBjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:39:09 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Should GFP_ATOMIC fail when we're below low watermark?
Date: Mon, 20 Aug 2007 11:38:49 +1000
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200708201138.50508.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

In current git (and for a while now), an attempt to allocate memory with 
GFP_ATOMIC will fail if we're below the low watermark level. The only way to 
access that memory that I can see (not that I've looked that hard) is to have 
PF_MEMALLOC set (ie from kswapd). I'm wondering if this behaviour is correct. 
Shouldn't GFP_ATOMIC allocations ignore watermarks too? How about GFP_KERNEL?

The following patch is a potential fix for GFP_ATOMIC.

Regards,

Nigel

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>

 page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff -ruNp 995-gfp-atomic-alloc.patch-old/mm/page_alloc.c 995-gfp-atomic-alloc.patch-new/mm/page_alloc.c
--- 995-gfp-atomic-alloc.patch-old/mm/page_alloc.c	2007-08-20 11:14:34.000000000 +1000
+++ 995-gfp-atomic-alloc.patch-new/mm/page_alloc.c	2007-08-20 11:11:09.000000000 +1000
@@ -1286,8 +1286,8 @@ restart:
 	/* This allocation should allow future memory freeing. */
 
 rebalance:
-	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-			&& !in_interrupt()) {
+	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)) ||
+			(gfp_mask & GFP_ATOMIC)) && !in_interrupt()) {
 		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
 nofail_alloc:
 			/* go through the zonelist yet again, ignoring mins */

-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
