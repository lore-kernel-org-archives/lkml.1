Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbXIZBcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbXIZBcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXIZBcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:32:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbXIZBcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:32:07 -0400
Date: Tue, 25 Sep 2007 21:31:56 -0400
From: Rik van Riel <riel@redhat.com>
To: Jan =?UTF-8?B?S3VuZHLDoXQ=?= <jkt@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kswapd high CPU usage with no swap
Message-ID: <20070925213156.68fceea2@bree.surriel.com>
In-Reply-To: <46F8DF55.2030905@gentoo.org>
References: <46F852B6.7030207@gentoo.org>
	<20070924223444.62f0622d@bree.surriel.com>
	<46F8DF55.2030905@gentoo.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_ihi0hlLi=_DmLOw.cF7/YvS"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_ihi0hlLi=_DmLOw.cF7/YvS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 25 Sep 2007 12:13:41 +0200
Jan Kundr=C3=A1t <jkt@gentoo.org> wrote:

> Rik van Riel wrote:
> > How much memory did you have in "cached" when you looked
> > with top (and no swap enabled) ?
>=20
> Hi Rik,
> it was pretty low number (several thousands, or maybe tens of
> thousands).
>=20
> In the meanwhile, I've come across your patch [1] ("prevent kswapd
> from freeing excessive amounts of lowmem") and applied it locally.

Could you try out the attached patch, too?

Kswapd and try_to_free_pages() have a built-in pause, where
it waits for IO to complete.  However, the current code also
calls blk_congestion_wait() when there is no IO in flight!

This patch should only make the pageout code wait for IO when
there actually is a significant amount of pageout IO in flight.

Signed-off-by: Rik van Riel <riel@redhat.com>

--MP_ihi0hlLi=_DmLOw.cF7/YvS
Content-Type: text/x-patch; name=linux-2.6-kswapd-iowait.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=linux-2.6-kswapd-iowait.patch

diff -up linux-2.6.22.x86_64/mm/vmscan.c.wait linux-2.6.22.x86_64/mm/vmscan.c
--- linux-2.6.22.x86_64/mm/vmscan.c.wait	2007-09-25 11:33:30.000000000 -0400
+++ linux-2.6.22.x86_64/mm/vmscan.c	2007-09-25 21:27:08.000000000 -0400
@@ -68,6 +68,8 @@ struct scan_control {
 	int all_unreclaimable;
 
 	int order;
+
+	int nr_io_pages;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -489,8 +491,10 @@ static unsigned long shrink_page_list(st
 			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
-			else
+			else {
+				sc->nr_io_pages++;
 				goto keep_locked;
+			}
 		}
 
 		referenced = page_referenced(page, 1);
@@ -541,8 +545,10 @@ static unsigned long shrink_page_list(st
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
-				if (PageWriteback(page) || PageDirty(page))
+				if (PageWriteback(page) || PageDirty(page)) {
+					sc->nr_io_pages++;
 					goto keep;
+				}
 				/*
 				 * A synchronous write - probably a ramdisk.  Go
 				 * ahead and try to reclaim the page.
@@ -1201,6 +1207,7 @@ unsigned long try_to_free_pages(struct z
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc.nr_scanned = 0;
+		sc.nr_io_pages = 0;
 		if (!priority)
 			disable_swap_token();
 		nr_reclaimed += shrink_zones(priority, zones, &sc);
@@ -1229,7 +1236,8 @@ unsigned long try_to_free_pages(struct z
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc.nr_scanned && priority < DEF_PRIORITY - 2)
+		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
+				sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
@@ -1315,6 +1323,7 @@ loop_again:
 		if (!priority)
 			disable_swap_token();
 
+		sc.nr_io_pages = 0;
 		all_zones_ok = 1;
 
 		/*
@@ -1398,7 +1407,8 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < DEF_PRIORITY - 2 &&
+					sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 
 		/*

--MP_ihi0hlLi=_DmLOw.cF7/YvS--
