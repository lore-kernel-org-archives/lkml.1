Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYHVMUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYHVMUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYHVMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:19:56 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:49189 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYHVMTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:19:55 -0400
Message-ID: <42930.166.70.238.46.1219406040.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <tkrat.28e983dc4d04d109@s5r6.in-berlin.de>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
    <200808212337.38626.nickpiggin@yahoo.com.au>
    <48AD7705.2000404@s5r6.in-berlin.de>
    <200808221140.25029.nickpiggin@yahoo.com.au>
    <tkrat.28e983dc4d04d109@s5r6.in-berlin.de>
Date: Fri, 22 Aug 2008 05:54:00 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 
     released
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       paulmck@linux.vnet.ibm.com, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
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

> On 22 Aug, Nick Piggin wrote:
>> On Friday 22 August 2008 00:09, Stefan Richter wrote:
>>> Nick Piggin wrote:
>>> > On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com
>>> wrote:
>>> >> It's simple to reproduce.  Take away the volatile declaration for
>>> the
>>> >> rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
>>> >> references and watch the thing lock up in SMP with multiple
>>> processors
>>> >> in the debugger each stuck with their own local copy of debug_lock.
>>> >
>>> > You should disable preempt before getting the processor id. Can't see
>>> any
>>> > other possible bugs, but you should be able to see from the
>>> disassembly
>>> > pretty easily.
>>>
>>> debug_lock() is AFAICS only called from contexts which have preemption
>>> disabled.  Last time around I recommended to Jeff to document this
>>> requirement on the calling context.
>>
>> I'm not talking about where debug_lock gets called, I'm talking about
>> where the processor id is derived that eventually filters down to
>> debug_lock.
>
> You are right, I replied to fast.  debug_unlock() retrieves the
> processor itself, but not debug_lock().
>
>>> But even though preemption is disabled, debug_lock() is still incorrect
>>> as I mentioned in my other post a minute ago.  It corrupts its .flags
>>> and .count members.  (Or maybe it coincidentally doesn't as long as
>>> volatile is around.)
>>
>> I don't think so. And flags should only be restored by the processor
>> that saved it because the spinlock should disable preemption, right?
>
> OK; the .count seems alright due to restrictions of the calling
> contexts.  About .flags:  Jeff, can the following happen?
>
>   - Context A on CPU A has interrupts enabled.  Enters debug_lock(),
>     thus disables its interrupts.  (Saves its flags in rlock->flags with
>     the plan to enable interrupts later when leaving debug_unlock()
>     provided it does so as last holder.)

ints should already be off here.
>
>   - Context B on CPU B happens to have interrupts disabled.  Enters
>     debug_lock(), overwrites rlock->flags with its different value.
>     (Spins on the rlock which is held by CPU A.)

ints are disabled on both here (should be).

>
>   - Context A on CPU A leaves debug_unlock.  Doesn't re-enable its
>     interrupts as planned, since rlock->flags is the one from CPU B.
> --

It should be benign since both procs have ints off here.

Stefan,

The flags needs fixing, you are right, however, since this case only
occurs when two processors both have an int1 exception (or some exception
other than an NMI) and ints are disabled here anyway, its benign.   That
being said, it needs to be perfect.  So I moved the flags to a stack
variable.

I will post a new patch series correcting the flags issue along with code
fragments showing the gcc breakage with debug lock later tonight.  I have
a lot to get done at omega8 on appliance releases this week, and being a
48 years old this year, I am slower than I used to be.

:-)

Jeff



