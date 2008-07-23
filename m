Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYGWESI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYGWESI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 00:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYGWERz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 00:17:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbYGWERy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 00:17:54 -0400
Date: Wed, 23 Jul 2008 00:16:12 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
Message-ID: <20080723041612.GA11191@redhat.com>
References: <1216676595.3433.80.camel@localhost.localdomain> <y0mprp68zg9.fsf@ton.toronto.redhat.com> <1216698788.3433.116.camel@localhost.localdomain> <20080722115101.GB9508@redhat.com> <1216739683.3364.43.camel@localhost.localdomain> <y0mk5fd9a64.fsf@ton.toronto.redhat.com> <20080723014804.GA8826@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723014804.GA8826@mit.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ted -


On Tue, Jul 22, 2008 at 09:48:04PM -0400, Theodore Tso wrote:

> [...]
> 1) Right now, when trying to resolve the address to install a kprobe,
> Systemtap is using the DWARF information from the vmlinux file and/or
> the module's debuginfo files.

Or as a fallback, it can use textual symbol tables, such as a
System.map or /proc/kallsyms dump.

> 2) Kprobe can support setting probes based on raw addresses (which is
> what Systemtap is doing now) as well as a text symbol looked up from
> kallsyms plus an offset.  The latter was introduced two years ago, but
> Systemtap does not take advantage of it.

Right.

> 3) James is offended by the fact that Systemtap is not utilizing this
> interface, and has offerred up patches which adds the capability of
> using the symbol+offset feature of the kprobes interface.  [...]
>
> Am I missing anything?

I also proposed a compromise where systemtap would use the
symbol+offset interface, but choose a single convenient symbol as base
for all probes in a particular elf file (/section).


> So the main arguments against this seems to be that it by itself
> this doesn't actually reduce any complexity or code in Systemtap
> because there are other places (kernel data segment, user space
> tracing if it ever manages to get merged into mainline, etc.) which
> needs to be able to paw through DWARF headers.

Right.


> James' argument that this Systemtap is cramming over half a megabyte
> is regarded by is somewhat of a red herring with respect to this
> specific patch, since systemtap does not calculate probe addresses
> at runtime.

Or more precisely, not from that table.

> This 600k or so of symbol tables is being used for something else.
> (What, exactly?!?)

They are there to enable scripts to perform address-to-symbol and
symbol-to-address mappings on demand.  This comes up in several
contexts, one of which is symbolic stack unwinding, another is a set
of explicit utility functions that are/will be available.

It is possible that through analysis of any particular script's
contents, systemtap will be able to determine that this data is
unused, and thus compile it out.


> James clearly in the long term wants to make this go away, which
> seems reasonable.

Right, though this is an active development area whose ultimate
costs/benefits we do not yet know.


> He views changing how kprobes are placed is the first in a series of
> changes that he would like to make.

Right, keeping in mind that this change does not advance that prior
goal.


> So perhaps the resistance in accepting his first patch troubles him
> since it appears that Systemtap folks aren't willing to take his
> suggestions about how things should be improved.

Actually, this is not James' first patch; I am grateful for several
that are in systemtap already and others are in the queue.  But point
taken.


> May I make a suggestion and not try to come to a conclusion about the
> big picture question for a moment and focus on the very short-term of
> whether it is better that when I implement a probe such as:
> 
> probe module("ext4dev").function("ext4_fill_super")
> {     
>       printk("here am I!\n");
> }

Sure.


> This should be done via passing a hard-coded address, or via using
> the kprobes function+offset facility?  It would seem that there are
> advantages to James' patch all by itself, in that it will will work
> even if the debuginfo information for the ext4dev module can't be
> found, since the kallsyms information would be used instead.

As a quality-of-implementation matter, systemtap checks at translation
time that such probes make sense -- that "ext4_fill_super" even
exists.  (That is needed also to expand wildcards.)  The only way it
can do that is if it has dwarf or separate textual symbol table data
(see above).  Both of those carry addresses as well, so we might as
well use them.


> It also means that the resulting systemtap probe modules will be
> easier to make more kernel independent, since it won't be using a
> hard-coded address, but rather a symbolic name.

This is true, but I think it would apply to only a small class of
scripts.  Such a script would have to access no $context variables
(since those require dwarf location/type data), and cannot include
statement probes at function interiors (since those would require
dwarf-derived non-zero symbol offsets), and cannot use any other
runtime facility that involves arbitrary symbol<->address lookups.

Even then, kernel-independence in the sense of being able to copy and
reuse a compiled probe module amongst separate kernel builds seems
like a faint hope anyway, considering modversions and our own internal
version-matching checks.  But maybe there is an opportunity here.


> So what is the good reason *not* to do things the way James has
> suggested?  The kprobes kallsyms facility has been around for a
> while now.  Is it that we need to make changes?

One reason is that James' proposed code breaks systemtap for
pre-kallsyms-kprobes kernels, and those kernels too that have
kallsyms-kprobes but not the RFC'd new one that has the source file
names encoded within them.  It could instead use e.g. our autoconf*
facility to generate code compatible with them all.

Another reason is that it likely breaks systemtap for impending code
for user-space by replacing rather than extending various internal
data structures that deal with this.

I have seen little sympathy expressed for either of these concerns,
which means that the new code would primarily allay some offense (but
not constitute a bug fix or "usability for kernel developers" matter),
and leave us to pick up the pieces.  We can't make a habit out of that
sort of thing, but maybe as a one-off in the interest of mutual
goodwill, we should work out a way to get it done.


> Maybe if things are focused on somewhat more concrete questions, we
> can make progress.

Thank you.


- FChE
