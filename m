Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZJFK0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZJFK0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbZJFK0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:26:42 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46021 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbZJFK0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:26:42 -0400
Date: Tue, 6 Oct 2009 12:26:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091006102604.GN5216@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006101414.GM5216@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Jens Axboe wrote:
> On Tue, Oct 06 2009, Nick Piggin wrote:
> > Hi,
> > 
> > Several people have been interested to test my vfs patches, so rather
> > than resend patches I have uploaded a rollup against Linus's current
> > head.
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/
> > 
> > I have used ext2,ext3,autofs4,nfs as well as in-memory filesystems
> > OK (although this doesn't mean there are no bugs!). Otherwise, if your
> > filesystem compiles, then there is a reasonable chance of it working,
> > or ask me and I can try updating it for the new locking.
> > 
> > I would be interested in seeing any numbers people might come up with,
> > including single-threaded performance.
> 
> I gave this a quick spin on the 64-thread nehalem. Just a simple dbench
> with 64 clients on tmpfs. The results are below. While running perf top
> -a in mainline, the top 5 entries are:
> 
>           2086691.00 - 96.6% : _spin_lock
>             14866.00 -  0.7% : copy_user_generic_string
>              5710.00 -  0.3% : mutex_spin_on_owner
>              2837.00 -  0.1% : _atomic_dec_and_lock
>              2274.00 -  0.1% : __d_lookup
> 
> Uhm auch... It doesn't look much prettier for the patch kernel, though:
> 
>           9396422.00 - 95.7% : _spin_lock
>             66978.00 -  0.7% : copy_user_generic_string
>             43775.00 -  0.4% : dput
>             23946.00 -  0.2% : __link_path_walk
>             17699.00 -  0.2% : path_init
>             15046.00 -  0.2% : do_lookup

I did a quick perf analysis on that, but only on 8 clients (64 clients
basically causes perf to shit itself, it's just not functional). So for
a 8 client 60s dbench run, we're already into ~75% spinlock time. The
components are:

dput (44%)
        path_put
                path_walk
                        do_path_lookup
path_get (44%)
        path_init
                do_path_lookup
__d_path (7%)

vfsmount_read_lock (3%)

This is for the patched kernel.

-- 
Jens Axboe

