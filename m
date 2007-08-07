Return-Path: <linux-kernel-owner+w=401wt.eu-S936272AbXHGVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936272AbXHGVGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935577AbXHGUxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56496 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935749AbXHGUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:52:59 -0400
Date: Tue, 7 Aug 2007 13:46:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, neilb@suse.de, m.hampel@gmx.de
Subject: [2.6.22.2 review 39/84] md: raid10: fix use-after-free of bio
Message-ID: <20070807204604.GO23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-raid10-fix-use-after-free-of-bio.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Maik Hampel <m.hampel@gmx.de>

In case of read errors raid10d tries to print a nice error message,
unfortunately using data from an already put bio.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>
Acked-By: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/md/raid10.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1565,7 +1565,6 @@ static void raid10d(mddev_t *mddev)
 			bio = r10_bio->devs[r10_bio->read_slot].bio;
 			r10_bio->devs[r10_bio->read_slot].bio =
 				mddev->ro ? IO_BLOCKED : NULL;
-			bio_put(bio);
 			mirror = read_balance(conf, r10_bio);
 			if (mirror == -1) {
 				printk(KERN_ALERT "raid10: %s: unrecoverable I/O"
@@ -1573,8 +1572,10 @@ static void raid10d(mddev_t *mddev)
 				       bdevname(bio->bi_bdev,b),
 				       (unsigned long long)r10_bio->sector);
 				raid_end_bio_io(r10_bio);
+				bio_put(bio);
 			} else {
 				const int do_sync = bio_sync(r10_bio->master_bio);
+				bio_put(bio);
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "raid10: %s: redirecting sector %llu to"

-- 
