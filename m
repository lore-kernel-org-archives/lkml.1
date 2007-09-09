Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXIISDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXIISDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbXIISDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:03:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:9626 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbXIISDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jartHjNsp8ZXq9zOe9rqbQDNIIVFMRkLp8pDIbgDq+dSJPkdaD02fHvh4wJrmwQgpT5gzXP7mngrbqZoQLXzEpnf6hhtLsxHQgIj8eAONX41k3nJcw/epzvSLkxYTWMG4sfZQAoZn2gZv+lXtyIv2y1w606hgsHvfmVzgQQJRmw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Sun, 9 Sep 2007 19:02:54 +0100
User-Agent: KMail/1.9.1
Cc: Nick Piggin <piggin@cyberone.com.au>, Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <46C59717.4020108@cyberone.com.au> <alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709091902.55388.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007 17:48, Linus Torvalds wrote:
> 
> On Fri, 17 Aug 2007, Nick Piggin wrote:
> > 
> > That's not obviously just taste to me. Not when the primitive has many
> > (perhaps, the majority) of uses that do not require said barriers. And
> > this is not solely about the code generation (which, as Paul says, is
> > relatively minor even on x86). I prefer people to think explicitly
> > about barriers in their lockless code.
> 
> Indeed.
> 
> I think the important issues are:
> 
>  - "volatile" itself is simply a badly/weakly defined issue. The semantics 
>    of it as far as the compiler is concerned are really not very good, and 
>    in practice tends to boil down to "I will generate so bad code that 
>    nobody can accuse me of optimizing anything away".
> 
>  - "volatile" - regardless of how well or badly defined it is - is purely 
>    a compiler thing. It has absolutely no meaning for the CPU itself, so 
>    it at no point implies any CPU barriers. As a result, even if the 
>    compiler generates crap code and doesn't re-order anything, there's 
>    nothing that says what the CPU will do.
> 
>  - in other words, the *only* possible meaning for "volatile" is a purely 
>    single-CPU meaning. And if you only have a single CPU involved in the 
>    process, the "volatile" is by definition pointless (because even 
>    without a volatile, the compiler is required to make the C code appear 
>    consistent as far as a single CPU is concerned).
> 
> So, let's take the example *buggy* code where we use "volatile" to wait 
> for other CPU's:
> 
> 	atomic_set(&var, 0);
> 	while (!atomic_read(&var))
> 		/* nothing */;
> 
> 
> which generates an endless loop if we don't have atomic_read() imply 
> volatile.
> 
> The point here is that it's buggy whether the volatile is there or not! 
> Exactly because the user expects multi-processing behaviour, but 
> "volatile" doesn't actually give any real guarantees about it. Another CPU 
> may have done:
> 
> 	external_ptr = kmalloc(..);
> 	/* Setup is now complete, inform the waiter */
> 	atomic_inc(&var);
> 
> but the fact is, since the other CPU isn't serialized in any way, the 
> "while-loop" (even in the presense of "volatile") doesn't actually work 
> right! Whatever the "atomic_read()" was waiting for may not have 
> completed, because we have no barriers!

Why is all this fixation on "volatile"? I don't think
people want "volatile" keyword per se, they want atomic_read(&x) to
_always_ compile into an memory-accessing instruction, not register access.
--
vda
