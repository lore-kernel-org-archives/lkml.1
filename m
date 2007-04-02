Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbXDBVmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbXDBVmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965964AbXDBVmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:42:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42719 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961AbXDBVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:42:51 -0400
Subject: Re: [PATCH 1/2] Generic Virtual Memmap suport for SPARSEMEM
From: Dave Hansen <hansendc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0704021428340.2272@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
	 <1175547000.22373.89.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021351590.1224@schroedinger.engr.sgi.com>
	 <1175548924.22373.109.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704021428340.2272@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 14:42:31 -0700
Message-Id: <1175550151.22373.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 14:31 -0700, Christoph Lameter wrote:
> On Mon, 2 Apr 2007, Dave Hansen wrote:
> 
> > > > Hmmmmmmm.  Can we combine this with sparse_index_alloc()?  Also, why not
> > > > just use the slab for this?
> > > 
> > > Use a slab for page sized allocations? No.
> > 
> > Why not?  We use it above for sparse_index_alloc() and if it is doing
> > something wrong, I'd love to fix it.  Can you elaborate?
> 
> The slab allocator purposes is to deliver small sub page sized chunks.
> The page allocator is there to allocate pages. Both are optimized for its 
> purpose.

I understand that, in general, but how does that optimization help,
here, exactly?  My argument is that if we use the slab, it means more
code sharing with existing code in sparse.c.  Other than ideology, what
practical reasons are there in this case that keep us from doing that
otherwise attractive code sharing.

> > > I just extended this in V2 to also work on IA64. Its pretty generic.
> > 
> > Can you extend it to work on ppc? ;)
> 
> I do not know enough about how ppc handles large pages.

I don't think the pagetable walks are generic enough to ever get used on
ppc, unless they start walking the Linux pagetables for the kernel
virtual address area.  I was trying to poke you into getting the
pagetable walks out of sparse.c. ;)

> > > > Then, do whatever magic you want in alloc_vmemmap().
> > > 
> > > That would break if alloc_vmemmap returns NULL because it cannot allocate 
> > > memory.
> > 
> > OK, that makes sense.  However, it would still be nice to hide that
> > #ifdef somewhere that people are a bit less likely to run into it.  It's
> > just one #ifdef, so if you can kill it, great.  Otherwise, they pile up
> > over time and _do_ cause real readability problems.
> 
> Well think about how to handle the case that the allocatiopn of a page 
> table page or a vmemmap block fails. Once we have that sorted out then we 
> can cleanup the higher layers.

I think it is best to just completely replace
sparse_early_mem_map_alloc() for the vmemmap case.  It really is a
completely different beast.  You'd never, for instance, have
alloc_remap() come into play.

-- Dave

