Return-Path: <linux-kernel-owner+w=401wt.eu-S1030642AbXBGRzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030642AbXBGRzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030640AbXBGRzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:55:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:36954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030632AbXBGRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:55:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=awp7FenhSt5Ly+kTkcqcD6ey6GMKVBe1PnTJjMUfroddvg9d6S9K+jp9qaBHZSBlt7jSKSlTg9Se+MJ7+O1S+b3H0Qy1VQbAHwz1RVoJJ6FdWRgPqsG85BDZEOeM4sFyj6xQKbyeJdoJmA+BDAqBgiWnRm3KXrPhMjDIPwhfUlY=
Message-ID: <45C97B56.8020800@gmail.com>
Date: Tue, 06 Feb 2007 23:10:14 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] ATA: abnormal status 0x80 on port 0xCC07
References: <6bffcb0e0702031044v601e4fc3icf859544af292789@mail.gmail.com> <45C8EAAD.5000905@googlemail.com>
In-Reply-To: <45C8EAAD.5000905@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Michal Piotrowski wrote:
[--snip--]
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index a388a8d..cf70702 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1037,7 +1037,7 @@ static unsigned int ata_id_xfermask(cons
>                  * the PIO timing number for the maximum. Turn it into
>                  * a mask.
>                  */
> -               u8 mode = id[ATA_ID_OLD_PIO_MODES] & 0xFF;
> +               u8 mode = (id[ATA_ID_OLD_PIO_MODES] >> 8) & 0xFF;
>                 if (mode < 5)   /* Valid PIO range */
>                         pio_mask = (2 << mode) - 1;
>                 else

All modern devices implement word53 and the above code probably never 
runs in your case.

> There are 55 per cent chances that this is a hardware problem and
> 45 % that this is a software bug.

This seems more like a hardware problem to me.

>   9 Power_On_Hours          0x0032   098   098   000    Old_age   Always       -       2207
> 
> Error 6 occurred at disk power-on lifetime: 2202 hours (91 days + 18 hours)
>   When the command that caused the error occurred, the device was active or idle.
> 
>   After command completion occurred, registers were:
>   ER ST SC SN CL CH DH
>   -- -- -- -- -- -- --
>   40 51 00 bc 0c 02 e0  Error: UNC at LBA = 0x00020cbc = 134332
> 
>   Commands leading to the command that caused the error were:
>   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
>   -- -- -- -- -- -- -- --  ----------------  --------------------
>   c8 00 00 2f 0c 02 e0 00      00:01:07.193  READ DMA
>   ec 03 46 00 00 00 a0 02      00:01:07.192  IDENTIFY DEVICE
>   ef 03 46 00 00 00 a0 00      00:01:07.180  SET FEATURES [Set transfer mode]
>   ec 00 00 bc 0c 02 a0 02      00:01:05.100  IDENTIFY DEVICE
>   c8 00 00 2f 0c 02 e0 00      00:01:05.096  READ DMA

There have been a series of read errors on LBA 0x20cbc about five hours 
before the smart log was dumped.  The error status as seen by the drive 
is uncorrectable media error at LBA 0x20cbc.  The failing command is 
READ for LBA 0x20c2f, so the drive could read some sectors but not all 
of them.  Maybe the command times out while the drive keeps retrying read.

Hmmm.. errors in smart log and dmesg don't have matching LBAs.  So, it's 
possible that those failed read and the command timeouts are unrelated. 
  Please keep watching and report.  We need more info to determine 
what's going on.

-- 
tejun

