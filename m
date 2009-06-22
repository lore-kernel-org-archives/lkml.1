Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZFVLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZFVLnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZFVLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:43:21 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:45870 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbZFVLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=x06iEod55gW8m6EiyYtNKVKpgQbYt2z2azWAkHE8qT5qcy2mvWggcFntJH6O0N/Bo3
         Wc0lhJ41F1Q2CFL1i7GoNnqJpYfnaypuLgDqMb/ePLPa0ouFp2lVwV8B5sHGSyhzMC5Z
         jNRiXuw42Mq5mYOSmBIppXt28ZFP91tIPXdOk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ide-cd: handle fragmented packet commands gracefully
Date: Mon, 22 Jun 2009 11:50:22 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1245574527-2104-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1245574527-2104-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906221150.22992.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 June 2009 10:55:27 Borislav Petkov wrote:
> There are some devices in the wild that clear the DRQ bit during the
> last word of a packet command and therefore could use a "second chance"
> for that last word of data to be xferred instead of simply failing the
> request. Do that by attempting to suck in those last bytes in PIO mode.
> 
> In addition, the ATA_ERR bit has to be cleared for we cannot be sure the
> data is valid otherwise.
> 
> See http://bugzilla.kernel.org/show_bug.cgi?id=13399 for details.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> ---
>  drivers/ide/ide-cd.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 4a19686..8d3f7d0 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -592,9 +592,19 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  			}
>  		} else if (!blk_pc_request(rq)) {
>  			ide_cd_request_sense_fixup(drive, cmd);
> -			/* complain if we still have data left to transfer */
> +
>  			uptodate = cmd->nleft ? 0 : 1;
> -			if (uptodate == 0)
> +
> +			/*
> +			 * suck out the remaining bytes from the drive in an
> +			 * attempt to complete the data xfer. (see BZ#13399)
> +			 */
> +			if (!(stat & ATA_ERR) && !uptodate && thislen) {
> +				ide_pio_bytes(drive, cmd, write, thislen);
> +				uptodate = cmd->nleft ? 0 : 1;
> +			}
> +
> +			if (!uptodate)
>  				rq->cmd_flags |= REQ_FAILED;
>  		}
>  		goto out_end;
