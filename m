Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbXEPTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbXEPTwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbXEPTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:52:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757637AbXEPTwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:52:08 -0400
Date: Wed, 16 May 2007 12:47:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page
In-Reply-To: <Pine.LNX.4.64.0705161946170.28185@blonde.wat.veritas.com>
Message-ID: <alpine.LFD.0.98.0705161242520.3890@woody.linux-foundation.org>
References: <20070508225012.GF20174@wotan.suse.de>
 <Pine.LNX.4.64.0705091950080.2909@blonde.wat.veritas.com>
 <20070510033736.GA19196@wotan.suse.de> <Pine.LNX.4.64.0705101935590.18496@blonde.wat.veritas.com>
 <20070511085424.GA15352@wotan.suse.de> <Pine.LNX.4.64.0705111357120.3350@blonde.wat.veritas.com>
 <20070513033210.GA3667@wotan.suse.de> <Pine.LNX.4.64.0705130535410.3015@blonde.wat.veritas.com>
 <20070513065246.GA15071@wotan.suse.de> <Pine.LNX.4.64.0705161838080.16762@blonde.wat.veritas.com>
 <20070516181847.GD5883@wotan.suse.de>
 <Pine.LNX.4.64.0705161946170.28185@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 May 2007, Hugh Dickins wrote:

> On Wed, 16 May 2007, Nick Piggin wrote:
> > On Wed, May 16, 2007 at 06:54:15PM +0100, Hugh Dickins wrote:
> > > On Sun, 13 May 2007, Nick Piggin wrote:
> > > > 
> > > > Well I think so, but not completely sure.
> > > 
> > > That's not quite enough to convince me!
> > 
> > I did ask Linus, and he was very sure it works.
> 
> Good, that's very encouraging.

Note that our default spinlocks _depend_ on a bog-standard store just 
working as an unlock, so this wouldn't even be anything half-way new:

	static inline void __raw_spin_unlock(raw_spinlock_t *lock)
	{
		asm volatile("movb $1,%0" : "+m" (lock->slock) :: "memory");
	}

There are some Opteron errata (and a really old P6 bug) wrt this, but they 
are definitely CPU bugs, and we haven't really worked out what the Opteron 
solution should be (the bug is apparently pretty close to impossible to 
trigger in practice, so it's not been a high priority).

> > The other option of moving the bit into ->mapping hopefully avoids all
> > the issues, and would probably be a little faster again on the P4, at the
> > expense of being a more intrusive (but it doesn't look too bad, at first
> > glance)...
> 
> Hmm, I'm so happy with PG_swapcache in there, that I'm reluctant to
> cede it to your PG_locked, though I can't deny your use should take
> precedence.  Perhaps we could enforce 8-byte alignment of struct
> address_space and struct anon_vma to make both bits available
> (along with the anon bit).

We probably could. It should be easy enough to mark "struct address_space" 
to be 8-byte aligned.

> But I think you may not be appreciating how intrusive PG_locked
> will be.  There are many references to page->mapping (often ->host)
> throughout fs/ : when we keep anon/swap flags in page->mapping, we
> know the filesystems will never see those bits set in their pages,
> so no page_mapping-like conversion is needed; just a few places in
> common code need to adapt.

You're right, it could be really painful. We'd have to rename the field, 
and use some inline function to access it (which masks off the low bits).

		Linus
