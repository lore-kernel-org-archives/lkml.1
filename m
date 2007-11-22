Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbXKVCQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbXKVCQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXKVCQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:16:32 -0500
Received: from paragon.brong.net ([74.52.187.94]:53388 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXKVCQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:16:31 -0500
Date: Thu, 22 Nov 2007 13:16:28 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       robm@fastmail.fm
Subject: Re: mmap dirty limits on 32 bit kernels (Was: [BUG] New Kernel
	Bugs)
Message-ID: <20071122021628.GA8660@brong.net>
References: <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org> <20071115052538.GA21522@brong.net> <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org> <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org> <20071115115049.GA8297@brong.net> <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org> <20071121235115.GA30679@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121235115.GA30679@brong.net>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 10:51:15AM +1100, Bron Gondwana wrote:
> On Thu, Nov 15, 2007 at 08:32:22AM -0800, Linus Torvalds wrote:
> > If this patch makes a difference, please holler. I think it's the correct 
> > thing to do, but I'm not going to actually commit it without somebody 
> > saying that it makes a difference (and preferably Peter Zijlstra and 
> > Andrew acking it too).
> 
> mmap: mmap call failed: errno: 12 errmsg: Cannot allocate memory
> 
> Yep, that's "fixed" the problem alright!  No way this puppy is
> dirtying 2Gb of memory any more.
> 
> http://linux.brong.fastmail.fm/2007-11-22/bmtest.pl

Alternatively perhaps I'm just a moron who used a config file with:
CONFIG_PAGE_OFFSET=0x80000000 set to build the new kernel (I hadn't
committed it because it turned out not to solve the issue it was
there for).  That would explain a few things.

[root@lb1 perl]$ free
             total       used       free     shared    buffers     cached
Mem:       4150620    2272284    1878336          0      11212    2066536
-/+ buffers/cache:     194536    3956084
Swap:      2096472          0    2096472

That's more the usage I would expect to see.

Now for the downside.  It works again, but it still runs slow.  Seems to
hit (and this is totally unscientific, I'm just watching the numbers
scroll by) at about 120000 writes rather than 70000 writes, but that's
still not fitting the while file dirty.

I notice that PF_LESS_THROTTLE gets set by nfsd to get an extra 25%
bonus free space allocated.  Potentially dcc could use similar tricks
to claim extra space if that knob is available up in userspace.  I'm
happy to patch dcc as well if I have to, I'm already backporting it,
so adding another little quilt directory and applying it is pretty
trivial (must try guilt/stgit one of these days)

Bron.


