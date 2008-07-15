Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYGOUYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYGOUYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYGOUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:24:27 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57303 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbYGOUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:24:26 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080715200718.GC4280@redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain>
	 <y0mr69vj5p0.fsf@ton.toronto.redhat.com>
	 <1216151526.3312.102.camel@localhost.localdomain>
	 <20080715200718.GC4280@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 15:24:22 -0500
Message-Id: <1216153462.3312.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 16:07 -0400, Frank Ch. Eigler wrote:
> On Tue, Jul 15, 2008 at 02:52:06PM -0500, James Bottomley wrote:
> 
> > [...]
> > > > One of the big nasties of systemtap is the way it tries to embed
> > > > virtually the entirety of the kernel symbol table in the probe
> > > > modules it constructs.
> > > 
> > > It is a compromise of conflicting requirements. 
> > 
> > Well ... in order to make forward progress, since the systemtap people
> > expressed a desire to be better integrated with the kernel, the first
> > order of business is to use the correct APIs [...]
> 
> Let's concentrate then on those areas where this is more clear-cut.

This is the most clear cut of the areas.  Until the systemtap modules
get moved to the proper APIs, it's very difficult to tell what else
needs to be cleaned up or changed inside the kernel to support them.

> > > > This is highly undesirable because it represents a subversion of the
> > > > kernel API to gain access to unexported symbols.
> > > 
> > > Please elaborate.  Does the translator or its runtime use unexported
> > > symbols?  (That would arouse the question about why.)
> > > 
> > > Or are you talking about being able to *probe* unexported functions or
> > > access unexported data?  That would be a deliberate feature.
> > 
> > No ... I'm talking about _stp_module_relocate() at this point.  It's an
> > unnecessary function
> 
> Maybe, but what "subversion" are you talking about?

using a hand crafted relocation function to gain access to kernel
symbols instead of the provided API.  Even if it's not used as a
template for every producer of binary modules, it's just incredibly
fragile.

> > since the kprobes API provides a way to attach to a symbol and an
> > offset.  The API allows access to unexported functions.
> 
> ... but not to e.g. data, which also uses this common mechanism.

That was number three in the original list of problems on my email.  I
think it's solvable reasonably easily (as I outlined).

> > > > At least for kprobes, the correct way to do this is to specify the
> > > > probe point by symbol and offset.
> > > 
> > > But there won't be just kprobes.  Much of this code was built with
> > > anticipation of user-space probing, and there the kernel won't have a
> > > similar mechanism.  Similarly, the code is written to work with old
> > > kernels too - ones that predate the symbol+offset kprobe API.
> > 
> > OK ... you've got me there ... why would user space probing necessitate
> > resolution of kernel space symbols?  Surely you plan to use an exported
> > module API of utrace or whatever the agreed framework is?
> 
> Of course, but for our purposes, the kernel will be just one amongst
> many probing targets.  We will be tracking multiple symbol tables and
> unwind data for user-space.

You're going to hand roll your own symbol resolution for user space too?
Isn't it pretty easy simply to get ld.so to do that for you?

> > > Unless someone is about to rip out pure address-based kprobes, I see
> > > no reason to complicate the code.
> > 
> > If you actually look, you'll see that pure addressed based kprobes still
> > work.
> 
> No need for the snark.  I know they work; we've been using them for
> years.  I am simply happy to stay with them.

I meant if you read the patch I posted, I made sure that pure addressed
based kprobes still work even when they have to use the
symbol_name/offset resolution method ... the new code just works out the
closest symbol and applies an offset.

> > Also, I think you'll find it simplifies the code, since tons of the
> > runtime junk that duplicate the in-kernel symbol resolution can be
> > thrown out, plus the corresponding pieces of systemtap that have to
> > worry about this.
> 
> Again, please consider user-space.  The runtime will need similar
> symbol resolution code *for user space* anyway.  Keeping it in there
> for the kernel is no incremental complexity - if anything, the
> opposite.

I really think there might have to be separate runtime pieces for user
space and for the kernel.  Trying to build a single scheme that works in
both places looks cumbersome.  In the separate case, the kernel piece,
which is potentially movable inside the kernel, becomes a lot simpler.

> > There's also the architectural worry: this scheme you currently use
> > is very fragile.  For instance, I don't see it surviving a move to
> > -ffunction-sections (which patches are already going over
> > linux-arch).
> 
> Let's try it.  Whatever actual problems that throws up, we'd also
> encounter with userspace.

OK, with -ffunction-sections you can't offset from _stext which seems to
be what _stp_module_relocate() uses.  The reason this gets used on
something like parisc is so that we can place jump stubs in between the
function sections if necessary to widen the PCREL17 relocations.  That
means that each function address can potentially move depending on the
number of relocation stubs embedded between it and the next function.
The exact same problem occurs between DSOs in user space.  Your problem
is that you don't know the separations until someone attempts linking
(and even then, there's nothing except common sense that requires the
linker to use the minimum number of stubs).

Now, you could still offset from the start address of the section, but
that's simply the address of the function, so resolution by
symbol_name/offset is the effective solution.

James


