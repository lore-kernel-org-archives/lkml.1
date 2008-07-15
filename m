Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYGOWUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYGOWUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYGOWT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:19:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613AbYGOWT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:19:58 -0400
Date: Tue, 15 Jul 2008 18:18:26 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080715221826.GD4280@redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain> <y0mr69vj5p0.fsf@ton.toronto.redhat.com> <1216151526.3312.102.camel@localhost.localdomain> <20080715200718.GC4280@redhat.com> <1216153462.3312.126.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216153462.3312.126.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Jul 15, 2008 at 03:24:22PM -0500, James Bottomley wrote:
> [...]
> > > > > This is highly undesirable because it represents a subversion of the
> > > > > kernel API to gain access to unexported symbols.
> > [...]
> > Maybe, but what "subversion" are you talking about?
> 
> using a hand crafted relocation function to gain access to kernel
> symbols instead of the provided API.

Please choose your words more carefully.  We don't "subvert" anything,
where one would mean sneaking around some sort of protection.  We use
an established, existing facility (placing kprobes by address).  We
compute addresses correctly (an error would be obvious), and is
conceptually not so different from an address being passed in at run
time from /proc/kallsyms.


> > Of course, but for our purposes, the kernel will be just one amongst
> > many probing targets.  We will be tracking multiple symbol tables and
> > unwind data for user-space.
> 
> You're going to hand roll your own symbol resolution for user space too?
> Isn't it pretty easy simply to get ld.so to do that for you?

I don't see how.  We can't call into ld.so from kernel space.  One may
need to probe ld.so itself.


> [...] I made sure that pure addressed based kprobes still work even
> when they have to use the symbol_name/offset resolution method
> ... the new code just works out the closest symbol and applies an
> offset.

(Not important, but did you consider the possibility that this chosen
reference symbol may, for whatever reason, not be listed in the
kernel's kprobe-assisting symbol table?)


> > Again, please consider user-space.  The runtime will need similar
> > symbol resolution code *for user space* anyway.  Keeping it in there
> > for the kernel is no incremental complexity - if anything, the
> > opposite.
>
> I really think there might have to be separate runtime pieces for
> user space and for the kernel.  Trying to build a single scheme that
> works in both places looks cumbersome.  In the separate case, the
> kernel piece, which is potentially movable inside the kernel,
> becomes a lot simpler. [...]

It may just be in the eye of the beholder.  To me, a single scheme
that supports all the various address spaces (and kernel versions and
configurations!) we deal with is just as appealing to me as increasing
kernel specialization is to you.


> OK, with -ffunction-sections you can't offset from _stext which
> seems to be what _stp_module_relocate() uses.  [...]  That means
> that each function address can potentially move depending on the
> number of relocation stubs embedded between it and the next
> function.

I may be missing something, but doesn't all that happen during
linking?  We process linked executables, not object files subject to
further run-time relaxation/shrinkage.


- FChE
