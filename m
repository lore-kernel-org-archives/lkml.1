Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbXIKVmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbXIKVmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXIKVmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:42:06 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:20214 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757614AbXIKVmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:42:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ynJydmWenMCeRE2R+i1rZM76p7i2Ehv4eDUfpeRNAVz4y8HtZY3FNgrmMjdkJZn5JQafxPyhngnDTJWAry7IwQvMsUVyUg6uNQQoowvCj8bEey5f6AgeoIn6/5aw4n9VN7C2E+Iq7bd1/j/JTGfWZF4r7XLFhuYmN2ru3vVfsCw=  ;
X-YMail-OSG: cEJUomwVM1mFFhvrpeHhl7Mp8EVo02LqC.Wh8vvY.GbBYaHsuRueHkbHkYpQZF8q2hfb8WMCeA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Tue, 11 Sep 2007 16:00:17 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709111144.48743.nickpiggin@yahoo.com.au> <20070911205350.GA18127@skynet.ie>
In-Reply-To: <20070911205350.GA18127@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111600.18756.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007 06:53, Mel Gorman wrote:
> On (11/09/07 11:44), Nick Piggin didst pronounce:

> However, this discussion belongs more with the non-existant-remove-slab
> patch. Based on what we've seen since the summits, we need a thorough
> analysis with benchmarks before making a final decision (kernbench, ebizzy,
> tbench (netpipe if someone has the time/resources), hackbench and maybe
> sysbench as well as something the filesystem people recommend to get good
> coverage of the subsystems).

True. Aside, it seems I might have been mistaken in saying Christoph
is proposing to use higher order allocations to fix the SLUB regression.
Anyway, I agree let's not get sidetracked about this here.


> I'd rather not get side-tracked here. I regret you feel stream-rolled but I
> think grouping pages by mobility is the right thing to do for better usage
> of the TLB by the kernel and for improving hugepage support in userspace
> minimally. We never really did see eye-to-eye but this way, if I'm wrong
> you get to chuck eggs down the line.

No it's a fair point, and even the hugepage allocations alone are a fair
point. From the discussions I think it seems like quite probably the right
thing to do pragmatically, which is what Linux is about and I hope will
result in a better kernel in the end. So I don't have complaints except
from little ivory tower ;)


> > Sure. And some people run workloads where fragmentation is likely never
> > going to be a problem, they are shipping this poorly configured hardware
> > now or soon, so they don't have too much interest in doing it right at
> > this point, rather than doing it *now*. OK, that's a valid reason which
> > is why I don't use the argument that we should do it correctly or never
> > at all.
>
> So are we saying the right thing to do is go with fs-block from day 1 once
> we get it to optimistically use high-order pages? I think your concern
> might be that if this goes in then it'll be harder to justify fsblock in
> the future because it'll be solving a theoritical problem that takes months
> to trigger if at all. i.e. The filesystem people will push because
> apparently large block support as it is solves world peace. Is that
> accurate?

Heh. It's hard to say. I think fsblock could take a while to implement,
regardless of high order pages or not. I actually would like to be able
to pass down a mandate to say higher order pagecache will never
get merged, simply so that these talented people would work on
fsblock ;)

But that's not my place to say, and I'm actually not arguing that high
order pagecache does not have uses (especially as a practical,
shorter-term solution which is unintrusive to filesystems).

So no, I don't think I'm really going against the basics of what we agreed
in Cambridge. But it sounds like it's still being billed as first-order
support right off the bat here.


> > OTOH, I'm not sure how much buy-in there was from the filesystems guys.
> > Particularly Christoph H and XFS (which is strange because they already
> > do vmapping in places).
>
> I think they use vmapping because they have to, not because they want
> to. They might be a lot happier with fsblock if it used contiguous pages
> for large blocks whenever possible - I don't know for sure. The metadata
> accessors they might be unhappy with because it's inconvenient but as
> Christoph Hellwig pointed out at VM/FS, the filesystems who really care
> will convert.

Sure, they would rather not to. But there are also a lot of ways you can
improve vmap more than what XFS does (or probably what darwin does)
(more persistence for cached objects, and batched invalidates for example).
There are also a lot of trivial things you can do to make a lot of those
accesses not require vmaps (and less trivial things, but even such things
as binary searches over multiple pages should be quite possible with a bit
of logic).


> > It would be interesting to craft an attack. If you knew roughly the
> > layout and size of your dentry slab for example... maybe you could stat a
> > whole lot of files, then open one and keep it open (maybe post the fd to
> > a unix socket or something crazy!) when you think you have filled up a
> > couple of MB worth of them.
>
> I might regret saying this, but it would be easier to craft an attack
> using pagetable pages. It's woefully difficult to do but it's probably
> doable. I say pagetables because while slub targetted reclaim is on the
> cards and memory compaction exists for page cache pages, pagetables are
> currently pinned with no prototype patch existing to deal with them.

But even so, you can just hold an open fd in order to pin the dentry you
want. My attack would go like this: get the page size and allocation group
size for the machine, then get the number of dentries required to fill a
slab. Then read in that many dentries and pin one of them. Repeat the
process. Even if there is other activity on the system, it seems possible
that such a thing will cause some headaches after not too long a time.
Some sources of pinned memory are going to be better than others for
this of course, so yeah maybe pagetables will be a bit easier (I don't know).


> > Then I would love to say #2 will go ahead (and I hope it would), but I
> > can't force it down the throat of the filesystem maintainers just like I
> > feel they can't force vm devs (me) to do a virtually mapped and
> > defrag-able kernel :) Basically I'm trying to practice what I preach and
> > I don't want to force fsblock onto anyone.
>
> If the FS people really want it and they insist that this has to be a
> #1 citizen then it's fsblock or make something new up.

Well I'm glad you agree :) I think not all do, but as you say maybe the
only thing is just to leave it up to the individual filesystems...
