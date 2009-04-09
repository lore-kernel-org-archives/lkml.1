Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZDIWBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZDIWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZDIWAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:00:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49452 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZDIWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:00:48 -0400
Date: Thu, 9 Apr 2009 23:59:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: updated: ext3 IO latency measurements on v2.6.30-rc1
Message-ID: <20090409215946.GA28183@elte.hu>
References: <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326090630.GA9369@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an update to the ext3+CFQ latency measurements i did early 
in the merge window - originally with a v2.6.29 based kernel.

Today i've repeated my measurements under v2.6.30-rc1, using the 
exact same system and the exact same workload.

The quick executive summary:

   _what a difference a week of upstream development makes_!

:-)

Here are the specific details, as a reply to my earlier mail:

* Ingo Molnar <mingo@elte.hu> wrote:

> * Jan Kara <jack@suse.cz> wrote:
> 
> > > So tell me again how the VM can rely on the filesystem not 
> > > blocking at random points.
> >
> >   I can write a patch to make writepage() in the non-"mmapped 
> > creation" case non-blocking on journal. But I'll also have to find 
> > out whether it really helps something. But it's probably worth 
> > trying...
> 
> _all_ the problems i ever had with ext3 were 'collateral damage' 
> type of things: simple writes (sometimes even reads) getting 
> serialized on some large [but reasonable] dirtying activity 
> elsewhere - even if the system was still well within its 
> hard-dirty-limit threshold.
> 
> So it sure sounds like an area worth improving, and it's not that 
> hard to reproduce either. Take a system with enough RAM but only a 
> single disk, and do this in a kernel tree:
> 
>   sync
>   echo 3 > /proc/sys/vm/drop_caches
> 
>   while :; do
>     date
>     make mrproper      2>/dev/null >/dev/null
>     make defconfig     2>/dev/null >/dev/null
>     make -j32 bzImage  2>/dev/null >/dev/null
>   done &
> 
> Plain old kernel build, no distcc and no icecream. Wait a few 
> minutes for the system to reach equilibrium. There's no tweaking 
> anywhere, kernel, distro and filesystem defaults used everywhere:
> 
>  aldebaran:/home/mingo/linux/linux> ./compile-test 
>  Thu Mar 26 10:33:03 CET 2009
>  Thu Mar 26 10:35:24 CET 2009
>  Thu Mar 26 10:36:48 CET 2009
>  Thu Mar 26 10:38:54 CET 2009
>  Thu Mar 26 10:41:22 CET 2009
>  Thu Mar 26 10:43:41 CET 2009
>  Thu Mar 26 10:46:02 CET 2009
>  Thu Mar 26 10:48:28 CET 2009
> 
> And try to use the system while this workload is going on. Use Vim 
> to edit files in this kernel tree. Use plain _cat_ - and i hit 
> delays all the time - and it's not the CPU scheduler but all IO 
> related.

Under .30-rc1 i couldnt hit a single (!) annoying delay during half 
an hour of trying. The "Vim experience" is _totally_ smooth with a 
load average of 40+.

And this is with default, untweaked ext3 - not even ext4. I'm 
impressed.

