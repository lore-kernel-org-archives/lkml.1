Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbXGKVAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbXGKVAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933614AbXGKU7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:59:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933531AbXGKU7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:22 -0400
Date: Wed, 11 Jul 2007 21:58:46 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [2.6.23 PATCH 07/18] dm io: fix panic on large request
Message-ID: <20070711205846.GY24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>

bio_alloc_bioset() will return NULL if 'num_vecs' is too large.
Use bio_get_nr_vecs() to get estimation of maximum number.

Signed-off-by: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-io.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

Index: linux/drivers/md/dm-io.c
===================================================================
--- linux.orig/drivers/md/dm-io.c	2007-07-11 21:37:32.000000000 +0100
+++ linux/drivers/md/dm-io.c	2007-07-11 21:37:43.000000000 +0100
@@ -293,7 +293,10 @@ static void do_region(int rw, unsigned i
 		 * bvec for bio_get/set_region() and decrement bi_max_vecs
 		 * to hide it from bio_add_page().
 		 */
-		num_bvecs = (remaining / (PAGE_SIZE >> SECTOR_SHIFT)) + 2;
+		num_bvecs = dm_sector_div_up(remaining,
+					     (PAGE_SIZE >> SECTOR_SHIFT));
+		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
+				      num_bvecs);
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
