Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbZBNBsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbZBNBsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbZBNBRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:17:00 -0500
Received: from kroah.org ([198.145.64.141]:50770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763383AbZBNBQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:49 -0500
Date: Fri, 13 Feb 2009 17:13:58 -0800
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
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 48/48] ide-cd: fix DMA for non bio-backed requests
Message-ID: <20090214011358.GW17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-cd-fix-dma-for-non-bio-backed-requests.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <petkovbb@googlemail.com>

commit 9e772d0135a5b5f8355320be429efa339700d52d upstream.

This one fixes http://bugzilla.kernel.org/show_bug.cgi?id=12320.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c |    3 +++
 drivers/ide/ide-io.c |    9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -984,6 +984,9 @@ static ide_startstop_t cdrom_newpc_intr(
 		if (blk_fs_request(rq)) {
 			ide_end_request(drive, 1, rq->nr_sectors);
 			return ide_stopped;
+		} else if (rq->cmd_type == REQ_TYPE_ATA_PC && !rq->bio) {
+			ide_end_request(drive, 1, 1);
+			return ide_stopped;
 		}
 		goto end_request;
 	}
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -577,11 +577,14 @@ void ide_map_sg(ide_drive_t *drive, stru
 	if (hwif->sg_mapped)	/* needed by ide-scsi */
 		return;
 
-	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
-		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
-	} else {
+	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
 		hwif->sg_nents = 1;
+	} else if (!rq->bio) {
+		sg_init_one(sg, rq->data, rq->data_len);
+		hwif->sg_nents = 1;
+	} else {
+		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 	}
 }
 

