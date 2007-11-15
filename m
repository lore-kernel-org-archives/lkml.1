Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXKOU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXKOU7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbXKOU72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:59:28 -0500
Received: from rtr.ca ([76.10.145.34]:2474 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760495AbXKOU71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:59:27 -0500
Message-ID: <473CB32D.40703@rtr.ca>
Date: Thu, 15 Nov 2007 15:59:25 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sebastian Kemper <sebastian_ml@gmx.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
References: <20071113164323.GA5252@section-eight> <20071114171139.GA9387@section-eight> <473B2EAA.4090802@rtr.ca> <200711152155.30719.bzolnier@gmail.com>
In-Reply-To: <200711152155.30719.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 14 November 2007, Mark Lord wrote:
>> Sebastian Kemper wrote:
>>> Hi Mark!
>>>
>>> On Wed, Nov 14, 2007 at 11:41:37AM -0500, Mark Lord wrote:
>>>> Ahh.. got it.  The host_status returned (not checked by that code) was 7,
>>>> which means "host error".
>>>>
>>>> In this case, that's because the cmd_len is (16), which is too large for 
>>>> ATAPI.
>>>> It needs to be changed to (12) instead.
>>> I don't understand. You seem to use a cmd_len of 16 in hdparm yourself.
>> ..
>>
>> Really?  Where?
>>
>>
>>> And why does it work with the "old" ATA driver and not with libata if
>>> 16 is too large for ATAPI in general?
>> ..
>>
>> Now that *is* the question.
>> And the answer appears to be that ide-cd.c ignores the passed-in cmd_len,
>> and replaces it with:
>>
>>    cmd_len = COMMAND_SIZE(rq->cmd[0]);
>>
>> That's a SCSI macro to calculate the correct cmd_len based on the SCSI opcode,
>> which is very appropriate here.   We should do that too (we don't) in libata.
>>
>> But not exactly as IDE does it -- that's actually a bug:  the code needs to also
>> check that the new cmd_len is no larger than the original, or we'll get an Oops.
>>
>> I'll cook up a patch for that shortly and try it before posting it here.
> 
> Could you please also fix ide-cd while at it?
..

ide-cd already does the COMMAND_SIZE() thingie, so that fix is not needed.

The only bug there is that it doesn't check for the possibility
of a 16-byte opcode being issued with only a 12-byte CDB underneath.
In practice, this doesn't seem to hurt anything.

I'm no longer familiar enough with the code there to reliably fix it.

Cheers
