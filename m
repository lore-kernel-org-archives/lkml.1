Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbXDBHh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbXDBHh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXDBHh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:37:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49130 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbXDBHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:37:27 -0400
Date: Mon, 2 Apr 2007 10:37:25 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Rene Herman <rene.herman@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <20070402071018.GE11996@kernel.dk>
Message-ID: <Pine.LNX.4.64.0704021036130.25134@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
 <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
 <20070402071018.GE11996@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Jens Axboe wrote:
> Updated patch attached :-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 0bc8b0b..cff761a 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -324,3 +324,10 @@ Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
>  Who:	Wim Van Sebroeck <wim@iguana.be>
>  
>  ---------------------------
> +
> +What:	The legacy CDROM drivers (drivers/cdrom/, except cdrom.c)
> +When:	In 2.6.23
> +Why:	They are all terminally broken (most don't even compile)
> +Who:	Jens Axboe <jens.axboe@oracle.com>
> +
> +---------------------------

I am certainly ok with that. But until then, update patch below =)

			Pekka

diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
index f574962..a1e4297 100644
--- a/drivers/cdrom/mcdx.c
+++ b/drivers/cdrom/mcdx.c
@@ -577,56 +577,57 @@ static void do_mcdx_request(request_queu
 	if (!req)
 		return;
 
+	if (!blk_fs_request(req)) {
+		end_request(req, 0);
+		goto again;
+	}
+
 	stuffp = req->rq_disk->private_data;
 
 	if (!stuffp->present) {
 		xwarn("do_request(): bad device: %s\n",req->rq_disk->disk_name);
 		xtrace(REQUEST, "end_request(0): bad device\n");
 		end_request(req, 0);
-		return;
+		goto again;
 	}
 
 	if (stuffp->audio) {
 		xwarn("do_request() attempt to read from audio cd\n");
 		xtrace(REQUEST, "end_request(0): read from audio\n");
 		end_request(req, 0);
-		return;
+		goto again;
 	}
 
 	xtrace(REQUEST, "do_request() (%lu + %lu)\n",
 	       req->sector, req->nr_sectors);
 
-	if (req->cmd != READ) {
+	if (rq_data_dir(req) != READ) {
 		xwarn("do_request(): non-read command to cd!!\n");
 		xtrace(REQUEST, "end_request(0): write\n");
 		end_request(req, 0);
-		return;
-	}
-	else {
-		stuffp->status = 0;
-		while (req->nr_sectors) {
-			int i;
-
-			i = mcdx_transfer(stuffp,
-					  req->buffer,
-					  req->sector,
-					  req->nr_sectors);
-
-			if (i == -1) {
-				end_request(req, 0);
-				goto again;
-			}
-			req->sector += i;
-			req->nr_sectors -= i;
-			req->buffer += (i * 512);
-		}
-		end_request(req, 1);
 		goto again;
-
-		xtrace(REQUEST, "end_request(1)\n");
-		end_request(req, 1);
 	}
 
+	stuffp->status = 0;
+	while (req->nr_sectors) {
+		int i;
+
+		spin_unlock_irq(q->queue_lock);
+		i = mcdx_transfer(stuffp,
+				  req->buffer,
+				  req->sector,
+				  req->nr_sectors);
+		spin_lock_irq(q->queue_lock);
+
+		if (i == -1) {
+			end_request(req, 0);
+			goto again;
+		}
+		req->sector += i;
+		req->nr_sectors -= i;
+		req->buffer += (i * 512);
+	}
+	end_request(req, 1);
 	goto again;
 }
 
 
