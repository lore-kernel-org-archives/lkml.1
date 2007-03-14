Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXCNKPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXCNKPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161052AbXCNKPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:15:38 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:34060 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161042AbXCNKPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:15:37 -0400
Date: Wed, 14 Mar 2007 09:44:54 +0000
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2 (oops in move_freepages)
Message-ID: <20070314094454.GA1652@skynet.ie>
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703132152.10136.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200703132152.10136.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (13/03/07 21:52), Bjorn Helgaas didst pronounce:
> FYI, I'm seeing the following oops with 2.6.21-rc3-mm1 (and -mm2)
> on the HP rx2600 and an Intel Tiger (both ia64 boxes).
> 
> I haven't investigated this other than to determine that it
> does not occur with 2.6.21-rc3 or 2.6.20-rc3-mm1, and the
> instruction at move_freepages+0x10 is a load of the value
> pointed to by the third argument (end_page).
> 

Please try the following patch from Yasunori Goto.

>From y-goto@jp.fujitsu.com Thu Mar  8 08:00:15 2007
Date: Thu, 08 Mar 2007 16:39:43 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] fix BUG_ON check at move_freepages() (Re: 2.6.21-rc3-mm2)

Hello.

The BUG_ON() check at move_freepages() is wrong.
Its end_page is start_page + MAX_ORDER_NR_PAGES. So, it can be 
next zone. BUG_ON() should check "end_page - 1".

This is fix of 2.6.21-rc3-mm2 for it.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: current_test/mm/page_alloc.c
===================================================================
--- current_test.orig/mm/page_alloc.c	2007-03-08 15:44:10.000000000 +0900
+++ current_test/mm/page_alloc.c	2007-03-08 16:17:29.000000000 +0900
@@ -707,7 +707,7 @@ int move_freepages(struct zone *zone,
 	unsigned long order;
 	int blocks_moved = 0;
 
-	BUG_ON(page_zone(start_page) != page_zone(end_page));
+	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
 
 	for (page = start_page; page < end_page;) {
 		if (!PageBuddy(page)) {

