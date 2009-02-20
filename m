Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZBTOE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZBTOE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZBTOEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:04:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZBTOET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:04:19 -0500
Date: Fri, 20 Feb 2009 11:04:03 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rfd] function-graph augmentation
Message-ID: <20090220140403.GC16897@ghostprotocols.net>
References: <1235077304.4612.662.camel@laptop> <20090219212807.GA5084@nowhere> <20090220085627.GE24555@elte.hu> <20090220133011.GB16897@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220133011.GB16897@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 20, 2009 at 10:30:11AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Feb 20, 2009 at 09:56:27AM +0100, Ingo Molnar escreveu:
> > 2)
> > 
> > Another, entirely different, and i think complementary approach, 
> > which exciting new possibilities would be to (also) 
> > automatically pick up arguments from the stack, on function 
> > entry.
> > 
> > If there's a (read-mostly, lockless-to-read and scalable) 
> > function attributes hash, then we could encode the parameters 
> > signature of functions (or at least, of certain functions) in 
> > the attributes hash. Then the tracer will know how many 
> > arguments to pick up from the stack.
> > 
> > This approach has the advantage that we could reconstruct the 
> > parameters of _arbitrary_ functions, without having to touch 
> > those functions. We already enumerate all functions during build 
> > time, it would take some more dwarf2 magic to recover the 
> > call/parameter signature. Oh, and at that time we could also 
> > record the _return type_ - easing the return value.
> > 
> > Note that it does not take a full, bloated DEBUG_INFO build - we 
> > can build a -g object to get the dwarf2 data and then strip out 
> > the dwarf2 data.
> > 
> > Arnaldo, what do you think about this, how feasible would it be 
> > to put dwarf2 magic into scripts/recordmcount.pl?
> 
> /me reading scripts/recordmcount.pl...

So you want to:

1. build object with -g
2. just after it is built, get what we want from the DWARF sections,
   then strip it, stash what we collected
3. what we want is:
	- parameter names
	- _where_ each parameter is (DWARF location expressions)
	- type signature (CTF like stuff)
4. allow users to ask for parameters (all? just some?) for certain functions
   to be collected at function entry
5. at function entry check if parameters should be collected, go over
   each parameter DWARF location expression and collect the values,
   encoding them into the ring buffer
6. at cat /d/tracing/trace time pretty print the parameters collected,
   i.e. name=value-formatting-according-to-its-type

Ok, base types are easy, enums are easy, what about structs? forget
about them and just print the pointer? i.e.:

	_spin_lock(.lock=0xabcdef)

versus:

	_spin_lock(.lock={.raw_lock={.slock=0}})

All members should be collected? Just some? User decides?

- Arnaldo
