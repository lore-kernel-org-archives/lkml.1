Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXCNQNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXCNQNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 12:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbXCNQNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 12:13:31 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:41622 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbXCNQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 12:13:30 -0400
Date: Wed, 14 Mar 2007 16:13:27 +0000
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Message-ID: <20070314161327.GA14416@skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703132152.10136.bjorn.helgaas@hp.com> <20070314094454.GA1652@skynet.ie> <200703140911.16537.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200703140911.16537.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/03/07 09:11), Bjorn Helgaas didst pronounce:
> On Wednesday 14 March 2007 03:44, Mel Gorman wrote:
> > Please try the following patch from Yasunori Goto.
> > ...
> > --- current_test.orig/mm/page_alloc.c	2007-03-08 15:44:10.000000000 +0900
> > +++ current_test/mm/page_alloc.c	2007-03-08 16:17:29.000000000 +0900
> > @@ -707,7 +707,7 @@ int move_freepages(struct zone *zone,
> >  	unsigned long order;
> >  	int blocks_moved = 0;
> >  
> > -	BUG_ON(page_zone(start_page) != page_zone(end_page));
> > +	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
> >  
> 
> I should have mentioned that I already tried this patch.  The
> oops still occurs, although now it's when loading the value
> pointed to by "end_page - 1" instead of "end_page".

Ok. This looks like another case of HOLES_IN_ZONE hilarity with page_zone().
As I take a new look at the BUG_ON check in move_freepages(), it isn't even
necessary as move_freepages_block() already checks the zone boundaries.  At a
later date when the code has survived a while without new bug reports, I'll
submit a patch that simply deletes this check because it should be redundant.
Just in case, I'd like to preserve the check in the non-HOLES_IN_ZONE
case for now.

Can you try this patch please? It should apply on top of Yasunori Goto's
patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc3-mm2-goto/mm/page_alloc.c linux-2.6.21-rc3-mm2-bjorn_testfix/mm/page_alloc.c
--- linux-2.6.21-rc3-mm2-goto/mm/page_alloc.c	2007-03-14 16:07:23.000000000 +0000
+++ linux-2.6.21-rc3-mm2-bjorn_testfix/mm/page_alloc.c	2007-03-14 16:01:00.000000000 +0000
@@ -707,7 +707,15 @@ int move_freepages(struct zone *zone,
 	unsigned long order;
 	int blocks_moved = 0;
 
+#ifndef CONFIG_HOLES_IN_ZONE
+	/*
+	 * page_zone is not safe to call in this context when
+	 * CONFIG_HOLES_IN_ZONE is set but this bug check is
+	 * redundant anyway as we check zone boundaries in
+	 * move_freepages_block()
+	 */
 	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
+#endif
 
 	for (page = start_page; page < end_page;) {
 		if (!PageBuddy(page)) {
