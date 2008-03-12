Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbYCLQkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbYCLQkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYCLQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:40:40 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:56374 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYCLQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EW8s4kM/aSAZCJOL8QfwuXS6juBFhE6HjGBdhaxIG7HVLyiwgE6p1YL5h1lMEAvZ5MbbK30mjPblZFGIERzXG3nWE9bG/D63UZQxLN59qB5TMjkViyP6N96DC7xGIaLcrJaHJx67KAGTIjkOPsVUGL2mQxqM5eBAX4cIGWQng0o=
Message-ID: <86802c440803120940y1e8643ecv3657019f206aa11e@mail.gmail.com>
Date: Wed, 12 Mar 2008 09:40:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: make mem_map allocation continuous.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20080312113902.GA16192@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
	 <20080311081410.GA24240@elte.hu> <20080312113902.GA16192@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 4:39 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On (11/03/08 09:14), Ingo Molnar didst pronounce:
>
>
> >
>  > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  >
>  > > [PATCH] mm: make mem_map allocation continuous.
>  > >
>  > > vmemmap allocation current got
>  > >  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
>  > >  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001800000 on node 0
>  > >  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001c00000 on node 0
>  > >  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002000000 on node 0
>  > >  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002400000 on node 0
>  > > ...
>  > >
>  > > there is 2M hole between them.
>  > >
>  > > the rootcause is that usemap (24 bytes) will be allocated after every 2M
>  > > mem_map. and it will push next vmemmap (2M) to next align (2M).
>  > >
>  > > solution:
>  > > try to allocate mem_map continously.
>  > >
>  > > after patch, will get
>  > >  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
>  > >  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
>  > >  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
>  > >  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
>  > >  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
>  > > ...
>  > > and usemap will share in page because of they are allocated continuously too.
>  > > sparse_early_usemap_alloc: usemap = ffff810024e00000 size = 24
>  > > sparse_early_usemap_alloc: usemap = ffff810024e00080 size = 24
>  > > sparse_early_usemap_alloc: usemap = ffff810024e00100 size = 24
>  > > sparse_early_usemap_alloc: usemap = ffff810024e00180 size = 24
>  > > ...
>  > >
>  > > so we make the bootmem allocation more compact and use less memory for usemap.
>  > >
>  > > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > very nice fix!
>  >
>
>  Agreed, good work.
>
>
>  > i suspect this patch should go via -mm.
>  >
>  > >     usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
>  > > +   printk(KERN_INFO "sparse_early_usemap_alloc: usemap = %p size = %ld\n", usemap, usemap_size());
>  >
>  > this should be in a separate patch.
>  >
>
>  Should this be KERN_DEBUG instead of KERN_INFO?
yes. to KERN_DEBUG or removed.
>
>  I don't have the original mail because I got unsubscribed from the lists
>  a few days ago and didn't notice (have been having mail issues) so
>  pardon awkward cut & pastes
>
>
>  > +/* section_map pointer array is 64k */
>  > +static __initdata struct page *section_map[NR_MEM_SECTIONS];
>
>  The size of this varies depending on architecture so the comment may be
>  misleading.  Maybe a comment like the following would be better?
>
>  /*
>   * The portions of the mem_map used by SPARSEMEM are allocated in
>   * batch and temporarily stored in this array. When sparse_init()
>   * completes, the array is discarded
>   */
Yes. for x86_64 is (1<<13)*8 at most. others should much less.
>
>  I can see why you file-scoped it because its too large for the stack but
>  would it be better to allocate it from bootmem instead? It is
>  available by the time you need to use the array.
Yes.
need to after another patch I sent out yesterday to make
free_bootmem_core could handle out of range inputs.

then could use alloc_bootmem and
for_each_online_node(node)
             free_bootmem_node(node, section_map, size);

will send delta to Andrew.

YH

YH
