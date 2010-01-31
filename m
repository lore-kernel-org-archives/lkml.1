Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270Ab0AaBBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0AaBBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 20:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080Ab0AaBBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 20:01:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:54416 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0AaBA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 20:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uIkOiuVrcwAQUwy8TQoMtEF3vRjsCYLzE0C13bOotnZbJzGaUdkQdacuhtLfpDz57i
         QreGUOg4kzyIT+hhZTb+GjkuicoA1QXUA78iP2LhpKN0lb3s7JE6Zgqq774Vq/386cK7
         V36u5xRUBIi7mFUlQ8JK+2Y9y5cbOxYhQO2H0=
Date: Sun, 31 Jan 2010 02:00:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: prasad@linux.vnet.ibm.com, shaggy@linux.vnet.ibm.com,
       linuxppc-dev@ozlabs.org, David Gibson <dwg@au1.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC:PATCH 00/03] powerpc: Expose BookE debug registers
	through extended ptrace interface
Message-ID: <20100131010054.GM5675@nowhere>
References: <20100124191830.GB14075@in.ibm.com> <1264365121.3601.43.camel@pasglop> <20100130204409.GE5675@nowhere> <1264887205.8287.5.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264887205.8287.5.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 08:33:25AM +1100, Benjamin Herrenschmidt wrote:
> 
> > We have one field for addr, one for len and one for the memory access
> > type.
> > 
> > I think that those three are enough to express breakpoint ranges.
> > Basically a breakpoint range is a breakpoint that can have a high
> > len.
> > 
> > I've looked at the G2 PowerPc core breakpoint implementation, just to
> > face one of such tricky examples.
> 
> BookE has a richer semantic. We have watchpoints with data value compare
> for example, we also have instruction value compare for breakpoints, and
> a few other niceties. There's also subtle differences between what
> processor variants support.
> 
>  .../...



Ah indeed, I missed the data value compare thing. Especially how
it is implemented won't make things easy.

This is basically a comparison against chosen bytes of the data,
with or/and patterns.

Not sure what the "or" can be useful for.

That won't be easy to implement in the generic interface, looking
at how it is done in the BookE.

There is also the address comparison by mask.

Anyway, I think we can add fields in the interface to provide
such features, but we can't support all of them given, as you
said, the subtle differences between different cpu.

For example I think it can be useful to implement support
for data comparison, by mask for example. But I don't imagine
useful usecases to compare byte 4 and byte1 and trigger an event
if one OR other match.

I think we are going to implement what has obvious usecases
(parts of such data comparisons, parts of address mask
comparison) in the generic interface: the fields in perf_attr
that can be filled by perf in userspace.
And the rest can be implemented from the hw_perf_event structure
which contains the arch structure and can then be filled by ptrace at
will.


> 
> > > I'd rather have this more dedicated and more complete interface merged
> > > for gdb's sake, and in a second step look at unifying.
> > 
> > 
> > Perhaps. Supporting ptrace breakpoints should be an easy first
> > step as it's basically the responsibility of the user to fill
> > the registers, but it's a pretty limited scope work, especially you
> > won't have perf support.
> 
> But we can add it later. 



Yeah you're right. Having a raw ptrace support is a first
useful step that won't be a barrier to enhance it further
through the generic API.


> > > I believe that the generic breakpoint infrastructure should not be the
> > > mid-layer. IE. It cannot be made in any clean shape of form, to express
> > > all of the subtle features that a given architecture or platform can
> > > support and as such would always be inferior to a dedicated one.
> > 
> > 
> > Actually I think the current interface already does, as I explained
> > above.
> > 
> > What is broken for any other architectures than x86 is the set
> > of constraints, but I can easily move it to the arch, unless
> > I find a good generic solution (or a cool combination between
> > both).
> 
> Again, this is all "can do" vs. "already done and working". May I point
> you to Linus recent rant against magic infrastructures that try to do
> everything and do nothing right ? :-) I much prefer starting with
> something dedicated that does exactly what is expected, have that
> upstream (and in that regard the patches are good for the next merge
> window) and -then- maybe look at how some of it could be re-used for
> perf.


Sure I'm not against a first raw ptrace support. As I said,
this is not a barrier for what comes next.

Now for the rest, I don't think this is the same story than
utrace.

Trying to have a generic layer for a hardware feature implemented
differently across archs can't be called something that tries to do
everything. Otherwise you can oppose these arguments to everything
that is not in the arch/ directories. No generic irq layer, no
generic timer, etc...

We need this generic layer because we want the breakpoints
to be available for wider uses than ptrace. If there was only
ptrace, I would really agree with you that it's not worth the
generic layer.

It's just that breakpoints are a set of possible features, but each
archs implement its own subset among the possible features. x86
is one of the weakest there, and since this generic layer has been
first x86 oriented, it looks too weak to host the most interesting
possibilities.

Let it grow a bit, it's still young.


> > Not at all. It's an attempt to make a generic interface that can
> > exploit at best _each_ arch specific features. 
> 
> That reminds me of the justifications for utrace :-) It might well be
> but I very much doubt that is possible. In any case, it doesn't appear
> to be there yet.


You are too pessimistic ;-)

I don't think we can express every possibilities through the generic
interface. But we can express the most interesting ones for profiling
uses.

The rest (ptrace) can still be expressed through the arch part of the perf
events.


> So let's just get that stuff in so we have our
> interface finally working, and we can look at doing fancy things with
> perf in a second pass.


Sure.

