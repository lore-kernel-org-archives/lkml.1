Return-Path: <linux-kernel-owner+w=401wt.eu-S1751985AbYJSSGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbYJSSGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYJSSGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 14:06:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49343 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbYJSSGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 14:06:38 -0400
Date: Sun, 19 Oct 2008 20:05:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: ata_id_is_ssd() bugfix
Message-ID: <20081019180545.GT19428@kernel.dk>
References: <200810182222.13281.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810182222.13281.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18 2008, Bartlomiej Zolnierkiewicz wrote:
> We need to explicitly check for major and minor version
> of supported ATA spec as earlier revisions used word 217
> for different purposes.

What did they use to put in that word? Just curious if it does any harm,
because as it stands, this patch will prevent ANY ssd from being
correctly flagged as such. So I'm inclined to file this as too much spec
fiddling, it'll do more harm than good.

> 
> [ The issue was originally spotted by Alan Cox. ]
> 
> This patch fixes regression introduced by:
> commit 8bff7c6b0f63c7ee9c5e3a076338d74125b8debb
> ("libata: set queue SSD flag for SSD devices").
> 
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> somebody owe me one for going through all these spec drafts... ;)
> 
>  include/linux/ata.h |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Index: b/include/linux/ata.h
> ===================================================================
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -75,6 +75,7 @@ enum {
>  	ATA_ID_EIDE_PIO_IORDY	= 68,
>  	ATA_ID_QUEUE_DEPTH	= 75,
>  	ATA_ID_MAJOR_VER	= 80,
> +	ATA_ID_MINOR_VER	= 81,
>  	ATA_ID_COMMAND_SET_1	= 82,
>  	ATA_ID_COMMAND_SET_2	= 83,
>  	ATA_ID_CFSSE		= 84,
> @@ -743,7 +744,12 @@ static inline int ata_id_is_cfa(const u1
>  
>  static inline int ata_id_is_ssd(const u16 *id)
>  {
> -	return id[ATA_ID_ROT_SPEED] == 0x01;
> +	/* ATA8-ACS version 4c or higher (=> 4c or 6 at the moment) */
> +	if (ata_id_major_version(id) >= 8 &&
> +	    (id[ATA_ID_MINOR_VER] == 0x39 || id[ATA_ID_MINOR_VER] == 0x28) &&
> +	    id[ATA_ID_ROT_SPEED] == 0x01)
> +		return 1;
> +	return 0;

Is the check even correct? It'll match version 8 AND the currently
listed minor version, not newer.

-- 
Jens Axboe

