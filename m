Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660AbYGWQlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbYGWQlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYGWQlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:41:10 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58557 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbYGWQlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:41:09 -0400
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Theodore Tso <tytso@mit.edu>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080723162505.GJ8826@mit.edu>
References: <1216676595.3433.80.camel@localhost.localdomain>
	 <y0mprp68zg9.fsf@ton.toronto.redhat.com>
	 <1216698788.3433.116.camel@localhost.localdomain>
	 <20080722115101.GB9508@redhat.com>
	 <1216739683.3364.43.camel@localhost.localdomain>
	 <y0mk5fd9a64.fsf@ton.toronto.redhat.com> <20080723014804.GA8826@mit.edu>
	 <20080723041612.GA11191@redhat.com>  <20080723162505.GJ8826@mit.edu>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 12:40:26 -0400
Message-Id: <1216831226.13159.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 12:25 -0400, Theodore Tso wrote:
> On Wed, Jul 23, 2008 at 12:16:12AM -0400, Frank Ch. Eigler wrote:
> > I also proposed a compromise where systemtap would use the
> > symbol+offset interface, but choose a single convenient symbol as base
> > for all probes in a particular elf file (/section).
> 
> I guess I don't see the value of that over just using the address
> directly.  James' point wasn't just to use the symbol+offset feature
> just for the sake of using it, but rather as a better way of
> specifying how to insert a probe into a kernel.  For example, it may
> be that by allowing the kernel to have a bit more semantic knowledge
> of where a probe is going, it could more easily do various
> safety-related checks that can't be done if all it is given is a a raw
> address.
> 
> > > probe module("ext4dev").function("ext4_fill_super")
> > > {     
> > >       printk("here am I!\n");
> > > }
> > 
> > > This should be done via passing a hard-coded address, or via using
> > > the kprobes function+offset facility?  It would seem that there are
> > > advantages to James' patch all by itself, in that it will will work
> > > even if the debuginfo information for the ext4dev module can't be
> > > found, since the kallsyms information would be used instead.
> > 
> > As a quality-of-implementation matter, systemtap checks at translation
> > time that such probes make sense -- that "ext4_fill_super" even
> > exists.  (That is needed also to expand wildcards.)  The only way it
> > can do that is if it has dwarf or separate textual symbol table data
> > (see above).  Both of those carry addresses as well, so we might as
> > well use them.
> 
> True, though I'll note for modern kernels, with /proc/kallsyms, we
> should hopefully be able to do this (offset=0 probes) without DWARF
> headers.  BTW, one of the things which I have wondered is whether
> DWARF was really the right approach after all, given how bloated and
> space-inefficient it seems to be.  Needing to keep 600 megs of module
> debuginfo for each kernel that I build (and yes, I build a fairly
> complete module-rich kernel, but having 59 megs of modules expand into
> 606 megs of debuginfo files is more than a little bit obnoxious.)

Yes ... the Sun solution to this was something called CTF which is
basically compressed dwarf with duplicates eliminated (as you say
below).  We could go a long way with simple duplicate elimination in
dwarf.  For instance dwarf tends to deposit a definition of a structure
wherever it's used.  For popular structures (like struct task) this can
lead to hundreds of duplicates in the debug info.

However, as has been rightly pointed out, most of what people want is
simple entry and exit notification on functions ... this we can do with
kprobes without any dwarf at all (so it's something systemtap should be
able to do).  In theory, we can also get at the actual function call
arguments without resorting to dwarf, although that requires someone
actually knowing the order and type (without dwarf we can't cross check
unless we do something like parse the kernel headers).

Where it gets tricky is if you want access to variables in the middle of
the routine.  This is very useful to kernel developers and for static
tracepoints.  Note that the current markers project has a solution to
this which could be done dwarfless ... the problem is that it has to
perturb the optimiser at that point to spill the variables of interest
to locations we know, so the price we pay is zero impact when disabled.
The approach I was taking more or less relies on dwarf (or CTF) to be
zero impact because the variable could be aynwhere ... including in a
register or temporary stack location.

> Maybe the kernel could be one of the places where we experiment with
> using something like CTF.  Apparently CTF is compact enough that the
> Solaris folks are willing to keep the CTF information for the
> currently booted kernel in unswappable kernel memory --- which I know
> is one of those things we wouldn't want to do with DWARF information!

I'm not sure we'd want to do it with CTF either ... the only reason to
have it in the kernel is if the kernel wants to use it.  Right at the
moment with the dwarf, systemtap userspace is the only consumer, so it
doesn't need to be in the kernel; I don't really see that changing with
CTF.  I think dtrace does it because the D runtime is in-kernel so some
of the run time typing needs the CTF.

James


