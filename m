Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZBVTin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZBVTin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZBVTif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:38:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbZBVTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:38:34 -0500
Date: Sun, 22 Feb 2009 20:38:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com
Subject: Re: [PATCHSET x86/core/percpu] implement dynamic percpu allocator
Message-ID: <20090222193817.GC21320@elte.hu>
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499CA834.4080208@kernel.org> <20090219110718.GK2354@elte.hu> <499E20BC.4020408@kernel.org> <20090220093234.GF24555@elte.hu> <499FA8D1.8030806@kernel.org> <499FAE55.8070801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499FAE55.8070801@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Tejun Heo wrote:
> > I can remove the TLB problem from non-NUMA case but for NUMA I still
> > don't have a good idea.  Maybe we need to accept the overhead for
> > NUMA?  I don't know.
> 
> Hmmmm... one thing we can do on NUMA is to remap and free the 
> remapped address and make __pa() and __va() handle that area 
> specially.  It's a bit convoluted but the added overhead 
> should be minimal.  It'll only be simple range check in 
> __pa()/__va() and it's not like they are super hot paths 
> anyway.  I'll give it a shot.

Heck no. It is absolutely crazy to complicate __pa()/__va() in 
_any_ way just to 'save' one more 2MB dTLB.

We'll use that TLB because that is what TLBs are for: to handle 
mapped pages. Yes, in the percpu scheme we are working on we'll 
have a 'dual' mapping for the static percpu area (on 64-bit) but 
mapping aliases have been one of the most basic CPU features for 
the past 15 years ...

Even a single NOP in the __pa()/__va() path is _more_ expensive 
than that TLB, believe me.

Look at last year's cheap quad CPU:

 Data TLB: 4MB pages, 4-way associative, 32 entries

That's 32x2MB = 64MB of data reach. Our access patterns in the 
kernel tend to be pretty focused as well, so 32 is more than 
enough in practice.

Especially if the pte is cached a TLB fill is very cheap on 
Intel CPUs. So even if we were trashing those 32 entries (which 
we are generally not), having a dTLB for the percpu area is a 
TLB entry well spent.

So lets just do the most simple and most straightforward mapping 
approach which i suggested: it takes advantage of everything, is 
very close to the best possible performance in the cached case - 
and dont worry about hardware resources.

The moment you start worrying about hardware resources on that 
level and start 'optimizing' it in software, you've already lost 
it. It leads down to the path of soft-TLB handlers and other 
sillyness. There's no way you can win such a race against 
hardware fundamentals - at least at today's speed of advance in 
the hw space.

	Ingo
