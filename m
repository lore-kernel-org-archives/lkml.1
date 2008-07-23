Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYGWQZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYGWQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYGWQZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:25:15 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44678 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbYGWQZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:25:14 -0400
Date: Wed, 23 Jul 2008 12:25:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
Message-ID: <20080723162505.GJ8826@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	systemtap@sourceware.org
References: <1216676595.3433.80.camel@localhost.localdomain> <y0mprp68zg9.fsf@ton.toronto.redhat.com> <1216698788.3433.116.camel@localhost.localdomain> <20080722115101.GB9508@redhat.com> <1216739683.3364.43.camel@localhost.localdomain> <y0mk5fd9a64.fsf@ton.toronto.redhat.com> <20080723014804.GA8826@mit.edu> <20080723041612.GA11191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723041612.GA11191@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 12:16:12AM -0400, Frank Ch. Eigler wrote:
> I also proposed a compromise where systemtap would use the
> symbol+offset interface, but choose a single convenient symbol as base
> for all probes in a particular elf file (/section).

I guess I don't see the value of that over just using the address
directly.  James' point wasn't just to use the symbol+offset feature
just for the sake of using it, but rather as a better way of
specifying how to insert a probe into a kernel.  For example, it may
be that by allowing the kernel to have a bit more semantic knowledge
of where a probe is going, it could more easily do various
safety-related checks that can't be done if all it is given is a a raw
address.

> > probe module("ext4dev").function("ext4_fill_super")
> > {     
> >       printk("here am I!\n");
> > }
> 
> > This should be done via passing a hard-coded address, or via using
> > the kprobes function+offset facility?  It would seem that there are
> > advantages to James' patch all by itself, in that it will will work
> > even if the debuginfo information for the ext4dev module can't be
> > found, since the kallsyms information would be used instead.
> 
> As a quality-of-implementation matter, systemtap checks at translation
> time that such probes make sense -- that "ext4_fill_super" even
> exists.  (That is needed also to expand wildcards.)  The only way it
> can do that is if it has dwarf or separate textual symbol table data
> (see above).  Both of those carry addresses as well, so we might as
> well use them.

True, though I'll note for modern kernels, with /proc/kallsyms, we
should hopefully be able to do this (offset=0 probes) without DWARF
headers.  BTW, one of the things which I have wondered is whether
DWARF was really the right approach after all, given how bloated and
space-inefficient it seems to be.  Needing to keep 600 megs of module
debuginfo for each kernel that I build (and yes, I build a fairly
complete module-rich kernel, but having 59 megs of modules expand into
606 megs of debuginfo files is more than a little bit obnoxious.)

Maybe the kernel could be one of the places where we experiment with
using something like CTF.  Apparently CTF is compact enough that the
Solaris folks are willing to keep the CTF information for the
currently booted kernel in unswappable kernel memory --- which I know
is one of those things we wouldn't want to do with DWARF information!

> I have seen little sympathy expressed for either of these concerns,
> which means that the new code would primarily allay some offense (but
> not constitute a bug fix or "usability for kernel developers" matter),
> and leave us to pick up the pieces.  We can't make a habit out of that
> sort of thing, but maybe as a one-off in the interest of mutual
> goodwill, we should work out a way to get it done.

This may have been a communication disconnect.  I suspect if the
answer was, "please make the following changes and we will accept the
patch", that James may have been willing to make the changes ---
especially if it is for the sake of backwards compatibility with older
kernels.  Most kernel developers do care very much about backwards
compatibility between userspace and older kernel versions.  (Some of
the folks who weren't as careful have been flamed pretty heavily about
that; I'm still not a great fan of the sysfs interface from a
userspace usability perspective, but we haven't had a major breakage
there in quite a while.)

So there is a big difference between "please do X, Y, and Z first and
the patch would then be acceptable" versus "for reasons A, B and C
this patch is totally unacceptable and in fact what you are trying to
do is pointless".

Regards,

						- Ted
