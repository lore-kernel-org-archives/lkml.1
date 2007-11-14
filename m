Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXKNRV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXKNRV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXKNRVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:21:49 -0500
Received: from rtr.ca ([76.10.145.34]:2059 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbXKNRVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:21:47 -0500
Message-ID: <473B2EAA.4090802@rtr.ca>
Date: Wed, 14 Nov 2007 12:21:46 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sebastian Kemper <sebastian_ml@gmx.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B219E.5060508@rtr.ca> <473B2541.10409@rtr.ca> <20071114171139.GA9387@section-eight>
In-Reply-To: <20071114171139.GA9387@section-eight>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Kemper wrote:
> Hi Mark!
> 
> On Wed, Nov 14, 2007 at 11:41:37AM -0500, Mark Lord wrote:
>> Ahh.. got it.  The host_status returned (not checked by that code) was 7,
>> which means "host error".
>>
>> In this case, that's because the cmd_len is (16), which is too large for 
>> ATAPI.
>> It needs to be changed to (12) instead.
> 
> I don't understand. You seem to use a cmd_len of 16 in hdparm yourself.
..

Really?  Where?


> And why does it work with the "old" ATA driver and not with libata if
> 16 is too large for ATAPI in general?
..

Now that *is* the question.
And the answer appears to be that ide-cd.c ignores the passed-in cmd_len,
and replaces it with:

   cmd_len = COMMAND_SIZE(rq->cmd[0]);

That's a SCSI macro to calculate the correct cmd_len based on the SCSI opcode,
which is very appropriate here.   We should do that too (we don't) in libata.

But not exactly as IDE does it -- that's actually a bug:  the code needs to also
check that the new cmd_len is no larger than the original, or we'll get an Oops.

I'll cook up a patch for that shortly and try it before posting it here.

-ml
