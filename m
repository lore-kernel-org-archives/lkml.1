Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYLEJk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYLEJk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYLEJkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:40:13 -0500
Received: from brick.kernel.dk ([93.163.65.50]:8973 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYLEJkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:40:11 -0500
Date: Fri, 5 Dec 2008 10:40:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at block/blk-timeout.c:178!
Message-ID: <20081205094004.GA18255@kernel.dk>
References: <4937E888.3060208@hp.com> <20081204155005.GX18255@kernel.dk> <493801AF.8050308@hp.com> <49382201.8030609@hp.com> <4938466C.8050704@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4938466C.8050704@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04 2008, Alan D. Brunelle wrote:
> Alan D. Brunelle wrote:
> > Alan D. Brunelle wrote:
> >> Jens Axboe wrote:
> >>
> >>> Alan, can you try latest -git? feaf3848a813a106f163013af6fcf6c4bfec92d9
> >>> or later.
> >>>
> >> git pull()ed to: feaf3848a813a106f163013af6fcf6c4bfec92d9 and the same
> >> problem occurs.
> > 
> > Maybe not - I've not been to reproduce that problem in subsequent
> > reboots. It could be that I booted the wrong kernel first time (rc6
> > instead of rc7). Will keep plugging - any idea as to what might have
> > "fixed" the problem between rc6 & rc7?
> > 
> > Alan
> 
> It's back - just not as easily reproduced as before.
> 
> I'm concerned over this piece of code:
> 
> /*
>  * hp_sw_tur - Send TEST UNIT READY
>  * @sdev: sdev command should be sent to
>  *
>  * Use the TEST UNIT READY command to determine
>  * the path state.
>  */
> static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
> {
>         struct request *req;
>         int ret;
> 
>         req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
>         if (!req)
>                 return SCSI_DH_RES_TEMP_UNAVAIL;
> 
>         req->cmd_type = REQ_TYPE_BLOCK_PC;
>         req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>                           REQ_FAILFAST_DRIVER;
>         req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
>         req->cmd[0] = TEST_UNIT_READY;
>         req->timeout = HP_SW_TIMEOUT;
>         req->sense = h->sense;
>         memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
>         req->sense_len = 0;
> 
> retry:
>         ret = blk_execute_rq(req->q, NULL, req, 1);
>         if (ret == -EIO) {
>                 if (req->sense_len > 0) {
>                         ret = tur_done(sdev, h->sense);
>                 } else {
>                         sdev_printk(KERN_WARNING, sdev,
>                                     "%s: sending tur failed with %x\n",
>                                     HP_SW_NAME, req->errors);
>                         ret = SCSI_DH_IO;
>                 }
>         } else {
>                 h->path_state = HP_SW_PATH_ACTIVE;
>                 ret = SCSI_DH_OK;
>         }
>         if (ret == SCSI_DH_IMM_RETRY)
>                 goto retry;
>         if (ret == SCSI_DH_DEV_OFFLINED) {
>                 h->path_state = HP_SW_PATH_PASSIVE;
>                 ret = SCSI_DH_OK;
>         }
> 
>         blk_put_request(req);
> 
>         return ret;
> }
> 
> I've pushed the BUG ON check into blk_execute_rq, and it's finding it
> set there. Could we be getting SCSI_DH_IMM_RETRYs and that's causing the
> same request to be used without being re-initialized, and on error the
> bit is not being cleaned up properly?
> 
> I'm checking that out next...

That does indeed look problematic, we only init the timer stuff when
getting the request initially. So you could either make your retry loop
do blk_put_request() and jump to the very beginning again, or this
should fix the current usage.

diff --git a/block/elevator.c b/block/elevator.c
index a6951f7..0a2f378 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -590,6 +590,12 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 
 	rq->q = q;
 
+	/*
+	 * This could happen on a request requeue, init the timer here as well
+	 */
+	blk_delete_timer(rq);
+	blk_clear_rq_complete(rq);
+
 	switch (where) {
 	case ELEVATOR_INSERT_FRONT:
 		rq->cmd_flags |= REQ_SOFTBARRIER;

-- 
Jens Axboe

