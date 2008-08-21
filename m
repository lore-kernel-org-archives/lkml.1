Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYHUP2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYHUP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760759AbYHUP2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:28:32 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:41212 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969AbYHUP2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:28:31 -0400
Message-ID: <2265.69.2.248.210.1219330973.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48AD8835.2050208@s5r6.in-berlin.de>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>      
    <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> 
         <1219316568.8651.107.camel@twins>      
    <20080821114745.GD21089@linux.vnet.ibm.com>      
    <48AD5A21.7020801@s5r6.in-berlin.de>   
    <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
       <48AD757A.8000608@s5r6.in-berlin.de>
    <2820.69.2.248.210.1219327738.squirrel@webmail.wolfmountaingroup.com>
    <48AD8835.2050208@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 09:02:53 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger      2.6.27-rc4 
          released
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, paulmck@linux.vnet.ibm.com,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Howells" <dhowells@redhat.com>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com wrote:
> [Stefan Richter wrote]
>>> I'm having a quick look at mdb-2.6.27-rc4-ia32-08-20-08.patch at the
>>> moment.  Speaking of debug_lock()...:
> ...
>>> Major problem:  rlock->flags is wrong in this call.  Use an on-stack
>>> flags variable for the initial spin_trylock_irqsave.  Ditto in the
>>> following call of spin_trylock_irqsave.
>>>
>>> Next major problem with debug_lock() and debug_unlock():  The reference
>>> counting doesn't work.  You need an atomic_t counter.  Have a look at
>>> the struct kref accessors for example, or even make use of the kref
>>> API.
>>> Or if it isn't feasible to fix with atomic_t, add a second spinlock to
>>> rlock_t to ensure integrity of .count (and of the .processor if
>>> necessary).
> ...
>> The code works in debug lock provided this memory location is actually
>> SHARED between the processors.  The various race conditions you describe
>> are valid cases, but he only modifier of .count and .lock is the
>> processor
>> that obtains the spinlock -- the rest are readers.  This code works
>> well,
>> of course, when this memory location is actually SHARED between the
>> processors and the read/write operations serialized.
>>
>> Even in SMP, at various times it is necessary for the processors to
>> perform serializing operations.  You cannot in checker-scoreboard land
>> for
>> everything.
>
> Regarding rlock->count, I stand corrected:  It works correctly if the
> debug_lock()...debug_unlock() region can be entered by up to two
> contexts and if the second one to enter cannot be preempted by the first
> one.
>
> However, since these regions are enclosed in preempt_disable/enable and
> since the first one to grab the rlock->lock keeps local interrupts
> disabled until debug_unlock() or even longer, there is always only a
> single context in the debug_lock()...debug_unlock() region --- which
> defeats the whole purpose of the rlock_t.  Or what am I missing /now/?
>
> Independently of this, you cannot use rlock->flags like you currently
> do.  spin_trylock_irqsave would overwrite the flags of CPU A by the
> flags of CPU B, making the results of spin_unlock_irqrestore in
> debug_unlock unpredictable.


Hmmm....

Yep, that may be correct.  I'll fix that one since it is outside of the
lock.    At this point, the flags in the processors are all going to be
identical at this point in the code so it would not cause any problems
(local debugger state would not care), so the debugger would work with
this and does.  But I will change that and repost the patch this evening.

You have good eyes by friend.

Jeff
> --
> Stefan Richter
> -=====-==--- =--- =-=-=
> http://arcgraph.de/sr/
>


