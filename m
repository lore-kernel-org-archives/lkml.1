Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYCJFQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYCJFQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 01:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYCJFQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 01:16:08 -0400
Received: from mail.suse.de ([195.135.220.2]:59107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbYCJFQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 01:16:06 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 10 Mar 2008 16:15:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18388.50188.552322.780524@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 00/28] Swap over NFS -v16
In-Reply-To: message from Peter Zijlstra on Friday March 7
References: <20080220144610.548202000@chello.nl>
	<20080223000620.7fee8ff8.akpm@linux-foundation.org>
	<18371.43950.150842.429997@notabene.brown>
	<1204023042.6242.271.camel@lappy>
	<18372.64081.995262.986841@notabene.brown>
	<1204099113.6242.353.camel@lappy>
	<1837 <1204626509.6241.39.camel@lappy>
	<18384.46967.583615.711455@notabene.brown>
	<1204888675.8514.102.camel@twins>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday March 7, a.p.zijlstra@chello.nl wrote:
> Hi Neil,
> 
> I'm so glad you are working with me on this and writing this in human
> English. It seems to be my eternal short-comming to communicate my ideas
> clearly :-/. Thanks for your effort!

:-)
It always helps to have a second brain with a different perspective.


> 
> On Fri, 2008-03-07 at 14:33 +1100, Neil Brown wrote:
> > 
> > [I don't find the above wholly satisfying.  There seems to be too much
> >  hand-waving.  If someone can provide better text explaining why
> >  swapout is a special case, that would be great.]
> 
> Anonymous pages are dirty by definition (except the zero page, but I
> think we recently ditched it). So shrinking of the anonymous pool will
> require swapping.

Well, there is the swap cache.  That's probably what I was thinking of
when I said "clean anonymous pages".  I suspect they are the first to
go!

> 
> It is indeed the last refuge for those with GFP_NOFS. Allong with the
> strict limit on the amount of dirty file pages it also ensures writing
> those out will never deadlock the machine as there are always clean file
> pages and or anonymous pages to launder.

The difficulty I have is justifying exactly why page-cache writeout
will not deadlock.  What if all the memory that is not dirty-pagecache
is anonymous, and if swap isn't enabled?
Maybe the number returned by "determine_dirtyable_memory" in
page-writeback.c excludes anonymous pages?  I wonder if the meaning of
NR_FREE_PAGES, NR_INACTIVE, etc is documented anywhere....

...
> 
> Right. I've had a long conversation on PG_emergency with Pekka. And I
> think the conclusion was that PG_emergency will create more head-aches
> than it solves. I probably have the conversation in my IRC logs and
> could email it if you're interested (and Pekka doesn't object).

Maybe that depends on the exact semantic of PG_emergency ??
I remember you being concerned that PG_emergency never changes between
allocation and freeing, and that wouldn't work well with slub.
My envisioned semantic has it possibly changing quite often.
What it means is:
   The last allocation done from this page was in a low-memory
   condition.

You really need some way to tell if the result of kmalloc/kmemalloc
should be treated as reserved.
I think you had code which first tried the allocation without
GFP_MEMALLOC and then if that failed, tried again *with*
GFP_MEMALLOC.  If that then succeeded, it is assumed to be an
allocation from reserves.  That seemed rather ugly, though I guess you
could wrap it in a function to hide the ugliness:

void *kmalloc_reserve(size_t size, int *reserve, gfp_t gfp_flags)
{
	void *result = kmalloc(size, gfp_flags & ~GFP_MEMALLOC);
	if (result) {
		*reserve = 0;
		return result;
	}
	result = kmalloc(size, gfp_flags | GFP_MEMALLOC);
	if (result) {
		*reserve = 1;
		return result;
	}
	return NULL;
}
???

> 
> I've already heard interest from other people to use these hooks to
> provide swap on other non-block filesystems such as jffs2, logfs and the
> like.

I'm interested in the swap_in/swap_out interface for external
write-intent bitmaps for md/raid arrays.
You can have a write-intent bitmap which records which blocks might be
dirty if the host crashes, so that resync is much faster.
It can be stored in a file in a separate filesystem, but that is
currently implemented by using bmap to enumerate the blocks and then
reading/writing directly to the device (like swap).  Your interface
would be much nicer for that (not that I think having a
write-intent-bitmap on an NFS filesystem would be a clever idea ;-)

I'll look forward to your next patch set....

One thing I had thought odd while reading the patches, but haven't
found an opportunity to mention before, is the "IS_SWAPFILE" test in
nfs-swapper.patch.
This seems like a layering violation.  It would be better if the test
was based on whether  ->swapfile had been called on the file.  That way
my write-intent-bitmaps would get the same benefit.

NeilBrown
