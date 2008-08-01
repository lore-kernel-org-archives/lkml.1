Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYHAOTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYHAOTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYHAOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:19:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYHAOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:19:00 -0400
Date: Fri, 1 Aug 2008 09:55:08 -0400
From: Josef Bacik <jbacik@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: high resolution timers, scheduling & sleep granularity
Message-ID: <20080801135508.GC14001@unused.rdu.redhat.com>
References: <4892FC11.4020105@redhat.com> <20080801132537.GB14001@unused.rdu.redhat.com> <4893164D.1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4893164D.1@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 09:57:33AM -0400, Ric Wheeler wrote:
> Josef Bacik wrote:
>> On Fri, Aug 01, 2008 at 08:05:37AM -0400, Ric Wheeler wrote:
>>   
>>> Hi Thomas & Ingo,
>>>
>>> Josef has been working on some patches to try and get ext3/4 to 
>>> dynamically detect the latency of a storage device and use that base 
>>> latency to tune the amount of time we sleep waiting for others to join in 
>>> a transaction. The logic in question lives in jbd/transaction.c 
>>> (transaction_stop).
>>>
>>> The code was originally developed to try and allow multiple threads to 
>>> join in a big, slow transaction. For example, transacations that write to 
>>> a slow ATA or S-ATA drive take in the neighborhood of 10 to 20 ms.
>>>
>>> Faster devices, for example a disk array,  can complete the transaction 
>>> in 1.3 ms. Even higher speed SSD devices boast of a latency of 0.1ms, not 
>>> to mention RAM disks ;-)
>>>
>>> The current logic makes us wait way too long, especially with a 250HZ 
>>> kernel since we sleep many times longer than it takes to complete the IO 
>>> ;-)
>>>
>>> Do either of you have any thoughts on how to get a better, fine grained 
>>> sleep capability that we could use that would allow us to sleep in 
>>> sub-jiffie chunks?
>>>
>>>     
>>
>> Hello,
>>
>> This is the most recent iteration of my patch using hrtimers.  It works really
>> well for ramdisks, so anything with low latency writes is going to be really
>> fast, but I'm still trying to come up with a smart way to sleep long enough to
>> not hurt SATA performance.  As it stands now I'm getting a 5% decrease in speed
>> on SATA.  So I think I've got the sleep as little as possible part down right,
>> just can't quite get it to sleep long enough if the disk is slow.  Thanks,
>>
>> Josef
>>   
>
> I think that this (or similar) kind of precision_sleep() should be 
> generically useful.
>
> One question on the code, would it be better to measure the average 
> transaction time in the same units as your precision sleep uses - aren't 
> jiffies are still too coarse?
>

Oh well crap I guess thats why I'm not sleeping long enough, i'm only sleeping
jiffies number of nanoseconds, and jiffies is much higher than nanoseconds...

/me writes jiffies * HZ = seconds backwards on his forehead

Josef
