Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYBLV1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYBLV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYBLVZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:25:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:44448 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbYBLVZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Xn88Mup2mCvAkz4e+B+ELGSp4EDF6YYl+rPVlfz8f83hyOGBbGSp4qpiqRGfLmaoC8DHR9zTvX22qJ8NtkWqMM/dFS2lI6nV5a/5G7utfLV5HakSSKAeDfBpSaX8F96BsDrfoyDiZt8HyYcPvUWVPaUCDHPCRLj47TscjYYMYuM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-scsi: do non-atomic pc->flags testing
Date: Tue, 12 Feb 2008 21:17:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202718880-1793-1-git-send-email-petkovbb@gmail.com> <200802121328.48515.bzolnier@gmail.com> <20080212152550.GE4530@gollum.tnic>
In-Reply-To: <20080212152550.GE4530@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122117.14156.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Borislav Petkov wrote:
> commit 272976f0f5754707f9e41da315717a6eb8d9d536
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Tue Feb 12 16:22:44 2008 +0100
> 
>     ide-scsi: do non-atomic pc->flags testing
> 
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
> index 5ec421c..eb84cdc 100644
> --- a/drivers/scsi/ide-scsi.c
> +++ b/drivers/scsi/ide-scsi.c
> @@ -319,8 +319,10 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
>  		pc = opc;
>  		rq = pc->rq;
>  		pc->scsi_cmd->result = (CHECK_CONDITION << 1) |
> -					((test_bit(PC_TIMEDOUT, &pc->flags)?DID_TIME_OUT:DID_OK) << 16);
> -	} else if (test_bit(PC_TIMEDOUT, &pc->flags)) {
> +					(((pc->flags & PC_TIMEDOUT) ?
> +							  DID_TIME_OUT :
> +							  DID_OK) << 16);
> +	} else if (pc->flags & PC_TIMEDOUT) {

How's about renaming flag defines to PC_FLAG_* at the same time
(like it was done for other ATAPI drivers)?

Otherwise looks good.
