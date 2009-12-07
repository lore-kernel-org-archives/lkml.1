Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbZLGSY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbZLGSY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZLGSY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:24:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47034 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbZLGSYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:24:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=n5kwR7BtxTBcL1ppo6YeoE1I+uVpqtf4RSk9OMaKbq5BzyUz/+W9ZJrVgi9uHs+1Vt
         s/NEMj0yLtWbR1jJqg9cdofsEffQBNsaia7OiRMzXdTA8u0YmRSf/RO2/hiMEL8Ey0PG
         6hkb9PGbb4i7HKCpmdLClmaOptds9QSiXqEFA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, reiserfs-devel@vger.kernel.org
Subject: [GIT PULL] reiserfs/kill-bkl for 2.6.33
Date: Mon,  7 Dec 2009 19:24:57 +0100
Message-Id: <1260210297-5384-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
To: Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the reiserfs/kill-bkl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

This tree has been in the works since April now and in linux-next
for two cycles. Alexander Beregalov has tested it many times and
helped a lot by reporting the various locking inversions
(thanks a lot to him, again).
All of them were fixed and the tree appears pretty stable: no known
regressions.

There are no more traces of the bkl inside reiserfs. It has been
converted into a recursive mutex. This sounds dirty but plugging
a traditional lock into reiserfs would involve a deeper rewrite
as the reiserfs architecture is based on the ugly big kernel lock
rules.

I'm attaching various benchmarks to this pull request so that you can
have an idea about some practical impacts. Depending on the workload,
the conversion effect is either better or worse.

 == Dbench ==

