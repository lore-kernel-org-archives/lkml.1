Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbXD0HUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbXD0HUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXD0HUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:20:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57190 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755440AbXD0HTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:19:50 -0400
Date: Fri, 27 Apr 2007 00:19:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070426235542.bad7035a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org>
 <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Andrew Morton wrote:

> It's not exactly hard to lock four pages which are contiguous in pagecache,
> contiguous in physical memory and are contiguous in the radix-tree.

If you can find them....
 
 > > The patch is not about forcing to use large pages but about the option to 
> > use larger pages. Its a new flexibility.
> 
> That's just spin.

No its a fact. The patchset really allows one to switch large page 
support on and off. It opens up new options..

> > They are really larger. One page struct controls it all.
> 
> No it doesn't and please stop spinning.  x86 ptes map 4k pages and the core
> MM needs changes to continue to work with this hack in place.

The page cache is different from pte mapping. One page struct controls 
them all. Look at the patches. There is no state information in the tail
pages apart from pointing to the head page.
 
> If x86 had larger pagesize we wouldn't be seeing any of this.  It is a workaround
> for present-generation hardware.

Pagecache != mmap.

> > The patchset would reduce complexity and making it easy to handle the page 
> > cache. Gets rid of the hacks to support larger ones right now. Its 
> > straightforward, no new locking, very much a cleanup patch.
> 
> Were any cleanups made which were not also applicable as standalone things
> to mainline?

The page cache functions require a mapping parameter. This is available 
in most place and a natural thing given that allocation etc is also bound
to mapping information.

> > No it becomes easier. Look at the patchset. It cleans up a huge mess.
> 
> I see no cleanups which are not also applicable to mainline.

Not sure what you mean by that.

> > What is hacky about it?
> 
> It pretends that pages are large than they actually are, forcing the
> pte-management code to also play along with the pretence.
> 
> Pages *aren't* 16k.  They're 4k.

No they are 16k if the filesystem wants them to be 16k. The filesystem 
does not need to have the data mapped into an address space. And there is 
no problem with mapping 4k sections if we want to using the ptes.

> Please address my point: if in five years time x86 has larger or varible
> pagesize, this code will be a permanent millstone around our necks which we
> *should not have merged*.

No this code will enable us to switch to this new page size in a very fast 
way. Because the pagecache already supports it it is easier to add the 
mmap support for other page sizes.

> And if in five years time x86 does not have larger pagesize support then
> the manufacturers would have decided that 4k pages are not a performance
> problem, so we again should not have merged this code.

The manufacturers on x86 are already supporting 2M page sizes and cannot 
support intermediate sizes since they are married to the page table 
format for performance reasons. The patch could f.e. lead to 
straightforward support for 2M page mappings if we wanted it. 

> > It is the most consistent solution that avoid the proliferation of further 
> > hacks to address the large blocksize.
> 
> You cannot say this.  I'm sitting here *watching* you refuse to seriously
> consider alternatives.

And I am sitting here in disbelief about the series of weird alternatives 
running over my screen just to avoid the obvious solution. Then there is 
this weird idea that this would hinder us from supporting additional page 
sizes for mmap while the patch does exactly lead to enable support such 
features in the future.
  
> > And you've conspicuously failed to address my point regarding the
> *permanent* additional maintenance cost.

Where? The page cache handling in the various layers is significantly 
simplified which reduces maintenance cost.
  
> Anyway.  Let's await those performance numbers.  If they're notably good,
> and if we judge that this goodness will be realised on more than one
> arguably-crippled present-day disk adapter then we can evaluate the
> *various* options which we have for stuffing more data into that adapter.

One? Spin.... The majority you mean?

Dave, where are we with the performance tests?
