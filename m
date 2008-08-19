Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYHSO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYHSO6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYHSO6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:58:04 -0400
Received: from gw.goop.org ([64.81.55.164]:59025 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYHSO6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:58:04 -0400
Message-ID: <48AADF78.7030108@goop.org>
Date: Tue, 19 Aug 2008 07:58:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
 to use function calls [POST 2]
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <20080819012816.GA7897@elte.hu> <48AA65A5.8020408@goop.org> <20080819092754.GE28713@elte.hu>
In-Reply-To: <20080819092754.GE28713@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> I think this might be a spurious "holding multiple locks in the same 
>> class" bug.  All the queue locks are presumably in the same class, and 
>> ipi_call_lock_irq() wants to hold them all to lock out any IPIs. 
>> Spurious because this is the only place which holds more than one 
>> queue lock, and it always locks 0->N.
>>
>> I guess the fix is to use an outer lock and use spin_lock_nested() 
>> (now that it exists).  Something along these lines?
>>     
>
> this is not a good idea:
>
>   
>> +/* Hold queues_lock when taking more than one queue[].lock at once */
>> +static DEFINE_SPINLOCK(queues_lock);
>>     
>
> because it adds an artificial extra spinlock for no good reason and 
> weakens the lock dependency checking as well.
>
> Just add a lock class descriptor to each call_function_queue lock, so 
> that lockdep can see that it's truly all in the correct order.
>
> I.e. dont turn lockdep off artificially.

Are you sure?  I thought this is exactly the case where
spin_lock_nest_lock() is supposed to be used?  Admittedly it's very
simple, but the extra lock does two things: 1) it guarantees that the
queue locks can be taken in any order, and 2) it's a single lock on
which we can do spin_lock_irq(), rather than doing it in the loop for
each individual lock (which I think was bogus).

I don't see how it weakens lockdep in any way.  Does it hide any
potential lock misuse?

    J

