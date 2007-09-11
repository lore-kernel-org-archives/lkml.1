Return-Path: <linux-kernel-owner+w=401wt.eu-S970832AbXILRnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970832AbXILRnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762900AbXILRmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:42:49 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:33499 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761523AbXILRms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:42:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=SEYts52/OkU6kng5mJoTo4JGyqi7N1/uJUkww3HB+H9XGXGbUBN1MLhcY6j7QYzTDbIvepjjGuITwVOOObVsKhnK69GzI9/4aAW6HKSOK4BSlL5r5fMthu/0bij4+LEkU7Kwl8ss1Q2cQ9QM/ir8ZAeKrviyQz+b37pypgc1U3g=  ;
X-YMail-OSG: mg.K0toVM1lwlddhrBw6McE2dy0WGA64uenPrBMV1n5MG7Tm
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Wed, 12 Sep 2007 04:07:47 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111606.10873.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709120407.48344.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 07:52, Christoph Lameter wrote:
> On Tue, 11 Sep 2007, Nick Piggin wrote:
> > > No you have not explained why the theoretical issues continue to exist
> > > given even just considering Lumpy Reclaim in .23 nor what effect the
> > > antifrag patchset would have.
> >
> > So how does lumpy reclaim, your slab patches, or anti-frag have
> > much effect on the worst case situation? Or help much against a
> > targetted fragmentation attack?
>
> F.e. Lumpy reclaim reclaim neighboring pages and thus works against
> fragmentation. So your formulae no longer works.

OK, I'll describe how it works and what the actual problem with it is. I
haven't looked at the patches for a fair while so you can forgive my
inaccuracies in terminology or exact details.

So anti-frag groups memory into (say) 2MB chunks. Top priority heuristic
is that allocations which are movable all go into groups with other movable
memory and allocations which are not movable do not go into these
groups. This is flexible though, so if a workload wants to use more non
movable memory, it is allowed to eat into first free, then movable
groups after filling all non-movable groups. This is important because
it is what makes anti-frag flexible (otherwise it would just be a memory
reserve in another form).

In my attack, I cause the kernel to allocate lots of unmovable allocations
and deplete movable groups. I theoretically then only need to keep a
small number (1/2^N) of these allocations around in order to DoS a
page allocation of order N.

And it doesn't even have to be a DoS. The natural fragmentation
that occurs today in a kernel today has the possibility to slowly push out
the movable groups and give you the same situation.

Now there are lots of other little heuristics, *including lumpy reclaim
and various slab reclaim improvements*, that improve the effectiveness
or speed of this thing, but at the end of the day, it has the same basic
issues. Unless you can move practically any currently unmovable
allocation (which will either be a lot of intrusive code or require a
vmapped kernel), then you can't get around the fundamental problem.
And if you do get around the fundamental problem, you don't really
need to group pages by mobility any more because they are all
movable[*].

So lumpy reclaim does not change my formula nor significantly help
against a fragmentation attack. AFAIKS.

[*] ok, this isn't quite true because if you can actually put a hard limit on
unmovable allocations then anti-frag will fundamentally help -- get back to
me on that when you get patches to move most of the obvious  ones.
Like pinned dentries, inodes, buffer heads, page tables, task structs, mm
structs, vmas, anon_vmas, radix-tree nodes, etc.


> > > And you have used a 2M pagesize which is
> > > irrelevant to this patchset that deals with blocksizes up to 64k. In my
> > > experience the use of blocksize < PAGE_COSTLY_ORDER (32k) is reasonably
> > > safe.
> >
> > I used EXACTLY the page sizes that you brought up in your patch
> > description (ie. 64K and 2MB).
>
> The patch currently only supports 64k.

Sure, and I pointed out the theoretical figure for 64K pages as well. Is that
figure not problematic to you? Where do you draw the limit for what is
acceptable? Why? What happens with tiny memory machines where a reserve
or even the anti-frag patches may not be acceptable and/or work very well?
When do you require reserve pools? Why are reserve pools acceptable for
first-class support of filesystems when it has been very loudly been made a
known policy decision by Linus in the past (and for some valid reasons) that
we should not put limits on the sizes of caches in the kernel.
