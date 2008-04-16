Return-Path: <linux-kernel-owner+w=401wt.eu-S1764952AbYDPPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764952AbYDPPvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758451AbYDPPva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:51:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:53638 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758297AbYDPPv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:51:29 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080415132512.GA22351@Krystal>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins>
	 <20080415132512.GA22351@Krystal>
Content-Type: text/plain; charset=utf-8
Date: Wed, 16 Apr 2008 17:51:24 +0200
Message-Id: <1208361084.6395.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 09:25 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Tue, 2008-04-15 at 08:32 -0400, Mathieu Desnoyers wrote:
> > > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > > On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> > > > 
> > > > > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > > > > +			"abs_time:%p bitset:%d",
> > > > > +			uaddr, fshared, val, abs_time, bitset);
> > > > 
> > > > This is some seriuosly ugly looking gunk, why would we want stuff like
> > > > that scattered across the code?
> > > > 
> > > 
> > > I don't really see how it differs so much from printks, which kernel
> > > developers are already familiar with.
> > 
> > Which never last longer than the debug session and are never exposed to
> > enterprise kABI crap.
> > 
> > > > What is wrong with a few simple hooks like:
> > > > 
> > > >   trace_futex_wait(uaddr, fshares, val, abs_time, bitset);
> > > > 
> > > > and then deal with that.
> > > > 
> > > 
> > > If any of your variable type changes, then you are exporting an unknown
> > > data structure to user-space. _That_ would break a userspace tracer
> > > whenever you change any of these kernel variables and you don't want
> > > that.
> > 
> > trace_futex_wait()'s signature would make the compiler issue a complaint
> > when the arguments suddenly changes type, no?
> > 
> 
> Yes, but then you would have to create new code for each event you want
> to trace. In the end, it would increase the icache footprint
> considerably and would also make addition of new events cumbersome.

Looking at patch 2/2 in this series that seems to be needed anyway. So
I'm not sure what adding all these character strings buy you.

> > > Exporting the field names and variable types helps to identify the
> > > variables by their given names rather than their respective order.
> > > Having the field type insures binary compatibility.
> > > 
> > > Clearly we can turn your trace_futex_wait(uaddr, fshares, val, abs_time,
> > > bitset); into a trace_mark() with a simple define, and I don't see any
> > > problem with that. I just want to make sure the event name, field names
> > > and field types are exported, and this is done by markers. However, I
> > > wonder why none of the kernel printk() are turned into specialized
> > > defines to make the code "cleaner".. maybe it's because it is useful to
> > > have everything declared in one spot after all.
> > 
> > I must be missing something here, printks don't need to look pretty
> > because they never see the light of lkml. They get ripped out as soon as
> > I understand what the heck happened.
> > 
> 
> The thing is that the trace_marks really fills two purpose : they
> extract information from the core kernel, which is meant to be shipped
> on production systems so tracing tools can report what is happening on
> the system and they also allow kernel hackers to add markers of their
> own, so they can extract information about specific events they are
> interested in along with the standard kernel instrumentation.
> 
> So, part of it is meant to be standard kernel information, part of it
> can be used for debugging. And since the kernel code evolves through
> time, it makes sense to have an infrastructure flexible enough to follow
> these changes easily.

The trouble I have with these free form thingies is that its too hard to
keep them consistent.

So we have this horrible printf syntax; but even worse:


> ﻿+       trace_mark(futex_wake_called, "uaddr:%p fshared:%p nr_wake:%d "
> +                       "bitset:%d",
> +                       uaddr, fshared, nr_wake, bitset);


> +       INIT_FUTEX_DEBUG_PROBE(futex_wake_called,
> +                       "uaddr:%p fshared:%p nr_wake:%d bitset:%d"),


Why the need to duplicate it; that's utter madness.

