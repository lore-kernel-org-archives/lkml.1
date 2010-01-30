Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751Ab0A3UoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab0A3UoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907Ab0A3UoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:44:16 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:49181 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0A3UoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DRRWXIwGQU4TNRnZ55oKY/0Ilq5EM5zVZFhRgY9ZIuScTuOiWyxveU97hl1fwewcGk
         9+V+xuq0iDpvMJC5JWAs7XMqjyduOt6ScD0yP8tJUocsI/IJoR89xvSKGEpVGvoADWCb
         7qEkAo5NhdxVj4KDJAir421mJThrwQoFZgGeg=
Date: Sat, 30 Jan 2010 21:44:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: prasad@linux.vnet.ibm.com, shaggy@linux.vnet.ibm.com,
       linuxppc-dev@ozlabs.org, David Gibson <dwg@au1.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC:PATCH 00/03] powerpc: Expose BookE debug registers
	through extended ptrace interface
Message-ID: <20100130204409.GE5675@nowhere>
References: <20100124191830.GB14075@in.ibm.com> <1264365121.3601.43.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264365121.3601.43.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 07:32:00AM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2010-01-25 at 00:48 +0530, K.Prasad wrote:
> > 
> > Some of the benefits of using these generic interfaces include:
> > - Interoperability with other users of debug register (such as
> > parallel
> >   kernel requests) i.e. non-exclusive use of debug registers.
> > - Enables debugging/tracing tools such as perf-events and ftrace to
> > make
> >   use of debug registers.
> > - Re-use of common code available in kernel (kernel/hw_breakpoint.c).
> > 
> > Let me know what you think.
> 
> This might have changed but last I looked the "generic" breakpoint
> interface was still too x86-centric and wasn't capable of expressing
> some of the features of the BookE debug register set such as the data
> value compare, the ranged breakpoints, etc...



We have one field for addr, one for len and one for the memory access
type.

I think that those three are enough to express breakpoint ranges.
Basically a breakpoint range is a breakpoint that can have a high
len.

I've looked at the G2 PowerPc core breakpoint implementation, just to
face one of such tricky examples.

We have DABR and DABR2 for watchpoint (and respectively IABR and IABR2
for ins breakpoints). Those host the addresses to target, or well,
let's rather call them "address operand" registers. To generalize, I
call these xABR and xABR2 as it seems instruction and data breakpoint
work the same, they just have their own dedicated registers.

Then you have DBCR/IBCR (let's call them xBCR) which control the
breakpoints, with two fields in each that detail the operators to affect
in the address operands registers. You can choose betwen ==, <, or >= .

Another field in the operator is the SIG_TYPE, which describes the
combination, either "matches xABR AND xABR2" or "matches xABR OR xABR2".

If you choose the "OR" SIG_TYPE, it makes no sense to use the < or >=
operators on the addresses operands in practice. Who needs the following
matches?

	addr < xABR || addr >= xABR2
	addr < xABR || addr < xABR2
	addr >= xABR || addr >= xABR2

The only operator that makes sense in a OR type is ==, which
basically provides you two breakpoints:

	addr == xABR || addr == xABR2

Now if you choose the "AND" SIG_TYPE, the following matches
make no sense:

	addr < xABR && addr < xABR2
	addr < xABR && addr >= xABR2 (if xABR < xABR2)
	addr == xABR && addr (>=,<) xABR2

Basically, it's only usable for delimited ranges:

	addr >= xABR && addr < xABR2 (xABR < xABR2)

So the comparison is a trick that can actually only have
a practical use to define two exact matching breakpoints
or a delimited breakpoint range.

Hence, unless I'm missing something obvious, the current
generic interface is sufficient to express that.

I may also miss other kind of implementation that could
have other requirements.

 
> I'd rather have this more dedicated and more complete interface merged
> for gdb's sake, and in a second step look at unifying.


Perhaps. Supporting ptrace breakpoints should be an easy first
step as it's basically the responsibility of the user to fill
the registers, but it's a pretty limited scope work, especially you
won't have perf support.


> I believe that the generic breakpoint infrastructure should not be the
> mid-layer. IE. It cannot be made in any clean shape of form, to express
> all of the subtle features that a given architecture or platform can
> support and as such would always be inferior to a dedicated one.


Actually I think the current interface already does, as I explained
above.

What is broken for any other architectures than x86 is the set
of constraints, but I can easily move it to the arch, unless
I find a good generic solution (or a cool combination between
both).



> I can see the interest in exposing some kind of generic API that
> implements a common subset of breakpoint or watchpoint facilities to
> generic code such as the event tracer. This could be layered on top of
> an arch specific mechanism
> 
> But having the generic mechanism at the core for everybody is another
> attempt of "make everybody look like x86" which I believe in this case
> is sub optimal.


Not at all. It's an attempt to make a generic interface that can
exploit at best _each_ arch specific features. Other than the set
of constraints that I'm going to rework, the generic interface is powerful
enough to host what I've seen in term of cpu breakpoints implementations
for now. But if it's actually not and I'm missing other cases, please
report it to me.

The reason that makes the current generic constraints x86
oriented only is that I've only x86 boxes at home and I needed
to make a first shot without knowing anything about other archs
constraints, but in the long term, our motivations (Prasad's and mines)
are definetely not archX-centric.

