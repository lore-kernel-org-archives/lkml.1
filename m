Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYK1WoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYK1WoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 17:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYK1WoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 17:44:08 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:49599 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYK1WoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 17:44:06 -0500
Message-ID: <49307406.4030609@cosmosbay.com>
Date: Fri, 28 Nov 2008 23:43:18 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCH 6/6] fs: Introduce kern_mount_special() to mount	special
 vfs
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDCAB.1070204@cosmosbay.com> <20081128092604.GL28946@ZenIV.linux.org.uk> <493072B7.5050308@cosmosbay.com>
In-Reply-To: <493072B7.5050308@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 28 Nov 2008 23:43:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Al Viro a écrit :
>> On Thu, Nov 27, 2008 at 12:32:59AM +0100, Eric Dumazet wrote:
>>> This function arms a flag (MNT_SPECIAL) on the vfs, to avoid
>>> refcounting on permanent system vfs.
>>> Use this function for sockets, pipes, anonymous fds.
>>
>> IMO that's pushing it past the point of usefulness; unless you can show
>> that this really gives considerable win on pipes et.al. *AND* that it
>> doesn't hurt other loads...
> 
> Well, if this is the last cache line that might be shared, then yes, 
> numbers can talk.
> But coming from 10 to 1 instead of 0 is OK I guess
> 
>>
>> dput() part: again, I want to see what happens on other loads; it's 
>> probably
>> fine (and win is certainly more than from mntput() change), but...  The
>> thing is, atomic_dec_and_lock() in there is often done on dentries with
>> d_count > 1 and that's fairly cheap (and doesn't involve contention on
>> dcache_lock on sane targets).
>>
>> FWIW, unless there's a really good reason to do alpha 
>> atomic_dec_and_lock()
>> in a special way, I'd try to compare with
> 
>>         if (atomic_add_unless(&dentry->d_count, -1, 1))
>>                 return;
> 
> I dont know, but *reading* d_count before trying to write it is expensive
> on modern cpus. Oprofile clearly show that on Intel Core2.
> 
> Then, *testing* the flag before doing the atomic_something() has the same
> problem. Or we should put flag in a different cache line.
> 
> I am lazy (time for a sleep here), maybe we are smart here and use a 
> trick like that already ?
> 
> atomic_t atomic_read_with_write_intent(atomic_t *v)
> {
>        int val = 0;
>     /*
>      * No LOCK prefix here, we only give a write intent hint to cpu
>      */
>        asm volatile("xaddl %0, %1"
>                     : "+r" (val), "+m" (v->counter)
>                     : : "memory");
>        return val;
> }

Forget it, its wrong... I really need to sleep :)


