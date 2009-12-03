Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZLCVMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZLCVMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZLCVMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:12:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155AbZLCVMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:12:08 -0500
Date: Thu, 3 Dec 2009 13:10:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Beulich <JBeulich@novell.com>
cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v2)
In-Reply-To: <4B179A6D0200007800023542@vpn.id2.novell.com>
Message-ID: <alpine.LFD.2.00.0912031303180.2872@localhost.localdomain>
References: <4B179A6D0200007800023542@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Dec 2009, Jan Beulich wrote:
>  
> -static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
> +static __always_inline u8 __ticket_spin_trylock(raw_spinlock_t *lock)
>  {
>  	int tmp, new;
>  
> @@ -88,12 +88,11 @@ static __always_inline int __ticket_spin
>  		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
>  		     "1:"
>  		     "sete %b1\n\t"
> -		     "movzbl %b1,%0\n\t"
>  		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
>  		     :
>  		     : "memory", "cc");
>  
> -	return tmp;
> +	return new;

This is fairly pessimal register allocation.

It used to be that we returned the value in 'tmp', which is %eax, which is 
also the expected return register. Now that we use 'new', it's some random 
other register that is _not_ %eax, which means that while we avoid a 
'movzbl', the regular spin_trylock function call case will now have the 
compiler emitting a 

	movb %X,%al
	ret

at the end just to get the right return register.

Which seems a bit annoying. It looks like we could have done that last 
instruction as just

	sete %b0

instead, and then return 'tmp' instead of 'new', keeping the return value 
in %al and avoiding the unnecessary movement.

> -static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
> +static __always_inline u8 __ticket_spin_trylock(raw_spinlock_t *lock)

Same thing here, afaik.

NOTE! I haven't actually looked at the generated code, and if we actually 
inline it all the way to the caller, it won't matter (and picking another 
register may even help). But while these helpers are marked 
__always_inline, I _thought_ that the way we actually build the final 
'spin_trylock()' function we end up with a real function in the end.

Maybe I'm wrong.

		Linus
