Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZG2Q2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZG2Q2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZG2Q2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:28:43 -0400
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:43780 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbZG2Q2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:28:42 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 12:28:41 EDT
X-MXL-Hash: 4a7078ba518a1036-db38b29365fbc9d972ace794703edfa29411d40a
X-MXL-Hash: 4a70757d623d26a2-c0f38831a38d557b68e1e84b620dd7c7e7a8f51c
Message-ID: <4A707578.3010901@steeleye.com>
Date: Wed, 29 Jul 2009 12:14:48 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>
CC: ian.campbell@citrix.com
Subject: [BUG] raid1 behind writes alter bio structure illegally
Content-Type: multipart/mixed;
 boundary="------------020107010406080701090800"
X-OriginalArrivalTime: 29 Jul 2009 16:14:48.0545 (UTC) FILETIME=[B1E0B510:01CA1067]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009071501)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [207.43.68.209]
X-AnalysisOut: [v=1.0 c=1 a=sbfkrs-6MiwA:10 a=m0bDsMyWfisirut6+qvwwQ==:17 ]
X-AnalysisOut: [a=LCk_woE_KLhvUd_Ag6EA:9 a=GgEz_z-d1_GhfqDnjkEA:7 a=yhO8dJ]
X-AnalysisOut: [HY9fJm1B4D0wTAb_6W3EYA:4 a=gKaebBb_zKi-ADdQOd8A:9 a=2Np9Sn]
X-AnalysisOut: [tYLsij6apzplpMNDpG6XsA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020107010406080701090800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've run into this bug on a 2.6.18 kernel, but I think the fix is still 
applicable to the latest kernels (even though the symptoms would be 
slightly different).

Perhaps someone who knows the block and/or SCSI layers well can comment 
on the legality of attaching new pages to a bio without fixing up the 
internal bio counters (details below)?

Thanks,
Paul

Environment:
-----------

Citrix XenServer 5.5 (2.6.18 Red Hat-derived kernel)

LVM over raid1 over SCSI/nbd

Description:
-----------

The problem is due to the behind-write code in raid1. It turns out the 
code is doing something a little non-kosher with the bio's and pages
associated with them. This causes (at least) the SCSI layer to get upset 
and fail the write requests.

Basically, when we do behind writes in raid1, we have to make a copy of
the original data that is being written, since we're going to complete
the request back up to user level before all the devices are finished
writing the data (e.g., the SCSI disk completes the write and raid1 then
completes the write back to user level, while nbd is still sending data
across the network).

The problem is actually a pretty simple one -- these copied pages 
(behind_pages in raid1 code) are allocated at different memory addresses 
than the original ones (obviously). This can cause the internal segment 
counts (nr_phys_segments) that were calculated in the bio when it was 
originally created (or cloned) to be invalid. Specifically, the SCSI 
layer notices the values are invalid when it tries to build its scatter 
gather list. The error:

Incorrect number of segments after building list
counted 94, received 64
req nr_sec 992, cur_nr_sec 8

appears in the kernel logs when this happens. (This exact message is no 
longer present in the kernel, but SCSI still appears to be building its 
scatter gather list in a similar fashion.)

Solution:
--------

The patch adds a call to blk_recount_segments to fix up the bio
structure to account for the new page addresses that have
been attached to the bio.

--------------020107010406080701090800
Content-Type: text/x-diff;
 name="xen-5.5-raid1-blk_recount_segments_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xen-5.5-raid1-blk_recount_segments_fix.diff"

diff -purN --exclude-from=/export/public/clemep/tmp/dontdiff linux-orig/block/ll_rw_blk.c linux-2.6.18-128.1.6.el5.xs5.5.0.496.1012xen/block/ll_rw_blk.c
--- linux-orig/block/ll_rw_blk.c	2009-05-29 07:29:54.000000000 -0400
+++ linux-2.6.18-128.1.6.el5.xs5.5.0.496.1012xen/block/ll_rw_blk.c	2009-07-28 13:36:19.000000000 -0400
@@ -1374,6 +1374,7 @@ new_hw_segment:
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
 
+EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)
diff -purN --exclude-from=/export/public/clemep/tmp/dontdiff linux-orig/drivers/md/raid1.c linux-2.6.18-128.1.6.el5.xs5.5.0.496.1012xen/drivers/md/raid1.c
--- linux-orig/drivers/md/raid1.c	2009-05-29 07:29:54.000000000 -0400
+++ linux-2.6.18-128.1.6.el5.xs5.5.0.496.1012xen/drivers/md/raid1.c	2009-07-28 13:35:36.000000000 -0400
@@ -900,6 +900,7 @@ static int make_request(request_queue_t 
 			 */
 			__bio_for_each_segment(bvec, mbio, j, 0)
 				bvec->bv_page = behind_pages[j];
+			blk_recount_segments(q, mbio);
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
 		}


--------------020107010406080701090800--
