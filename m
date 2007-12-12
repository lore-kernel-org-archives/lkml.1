Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXLLRIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXLLRIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbXLLRI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:08:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXLLRI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:08:26 -0500
Date: Wed, 12 Dec 2007 12:06:48 -0500 (EST)
Message-Id: <20071212.120648.71084437.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 20/30] blk_end_request: changing xsysace (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <475FA538.7000609@panasas.com>
References: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
	<475FA538.7000609@panasas.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 12 Dec 2007 11:09:12 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > Index: 2.6.24-rc4/drivers/block/xsysace.c
> > ===================================================================
> > --- 2.6.24-rc4.orig/drivers/block/xsysace.c
> > +++ 2.6.24-rc4/drivers/block/xsysace.c
> > @@ -703,7 +703,7 @@ static void ace_fsm_dostate(struct ace_d
> >  
> >  		/* bio finished; is there another one? */
> >  		i = ace->req->current_nr_sectors;
> > -		if (end_that_request_first(ace->req, 1, i)) {
> > +		if (__blk_end_request(ace->req, 0, i)) {
>
> end_that_request_first() took sectors __blk_end_request() now takes
> bytes

Thank you for pointing it out!  And I'm very sorry for the bug.
I have checked all conversions between sectors and bytes through
all patches again, and I found no other miss conversions.

Below is the revised patch for xsysace.

Thanks,
Kiyoshi Ueda


Subject: [PATCH 20/30] blk_end_request: changing xsysace (take 4)

This patch converts xsysace to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

xsysace is a little bit different from "normal" drivers.
xsysace driver has a state machine in it.
It calls end_that_request_first() and end_that_request_last()
from different states. (ACE_FSM_STATE_REQ_TRANSFER and
ACE_FSM_STATE_REQ_COMPLETE, respectively.)

However, those states are consecutive and without any interruption
inbetween.
So we can just follow the standard conversion rule (b) mentioned in
the patch subject "[PATCH 01/30] blk_end_request: add new request
completion interface".


In ace_fsm_dostate(), the variable 'i' was used only for passing
sector size of the request to end_that_request_first().
So I removed it and changed the code to pass the size in bytes
directly to __blk_end_request().

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xsysace.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

Index: 2.6.24-rc4/drivers/block/xsysace.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/xsysace.c
+++ 2.6.24-rc4/drivers/block/xsysace.c
@@ -483,7 +483,6 @@ static void ace_fsm_dostate(struct ace_d
 	u32 status;
 	u16 val;
 	int count;
-	int i;
 
 #if defined(DEBUG)
 	dev_dbg(ace->dev, "fsm_state=%i, id_req_count=%i\n",
@@ -688,7 +687,6 @@ static void ace_fsm_dostate(struct ace_d
 		}
 
 		/* Transfer the next buffer */
-		i = 16;
 		if (ace->fsm_task == ACE_TASK_WRITE)
 			ace->reg_ops->dataout(ace);
 		else
@@ -702,8 +700,8 @@ static void ace_fsm_dostate(struct ace_d
 		}
 
 		/* bio finished; is there another one? */
-		i = ace->req->current_nr_sectors;
-		if (end_that_request_first(ace->req, 1, i)) {
+		if (__blk_end_request(ace->req, 0,
+				      blk_rq_cur_bytes(ace->req))) {
 			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
 			 *      ace->req->hard_nr_sectors,
 			 *      ace->req->current_nr_sectors);
@@ -718,9 +716,6 @@ static void ace_fsm_dostate(struct ace_d
 		break;
 
 	case ACE_FSM_STATE_REQ_COMPLETE:
-		/* Complete the block request */
-		blkdev_dequeue_request(ace->req);
-		end_that_request_last(ace->req, 1);
 		ace->req = NULL;
 
 		/* Finished request; go to idle state */
