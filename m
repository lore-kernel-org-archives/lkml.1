Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXGXIVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXGXIVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbXGXIUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:20:54 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:34801 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758721AbXGXIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:20:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=3vama6rqTeCvdbFFOotS/qwywYCZqQD/s7xTo5iZtvG5e0VzPUq1s9fKaV4Tgu07qJ+AsXBgKp3iI8py8HsbAMs6jbsvV6Lv97Qbs0T7/GXur6MEI1v3pYcZcr+2PzPE0fHuI4CXpNf2N+hJpCMuOtwljI/2PyTx1nqlr3Nw2vs=  ;
X-YMail-OSG: ZUktGkkVM1kdGjeRkclaIMlk3JvqNjagjQGGnXBEVSw8RgZgYNsdZ_CB2pbglBGL.gNXb7hXJQ--
Message-ID: <46A5B652.3050304@yahoo.com.au>
Date: Tue, 24 Jul 2007 18:20:34 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in> <46A577AA.4020804@yahoo.com.au> <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Tue, 24 Jul 2007, Nick Piggin wrote:
> 
> 
>>Satyam Sharma wrote:
>>
>>>From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
>>>
>>>[8/8] i386: bitops: smp_mb__{before, after}_clear_bit() definitions
>>>
>>>
>>>>From Documentation/atomic_ops.txt, those archs that require explicit
>>>
>>>memory barriers around clear_bit() must also implement these two interfaces.
>>>However, for i386, clear_bit() is a strict, locked, atomic and
>>>un-reorderable operation and includes an implicit memory barrier already.
>>>
>>>But these two functions have been wrongly defined as "barrier()" which is
>>>a pointless _compiler optimization_ barrier, and only serves to make gcc
>>>not do legitimate optimizations that it could have otherwise done.
>>>
>>>So let's make these proper no-ops, because that's exactly what we require
>>>these to be on the i386 platform.
>>
>>No. clear_bit is not a compiler barrier on i386,
> 
> 
> Obvious.
> 
> 
>>thus smp_mb__before/after
>>must be.
> 
> 
> Not so obvious. Why do we require these to be a full compiler barrier
> is precisely the question I raised here.
> 
> Consider this (the above two functions exist only for clear_bit(),
> the atomic variant, as you already know), the _only_ memory reference
> we care about is that of the address of the passed bit-string:

No. Memory barriers explicitly extend to all memory references.


> (1) The compiler must not optimize / elid it (i.e. we need to disallow
>     compiler optimization for that reference) -- but we've already taken
>     care of that with the __asm__ __volatile__ and the constraints on
>     the memory "addr" operand there, and,
> (2) For the i386, it also includes an implicit memory (CPU) barrier
>     already.

Repeating what has been said before: A CPU memory barrier is not a
compiler barrier or vice versa. Seeing as we are talking about
the compiler barrier, it is irrelevant as to whether or not the
assembly includes a CPU barrier.


> So I /think/ it makes sense to let the compiler optimize _other_ memory
> references across the call to clear_bit(). There's a difference. I think
> we'd be safe even if we do this, because the synchronization in callers
> must be based upon the _passed bit-string_, otherwise _they_ are the
> ones who're buggy.

Yes it makes sense to let the compiler move memory operations over
clear_bit(), because we have defined the interface to be nice and
relaxed. And this is exactly why we do need to have an additional
barrier there in smp_mb__*_clear_bit().


> [ For those interested, I've been looking at the code generated
>   for the test kernel I built with these patches, and I don't
>   really see anything gcc did that it shouldn't have -- but ok,
>   that doesn't mean other versions/toolchains for other setups
>   won't. Also, the test box has been up all night, but I'm only
>   running Firefox on it anyway, and don't really know how to
>   verify if I've introduced any correctness issues / bugs. ]

correct output != correct input.

Without a barrier there, we _allow_ the compiler to reorder. If it
does not reorder, the missing barrier is still a bug :)

-- 
SUSE Labs, Novell Inc.
