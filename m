Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXBOHbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXBOHbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964972AbXBOHb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:31:29 -0500
Received: from ns2.suse.de ([195.135.220.15]:45311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964975AbXBOHb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:31:26 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070215051842.7443.65926.sendpatchset@linux.site>
In-Reply-To: <20070215051822.7443.30110.sendpatchset@linux.site>
References: <20070215051822.7443.30110.sendpatchset@linux.site>
Subject: [patch 2/3] fs: buffer don't PageUptodate without page locked
Date: Thu, 15 Feb 2007 08:31:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__block_write_full_page is calling SetPageUptodate without the page locked.
This is unusual, but not incorrect, as PG_writeback is still set.

However the next patch will require that SetPageUptodate always be called
with the page locked. Simply don't bother setting the page uptodate in this
case (it is unusual that the write path does such a thing anyway). Instead
just leave it to the read side to bring the page uptodate when it notices
that all buffers are uptodate.

Signed-off-by: Nick Piggin <npiggin@suse.de>

 fs/buffer.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1698,17 +1698,8 @@ done:
 		 * clean.  Someone wrote them back by hand with
 		 * ll_rw_block/submit_bh.  A rare case.
 		 */
-		int uptodate = 1;
-		do {
-			if (!buffer_uptodate(bh)) {
-				uptodate = 0;
-				break;
-			}
-			bh = bh->b_this_page;
-		} while (bh != head);
-		if (uptodate)
-			SetPageUptodate(page);
 		end_page_writeback(page);
+
 		/*
 		 * The page and buffer_heads can be released at any time from
 		 * here on.
