Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXHQDQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXHQDQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 23:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXHQDQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 23:16:11 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:33672 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751057AbXHQDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 23:16:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Ivp9JauPmV6a9vf6Vw4LH/p0Qfss9Q3ehyUW1+E3/bZujIPfNTxntRxuXsB98L8ge8HAXpHM6c5gMf/r8L+SYcCxQmKYP2PR4RLxR0/cCjz5khlkykftfn/Va0u1BnV75nqgT6B6wB747kcVL/OXJGTi3GHBfk6PQk7vGHTBqUA=  ;
X-YMail-OSG: DKgZ7qkVM1kWr4AjsTRW5ghCgQ9Z8b7NG5E6bt_8o.Y4ZPZBHRmWqujg4emacK2RR.Se1SYYIg--
Message-ID: <46C512EB.7020603@yahoo.com.au>
Date: Fri, 17 Aug 2007 13:15:55 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Paul Mackerras <paulus@samba.org>, Satyam Sharma <satyam@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in> <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au> <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au> <46C40587.7050708@s5r6.in-berlin.de> <20070816081049.GA1431@gondor.apana.org.au> <46C41EE4.9090806@s5r6.in-berlin.de> <46C42767.4070104@s5r6.in-berlin.de> <20070816104250.GB2927@gondor.apana.org.au> <20070816163441.GB16957@linux.vnet.ibm.com>
In-Reply-To: <20070816163441.GB16957@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Aug 16, 2007 at 06:42:50PM +0800, Herbert Xu wrote:

>>In fact, volatile doesn't guarantee that the memory gets
>>read anyway.  You might be reading some stale value out
>>of the cache.  Granted this doesn't happen on x86 but
>>when you're coding for the kernel you can't make such
>>assumptions.
>>
>>So the point here is that if you don't mind getting a stale
>>value from the CPU cache when doing an atomic_read, then
>>surely you won't mind getting a stale value from the compiler
>>"cache".
> 
> 
> Absolutely disagree.  An interrupt/NMI/SMI handler running on the CPU
> will see the same value (whether in cache or in store buffer) that
> the mainline code will see.  In this case, we don't care about CPU
> misordering, only about compiler misordering.  It is easy to see
> other uses that combine communication with handlers on the current
> CPU with communication among CPUs -- again, see prior messages in
> this thread.

I still don't agree with the underlying assumption that everybody
(or lots of kernel code) treats atomic accesses as volatile.

Nobody that does has managed to explain my logic problem either:
loads and stores to long and ptr have always been considered to be
atomic, test_bit is atomic; so why are another special subclass of
atomic loads and stores? (and yes, it is perfectly legitimate to
want a non-volatile read for a data type that you also want to do
atomic RMW operations on)

Why are people making these undocumented and just plain false
assumptions about atomic_t? If they're using lockless code (ie.
which they must be if using atomics), then they actually need to be
thinking much harder about memory ordering issues. If that is too
much for them, then they can just use locks.


>>>So, the architecture guys can implement atomic_read however they want
>>>--- as long as it cannot be optimized away.*
>>
>>They can implement it however they want as long as it stays
>>atomic.
> 
> 
> Precisely.  And volatility is a key property of "atomic".  Let's please
> not throw it away.

It isn't, though (at least not since i386 and x86-64 don't have it).
_Adding_ it is trivial, and can be done any time. Throwing it away
(ie. making the API weaker) is _hard_. So let's not add it without
really good reasons. It most definitely results in worse code
generation in practice.

I don't know why people would assume volatile of atomics. AFAIK, most
of the documentation is pretty clear that all the atomic stuff can be
reordered etc. except for those that modify and return a value.

It isn't even intuitive: `*lp = value` is like the most fundamental
atomic operation in Linux.

-- 
SUSE Labs, Novell Inc.
