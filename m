Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbYGOUJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbYGOUJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYGOUIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:08:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbYGOUIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:08:51 -0400
Date: Tue, 15 Jul 2008 16:07:18 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080715200718.GC4280@redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain> <y0mr69vj5p0.fsf@ton.toronto.redhat.com> <1216151526.3312.102.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216151526.3312.102.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jul 15, 2008 at 02:52:06PM -0500, James Bottomley wrote:

> [...]
> > > One of the big nasties of systemtap is the way it tries to embed
> > > virtually the entirety of the kernel symbol table in the probe
> > > modules it constructs.
> > 
> > It is a compromise of conflicting requirements. 
> 
> Well ... in order to make forward progress, since the systemtap people
> expressed a desire to be better integrated with the kernel, the first
> order of business is to use the correct APIs [...]

Let's concentrate then on those areas where this is more clear-cut.


> > > This is highly undesirable because it represents a subversion of the
> > > kernel API to gain access to unexported symbols.
> > 
> > Please elaborate.  Does the translator or its runtime use unexported
> > symbols?  (That would arouse the question about why.)
> > 
> > Or are you talking about being able to *probe* unexported functions or
> > access unexported data?  That would be a deliberate feature.
> 
> No ... I'm talking about _stp_module_relocate() at this point.  It's an
> unnecessary function

Maybe, but what "subversion" are you talking about?

> since the kprobes API provides a way to attach to a symbol and an
> offset.  The API allows access to unexported functions.

... but not to e.g. data, which also uses this common mechanism.


> > > At least for kprobes, the correct way to do this is to specify the
> > > probe point by symbol and offset.
> > 
> > But there won't be just kprobes.  Much of this code was built with
> > anticipation of user-space probing, and there the kernel won't have a
> > similar mechanism.  Similarly, the code is written to work with old
> > kernels too - ones that predate the symbol+offset kprobe API.
> 
> OK ... you've got me there ... why would user space probing necessitate
> resolution of kernel space symbols?  Surely you plan to use an exported
> module API of utrace or whatever the agreed framework is?

Of course, but for our purposes, the kernel will be just one amongst
many probing targets.  We will be tracking multiple symbol tables and
unwind data for user-space.


> > Unless someone is about to rip out pure address-based kprobes, I see
> > no reason to complicate the code.
> 
> If you actually look, you'll see that pure addressed based kprobes still
> work.

No need for the snark.  I know they work; we've been using them for
years.  I am simply happy to stay with them.


> Also, I think you'll find it simplifies the code, since tons of the
> runtime junk that duplicate the in-kernel symbol resolution can be
> thrown out, plus the corresponding pieces of systemtap that have to
> worry about this.

Again, please consider user-space.  The runtime will need similar
symbol resolution code *for user space* anyway.  Keeping it in there
for the kernel is no incremental complexity - if anything, the
opposite.


> There's also the architectural worry: this scheme you currently use
> is very fragile.  For instance, I don't see it surviving a move to
> -ffunction-sections (which patches are already going over
> linux-arch).

Let's try it.  Whatever actual problems that throws up, we'd also
encounter with userspace.


- FChE
