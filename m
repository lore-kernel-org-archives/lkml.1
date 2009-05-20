Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZETWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZETWm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZETWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:42:20 -0400
Received: from claw.goop.org ([74.207.240.146]:45969 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZETWmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:42:19 -0400
Message-ID: <4A148740.1070405@goop.org>
Date: Wed, 20 May 2009 15:42:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Jun Nakajima <jun.nakajima@intel.com>,
       Xiaohui Xin <xiaohui.xin@intel.com>, Xin Li <xin.li@intel.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Performance overhead of paravirt_ops on			 nativeidentified
References: <4A0B62F7.5030802@goop.org> <4A0BED040200007800000DB0@vpn.id2.novell.com> <4A0C58BB.3090303@goop.org> <4A0D3F8C02000078000010A7@vpn.id2.novell.com> <4A0DB988.6000009@goop.org> <4A11280402000078000014E2@vpn.id2.novell.com>
In-Reply-To: <4A11280402000078000014E2@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Jeremy Fitzhardinge <jeremy@goop.org> 15.05.09 20:50 >>>
>>>>         
>> Jan Beulich wrote:
>>     
>>> A patch for the pv-ops kernel would require some time. What I can give you
>>> right away - just for reference - are the sources we currently use in our kernel:
>>> attached.
>>>       
>> Hm, I see.  Putting a call out to a pv-ops function in the ticket lock 
>> slow path looks pretty straightforward.  The need for an extra lock on 
>> the contended unlock side is a bit unfortunate; have you measured to see 
>> what hit that has?  Seems to me like you could avoid the problem by 
>> using per-cpu storage rather than stack storage (though you'd need to 
>> copy the per-cpu data to stack when handling a nested spinlock).
>>     
>
> Not sure how you'd imagine this to work: The unlock code has to look at all
> cpus' data in either case, so an inner lock would still be required imo.
>   

Well, rather than an explicit lock I was thinking of an optimistic 
scheme like the pv clock update algorithm.

"struct spinning" would have a version counter it could update using the 
even=stable/odd=unstable algorithm.  The lock side would simply save the 
current per-cpu "struct spinning" state onto its own stack (assuming you 
can even have nested spinning), and then update the per-cpu copy with 
the current lock.  The kick side can check the version counter to make 
sure it gets a consistent snapshot of the target cpu's current lock state.

I think that only the locking side requires locked instructions, and the 
kick side can be all unlocked.

>> What's the thinking behind the xen_spin_adjust() stuff?
>>     
>
> That's the placeholder for implementing interrupt re-enabling in the irq-save
> lock path. The requirement is that if a nested lock attempt hits the same
> lock on the same cpu that it failed to get acquired on earlier (but got a ticket
> already), tickets for the given (lock, cpu) pair need to be circularly shifted
> around so that the innermost requestor gets the earliest ticket. This is what
> that function's job will become if I ever get to implement this.
>   

Sounds fiddly.

>>> static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock) { 
>>> unsigned int token, count; bool free; __ticket_spin_lock_preamble; if 
>>> (unlikely(!free)) token = xen_spin_adjust(lock, token); do { count = 1 
>>> << 10; __ticket_spin_lock_body; } while (unlikely(!count) && 
>>> !xen_spin_wait(lock, token)); } 
>>>       
>> How does this work?  Doesn't it always go into the slowpath loop even if 
>> the preamble got the lock with no contention?
>>     
>
> It indeed always enters the slowpath loop, but only for a single pass through
> part of its body (the first compare in the body macro will make it exit the loop
> right away: 'token' is not only the ticket here, but the full lock->slock
> contents). But yes, I think you're right, one could avoid entering the body
> altogether by moving the containing loop into the if(!free) body. The logic
> went through a number of re-writes, so I must have overlooked that
> opportunity on the last round of adjustments.
>   

I was thinking of something like this: (completely untested)

void __ticket_spin_lock(raw_spinlock_t *lock)
{
	unsigned short inc = 0x100;
	unsigned short token;

	do {
		unsigned count = 1 << 10;
		asm volatile (
			"	lock xaddw %w0, %1\n"
			"1:	cmpb %h0, %b0\n"
			"	je 2f\n"
			"	rep ; nop\n"
			"	movb %1, %b0\n"
			/* don't need lfence here, because loads are in-order */
			"	sub $1,%2\n"
			"	jnz 1b\n"
			"2:"
			: "+Q" (inc), "+m" (lock->slock), "+r" (count)
			:
			: "memory", "cc");

		if (likely(count != 0))
			break;

		token = inc;
		inc = 0;
	} while (unlikely(!xen_spin_wait(lock, token)));
}


where xen_spin_wait() would actually be a pvops call, and perhaps the 
asm could be pulled out into an inline to deal with the 8/16 bit ticket 
difference.

    J
