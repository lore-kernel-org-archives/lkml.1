Return-Path: <linux-kernel-owner+w=401wt.eu-S935206AbXEUTp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbXEUTp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933822AbXEUT2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:28:10 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:60110 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814AbXEUT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:28:08 -0400
Message-ID: <4651F261.2040903@cosmosbay.com>
Date: Mon, 21 May 2007 21:26:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: second, bigger problem with private futexes
References: <4651D628.1070206@redhat.com> <4651E1D4.6010705@cosmosbay.com> <4651E44A.9070301@redhat.com> <4651E992.9080205@cosmosbay.com>
In-Reply-To: <4651E992.9080205@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 21 May 2007 21:26:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Ulrich Drepper a écrit :
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Eric Dumazet wrote:
>>> Do you mean POSIX allowed to mix PROCESS_PRIVATE and PROCESS_SHARED
>>> condvar and mutexes ? Seems silly to me :(
>>
> 
>> Don't judge what you don't understand.
> 
> Yes, I kindly apologise for this crime.
> 
>  > If all waiters are always in one
>> process but the notifiers can be in different processes, this setup
>> might make a lot of sense.
> 
> Thanks for providing this information.
> 
> I assume in this case the condvar is PSHARED, while mutex could be/is 
> PRIVATE ?
> 
> I wonder how old (assuming all shared) code could work, since the 
> notifier would call FUTEX_CMP_REQUEUE giving a target address outside of 
> this process vm ?
> 
> My understanding (probably bad, since I know nothing about POSIX as you 
> mentioned)
> 
> - Old code could not use FUTEX_CMP_REQUEUE if mutex was private.
> -> Old code was using a normal FUTEX_WAKE in this case.
> 
> So I repeat my question : Should we really add yer another futex command 
> in kernel for a corner case ?
> 

Reading this I realize it's confusing... :(

Because a process issuing a futex() syscall cannot point to another process vm 
(without giving more information than just a virtual address), I do think :

1) pthread_cond_broadcast() SHOULD use FUTEX_CMP_REQUEUE if :

condvar & mutex are PSHARED

2) pthread_cond_broadcast() MUST use FUTEX_CMP_REQUEUE_PRIVATE if :

condvar & mutex are PRIVATE

3) if condvar is PRIVATE and mutex is SHARED, a FUTEX_WAKE_PRIVATE should be 
done. (and loose the REQUEUE optim)
Yes we could add a special futex primitive for this special case. But I cannot 
see how a program could use such a construct.

4) if condvar is SHARED and mutex is private, we have a *problem*, because the 
process doing the broadcast() can be in another mm. So a requeue is not 
possible at all. -> a FUTEX_WAKE is necessary (no REQUEUE optim)
I guess it's OK performance wise since the notifier in this case probably 
doesnt hold a lock on the mutex. And probably old glibc was doing same thing, 
since the mutex address stored in condvar was possibly in another vm, and 
notifier had the same problem.


Thanks