As dbench uses a given file that describes a precise workload, it
only measures one type of load (I've picked the default one).

Comparison between 2.6.32 vanilla (bkl) and my tree (mut):

- 1 thread during 360 secs:
Graph: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/360-1.pdf
Bkl: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/bkl-360-1.log
Mutex: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/mut-360-1.log

The difference is pretty low. Both are racing between 215 and 220 MB/s

- 16 thread during 360 secs:
Graph: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/360-16.pdf
Bkl: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/bkl-360-16.log
Mutex: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/mut-360-16.log

Here the bkl is better. At a first glance, the bkl is at 365 MB/s average and the
mutex at a 307 MB/s average.
This makes a 16 % regression

- 128 thread during 360 secs:
Graph: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/360-128.pdf
Bkl: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/bkl-360-128.log
Mutex: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_mono/mut-360-128.log

Here the mutex is slightly better.

== Parallel Dbench ==

Now same comparisons but using two running dbench, on two different partitions
on the same disk (unfortunately I can't test with a separate disk):

- 1 thread during 360 secs:
Graph: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/360-1-parallel.pdf
Bkl: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/bkl-part1-360-1.log
     http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/bkl-part2-360-1.log
Mutex: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/mut-part1-360-1.log
       http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/mut-part2-360-1.log

Better with the mutex.
The bkl is around 185 Mb/s and 192 Mb/s
The mutex is around 204 Mb/s and 205 Mb/s

- 16 threads during 360 secs:
Graph: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/360-16-parallel.pdf
Bkl: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/bkl-part1-360-16.log
     http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/bkl-part2-360-16.log
Mutex: http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/mut-part1-360-16.log
       http://www.kernel.org/pub/linux/kernel/people/frederic/dbench_parallel/mut-part2-360-16.log

There it's a bit hard to tell which is the best. Sometimes the mutex, sometimes
the bkl.

== ffsb ==

ffsb is better to define a statistical workload. The following benchmarks
show pretty equal results between the bkl and the mutex.
I've stolen the workload definitions from Chris Mason's webpage, but
I've changed them a bit so that they can fit in my laptop.

- Creation of largefiles, 1 thread
Description of the workload:
http://www.kernel.org/pub/linux/kernel/people/frederic/ffsb/largefile_create_thread1.profile
Bkl write throughput: 22.1MB/sec
Mutex write throughput: 21.9MB/sec

- Creation of largefiles, 16 threads
Description of the workload:
http://www.kernel.org/pub/linux/kernel/people/frederic/ffsb/largefile_create_thread16.profile
Bkl write throughput: 18.6MB/sec
Mutex write throughput: 18.5MB/sec

- Simulation of a mailserver, 16 threads
Description of the workload:
http://www.kernel.org/pub/linux/kernel/people/frederic/ffsb/mailserver16.profile
Bkl write throughput: 4.74MB/sec
Bkl read throughput: 9.74MB/sec
Mutex write throughput: 4.68MB/sec
Mutex read throughput: 9.8MB/sec

More details about ffsb benchmark results can be found there:
http://www.kernel.org/pub/linux/kernel/people/frederic/ffsb/
with more granular informations such as latency per fs operation.


So, depending on the situation, the mutex is better or worse. Some
bad results in dbench can be explained by the fact that the dbench
workload seem to do a lot of concurrent readdir and writes.

The bkl conversion forced us to relax the lock on readdir before
passing a dir entry to the user, then if a concurrent write occured
with a parallel readdir and then changed the tree, reiserfs does a
fixup to retrieve the directory entry in the tree. We don't have
the choice for now, we need to relax the lock to avoid a lock
inversion with the mmap_sem.

Some further optimizations can be planned in this area, such as copying
the directory entries in a temporary buffer without relaxing the
lock, and copy to the user without the lock (suggested by Thomas and
Chris).


Thanks,
	Frederic
---

Frederic Weisbecker (32):
      reiserfs: kill-the-BKL
      reiserfs, kill-the-BKL: fix unsafe j_flush_mutex lock
      kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
      kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
      kill-the-BKL/reiserfs: only acquire the write lock once in reiserfs_dirty_inode
      kill-the-BKL/reiserfs: release write lock on fs_changed()
      kill-the-BKL/reiserfs: release the write lock before rescheduling on do_journal_end()
      kill-the-BKL/reiserfs: release write lock while rescheduling on prepare_for_delete_or_cut()
      kill-the-BKL/reiserfs: release the write lock inside get_neighbors()
      kill-the-BKL/reiserfs: release the write lock inside reiserfs_read_bitmap_block()
      kill-the-BKL/reiserfs: release the write lock on flush_commit_list()
      kill-the-BKL/reiserfs: add reiserfs_cond_resched()
      kill-the-bkl/reiserfs: conditionaly release the write lock on fs_changed()
      kill-the-bkl/reiserfs: lock only once on reiserfs_get_block()
      kill-the-bkl/reiserfs: don't hold the write recursively in reiserfs_lookup()
      kill-the-bkl/reiserfs: reduce number of contentions in search_by_key()
      kill-the-bkl/reiserfs: factorize the locking in reiserfs_write_end()
      kill-the-bkl/reiserfs: use mutex_lock in reiserfs_mutex_lock_safe
      kill-the-bkl/reiserfs: unlock only when needed in search_by_key
      kill-the-bkl/reiserfs: acquire the inode mutex safely
      kill-the-bkl/reiserfs: move the concurrent tree accesses checks per superblock
      kill-the-bkl/reiserfs: fix "reiserfs lock" / "inode mutex" lock inversion dependency
      kill-the-bkl/reiserfs: fix recursive reiserfs lock in reiserfs_mkdir()
      kill-the-bkl/reiserfs: fix recursive reiserfs write lock in reiserfs_commit_write()
      kill-the-bkl/reiserfs: panic in case of lock imbalance
      kill-the-bkl/reiserfs: Fix induced mm->mmap_sem to sysfs_mutex dependency
      kill-the-bkl/reiserfs: fix reiserfs lock to cpu_add_remove_lock dependency
      kill-the-bkl/reiserfs: always lock the ioctl path
      kill-the-bkl/reiserfs: definitely drop the bkl from reiserfs_ioctl()
      kill-the-bkl/reiserfs: drop the fs race watchdog from _get_block_create_0()
      kill-the-bkl/reiserfs: turn GFP_ATOMIC flag to GFP_NOFS in reiserfs_get_block()
      Merge commit 'v2.6.32' into reiserfs/kill-bkl

 fs/reiserfs/Makefile           |    2 +-
 fs/reiserfs/bitmap.c           |    4 +
 fs/reiserfs/dir.c              |   10 +++-
 fs/reiserfs/do_balan.c         |   17 ++----
 fs/reiserfs/file.c             |    2 +-
 fs/reiserfs/fix_node.c         |   19 +++++-
 fs/reiserfs/inode.c            |   97 +++++++++++++++++-------------
 fs/reiserfs/ioctl.c            |   77 +++++++++++++----------
 fs/reiserfs/journal.c          |  130 ++++++++++++++++++++++++++++++----------
 fs/reiserfs/lock.c             |   88 +++++++++++++++++++++++++++
 fs/reiserfs/namei.c            |   20 ++++--
 fs/reiserfs/prints.c           |    4 -
 fs/reiserfs/resize.c           |    2 +
 fs/reiserfs/stree.c            |   53 ++++++++++++++---
 fs/reiserfs/super.c            |   52 ++++++++++++----
 fs/reiserfs/xattr.c            |    6 +-
 include/linux/reiserfs_fs.h    |   71 +++++++++++++++++++---
 include/linux/reiserfs_fs_sb.h |   20 ++++++
 18 files changed, 503 insertions(+), 171 deletions(-)
