Return-Path: <linux-kernel-owner+w=401wt.eu-S1033830AbXEIDQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033830AbXEIDQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033189AbXEIDQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:16:17 -0400
Received: from waste.org ([66.93.16.53]:34487 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033730AbXEIDQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:16:15 -0400
Date: Tue, 8 May 2007 22:16:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509031604.GD11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 07:24:07PM -0700, Christoph Lameter wrote:
> On Tue, 8 May 2007, Matt Mackall wrote:
> 
> > > > Yes. It can in fact put 512 8-byte objects in a 4k page. More
> > > 
> > > So can SLUB.
> > 
> > Not without at least a bit per-object of overhead. So you can either
> > fit 512 objects in 4160 bytes or 504 objects in 4k.
> 
> Slub uses a linked list pointer in the page struct which is NULL if all 
> objects are allocated. There is no bit per object overhead.

Ahh, I'd forgotten about that feature.

> > For the kmalloc case, we do have an 8-byte header, which works out to
> > be about 1/8th of the slop that mainline kmalloc over SLAB has on
> 
> Exactly. That overhead does not exist in SLUB. Thus SLOB is less efficient 
> than SLUB.

What size object does kmalloc(80) return? In SLAB, the answer is 128
bytes with 48 bytes of slack space. In SLOB, the answer is 88 for 8
bytes of slack space. Looks like SLUB is in the same camp as SLAB
here:

+/*
+ * We keep the general caches in an array of slab caches that are used for
+ * 2^x bytes of allocations.
+ */
+extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
...
+	if (size <=        128) return 7;

As I pointed out in our private thread, according to these
measurements:

http://lwn.net/Articles/124374/

total bytes allocated: 47118848   
slack bytes allocated:  8717262
number of allocs:        132796

...the average kmalloc allocation with SLAB is 355 bytes with an
average slack of 66 bytes. As SLUB uses the same kmalloc cache size
strategy, I expect the same there.

SLOB's kmalloc overhead is 8 bytes, always. That's 1/8th the average
SLAB kmalloc overhead.
 
-- 
Mathematics is the supreme nostalgia of our time.
