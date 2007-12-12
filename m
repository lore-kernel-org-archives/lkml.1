Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbXLLJKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbXLLJKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXLLJKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:10:11 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27909 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758412AbXLLJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:10:06 -0500
Message-ID: <475FA538.7000609@panasas.com>
Date: Wed, 12 Dec 2007 11:09:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, grant.likely@secretlab.ca
Subject: Re: [PATCH 20/30] blk_end_request: changing xsysace (take 4)
References: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 09:09:15.0533 (UTC) FILETIME=[AB3B03D0:01C83C9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kiyoshi Ueda wrote:
> This patch converts xsysace to use blk_end_request interfaces.
> Related 'uptodate' arguments are converted to 'error'.
> 
> xsysace is a little bit different from "normal" drivers.
> xsysace driver has a state machine in it.
> It calls end_that_request_first() and end_that_request_last()
> from different states. (ACE_FSM_STATE_REQ_TRANSFER and
> ACE_FSM_STATE_REQ_COMPLETE, respectively.)
> 
> However, those states are consecutive and without any interruption
> inbetween.
> So we can just follow the standard conversion rule (b) mentioned in
> the patch subject "[PATCH 01/30] blk_end_request: add new request
> completion interface".
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  drivers/block/xsysace.c |    5 +----
>  1 files changed, 1 insertion(+), 4 deletions(-)
> 
> Index: 2.6.24-rc4/drivers/block/xsysace.c
> ===================================================================
> --- 2.6.24-rc4.orig/drivers/block/xsysace.c
> +++ 2.6.24-rc4/drivers/block/xsysace.c
> @@ -703,7 +703,7 @@ static void ace_fsm_dostate(struct ace_d
>  
>  		/* bio finished; is there another one? */
>  		i = ace->req->current_nr_sectors;
> -		if (end_that_request_first(ace->req, 1, i)) {
> +		if (__blk_end_request(ace->req, 0, i)) {
end_that_request_first() took sectors __blk_end_request() now takes
bytes

>  			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
>  			 *      ace->req->hard_nr_sectors,
>  			 *      ace->req->current_nr_sectors);
> @@ -718,9 +718,6 @@ static void ace_fsm_dostate(struct ace_d
>  		break;
>  
>  	case ACE_FSM_STATE_REQ_COMPLETE:
> -		/* Complete the block request */
> -		blkdev_dequeue_request(ace->req);
> -		end_that_request_last(ace->req, 1);
>  		ace->req = NULL;
>  
>  		/* Finished request; go to idle state */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Boaz
