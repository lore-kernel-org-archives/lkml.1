Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZLRQhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZLRQhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 11:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZLRQhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 11:37:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772AbZLRQhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 11:37:12 -0500
Date: Fri, 18 Dec 2009 08:36:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Beulich <JBeulich@novell.com>
cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: slightly shorten __ticket_spin_trylock() (v3)
In-Reply-To: <4B2BB5830200007800026AC7@vpn.id2.novell.com>
Message-ID: <alpine.LFD.2.00.0912180822380.3712@localhost.localdomain>
References: <4B2BB5830200007800026AC7@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Jan Beulich wrote:
>
> -static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
> +static __always_inline u8 __ticket_spin_trylock(arch_spinlock_t *lock)
>  {
>  	int tmp, new;
>  
> @@ -87,8 +87,7 @@ static __always_inline int __ticket_spin
>  		     "jne 1f\n\t"
>  		     LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
>  		     "1:"
> -		     "sete %b1\n\t"
> -		     "movzbl %b1,%0\n\t"
> +		     "sete %b0\n\t"
>  		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
>  		     :
>  		     : "memory", "cc");
> @@ -127,7 +126,7 @@ static __always_inline void __ticket_spi

Btw, I looked at that earlier, and it's still pretty sub-optimal.

There's two problems - nobody actually uses the low-level code directly, 
it goes through a 

	if (__ticket_spinlock()) {
		..
		return 1;
	}
	return 0;

logic. Which means that regardless of what the asm does, the end result 
will still be something like this _after_ the asm:

        1:sete %al      # tmp

# 0 "" 2
#NO_APP
        testb   %al, %al        # tmp
        leave
        setne   %al     #, tmp66

ie you have that "sete" (in the asm) being then followed by testb/setne 
again (from the C code wrappers).

The other problem is that the compiler could actually generate better code 
if you leave it to it, so doing

        int tmp, new;

        tmp = ACCESS_ONCE(lock->slock);
        new = tmp + 0x100;
        asm volatile("cmpb %h0,%b0\n\t"
                     "jne 1f\n\t"
                     LOCK_PREFIX "cmpxchgw %w2,%1\n\t"
                     "1:"
                     "sete %b0\n\t"
                     : "=a" (tmp), "+m" (lock->slock)
                     : "r" (new), "0" (tmp)
                     : "memory", "cc");

        return tmp;

actually seems to result in better code:

	_raw_spin_trylock:
	        pushq   %rbp    #
	        movl    (%rdi), %eax    #* lock, D.17152
	        movq    %rsp, %rbp      #,
	        leal    256(%rax), %edx #, new
	#APP
	# 86 "/home/torvalds/v2.6/linux/arch/x86/include/asm/spinlock.h" 1
	        cmpb %ah,%al    # tmp
	        jne 1f
	        .section .smp_locks,"a"
	 .balign 8
	 .quad 661f
	.previous
	661:
	        lock; cmpxchgw %dx,(%rdi)       # new,* lock
	        1:sete %al      # tmp
	
	# 0 "" 2
	#NO_APP

Look - no "movzwl" at all at the beginning, because it turns out that the 
spinlock is a "unsigned int" and the "movl" to load the value pairs just 
fine with the "leal" that the compiler can do too.  And we didn't 
artificially constrain the second register to a byte register either (but 
the compiler still picked %dx, of course).

I dunno. I still don't get the feeling that any of this actually 
_matters_.

(Btw, the above isn't actually tested - I just edited the inline asm and 
looked at what gcc generated, I didn't _run_ any of it).

			Linus
