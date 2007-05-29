Return-Path: <linux-kernel-owner+w=401wt.eu-S1764274AbXE2HfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764274AbXE2HfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764094AbXE2Hey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:34:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:41750 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbXE2Hew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mi/JiQxxQ1YRfzjKQTvnY2V1AX/XSAM5a3us1LeFhL0Q0Q2jmadXsPdANHceLCqnRzuI0leTKyMAwd0KR+IkOBNFvtoRcwdc2BEP+jwCxykgZiLLIKrKhtWIYo+OhFN2c51d2Svde8Nykgt9P3oJZoMkEkXZBOAJOP0bkK2nZYU=
Message-ID: <465BD751.8000708@gmail.com>
Date: Tue, 29 May 2007 09:33:37 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Paul Mundt <lethal@linux-sh.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, garyhade@us.ibm.com
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org> <464439C8.7090309@gmail.com> <20070512034928.GB29259@linux-sh.org> <20070516003002.GA18863@linux-sh.org> <464B3505.20004@gmail.com> <465B8277.9010001@garzik.org>
In-Reply-To: <465B8277.9010001@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> -    msleep(150);
>> +    /* wait a while before checking status */
>> +    ata_wait_after_reset(ap, deadline);
> [...]
>> -    msleep(150);
>> +    /* wait a while before checking status */
>> +    ata_wait_after_reset(ap, deadline);
>>  
>>      /* Before we perform post reset processing we want to see if
>>       * the bus shows 0xFF because the odd clown forgets the D7
>> @@ -3543,8 +3583,8 @@ int sata_std_hardreset(struct ata_port *
>>          return 0;
>>      }
>>  
>> -    /* wait a while before checking status, see SRST for more info */
>> -    msleep(150);
>> +    /* wait a while before checking status */
>> +    ata_wait_after_reset(ap, deadline);
>>  
>>      rc = ata_wait_ready(ap, deadline);
> [...]
>> -    msleep(150);
>> +    /* wait a while before checking status */
>> +    ata_wait_after_reset(ap, deadline);
>>  
>>      /* Before we perform post reset processing we want to see if
>>       * the bus shows 0xFF because the odd clown forgets the D7
>> Index: work/drivers/ata/sata_inic162x.c
>> ===================================================================
>> --- work.orig/drivers/ata/sata_inic162x.c
>> +++ work/drivers/ata/sata_inic162x.c
>> @@ -446,7 +446,7 @@ static int inic_hardreset(struct ata_por
>>          struct ata_taskfile tf;
>>  
>>          /* wait a while before checking status */
>> -        msleep(150);
>> +        ata_wait_after_reset(ap, deadline);
>>  
>>          rc = ata_wait_ready(ap, deadline);
> [...]
> 
> The main thing that bothers me is not the increase in delay, but the
> fact that this create converts a delay/Status-poll sequence into a
> delay/Status-poll/Status-poll sequence.
> 
> ata_wait_after_reset() immediately before ata_wait_ready() seems highly
> redundant.  Why not just poll Status once?

I was trying to minimize code disturbance around reset such that
ata_wait_after_reset() can be drop-in replacement for msleep(150).  This
was for two reasons 1. as this patch was to fix regression I didn't want
to introduce a lot of change into -rcX and 2. I was lazy.  :-)

As dont-consider-0xff-as-port-empty-if-sstatus-available patch fixes the
regression nicely, I think we can delay this to 2.6.23.  I'll merge
ata_wait_after_reset() into ata_wait_ready() (or the other way around).

Thanks.

-- 
tejun
