Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZFKIkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZFKIkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbZFKIjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:39:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38807 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbZFKIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:39:52 -0400
Date: Thu, 11 Jun 2009 17:38:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       apw@canonical.com, riel@redhat.com, minchan.kim@gmail.com,
       mel@csn.ul.ie
Subject: [PATCH 2/3] check unevictable flag in lumy reclaim v2
Message-Id: <20090611173819.0f76e431.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090611172249.6D3C.A69D9226@jp.fujitsu.com>
References: <20090611165535.cf46bf29.kamezawa.hiroyu@jp.fujitsu.com>
	<20090611170152.7a43b13b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090611172249.6D3C.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about this ?

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Lumpy reclaim check pages from their pfn. Then, it can find unevictable pages
in its loop.
Abort lumpy reclaim when we find Unevictable page, we never get a lump
of pages for requested order.

Changelog: v1->v2
 - rewrote commet.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: lumpy-reclaim-trial/mm/vmscan.c
===================================================================
--- lumpy-reclaim-trial.orig/mm/vmscan.c
+++ lumpy-reclaim-trial/mm/vmscan.c
@@ -936,6 +936,15 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
+			/*
+			 * We tries to free all pages in this range to create
+			 * a free large page. Then, if the range includes a page
+			 * never be reclaimed, we have no reason to do more.
+			 * PageUnevictable page is not a page which can be
+			 * easily freed. Abort this scan now.
+			 */
+			if (unlikely(PageUnevictable(cursor_page)))
+				break;
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;

