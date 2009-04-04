Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZDDMRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZDDMRz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZDDMRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:17:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53386 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZDDMRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=f52d7PNtX22Ik5pn/rQSyGAKPNtrOMjpcKdE6MALNetgrnvR/rEO633eQuZE4FMERX
         8lu1Fh0wgnlLpqm/Ln8slXLB91eefPBIrkkLHn7x8Ce1TKREd4XiOBKEZBGS1Lv1KAnt
         9xyARTbcBhIbcP5T3w/1f/yccVCn96+OHQiVQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/3] ide-cd: cdrom_decode_status: simplify do_end_request logic
Date: Sat, 4 Apr 2009 14:20:03 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238745519-19389-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1238745519-19389-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904041420.03842.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 03 April 2009, Borislav Petkov wrote:
> Set do_end_request per default which results in several lines removed
> and simplifying code flow. Also, add defines for cdrom_decode_status's
> return codes instead of naked numbers.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |   35 ++++++++++++-----------------------
>  drivers/ide/ide-cd.h |    9 ++++++---
>  2 files changed, 18 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index bc37027..59a8bc2 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -301,17 +301,11 @@ static int ide_cd_breathe(ide_drive_t *drive, struct request *rq)
>  	}
>  }
>  
> -/**
> - * Returns:
> - * 0: if the request should be continued.
> - * 1: if the request will be going through error recovery.
> - * 2: if the request should be ended.
> - */
>  static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct request *rq = hwif->rq;
> -	int err, sense_key, do_end_request;
> +	int err, sense_key, do_end_request = 1;

I think that do_end_request inversion makes code harder to follow
and adds risk of subtle behavior changes.  It is not worth it IMHO,
especialy since we may later remove this variable by doing a bit
of code re-organization.

[...]

> @@ -18,15 +18,18 @@
>  
>  #define ATAPI_WAIT_WRITE_BUSY	(10 * HZ)
>  
> -/************************************************************************/
> -
> -#define SECTOR_BITS 		9
> +#define SECTOR_BITS		9
>  #ifndef SECTOR_SIZE
>  #define SECTOR_SIZE		(1 << SECTOR_BITS)
>  #endif

you may remove this extra SECTOR_SIZE definition while at it

>  #define SECTORS_PER_FRAME	(CD_FRAMESIZE >> SECTOR_BITS)
>  #define SECTOR_BUFFER_SIZE	(CD_FRAMESIZE * 32)
>  
> +/* internal decode_status codes */
> +#define REQ_CONT               0
> +#define REQ_RECOVER            1
> +#define REQ_FAIL               2

REQ_* prefix is too generic, IDE_RQ_*?  also please use enum for it
