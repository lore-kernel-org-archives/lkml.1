Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXBFId3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXBFId3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXBFId3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:33:29 -0500
Received: from ns.suse.de ([195.135.220.2]:58423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXBFId2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:33:28 -0500
Date: Tue, 6 Feb 2007 09:33:27 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] fs: fix __block_write_full_page error case buffer submission
Message-ID: <20070206083327.GC16965@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I had initially been going to send a patch to bring the common case
into line with the error case to reduce the chance of rare bugs, but
that's stupid because the common case is obviously the better tested one!

Oh, and the error case seems to have a bug as well.

--
Andrew noticed that unlocking the page before submitting all buffers for
writeout could cause problems if the IO completes before we've finished
messing around with the page buffers, and they subsequently get freed.

Even if there were no bug, it is a good idea to bring the error case
into line with the common case here.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -1732,7 +1732,6 @@ recover:
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
-	unlock_page(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
@@ -1742,6 +1741,7 @@ recover:
 		}
 		bh = next;
 	} while (bh != head);
+	unlock_page(page);
 	goto done;
 }
 
