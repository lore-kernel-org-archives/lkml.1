Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYHUOep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYHUOep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbYHUOeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:34:37 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:56778 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYHUOeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:34:36 -0400
Message-ID: <2820.69.2.248.210.1219327738.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48AD757A.8000608@s5r6.in-berlin.de>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>   
    <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> 
      <1219316568.8651.107.camel@twins>   
    <20080821114745.GD21089@linux.vnet.ibm.com>   
    <48AD5A21.7020801@s5r6.in-berlin.de>
    <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>
    <48AD757A.8000608@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 08:08:58 -0600 (MDT)
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
>> It's simple to reproduce.  Take away the volatile declaration for the
>> rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
>> references and watch the thing lock up in SMP with multiple processors
>> in
>> the debugger each stuck with their own local copy of debug_lock.
>
> I'm having a quick look at mdb-2.6.27-rc4-ia32-08-20-08.patch at the
> moment.  Speaking of debug_lock()...:
>
> You use spin_trylock_irqsave((spinlock_t *)&rlock->lock, rlock->flags)
> in there.  Minor nit:  The pointer type cast is unnecessary.
>
> Major problem:  rlock->flags is wrong in this call.  Use an on-stack
> flags variable for the initial spin_trylock_irqsave.  Ditto in the
> following call of spin_trylock_irqsave.
>
> Next major problem with debug_lock() and debug_unlock():  The reference
> counting doesn't work.  You need an atomic_t counter.  Have a look at
> the struct kref accessors for example, or even make use of the kref API.
> Or if it isn't feasible to fix with atomic_t, add a second spinlock to
> rlock_t to ensure integrity of .count (and of the .processor if
> necessary).
>
> Furthermore, I have doubts about the loop which is entered by CPU B
> while CPU A holds the rlock.  You are fully aware that atomic_read(a) &&
> !atomic_read(b) in its entirety is not atomic, I hope.
>
> All this aside, I don't see *anything* in debug_lock and _unlock which
> would necessitate volatile.  Well, volatile might have papered over some
> of these bugs.
>
> PS:
> Try to cut down on #if/#endif clutter.  It should be possible to reduce
> them at least in .c files; .h are a different matter.  For example,
> #if MDB_DEBUG_DEBUGGER
> 	DBGPrint("something");
> #endif
> can be trivially reduced to
> 	dbg_mdb_printk("something");
> where dbg_mdb_printk() is defined as an inline function which does
> nothing when MDB_DEBUG_DEBUGGER is false.
>
> PS2:
> Why are there this many debug printks anyway?
> --
> Stefan Richter
> -=====-==--- =--- =-=-=
> http://arcgraph.de/sr/
>

The code works in debug lock provided this memory location is actually
SHARED between the processors.  The various race conditions you describe
are valid cases, but he only modifier of .count and .lock is the processor
that obtains the spinlock -- the rest are readers.  This code works well,
of course, when this memory location is actually SHARED between the
processors and the read/write operations serialized.

Even in SMP, at various times it is necessary for the processors to
perform serializing operations.  You cannot in checker-scoreboard land for
everything.

Jeff

