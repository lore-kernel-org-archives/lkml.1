Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYHVGgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYHVGgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYHVGga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:36:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46491 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYHVGg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:36:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 22 Aug 2008 08:32:57 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4
 released
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: jmerkey@wolfmountaingroup.com, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <200808221140.25029.nickpiggin@yahoo.com.au>
Message-ID: <tkrat.28e983dc4d04d109@s5r6.in-berlin.de>
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>
 <200808212337.38626.nickpiggin@yahoo.com.au>
 <48AD7705.2000404@s5r6.in-berlin.de>
 <200808221140.25029.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Aug, Nick Piggin wrote:
> On Friday 22 August 2008 00:09, Stefan Richter wrote:
>> Nick Piggin wrote:
>> > On Thursday 21 August 2008 22:26, jmerkey@wolfmountaingroup.com wrote:
>> >> It's simple to reproduce.  Take away the volatile declaration for the
>> >> rlock_t structure in mdb-ia32.c (rlock_t debug_lock) in all code
>> >> references and watch the thing lock up in SMP with multiple processors
>> >> in the debugger each stuck with their own local copy of debug_lock.
>> >
>> > You should disable preempt before getting the processor id. Can't see any
>> > other possible bugs, but you should be able to see from the disassembly
>> > pretty easily.
>>
>> debug_lock() is AFAICS only called from contexts which have preemption
>> disabled.  Last time around I recommended to Jeff to document this
>> requirement on the calling context.
> 
> I'm not talking about where debug_lock gets called, I'm talking about
> where the processor id is derived that eventually filters down to
> debug_lock.

You are right, I replied to fast.  debug_unlock() retrieves the
processor itself, but not debug_lock().

>> But even though preemption is disabled, debug_lock() is still incorrect
>> as I mentioned in my other post a minute ago.  It corrupts its .flags
>> and .count members.  (Or maybe it coincidentally doesn't as long as
>> volatile is around.)
> 
> I don't think so. And flags should only be restored by the processor
> that saved it because the spinlock should disable preemption, right?

OK; the .count seems alright due to restrictions of the calling
contexts.  About .flags:  Jeff, can the following happen?

  - Context A on CPU A has interrupts enabled.  Enters debug_lock(),
    thus disables its interrupts.  (Saves its flags in rlock->flags with
    the plan to enable interrupts later when leaving debug_unlock()
    provided it does so as last holder.)

  - Context B on CPU B happens to have interrupts disabled.  Enters
    debug_lock(), overwrites rlock->flags with its different value.
    (Spins on the rlock which is held by CPU A.)

  - Context A on CPU A leaves debug_unlock.  Doesn't re-enable its
    interrupts as planned, since rlock->flags is the one from CPU B.
-- 
Stefan Richter
-=====-==--- =--- =-==-
http://arcgraph.de/sr/


