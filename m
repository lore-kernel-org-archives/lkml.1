Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYCLQom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYCLQom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYCLQod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:44:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:16051 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766AbYCLQoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:44:32 -0400
Message-ID: <47D808BD.2080902@ru.mvista.com>
Date: Wed, 12 Mar 2008 19:45:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: sanitize handling of IDE_HFLAG_NO_SET_MODE host
 flag
References: <200802232115.11908.bzolnier@gmail.com>
In-Reply-To: <200802232115.11908.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Check for IDE_HFLAG_NO_SET_MODE host flag in ide_set_pio(),
>   ide_set_[pio,dma]_mode(), ide_set_xfer_rate() and set_pio_mode().

> * Remove no longer needed IDE_HFLAG_NO_SET_MODE host flag checking
>   from ide_tune_dma().

> * Remove superfluous ->set_pio_mode checking from do_special().

> This is a part of preparations for adding 'struct ide_port_ops'.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/ide-lib.c
> ===================================================================
> --- a/drivers/ide/ide-lib.c
> +++ b/drivers/ide/ide-lib.c
> @@ -353,6 +354,9 @@ int ide_set_pio_mode(ide_drive_t *drive,
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  
> +	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
> +		return 0;
> +

    Shouldn't this be considered an error?

>  	if (hwif->set_pio_mode == NULL)
>  		return -1;
>  
> @@ -380,6 +384,9 @@ int ide_set_dma_mode(ide_drive_t *drive,
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  
> +	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
> +		return 0;
> +

    Same here....

>  	if (hwif->set_dma_mode == NULL)
>  		return -1;
>  
> @@ -410,7 +417,8 @@ int ide_set_xfer_rate(ide_drive_t *drive
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  
> -	if (hwif->set_dma_mode == NULL)
> +	if (hwif->set_dma_mode == NULL ||
> +	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
>  		return -1;

    Hm, this is was not considered an error before...

MBR, Sergei
