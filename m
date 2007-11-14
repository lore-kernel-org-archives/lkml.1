Return-Path: <linux-kernel-owner+w=401wt.eu-S1761161AbXKNQlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761161AbXKNQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbXKNQlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:41:39 -0500
Received: from rtr.ca ([76.10.145.34]:1376 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728AbXKNQlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:41:39 -0500
Message-ID: <473B2541.10409@rtr.ca>
Date: Wed, 14 Nov 2007 11:41:37 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
Cc: Sebastian Kemper <sebastian_ml@gmx.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: libata/PATA: GPCMD_SET_STREAMING via SG_IO does nothing
References: <20071113164323.GA5252@section-eight> <20071113212230.77cadecd@the-village.bc.nu> <20071113232859.GA4681@section-eight> <473B219E.5060508@rtr.ca>
In-Reply-To: <473B219E.5060508@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Sebastian Kemper wrote:
>> Hi Alan!
>>
>> On Tue, Nov 13, 2007 at 09:22:30PM +0000, Alan Cox wrote:
>>> It isn't a known issue, and it suprises me as SG_IO basically passes
>>> commands through to the drive. We don't support speed change via 
>>> xfermode
>>> setting but GPCMD_SET_STREAMING sohuld behave.
>>>
>>> Do you have a simple code example that shows the problem ?
>>
>> http://svn.mplayerhq.hu/mplayer/trunk/stream/stream_dvd.c?view=markup
> ..
> 
> That code is riddled with bugs, by the way.
> It fails to close/clean-up on just about every exit path.
> But apart from that, it does appear to issue the command.
> 
> Another way to the same thing is with "hdparm -E",
> which contrary to my earlier posting actually does
> seem to work already with libata.
> 
>> See dvd_set_speed(). The drive I'm using is an Optiarc DVD RW AD-7170A.
>> With the "old" ATA driver dvd_set_speed() works, with libata it doesn't.
> ..
> 
> Can you define "doesn't work" for me?
> How can I test this to see if it works one way or another ?
> 
> The command issue (ioctl) is not returning -1.
..

Ahh.. got it.  The host_status returned (not checked by that code) was 7,
which means "host error".

In this case, that's because the cmd_len is (16), which is too large for ATAPI.
It needs to be changed to (12) instead.

So this line:  sghdr.cmd_len = 12;
The code (apart from totally mishandling any kinds of errors) works after that.

-ml
