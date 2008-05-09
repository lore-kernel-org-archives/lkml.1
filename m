Return-Path: <linux-kernel-owner+w=401wt.eu-S1764888AbYEIQgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764888AbYEIQgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYEIQfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:35:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41084 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751675AbYEIQfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:35:52 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	<20080507073017.GJ32195@elte.hu>
From: Olaf Weber <olaf@sgi.com>
Date: Fri, 09 May 2008 18:35:40 +0200
In-Reply-To: <20080507073017.GJ32195@elte.hu> (Ingo Molnar's message of "Wed, 7 May 2008 09:30:17 +0200")
Message-ID: <bzymymzv3j7.fsf@fransum.emea.sgi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.3 (irix)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
> * Christoph Lameter <clameter@sgi.com> wrote:

>> @@ -132,10 +132,14 @@ unsigned long __lockfunc _write_lock_irq
>> {
>> unsigned long flags;
>> 
>> +retry:
>> local_irq_save(flags);
>> -	preempt_disable();
>> -	_raw_write_lock(lock);
>> -	return flags;
>> +	if (_write_trylock(lock))
>> +		return flags;
>> +	local_irq_restore(flags);
>> +	while (!write_can_lock(lock))
>> +		cpu_relax();
>> +	goto retry;
>> }
>> EXPORT_SYMBOL(_write_lock_irqsave);

> hm, this is done on a too high level and will turn off some debugging 
> code. I.e. if we dont just loop long but truly deadlock here we wont 
> call lib/spinlock_debug.c's _raw_write_lock() code that does some sanity 
> checks in the debug case.

> so how about doing this on a deeper level and adding a new 
> __raw_write_lock_flags() primitive that would look at the flags value 
> and could enable interrupts in the lowlevel code?

Thinking of an alternative approach, I'd like to revisit the original
problem for a moment: on a (big) system running a kernel based on
2.6.16 we found that in the following stack trace, pdflush has just
enabled irqs again on its cpu after running with irqs disabled for
about 2 minutes.

>> bt 0xe0000168f4378000
================================================================
STACK TRACE FOR TASK: 0xe0000168f4378000 (pdflush)

 0 kdba_main_loop+0x14c [0xa0000001004190cc]
 1 kdb+0x11fc [0xa0000001002a639c]
 2 kdb_ipi+0x11c [0xa0000001002a12dc]
 3 handle_IPI+0x27c [0xa00000010005671c]
 4 handle_IRQ_event+0x8c [0xa0000001000fa40c]
 5 __do_IRQ+0x12c [0xa0000001000fa5cc]
 6 ia64_handle_irq+0x15c [0xa00000010001213c]
 7 ia64_leave_kernel [0xa00000010000cb20]
 8 _write_unlock_irqrestore+0x40 [0xa000000100558500]
 9 test_set_page_writeback+0x18c [0xa000000100114b6c]
10 xfs_start_page_writeback+0x2c [0xa0000002e4ab914c]
11 xfs_page_state_convert+0xa0c [0xa0000002e4abcbac]
12 xfs_vm_writepage+0x19c [0xa0000002e4abd13c]
13 mpage_writepages+0x3fc [0xa0000001001bcb5c]
14 xfs_vm_writepages+0xac [0xa0000002e4ab9eac]
15 do_writepages+0xac [0xa0000001001136cc]
16 __writeback_single_inode+0x47c [0xa0000001001b8f7c]
17 sync_sb_inodes+0x4ac [0xa0000001001b9cec]
18 writeback_inodes+0x19c [0xa0000001001baafc]
19 wb_kupdate+0x26c [0xa000000100113bcc]
20 pdflush+0x38c [0xa00000010011582c]
21 kthread+0x22c [0xa0000001000c9dac]
22 kernel_thread_helper+0xcc [0xa000000100012f6c]
23 start_kernel_thread+0x1c [0xa0000001000094bc]
================================================================

There is, as far as I could tell, no code in the critical region of
test_set_page_writeback that could take this much time, except for the
call to _write_lock_irqsave itself.  There the root of the problem
seems to have been that many threads went after the read lock, and an
rwlock_t will allow readers in while readers hold the lock, even if a
writer needs it, thus potentially starving the writer indefinitely (up
to 2 minutes in the case under discussion).

Re-enabling irqs when looping in _write_lock_irqsave (and *_irq and
*_bh) works here because _write_lock_irqsave() wasn't called with irqs
disabled.  But pdflush will still spend a long time getting the lock.

The reason we're pursuing this nevertheless is that it is easy to do
starting from the current code-base, and doesn't impose API or ABI
changes.


An alternative approach would to view this as a bug of the rwlock_t
code in particular, and fix it by keeping new readers from a acquiring
an rwlock_t if a writer is also trying to lock it.  For x86 at least,
I can sketch an implementation that is based on the new ticket-based
spinlocks:
 - use the ticket-based lock for writers
 - add a reader count for readers (16 bits out of 32 are free)
 - readers get in if the write lock is idle
 - if the write lock wasn't idle, readers loop until it is
 - on obtaining the ticket-based lock, the writer waits for active
   readers to leave (eg reader count to go to zero)
Contention by writers now keeps readers out, which may be a problem.

Advantages of such an approach:
 - Writers are "fair" amongst themselves.
 - Readers cannot hold off writers.

Disadvantages:
 - Contention among writers can hold off readers indefinitely.
   This scheme only works if the write lock is not "permanently"
   contended, otherwise it goes from frying pan to fire.
 - Requires changes to the asm-coded locking primitives, which means
   it is likely to be done for x86 and ia64 only, unless the platform
   maintainers step in.

Given the above, is this worth pursuing for inclusion in mainline?


A third solution would be to look at this problem on a case-by-case
basis.  In the case under discussion, there may be other kernel bugs
that aggravate the problem (it is an old kernel after all) and maybe
this just means the address_space.tree_lock ought to be replaced with
something else (though I wouldn't claim to know what).

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com
