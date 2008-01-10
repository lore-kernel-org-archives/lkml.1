Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYAJKCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYAJKCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYAJKC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:02:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:14528 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbYAJKCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:02:24 -0500
Date: Thu, 10 Jan 2008 11:02:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Message-ID: <20080110100221.GW6258@kernel.dk>
References: <20080109085231.GE6650@kernel.dk> <200801101242.25671.nickpiggin@yahoo.com.au> <20080110083753.GB10745@infradead.org> <1199957821.29498.2.camel@twins> <20080110094941.GV6258@kernel.dk> <1199958771.29498.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199958771.29498.4.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008, Peter Zijlstra wrote:
> 
> On Thu, 2008-01-10 at 10:49 +0100, Jens Axboe wrote:
> > On Thu, Jan 10 2008, Peter Zijlstra wrote:
> > > 
> > > On Thu, 2008-01-10 at 08:37 +0000, Christoph Hellwig wrote:
> > > 
> > > > Peter, any chance you could chime in here?
> > > 
> > > I have this patch to add swap_out/_in methods. I expect we can loosen
> > > the requirement for swapcache pages and change the name a little.
> > > 
> > > previously posted here:
> > >   http://lkml.org/lkml/2007/5/4/143
> > > 
> > > --- 
> > > Subject: mm: add support for non block device backed swap files
> > > 
> > > New addres_space_operations methods are added:
> > >   int swapfile(struct address_space *, int);
> > >   int swap_out(struct file *, struct page *, struct writeback_control *);
> > >   int swap_in(struct file *, struct page *);
> > > 
> > > When during sys_swapon() the swapfile() method is found and returns no error
> > > the swapper_space.a_ops will proxy to sis->swap_file->f_mapping->a_ops, and
> > > make use of swap_{out,in}() to write/read swapcache pages.
> > > 
> > > The swapfile method will be used to communicate to the address_space that the
> > > VM relies on it, and the address_space should take adequate measures (like 
> > > reserving memory for mempools or the like).
> > > 
> > > This new interface can be used to obviate the need for ->bmap in the swapfile
> > > code. A filesystem would need to load (and maybe even allocate) the full block
> > > map for a file into memory and pin it there on ->swapfile(,1) so that
> > > ->swap_{out,in}() have instant access to it. It can be released on
> > > ->swapfile(,0).
> > 
> > So this is where I don't think that's good enough, you cannot require a
> > full block/extent mapping of a file on setup. It can take quite some
> > time, a little testing I did here easily took 5 seconds for only a
> > couple of gigabytes. And that wasn't even worst case for that size. It
> > also wastes memory by populating extents that we may never read or
> > write.
> > 
> > If you look at the loop addition I did, it populates lazily as needed
> > with some very simple logic to populate-ahead. In practice that performs
> > as well as a pre-populated map, the first IO to a given range will just
> > be a little slower since we have to bmap() it.
> > 
> > Do you have plans to improve this area?
> 
> Nope, for swap it _must_ be there, there is just no way we can do block
> allocation on swapout.

I appreciate that fact, just saying that we could have more flexibility
for other uses.

> That said, the swapfile() interface can be used to pre-populate the
> extend/block mapping, and when using swap_(in/out) without it, it can be
> done lazily.

I think the interface is too simple, I would much rather have a way to
dig into the file mappings and be allowed to request population and so
on. Without that, it can't be used for eg loop.

-- 
Jens Axboe

