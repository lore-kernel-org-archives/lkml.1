Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbZAUR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbZAUR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZAUR2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:28:37 -0500
Received: from smtp-out.google.com ([216.239.45.13]:44335 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZAUR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:28:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=B0wN3/XuR+KQ/CPbGmXbHz4JJXRRZJ1R1WGncg8AqM3E4Nc1MQcZFbAFT88QRyoCU
	9BzzJhw7G/G1Jpy6jUVXg==
Message-ID: <49775B38.7010505@google.com>
Date: Wed, 21 Jan 2009 09:28:24 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <877i4pdx4f.fsf@basil.nowhere.org> <4976BF08.90306@google.com> <20090121084808.GC15750@one.firstfloor.org>
In-Reply-To: <20090121084808.GC15750@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.38
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Jan 20, 2009 at 10:22:00PM -0800, Mike Waychison wrote:
>> Andi Kleen wrote:
>>> Mike Waychison <mikew@google.com> writes:
>>>
>>>> livelock on dcache_lock/inode_lock (specifically in 
>>>> atomic_dec_and_lock()) 
>>> I'm not sure how something can livelock in atomic_dec_and_lock which
>>> doesn't take a spinlock itself? Are you saying you run into NUMA memory
>>> unfairness here? Or did I misparse you?
>> By atomic_dec_and_lock, I really meant to say _atomic_dec_and_lock(). 
> 
> Ok. So it's basically just the lock that is taken? 
> 
> In theory one could likely provide an x86 specific dec-and_lock that
> might perform better and doesn't lock if the count is still > 0, but that 
> would only help if the reference count is still > 0. Is that a common
> situation in your test?
> 

This is precisely what _atomic_dec_and_lock does.  It only locks if it 
looks like the counter will be hitting 0 with this dec.

It is a common case for the count to be > 1, however the troubles we see 
happen with there are a large number of final dputs (and thus also final 
iputs)

>> It takes the spinlock if the cmpxchg hidden inside atomic_dec_unless fails.
>>
>> There are likely NUMA unfairness issues at play, but it's not the main 
>> worry at this point.
>>
>>>> This patchset is an attempt to try and reduce the locking overheads 
>>>> associated
>>>> with final dput() and final iput().  This is done by batching dentries and
>>>> inodes into per-process queues and processing them in 'parallel' to 
>>>> consolidate
>>>> some of the locking.
>>> I was wondering what this does to the latencies when dput/iput
>>> is only done for very objects. Does it increase costs then
>>> significantly?
>> very objects?
> 
> Sorry.
> 
> "is only done for very few objects". Somnhow the few got lost.
> Basically latency in the unloaded case.
> 
> I always worry when people do complicated things for the high
> load case how the more usual "do it for a single object" workload
> fares.

Hmm.  I'm not sure.  The inline latency should fair out to be better 
than before on average (common case is to disable pre-emption, enqueue 
on the postponed list and re-enable pre-emption, which is fast).  It's 
the clearing of the queues that may take a little longer, though the 
locking overhead should be the same.  The trouble is that the queue 
itself may not be cache hot and that would add a bit of latency.

Would you know of a good way to detect this latency for fewer objects?

> 
>>> As a high level comment it seems like a lot of work to work
>>> around global locks, like the inode_lock, where it might be better to 
>>> just split the lock up? Mind you I don't have a clear proposal
>>> how to do that, but surely it's doable somehow.
>>>
>> Perhaps.. the only plausible way I can think this would be doable would 
>> be to rework the global resources (like the global inode_unused LRU list 
> 
> One simple way would be to just use multiple lists with an own lock 
> each. I doubt that would impact the LRU behaviour very much.
> 
>> and deal with inode state transitions), but even then, some sort of 
>> consistency needs to happen at the super_block level,
> 
> The sb could also look at multiple lists?

Maybe (hashing on inode nr perhaps?).

The other trouble is that dcache_lock which for the most part stands in 
from of the inode_lock.  While developing this patchset, I was 
originally chasing dcache_lock contention issues.  Once I relieved the 
contention via deferred batching and parallel processing of dput(), I 
was surprised to see that performance didn't get any better because now 
I was mostly contending on inode_lock :\

The dcache_lock again could maybe be broken out to be per super_block, 
but I have no idea how to make that work with mountpoint traversals. 
Making this guy become a set of smaller locks seems difficult at best.
