Return-Path: <linux-kernel-owner+w=401wt.eu-S1161340AbXCNUvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161340AbXCNUvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161338AbXCNUvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:51:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:18607 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161332AbXCNUvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:51:47 -0400
Message-ID: <45F86058.6090509@ru.mvista.com>
Date: Wed, 14 Mar 2007 23:51:36 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] sl82c105: add ->speedproc support
References: <200703102209.59918.bzolnier@gmail.com> <45F32860.8040901@ru.mvista.com> <200703102332.12716.bzolnier@gmail.com> <45F551E5.8010904@ru.mvista.com>
In-Reply-To: <45F551E5.8010904@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>> Bartlomiej Zolnierkiewicz wrote:

>>>> [PATCH] sl82c105: add ->speedproc support

>>>> * add sl82c105_tunepio() wrapper for sl82c105_tune_drive()
>>>>  (just to get the error value)

>>>> * add sl82c105_tune_chipset() (->speedproc method) for setting
>>>>  transfer mode

>>>    Thanks for the patch!

>>>  > Index: b/drivers/ide/pci/sl82c105.c

>>>> ===================================================================
>>>> --- a/drivers/ide/pci/sl82c105.c
>>>> +++ b/drivers/ide/pci/sl82c105.c

> [...]

>>>> @@ -114,17 +114,45 @@ static void sl82c105_tune_drive(ide_driv
>>>>      */
>>>>     drive->io_32bit = 1;
>>>>     drive->unmask    = 1;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static void sl82c105_tune_drive(ide_drive_t *drive, u8 pio)
>>>> +{
>>>> +    /*
>>>> +     * TODO: find best PIO mode and set device speed here
>>>> +     *       (requires adding helper function for getting PIO cycle 
>>>> time)
>>>> +     */

>>>   I thought we were doing it by calling ide_get_best_pio_mode() above...

>> We are also using ide_get_best_pio_mode() to get PIO cycle time
>> so we can't move it here ATM.

>   I've found/used quite convenient workaround for that -- return PIO 
> mode actually selected from xxx_tune_pio(), then call 
> ide_config_drive_speed() from the real tuneproc() method.

    Works like charm with ignoring the result, since ide_get_best_pio_mode() 
returns the same explicit mode as was passed to it -- so is good for the 
speedproc() methods also...

>>>> +    (void)sl82c105_tunepio(drive, pio);

>>>    Erm, I thought afterwards that I vainly folded one into another. I 
>>> think it's worth moving those io_32bit and unmask flag assignments 
>>> above back there... May also recast my patch. :-)

>> Moving them to ->init_hwif where they belong would be even better... ;-)

>    Well, I wasn't sure where they belong... :-)
>    So, OK to recast that patch?

   Recasted it and reworked your patch atop of it (adding MWDMA 0/1 support as 
a bonus! :-) -- now need to conduct some testing on a remote target...

>>>> +static int sl82c105_tune_chipset(ide_drive_t *drive, u8 mode)
>>>> +{
>>>> +    mode = ide_rate_filter(drive, mode);
>>>> +
>>>> +    if (mode >= XFER_PIO_0 && mode <= XFER_PIO_5)
>>>> +        return sl82c105_tunepio(drive, mode - XFER_PIO_0);
>>>> +
>>>> +    /*
>>>> +     * TODO: add MWDMA0/1 support
>>>> +     */
>>>> +    BUG_ON(mode != XFER_MW_DMA_2);

   I wonder is there are some W83C554 users anywhere -- that chipset also 
supports UltraDMA...

MBR, Sergei
