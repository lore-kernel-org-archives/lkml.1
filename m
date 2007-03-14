Return-Path: <linux-kernel-owner+w=401wt.eu-S1161186AbXCNMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161186AbXCNMPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161197AbXCNMPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:15:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186AbXCNMPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:15:44 -0400
Date: Wed, 14 Mar 2007 13:15:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: [patch 2/2] splice: dont readpage
Message-ID: <20070314121543.GB926@wotan.suse.de>
References: <20070314121440.GA926@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314121440.GA926@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Splice does not need to readpage to bring the page uptodate before writing
to it, because prepare_write will take care of that for us.

Splice is also wrong to SetPageUptodate before the page is actually uptodate.
This results in the old uninitialised memory leak. This gets fixed as a
matter of course when removing the readpage logic.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -593,36 +593,6 @@ find_page:
 			goto out;
 	}
 
-	/*
-	 * We get here with the page locked. If the page is also
-	 * uptodate, we don't need to do more. If it isn't, we
-	 * may need to bring it in if we are not going to overwrite
-	 * the full page.
-	 */
-	if (!PageUptodate(page)) {
-		if (this_len < PAGE_CACHE_SIZE) {
-			ret = mapping->a_ops->readpage(file, page);
-			if (unlikely(ret))
-				goto out;
-
-			lock_page(page);
-
-			if (!PageUptodate(page)) {
-				/*
-				 * Page got invalidated, repeat.
-				 */
-				if (!page->mapping) {
-					unlock_page(page);
-					page_cache_release(page);
-					goto find_page;
-				}
-				ret = -EIO;
-				goto out;
-			}
-		} else
-			SetPageUptodate(page);
-	}
-
 	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
 	if (unlikely(ret)) {
 		loff_t isize = i_size_read(mapping->host);
