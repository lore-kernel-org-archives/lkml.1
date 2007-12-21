Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbXLUUma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbXLUUma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXLUUmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:42:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:39682 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752399AbXLUUmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:42:19 -0500
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19LhuMUJ81LtoypRPrE1RspotJ06Su+j4mbA2CdUQ
	YNWYwuDo2dMLZe
Date: Fri, 21 Dec 2007 21:42:13 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org, sct@redhat.com, adilget@clusterfs.com,
       linux-ext4@vger.kernel.org
Subject: [PATCH] Fix dirty page accounting leak with ext3 data=journal
Message-ID: <20071221204213.GA32138@atjola.homenet>
References: <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220141217.GA4745@atjola.homenet> <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org> <20071220222816.GB4745@atjola.homenet> <Pine.LNX.4.64.0712212049001.24477@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0712212049001.24477@bizon.gios.gov.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0, try_to_free_buffers was
changed to bail out if the page was dirty. That caused
truncate_complete_page to leak massive amounts of memory, because the
dirty bit was only cleared after the call to try_to_free_buffers. So the
call to cancel_dirty_page was moved up to have the dirty bit cleared
early in 3e67c0987d7567ad666641164a153dca9a43b11d.

The problem with that fix is, that the page can be redirtied after
cancel_dirty_page was called, eg. like this:

truncate_complete_page()
  cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
  do_invalidatepage()
    ext3_invalidatepage()
      journal_invalidatepage()
        journal_unmap_buffer()
          __dispose_buffer()
            __journal_unfile_buffer()
              __journal_temp_unlink_buffer()
                mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

And then we end up with dirty pages being wrongly accounted.

In ecdfc9787fe527491baefc22dce8b2dbd5b2908d the changes to
try_to_free_buffers were reverted, so the original reason for the
massive memory leak is gone, so we can also revert the move of
the call to cancel_dirty_page from truncate_complete_page and get the
accounting right again.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>

---
I'm not sure if it matters, but opposed to the final check in
__remove_from_page_cache, this one also cares about the task io
accounting, so maybe we want to use this instead, although it's not
quite the clean fix either.

diff --git a/mm/truncate.c b/mm/truncate.c
index cadc156..2974903 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -98,11 +98,11 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	if (page->mapping != mapping)
 		return;
 
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
-
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
 
+	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+
 	remove_from_page_cache(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
