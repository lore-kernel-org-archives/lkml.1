Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbXKNTnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbXKNTnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXKNTnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:43:43 -0500
Received: from waste.org ([66.93.16.53]:34157 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbXKNTnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:43:42 -0500
Date: Wed, 14 Nov 2007 13:42:24 -0600
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071114194223.GT19691@waste.org>
References: <200711112058.28043.rjw@sisk.pl> <20071114112001.GA13870@elte.hu> <20071114173611.GR19691@waste.org> <20071114183952.GS19691@waste.org> <20071114190501.GA5768@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114190501.GA5768@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 08:05:01PM +0100, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > > > [   61.245190] rc.sysinit used greatest stack depth: 1680 bytes left
> > > > [   61.386859] list_add corruption. prev->next should be next (407d973c), but was 418cf818. (prev=41877098).
> > > > [   61.396328] ------------[ cut here ]------------
> > > > [   61.400910] kernel BUG at lib/list_debug.c:33!
> > > > [   61.405330] invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
> > > > 
> > > > looks like memory corruption of some sort and it's reproducible. Picking 
> > > > CONFIG_SLUB makes the crash go away. Booting v2.6.23 with the same 
> > > > .config works fine.
> > > 
> > > Hmmm, the changes in SLOB since v2.6.23 are all trivial. I'll try to 
> > > reproduce it with your config, but it doesn't seem promising.
> > 
> > Couldn't reproduce it here, let me know if you get anywhere with your 
> > bisect.
> 
> the bug went away - and the only thing i did was a networking config 
> tweak. So maybe something in networking corrupts memory? I'm not sure i 
> can restore the old state. (i had lots of problems with net interface 
> renaming not working in .24)

Quite possible. SLOB is more sensitive to off by one bugs because it
doesn't have the power-of-two buckets that SLAB/SLUB have. IIRC,
SLAB/SLUB's debugging features won't detect when you request 28 bytes,
get 32, then overwrite byte 29. But that will damage other objects or
the free list in SLOB.

But this isn't the per-page SLOB list that's getting clobbered, this
is the list of pages held in struct page.

-- 
Mathematics is the supreme nostalgia of our time.
