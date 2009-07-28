Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZG1XzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZG1XzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZG1XzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:55:07 -0400
Received: from kroah.org ([198.145.64.141]:35908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZG1XuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:59 2009
Message-Id: <20090728234159.690883741@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Josef Bacik <jbacik@redhat.com>, Nick Piggin <npiggin@suse.de>
Subject: [patch 53/71] mm: mark page accessed before we write_end()
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=mm-mark-page-accessed-before-we-write_end.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit c8236db9cd7aa492dcfcdcca702638e704abed49 upstream.

In testing a backport of the write_begin/write_end AOPs, a 10% re-read
regression was noticed when running iozone.  This regression was
introduced because the old AOPs would always do a mark_page_accessed(page)
after the commit_write, but when the new AOPs where introduced, the only
place this was kept was in pagecache_write_end().

This patch does the same thing in the generic case as what is done in
pagecache_write_end(), which is just to mark the page accessed before we
do write_end().

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2249,6 +2249,7 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
 		if (unlikely(status < 0))


