Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYGZTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYGZTlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYGZTlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:41:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYGZTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:41:12 -0400
Date: Sat, 26 Jul 2008 12:38:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Andrea Righi <righi.andrea@gmail.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: __weak vs ifdef
In-Reply-To: <20080725122454.GE6701@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0807261221480.4188@nehalem.linux-foundation.org>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi> <20080725015537.564e3397.akpm@linux-foundation.org> <20080725091455.GD19310@cs181140183.pp.htv.fi> <20080725092748.GF19310@cs181140183.pp.htv.fi> <20080725023455.dde3eb27.akpm@linux-foundation.org>
 <20080725122454.GE6701@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jul 2008, Matthew Wilcox wrote:

> On Fri, Jul 25, 2008 at 02:34:55AM -0700, Andrew Morton wrote:
> > We should make arch_pick_mmap_layout __weak and nuke that ifdef.
> 
> I strongly disagree.  I find it makes it harder to follow code flow
> when __weak functions are involved.  Ifdefs are ugly, no question, but
> they're easier to grep for

Hell no, they're not.

Our use of random HAVE_ARCH_xyz or ARCH_SUPPORTS_xyz etc stuff makes 
things _totally_ impossible to grep for.

In contrast, it we did this code as

	#ifndef arch_pick_mmap_layout
	void __weak arch_pick_mmap_layout(struct mm_struct *mm)
	{
		mm->mmap_base = TASK_UNMAPPED_BASE;
		mm->get_unmapped_area = arch_get_unmapped_area;
		mm->unmap_area = arch_unmap_area;
	}
	#endif

then trying to grep for arch_pick_mmap_layout() would show EVERY SINGLE 
RELEVANT CASE! And it would show the "__weak" there too, so that once 
people get used to this convention, they'd have a really easy time 
figuring out the rules from just the output of the 'grep'.

I really think that whoever started that 'HAVE_ARCH_x'/'ARCH_HAS_x' mess 
with totally random symbols that have NOTHING WHAT-SO-EVER to do with the 
actual symbols in question (so they do _not_ show up in grep'ing for some 
use) should be shot. 

We should never _ever_ use that model. And we use it way too much.

We should generally strive for the simpler and much more obvious

	/* Generic definition */
	#ifndef symbol
	int symbol(..)
	...
	#endif

and then architecture code can do

	#define symbol(x) ...

or if they want to do a function, and you _really_ don't like the '__weak' 
part (or you want to make it an inline function and don't want the clash 
with the real declaration), then you can just do

	static inline int symbol(x)
	{
		...
	}
	#define symbol symbol

and again it all works fine WITHOUT having to introduce some idiotic new 
and unrelated element called ARCH_HAS_SYMBOL.

And now when you do 'git grep symbol' you really will see the rules. ALL 
the rules. Not some random collection of uses that don't actually explain 
why there are five different definitions of the same thing and then you 
have to figure out which one gets used.

> My basic point here is that __weak makes the code easier to write but
> harder to read, and we're supposed to be optimising for easier to read.

But your basic point is flawed. The thing you advocate is actually harder 
to read.

Yes, if you don't follow the codign style, and you write

	int __weak
	symbol(x)
	{

you are (a) a moronic rebel you never understood why the declaration 
should be on one line and (b) as a result your 'grep' won't see the __weak 
and you'll be confused about the rules.

But if we _consistently_ used

 - '#ifndef symbol' to avoid redeclaring something that the architecture 
   overrides

 - and '__weak' to allow architectures to just override functions without 
   extra work and rules

then after a while people would simply _know_ that very simple set of 
rules, and a 'grep' would work so much better than it does now.

Really. Try it. Try it with 'arch_pick_mmap_layout' (with Andrews patch in 
place). And then imagine that you'd be used to '__weak', and seeing that 
additional

	mm/util.c:#ifndef arch_pick_mmap_layout
	mm/util.c:void __weak arch_pick_mmap_layout(struct mm_struct *mm)

in the output. Be honest now - wouldn't that actually _tell_ you something 
relevant about that particular declaration? And make the fact that some 
architectures override it _less_ confusing?

IOW, you could tell directly from the grep output that it's a "default 
fallback". Which you definitely cannot tell right now, because we have 
insane models for doing it.

		Linus
