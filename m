Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYHIIEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYHIIEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 04:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYHIIEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 04:04:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53915 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYHIIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 04:04:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489D4F73.5030109@s5r6.in-berlin.de>
Date: Sat, 09 Aug 2008 10:04:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com> <489B199B.40305@s5r6.in-berlin.de> <489D2600.7020400@goop.org>
In-Reply-To: <489D2600.7020400@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Stefan Richter wrote:
>> jmerkey@wolfmountaingroup.com wrote:
>>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch 
[...]
>> The accessors rspin_lock() and rspin_try_lock() peek into spinlock_t and
>> may therefore not be fully portable.  Also, they and rspin_unlock()
>> don't look SMP safe:
>>
>>  
>>> +//
>>> +//   returns   0 - atomic lock occurred, processor assigned
>>> +//             1 - recusive count increased
>>> +//
>>> +
>>> +unsigned long rspin_lock(volatile rlock_t *rlock)
>>> +{
>>> +#if defined(CONFIG_SMP)
>>> +   register unsigned long proc = get_processor_id();
>>> +   register unsigned long retCode;
>>> +
>>> +   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
>>>     
> 
> Ticket locks will almost always have a non-zero slock.  It doesn't 
> indicate anything about the locked/unlocked state.  But this looks like 
> it's effectively doing a trylock:
> 
>     if (!spin_trylock(rlock) && rlock->processor == proc) {
>         rlock->count++;
>         ...
>     } else {
>         rlock->processor = proc;
>         ...
>     }

Right.  This implemention also looks free of race conditions, provided that

   - rspin_lock, rspin_try_lock, and rspin_unlock are only called in
     contexts with disabled preemption and disabled local interrupts,

   - rspin_unlock() rewrites rlock->processor to "no CPU" before
     it drops the lock.  (The implementation in
     mdb-2.6.27-rc2-ia32-08-07-08.patch does so.)

BTW, the rspin_try_lock() in that patch wrong:  It always returns 0 
instead of having three branches of execution which return 0/1/-1.
-- 
Stefan Richter
-=====-==--- =--- -=--=
http://arcgraph.de/sr/
