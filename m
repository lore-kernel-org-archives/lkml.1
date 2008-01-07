Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYAGTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYAGTER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbYAGTEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:04:07 -0500
Received: from waste.org ([66.93.16.53]:42024 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYAGTEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:04:06 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
	 <1199641910.8215.28.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 13:03:15 -0600
Message-Id: <1199732595.4110.30.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-07 at 20:06 +0200, Pekka J Enberg wrote:
> Hi Matt,
> 
> On Sun, 6 Jan 2008, Matt Mackall wrote:
> > I don't have any particular "terrible" workloads for SLUB. But my
> > attempts to simply boot with all three allocators to init=/bin/bash in,
> > say, lguest show a fair margin for SLOB.
> 
> Sorry, I once again have bad news ;-). I did some testing with
> 
>   lguest --block=<rootfile> 32 /boot/vmlinuz-2.6.24-rc6 root=/dev/vda init=doit
> 
> where rootfile is
> 
>   http://uml.nagafix.co.uk/BusyBox-1.5.0/BusyBox-1.5.0-x86-root_fs.bz2
> 
> and the "doit" script in the guest passed as init= is just
> 
>   #!/bin/sh
>   mount -t proc proc /proc
>   cat /proc/meminfo | grep MemTotal
>   cat /proc/meminfo | grep MemFree
>   cat /proc/meminfo | grep Slab
> 
> and the results are:
> 
> [ the minimum, maximum, and average are of captured from 10 individual runs ]
> 
>                                  Free (kB)             Used (kB)
>                     Total (kB)   min   max   average   min  max  average
>   SLUB (no debug)   26536        23868 23892 23877.6   2644 2668 2658.4
>   SLOB              26548        23472 23640 23579.6   2908 3076 2968.4
>   SLAB (no debug)   26544        23316 23364 23343.2   3180 3228 3200.8
>   SLUB (with debug) 26484        23120 23136 23127.2   3348 3364 3356.8
> 
> So it seems that on average SLUB uses 300 kilobytes *less memory* (!) (which is
> roughly 1% of total memory available) after boot than SLOB for my
> configuration.

Fascinating. Which kernel version are you using? This patch doesn't seem
to have made it to mainline:

---

slob: fix free block merging at head of subpage

We weren't merging freed blocks at the beginning of the free list.
Fixing this showed a 2.5% efficiency improvement in a userspace test
harness.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 5374012889d6 mm/slob.c
--- a/mm/slob.c	Wed Dec 05 09:27:46 2007 -0800
+++ b/mm/slob.c	Wed Dec 05 16:10:37 2007 -0600
@@ -398,6 +398,10 @@ static void slob_free(void *block, int s
 	sp->units += units;
 
 	if (b < sp->free) {
+		if (b + units == sp->free) {
+			units += slob_units(sp->free);
+			sp->free = slob_next(sp->free);
+		}
 		set_slob(b, units, sp->free);
 		sp->free = b;
 	} else {

---

> One possible explanation is that the high internal fragmentation (space
> allocated but not used) of SLUB kmalloc() only affects short-lived allocations
> and thus does not show up in the more permanent memory footprint.  Likewise, it
> could be that SLOB has higher external fragmentation (small blocks that are
> unavailable for allocation) of which SLUB does not suffer from.  Dunno, haven't
> investigated as my results are contradictory to yours.

I suppose that's possible.

> I am beginning to think this is highly dependent on .config so would you mind
> sending me one you're using for testing, Matt?

I'm sure I don't have it any more, as that was back in July or so. How
about you send me your config and I'll try to figure out what's going
on?

-- 
Mathematics is the supreme nostalgia of our time.

