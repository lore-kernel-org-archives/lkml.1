Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbYF3SLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbYF3SLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbYF3SK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:10:57 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:59031 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbYF3SK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:10:56 -0400
Message-ID: <486921AD.8060308@fastmq.com>
Date: Mon, 30 Jun 2008 20:10:53 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Roger Heflin <rogerheflin@gmail.com>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <48663873.5010200@gmail.com>
In-Reply-To: <48663873.5010200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

>> If these figures are to be believed, then why are we seeing latencies of
>> 8.3 msec?  Is this normal?  Or are we just being overly optimistic in
>> our performance expectations?
> 
> Consider this, 60/7200rpm=8.3ms for one rotation.
> 
> You write sector n and n+1, it takes some amount of time for that first 
> set of sectors to come under the head, when it does you write it and 
> immediately return.   Immediately after that you attempt write sector 
> n+2 and n+3 which just a bit ago passed under the head, so you have to 
> wait an *ENTIRE* revolution for those sectors to again come under the 
> head to be written, another ~8.3ms, and you continue to repeat this with 
> each block being written.   If the sector was randomly placed in the 
> rotation (ie 50% chance of the disk being off by 1/2 a rotation or 
> less-you would have a 4.15 ms average seek time for your test)-but the 
> case of sequential sync writes this leaves the sector about as far as 
> possible from the head (it just passed under the head).

Fair enough. That exaplains the behaviour. Would AIO help here? If we 
are able to enqueue next write before the first one is finished, it can 
start writing it immediately without waiting for a revolution.

>> We also ran the same test on a different system with recent SAS disks
>> connected via a HP/Compaq CCISS controller.  I don't have the exact
>> details of the drives used, since I don't know how to get them out of
>> the cciss driver, but the latencies we got were around 4 msec.  Whilst
>> this is better than the "commodity" hardware used in the tests above, it
>> still seems excessive.
> 
> Almost the same case as for the 7200 rpm disk, but I bet these SAS 
> drives are 15k drives?   If so 60/15000=4ms.

Bingo!

Thanks.
Martin
