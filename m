Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbXCWQWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbXCWQWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXCWQWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:22:13 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:37377 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbXCWQWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:22:11 -0400
Date: Fri, 23 Mar 2007 17:22:12 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Christoph Lameter <christoph@lameter.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] NUMA : could we introduce virt_to_nid() ?
Message-Id: <20070323172212.6648412d.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0703230749130.29603@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
	<Pine.LNX.4.64.0703210742080.1573@graphe.net>
	<Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
	<20070321160929.GB25583@one.firstfloor.org>
	<20070323121512.c287ddef.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0703230749130.29603@graphe.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 07:50:28 -0700 (PDT)
Christoph Lameter <christoph@lameter.com> wrote:

> On Fri, 23 Mar 2007, Eric Dumazet wrote:
> 
> > Checking Christoph quicklist implementation, I found the same cache miss in free() than SLAB has.
> > 
> > /* common implementation *
> > int virt_to_nid(const void *addr)
> > {
> > 	struct page *page = virt_to_page(addr); 
> > 	return page_to_nid(page);
> > }
> > 
> > On some platforms (x86_64 for example), could we have a better 
> > implementation, not accessing struct page, but using phys_to_nid() ?
> 
> This is going to pollute the caches since we then use multiple ways to 
> determine the node of a page. Its better to stay with the same approach 
> for all pages. The page struct is used for many other purposes as well. 
> Its likely to be in the cpu cache.
> 

Sorry ? page structs are not in cpu cache at all.

phys_to_nid() on my 16 GB x86_64 machine uses one single cache line, shared by all pages.
This single cache line is cache hot yes, not "struct page"s ...

And on this machine, thats about 224 Mbytes of 'struct pages'

You carefully commented your alloc() function saying it is touching two cache lines.
But you omited to say that free() function needs 3 cache lines if CONFIG_NUMA

For SLAB use, page struct is needed because we use lru.{next|prev} to store slab/cachep pointers, but for a pure page allocator, unless I misread your patch, we dont need it, if virt_to_nid() can do its job without it.

