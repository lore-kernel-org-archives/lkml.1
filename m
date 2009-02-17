Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZBQLcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZBQLcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZBQLcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:32:32 -0500
Received: from h155.mvista.com ([63.81.120.155]:20686 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751123AbZBQLcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:32:31 -0500
Message-ID: <499AA047.70502@ru.mvista.com>
Date: Tue, 17 Feb 2009 14:32:23 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <liml@rtr.ca>,
       =?UTF-8?B?SGFubm8=?= =?UTF-8?B?IELDtmNr?= <hanno@hboeck.de>
Subject: Re: [PATCH v2] libata: Don't trust current capacity values in identify
 words 57-58
References: <4999CA54.1060306@gmail.com> <4999CFEB.3030204@ru.mvista.com> <499A1DAC.6090200@gmail.com>
In-Reply-To: <499A1DAC.6090200@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Robert Hancock wrote:

> Hanno Böck reported a problem where an old Conner CP30254 240MB hard drive
> was reported as 1.1TB in capacity by libata:
>
> http://lkml.org/lkml/2009/2/13/134
>
> This was caused by libata trusting the drive's reported current capacity in 
> sectors in identify words 57 and 58 if the drive does not support LBA and the
> current CHS translation values appear valid. Unfortunately it seems older
> ATA specs were vague about what this field should contain and a number of drives
> used values with wrong byte order or that were totally bogus. There's no
> unique information that it conveys and so we can just calculate the number
> of sectors from the reported current CHS values.
>
> While we're at it, clean up this function to use named constants for the
> identify word values.
>
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

   ... though I'm not sure that the rename should be a part of this patch.

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 9fbf059..33b5549 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1322,14 +1322,16 @@ static u64 ata_id_n_sectors(const u16 *id)
>  {
>  	if (ata_id_has_lba(id)) {
>  		if (ata_id_has_lba48(id))
> -			return ata_id_u64(id, 100);
> +			return ata_id_u64(id, ATA_ID_LBA_CAPACITY_2);
>  		else
> -			return ata_id_u32(id, 60);
> +			return ata_id_u32(id, ATA_ID_LBA_CAPACITY);
>  	} else {
>  		if (ata_id_current_chs_valid(id))
> -			return ata_id_u32(id, 57);
> +			return id[ATA_ID_CUR_CYLS] * id[ATA_ID_CUR_HEADS] *
> +			       id[ATA_ID_CUR_SECTORS];
>   

   It won't hurt to comment on why the capacity is ignored. 
Unfortunately, the IDE code lacks such comment.

MBR, Sergei


