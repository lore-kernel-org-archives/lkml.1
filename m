Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbXLAWqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbXLAWqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 17:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXLAWpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 17:45:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:53479 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXLAWpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 17:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=NbVx1Ytiz9SOsB+blUpS9vd2vNtSgP4qLa7/miqrKPDd3ufb9g1XFnTKARMIJ15YCSep9pvm+o3vgGZVqzMcKTlg8C/nQuIP5NtRa2KbLwqRepmT91LurhrrszN8cPAqpKVOOUfzUCFQyeDq2MOH5kDuQRNczlmrdhxtnTR44+4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 24/28] blk_end_request: changing ide normal caller (take 3)
Date: Sat, 1 Dec 2007 23:53:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
References: <20071130.183358.35360061.k-ueda@ct.jp.nec.com>
In-Reply-To: <20071130.183358.35360061.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712012353.05187.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Kiyoshi Ueda wrote:
> This patch converts "normal" parts of ide to use blk_end_request().
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  drivers/ide/ide-cd.c |    6 +++---
>  drivers/ide/ide-io.c |   17 ++++++-----------
>  2 files changed, 9 insertions(+), 14 deletions(-)

[...]

> Index: 2.6.24-rc3-mm2/drivers/ide/ide-io.c
> ===================================================================
> --- 2.6.24-rc3-mm2.orig/drivers/ide/ide-io.c
> +++ 2.6.24-rc3-mm2/drivers/ide/ide-io.c
> @@ -78,14 +78,9 @@ static int __ide_end_request(ide_drive_t
>  		ide_dma_on(drive);
>  	}
>  
> -	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
> -		add_disk_randomness(rq->rq_disk);
> -		if (dequeue) {
> -			if (!list_empty(&rq->queuelist))
> -				blkdev_dequeue_request(rq);
> +	if (!__blk_end_request(rq, uptodate, nr_bytes)) {
> +		if (dequeue)
>  			HWGROUP(drive)->rq = NULL;
> -		}
> -		end_that_request_last(rq, uptodate);
>  		ret = 0;
>  	}

Hmmm, this seems to change the old behavior (the request should
be dequeued from the queue only if 'dequeue' variable is set)
and AFAIR some error handling code (in ide-cd?) depends on the
old behavior so please revisit this patch.

Thanks,
Bart
