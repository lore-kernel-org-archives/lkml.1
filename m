Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbYHUPYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbYHUPYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYHUPXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:23:53 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37132 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbYHUPXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:23:52 -0400
Message-ID: <48AD8835.2050208@s5r6.in-berlin.de>
Date: Thu, 21 Aug 2008 17:22:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger      2.6.27-rc4
      released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>       <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de>       <1219316568.8651.107.camel@twins>       <20080821114745.GD21089@linux.vnet.ibm.com>       <48AD5A21.7020801@s5r6.in-berlin.de>    <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>    <48AD757A.8000608@s5r6.in-berlin.de> <2820.69.2.248.210.1219327738.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <2820.69.2.248.210.1219327738.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
[Stefan Richter wrote]
>> I'm having a quick look at mdb-2.6.27-rc4-ia32-08-20-08.patch at the
>> moment.  Speaking of debug_lock()...:
...
>> Major problem:  rlock->flags is wrong in this call.  Use an on-stack
>> flags variable for the initial spin_trylock_irqsave.  Ditto in the
>> following call of spin_trylock_irqsave.
>>
>> Next major problem with debug_lock() and debug_unlock():  The reference
>> counting doesn't work.  You need an atomic_t counter.  Have a look at
>> the struct kref accessors for example, or even make use of the kref API.
>> Or if it isn't feasible to fix with atomic_t, add a second spinlock to
>> rlock_t to ensure integrity of .count (and of the .processor if
>> necessary).
...
> The code works in debug lock provided this memory location is actually
> SHARED between the processors.  The various race conditions you describe
> are valid cases, but he only modifier of .count and .lock is the processor
> that obtains the spinlock -- the rest are readers.  This code works well,
> of course, when this memory location is actually SHARED between the
> processors and the read/write operations serialized.
> 
> Even in SMP, at various times it is necessary for the processors to
> perform serializing operations.  You cannot in checker-scoreboard land for
> everything.

Regarding rlock->count, I stand corrected:  It works correctly if the
debug_lock()...debug_unlock() region can be entered by up to two
contexts and if the second one to enter cannot be preempted by the first
one.

However, since these regions are enclosed in preempt_disable/enable and
since the first one to grab the rlock->lock keeps local interrupts
disabled until debug_unlock() or even longer, there is always only a
single context in the debug_lock()...debug_unlock() region --- which
defeats the whole purpose of the rlock_t.  Or what am I missing /now/?

Independently of this, you cannot use rlock->flags like you currently
do.  spin_trylock_irqsave would overwrite the flags of CPU A by the
flags of CPU B, making the results of spin_unlock_irqrestore in
debug_unlock unpredictable.
-- 
Stefan Richter
-=====-==--- =--- =-=-=
http://arcgraph.de/sr/
