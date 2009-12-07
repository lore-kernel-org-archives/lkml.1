Return-Path: <linux-kernel-owner+w=401wt.eu-S965030AbZLGUuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030AbZLGUuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965022AbZLGUuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:50:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965021AbZLGUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:49:59 -0500
Date: Mon, 7 Dec 2009 12:48:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Steven Rostedt <rostedt@goodmis.org>, werner <w.landgraf@ru.ru>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: kernel problem
Message-Id: <20091207124828.85e814b8.akpm@linux-foundation.org>
In-Reply-To: <20091207145011.GA14743@csn.ul.ie>
References: <web-100877149@zbackend1.aha.ru>
	<20091204154109.GB1716@goodmis.org>
	<20091207145011.GA14743@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009 14:50:11 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Dec 04, 2009 at 10:41:09AM -0500, Steven Rostedt wrote:
> > [ Added Cc's of people that may be interested in this ]
> > > <SNIP>
> > > ------------[ cut here ]------------
> > > WARNING: at mm/page_alloc.c:1805
> > > __alloc_pages_nodemask+0x127/0x48f()
> > > Hardware name: System Product Name
> > > Modules linked in:
> > > Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
> > > Call Trace:
> > >  [<c103d94b>] warn_slowpath_common+0x65/0x95
> > >  [<c103d98d>] warn_slowpath_null+0x12/0x15
> > >  [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
> > >  [<c10be964>] ? get_slab+0x8/0x50
> > >  [<c10b8979>] alloc_page_interleave+0x2e/0x6e
> > >  [<c10b8a10>] alloc_pages_current+0x57/0x99
> > >  [<c2083a4a>] ? xd_init+0x0/0x482
> > >  [<c1094c38>] __get_free_pages+0xd/0x1e
> > >  [<c2083a94>] xd_init+0x4a/0x482
> > >  [<c2082df0>] ? loop_init+0x104/0x16a
> > >  [<c169162d>] ? loop_probe+0x0/0xaf
> > >  [<c2083a4a>] ? xd_init+0x0/0x482
> > >  [<c1001143>] do_one_initcall+0x51/0x13f
> > >  [<c204a307>] kernel_init+0x10b/0x15f
> > >  [<c204a1fc>] ? kernel_init+0x0/0x15f
> > >  [<c1004347>] kernel_thread_helper+0x7/0x10
> > > ---[ end trace 686db6333ade6e7a ]---
> > > xd: Out of memory.
> 
> First off, it would appear that every block driver under the sun is
> being loaded. I seriously doubt this controller really exists in the
> machine.

I'd be surprised if anyone uses xd.c any more.

> Second, it's a real warning as the driver is trying to allocate a buffer of
> size 0 which get_order() chokes on.

ooh, good one.  I couldn't work it out.

Have we changed behaviour here?  Is it possible that an
xd_dma_mem_alloc(0) in some earlier kernel did something different?

> For bonus points, it tries to allocate
> a buffer before it knows what size it should be. This patch should resolve
> the problem but because I don't have the hardware to test it on, it could
> do with a second set of eyes just to be sure the rejigged logic makes sense.
> 
> If this is ok, what is the appropriate submission path for unmaintained
> block drivers? Is it the block maintainer or someone else?

Yup, Jens would be the appropriate target.

> ==== CUT HERE ====
> block,xd: Delay allocation of DMA buffers until device is known
> 
> Loading the XD module triggers a warning like
> 
>  WARNING: at mm/page_alloc.c:1805
>  __alloc_pages_nodemask+0x127/0x48f()
>  Hardware name: System Product Name
>  Modules linked in:
>  Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
>  Call Trace:
>   [<c103d94b>] warn_slowpath_common+0x65/0x95
>   [<c103d98d>] warn_slowpath_null+0x12/0x15
>   [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
>   [<c10be964>] ? get_slab+0x8/0x50
>   [<c10b8979>] alloc_page_interleave+0x2e/0x6e
>   [<c10b8a10>] alloc_pages_current+0x57/0x99
>   [<c2083a4a>] ? xd_init+0x0/0x482
>   [<c1094c38>] __get_free_pages+0xd/0x1e
>   [<c2083a94>] xd_init+0x4a/0x482
>   [<c2082df0>] ? loop_init+0x104/0x16a
>   [<c169162d>] ? loop_probe+0x0/0xaf
>   [<c2083a4a>] ? xd_init+0x0/0x482
>   [<c1001143>] do_one_initcall+0x51/0x13f
>   [<c204a307>] kernel_init+0x10b/0x15f
>   [<c204a1fc>] ? kernel_init+0x0/0x15f
>   [<c1004347>] kernel_thread_helper+0x7/0x10
>  ---[ end trace 686db6333ade6e7a ]---
>  xd: Out of memory.
>
> ...
