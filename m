Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbXLQScA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbXLQScA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXLQSbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:31:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932AbXLQSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:31:50 -0500
Date: Mon, 17 Dec 2007 10:28:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: security@kernel.org, tytso@mit.edu,
       Herbert Xu <herbert@gondor.apana.org.au>,
       John Reiser <jreiser@BitWagon.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-sparse@vger.kernel.org, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] Signed divides vs shifts (Re: /dev/urandom uses uninit
 bytes, leaks user data)
In-Reply-To: <20071217185557.0b501e23.dada1@cosmosbay.com>
Message-ID: <alpine.LFD.0.9999.0712171009570.21557@woody.linux-foundation.org>
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au> <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org> <20071217185557.0b501e23.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Dec 2007, Eric Dumazet wrote:
> 
> while 
> 
> long *mid(long *a, long *b)
> {
> 	return ((a - b) / 2u + a);
> }

This is exactly what I'm talking about. That "2u" is TOTALLY POINTLESS. 
It's an "unsigned int", but since (a-b) will be of type ptrdiff_t, and is 
*wider* on a 64-bit architecture (it's the same as "long" on x86-64), then 
the 2u will just be converted to "long", and be signed again! 

So you thought that you did an unsigned divide, but you did no such thing. 

If you change the "2u" to a "2ul", it works again, and you get

	mid:
	        movq    %rdi, %rax
	        subq    %rsi, %rax
	        sarq    %rax
	        andq    $-8, %rax
	        addq    %rdi, %rax
	        ret

which is the code you wanted. But quite frankly, you could just have 
written it with a shift to start with, and avoided the subtle type issue, 
although gcc then generates

        movq    %rdi, %rax
        subq    %rsi, %rax
        sarq    $4, %rax
        leaq    (%rdi,%rax,8), %rax
        ret

instead. Of course, this all *does* still have subtle sign issues, because 
the "a-b" part implies a signed divide in itself, which is why you see 
that "sarq" in he first place (rather than a "shrq"). 

Signed divides are hard. The "a-b" pointer subtraction is actually cheaper 
than a general signed divide by sizeof, since the compiler can then assume 
that the two pointers are mutually aligned, which is why gcc can generate 
just a single "sarq" instead of having to do an extra "add negative bit" 
thing to get the rounding right.

[ So Al, when you said that

	(a-b)

  is equivalent to

	((char *)a-(char *)b)/4

  for a "int *" a and b, you're right in the sense that the *result* is 
  the same, but the code generation likely isn't. The "a-b" thing can (and 
  does) allow the compiler to avoid the whole "align up for signed 
  numbers" thing, and the difference in code generation is clear:

	subq    %rsi, %rdi
	sarq    $2, %rdi

  vs

	subq    %rsi, %rdi
	leaq    3(%rdi), %rax
	testq   %rdi, %rdi
	cmovs   %rax, %rdi
	sarq    $2, %rdi

  exactly because the first case *knows* that the low two bits have to be 
  zero, and thus there is no rounding issue. ]

			Linus
