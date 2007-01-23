Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbXAWA2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbXAWA2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932591AbXAWA1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:27:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:37712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbXAWA1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:27:17 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:26:52 +1100
Message-Id: <1070123002652.29462@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
References: <20070123112437.29357.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When 'repair' finds a block that is different one the various
parts of the mirror. it is meant to write a chosen good version
to the others.  However it currently writes out the original data
to each. The memcpy to make all the data the same is missing.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    5 +++++
 1 file changed, 5 insertions(+)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-01-23 11:13:45.000000000 +1100
+++ ./drivers/md/raid1.c	2007-01-23 11:23:43.000000000 +1100
@@ -1221,6 +1221,11 @@ static void sync_request_write(mddev_t *
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
