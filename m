Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZBRBDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZBRBDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZBRBDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:03:15 -0500
Received: from h155.mvista.com ([63.81.120.155]:34348 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751473AbZBRBDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:03:14 -0500
Message-ID: <499B5E49.4070409@ru.mvista.com>
Date: Wed, 18 Feb 2009 04:03:05 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com> <499986D0.3000205@ru.mvista.com> <4999BD1A.1060101@gawab.com> <4999C195.5050905@ru.mvista.com> <4999DD31.4010504@gawab.com> <Pine.LNX.4.64.0902171102260.15234@blonde.anvils> <499B0B3E.3070101@gawab.com>
In-Reply-To: <499B0B3E.3070101@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Justin Madru wrote:

>>>> If 12609 is truly a post-2.6.28 regression and 12263 is post-2.6.27
>>>> regresssion, this just cannot be.
>>>>       
>>> Maybe the reporter of #12609 didn't notice/test kernels 28-rc1 to 
>>> 28. Or maybe
>>> the difference in hardware is
>>> the issue, but the bug is still the same. Don't know.
>>>     
>>
>> Sorry Justin, you must be confused: as Sergei says,
>> #12609 and #12263 can only be different.
>>
>> I was one of the reporters of #12609, and I do know it's a post-2.6.28
>> regression (and Larry said so too), and one fix (not the preferred fix)
>> is to revert the ata_bmdma32_port_ops from 2.6.29-rc, and the preferred
>> fix is to improve the ata_sff_data_xfer32() introduced in 2.6.29-rc1.
>>
>> 2.6.28 does not contain any ata_bmdma32_port_ops, nor 
>> ata_sff_data_xfer32(),
>> not did 2.6.28-rc1 contain them.  So it is impossible for the 
>> reversion of
>> the patch that introduced them to fix any problem on 2.6.28.
>>
>> I'm quite prepared to believe that your #12263 manifests similarly to
>> #12609, and that a tip tree which contains a fix for #12609 contains
>> a fix for #12263; but please, those bugs are not the same, and they
>> don't have the same fix.
>>
>> Hugh
>>
>>   
> Well, like I said: "[I] Don't know". I'm not a kernel developer (or 
> even any developer... yet).
> I'm just someone that tests the -rc kernels to see if there's any 
> problems with my hardware.
> I try to report any regressions to lkml, and hopefully help the 
> developers.
>
> To me, who has no knowledge of all these low level issues, the 
> following error messages
> look strikingly similar with a quick glance.
>
> # bug 12609
> # http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> #
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>         res 51/20:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
> ata2.00: status: { DRDY ERR }
> ata2: soft resetting link
> ata2.00: configured for UDMA/33
> ata2: EH complete
>
> # bug 12263
> # http://marc.info/?l=linux-kernel&m=122913412608533&w=4
> #
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata2.00: ST_FIRST: !(DRQ|ERR|DF)
> ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>         res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)

   Note the different value of the status, error and interrupt reason 
registers: 51/20:03 vs 50/00:01. The former means (unexpected?) status 
phase interrupt with error indication and the sense key NOT READY, the 
latter means (unexpected?) command phase interrupt with no error. IIUC, 
the former happens once the 'sr' driver first sends the TEST UNIT READY 
command while probing the CD/DVD drive, the latter seems to be a result 
of some polling process (originated from userland) -- I'm not seeing 
ALLOW_MEDIUM_REMOVAL anywhere in this driver. So they only look similar, 
I think...


> So, will the patch for 12609 fix my issue also, or does there need to 
> be another patch?

   Most probably it'll need another patch.

> Justin Madru

MBR, Sergei


