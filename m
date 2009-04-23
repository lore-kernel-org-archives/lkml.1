Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZDWHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZDWHhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZDWH3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:29:13 -0400
Received: from sous-sol.org ([216.99.217.87]:48437 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756049AbZDWH3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:29:11 -0400
Message-Id: <20090423072328.181381441@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: [patch 024/100] md/raid1 - dont assume newly allocated bvecs are initialised.
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=md-raid1-don-t-assume-newly-allocated-bvecs-are-initialised.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: NeilBrown <neilb@suse.de>

upstream commit: 303a0e11d0ee136ad8f53f747f3c377daece763b

Since commit d3f761104b097738932afcc310fbbbbfb007ef92
newly allocated bvecs aren't initialised to NULL, so we have
to be more careful about freeing a bio which only managed
to get a few pages allocated to it.  Otherwise the resync
process crashes.

This patch is appropriate for 2.6.29-stable.

Cc: stable@kernel.org
Cc: "Jens Axboe" <jens.axboe@oracle.com>
Reported-by: Gabriele Tozzi <gabriele@tozzi.eu>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -120,6 +120,7 @@ static void * r1buf_pool_alloc(gfp_t gfp
 				goto out_free_pages;
 
 			bio->bi_io_vec[i].bv_page = page;
+			bio->bi_vcnt = i+1;
 		}
 	}
 	/* If not user-requests, copy the page pointers to all bios */
@@ -135,9 +136,9 @@ static void * r1buf_pool_alloc(gfp_t gfp
 	return r1_bio;
 
 out_free_pages:
-	for (i=0; i < RESYNC_PAGES ; i++)
-		for (j=0 ; j < pi->raid_disks; j++)
-			safe_put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
+	for (j=0 ; j < pi->raid_disks; j++)
+		for (i=0; i < r1_bio->bios[j]->bi_vcnt ; i++)
+			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
 	while ( ++j < pi->raid_disks )

