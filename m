Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZENWnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZENWnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZENWl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:41:59 -0400
Received: from kroah.org ([198.145.64.141]:51438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbZENWl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:41:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:20 2009
Message-Id: <20090514223520.813205207@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:39 -0700
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
Subject: [patch 04/51] md/raid10: dont clear bitmap during recovery if array will still be degraded.
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=md-raid10-don-t-clear-bitmap-during-recovery-if-array-will-still-be-degraded.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 18055569127253755d01733f6ecc004ed02f88d0 upstream.

If we have a raid10 with multiple missing devices, and we recover just
one of these to a spare, then we risk (depending on the bitmap and
array chunk size) clearing bits of the bitmap for which recovery isn't
complete (because a device is still missing).

This can lead to a subsequent "re-add" being recovered without
any IO happening, which would result in loss of data.

This patch takes the safe approach of not clearing bitmap bits
if the array will still be degraded.

This patch is suitable for all active -stable kernels.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1807,17 +1807,17 @@ static sector_t sync_request(mddev_t *md
 				r10_bio->sector = sect;
 
 				raid10_find_phys(conf, r10_bio);
-				/* Need to check if this section will still be
+
+				/* Need to check if the array will still be
 				 * degraded
 				 */
-				for (j=0; j<conf->copies;j++) {
-					int d = r10_bio->devs[j].devnum;
-					if (conf->mirrors[d].rdev == NULL ||
-					    test_bit(Faulty, &conf->mirrors[d].rdev->flags)) {
+				for (j=0; j<conf->raid_disks; j++)
+					if (conf->mirrors[j].rdev == NULL ||
+					    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
 						still_degraded = 1;
 						break;
 					}
-				}
+
 				must_sync = bitmap_start_sync(mddev->bitmap, sect,
 							      &sync_blocks, still_degraded);
 


