Return-Path: <linux-kernel-owner+w=401wt.eu-S934788AbXEHItO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788AbXEHItO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934781AbXEHItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:49:12 -0400
Received: from holomorphy.com ([66.93.40.71]:58412 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934778AbXEHItK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:49:10 -0400
Date: Tue, 8 May 2007 01:49:07 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070508084907.GB31925@holomorphy.com>
References: <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org> <20070427164535.GH24852@thunk.org> <m1abwku30d.fsf@ebiederm.dsl.xmission.com> <20070507042925.GT32602149@melbourne.sgi.com> <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com> <20070507052729.GV32602149@melbourne.sgi.com> <m17irlkubc.fsf@ebiederm.dsl.xmission.com> <20070507064925.GB19966@holomorphy.com> <20070507070638.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507070638.GC19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 12:06:38AM -0700, William Lee Irwin III wrote:
> +int alloc_page_array(struct pagearray *, const int, const size_t);
> +void free_page_array(struct pagearray *);
> +void zero_page_array(struct pagearray *);
> +struct page *nopage_page_array(const struct vm_area_struct *, unsigned long, unsigned long, int *, struct pagearray *);
> +int mmap_page_array(const struct vm_area_struct *, struct pagearray *, const size_t, const size_t);
> +int copy_page_array_to_user(struct pagearray *, void __user *, const size_t, const size_t);
> +int copy_page_array_from_user(struct pagearray *, void __user *, const size_t, const size_t);
> +struct scatterlist *pagearray_to_scatterlist(struct pagearray *, size_t, size_t, int *);
> +void *vmap_pagearray(struct pagearray *);

This should probably have memcpy to/from pagearrays. Whole-hog read
and write f_op implementations would be good, too, since ISTR some
drivers basically do little besides that on their internal buffers.

vmap_pagearray() should take flags, esp. VM_IOREMAP but perhaps also
protections besides PAGE_KERNEL in case uncachedness is desirable. I'm
not entirely sure what it'd be used for if discontiguity is so heavily
supported. My wild guess is drivers that do things that are just too
weird to support with the discontig API, since that's how I used it.
It should support vmap()'ing interior sub-ranges, too.

The pagearray mmap() support is schizophrenic as to whether it prefills
or faults and not all that complete as far as manipulating the mmap()
goes. Shooting down ptes, flipping pages, or whatever drivers actually
do with the things should have helpers arranged. Coherent sets of
helpers for faulting vs. mmap()'ing idioms would be good.

pagearray_to_scatterlist() should probably take the scatterist as an
argument instead of allocating the scatterlist itself.

Something to construct bio's from pagearrays might help.

s/page_array/pagearray/g should probably be done. Prefixing with
pagearray_ instead of randomly positioning it within the name would
be good, too.

Some working API conversions on drivers sound like a good idea. I had
some large number of API conversions about, now lost, but they'd be
bitrotted anyway.

struct pagearray is better off as an opaque type so large pagearray
handling can be added in later via radix trees or some such, likewise
for expansion and contraction. Keeping drivers' hands off the internals
is just a good idea in general.

I'm somewhat less clear on what filesystems need to do here, or if it
would be useful for them to efficiently manipulate data inside a
large block that spans multiple discontiguous pages. I expect some
changes are needed at the very least to fill a pagearray with whatever
predetermined pages are needed. Filesystems probably need other changes
to handle sparse pagearrays and refilling pages within them via IO.


-- wli
