Return-Path: <linux-kernel-owner+w=401wt.eu-S1765342AbXEVCip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765342AbXEVCip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbXEVCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:38:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50417 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207AbXEVCih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:38:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 2/3] rd: Mark ramdisk buffer heads dirty in ramdisk_set_page_dirty
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
Date: Mon, 21 May 2007 20:36:51 -0600
In-Reply-To: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Mon, 21 May 2007 20:31:50 -0600")
Message-ID: <m1zm3xh9do.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The problem:  When we are trying to free buffers try_to_free_buffers
will look at ramdisk pages with clean buffer heads and remove the
dirty bit from the page.  Resulting in ramdisk pages with data that
get removed from the page cache.  Ouch!

When we mark a ramdisk page dirty we call set_page_dirty which then
calls ramdisk_set_page_dirty.  Currently we don't mark the buffer
heads dirty leaving us susceptible to the problem above.

So to fix the mismatch between buffer head state and page state this patch
modifies ramdisk_set_page_dirty to set the dirty bit on all of the buffers
a page may posses.

I set the uptodate bit on the buffer head so that later we can use
simple_commit_write, and because it is trivially safe.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/block/rd.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index a1512da..41de0f4 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -184,6 +184,21 @@ static int ramdisk_writepages(struct address_space *mapping,
  */
 static int ramdisk_set_page_dirty(struct page *page)
 {
+	struct address_space * const mapping = page_mapping(page);
+
+	spin_lock(&mapping->private_lock);
+	if (page_has_buffers(page)) {
+		struct buffer_head *head = page_buffers(page);
+		struct buffer_head *bh = head;
+
+		do {
+			set_buffer_uptodate(bh);
+			set_buffer_dirty(bh);
+			bh = bh->b_this_page;
+		} while (bh != head);
+	}
+	spin_unlock(&mapping->private_lock);
+
 	if (!TestSetPageDirty(page))
 		return 1;
 	return 0;
-- 
1.5.1.1.181.g2de0

