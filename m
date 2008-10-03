Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYJCRo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYJCRo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYJCRnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:43:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:33468 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYJCRnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PehDenk1UZ/A3bJhtAdmUxq+t5ypeJEpvCAHld4F04nZiRTGhrtKjt8Bn7F8JcDDSE
         xFxqWgVRezgRWURO+2uztHlxx5QbBuZqjFVWjhaFIsqdYV5oQmSXuTYE6iL73ACR8pFR
         dZscMYTh9M6WCXKovubwOpgJZnMhcTMIoVr9c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/3] ide-cd: shorten ide_cd_request_sense_fixup's param list
Date: Fri, 3 Oct 2008 19:29:23 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com> <1222669799-6565-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1222669799-6565-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810031929.24291.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2008, Borislav Petkov wrote:
> ... since HWGROUP(drive)->rq points to the same rq as in the irq handler. While

Since we already have obtained rq pointer why not pass it to the helper
function instead of having the helper function waste cycles on it?

Moreover it results in slightly bigger code...

> at it, remove stale comment.

I applied this part only.

> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index e41b94d..bf92cd6 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -843,12 +843,11 @@ static void ide_cd_restore_request(ide_drive_t *drive, struct request *rq)
>  	rq->q->prep_rq_fn(rq->q, rq);
>  }
>  
> -/*
> - * All other packet commands.
> - */
> -static void ide_cd_request_sense_fixup(ide_drive_t *drive, struct request *rq)
> +static void ide_cd_request_sense_fixup(ide_drive_t *drive)
>  {
>  
> +	struct request *rq = HWGROUP(drive)->rq;
> +
>  	ide_debug_log(IDE_DBG_FUNC, "Call %s, rq->cmd[0]: 0x%x\n",
>  		      __func__, rq->cmd[0]);
>  
> @@ -1021,7 +1020,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  			cdrom_end_request(drive, uptodate);
>  			return ide_stopped;
>  		} else if (!blk_pc_request(rq)) {
> -			ide_cd_request_sense_fixup(drive, rq);
> +			ide_cd_request_sense_fixup(drive);
>  			/* complain if we still have data left to transfer */
>  			uptodate = rq->data_len ? 0 : 1;
>  		}
