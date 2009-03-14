Return-Path: <linux-kernel-owner+w=401wt.eu-S1762449AbZCNBax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762449AbZCNBax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZCNBUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:23 -0400
Received: from kroah.org ([198.145.64.141]:35020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753324AbZCNBUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:35 2009
Message-Id: <20090314011035.827129687@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:07 -0700
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
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 030/114] md/raid10:  Dont call bitmap_cond_end_sync when we are doing recovery.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=md-raid10-don-t-call-bitmap_cond_end_sync-when-we-are-doing-recovery.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 78200d45cde2a79c0d0ae0407883bb264caa3c18 upstream.

For raid1/4/5/6, resync (fixing inconsistencies between devices) is
very similar to recovery (rebuilding a failed device onto a spare).
The both walk through the device addresses in order.

For raid10 it can be quite different.  resync follows the 'array'
address, and makes sure all copies are the same.  Recover walks
through 'device' addresses and recreates each missing block.

The 'bitmap_cond_end_sync' function allows the write-intent-bitmap
(When present) to be updated to reflect a partially completed resync.
It makes assumptions which mean that it does not work correctly for
raid10 recovery at all.

In particularly, it can cause bitmap-directed recovery of a raid10 to
not recovery some of the blocks that need to be recovered.

So move the call to bitmap_cond_end_sync into the resync path, rather
than being in the common "resync or recovery" path.


Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1750,8 +1750,6 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
-	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
-
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
 	 * have bi_end_io, bi_sector, bi_bdev set,
@@ -1887,6 +1885,8 @@ static sector_t sync_request(mddev_t *md
 		/* resync. Schedule a read for every block at this virt offset */
 		int count = 0;
 
+		bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 		if (!bitmap_start_sync(mddev->bitmap, sector_nr,
 				       &sync_blocks, mddev->degraded) &&
 		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {


