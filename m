Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbXHWTay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbXHWTay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbXHWTaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:30:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:54517 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbXHWTaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:30:15 -0400
In-Reply-To: <alpine.LFD.0.999.0708221116310.30176@woody.linux-foundation.org>
References: <46C03885.7000109@redhat.com> <20070813112452.GK24018@shell.boston.redhat.com> <swfhcmswcux.wl%takata.hirokazu@renesas.com> <swfejhww4cs.wl%takata.hirokazu@renesas.com> <46CC42EF.3030602@redhat.com> <8fc86c23579e12b012891d6e69b1b107@kernel.crashing.org> <alpine.LFD.0.999.0708221116310.30176@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e8b5ee6194ed619c245eb884c5ae6b11@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Hirokazu Takata <takata@linux-m32r.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
       akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       Chris Snook <csnook@redhat.com>, Chris Friesen <cfriesen@nortel.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 11/23] make atomic_read() and atomic_set() behavior consistent on m32r
Date: Thu, 23 Aug 2007 21:29:41 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The inline asm version has the EXACT SAME PROBLEM as the "volatile"
> version has: it means that the compiler is unable to combine trivial
> instructions.

This simply isn't true.  The compiler *can* combine asm stuff:


typedef struct { int counter; } atomic_t;

static inline __attribute__((pure)) int atomic_read(const atomic_t *v)
{
         int x;
         asm("ld %0,@%1" : "=r"(x) : "r"(&v->counter), "m"(v->counter));
         return x;
}

int f(atomic_t *x)
{
         return atomic_read(x) + atomic_read(x);
}

int g(atomic_t *x)
{
         return 0 * atomic_read(x);
}


generates


f:
         ld r0,@r0
         slli r0,#1
         jmp lr

g:
         ldi r0,#0
         jmp lr


> So why the *hell* you'd expect the asm version to be smaller, I can't
> imagine.

I expect it to be smaller than the current code, which uses the
"big hammer" volatile version.  We're talking about m32r here,
not x86.  Even when using "volatile asm" it shouldn't generate
much bigger code.

Anyhow, I answered my own question: on m32r, you cannot use "m"
with ld/st insns, since autoincrement modes don't work there (the
assembler complains, at least). So you have to force the address
into a reg instead, and _that_ causes the size increase.

> If the code needs barriers, the code should damn well add them.

Sure.  I'm not suggesting otherwise.


Segher

