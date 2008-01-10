Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbYAJTZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbYAJTZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761021AbYAJTYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:24:53 -0500
Received: from waste.org ([66.93.16.53]:34327 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761000AbYAJTYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:24:51 -0500
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801101112350.20353@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
	 <1199906151.6245.57.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
	 <1199919548.6245.74.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI>
	 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org>
	 <1199987366.5331.92.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801101112350.20353@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 13:23:52 -0600
Message-Id: <1199993032.5331.155.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 11:16 -0800, Christoph Lameter wrote:
> On Thu, 10 Jan 2008, Matt Mackall wrote:
> 
> > Here I'm going to differ with you. The premises of the SLAB concept
> > (from the original paper) are: 
> > 
> > a) fragmentation of conventional allocators gets worse over time
> 
> Even fragmentation of SLAB/SLUB gets worses over time. That is why we need 
> a defrag solution.
> 
> > b) grouping objects of the same -type- (not size) together should mean
> > they have similar lifetimes and thereby keep fragmentation low
> 
> I agree that is crap. The lifetimes argument is mostly only exploitable in 
> benchmarks. That is why SLUB just groups them by size if possible.
> 
> > d) constructors and destructors are cache-friendly
> 
> I agree. Crap too. We removed the destructors. The constructors are needed 
> so that objects in slab pages always have a definite state. That is f.e.
> necessary for slab defragmentation because it has to be able to inspect an 
> object at an arbitrary time and either remove it or move it to another 
> slab page.

Are you saying that the state of -freed- objects matters for your active
defragmentation? That's odd.

> Constructors also make sense because the initialization of a cache object 
> may be expensive. Initializing list heads and spinlocks can take some code 
> and that code can be omitted if objects have a definite state when they 
> are free. We saw that when measuring the buffer_head constructors effect 
> on performance.

Hmm. SLOB proves that you don't need to segregate objects based on
constructors, so you could combine even slabs that have constructors and
just delay construction until allocation. I'm surprised constructors
have measurable advantage..

-- 
Mathematics is the supreme nostalgia of our time.

