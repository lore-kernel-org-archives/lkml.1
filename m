Return-Path: <linux-kernel-owner+w=401wt.eu-S1422817AbXCGRwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbXCGRwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422779AbXCGRvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:51:51 -0500
Received: from mx1.suse.de ([195.135.220.2]:43718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422790AbXCGROp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:45 -0500
Message-Id: <20070307171250.083448111@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Martin Michlmayr <tbm@cyrius.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Rod Whitby <rod@whitby.id.au>
Subject: [patch 028/101] MTD: Fatal regression in drivers/mtd/redboot.c in 2.6.20
Content-Disposition: inline; filename=mtd-fatal-regression-in-drivers-mtd-redboot.c-in-2.6.20.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

[MTD] Fix regression in RedBoot partition scanning

This fixes a regression introduced by the attempt to handle RedBoot FIS
tables which are smaller than an eraseblock, in commit
0b47d654089c5ce3f2ea26a4485db9bcead1e515

It moves the recalculation of the number of slots in the table to the
correct place, and improves the heuristic for when we think we need to
byte-swap what we read from the flash.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Cc: Rod Whitby <rod@whitby.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/redboot.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- linux-2.6.20.1.orig/drivers/mtd/redboot.c
+++ linux-2.6.20.1/drivers/mtd/redboot.c
@@ -94,8 +94,19 @@ static int parse_redboot_partitions(stru
 			 * (NOTE: this is 'size' not 'data_length'; size is
 			 * the full size of the entry.)
 			 */
-			if (swab32(buf[i].size) == master->erasesize) {
+
+			/* RedBoot can combine the FIS directory and
+			   config partitions into a single eraseblock;
+			   we assume wrong-endian if either the swapped
+			   'size' matches the eraseblock size precisely,
+			   or if the swapped size actually fits in an
+			   eraseblock while the unswapped size doesn't. */
+			if (swab32(buf[i].size) == master->erasesize ||
+			    (buf[i].size > master->erasesize
+			     && swab32(buf[i].size) < master->erasesize)) {
 				int j;
+				/* Update numslots based on actual FIS directory size */
+				numslots = swab32(buf[i].size) / sizeof (struct fis_image_desc);
 				for (j = 0; j < numslots; ++j) {
 
 					/* A single 0xff denotes a deleted entry.
@@ -120,11 +131,11 @@ static int parse_redboot_partitions(stru
 					swab32s(&buf[j].desc_cksum);
 					swab32s(&buf[j].file_cksum);
 				}
+			} else if (buf[i].size < master->erasesize) {
+				/* Update numslots based on actual FIS directory size */
+				numslots = buf[i].size / sizeof(struct fis_image_desc);
 			}
 			break;
-		} else {
-			/* re-calculate of real numslots */
-			numslots = buf[i].size / sizeof(struct fis_image_desc);
 		}
 	}
 	if (i == numslots) {

--
