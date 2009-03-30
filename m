Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbZC3NAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbZC3NAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZC3M7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:59:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:45958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbZC3M7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:59:49 -0400
Date: Mon, 30 Mar 2009 14:59:46 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 12/14] fs: dcache per-bucket dcache hash locking
Message-ID: <20090330125946.GM31000@wotan.suse.de>
References: <20090329155539.275927173@nick.local0.net> <20090329155750.062096365@nick.local0.net> <878wmnnr73.fsf@basil.nowhere.org> <20090330122712.GF31000@wotan.suse.de> <20090330124735.GK11935@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330124735.GK11935@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:47:35PM +0200, Andi Kleen wrote:
> On Mon, Mar 30, 2009 at 02:27:12PM +0200, Nick Piggin wrote:
> > It's interesting. I suspect that with the size of the dcache hash,
> > if we assume pretty random distribution of access patterns, then
> > it might be unlikely to get much common cache lines (ok, birthday
> 
> The problem is that you increase the cache foot print overall
> because these hash tables are gigantic. And because it's random
> there will not be much locality. That is your hash table
> might still fit when you're lucky, but then if the rest
> of your workload needs a lot of cache too you might
> end up with a cache miss on every access.

Hmm, I disagree in general because the hash table is so big, then
it is very unlikely to get much sharing whether or not we double
the size of it. Even if we only use a few dentries in the workload,
they will be scattered all over the table and each lookup will use
one cacheline regardless of the bucket head size.

Wheras if we have to go to another lock table each time, then we
have to touch 2 cachelines per lookup.

Actually I have patches floating around to be able to dynamically
resize the dcache hash table, and in that case it actually would
be able to make it very small and fit in cache for workloads that
don't have too many dentries.

But anyway let's not worry too much about this yet. I agree it
has downsides whatever direction we go, so we can discuss or
measure after the basics of the patchset are more mature.


> False sharing is not the issue with the big lock hash typically, that was 
> more as an issue for a potential separate hash table design 
> (I guess my original sentence was a bit confusing)
> 
> BTW the alternative would be to switch the hash table to some
> large fan out tree indexed by the string hash value and then use
> the standard lockless algorithms on that.

Well yes that's the other thing we could try.
