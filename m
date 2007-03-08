Return-Path: <linux-kernel-owner+w=401wt.eu-S933312AbXCHUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbXCHUxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXCHUxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:53:41 -0500
Received: from elvis.mu.org ([192.203.228.196]:53441 "EHLO elvis.mu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933310AbXCHUxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:53:39 -0500
In-Reply-To: <200703082134.47530.bzolnier@gmail.com>
References: <20070221012304.GC1777@freefall.freebsd.org> <200703072216.08295.bzolnier@gmail.com> <B2D4536E-D449-4D10-B745-30D25CAC40A4@freebsd.org> <200703082134.47530.bzolnier@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <AD2A17AC-83C6-4CCB-9452-A07DF2F8D821@freebsd.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH 3/3] Use correct IDE error recovery
Date: Thu, 8 Mar 2007 12:53:07 -0800
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 8, 2007, at 12:34 PM, Bartlomiej Zolnierkiewicz wrote:

>
> Hi,
>
> On Thursday 08 March 2007, Suleiman Souhlal wrote:
>>
>> On Mar 7, 2007, at 1:16 PM, Bartlomiej Zolnierkiewicz wrote:
>>
>>>
>>> Hi,
>>>
>>> (sorry for the long delay)
>>>
>>> On Wednesday 21 February 2007, Suleiman Souhlal wrote:
>>>> IDE error recovery is using WIN_IDLEIMMEDIATE which was only  
>>>> valid for
>>>> IDE V1 and IDE V2.  Modern drives will not be able to recover using
>>>> this error handling.  The correct thing to do is issue a SRST  
>>>> followed
>>>> by a SET_FEATURES.
>>>
>>> This change looks fine, indeed we are better of using SRST +
>>> SET_FEATURES than IDLE_IMMEDIATE.
>>>
>>>> Signed-off-by:	Suleiman Souhlal <suleiman@google.com>
>>>>
>>>> ---
>>>>  drivers/ide/ide-io.c   |   35 +++++++++++-----
>>>>  drivers/ide/ide-iops.c |  105 +++++++++++++++++++++++++++ 
>>>> +--------------------
>>>>  include/linux/ide.h    |    2 +
>>>>  3 files changed, 88 insertions(+), 54 deletions(-)
>>>>
>>>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>>>> index c193553..2f05b4d 100644
>>>> --- a/drivers/ide/ide-io.c
>>>> +++ b/drivers/ide/ide-io.c
>>>> @@ -519,21 +519,21 @@ static ide_startstop_t ide_ata_error(ide
>>>>  	if ((stat & DRQ_STAT) && rq_data_dir(rq) == READ && hwif-
>>>>> err_stops_fifo == 0)
>>>>  		try_to_flush_leftover_data(drive);
>>>>
>>>> +	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq)) {
>>>> +		ide_kill_rq(drive, rq);
>>>> +		return ide_stopped;
>>>> +	}
>>>> +
>>>>  	if (hwif->INB(IDE_STATUS_REG) & (BUSY_STAT|DRQ_STAT))
>>>> -		/* force an abort */
>>>> -		hwif->OUTB(WIN_IDLEIMMEDIATE, IDE_COMMAND_REG);
>>>> +		rq->errors |= ERROR_RESET;
>>>>
>>>> -	if (rq->errors >= ERROR_MAX || blk_noretry_request(rq))
>>>> -		ide_kill_rq(drive, rq);
>>>> -	else {
>>>> -		if ((rq->errors & ERROR_RESET) == ERROR_RESET) {
>>>> -			++rq->errors;
>>>> -			return ide_do_reset(drive);
>>>> -		}
>>>> -		if ((rq->errors & ERROR_RECAL) == ERROR_RECAL)
>>>> -			drive->special.b.recalibrate = 1;
>>>
>>> Is the removal of ERROR_RECAL handling intentional?
>>> There is nothing about it in the patch description...
>>
>> Yes, it was intentional, but I forgot to add "while there remove some
>
> Why is it useless?  What am I missing?

I thought the recalibration code didn't do anything, but upon  
rereading the code I'm not so sure anymore..

-- Suleiman


