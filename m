Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYLDDGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYLDDGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 22:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYLDDGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 22:06:24 -0500
Received: from relais.videotron.ca ([24.201.245.36]:26528 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYLDDGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 22:06:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 03 Dec 2008 22:06:16 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Yet more ARM breakage in linux-next
In-reply-to: <20081204003143.GA21350@flint.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.0812032058050.14328@xanadu.home>
References: <20081203192905.GA12502@flint.arm.linux.org.uk>
 <20081203124109.79f8f15b.akpm@linux-foundation.org>
 <200812040952.44957.rusty@rustcorp.com.au>
 <20081204003143.GA21350@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008, Russell King wrote:

> On Thu, Dec 04, 2008 at 09:52:44AM +1030, Rusty Russell wrote:
> > On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
> > > On Wed, 3 Dec 2008 19:29:05 +0000
> > >
> > > Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > > > This seems to be causing lots of ARM breakage:
> > > >
> > > > lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
> > > >
> > > > Whoever's responsible,
> > >
> > > git-blame?
> > 
> > It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
> > asm/bitops.h, and I'm the first one to use it in generic code.
> > 
> > But as I prepared this patch, I note that the armv5 __fls/fls is wrong:
> 
> __fls is wrong.

__fls used to _not_ exist at all on ARM until commit 0c65f459ce.

> >   /* Implement fls() in C so that 64-bit args are suitably truncated */
> >   static inline int fls(int x)
> >   {
> >       return __fls(x);
> >   }
> > 
> > __fls(x) returns a bit number (0-31).  fls() returns 0 or bitnumber+1.
> 
> The 'clz' instruction returns 32 for a zero input, or (31 - most significant
> set bit) - which seems to work for fls() but not __fls().

... and it looks like the person who introduced the commit above didn't 
take into account the fact that __fls() already had another semantic in 
the kernel.

> Sending to Nicolas.

I queued a fix addressing both issues for RMK to merge:

  http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=5339/1


Nicolas
