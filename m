Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbYCEM3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbYCEM3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbYCEM25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:28:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:33928 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755888AbYCEM24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:28:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1875GwhHc47bHRYF0j/BQUYZM1zJCmiGUK/U2EyYK
	kC/uL8mzssIX1S
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
	count
From: Mike Galbraith <efault@gmx.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Tejun Heo <htejun@gmail.com>, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, tomof@acm.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <47CE72EF.7050302@panasas.com>
References: <47CD7C05.1080707@gmail.com>	<20080305041914V.tomof@acm.org>
	 <47CDDC31.4070806@gmail.com>
	 <20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
	 <47CE72EF.7050302@panasas.com>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 13:28:50 +0100
Message-Id: <1204720130.8022.1.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-05 at 12:16 +0200, Boaz Harrosh wrote:

> Please test it solves the CD burning problem.

Works for me.

	-Mike

> (The patch includes the revert of commit e97a294e)
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Wed, 5 Mar 2008 12:07:12 +0200
> Subject: [PATCH] blk: missing add of padded bytes to io completion byte count
> 
> the commit e97a294ef6938512b655b1abf17656cf2b26f709 was very wrong. This is
> because scsi-ml supports the ability to split a request into smaller chunks,
> in which case scsi_bufflen() is smaller then request length. Then at completion
> time the remainder can be issued as a new scsi command. In that case the above
> commit is a data corruption.
> 
> Also in this fix all users of block layer are taken care of, and not only
> scsi devices.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  block/blk-core.c    |    4 ++++
>  drivers/scsi/scsi.c |    2 +-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2a438a9..37fcccc 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1549,6 +1549,9 @@ static int __end_that_request_first(struct request *req, int error,
>  			     nr_bytes >> 9, req->sector);
>  	}
>  
> +	if (nr_bytes >= blk_rq_bytes(req))
> +		nr_bytes += req->extra_len;
> +
>  	total_bytes = bio_nbytes = 0;
>  	while ((bio = req->bio) != NULL) {
>  		int nbytes;
> @@ -1616,6 +1619,7 @@ static int __end_that_request_first(struct request *req, int error,
>  	if (!req->bio)
>  		return 0;
>  
> +	BUG_ON(total_bytes >= blk_rq_bytes(req));
>  	/*
>  	 * if the request wasn't completed, update state
>  	 */
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index e5c6f6a..fecba05 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  				"Notifying upper driver of completion "
>  				"(result %x)\n", cmd->result));
>  
> -	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
> +	good_bytes = scsi_bufflen(cmd);
>          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
>  		drv = scsi_cmd_to_driver(cmd);
>  		if (drv->done)

