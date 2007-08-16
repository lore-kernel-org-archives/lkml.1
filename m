Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXHPFi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXHPFi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXHPFiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:38:46 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4152 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbXHPFio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:38:44 -0400
Date: Thu, 16 Aug 2007 13:37:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <clameter@sgi.com>, Satyam Sharma <satyam@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070816053741.GA32442@gondor.apana.org.au>
References: <20070816011414.GC9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151839140.11520@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708160730590.24380@enigma.security.iitk.ac.in> <20070816020851.GA30809@gondor.apana.org.au> <Pine.LNX.4.64.0708151917210.11736@schroedinger.engr.sgi.com> <18115.49946.522011.832468@cargo.ozlabs.ibm.com> <20070816033343.GA31844@gondor.apana.org.au> <18115.51472.408193.332905@cargo.ozlabs.ibm.com> <20070816040308.GA32133@gondor.apana.org.au> <18115.54225.644905.463771@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18115.54225.644905.463771@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 02:34:25PM +1000, Paul Mackerras wrote:
>
> I'm talking about this situation:
> 
> CPU 0 comes into __sk_stream_mem_reclaim, reads memory_allocated, but
> then before it can do the store to *memory_pressure, CPUs 1-1023 all
> go through sk_stream_mem_schedule, collectively increase
> memory_allocated to more than sysctl_mem[2] and set *memory_pressure.
> Finally CPU 0 gets to do its store and it sets *memory_pressure back
> to 0, but by this stage memory_allocated is way larger than
> sysctl_mem[2].

It doesn't matter.  The memory pressure flag is an *advisory*
flag.  If we get it wrong the worst that'll happen is that we'd
waste some time doing work that'll be thrown away.

Please look at the places where it's used before jumping to
conclusions.

> Now, maybe it's the case that it doesn't really matter whether
> *->memory_pressure is 0 or 1.  But if so, why bother computing it at
> all?

As long as we get it right most of the time (and I think you
would agree that we do get it right most of the time), then
this flag has achieved its purpose.

> People seem to think that using atomic_t means they don't need to use
> a spinlock.  That's fine if there is only one variable involved, but
> as soon as there's more than one, there's the possibility of a race,
> whether or not you use atomic_t, and whether or not atomic_read has
> "volatile" behaviour.

In any case, this actually illustrates why the addition of
volatile is completely pointless.  Even if this code was
broken, which it definitely is not, having the volatile
there wouldn't have helped at all.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
