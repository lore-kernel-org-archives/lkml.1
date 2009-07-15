Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZGOKsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZGOKsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZGOKsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:48:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43497 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbZGOKsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:48:35 -0400
Date: Wed, 15 Jul 2009 11:48:34 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kosaki.motohiro@jp.fujitsu.com, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
	(resend)
Message-ID: <20090715104833.GB9267@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a page is freed with the PG_mlocked set, it is considered an unexpected
but recoverable situation. A counter records how often this event happens
but it is easy to miss that this event has occured at all. This patch warns
once when PG_mlocked is set to prompt debuggers to check the counter to
see how often it is happening.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index caa9268..f8902e7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -495,8 +495,16 @@ static inline void free_page_mlock(struct page *page)
 static void free_page_mlock(struct page *page) { }
 #endif
 
-static inline int free_pages_check(struct page *page)
-{
+static inline int free_pages_check(struct page *page, int wasMlocked)
+{
+	if (unlikely(wasMlocked)) {
+		WARN_ONCE(1, KERN_WARNING
+			"Page flag mlocked set for process %s at pfn:%05lx\n"
+			"page:%p flags:0x%lX\n",
+			current->comm, page_to_pfn(page),
+			page, page->flags|__PG_MLOCKED);
+	}
+
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(atomic_read(&page->_count) != 0) |
@@ -562,7 +570,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	kmemcheck_free_shadow(page, order);
 
 	for (i = 0 ; i < (1 << order) ; ++i)
-		bad += free_pages_check(page + i);
+		bad += free_pages_check(page + i, wasMlocked);
 	if (bad)
 		return;
 
@@ -1027,7 +1035,7 @@ static void free_hot_cold_page(struct page *page, int cold)
 
 	if (PageAnon(page))
 		page->mapping = NULL;
-	if (free_pages_check(page))
+	if (free_pages_check(page, wasMlocked))
 		return;
 
 	if (!PageHighMem(page)) {
