Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZJPUH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZJPUH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 16:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZJPUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 16:07:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45468 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZJPUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 16:07:27 -0400
Subject: -rt dbench scalabiltiy issue
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Cc: Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 13:05:19 -0700
Message-Id: <1255723519.5135.121.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See http://lwn.net/Articles/354690/ for a bit of background here.

I've been looking at scalability regressions in the -rt kernel. One easy
place to see regressions is with the dbench benchmark. While dbench can
be painfully noisy from run to run, it does clearly show some severe
regressions with -rt. 

There's a chart in the article above that illustrates this, but here's
some specific numbers on an 8-way box running dbench-3.04 as follows: 

./dbench 8 -t 10 -D . -c client.txt 2>&1 

I ran both on an ext3 disk and a ramfs mounted directory.

(Again, the numbers are VERY rough due to the run-to-run variance seen)

			ext3		ramfs 
2.6.32-rc3:		~1800 MB/sec	~1600 MB/sec
2.6.31.2-rt13: 		~300 MB/sec	~66 MB/sec

Ouch. Similar to the charts in the LWN article.

Dino pointed out that using lockstat with -rt, we can see the
dcache_lock is fairly hot with the -rt kernel. One of the issues with
the -rt tree is that the change from spinlocks to sleeping-spinlocks
doesn't effect the un-contended case very much, but when there is
contention on the lock, the overhead is much worse then with vanilla.

And as noted at the realtime mini-conf, Ingo saw this dcache_lock
bottleneck as well and suggested trying Nick Piggin's dcache_lock
removal patches.

So over the last week, I've ported Nick's fs-scale patches to -rt. 

Specifically the tarball found here:
ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/06102009.tar.gz


Due to the 2.6.32 2.6.31-rt split, the port wasn't exactly straight
forward, but I believe I managed to do a decent job. Once I had the
patchset applied, building and booted, I eagerly ran dbench to see the
new results, aaaaaand.....

			ext3		ramfs 
2.6.31.2-rt13-nick:	~80 MB/sec	~126 MB/sec


So yea, mixed bag there. The ramfs got a little bit better but not that
much, and the ext3 numbers regressed further.

I then looked into the perf tool, to see if it would shed some light on
whats going on (snipped results below).

2.6.31.2-rt13 on ext3: 
42.45%   dbench  [kernel]                    [k] _atomic_spin_lock_irqsave
                |          
                |--85.61%-- rt_spin_lock_slowlock
                |          rt_spin_lock
                |          |          
                |          |--23.91%-- start_this_handle
                |          |          journal_start
                |          |          ext3_journal_start_sb
                |          |--21.29%-- journal_stop
                |          |
                |          |--13.80%-- ext3_test_allocatable
                |          |          
                |          |--12.15%-- bitmap_search_next_usable_block
                |          |          
                |          |--9.79%-- journal_put_journal_head
                |          |          
                |          |--5.93%-- journal_add_journal_head
                |          |          
                |          |--2.59%-- atomic_dec_and_spin_lock
                |          |          dput
                |          |          |          
                |          |          |--65.31%-- path_put
                |          |          |          |          
                |          |          |          |--53.37%-- __link_path_walk
...

So this is initially interesting, as it seems on ext3 it seems the
journal locking is really whats catching us more then the dcache_lock.
Am I reading this right? 


2.6.31.2-rt13 on ramfs: 
45.98%         dbench  [kernel]                    [k] _atomic_spin_lock_irqsave
                |          
                |--82.94%-- rt_spin_lock_slowlock
                |          rt_spin_lock
                |          |          
                |          |--61.18%-- dcache_readdir
                |          |          vfs_readdir
                |          |          sys_getdents
                |          |          system_call_fastpath
                |          |          __getdents64
                |          |          
                |          |--11.26%-- atomic_dec_and_spin_lock
                |          |          dput
                |          |          
                |          |--7.93%-- d_path
                |          |          seq_path
                |          |          show_vfsmnt
                |          |          seq_read
                |          |          vfs_read
                |          |          sys_read
                |          |          system_call_fastpath
                |          |          __GI___libc_read
                |          |          


So here we do see the dcache_readdir's use of the dcache lock pop up to
the top. And with ramfs we don't see any of the ext3 journal code.

Next up is with Nick's patchset:

2.6.31.2-rt13-nick on ext3:
    45.48%         dbench  [kernel]                    [k] _atomic_spin_lock_irqsave
                |          
                |--83.40%-- rt_spin_lock_slowlock
                |          |          
                |          |--100.00%-- rt_spin_lock
                |          |          |          
                |          |          |--43.35%-- dput
                |          |          |          |          
                |          |          |          |--50.29%-- __link_path_walk
                |          |          |           --49.71%-- path_put
                |          |          |--39.07%-- path_get
                |          |          |          |          
                |          |          |          |--61.98%-- path_walk
                |          |          |          |--38.01%-- path_init
                |          |          |          
                |          |          |--7.33%-- journal_put_journal_head
                |          |          |          
                |          |          |--4.32%-- journal_add_journal_head
                |          |          |          
                |          |          |--2.83%-- start_this_handle
                |          |          |          journal_start
                |          |          |          ext3_journal_start_sb
                |          |          |          
                |          |          |--2.52%-- journal_stop
                |          
                |--15.87%-- rt_spin_lock_slowunlock
                |          rt_spin_unlock
                |          |          
                |          |--43.48%-- path_get
                |          |          
                |          |--41.80%-- dput
                |          |          
                |          |--5.34%-- journal_add_journal_head
		...

With Nick's patches on ext3, it seems dput()'s locking is the bottleneck
more then the journal code (maybe due to the multiple spinning nested
trylocks?). 

With the ramfs, it looks mostly the same, but without the journal calls:

2.6.31.2-rt13-nick on ramfs:
    46.51%         dbench  [kernel]                  [k] _atomic_spin_lock_irqsave
                |          
                |--86.95%-- rt_spin_lock_slowlock
                |          rt_spin_lock
                |          |          
                |          |--50.08%-- dput
                |          |          |          
                |          |          |--56.92%-- __link_path_walk
                |          |          |          
                |          |           --43.08%-- path_put
                |          |          
                |          |--49.12%-- path_get
                |          |          |          
                |          |          |--63.22%-- path_walk
                |          |          |          
                |          |          |--36.73%-- path_init
                |          
                |--12.59%-- rt_spin_lock_slowunlock
                |          rt_spin_unlock
                |          |          
                |          |--49.86%-- path_get
                |          |          |          
                |          |          |--58.15%-- path_init
                |          |          |          |          
...


So the net of this is: Nick's patches helped some but not that much in
ramfs filesystems, and hurt ext3 performance w/ -rt.

Maybe I just mis-applied the patches? I'll admit I'm unfamiliar with the
dcache code, and converting the patches to the -rt tree was not always
straight forward.

Or maybe these results are expected? With Nick's patch against
2.6.32-rc3 I got:

			ext3		ramfs 
2.6.32-rc3-nick		~1800 MB/sec	~2200 MB/sec

So ext3 performance didn't change, but ramfs did see a nice bump. Maybe
Nick's patches helped where they could, but we still have other
contention points that are problematic with -rt's lock slowpath
overhead?


Ingo, Nick, Thomas: Any thoughts or comments here? Am I reading perf's
results incorrectly? Any idea why with Nick's patch the contention in
dput() hurts ext3 so much worse then in the ramfs case?


I'll be doing some further tests today w/ ext2 to see if getting the
journal code out of the way shows any benefit. But if folks have any
insight or suggestions for other ideas to look at please let me know.

thanks
-john

