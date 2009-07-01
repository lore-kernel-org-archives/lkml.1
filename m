Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZGAVak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZGAVak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZGAVac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:30:32 -0400
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:60091 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZGAVac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:30:32 -0400
Message-ID: <4A4BD577.2080609@numericable.fr>
Date: Wed, 01 Jul 2009 23:30:31 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, wuzhangjin@gmail.com,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>	 <1246459661.9660.40.camel@falcon>	 <200907011821.26091.bzolnier@gmail.com>	 <200907011829.16850.bzolnier@gmail.com> <b6a2187b0907011028r27d35be4xc62c7ed4496dfb2f@mail.gmail.com>
In-Reply-To: <b6a2187b0907011028r27d35be4xc62c7ed4496dfb2f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Thu, Jul 2, 2009 at 12:29 AM, Bartlomiej
> Zolnierkiewicz<bzolnier@gmail.com> wrote:
>> Here is the more complete version, also taking into the account changes
>> in ide_intr() and ide_timer_expiry():
> 
> This works great for. Survived STR, STD. I just applied on top vanilla
> latest Linus's git pull. Nothing else to revert.
> 
> Thanks,
> Jeff.
> 
> 
i confirm, this  works for me too :)
thanks,
Etienne


>> ---
>>  drivers/ide/ide-io.c |   15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> Index: b/drivers/ide/ide-io.c
>> ===================================================================
>> --- a/drivers/ide/ide-io.c
>> +++ b/drivers/ide/ide-io.c
>> @@ -532,7 +532,8 @@ repeat:
>>
>>                if (startstop == ide_stopped) {
>>                        rq = hwif->rq;
>> -                       hwif->rq = NULL;
>> +                       if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0)
>> +                               hwif->rq = NULL;
>>                        goto repeat;
>>                }
>>        } else
>> @@ -679,8 +680,10 @@ void ide_timer_expiry (unsigned long dat
>>                spin_lock_irq(&hwif->lock);
>>                enable_irq(hwif->irq);
>>                if (startstop == ide_stopped && hwif->polling == 0) {
>> -                       rq_in_flight = hwif->rq;
>> -                       hwif->rq = NULL;
>> +                       if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
>> +                               rq_in_flight = hwif->rq;
>> +                               hwif->rq = NULL;
>> +                       }
>>                        ide_unlock_port(hwif);
>>                        plug_device = 1;
>>                }
>> @@ -856,8 +859,10 @@ irqreturn_t ide_intr (int irq, void *dev
>>         */
>>        if (startstop == ide_stopped && hwif->polling == 0) {
>>                BUG_ON(hwif->handler);
>> -               rq_in_flight = hwif->rq;
>> -               hwif->rq = NULL;
>> +               if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {
>> +                       rq_in_flight = hwif->rq;
>> +                       hwif->rq = NULL;
>> +               }
>>                ide_unlock_port(hwif);
>>                plug_device = 1;
>>        }
>>

