Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZEUTMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZEUTMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZEUTMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:12:40 -0400
Received: from h155.mvista.com ([63.81.120.155]:58488 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754453AbZEUTMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:12:40 -0400
Message-ID: <4A15A7DD.1040300@ru.mvista.com>
Date: Thu, 21 May 2009 23:13:33 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: respect quirk_drives[] list on all controllers
References: <200905201734.42093.bzolnier@gmail.com>
In-Reply-To: <200905201734.42093.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add ide_check_nien_quirk_list() helper to the core code
>   and then use it in ide_port_tune_devices().

> * Remove no longer needed ->quirkproc methods from hpt366.c
>   and pdc202xx_{new,old}.c.

    Haha, I remembered about that idea of yours and was thinking of 
undertaking its implementation just yesterday. You've beten me to it. :-)

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-iops.c
> ===================================================================
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -269,6 +269,31 @@ no_80w:
>  	return 0;
>  }
>  
> +static const char *nien_quirk_list[] = {
> +	"QUANTUM FIREBALLlct08 08",
> +	"QUANTUM FIREBALLP KA6.4",
> +	"QUANTUM FIREBALLP KA9.1",
> +	"QUANTUM FIREBALLP KX13.6",
> +	"QUANTUM FIREBALLP KX20.5",
> +	"QUANTUM FIREBALLP KX27.3",
> +	"QUANTUM FIREBALLP LM20.4",
> +	"QUANTUM FIREBALLP LM20.5",
> +	NULL
> +};
> +
> +void ide_check_nien_quirk_list(ide_drive_t *drive)

    Why not reuse ide_in_drive_list()?

> +{
> +	const char **list, *m = (char *)&drive->id[ATA_ID_PROD];
> +
> +	for (list = nien_quirk_list; *list != NULL; list++)
> +		if (strstr(m, *list) != NULL) {

    Ah, strstr() vs strcmp()... I think strcmp() should work anyway...

> +			drive->quirk_list = 2;
> +			return;
> +		}
> +
> +	drive->quirk_list = 0;
> +}
> +
>  int ide_driveid_update(ide_drive_t *drive)
>  {
>  	u16 *id;

MBR, Sergei
