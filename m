Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbZEPNme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbZEPNme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZEPNmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:42:22 -0400
Received: from h155.mvista.com ([63.81.120.155]:64231 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753908AbZEPNmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:42:21 -0400
Message-ID: <4A0EC2AD.20704@ru.mvista.com>
Date: Sat, 16 May 2009 17:42:05 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com,
       zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org>
In-Reply-To: <1241751256-17435-12-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tejun Heo wrote:

> swim processes requests one-by-one synchronously and can easily be
> converted to dequeuing model.  Convert it.
>
> [ Impact: dequeue in-flight request ]
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Laurent Vivier <Laurent@lvivier.info>
> ---
>  drivers/block/swim.c |   47 +++++++++++++++++++++++------------------------
>  1 files changed, 23 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/block/swim.c b/drivers/block/swim.c
> index fc6a1c3..dedd489 100644
> --- a/drivers/block/swim.c
> +++ b/drivers/block/swim.c
> @@ -514,7 +514,7 @@ static int floppy_read_sectors(struct floppy_state *fs,
>  			ret = swim_read_sector(fs, side, track, sector,
>  						buffer);
>  			if (try-- == 0)
> -				return -1;
> +				return -EIO;
>  		} while (ret != 512);
>  
>  		buffer += ret;
> @@ -528,38 +528,37 @@ static void redo_fd_request(struct request_queue *q)
>  	struct request *req;
>  	struct floppy_state *fs;
>  
> -	while ((req = elv_next_request(q))) {
> +	req = elv_next_request(q);
> +	if (req)
> +		blkdev_dequeue_request(req);
> +
> +	while (req) {
> +		int err = -EIO;
>  
>  		fs = req->rq_disk->private_data;
> -		if (blk_rq_pos(req) >= fs->total_secs) {
> -			__blk_end_request_cur(req, -EIO);
> -			continue;
> -		}
> -		if (!fs->disk_in) {
> -			__blk_end_request_cur(req, -EIO);
> -			continue;
> -		}
> -		if (rq_data_dir(req) == WRITE) {
> -			if (fs->write_protected) {
> -				__blk_end_request_cur(req, -EIO);
> -				continue;
> -			}
> -		}
> +		if (blk_rq_pos(req) >= fs->total_secs)
> +			goto done;
> +		if (!fs->disk_in)
> +			goto done;
> +		if (rq_data_dir(req) == WRITE && fs->write_protected)
> +			goto done;
> +
>  		switch (rq_data_dir(req)) {
>  		case WRITE:
>  			/* NOT IMPLEMENTED */
> -			__blk_end_request_cur(req, -EIO);
>  			break;
>  		case READ:
> -			if (floppy_read_sectors(fs, blk_rq_pos(req),
> -						blk_rq_cur_sectors(req),
> -						req->buffer)) {
> -				__blk_end_request_cur(req, -EIO);
> -				continue;
> -			}
> -			__blk_end_request_cur(req, 0);
> +			err = floppy_read_sectors(fs, blk_rq_pos(req),
> +						  blk_rq_cur_sectors(req),
> +						  req->buffer);
>  			break;
>  		}
> +	done:
> +		if (!__blk_end_request_cur(req, err)) {
> +			req = elv_next_request(q);
> +			if (req)
> +				blkdev_dequeue_request(req);
> +		}
>  	}
>  }

   And without duplication:

@@ -528,38 +528,37 @@
 static void redo_fd_request(struct request_queue *q)
 {
- 	struct request *req;
 	struct floppy_state *fs;
 
-	while ((req = elv_next_request(q))) {
+	while (1) {
+	 	struct request *req = elv_next_request(q);
+		int err;
+ 
+		if (req == NULL)
+			break;
+		blkdev_dequeue_request(req);
 
+again:
+		err = -EIO;
 		fs = req->rq_disk->private_data;
-		if (blk_rq_pos(req) >= fs->total_secs) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (!fs->disk_in) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (rq_data_dir(req) == WRITE) {
-			if (fs->write_protected) {
-				__blk_end_request_cur(req, -EIO);
-				continue;
-			}
-		}
+		if (blk_rq_pos(req) >= fs->total_secs)
+			goto done;
+		if (!fs->disk_in)
+			goto done;
+		if (rq_data_dir(req) == WRITE && fs->write_protected)
+			goto done;
+
 		switch (rq_data_dir(req)) {
 		case WRITE:
 			/* NOT IMPLEMENTED */
-			__blk_end_request_cur(req, -EIO);
 			break;
 		case READ:
-			if (floppy_read_sectors(fs, blk_rq_pos(req),
-						blk_rq_cur_sectors(req),
-						req->buffer)) {
-				__blk_end_request_cur(req, -EIO);
-				continue;
-			}
-			__blk_end_request_cur(req, 0);
+			err = floppy_read_sectors(fs, blk_rq_pos(req),
+						  blk_rq_cur_sectors(req),
+						  req->buffer);
 			break;
 		}
+	done:
+		if (__blk_end_request_cur(req, err))
+			goto again;
 	}
 }


MBR, Sergei


