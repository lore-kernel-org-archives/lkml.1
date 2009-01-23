Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbZAWQ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbZAWQ1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 11:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZAWQ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 11:27:12 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:37707 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZAWQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 11:27:11 -0500
Date: Fri, 23 Jan 2009 10:52:43 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <20090123041756.GH20098@wotan.suse.de>
Message-ID: <alpine.DEB.1.10.0901231042380.32253@qirst.com>
References: <20090114142200.GB25401@wotan.suse.de> <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com> <20090114150900.GC25401@wotan.suse.de> <Pine.LNX.4.64.0901141158090.26507@quilx.com> <20090115060330.GB17810@wotan.suse.de>
 <Pine.LNX.4.64.0901151320250.26467@quilx.com> <20090116031940.GL17810@wotan.suse.de> <Pine.LNX.4.64.0901161500080.27283@quilx.com> <20090119054730.GA22584@wotan.suse.de> <alpine.DEB.1.10.0901211914140.18367@qirst.com>
 <20090123041756.GH20098@wotan.suse.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Nick Piggin wrote:

> > > The thing IMO you forget with all these doomsday scenarios about SGI's peta
> > > scale systems is that no matter what you do, you can't avoid the fact that
> > > computing is about locality. Even if you totally take the TLB out of the
> > > equation, you still have the small detail of other caches. Code that jumps
> > > all over that 1024 TB of memory with no locality is going to suck regardless
> > > of what the kernel ever does, due to physical limitations of hardware.
> >
> > Typically we traverse lists of objects that are in the same slab cache.
>
> Very often that is not the case. And the price you pay for that is that
> you have to drain and switch freelists whenever you encounter an object
> that is not on the same page.

SLUB can directly free an object to any slab page. "Queuing" on free via
the per cpu slab is only possible if the object came from that per cpu
slab. This is typically only the case for objects that were recently
allocated.

There is no switching of queues because they do not exist in that form in
SLUB. We always determine the page address and put the object into the
freelist of that page. Also results in nice parallelism since the lock is
not even cpu specific.

> This gives your freelists a chaotic and unpredictable behaviour IMO in
> a running system where pages succumb to fragmentation so your freelist
> maximum sizes are limited. It also means you can lose track of cache
> hot objects when you switch to different "fast" pages. I don't consider
> this to be "queueing done right".

Yes you can loose track of caching hot objects. That is one of the
concerns with the SLUB approach. On the other hand: Caching architectures
get more and more complex these days (especially in a NUMA system). The
SLAB approach is essentially trying to guess which objects are cache hot
and queue them. Sometimes the queueing is advantageous (may be a reason
that SLAB is better than SLUB in some cases). In other cases SLAB keeps
objects on queues but the object have become sale (context switch, slab
unused for awhile). Then its no advantage anymore.

> > If all objects are from the same page then you need not check
> > the NUMA locality of any object on that queue.
>
> In SLAB and SLQB, all objects on the freelist are on the same node. So
> tell me how does same-page objects simplify numa  handling?

F.e. On free you need to determine the node to find the right queue in
SLAB. SLUB does not need to do that. It simply determines the page address
and does not care about the node when freeing the object. It is irrelevant
on which node the object sits.

Also on alloc: The per cpu slab can be from a foreign node. NUMA locality
does only matter if the caller wants memory from a particular node. So
cpus that have no local memory can still use the per cpu slabs to have
fast allocations etc etc.

> > > And you found you have to increase the size of your pages because you
> > > need bigger queues. (must we argue semantics? it is a list of free
> > > objects)
> >
> > Right. That may be the case and its a similar tuning to what SLAB does.
>
> SLAB and SLQB doesn't need bigger pages to do that.

But they require more metadata handling because they need to manage lists
of order-0 pages. metadata handling is reduced by orders of magnitude in
SLUB.
