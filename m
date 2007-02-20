Return-Path: <linux-kernel-owner+w=401wt.eu-S1030242AbXBTQic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242AbXBTQic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030248AbXBTQib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:38:31 -0500
Received: from pat.uio.no ([129.240.10.15]:43721 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030242AbXBTQia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:38:30 -0500
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion
	event
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Mason <chris.mason@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1171988988.6271.26.camel@heimdal.trondhjem.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
	 <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
	 <20070219215048.GI6133@think.oraclecorp.com>
	 <20070220002109.GG31205@kvack.org>
	 <1171987310.6271.23.camel@heimdal.trondhjem.org>
	 <20070220160854.GO6133@think.oraclecorp.com>
	 <1171988988.6271.26.camel@heimdal.trondhjem.org>
Content-Type: multipart/mixed; boundary="=-3pbUcrglvqiUp5NynknY"
Date: Tue, 20 Feb 2007 11:38:16 -0500
Message-Id: <1171989496.6271.32.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.2, required=12.0, autolearn=disabled, AWL=0.228)
X-UiO-Scanned: 950815B67F7DA6C5DA76ACFCC267B6E48502F366
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 2 maxlevel 200 minaction 2 bait 0 mail/h: 948 total 584030 max/h 2803 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3pbUcrglvqiUp5NynknY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-02-20 at 11:30 -0500, Trond Myklebust wrote:
> > One option is to have invalidate_inode_pages2_range continue if it can't
> > toss a page but still return something that O_DIRECT ignores (living
> > with the race), but it looks like I can make a launder_page op that does
> > the right thing.  I'll give it a shot.
> 
> I already sent in a patch to do that last week.

To be more precise, here are the 2 patches that I sent to lkml last
week. One ensures that we don't stop the invalidation just because of
the existence of an unsynced dirty page. The other gets rid of the EIO
for that case.

Cheers
  Trond


--=-3pbUcrglvqiUp5NynknY
Content-Disposition: inline; filename=linux-2.6.20-001-fix_invalidate_inode_pages2_range_return.dif
Content-Type: message/rfc822; name=linux-2.6.20-001-fix_invalidate_inode_pages2_range_return.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 13 Jan 2007 02:28:13 -0500
VM: invalidate_inode_pages2_range() should not exit early
Subject: No Subject
Message-Id: <1171989417.6271.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Fix invalidate_inode_pages2_range() so that it does not immediately exit
just because a single page in the specified range could not be removed.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 mm/truncate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index ebf3fcb..0f4b6d1 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -375,10 +375,10 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 
 	pagevec_init(&pvec, 0);
 	next = start;
-	while (next <= end && !ret && !wrapped &&
+	while (next <= end && !wrapped &&
 		pagevec_lookup(&pvec, mapping, next,
 			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
-		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			pgoff_t page_index;
 

--=-3pbUcrglvqiUp5NynknY
Content-Disposition: attachment; filename*0=linux-2.6.20-002-invalidate_inode_pages2_dont_fail_on_dirty.d; filename*1=if
Content-Type: message/rfc822; name=linux-2.6.20-002-invalidate_inode_pages2_dont_fail_on_dirty.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 13 Jan 2007 02:28:13 -0500
VM: invalidate_inode_pages2_range() shouldn't fail on page dirty...
Subject: No Subject
Message-Id: <1171989417.6271.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

invalidate_inode_pages2() should not try to fix races between direct_IO and
mmap(). It should only be trying to clear out pages that were dirty before
the direct_IO write (see generic_file_direct_IO()).
Skipping dirty pages should therefore not result in an error.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 mm/truncate.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 0f4b6d1..c3ff820 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -318,6 +318,8 @@ EXPORT_SYMBOL(invalidate_mapping_pages);
  * invalidation guarantees, and cannot afford to leave pages behind because
  * shrink_list() has a temp ref on them, or because they're transiently sitting
  * in the lru_cache_add() pagevecs.
+ * Note: this function just skips pages that are dirty without flagging
+ * an error.
  */
 static int
 invalidate_complete_page2(struct address_space *mapping, struct page *page)
@@ -330,7 +332,7 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 
 	write_lock_irq(&mapping->tree_lock);
 	if (PageDirty(page))
-		goto failed;
+		goto dirty;
 
 	BUG_ON(PagePrivate(page));
 	__remove_from_page_cache(page);
@@ -338,9 +340,9 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
 	ClearPageUptodate(page);
 	page_cache_release(page);	/* pagecache ref */
 	return 1;
-failed:
+dirty:
 	write_unlock_irq(&mapping->tree_lock);
-	return 0;
+	return 1;
 }
 
 static int do_launder_page(struct address_space *mapping, struct page *page)

--=-3pbUcrglvqiUp5NynknY--

