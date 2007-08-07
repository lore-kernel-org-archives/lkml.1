Return-Path: <linux-kernel-owner+w=401wt.eu-S937364AbXHGVYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937364AbXHGVYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935199AbXHGU4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:56:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59896 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965131AbXHGU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:56:29 -0400
Date: Tue, 7 Aug 2007 13:49:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Junichi Nomura <j-nomura@ce.jp.nec.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22.2 review 71/84] dm io: fix another panic on large request
Message-ID: <20070807204904.GU23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-io-fix-panic-on-large-request-2.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>

bio_alloc_bioset() will return NULL if 'num_vecs' is too large.
Use bio_get_nr_vecs() to get estimation of maximum number.

Signed-off-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-io.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
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

-- 
