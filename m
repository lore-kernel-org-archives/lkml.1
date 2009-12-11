Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbZLKPcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbZLKPcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZLKPcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:32:20 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:13497 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbZLKPcT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;6:1>);
	Fri, 11 Dec 2009 10:32:19 -0500
Message-Id: <4B227418020000780002553C@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 11 Dec 2009 15:32:24 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, <mingo@elte.hu>,
       <tglx@linutronix.de>, "Nick Piggin" <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v2)
References: <4B179A6D0200007800023542@vpn.id2.novell.com>
 <alpine.LFD.2.00.0912031303180.2872@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912031303180.2872@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Linus Torvalds <torvalds@linux-foundation.org> 03.12.09 22:10 >>>
>On Thu, 3 Dec 2009, Jan Beulich wrote:
>> @@ -88,12 +88,11 @@ static __always_inline int __ticket_spin
>>  		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
>>  		     "1:"
>>  		     "sete %b1\n\t"
>> -		     "movzbl %b1,%0\n\t"
>>  		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
>>  		     :
>>  		     : "memory", "cc");
>>  
>> -	return tmp;
>> +	return new;
>
>This is fairly pessimal register allocation.
>
>It used to be that we returned the value in 'tmp', which is %eax, which is 
>also the expected return register. Now that we use 'new', it's some random 
>other register that is _not_ %eax, which means that while we avoid a 
>'movzbl', the regular spin_trylock function call case will now have the 
>compiler emitting a 
>
>	movb %X,%al
>	ret
>
>at the end just to get the right return register.

No, not really, because __spin_trylock() doesn't directly pass on the
return value of _raw_spin_trylock().

>Which seems a bit annoying. It looks like we could have done that last 
>instruction as just
>
>	sete %b0
>
>instead, and then return 'tmp' instead of 'new', keeping the return value 
>in %al and avoiding the unnecessary movement.
>
>> -static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
>> +static __always_inline u8 __ticket_spin_trylock(raw_spinlock_t *lock)
>
>Same thing here, afaik.
>
>NOTE! I haven't actually looked at the generated code, and if we actually 
>inline it all the way to the caller, it won't matter (and picking another 
>register may even help). But while these helpers are marked 
>__always_inline, I _thought_ that the way we actually build the final 
>'spin_trylock()' function we end up with a real function in the end.

The code isn't really much different either way: In the old variant, the
compiler generated a xor/set pair, in the variant you suggest it
produces a single movzx. In the _spin_trylock_bh() case the new
variant actually produces an extra instruction (copying from %eax to
another register), but all that certainly also depends on the compiler
version.

Hence I'm really uncertain which of both methods is preferable. The
one additional benefit to the version you suggest is that it permits
relaxing the constraint of 'new' from q to r (permitting the compiler
to pick from a wider set of registers on 32-bit). But since there are
only very few direct callers of _raw_spin_trylock(), this is marginal,
as it doesn't matter for _spin_trylock() (I don't think the lock
debugging case really needs much attention on performance).

Jan

