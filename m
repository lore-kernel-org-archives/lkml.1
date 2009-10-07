Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZJGKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZJGKLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZJGKLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:11:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:42263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZJGKL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:11:29 -0400
Date: Wed, 7 Oct 2009 12:10:52 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091007101052.GP30316@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <20091007095657.GB8703@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007095657.GB8703@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:56:57AM +0200, Jens Axboe wrote:
> On Wed, Oct 07 2009, Nick Piggin wrote:
> > Anyway, this is the basics working for now, microbenchmark shows
> > same-cwd lookups scale linearly now too. We can probably slowly
> > tackle more cases if they come up as being important, simply by
> > auditing filesystems etc.
> 
>                                 throughput
> ------------------------------------------------
> 2.6.32-rc3-git          |      561.218 MB/sec
> 2.6.32-rc3-git+patch    |      627.022 MB/sec
> 2.6.32-rc3-git+patch+inc|      969.761 MB/sec
> 
> So better, quite a bit too. Latencies are not listed here, but they are
> also a lot better. Perf top still shows ~95% spinlock time. I did a
> shorter run (the above are full 600 second runs) of 60s with profiling
> and the full 64 clients, this time using -a as well (which generated
> 9.4GB of trace data!). The top is now:
> 
> _spin_lock (92%)
>         path_get (39%)
>                 d_path (59%)
>                 path_init (26%)
>                 path_walk (13%)
>         dput (37%)
>                 path_put (86%)
>                 link_path_walk (13%)
>         __d_path (23%)

path_init, path_walk, and link_path_walk are all non-lockless
variants, so the RCU walk is dropping out in some cases. path_put
will be significantly coming from locked lookups too. It could be
improved by expanding the cases we do lockless walk for (or
allowing a lockless walk to turn into a locked walk part-way
through, rather than restarting the whole thing, which is probably
a very good idea anyway).

d_path and __d_path are... I think dbench doing something stupid.
Although even those could possibly be optimised to avoid d_lock
as well... Although after looking at strace from dbench, I'd
rather take profiles from real workloads before adding complexity
(or even a real samba serving a netbench workload would be
preferable to dbench, I think).

But it's always nice to see numbers and results. Nearly 2x
increase isn't too bad, even if it is still horribly choked.


> And finally, this:
> 
> > +	if (!nd->dentry->d_inode) {
> > +		spin_unlock(&nd->path.dentry->d_lock);
> > +		return -EAGAIN;
> > +	}
> 
> doesn't compile, it wants to be
> 
>         if (!nd->path.dentry->d_inode) {

Ah thanks, forgot to refresh.

