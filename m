Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbXGXIjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbXGXIjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXGXIjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:39:21 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:31095 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752923AbXGXIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:39:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=HB/KVV1SjY/Gzv9StaUMLm94Byc41Hn3xx7s/yhZUXUb/lgK3rShh3EvtvwmL6rJos4GxX2CAJXUFHdGfR4LEeWEQOiC9R+iy53Ym9tcyLSgb4BLiWAhZyRd4WeSQ2D1sA8VL4egmGlviYm5ntf5c3/u0TKolhddEzGX6H2EDJA=  ;
X-YMail-OSG: S8lowbwVM1l0FBcYTV00zGhqbaUd4o_ecv02LU3fmS5DV6he2IfhbA6lgfcFe5.745SYULk4Qw--
Message-ID: <46A5BAB3.2030503@yahoo.com.au>
Date: Tue, 24 Jul 2007 18:39:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in> <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in> <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.64.0707241304410.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241304410.1433@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Tue, 24 Jul 2007, Nick Piggin wrote:
> 
> 
>>>>[...]
>>>>
>>>>__test_and_change_bit is one that you could remove the memory clobber
>>>>from.
>>>
>>>Yes, for the atomic versions we don't care if we're asking gcc to
>>>generate trashy code (even though I'd have wanted to only disallow
>>>problematic optimizations -- ones involving the passed bit-string
>>>address -- there, and allow other memory references to be optimized
>>>as and how the compiler feels like it) because the atomic variants
>>>are slow anyway and we probably want to be extra-safe there.
>>>
>>>But for the non-atomic variants, it does make sense to remove the
>>>memory clobber (and the unneeded __asm__ __volatile__ that another
>>>patch did -- for the non-atomic variants, again).
>>
>>No. It has nothing to do with atomicity and all to do with ordering.
> 
> 
> The memory clobber, or the volatile asm? There's more than one variable
> here ... but still, I don't think either affects _ordering_ in any
> _direct_ way.

The clobber which you remove with this patch.


>>For example test_bit, clear_bit, set_bit, etc are all atomic but none
>>place any restrictions on ordering.
> 
> 
> In that case we need to update comments in include/asm-i386/bitops.h

Hmm... yeah it looks like they could be reordered. I think?


>>__test_and_change_bit has no restriction on ordering, so as long as
>>the correct operands are clobbered, a "memory" clobber to enforce a
>>compiler barrier is not needed.
> 
> 
> But why even for the other operations? Consider (current code of)
> test_and_set_bit():
> 
> static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
> {
> 	int oldbit;
> 	__asm__ __volatile__( LOCK_PREFIX
> 		"btsl %2,%1\n\tsbbl %0,%0"
> 		:"=r" (oldbit),"+m" (ADDR)
> 		:"Ir" (nr) : "memory");
> 
> 	return oldbit;
> }
> 
> The only memory reference in there is to the passed address, it will
> be modified, yes, but that's been made obvious to gcc in the asm
> already. So why are we marking all of memory as clobbered, is the
> question. (I just read Jeremy's latest reply, but I don't see how
> or why the memory clobber helps that case either -- does a memory
> clobber affect how gcc would order / reorder code?)

Of course, because then the compiler can't assume anything about
the contents of memory after the operation.

   #define barrier() __asm__ __volatile__("": : :"memory")

A memory clobber is equivalent to a compiler barrier.

-- 
SUSE Labs, Novell Inc.
