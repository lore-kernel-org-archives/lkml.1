Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZBXMwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZBXMwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZBXMv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:51:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZBXMv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:51:57 -0500
Date: Tue, 24 Feb 2009 13:51:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk
	allocation
Message-ID: <20090224125132.GB31295@elte.hu>
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3DE76.5010606@kernel.org>
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

> > - We'd have a very 'compressed' pte presence in the pagetables: 
> >   the dynamic percpu area is as tightly packed as possible. With 
> >   a chunked design we 'scatter' the ptes a bit more broadly.
> 
> Can you please elaborate a bit?

Sure. We want to compress data usage on every level of caching. 

Part of that is to compress the ptes themselves, as they are 
laid out in the pagetables. With your current small-chunks setup 
we get this address space layout:

    u1 .... [hole] ... u2 .. [hole] .... u3 ... [hole]

Where the 'hole' is the units belonging to other CPUs - but this 
CPU is largely uninterested in it. These 'holes' are the larger 
the more CPUs there are in the system.

A 'hole' there means that we have a number of ptes that are 
unused in that CPU. That is bad in several ways:

 - those ptes will still be cached in the CPU - just not used 
   for anything by that CPU. So the cache utilization ratio for 
   those ptes will be very low.

 - a modern x86 CPU's TLB walker will prefetch into nearby 
   present ptes quite agressively, based on access patterns it 
   detects. Having a lot of 'other CPU' ptes present will fool 
   this CPU into prefetching them, if there's nearby usage. 
   Those TLB entries are lost and they can create pressure on 
   and eliminate useful TLB entries as well.

 - as the number of CPUs increases in the system, the worse this 
   situation gets. So up until a certain limit (when the hole
   becomes so large that the CPU does not speculate to any 
   additional level into it) this effects gets worse gradually.

So what i'm saying is that these are strong reasons for us to 
want to make the unit size to be something like 2MB - on 64-bit 
x86 at least.

( Using a 2MB unit size will also have another advantage: _iff_ 
  we can still allocate a hugepage at that point we can map it 
  straight there when extending the dynamic area. )

	Ingo
