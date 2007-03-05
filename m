Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbXCEWfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbXCEWfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbXCEWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:35:08 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:54982 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXCEWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:35:06 -0500
Message-ID: <45EC9B15.6090908@simon.arlott.org.uk>
Date: Mon, 05 Mar 2007 22:35:01 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH (updated)] timer: Run calc_load halfway through each round_jiffies
 second
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk> <45E720E8.1010809@simon.arlott.org.uk> <45E75911.3070907@simon.arlott.org.uk> <20020101030506.GB4106@ucw.cz>
In-Reply-To: <20020101030506.GB4106@ucw.cz>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/02 03:05, Pavel Machek wrote:
>> Whenever jiffies is started at a multiple of 5*HZ or 
>> wraps, calc_load is run exactly on the second which is 
>> when tasks using round_jiffies will be scheduled to run. 
>> This has a bad effect on the load average, making it 
>> tend towards 1.00 if a task happens to run every time 
>> the load is being calculated.
>>
>> This changes calc_load so that it updates load half a 
>> second after any tasks scheduled using round_jiffies.
> 
> Hmm, otoh this makes calc_load more expensive, power-wise, because it
> needs to wake the cpu once more?

This was something I was concerned about, it's hard to avoid since it 
shouldn't be run when scheduled tasks are which leaves running it 
before those tasks run as the only other option. To do that you need 
some idea of how long it's going to take to run.

Mar  1 22:36:17 redrum [  639.147319] calc_load(1) jiffies=311500 count=0 [start]
Mar  1 22:36:17 redrum [  639.147331] calc_load... count=5000 [run]
Mar  1 22:36:17 redrum [  639.147336] calc_load... count=5000 [finish]

While I really doubt the accuracy of these timings using printk (they 
vary a lot only going as low as 4 + 4µs), it does show that 1ms is plenty 
of time and that it *could* be scheduled at 1 tick before the second even 
at HZ=1000.

Of course then you miss out on ever catching tasks scheduled with 
round_jiffies since they'd need to run for a full second to affect it.

Also, calc_load with NO_HZ only appears to run every time the system 
needed to wake up for something else (calc_load itself is already able 
to handle this appropriately), so this isn't as much of a problem as it 
might seem. Someone whose CPU only needs to be woken up every 5s (or 4.5s 
for a round_jiffies task) will find their load being higher than it 
should be - but the current version does that already. (Mine doesn't 
stay below 0.5 with NO_HZ because of this).

> Timetraveling, sorry.

Since Eric Dumazet seems to have disappeared for now I really need 
other people to comment on this too. Although you shouldn't literally 
time travel ;) (Date: Tue, 1 Jan 2002 03:05:07 +0000).

-- 
Simon Arlott
