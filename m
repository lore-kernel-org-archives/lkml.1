Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZJGJ5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZJGJ5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbZJGJ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:57:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39719 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZJGJ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:57:34 -0400
Date: Wed, 7 Oct 2009 11:56:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091007095657.GB8703@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007085849.GN30316@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07 2009, Nick Piggin wrote:
> On Tue, Oct 06, 2009 at 02:49:41PM +0200, Jens Axboe wrote:
> > On Tue, Oct 06 2009, Nick Piggin wrote:
> > > It's a copout, but you could try running multiple dbenches under
> > > different working directories (or actually, IIRC dbench does root
> > > based path lookups so maybe that won't help you much).
> > 
> > Yeah, it's hitting dentry->d_lock pretty hard so basically
> > spin-serialized at that point.
> > 
> > > > Anyway, below are the results. Seem very stable.
> > > > 
> > > >                                 throughput
> > > > ------------------------------------------------
> > > > 2.6.32-rc3-git          |      561.218 MB/sec
> > > > 2.6.32-rc3-git+patch    |      627.022 MB/sec
> > > 
> > > Well it's good to see you got some improvement.
> > 
> > Yes, it's an improvement though the results are still pretty abysmal :-)
> 
> OK, I have a really basic patch that does store-free path walking
> (except on the final element). dbench is pretty nasty still because
> it seems to do a lot of stupid things like reading from /proc/mounts
> all the time.
> 
> Actually it isn't quite store-free because it still takes mnt ref
> (which is hard to avoid, but at least it is a per-cpu data). So
> this patch applies on top of my recent patchset. At least it does
> not store to the dentries.
> 
> Basically it is holding rcu_read_lock for the entire walk, it uses
> inode RCU from my earlier patches to check inode permissions, and
> it bails out at the slightest sign of trouble :) (actually I think
> I have got it to walk mountpoints which is nice).
> 
> The seqlock in the dentry is for getting consistent name,len pointer,
> and also not giving a false positive if a rename has partially
> overwritten the name string (false negatives are always fine in the
> lock free lookup path but false positives are not). Possibly we
> could make do with a per-sb seqlock for this (or just rename_lock).
> 
> I have duplicated most of the lookup code, altering it to the lock
> free version, which returns -EAGAIN if it gets in trouble and the
> regular path walk starts up. I don't know if this is the best way
> to go... it's fairly easy but a bit ugly. But complexifying the
> existing path walk any more would not be nice either. It might be
> nice to try locking the dentry that we're having trouble with and
> continuing from there, rather than redoing the whole walk with
> locks...
> 
> Anyway, this is the basics working for now, microbenchmark shows
> same-cwd lookups scale linearly now too. We can probably slowly
> tackle more cases if they come up as being important, simply by
> auditing filesystems etc.

                                throughput
------------------------------------------------
2.6.32-rc3-git          |      561.218 MB/sec
2.6.32-rc3-git+patch    |      627.022 MB/sec
2.6.32-rc3-git+patch+inc|      969.761 MB/sec

So better, quite a bit too. Latencies are not listed here, but they are
also a lot better. Perf top still shows ~95% spinlock time. I did a
shorter run (the above are full 600 second runs) of 60s with profiling
and the full 64 clients, this time using -a as well (which generated
9.4GB of trace data!). The top is now:

_spin_lock (92%)
        path_get (39%)
                d_path (59%)
                path_init (26%)
                path_walk (13%)
        dput (37%)
                path_put (86%)
                link_path_walk (13%)
        __d_path (23%)

And finally, this:

> +	if (!nd->dentry->d_inode) {
> +		spin_unlock(&nd->path.dentry->d_lock);
> +		return -EAGAIN;
> +	}

doesn't compile, it wants to be

        if (!nd->path.dentry->d_inode) {

-- 
Jens Axboe

