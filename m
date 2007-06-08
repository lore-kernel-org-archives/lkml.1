Return-Path: <linux-kernel-owner+w=401wt.eu-S967511AbXFHHTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967511AbXFHHTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937829AbXFHHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:11 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33137 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937142AbXFHHRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:09 -0400
Message-Id: <20070608071546.073789000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, heiko.carstens@de.ibm.com,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/32] s390: page_mkclean data corruption.
Content-Disposition: inline; filename=01-data-corruption.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The git commit c2fda5fed81eea077363b285b66eafce20dfd45a which
added the page_test_and_clear_dirty call to page_mkclean and the
git commit 7658cc289288b8ae7dd2c2224549a048431222b3 which fixes
the "nasty and subtle race in shared mmap'ed page writeback"
problem in clear_page_dirty_for_io cause data corruption on s390.

The effect of the two changes is that for every call to
clear_page_dirty_for_io a page_test_and_clear_dirty is done. If
the per page dirty bit is set set_page_dirty is called. Strangly
clear_page_dirty_for_io is called for not-uptodate pages, e.g.
over this call-chain:

[<000000000007c0f2>] clear_page_dirty_for_io+0x12a/0x130
[<000000000007c494>] generic_writepages+0x258/0x3e0
[<000000000007c692>] do_writepages+0x76/0x7c
[<00000000000c7a26>] __writeback_single_inode+0xba/0x3e4
[<00000000000c831a>] sync_sb_inodes+0x23e/0x398
[<00000000000c8802>] writeback_inodes+0x12e/0x140
[<000000000007b9ee>] wb_kupdate+0xd2/0x178
[<000000000007cca2>] pdflush+0x162/0x23c

The bad news now is that page_test_and_clear_dirty might claim
that a not-uptodate page is dirty since SetPageUptodate which
resets the per page dirty bit has not yet been called. The page
writeback that follows clobbers the data on disk.

The simplest solution to this problem is to move the call to
page_test_and_clear_dirty under the "if (page_mapped(page))".
If a file backed page is mapped it is uptodate.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.13.orig/mm/rmap.c
+++ linux-2.6.20.13/mm/rmap.c
@@ -490,9 +490,9 @@ int page_mkclean(struct page *page)
 		struct address_space *mapping = page_mapping(page);
 		if (mapping)
 			ret = page_mkclean_file(mapping, page);
+		if (page_test_and_clear_dirty(page))
+			ret = 1;
 	}
-	if (page_test_and_clear_dirty(page))
-		ret = 1;
 
 	return ret;
 }

-- 
