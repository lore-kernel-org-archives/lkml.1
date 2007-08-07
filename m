Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbXHGWLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbXHGWLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937468AbXHGWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:02:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937940AbXHGWCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:02:21 -0400
Message-ID: <46B8EBD8.9080101@redhat.com>
Date: Tue, 07 Aug 2007 18:02:00 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com> <46B8E1D3.8050501@redhat.com> <46B8E64E.7010708@nortel.com>
In-Reply-To: <46B8E64E.7010708@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Chris Snook wrote:
> 
>> That's why we define atomic_read like so:
>>
>> #define atomic_read(v)          ((v)->counter)
>>
>> This avoids the aliasing problem, because the compiler must 
>> de-reference the pointer every time, which requires a memory fetch.
> 
> Can you guarantee that the pointer dereference cannot be optimised away 
> on any architecture?  Without other restrictions, a suficiently 
> intelligent optimiser could notice that the address of v doesn't change 
> in the loop and the destination is never written within the loop, so the 
> read could be hoisted out of the loop.

That would be a compiler bug.

> Even now, powerpc (as an example) defines atomic_t as:
> 
> typedef struct { volatile int counter; } atomic_t
> 
> 
> That volatile is there precisely to force the compiler to dereference it 
> every single time.

On most superscalar architectures, including powerpc, multiple instructions can 
be in flight simultaneously, potentially even reading and writing the same data. 
  When the compiler detects data dependencies within a thread of execution, it 
will do the right thing.  Putting the volatile keyword in here instructs the 
compiler to serialize accesses to this data even if it does not detect dependencies.

It's worth noting that all of the SMP architectures which lack the volatile 
keyword in their atomic_t definition inherit memory access semantics from ISAs 
that predate the advent of heavily-pipelined superscalar design.  i386 and 
x86_64 get theirs from at least as far back as the 8086.  I believe s390(x) 
inherits this from the s/370 ISA.  These ISAs assume strictly serialized memory 
access, and anything binary-compatible with them must enforce this in hardware, 
even at the expense of performance.  Modern ISAs that lack legacy baggage do 
away with this guarantee, putting the burden on the compiler to enforce 
serialization.  When the compiler can't detect that it's needed, we use volatile 
to inform it explicitly.

	-- Chris
