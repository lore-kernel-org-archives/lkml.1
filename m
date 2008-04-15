Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbYDOM4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbYDOM4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYDOM4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:56:39 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:57395 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYDOM4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:56:39 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080415123233.GA19797@Krystal>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415123233.GA19797@Krystal>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 14:56:30 +0200
Message-Id: <1208264190.6395.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 08:32 -0400, Mathieu Desnoyers wrote:
> * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:
> > 
> > > +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> > > +			"abs_time:%p bitset:%d",
> > > +			uaddr, fshared, val, abs_time, bitset);
> > 
> > This is some seriuosly ugly looking gunk, why would we want stuff like
> > that scattered across the code?
> > 
> 
> I don't really see how it differs so much from printks, which kernel
> developers are already familiar with.

Which never last longer than the debug session and are never exposed to
enterprise kABI crap.

> > What is wrong with a few simple hooks like:
> > 
> >   trace_futex_wait(uaddr, fshares, val, abs_time, bitset);
> > 
> > and then deal with that.
> > 
> 
> If any of your variable type changes, then you are exporting an unknown
> data structure to user-space. _That_ would break a userspace tracer
> whenever you change any of these kernel variables and you don't want
> that.

trace_futex_wait()'s signature would make the compiler issue a complaint
when the arguments suddenly changes type, no?

> Exporting the field names and variable types helps to identify the
> variables by their given names rather than their respective order.
> Having the field type insures binary compatibility.
> 
> Clearly we can turn your trace_futex_wait(uaddr, fshares, val, abs_time,
> bitset); into a trace_mark() with a simple define, and I don't see any
> problem with that. I just want to make sure the event name, field names
> and field types are exported, and this is done by markers. However, I
> wonder why none of the kernel printk() are turned into specialized
> defines to make the code "cleaner".. maybe it's because it is useful to
> have everything declared in one spot after all.

I must be missing something here, printks don't need to look pretty
because they never see the light of lkml. They get ripped out as soon as
I understand what the heck happened.

> > Also, you seem to expose way too much futex internals; do you really
> > need that? People will go use this marker crap like ABI and further
> > restrain us from changing the code.
> > 
> 
> Because we extract the field names and types, we can create tracer
> plugins that would hook on field names rather than expect a specific
> number of fields and fixed field types. It makes it possible to tolerate
> missing fields pretty easily. But yes, tracer tools might have to be
> adapted to internal kernel changes, since they must follow kernel
> structure changes. However, staying as close as possible to a canonical
> representation of event fields, staying far from the specific
> implemetation, would help to lessen the inter-dependency. On the other
> hand, it would probably hurt trace compactness and efficiency.

See, these tracer tools are my nightmare as member of an enterprise
linux team. They'll make an already hard job even harder, no thanks!

At least reduce the hooks to the very bare minimum; only log when the
mutex changes state; not this: we entered futex_wait; we exited with
state crap.

Just log:

  futex: <uaddr> wait
  futex: <uaddr> wakeup

And other fundamental events, the rest is just not needed.

