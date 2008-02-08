Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYBHNN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYBHNN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYBHNNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:13:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52153 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYBHNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:13:16 -0500
Date: Fri, 8 Feb 2008 14:48:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080208134823.GB6115@one.firstfloor.org>
References: <47AB79D4.2070605@gmail.com> <20080208115542.GD4745@one.firstfloor.org> <19f34abd0802080418o75969480v3286da7a83ebc178@mail.gmail.com> <20080208132032.GA6115@one.firstfloor.org> <19f34abd0802080459t4630c251q2a7cb3680e207e7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0802080459t4630c251q2a7cb3680e207e7a@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 01:59:57PM +0100, Vegard Nossum wrote:
> On 2/8/08, Andi Kleen <andi@firstfloor.org> wrote:
> > On Fri, Feb 08, 2008 at 01:18:37PM +0100, Vegard Nossum wrote:
> > > On 2/8/08, Andi Kleen <andi@firstfloor.org> wrote:
> > > > Your assumption that only the string instructions can take
> > > > multiple page faults seems a little dangerous too.
> > >
> > > Yes, this is true. I cannot guarantee that there are no other
> > > instructions that could access more than one memory location but only
> > > take one page fault. However, since the kernel does boot, we at least
> > > know that these instructions are not very frequently used. (If you
> > > know of any other instructions we might be missing, I'll be happy to
> > > know about it!)
> >
> > Pretty much all in the right circumstances.
> >
> > e.g. consider a segment reload in tracked memory.
> >
> > Also there are various instructions which do all kinds of complicated
> > things internally; like IRET or INT: often with many memory accesses.
> > Just page through a instruction manual and look at the pseudo code
> > describing what the various instructions do.
> 
> Yes, this is true. Then our task is to make sure that this memory is
> never allocated from tracked caches. We do have some changes in this
> area, for instance we never track task structs. Keep in mind that only
> slab objects are tracked currently, so things like stacks never catch
> page faults. I am not sure if this is exactly what you had in mind,
> but I don't know other kernel code very well enough to come up with
> perhaps more relevant examples :-)

Given that you don't seem to handle networking yet I wonder how
many cases you really tested so far.

> For now, I am simply assuming that we never load task segments, GDTs,
> LDTs, or paging structures from tracked memory (e.g. regular
> kmalloc()).

There's the stack for once too. And some others I'm probably
forgetting.

> currently with surprisingly little amounts of code.

You only need this for the size and to detect string instructions, right?
The address should be delivered with the page fault and the r/w status too.

I think for string instructions you could probably detect it with
a little state machine that detects multiple page faults on the same
instruction.

Or just prevent the compiler/the code from generating string instructions.
There should not be that many once you stop gcc from generating inline
string ops (-Os is probably enough for that) 

For size you could in theory use VT which has special support in the CPU
to help with parsing this, although that would limit it to modern CPUs
and would require quite some infrastructure.

> 
> But AFAIK the format for MMX and SSE is different from the "regular"
> instructions, and so I don't know how to parse them. But this is
> something we can look at later.

I'm pretty sure there are other special instructions that you will
eventually run into. Intel (and sometimes AMD) add new ones each CPU
generation :) Reimplementing instruction decoding on x86 is not
an easy job. Anyways if you really want to do it I would rather
recommend to use one of the existing codes like the x86-emulate
that is in KVM, but even that one is far from complete. Trying
to avoid it would probably better.

-Andi

