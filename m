Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYBXHyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYBXHyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYBXHyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:54:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:33814 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751454AbYBXHyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:54:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NFbRWc6zNMdgkv5Fb5I2wtglJrNVijUw0ABR9ad
	TNmfAlN7DFUZrl
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <1203752563.5225.4.camel@homer.simson.net>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 08:54:43 +0100
Message-Id: <1203839683.17463.9.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-23 at 08:42 +0100, Mike Galbraith wrote:

>  Meanwhile back at the ranch, reverting
> 6b00769fe1502b4ad97bb327ef7ac971b208bfb5
> 40b01b9bbdf51ae543a04744283bf2d56c4a6afa and the one entangled line from
> dde2020754aeb14e17052d61784dcb37f252aac2 did restore my burner.

It looks like the reason for boot failure with
40b01b9bbdf51ae543a04744283bf2d56c4a6afa may be that one hunk of
6b00769fe1502b4ad97bb327ef7ac971b208bfb5 was supposed to land in
40b01b9bbdf51ae543a04744283bf2d56c4a6afa (per comment);

diff --git a/block/blk-map.c b/block/blk-map.c
index a7cf63c..09f7fd0 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -154,6 +155,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 
 		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len += pad_len;
 		bio->bi_size += pad_len;
+		rq->data_len += pad_len;
 	}
 
 	rq->buffer = rq->data = NULL;


Something else looks funny with
6b00769fe1502b4ad97bb327ef7ac971b208bfb5, did something go missing?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 135c1d0..ba21d97 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1014,10 +1014,6 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	}
 
 	req->buffer = NULL;
-	if (blk_pc_request(req))
-		sdb->length = req->data_len;
-	else
-		sdb->length = req->nr_sectors << 9;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of  <== here
@@ -1026,6 +1022,10 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
 	BUG_ON(count > sdb->table.nents);
 	sdb->table.nents = count;
+	if (blk_pc_request(req))
+		sdb->length = req->data_len;
+	else
+		sdb->length = req->nr_sectors << 9;
 	return BLKPREP_OK;
 }
 




