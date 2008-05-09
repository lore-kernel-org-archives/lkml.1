Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYEIUCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYEIUCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYEIUCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:02:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59183 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752284AbYEIUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:02:19 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	<20080507073017.GJ32195@elte.hu>
	<bzymymzv3j7.fsf@fransum.emea.sgi.com>
	<1210355814.13978.255.camel@twins>
From: Olaf Weber <olaf@sgi.com>
Date: Fri, 09 May 2008 22:01:56 +0200
In-Reply-To: <1210355814.13978.255.camel@twins> (Peter Zijlstra's message of "Fri, 09 May 2008 19:56:54 +0200")
Message-ID: <bzyk5i3w8jv.fsf@fransum.emea.sgi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.3 (irix)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:
> On Fri, 2008-05-09 at 18:35 +0200, Olaf Weber wrote:

>> An alternative approach would to view this as a bug of the rwlock_t
>> code in particular, and fix it by keeping new readers from a acquiring
>> an rwlock_t if a writer is also trying to lock it.  For x86 at least,
>> I can sketch an implementation that is based on the new ticket-based
>> spinlocks:
>>  - use the ticket-based lock for writers
>>  - add a reader count for readers (16 bits out of 32 are free)
>>  - readers get in if the write lock is idle
>>  - if the write lock wasn't idle, readers loop until it is
>>  - on obtaining the ticket-based lock, the writer waits for active
>>    readers to leave (eg reader count to go to zero)
>> Contention by writers now keeps readers out, which may be a problem.
>> 
>> Advantages of such an approach:
>>  - Writers are "fair" amongst themselves.
>>  - Readers cannot hold off writers.
>> 
>> Disadvantages:
>>  - Contention among writers can hold off readers indefinitely.
>>    This scheme only works if the write lock is not "permanently"
>>    contended, otherwise it goes from frying pan to fire.
>>  - Requires changes to the asm-coded locking primitives, which means
>>    it is likely to be done for x86 and ia64 only, unless the platform
>>    maintainers step in.
>> 
>> Given the above, is this worth pursuing for inclusion in mainline?

> Keep in mind that rwlock_t must support recusive read locks. Much code
> depends on this.

Ouch.  Given the possibility of something like this:

    thread A                thread B
    read_lock         
                            write_lock -- attempt, will spin
    read_lock -- recursive

we'd have to deal with not having the write be a barrier to the
recursive read_lock, yet a barrier to a new read_lock.  That's not
possible without keeping track of read_lock owners, which would
greatly complicate the locks.

IMHO recursive locking is moderately evil at the best of time, but if
it's there, its there.  (And if it's necessary, it has to be allowed.)



>> A third solution would be to look at this problem on a case-by-case
>> basis.  In the case under discussion, there may be other kernel bugs
>> that aggravate the problem (it is an old kernel after all) and maybe
>> this just means the address_space.tree_lock ought to be replaced with
>> something else (though I wouldn't claim to know what).

> That has been done by Nick Piggin, the lockless pagecache work removes
> the read side of the tree_lock.

Now that is good news.

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com
