Return-Path: <linux-kernel-owner+w=401wt.eu-S934573AbZIEAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573AbZIEAUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934560AbZIEAUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:38 -0400
Received: from kroah.org ([198.145.64.141]:42073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934532AbZIEAUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:48 2009
Message-Id: <20090905001448.661183107@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>, Nick Piggin <npiggin@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 09/71] Re-introduce page mapping check in mark_buffer_dirty()
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=re-introduce-page-mapping-check-in-mark_buffer_dirty.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8e9d78edea3ce5c0036f85b93091483f2f15443a upstream.

In commit a8e7d49aa7be728c4ae241a75a2a124cdcabc0c5 ("Fix race in
create_empty_buffers() vs __set_page_dirty_buffers()"), I removed a test
for a NULL page mapping unintentionally when some of the code inside
__set_page_dirty() was moved to the callers.

That removal generally didn't matter, since a filesystem would serialize
truncation (which clears the page mapping) against writing (which marks
the buffer dirty), so locking at a higher level (either per-page or an
inode at a time) should mean that the buffer page would be stable.  And
indeed, nothing bad seemed to happen.

Except it turns out that apparently reiserfs does something odd when
under load and writing out the journal, and we have a number of bugzilla
entries that look similar:

	http://bugzilla.kernel.org/show_bug.cgi?id=13556
	http://bugzilla.kernel.org/show_bug.cgi?id=13756
	http://bugzilla.kernel.org/show_bug.cgi?id=13876

and it looks like reiserfs depended on that check (the common theme
seems to be "data=journal", and a journal writeback during a truncate).

I suspect reiserfs should have some additional locking, but in the
meantime this should get us back to the pre-2.6.29 behavior.

Pattern-pointed-out-by: Roland Kletzing <devzero@web.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/buffer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1165,8 +1165,11 @@ void mark_buffer_dirty(struct buffer_hea
 
 	if (!test_set_buffer_dirty(bh)) {
 		struct page *page = bh->b_page;
-		if (!TestSetPageDirty(page))
-			__set_page_dirty(page, page_mapping(page), 0);
+		if (!TestSetPageDirty(page)) {
+			struct address_space *mapping = page_mapping(page);
+			if (mapping)
+				__set_page_dirty(page, mapping, 0);
+		}
 	}
 }
 