> I have such an ext3 based system where i can do such tests and 
> where i dont mind crashes and data corruption either, so if you 
> send me experimental patches against latet -git i can try them 
> immediately. The system has 16 CPUs, 12GB of RAM and a single 
> disk.
> 
> Btw., i had this test going on that box while i wrote some simple 
> scripts in Vim - and it was a horrible experience. The worst wait 
> was well above one minute - Vim just hung there indefinitely. Not 
> even Ctrl-Z was possible. I captured one such wait, it was hanging 
> right here:
> 
>  aldebaran:~/linux/linux> cat /proc/3742/stack
>  [<ffffffff8034790a>] log_wait_commit+0xbd/0x110
>  [<ffffffff803430b2>] journal_stop+0x1df/0x20d
>  [<ffffffff8034421f>] journal_force_commit+0x28/0x2d
>  [<ffffffff80331c69>] ext3_force_commit+0x2b/0x2d
>  [<ffffffff80328b56>] ext3_write_inode+0x3e/0x44
>  [<ffffffff802ebb9d>] __sync_single_inode+0xc1/0x2ad
>  [<ffffffff802ebed6>] __writeback_single_inode+0x14d/0x15a
>  [<ffffffff802ebf0c>] sync_inode+0x29/0x34
>  [<ffffffff80327453>] ext3_sync_file+0xa7/0xb4
>  [<ffffffff802ef17d>] vfs_fsync+0x78/0xaf
>  [<ffffffff802ef1eb>] do_fsync+0x37/0x4d
>  [<ffffffff802ef228>] sys_fsync+0x10/0x14
>  [<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
>  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> It took about 120 seconds for it to recover.

These delays are definitely below 300 msecs now. (100 msecs is 
roughly the lag i can still notice in typing)

> And it's not just sys_fsync(). The script i wrote tests file read 
> latencies. I have created 1000 files with the same size (all copies 
> of kernel/sched.c ;-), and tested their cache-cold plain-cat 
> performance via:
> 
>   for ((i=0;i<1000;i++)); do
>     printf "file #%4d, plain reading it took: " $i
>     /usr/bin/time -f "%e seconds."  cat $i >/dev/null
>   done
> 
> I.e. plain, supposedly high-prio reads. The result is very common 
> hickups in read latencies:
> 
> file # 579 (253560 bytes), reading it took: 0.08 seconds.
> file # 580 (253560 bytes), reading it took: 0.05 seconds.
> file # 581 (253560 bytes), reading it took: 0.01 seconds.
> file # 582 (253560 bytes), reading it took: 0.01 seconds.
> file # 583 (253560 bytes), reading it took: 4.61 seconds.
> file # 584 (253560 bytes), reading it took: 1.29 seconds.
> file # 585 (253560 bytes), reading it took: 3.01 seconds.
> file # 586 (253560 bytes), reading it took: 7.74 seconds.
> file # 587 (253560 bytes), reading it took: 3.22 seconds.
> file # 588 (253560 bytes), reading it took: 0.05 seconds.
> file # 589 (253560 bytes), reading it took: 0.36 seconds.
> file # 590 (253560 bytes), reading it took: 7.39 seconds.
> file # 591 (253560 bytes), reading it took: 7.58 seconds.
> file # 592 (253560 bytes), reading it took: 7.90 seconds.
> file # 593 (253560 bytes), reading it took: 8.78 seconds.
> file # 594 (253560 bytes), reading it took: 8.01 seconds.
> file # 595 (253560 bytes), reading it took: 7.47 seconds.
> file # 596 (253560 bytes), reading it took: 11.52 seconds.
> file # 597 (253560 bytes), reading it took: 10.33 seconds.
> file # 598 (253560 bytes), reading it took: 8.56 seconds.
> file # 599 (253560 bytes), reading it took: 7.58 seconds.

This test is totally smooth now:

file #   6 (253560 bytes), reading it took: 0.05 seconds.
file #   7 (253560 bytes), reading it took: 0.11 seconds.
file #   8 (253560 bytes), reading it took: 0.12 seconds.
file #   9 (253560 bytes), reading it took: 0.06 seconds.
file #  10 (253560 bytes), reading it took: 0.05 seconds.
file #  11 (253560 bytes), reading it took: 0.11 seconds.
file #  12 (253560 bytes), reading it took: 0.09 seconds.
file #  13 (253560 bytes), reading it took: 0.09 seconds.
file #  14 (253560 bytes), reading it took: 0.03 seconds.
file #  15 (253560 bytes), reading it took: 0.08 seconds.
file #  16 (253560 bytes), reading it took: 0.15 seconds.
file #  17 (253560 bytes), reading it took: 0.06 seconds.
file #  18 (253560 bytes), reading it took: 0.13 seconds.
file #  19 (253560 bytes), reading it took: 0.16 seconds.
file #  20 (253560 bytes), reading it took: 0.29 seconds.
file #  21 (253560 bytes), reading it took: 0.18 seconds.
file #  22 (253560 bytes), reading it took: 0.28 seconds.
file #  23 (253560 bytes), reading it took: 0.04 seconds.

290 msecs was the worst in thes series above.

The vim read+write test takes longer:

aldebaran:~/linux/linux/test-files/src> ./vim-test
file #   0 (253560 bytes), Vim-opening it took: 2.35 seconds.
file #   1 (253560 bytes), Vim-opening it took: 2.09 seconds.
file #   2 (253560 bytes), Vim-opening it took: 2.20 seconds.
file #   3 (253560 bytes), Vim-opening it took: 2.14 seconds.
file #   4 (253560 bytes), Vim-opening it took: 2.15 seconds.
file #   5 (253560 bytes), Vim-opening it took: 2.13 seconds.
file #   6 (253560 bytes), Vim-opening it took: 2.11 seconds.
file #   7 (253560 bytes), Vim-opening it took: 2.09 seconds.
file #   8 (253560 bytes), Vim-opening it took: 2.03 seconds.
file #   9 (253560 bytes), Vim-opening it took: 2.03 seconds.
file #  10 (253560 bytes), Vim-opening it took: 2.06 seconds.
file #  11 (253560 bytes), Vim-opening it took: 2.19 seconds.
file #  12 (253560 bytes), Vim-opening it took: 2.07 seconds.
file #  13 (253560 bytes), Vim-opening it took: 2.02 seconds.

I suspect that is to be expected? The test does:

   vim -c "q" $i 2>/dev/null >/dev/null

2 seconds is OK-ish - when close+writing a file i mentally expect 
some short delay anyway. I think vim fsyncs the swap file in that 
case as well.

I havent actually experienced any such delays while editing files.

> The system's RAM is ridiculously under-utilized, 96.1% is free, only 
> 3.9% is utilized:
> 
>               total       used       free     shared    buffers     cached
>  Mem:      12318192     476732   11841460          0      48324     142936
>  -/+ buffers/cache:     285472   12032720
>  Swap:      4096564          0    4096564
> 
> Dirty data in /proc/meminfo fluctuates between 0.4% and 1.6% of 
> total RAM. (the script removes the freshly build kernel object 
> files, so the workload is pretty steady.)
> 
> The peak of 1.6% looks like this:
> 
> Dirty:            118376 kB
> Dirty:            143784 kB
> Dirty:            161756 kB
> Dirty:            185084 kB
> Dirty:            210524 kB
> Dirty:            213348 kB
> Dirty:            200124 kB
> Dirty:            122152 kB
> Dirty:            121508 kB
> Dirty:            121512 kB
> 
> (1 second snapshots)
> 
> So the problems are all around the place and they are absolutely, 
> trivially reproducible. And this is how a default ext3 based distro 
> and the default upstream kernel will present itself to new Linux 
> users and developers. It's not a pretty experience.
> 
> Oh, and while at it - also a job control complaint. I tried to 
> Ctrl-C the above script:
> 
> file # 858 (253560 bytes), reading it took: 0.06 seconds.
> file # 859 (253560 bytes), reading it took: 0.02 seconds.
> file # 860 (253560 bytes), reading it took: 5.53 seconds.
> file # 861 (253560 bytes), reading it took: 3.70 seconds.
> file # 862 (253560 bytes), reading it took: 0.88 seconds.
> file # 863 (253560 bytes), reading it took: 0.04 seconds.
> file # 864 (253560 bytes), reading it took: ^C0.69 seconds.
> file # 865 (253560 bytes), reading it took: ^C0.49 seconds.
> file # 866 (253560 bytes), reading it took: ^C0.01 seconds.
> file # 867 (253560 bytes), reading it took: ^C0.02 seconds.
> file # 868 (253560 bytes), reading it took: ^C^C0.01 seconds.
> file # 869 (253560 bytes), reading it took: ^C^C0.04 seconds.
> file # 870 (253560 bytes), reading it took: ^C^C^C0.03 seconds.
> file # 871 (253560 bytes), reading it took: ^C0.02 seconds.
> file # 872 (253560 bytes), reading it took: ^C^C0.02 seconds.
> file # 873 (253560 bytes), reading it took: 
> ^C^C^C^Caldebaran:~/linux/linux/test-files/src> 
> 
> I had to hit Ctrl-C numerous times before Bash would honor it. 
> This to is a very common thing on large SMP systems. I'm willing 
> to test patches until all these problems are fixed. Any takers?

This Bash bug still occurs and is highly annoying when using scripts 
on SMP Linux boxes and trying to Ctrl-C out of them.

But all in one, the ext3 and IO latency problems seem to be 
thoroughly cured!

To me the past 1 week has made more difference in filesystems and IO 
interactivity than all filesystems development done in the past 5+ 
years, combined. Kudos!

	Ingo
