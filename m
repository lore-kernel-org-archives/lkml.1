Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbZFKIEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbZFKIEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbZFKIDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:03:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36712 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZFKIDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:03:42 -0400
Date: Thu, 11 Jun 2009 17:01:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
Subject: [PATCH 2/3] check unevictable flag in lumy reclaim
Message-Id: <20090611170152.7a43b13b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Lumpy reclaim scans pages from their pfn. Then, it can find unevictable pages
in its loop. Abort lumpy reclaim when we find Unevictable page, we never get a
block of pages for requested order.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: lumpy-reclaim-trial/mm/vmscan.c
===================================================================
--- lumpy-reclaim-trial.orig/mm/vmscan.c
+++ lumpy-reclaim-trial/mm/vmscan.c
@@ -936,6 +936,9 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
+			/* Abort when the page is mlocked */
+			if (unlikely(PageUnevictable(cursor_page)))
+				break;
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;

