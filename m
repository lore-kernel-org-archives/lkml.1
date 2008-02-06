Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbYBGAaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbYBGAaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764215AbYBGAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:18 -0500
Received: from mail.suse.de ([195.135.220.2]:46703 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763937AbYBGAAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:15 -0500
Date: Wed, 6 Feb 2008 15:54:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       B.Steinbrink@gmx.de, jack@suse.cz, Jan Kara <jack@ucw.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Osterried <osterried@jesse.de>,
       Kerin Millar <kerframil@gmail.com>
Subject: [patch 69/73] Fix dirty page accounting leak with ext3 data=journal
Message-ID: <20080206235432.GR13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="fix-dirty-page-accounting-leak-with-ext3-data-journal.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Björn Steinbrink <B.Steinbrink@gmx.de>

patch a2b345642f530054a92b8d2b5108436225a8093e in mainline.

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
Tested-by: Zaid D. <zaid.box@gmail.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Osterried <osterried@jesse.de>
Cc: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 mm/truncate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -95,11 +95,11 @@ truncate_complete_page(struct address_sp
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

-- 
