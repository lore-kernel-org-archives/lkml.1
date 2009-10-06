Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbZJFMuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbZJFMuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZJFMuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:50:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34464 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbZJFMuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:50:18 -0400
Date: Tue, 6 Oct 2009 14:49:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091006124941.GS5216@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006122623.GE30316@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Nick Piggin wrote:
> On Tue, Oct 06, 2009 at 12:14:14PM +0200, Jens Axboe wrote:
> > On Tue, Oct 06 2009, Nick Piggin wrote:
> > > Hi,
> > > 
> > > Several people have been interested to test my vfs patches, so rather
> > > than resend patches I have uploaded a rollup against Linus's current
> > > head.
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/
> > > 
> > > I have used ext2,ext3,autofs4,nfs as well as in-memory filesystems
> > > OK (although this doesn't mean there are no bugs!). Otherwise, if your
> > > filesystem compiles, then there is a reasonable chance of it working,
> > > or ask me and I can try updating it for the new locking.
> > > 
> > > I would be interested in seeing any numbers people might come up with,
> > > including single-threaded performance.
> > 
> > I gave this a quick spin on the 64-thread nehalem. Just a simple dbench
> > with 64 clients on tmpfs. The results are below. While running perf top
> > -a in mainline, the top 5 entries are:
> > 
> >           2086691.00 - 96.6% : _spin_lock
> >             14866.00 -  0.7% : copy_user_generic_string
> >              5710.00 -  0.3% : mutex_spin_on_owner
> >              2837.00 -  0.1% : _atomic_dec_and_lock
> >              2274.00 -  0.1% : __d_lookup
> > 
> > Uhm auch... It doesn't look much prettier for the patch kernel, though:
> > 
> >           9396422.00 - 95.7% : _spin_lock
> >             66978.00 -  0.7% : copy_user_generic_string
> >             43775.00 -  0.4% : dput
> >             23946.00 -  0.2% : __link_path_walk
> >             17699.00 -  0.2% : path_init
> >             15046.00 -  0.2% : do_lookup
> 
> Yep, this is the problem of the common-path lookup. Every dentry
> element in the path has its d_lock taken for every path lookup,
> so cwd dentry lock bounces a lot for dbench.
> 
> I'm working on doing path traversal without any locks or stores
> to the dentries in the common cases, so that should basically
> be the last bit of the puzzle for vfs locking (although it can be
> considered a different type of problem than the global lock
> removal, but RCU-freed struct inode is important for the approach
> I'm taking, so I'm basing it on top of these patches).
>  
> It's a copout, but you could try running multiple dbenches under
> different working directories (or actually, IIRC dbench does root
> based path lookups so maybe that won't help you much).

Yeah, it's hitting dentry->d_lock pretty hard so basically
spin-serialized at that point.

> > Anyway, below are the results. Seem very stable.
> > 
> >                                 throughput
> > ------------------------------------------------
> > 2.6.32-rc3-git          |      561.218 MB/sec
> > 2.6.32-rc3-git+patch    |      627.022 MB/sec
> 
> Well it's good to see you got some improvement.

Yes, it's an improvement though the results are still pretty abysmal :-)

-- 
Jens Axboe

