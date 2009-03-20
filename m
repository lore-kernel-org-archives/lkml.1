Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbZCTXb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbZCTXb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbZCTXYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:32 -0400
Received: from kroah.org ([198.145.64.141]:48588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762936AbZCTXYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:25 2009
Message-Id: <20090320222925.117322176@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 14/43] dm io: respect BIO_MAX_PAGES limit
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=dm-io-respect-bio_max_pages-limit.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit d659e6cc98766a1a61d6bdd283f95d149abd7719 upstream.

dm-io calls bio_get_nr_vecs to get the maximum number of pages to use
for a given device.  It allocates one additional bio_vec to use
internally but failed to respect BIO_MAX_PAGES, so fix this.

This was the likely cause of:
  https://bugzilla.redhat.com/show_bug.cgi?id=173153

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -292,6 +292,8 @@ static void do_region(int rw, unsigned r
 					     (PAGE_SIZE >> SECTOR_SHIFT));
 		num_bvecs = 1 + min_t(int, bio_get_nr_vecs(where->bdev),
 				      num_bvecs);
+		if (unlikely(num_bvecs > BIO_MAX_PAGES))
+			num_bvecs = BIO_MAX_PAGES;
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;


