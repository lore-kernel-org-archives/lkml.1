Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbYAJTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbYAJTbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYAJTbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:31:11 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36006 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751741AbYAJTbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:31:09 -0500
Date: Thu, 10 Jan 2008 11:31:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
In-Reply-To: <1199993032.5331.155.camel@cinder.waste.org>
Message-ID: <Pine.LNX.4.64.0801101127220.20353@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> 
 <1199419890.4608.77.camel@cinder.waste.org>  <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
  <1199641910.8215.28.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> 
 <1199906151.6245.57.camel@cinder.waste.org>  <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI>
  <1199919548.6245.74.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> 
 <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> 
 <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> 
 <1199987366.5331.92.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801101112350.20353@schroedinger.engr.sgi.com>
 <1199993032.5331.155.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Matt Mackall wrote:

> > I agree. Crap too. We removed the destructors. The constructors are needed 
> > so that objects in slab pages always have a definite state. That is f.e.
> > necessary for slab defragmentation because it has to be able to inspect an 
> > object at an arbitrary time and either remove it or move it to another 
> > slab page.
> 
> Are you saying that the state of -freed- objects matters for your active
> defragmentation? That's odd.

The state of the object immediately after it is allocated matters for a 
defrag solution. A kmalloc leads to an object in a undetermined state if 
you have no constructor. Code will then initialize the object but defrag 
f.e. must be able to inspect the object before. This means either that the 
freed object has a defined state or that kmalloc establishes that state 
before the object is marked as allocated.

> > Constructors also make sense because the initialization of a cache object 
> > may be expensive. Initializing list heads and spinlocks can take some code 
> > and that code can be omitted if objects have a definite state when they 
> > are free. We saw that when measuring the buffer_head constructors effect 
> > on performance.
> 
> Hmm. SLOB proves that you don't need to segregate objects based on
> constructors, so you could combine even slabs that have constructors and
> just delay construction until allocation. I'm surprised constructors
> have measurable advantage..

That is not working if you need to inspect allocated objects at any time 
for a defrag solution. All objects in a defragmentable slab need to have a 
consistent object state if allocated. If you have some without 
constructors then these object have no defined state and may contain 
arbitrary bytes.

