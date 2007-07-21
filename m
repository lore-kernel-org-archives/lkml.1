Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbXGUDrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbXGUDrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXGUDrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:47:01 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46991 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbXGUDrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:47:00 -0400
Message-ID: <46A181A5.5010203@cosmosbay.com>
Date: Sat, 21 Jul 2007 05:46:45 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: posible latency issues in seq_read
References: <46A125F4.3030504@nortel.com> <75b66ecd0707201518j45ef8bb7q7e48462ffbbc9c58@mail.gmail.com> <46A1399C.8010405@nortel.com>
In-Reply-To: <46A1399C.8010405@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 21 Jul 2007 05:46:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> Lee Revell wrote:
>> On 7/20/07, Chris Friesen <cfriesen@nortel.com> wrote:
> 
>>> We've run into an issue (on 2.6.10) where calling "lsof" triggers lost
>>> packets on our server.  Preempt is disabled, and NAPI is enabled.
> 
>> Can you reproduce with a recent kernel?  Lots of latency issues have
>> been fixed since then.
> 
> Unfortunately I have to fix it on this version (the bug was found on 
> shipped product), so if there was a difference I'd have to isolate the 
> changes and backport them.  Also, I can't run the software that triggers 
> the problem on a newer kernel as it has dependencies on various patches 
> that are not in mainline.
> 
> Basically what I'd like to know is whether calling schedule() in 
> seq_read() is safe or whether it would break assumptions made by 
> seq_file users.
> 

It wont help much. seq_read() is fine in itself.

The problem is in established_get_next() and established_get_first() not 
allowing softirq processing, while scanning a possibly huge hash table, even 
if few sockets are hashed in.

As cond_resched_softirq() was added in linux-2.6.11, you probably *need* to 
check the diffs between linux-2.6.10 & linux-2.6.11

files :

include/linux/sched.h
net/core/sock.c      (__release_sock() latency)
net/ipv4/tcp_ipv4.c  (/proc/net/tcp latency)


