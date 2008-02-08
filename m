Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYBHNAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYBHNAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYBHNAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:00:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:41809 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYBHM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aUYCLvvzg1kSsz6bM8DKKK8TrwJ7LqeXsqRxreMRPM9lb3t7DYUvIkSMgpqmhUFZyTThKGduvhAq31I6eFIWzJp7Dk8mxU7M2mecsU5TOVLmrGq4GYrajFoWUXCVVP7a0fah2JUoVvATyIb8Fg7EaI5b6wXFgTvtAPmCF76lzyY=
Message-ID: <19f34abd0802080459t4630c251q2a7cb3680e207e7a@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:59:57 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080208132032.GA6115@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <20080208115542.GD4745@one.firstfloor.org>
	 <19f34abd0802080418o75969480v3286da7a83ebc178@mail.gmail.com>
	 <20080208132032.GA6115@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/08, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Feb 08, 2008 at 01:18:37PM +0100, Vegard Nossum wrote:
> > On 2/8/08, Andi Kleen <andi@firstfloor.org> wrote:
> > > Your assumption that only the string instructions can take
> > > multiple page faults seems a little dangerous too.
> >
> > Yes, this is true. I cannot guarantee that there are no other
> > instructions that could access more than one memory location but only
> > take one page fault. However, since the kernel does boot, we at least
> > know that these instructions are not very frequently used. (If you
> > know of any other instructions we might be missing, I'll be happy to
> > know about it!)
>
> Pretty much all in the right circumstances.
>
> e.g. consider a segment reload in tracked memory.
>
> Also there are various instructions which do all kinds of complicated
> things internally; like IRET or INT: often with many memory accesses.
> Just page through a instruction manual and look at the pseudo code
> describing what the various instructions do.

Yes, this is true. Then our task is to make sure that this memory is
never allocated from tracked caches. We do have some changes in this
area, for instance we never track task structs. Keep in mind that only
slab objects are tracked currently, so things like stacks never catch
page faults. I am not sure if this is exactly what you had in mind,
but I don't know other kernel code very well enough to come up with
perhaps more relevant examples :-)

For now, I am simply assuming that we never load task segments, GDTs,
LDTs, or paging structures from tracked memory (e.g. regular
kmalloc()).

> > There is also the point that if kmemcheck doesn't handle all the
> > faulting addresses, it will simply fault again and again, without
> > making any progress. I mean, it won't go unnoticed for very long :-)
> >
> > This is also why we depend on M386 and !X86_GENERIC, to avoid those
> > MMX, etc. instructions, as we have no support for those currently
>
> I would not expect problems from MMX/SSE here (except for the generic
> ones all instructions have)

The problem with these instructions is not that they take page faults,
but that kmemcheck doesn't know how to handle them. Kmemcheck needs to
parse the instruction stream at EIP to determine what addresses were
accessed, their size, and the type (read or write). This can be done
currently with surprisingly little amounts of code.

But AFAIK the format for MMX and SSE is different from the "regular"
instructions, and so I don't know how to parse them. But this is
something we can look at later.


Vegard


PS: Thanks for telling me about how change_page_attr() was wrong in
kmemcheck v2. A lot of things were simply wrong in v2, but hopefully
they are better now :-)
