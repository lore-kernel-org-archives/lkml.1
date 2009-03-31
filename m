Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZCaLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZCaLRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZCaLRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:17:07 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35440 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZCaLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:17:06 -0400
Date: Tue, 31 Mar 2009 12:17:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: add_to_swap_cache with GFP_ATOMIC ?
In-Reply-To: <28c262360903310338k20b8eebbncb86baac9b09e54@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0903311154570.19028@blonde.anvils>
References: <28c262360903310338k20b8eebbncb86baac9b09e54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Minchan Kim wrote:
> 
> I don't know why we should call add_to_swap_cache with GFP_ATOMIC ?
> Is there a special something for avoiding blocking?

add_to_swap_cache itself does not need to be called with GFP_ATOMIC.

There are three places from which it is called:

read_swap_cache_async (typically used when faulting) masks the
gfp_mask coming in (typically GFP_HIGHUSER_MOVABLE for the pages
themselves) to call add_to_swap_cache typically with GFP_KERNEL.

shmem_writepage does call it with GFP_ATOMIC: that's because it's
holding the shmem_inode's spin_lock while it switches the page between
file cache and swap cache - IIRC holding page lock isn't quite enough
for that, because of other cases; but I've not thought that through
in a long time, we could re-examine if it troubles you.

The questionable one is add_to_swap (when vmscanning), which calls
it with __GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, i.e. GFP_ATOMIC
plus __GFP_NOMEMALLOC|__GFP_NOWARN.  That one I have wondered
about from time to time: GFP_NOIO would be the obvious choice,
that's what swap_writepage will use to allocate bio soon after.

I've been tempted to change it, but afraid to touch that house
of cards, and afraid of long testing and justification required.
Would it be safe to drop that __GFP_HIGH?  What's the effect of the
__GFP_NOMEMALLOC (we've layer on layer of tweak this one way because
we're in the reclaim path so let it eat more, then tweak it the other
way because we don't want it to eat up _too_ much).  I just let it stay.

Hugh
