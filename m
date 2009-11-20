Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZKTKtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZKTKtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZKTKtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:49:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZKTKtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:49:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
To: torvalds@osdl.org, akpm@linux-foundation.org
cc: dhowells@redhat.com, steved@redhat.com, jens.axboe@oracle.com,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: [GIT PULL] Fix bugs in Slow-work, FS-Cache and CacheFiles
Date: Fri, 20 Nov 2009 10:48:39 +0000
Message-ID: <13590.1258714119@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull the attached patches before 2.6.32 please?  For the most part
they are bug fixes for the slow-work, FS-Cache and CacheFiles facilities, with
a few patches to produce better debugging information, and a couple of patches
to slow work from Jens that all the rest are built on top of.

These vastly improve the stability of FS-Cache under extremely high load -
especially when the system is running out of memory regularly.  I wrote a
better test case:

	http://people.redhat.com/~dhowells/slurp.c

which helped enormously in reproducing these bugs.  Testing has involved
running repeated invocations of slurp over five NFS4 mounted directory trees
totalling ~40GB in N file spread over 100,000 dirs on a machine with 1GB of
RAM and 4GB of disk cache space.  Note that slurp, being massively parallel,
will abandon a part of the tree if it hits any error (such as ENOMEM) - so not
all the data set will necessarily be used in any particular run.

The patches can also be downloaded as:

	http://people.redhat.com/~dhowells/fscache/patches/fscache-fixes.tar.bz2

The changes don't affect very much outside of FS-Cache and its dependents (NFS,
AFS and 9P), but the slow-work changes do affect CIFS and GFS2.

Thanks,
David
---
The following changes since commit 66b00a7c93ec782d118d2c03bd599cfd041e80a1:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-fscache.git master

David Howells (25):
      SLOW_WORK: Wait for outstanding work items belonging to a module to clear
      SLOW_WORK: Allow the work items to be viewed through a /proc file
      SLOW_WORK: Allow the owner of a work item to determine if it is queued or not
      SLOW_WORK: Allow a requeueable work item to sleep till the thread is needed
      FS-Cache: Annotate slow-work runqueue proc lines for FS-Cache work items
      FS-Cache: Allow the current state of all objects to be dumped
      FS-Cache: Add counters for entry/exit to/from cache operation functions
      FS-Cache: Clear netfs pointers in cookie after detaching object, not before
      FS-Cache: Use radix tree preload correctly in tracking of pages to be stored
      FS-Cache: Permit cache retrieval ops to be interrupted in the initial wait phase
      FS-Cache: The object-available state can't rely on the cookie to be available
      FS-Cache: Fix lock misorder in fscache_write_op()
      FS-Cache: Don't delete pending pages from the page-store tracking tree
      FS-Cache: Handle read request vs lookup, creation or other cache failure
      FS-Cache: Handle pages pending storage that get evicted under OOM conditions
      FS-Cache: Add a retirement stat counter
      FS-Cache: Make sure FSCACHE_COOKIE_LOOKING_UP cleared on lookup failure
      FS-Cache: Start processing an object's operations on that object's death
      FS-Cache: Actually requeue an object when requested
      CacheFiles: Don't write a full page if there's only a partial page to cache
      CacheFiles: Handle truncate unlocking the page we're reading
      CacheFiles: Mark parent directory locks as I_MUTEX_PARENT to keep lockdep happy
      CacheFiles: Better showing of debugging information in active object problems
      CacheFiles: Catch an overly long wait for an old active object
      CacheFiles: Don't log lookup/create failing with ENOBUFS

Jens Axboe (3):
      SLOW_WORK: Make slow_work_ops ->get_ref/->put_ref optional
      SLOW_WORK: Add support for cancellation of slow work
      SLOW_WORK: Add delayed_slow_work support

 Documentation/filesystems/caching/fscache.txt   |  110 +++++
 Documentation/filesystems/caching/netfs-api.txt |   21 +-
 Documentation/slow-work.txt                     |  160 +++++++-
 fs/9p/cache.c                                   |   14 +-
 fs/afs/file.c                                   |   15 +-
 fs/cachefiles/interface.c                       |   32 ++-
 fs/cachefiles/namei.c                           |  187 +++++++--
 fs/cachefiles/rdwr.c                            |  128 ++++++-
 fs/fscache/Kconfig                              |    7 +
 fs/fscache/Makefile                             |    1 +
 fs/fscache/cache.c                              |    5 +
 fs/fscache/cookie.c                             |   26 +-
 fs/fscache/internal.h                           |   55 +++
 fs/fscache/main.c                               |    6 +-
 fs/fscache/object-list.c                        |  432 ++++++++++++++++++++
 fs/fscache/object.c                             |  104 +++++-
 fs/fscache/operation.c                          |  120 +++++--
 fs/fscache/page.c                               |  273 ++++++++++---
 fs/fscache/proc.c                               |   13 +
 fs/fscache/stats.c                              |   94 ++++-
 fs/gfs2/main.c                                  |    4 +-
 fs/gfs2/recovery.c                              |    1 +
 fs/nfs/fscache.c                                |   10 +-
 include/linux/fscache-cache.h                   |   40 ++-
 include/linux/fscache.h                         |   27 ++
 include/linux/slow-work.h                       |   72 ++++-
 init/Kconfig                                    |   10 +
 kernel/Makefile                                 |    1 +
 kernel/slow-work-proc.c                         |  227 +++++++++++
 kernel/slow-work.c                              |  494 +++++++++++++++++++++--
 kernel/slow-work.h                              |   72 ++++
 lib/radix-tree.c                                |    5 +-
 32 files changed, 2502 insertions(+), 264 deletions(-)
 create mode 100644 fs/fscache/object-list.c
 create mode 100644 kernel/slow-work-proc.c
 create mode 100644 kernel/slow-work.h
