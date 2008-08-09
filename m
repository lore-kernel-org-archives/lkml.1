Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYHIFHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYHIFHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 01:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYHIFHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 01:07:31 -0400
Received: from gw.goop.org ([64.81.55.164]:34812 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYHIFHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 01:07:30 -0400
Message-ID: <489D2600.7020400@goop.org>
Date: Fri, 08 Aug 2008 22:07:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com> <489B199B.40305@s5r6.in-berlin.de>
In-Reply-To: <489B199B.40305@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> jmerkey@wolfmountaingroup.com wrote:
>   
>> The mdb-rc2 patch was posted this morning with the changes for a modular
>> kernel debugger using kprobes.
>>
>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch
>>
>> Jeffrey Vernon Merkey
>>     
>
>
> Quoting from this patch:
>
>   
>> +typedef struct _RLOCK 
>> +{
>> +#if defined(CONFIG_SMP)
>> +    spinlock_t lock;
>> +#endif
>> +    unsigned long flags;
>> +    unsigned long processor;
>> +    unsigned long count;    
>> +} rlock_t;
>>     
>
> Is this something along the lines of a counting semaphore?  As far as I
> understand its accessor functions, an rlock
>   - can be taken by one CPU multiple times,
>   - will block the other CPUs as long as the first CPU hasn't unlocked
>     the rlock as many times as it locked it.
>
> The accessors rspin_lock() and rspin_try_lock() peek into spinlock_t and
> may therefore not be fully portable.  Also, they and rspin_unlock()
> don't look SMP safe:
>
>   
>> +//
>> +//   returns   0 - atomic lock occurred, processor assigned
>> +//             1 - recusive count increased
>> +//
>> +
>> +unsigned long rspin_lock(volatile rlock_t *rlock)
>> +{
>> +#if defined(CONFIG_SMP)
>> +   register unsigned long proc = get_processor_id();
>> +   register unsigned long retCode;
>> +
>> +   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
>>     

Ticket locks will almost always have a non-zero slock.  It doesn't 
indicate anything about the locked/unlocked state.  But this looks like 
it's effectively doing a trylock:

	if (!spin_trylock(rlock) && rlock->processor == proc) {
		rlock->count++;
		...
	} else {
		rlock->processor = proc;
		...
	}


    J


