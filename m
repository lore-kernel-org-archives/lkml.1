Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXGTESw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXGTESw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbXGTESn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:18:43 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61403 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750733AbXGTESm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:18:42 -0400
Date: Fri, 20 Jul 2007 00:18:39 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock (cmpxchg8b)
Message-ID: <20070720041839.GA11217@Krystal>
References: <200707191154.642492000@suse.de> <20070719095459.E60AD14E11@wotan.suse.de> <1184863904.6458.17.camel@dhcp193.mvista.com> <20070720031105.GA8237@Krystal> <20070720034757.GA9093@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070720034757.GA9093@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:07:49 up 2 days, 22:41,  1 user,  load average: 0.98, 1.29, 0.79
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
 
> I just want to rectify a detail: local_t uses type "long", which is 32
> bits on x86_32 and 64 bits on x86_64.
> 
> Using a cmpxchg8b on i386 seems to require the LOCK prefix to be taken,
> so it may degrate performances too much. Therefore, you may prefer to
> stay with cli/sti on i386, but using a local cmpxchg would make sense on
> x86_64.
> 
> A side-note: I really dislike the new cmpxchg behavior when a too
> large value is passed to it. If we pass a uint64_t * as first argument
> to cmpxchg or cmpxchg_local on i386, it just fails silently. Before, a
> linker error was produced, which required the kernel to be compiled with
> -O2 as side-effect, but at least there wasn't any silent failure...
> 
> Mathieu
> 

Actually, about the i386 case, I am trying to get my head around the
locked cmpxchg8b issue.

I just implemented what would look like something that could be added to
the standard cmpxchg on i386:

union pack64 {
        u64 value;
        struct {
                u32 low, high;
        };
};

static inline u64 cmpxchg8b(u64 * ptr, u64 old, u64 new)
{
        union pack64 oldu;
        union pack64 newu;
        union pack64 prevu;

        oldu.value = old;
        newu.value = new;

        __asm__ __volatile__("cmpxchg8b (%6)\n\t"
                             : "=d"(prevu.high), "=a" (prevu.low)
                             : "0" (oldu.high), "1" (oldu.low),
                               "c" (newu.high), "b" (newu.low),
                               "m"(*__xg(ptr))
                             : "memory");
        return prevu.value;
}

I tried it with and without the LOCK prefix on my Pentium 4.

Locked cmpxchg8b : 90 cycles
Non locked cmpxchg8b: 30 cycles
sti: 166 cycles
cli: 159 cycles

So, hrm, even if we use the locked version, it is still much faster than
the sti/cli. I am thoughtful about the comment in asm-i386/system.h:

/*
 * The semantics of XCHGCMP8B are a bit strange, this is why
 * there is a loop and the loading of %%eax and %%edx has to
 * be inside. This inlines well in most cases, the cached
 * cost is around ~38 cycles. (in the future we might want
 * to do an SIMD/3DNOW!/MMX/FPU 64-bit store here, but that
 * might have an implicit FPU-save as a cost, so it's not
 * clear which path to go.)
 *
 * cmpxchg8b must be used with the lock prefix here to allow 
 * the instruction to be executed atomically, see page 3-102
 * of the instruction set reference 24319102.pdf. We need
 * the reader side to see the coherent 64bit value.
 */

I just re-read 24319102.pdf page 3-102. Here is what seems to be the
reference used:

"This instruction can be used with a LOCK prefix to allow the
instruction to be executed atomi cally. To simplify the interface to the
processor’s bus, the destination operand receives a write cycle without
regard to the result of the comparison. The destination operand is
written back if the comparison fails; otherwise, the source operand is
written into the destination. (The processor never produces a locked
read without also producing a locked write.)" (page 3-102)

However, we find _exactly_ the same comment about the cmpxchg
instruction:

"This instruction can be used with a LOCK prefix to allow the
instruction to be executed atomi cally. To simplify the interface to the
processor’s bus, the destination operand receives a write cycle without
regard to the result of the comparison. The destination operand is
written back if the comparison fails; otherwise, the source operand is
written into the destination. (The processor never produces a locked
read without also producing a locked write.)" (page 3-100)

Since we use the standard cmpxchg without lock prefix and consider it
atomic wrt the local CPU, I wonder why we could not do the same for
cmpxchg8b ? Any idea ?

It could then give you 8 bytes cmpxchg atomical wrt the local CPU for 30
cycles, which is really not so bad! Or is there any undocumented
funkyness about cmpxchg8b I should be aware of ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
