Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXFDRvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXFDRvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXFDRvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:51:01 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096AbXFDRvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:51:00 -0400
Date: Mon, 4 Jun 2007 10:50:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <20070604182025.558a8d10@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0706041043330.23741@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <20070601204141.f84ad72f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>
 <20070601213117.1178e8e0.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>
 <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>
 <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com>
 <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com>
 <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
 <20070604182025.558a8d10@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 Jun 2007, Alan Cox wrote:

> > The thing is, why *should* we care about comparing addresses? We'll give 
> 
> Because people use it to tell objects apart. All over the kernel we do
> things like
> 
> 	if (inode1 == inode2)

But that only makes sense if your objects have meaning, which is not 
possible with a zero-sized object.

Let's take an example: one of the few reasons to check for equality (or 
inequality) is for locking order.

So on UP, the lock goes away, and let's say that you (insanely) only have 
a spinlock in the structure in question, so you have a zero-sized 
structure that you want to test ordering on because you want to avoid 
ABBA deadlocks.

So you write your code as

   double_lock()
   {
	if (ptr1 == ptr2) {
		lock(ptr1->lock);
		return;
	}
	if (ptr1 < ptr2) {
		lock(ptr1->lock);
		lock(ptr2->lock);
		return;
	}
	lock(ptr2->lock);
	lock(ptr1->lock);
    }

and the interesting thing is that this actually *works* even for the case 
where the lock has gone away: even though ptr1/ptr2 are always equal.

In other words, the only _valid_ reasons to compare pointers like this end 
up degenerating into working cases even for a zero-sized pointer.

The exception is if you use the memory allocator as a "ID allocator", but 
quite frankly, if you use a size of zero, it's your own damn problem. 
Insane code is not an argument for insane behaviour.

If people can't be bothered to create a "random ID generator" themselves, 
they had damn well better use "kmalloc(1)" rather than "kmalloc(0)" to get 
a unique cookie. Asking the allocator to do something idiotic because some 
idiot thinks a memory allocator is a cookie allocator is just crazy.

I can understand that things like user-level libraries have to take crazy 
people into account, but the kernel internal libraries definitely do not.

(Right now we warn once for zero-sized allocations anyway, and all the 
cases we've found so far are either bugs that would have been found with 
ZERO_ALLOC_PTR or would have been perfectly fine with it, so I don't think 
anybody really _is_ that insane in the kernel)

		Linus
