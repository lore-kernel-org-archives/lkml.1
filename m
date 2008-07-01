Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbYGAOt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbYGAOt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYGAOtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:49:18 -0400
Received: from nebensachen.de ([195.34.83.29]:58989 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbYGAOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:49:17 -0400
X-Hashcash: 1:20:080701:joe@skyrush.com::euu0Chsp20yEf2zy:004tmB
X-Hashcash: 1:20:080701:edwintorok@gmail.com::D0VW8Cpmq06Xm5aU:000000000000000000000000000000000000000000FC3
X-Hashcash: 1:20:080701:alan@lxorguk.ukuu.org.uk::mKc/0RZziW0ehl6p:00000000000000000000000000000000000000eHA
X-Hashcash: 1:20:080701:linux-kernel@vger.kernel.org::wcfcqwkHnBoR3STu:0000000000000000000000000000000002Rgh
From: Elias Oltmanns <eo@nebensachen.de>
To: Joe Peterson <joe@skyrush.com>
Cc: =?iso-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>
	<486A3B4A.2090005@skyrush.com>
Date: Tue, 01 Jul 2008 16:48:33 +0200
In-Reply-To: <486A3B4A.2090005@skyrush.com> (Joe Peterson's message of "Tue,
	01 Jul 2008 08:12:26 -0600")
Message-ID: <877ic5irsu.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson <joe@skyrush.com> wrote:
> Elias Oltmanns wrote:
>> The following patch to 2.6.26-rc8 fixes the issue for me. Perhaps we
>> really want to do something else, but since I'm not all that familiar
>> with the standard behaviour on other Unices and since the comment
>> describing the changed order of function calls in the original commit
>> didn't give the reason for that change, I leave that to more
>> knowledgeable people.
>> 
>>  drivers/char/n_tty.c |   13 +------------
>>  1 files changed, 1 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
>> index 8096389..74018ef 100644
>> --- a/drivers/char/n_tty.c
>> +++ b/drivers/char/n_tty.c
>> @@ -759,20 +759,9 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
>>  		signal = SIGTSTP;
>>  		if (c == SUSP_CHAR(tty)) {
>>  send_signal:
>> -			/*
>> -			 * Echo character, and then send the signal.
>> -			 * Note that we do not use isig() here because we want
>> -			 * the order to be:
>> -			 * 1) flush, 2) echo, 3) signal
>> -			 */
>> -			if (!L_NOFLSH(tty)) {
>> -				n_tty_flush_buffer(tty);
>> -				tty_driver_flush_buffer(tty);
>> -			}
>>  			if (L_ECHO(tty))
>>  				echo_char(c, tty);
>> -			if (tty->pgrp)
>> -				kill_pgrp(tty->pgrp, signal, 1);
>> +			isig(signal, tty, 0);
>>  			return;
>>  		}
>>  	}
>
> I noticed the original post in this thread mentioned that the problem
> has been seen since 2.6.21 or 2.6.23:
>
>> I use 2.6.25-2 and 2.6.26-rc8 now; I don't recall seeing this
>> behaviour with old kernels (IIRC I see this since 2.6.21 or 2.6.23).
>>
>> Is this intended behaviour, or should I report a bug?
>
> The echo patch that is altered in the patch above only appeared recently
> (in 2.6.25).  Is there a way for you try try the test case on a
> pre-2.6.25 kernel and see if the issue exists there?  If so, it is
> strange that the above fixes it.

Due to my tests, 2.6.24 responds much faster to Ctrl+C than 2.6.25 does.
The patch above makes them *feel* alike again (no hard numbers, mind).
However, I haven't checked anything as early as 2.6.21 or before so I
don't know whether there may have been another regression since then.

Regards,

Elias
