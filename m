Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZB1S2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZB1S2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZB1S21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:28:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZB1S20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:28:26 -0500
Date: Sat, 28 Feb 2009 19:27:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228182759.GA28865@elte.hu>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu> <200902282249.57479.nickpiggin@yahoo.com.au> <20090228125816.GA14917@elte.hu> <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 28 Feb 2009, Arjan van de Ven wrote:
> > 
> > it invalidates all caches in the hierarchy
> 
> Yeah, now that I look at the intel pdf's, I see that.
> 
> > afaik this is what Intel cpus do; but I also thought this 
> > behavior was quite architectural as well...
> 
> Ok, I really think we should definitely not use non-temporal 
> stores for anything smaller than one full page in that case. 
> In fact, I wonder if even any of the old streaming benchmarks 
> are even true. I thought it would still stay in the L3, but 
> yes, it literally seems to make the access totally noncached 
> and WC.
> 
> That's almost unacceptable in the long run. With a 8MB L3 
> cache - and a compile sequence, do we really want to go out to 
> memory to write the .S file, and then have the assembler go 
> out to memory to read it back? For a compile, that _probably_ 
> is all fine (the compiler in particular will have enough data 
> structures around that it's not going to fit in the cache 
> anyway), but I'm seeing leaner compilers and other cases where 
> forcing things out all the way on the bus is simply the wrong 
> thing.

with the 'total' cutoff we could cut off at a higher place, say 
64K. But that would be rather arbitrary, not backed up by real 
numbers.

OTOH, given how draconian non-temporal stores are, i'm leaning 
towards removing them from the x86 code altogether. If it matter 
to performance somewhere it can be reintroduced, based on really 
well backed up numbers.

	Ingo
