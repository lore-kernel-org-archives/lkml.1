Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYLPTPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYLPTPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYLPTPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:15:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:40415 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYLPTPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=roS/1zLrNFVhRlnyAxIdNEyN7u1vzYz1sSROBmZ5xlhGF+gdJc7Kh7gmvL4kLfasjw
         nMKGHPFcpkKX9DKbJbNleMqeAD+4f66rckbJH1Crk6noduXrpJEIhk/i/oq/UV7cpBgU
         F21DYpCRozvIk+PDyuETqu0WUqQP53Qtqesi4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Subject: Re: [PATCH] ide: Fix drive's DWORD-IO handling
Date: Tue, 16 Dec 2008 20:13:15 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <4945968D.7050300@inf.tu-dresden.de>
In-Reply-To: <4945968D.7050300@inf.tu-dresden.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812162013.15461.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2008, Mario Schwalbe wrote:
> According the documentation, id[ATA_ID_DWORD_IO] is non-zero if
> the drive supports dword IO, while the code disables support by
> setting IDE_DFLAG_NO_IO_32BIT. In addition, this word has been
> reused by the ATA8 specification. This patch fixes both cases.
> ---
>  drivers/ide/ide-probe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
> index c55bdbd..859b0e5 100644
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -856,7 +856,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
>  		ide_drive_t *drive = &hwif->drives[unit];
> 
>  		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
> -		    drive->id[ATA_ID_DWORD_IO])
> +		    !ata_id_has_dword_io(drive->id))
>  			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
>  		else
>  			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;

This change is OK and I would happily apply the patch but...

ata_id_has_dword_io() itself has bugs that need fixing (which would
have a nice side-effect of fixing some libata drivers that happen to
use it directly).  ATA_ID_DWORD_IO word is defined only in ATA-1 spec
and devices confirming to the later versions of spec support dword IO
just fine despite using zero value for the said word.

Thus could you please fix ata_id_has_dword_io() first (preferrably in
a separate patch) and than re-submit this patch (btw please remember to
include "Signed-off-by" line in your patches).

Thanks,
Bart
