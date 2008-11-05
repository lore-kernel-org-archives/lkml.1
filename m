Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYKEUce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYKEUce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYKEUcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:32:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756725AbYKEUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:32:15 -0500
Date: Wed, 5 Nov 2008 12:31:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: peterz@infradead.org, rientjes@google.com, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081105123150.d6628805.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811051415360.31450@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
	<20081104131637.68fbe055.akpm@linux-foundation.org>
	<1225833710.7803.1993.camel@twins>
	<20081104135004.f1717fcf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041601100.5077@quilx.com>
	<20081104143534.b5c16147.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041648350.6254@quilx.com>
	<20081104153610.bbfd5ed8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811042036000.31167@quilx.com>
	<20081104190505.769b93ec.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811050747040.11867@quilx.com>
	<20081105104145.abd6fc91.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811051415360.31450@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 14:21:47 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 5 Nov 2008, Andrew Morton wrote:
> 
> > > > Doable.  lru->page->mapping->host is a good start.
> > >
> > > The block layer has a list of inodes that are dirty. From that we need to
> > > select ones that will improve the situation from the cpuset/memcg. How
> > > does the LRU come into this?
> >
> > In the simplest case, dirty-memory throttling can just walk the LRU
> > writing back pages in the same way that kswapd does.
> 
> That means running reclaim. But we are only interested in getting rid of
> dirty pages. Plus the filesystem guys have repeatedly pointed out that
> page sized I/O to random places in a file is not a good thing to do. There
> was actually talk of stopping kswapd from writing out pages!

They don't have to be reclaimed.

> > There would probably be performance benefits in doing
> > address_space-ordered writeback, so the dirty-memory throttling could
> > pick a dirty page off the LRU, go find its inode and then feed that
> > into __sync_single_inode().
> 
> We cannot call into the writeback functions for an inode from a reclaim
> context. We can write back single pages but not a range of pages from an
> inode due to various locking issues (see discussion on slab defrag
> patchset).

We're not in a reclaim context.  We're in sys_write() context.

> > But _are_ people hitting this problem?  I haven't seen any real-looking
> > reports in ages.  Is there some workaround?  If so, what is it?  How
> > serious is this problem now?
> 
> Are there people who are actually having memcg based solutions deployed?
> No enterprise release includes it yet so I guess that there is not much of
> a use yet.

If you know the answer then please provide it.  If you don't, please
say "I don't know".

