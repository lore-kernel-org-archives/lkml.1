Return-Path: <linux-kernel-owner+w=401wt.eu-S1946279AbXBCCmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946279AbXBCCmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946276AbXBCCju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:39:50 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53264 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946267AbXBCCja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:39:30 -0500
Message-Id: <20070203024348.243162000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:43 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 39/59] md: make repair actually work for raid1.
Content-Disposition: inline; filename=md-make-repair-actually-work-for-raid1.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

When 'repair' finds a block that is different one the various
parts of the mirror. it is meant to write a chosen good version
to the others.  However it currently writes out the original data
to each. The memcpy to make all the data the same is missing.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/raid1.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6.19.2.orig/drivers/md/raid1.c
+++ linux-2.6.19.2/drivers/md/raid1.c
@@ -1266,6 +1266,11 @@ static void sync_request_write(mddev_t *
 					sbio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+					for (j = 0; j < vcnt ; j++)
+						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
+						       page_address(pbio->bi_io_vec[j].bv_page),
+						       PAGE_SIZE);
+
 				}
 			}
 	}

--
