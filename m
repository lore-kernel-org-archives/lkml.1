Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZCCJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZCCJDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZCCJDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:03:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZCCJDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:03:16 -0500
Date: Tue, 3 Mar 2009 10:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       sqazi@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090303090252.GC11484@elte.hu>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <200903020106.51865.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0903021255020.3111@localhost.localdomain> <200903031521.00217.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903031521.00217.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 03 March 2009 08:16:23 Linus Torvalds wrote:
> > On Mon, 2 Mar 2009, Nick Piggin wrote:
> > > I would expect any high performance CPU these days to combine entries
> > > in the store queue, even for normal store instructions (especially for
> > > linear memcpy patterns). Isn't this likely to be the case?
> >
> > None of this really matters.
> 
> Well that's just what I was replying to. Of course 
> nontemporal/uncached stores can't avoid cc operations either, 
> but somebody was hoping that they would avoid the 
> write-allocate / RMW behaviour. I just replied because I think 
> that modern CPUs can combine stores in their store queues to 
> get the same result for cacheable stores.
> 
> Of course it doesn't make it free especially if it is a cc 
> protocol that has to go on the interconnect anyway. But 
> avoiding the RAM read is a good thing anyway.

Hm, why do you assume that there is a RAM read? A sufficiently 
advanced x86 CPU will have good string moves with full cacheline 
transfers - removing partial cachelines and removing the need 
for the physical read.

The cacheline still has to be flushed/queried/transferred across 
the cc domain according to the cc protocol in use, to make sure 
there's no stale cached data elsewhere, but that is not a RAM 
read and in the common case (when the address is not present in 
any cache) it can be quite cheap.

The only cost is the dirty cacheline that is left around that 
increases the flush-out pressure on the cache. (the CPU might 
still be smart about this detail too so in practice a lot of 
write-allocates might not even cause that much trouble.)

	Ingo
