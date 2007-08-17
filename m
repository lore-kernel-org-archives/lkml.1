Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbXHQEkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbXHQEkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXHQEkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:40:21 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:41942 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752507AbXHQEkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:40:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=p0zYyS50i2Ugmbs57/HCHX3owp+qoXtZxXwFM2SRVGJ9s5GQpInmZtFAZc6fdec1en7sAMCU9+4tUCJMQNF+1p9zGDW0xoURXv6jKXRN+p9ClSP8ccU2q4tJHk2Ld6RONx9RZ/bPWzQRAXDIQPFRTjemJrvq4RlPbrLc1J0NyzY=  ;
X-YMail-OSG: LHVdd_4VM1kwodVCBp_ANE9AIB3vM6RaPvYqc.CTsAI99cKTjSBoy5xy1BKMD8UHBbadd_OZZg--
Message-ID: <46C52681.20409@yahoo.com.au>
Date: Fri, 17 Aug 2007 14:39:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: paulmck@linux.vnet.ibm.com, Herbert Xu <herbert@gondor.apana.org.au>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Satyam Sharma <satyam@infradead.org>,
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
References: <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in>	<18115.52863.638655.658466@cargo.ozlabs.ibm.com>	<20070816053945.GB32442@gondor.apana.org.au>	<18115.62741.807704.969977@cargo.ozlabs.ibm.com>	<20070816070907.GA964@gondor.apana.org.au>	<46C40587.7050708@s5r6.in-berlin.de>	<20070816081049.GA1431@gondor.apana.org.au>	<46C41EE4.9090806@s5r6.in-berlin.de>	<46C42767.4070104@s5r6.in-berlin.de>	<20070816104250.GB2927@gondor.apana.org.au>	<20070816163441.GB16957@linux.vnet.ibm.com>	<46C512EB.7020603@yahoo.com.au> <18117.7611.660070.879392@cargo.ozlabs.ibm.com>
In-Reply-To: <18117.7611.660070.879392@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Nick Piggin writes:
> 
> 
>>Why are people making these undocumented and just plain false
>>assumptions about atomic_t?
> 
> 
> Well, it has only been false since December 2006.  Prior to that
> atomics *were* volatile on all platforms.

Hmm, although I don't think it has ever been guaranteed by the
API documentation (concede documentation is often not treated
as the authoritative source here, but for atomic it is actually
very good and obviously indispensable as the memory ordering
reference).


>>If they're using lockless code (ie.
>>which they must be if using atomics), then they actually need to be
>>thinking much harder about memory ordering issues.
> 
> 
> Indeed.  I believe that most uses of atomic_read other than in polling
> loops or debug printk statements are actually racy.  In some cases the
> race doesn't seem to matter, but I'm sure there are cases where it
> does.
> 
> 
>>If that is too
>>much for them, then they can just use locks.
> 
> 
> Why use locks when you can just sprinkle magic fix-the-races dust (aka
> atomic_t) over your code? :) :)

I agree with your skepticism of a lot of lockless code. But I think
a lot of the more subtle race problems will not be fixed with volatile.
The big, dumb infinite loop bugs would be fixed, but they're pretty
trivial to debug and even audit for.


>>>Precisely.  And volatility is a key property of "atomic".  Let's please
>>>not throw it away.
>>
>>It isn't, though (at least not since i386 and x86-64 don't have it).
> 
> 
> Conceptually it is, because atomic_t is specifically for variables
> which are liable to be modified by other CPUs, and volatile _means_
> "liable to be changed by mechanisms outside the knowledge of the
> compiler".

Usually that is the case, yes. But also most of the time we don't
care that it has been changed and don't mind it being reordered or
eliminated.

One of the only places we really care about that at all is for
variables that are modified by the *same* CPU.


>>_Adding_ it is trivial, and can be done any time. Throwing it away
>>(ie. making the API weaker) is _hard_. So let's not add it without
> 
> 
> Well, in one sense it's not that hard - Linus did it just 8 months ago
> in commit f9e9dcb3. :)

Well it would have been harder if the documentation also guaranteed
that atomic_read/atomic_set was ordered. Or it would have been harder
for _me_ to make such a change, anyway ;)


>>really good reasons. It most definitely results in worse code
>>generation in practice.
> 
> 
> 0.0008% increase in kernel text size on powerpc according to my
> measurement. :)

I don't think you're making a bad choice by keeping it volatile on
powerpc and waiting for others to shake out more of the bugs. You
get to fix everybody else's memory ordering bugs :)


>>I don't know why people would assume volatile of atomics. AFAIK, most
> 
> 
> By making something an atomic_t you're saying "other CPUs are going to
> be modifying this, so treat it specially".  It's reasonable to assume
> that special treatment extends to reading and setting it.

But I don't actually know what that "special treatment" is. Well
actually, I do know that operations will never result in a partial
modification being exposed. I also know that the operators that
do not modify and return are not guaranteed to have any sort of
ordering constraints.

-- 
SUSE Labs, Novell Inc.
