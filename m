Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZAJUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZAJUHH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZAJUGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:06:54 -0500
Received: from h155.mvista.com ([63.81.120.155]:2037 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005AbZAJUGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:06:54 -0500
Message-ID: <4968FFD7.6070302@ru.mvista.com>
Date: Sat, 10 Jan 2009 23:06:47 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com>	<200901101009.13699.borntraeger@de.ibm.com>	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>	<200901101242.05203.borntraeger@de.ibm.com>	<49688B63.5030105@ru.mvista.com>	<20090110122130.318cf168@lxorguk.ukuu.org.uk>	<20090110130745.GA14049@elte.hu>	<49689EA8.20506@garzik.org>	<20090110132412.GB14049@elte.hu>	<20090110133617.GA22304@elte.hu>	<20090110135731.0da08c90@lxorguk.ukuu.org.uk>	<4968BA6F.8050207@ru.mvista.com> <20090110152800.44308491@lxorguk.ukuu.org.uk> <4968C5CA.6010508@ru.mvista.com>
In-Reply-To: <4968C5CA.6010508@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>    All the S/G counts printed out were divisible by 4 (36 for 
>>> INQUIRY and 96 for REQUSET SENSE). It's the *actual* byte count for 
>>> the REQUEST SENSE that's no divisible. The SCSI/ATAPI devices are 
>>> free to sent less data than requested on non block transfer commands.
>
>> That is just fine - if the sg list is not corrupt or being mishandled 
>> and
>> the atapi pio code is not buggy.
>
>> RTFS a bit and it becomes obvious that the core libata code has a bug:
>
>    Oh, I have already... and saw where the issue could be. It just 
> wasn't obvious why 32-bit PIO triggered it.

  Got it now, however the issue doesn't seem as evident simple to me...

>> From libata-sff.c:
>>         /* consumed can be larger than count only for the last 
>> transfer */
>>         WARN_ON_ONCE(qc->cursg && count != consumed);
>>
>> The big clue turns out to be that the code doesn't match the comment.
>>
>> Next note the check on qc->cursg. If my input sg list is a 36 byte 
>> single
>> sg entry then qc->cursg should be NULL by the WARN_ON() - but it isn't.
>
>    I think it's still not NULL because qc->cursg_ofs == sg->length 
> check was *not* true right above, hence sg_next() wasn't called...
>
>> If qc->cursg is NULL when the sg_next() is run then we don't warn 
>> because
>> we are quite happy with the last segment being padded or underrunning.
>
>    I don't think that sg_next() is called on an underrun segment. And 
> here lies the mistake.
>
>> What we actually want to explode on is a case where we transfer more
>> bytes than are wanted and where there are more sg entries to perform 
>> - at
>> that point we would corrupt.
>
>> So at least one failure case is
>
>>     Core code issues an SG list for 96 bytes
>>     Drive indicates it wishes to return 18 bytes
>
>>     data_xfer transfers 18 bytes + 2 padding (correctly) -> 20 bytes

   Correctly indeed? I'm not at all sure it's correct to read an extra 
16-bit word off the device when it thinks it's already done with the 
data transfer. This is not the same as to read 16-bit word and ignore 
its MSB as it happened. The same concern about the writes... Note that 
the IDE code doesn't do this...

MBR, Sergei


