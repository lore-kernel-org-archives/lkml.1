Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZIIJbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZIIJbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZIIJbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:31:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38439 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbZIIJbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:31:39 -0400
Date: Wed, 9 Sep 2009 10:31:44 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Message-ID: <20090909093144.GD24614@csn.ul.ie>
References: <20090909175036.0D06.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090909175036.0D06.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 05:51:35PM +0900, KOSAKI Motohiro wrote:
> > On Wed, Sep 09, 2009 at 05:17:34PM +0900, KOSAKI Motohiro wrote:
> > > > On Wed, Sep 09, 2009 at 09:49:15AM +0900, KOSAKI Motohiro wrote:
> > > > > Hi
> > > > > 
> > > > > This release doesn't boot on my ia64 test box.
> > > > > After following two patches reverted, booting was successful.
> > > > > 
> > > > > 	page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch 
> > > > > 	Kamezawa-san's kcore patch series
> > > > > 
> > > > > 
> > > > > Mel, Kamezawa-san, Can you please gime me any advise?
> > > > 
> > > > Can you post a .config, the vanilla dmesg, the dmesg with the page
> > > > allocator patch reverted, the dmesg with Kamezawa-san's patch reverted
> > > > and both reverted please?
> > > 
> > > I already attached .config on another mail.
> > > if neither of either revert, the system become hang before output any dmesg.
> > 
> > console=uart,io,0x3f8 ?
> > 
> > I'm trying to resurrect an ia-64 machine here to reproduce the problem but
> > it's in bad shape :(
> 
> I use "console=tty0 console=ttyS0". but serial console also do no output ;)
> 

/me slaps self

I think I see the problem. Can you try this patch please?

---
Calculate the number of pageblocks within a range properly

Patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback
is meant to change the pageblock ownership of each pageblock within a
given range. This is necessary when the buddy to be split is of higher
order than the pageblock_order. However, the calculation was wrong
leading to crashes on ia-64 and slightly incorrect behaviour on x86.
This patch corrects the calculation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e0ec94..4326280 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -830,7 +830,7 @@ static int move_freepages_block(struct zone *zone, struct page *page,
 static void change_pageblock_range(struct page *pageblock_page,
 					int start_order, int migratetype)
 {
-	int nr_pageblocks = 1 << (MAX_ORDER - 1 - start_order);
+	int nr_pageblocks = 1 << (start_order - pageblock_order);
 
 	while (nr_pageblocks--) {
 		set_pageblock_migratetype(pageblock_page, migratetype);
