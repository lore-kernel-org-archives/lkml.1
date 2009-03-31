Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbZCaB52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbZCaB52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZCaB5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:57:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbZCaB5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:57:16 -0400
Date: Tue, 31 Mar 2009 03:57:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 12/14] fs: dcache per-bucket dcache hash locking
Message-ID: <20090331015712.GC3555@wotan.suse.de>
References: <20090329155539.275927173@nick.local0.net> <20090329155750.062096365@nick.local0.net> <878wmnnr73.fsf@basil.nowhere.org> <20090330180031.GB1041@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330180031.GB1041@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 02:00:31PM -0400, Christoph Hellwig wrote:
> On Mon, Mar 30, 2009 at 02:14:08PM +0200, Andi Kleen wrote:
> > npiggin@suse.de writes:
> > 
> > > We can turn the dcache hash locking from a global dcache_hash_lock into
> > > per-bucket locking.
> > 
> > Per bucket locking is typically a bad idea because you get far too
> > many locks and you increase cache footprint with all of them. It's
> > typically better to use a second much smaller hash table that only has
> > locks (by just shifting the hash value down some more) 
> > Just need to be careful to avoid too much false sharing.
> 
> Yeah, I'm also not too happy about it.  I think we're better off
> replacing the global hash with more fine-grained structures.  That might
> even some sort of simplistic tree hanging of directory dentries.
> 
> The hard part in getting anything like this done was always the amount
> of different things dcache_lock protects besiseds the hash, but Nick's
> earlier patches when actually fully implemented should sort that out.

Well yes that's the thing, dcache_hash_lock becomes inner-most and
very simply protecting dentry hash and d_hash, so it should now
be quite trivial (locking-wise) to experiment with other data
structures.

Of course any proposed new data structure will have to compete with
a scaled hash table... whether we scale it the dumb way like I did
or something like Andi suggests, I don't really know. But just to
be clear, the point of that patch is more to show how it is possible
to easily change locking. The really important parts of my series for
the moment are the first half of actually breaking up dcache_lock.

Anyway, no real objections yet, so I'll continue down this path and
see what I come up with.

If anybody knows of workloads or benchmarks to try, also let me know.
The patchset posted improved dbench-in-ram performance by about 1.6x
on my 2s8c system here so it is encouraging but not the most realistic
test :)

