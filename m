Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYHIPGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYHIPGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYHIPFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:05:54 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:59800 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYHIPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:05:53 -0400
Message-ID: <44066.166.70.238.43.1218293041.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489D4F73.5030109@s5r6.in-berlin.de>
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>
    <489B199B.40305@s5r6.in-berlin.de> <489D2600.7020400@goop.org>
    <489D4F73.5030109@s5r6.in-berlin.de>
Date: Sat, 9 Aug 2008 08:44:01 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, jmerkey@wolfmountaingroup.com,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeremy Fitzhardinge wrote:
>> Stefan Richter wrote:
>>> jmerkey@wolfmountaingroup.com wrote:
>>>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch
> [...]
>>> The accessors rspin_lock() and rspin_try_lock() peek into spinlock_t
>>> and
>>> may therefore not be fully portable.  Also, they and rspin_unlock()
>>> don't look SMP safe:
>>>
>>>
>>>> +//
>>>> +//   returns   0 - atomic lock occurred, processor assigned
>>>> +//             1 - recusive count increased
>>>> +//
>>>> +
>>>> +unsigned long rspin_lock(volatile rlock_t *rlock)
>>>> +{
>>>> +#if defined(CONFIG_SMP)
>>>> +   register unsigned long proc = get_processor_id();
>>>> +   register unsigned long retCode;
>>>> +
>>>> +   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
>>>>
>>
>> Ticket locks will almost always have a non-zero slock.  It doesn't
>> indicate anything about the locked/unlocked state.  But this looks like
>> it's effectively doing a trylock:
>>
>>     if (!spin_trylock(rlock) && rlock->processor == proc) {
>>         rlock->count++;
>>         ...
>>     } else {
>>         rlock->processor = proc;
>>         ...
>>     }
>
> Right.  This implemention also looks free of race conditions, provided
> that
>
>    - rspin_lock, rspin_try_lock, and rspin_unlock are only called in
>      contexts with disabled preemption and disabled local interrupts,
>
>    - rspin_unlock() rewrites rlock->processor to "no CPU" before
>      it drops the lock.  (The implementation in
>      mdb-2.6.27-rc2-ia32-08-07-08.patch does so.)
>
> BTW, the rspin_try_lock() in that patch wrong:  It always returns 0
> instead of having three branches of execution which return 0/1/-1.


.... On linux it does -- on another OS it does something quite different. 
I changed that case last night when I added spin)is_locked calls.   Is
there
to do a "debugger bust spinlocks" if the system ever hangs in the
debugger.  probably should code it different.

Jeff

:-)

Jeff

> --
> Stefan Richter
> -=====-==--- =--- -=--=
> http://arcgraph.de/sr/
>


