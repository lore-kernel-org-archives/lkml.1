Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbZJILK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbZJILK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760486AbZJILK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:10:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40977 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759715AbZJILKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:10:25 -0400
Date: Fri, 9 Oct 2009 13:09:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       kiran@scalex86.org, peterz@infradead.org
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009110948.GB9228@kernel.dk>
References: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de> <20091009035050.GC4287@wotan.suse.de> <20091008.231527.251721755.davem@davemloft.net> <20091009104013.GF17818@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009104013.GF17818@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Nick Piggin wrote:
> On Thu, Oct 08, 2009 at 11:15:27PM -0700, David Miller wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > Date: Fri, 9 Oct 2009 05:50:50 +0200
> > 
> > > OK, I got rid of this guy from the RCU walk. Basically now hold
> > > vfsmount_lock over the entire RCU path walk (which also pins the mnt)
> > > and use a seqlock in the fs struct to get a consistent mnt,dentry
> > > pair. This also simplifies the walk because we don't need the
> > > complexity to avoid mntget/mntput (just do one final mntget on the
> > > resulting mnt before dropping vfsmount_lock).
> > > 
> > > vfsmount_lock adds one per-cpu atomic for the spinlock, and we
> > > remove two thread-shared atomics for fs->lock so a net win for
> > > both single threaded performance and thread-shared scalability.
> > > Latency is no problem because we hold rcu_read_lock for the same
> > > length of time anyway.
> > > 
> > > The parallel git diff workload is improved by serveral percent.
> > 
> > Sounds sweet Nick, can't wait to play with your next set of
> > patches here.
> 
> http://www.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/
> 
> OK well there will be another rev of the patches there with everything,
> also with the d_mounted patch so dentry remains a nice size. Also tried
> rearranging some structures in the dentry to help lookups but haven't
> quite finished there.
> 
> Jens I would be interested to see whether parallel case on the N2 is
> improved at all. Profiles from that case might be interesting.

Results with 09102009.patch below. And thanks for doing a rolled up
patch again, at least I don't use quilt :-)

2.6.32-rc3 serial
real    0m6.587s
user    0m1.970s
sys     0m2.890s

2.6.32-rc3 parallel
real    0m3.180s
user    0m1.460s
sys     0m2.700s

vfs serial
real    0m6.543s
user    0m1.970s
sys     0m2.590s

vfs parallel
real    0m3.121s
user    0m1.200s
sys     0m2.920s

Doesn't looks so good. Don't pay too much attention to user/sys time
btw, they don't seem very stable. The real elapsed time is stable,
though.

-- 
Jens Axboe

