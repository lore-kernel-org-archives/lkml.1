Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZKSRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZKSRUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZKSRUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:20:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZKSRUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:20:33 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/28] Fixes for FS-Cache and CacheFiles
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:20:34 +0000
Message-ID: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The associated patches provide three sets of changes:

 (1) More ways to get debugging information from the slow-work, FS-Cache and
     CacheFiles facilities.

 (2) Fixes for all facilities.

 (3) Some extensions for slow-work for users other than FS-Cache/CacheFiles
     that aren't included in this series, but upon which other patches have
     been built.

The patches can also be found in:

	http://people.redhat.com/~dhowells/fscache/patches/fscache-fixes.tar.bz2

The bugs fixed were found by running a simple stress tester:

	http://people.redhat.com/~dhowells/slurp.c

Build it and point it at a bunch of NFS (or AFS or whatever) directory trees,
and it forks and execs a copy of itself to handle each directory that it is
given.  Whilst scanning a directory, for each subdir of that directory a new
copy forked and exec'd, and then each file in that directory is read from end
to end.

This results in a large number of processes reading in parallel a large number
of files.  If the data set is large enough, it applies pressure to both RAM
space and cache space, and can cause OOMs to occur, and can cause cachefilesd
to run in parallel trying to cull the cache as well.

With these patches applied, you can see more counters in /proc/fs/fscache/stats
and new sources of information exist too:

 (*) /proc/slow_work_rq

	The items currently being processed by or currently queued for
	processing by the slow-work facility.

 (*) /proc/fs/fscache/objects

	A list of current fscache objects and their states.  This can be
	configured by loading a key into your session keyring before viewing
	the file, for instance:

		keyctl add user fscache:objlist KB @s

	This is described in Documentation/filesystems/caching/fscache.txt

David
---

David Howells (25):
      CacheFiles: Don't log lookup/create failing with ENOBUFS
      CacheFiles: Catch an overly long wait for an old active object
      CacheFiles: Better showing of debugging information in active object problems
      CacheFiles: Mark parent directory locks as I_MUTEX_PARENT to keep lockdep happy
      CacheFiles: Handle truncate unlocking the page we're reading
      CacheFiles: Don't write a full page if there's only a partial page to cache
      FS-Cache: Actually requeue an object when requested
      FS-Cache: Start processing an object's operations on that object's death
      FS-Cache: Make sure FSCACHE_COOKIE_LOOKING_UP cleared on lookup failure
      FS-Cache: Add a retirement stat counter
      FS-Cache: Handle pages pending storage that get evicted under OOM conditions
      FS-Cache: Handle read request vs lookup, creation or other cache failure
      FS-Cache: Don't delete pending pages from the page-store tracking tree
      FS-Cache: Fix lock misorder in fscache_write_op()
      FS-Cache: The object-available state can't rely on the cookie to be available
      FS-Cache: Permit cache retrieval ops to be interrupted in the initial wait phase
      FS-Cache: Use radix tree preload correctly in tracking of pages to be stored
      FS-Cache: Clear netfs pointers in cookie after detaching object, not before
      FS-Cache: Add counters for entry/exit to/from cache operation functions
      FS-Cache: Allow the current state of all objects to be dumped
      FS-Cache: Annotate slow-work runqueue proc lines for FS-Cache work items
      SLOW_WORK: Allow a requeueable work item to sleep till the thread is needed
      SLOW_WORK: Allow the owner of a work item to determine if it is queued or not
      SLOW_WORK: Allow the work items to be viewed through a /proc file
      SLOW_WORK: Wait for outstanding work items belonging to a module to clear

Jens Axboe (3):
      SLOW_WORK: Add delayed_slow_work support
      SLOW_WORK: Add support for cancellation of slow work
      SLOW_WORK: Make slow_work_ops ->get_ref/->put_ref optional


 Documentation/filesystems/caching/fscache.txt   |  110 +++++
 Documentation/filesystems/caching/netfs-api.txt |   21 +
 Documentation/slow-work.txt                     |  160 +++++++
 fs/9p/cache.c                                   |   14 -
 fs/afs/file.c                                   |   15 -
 fs/cachefiles/interface.c                       |   32 +
 fs/cachefiles/namei.c                           |  187 +++++++--
 fs/cachefiles/rdwr.c                            |  128 +++++-
 fs/fscache/Kconfig                              |    7 
 fs/fscache/Makefile                             |    1 
 fs/fscache/cache.c                              |    5 
 fs/fscache/cookie.c                             |   26 +
 fs/fscache/internal.h                           |   55 +++
 fs/fscache/main.c                               |    6 
 fs/fscache/object-list.c                        |  432 ++++++++++++++++++++
 fs/fscache/object.c                             |  104 ++++-
 fs/fscache/operation.c                          |  120 ++++--
 fs/fscache/page.c                               |  273 ++++++++++---
 fs/fscache/proc.c                               |   13 +
 fs/fscache/stats.c                              |   94 ++++
 fs/gfs2/main.c                                  |    4 
 fs/gfs2/recovery.c                              |    1 
 fs/nfs/fscache.c                                |   10 
 include/linux/fscache-cache.h                   |   40 ++
 include/linux/fscache.h                         |   27 +
 include/linux/slow-work.h                       |   72 +++
 init/Kconfig                                    |   10 
 kernel/Makefile                                 |    1 
 kernel/slow-work-proc.c                         |  227 +++++++++++
 kernel/slow-work.c                              |  494 +++++++++++++++++++++--
 kernel/slow-work.h                              |   72 +++
 lib/radix-tree.c                                |    5 
 32 files changed, 2502 insertions(+), 264 deletions(-)
 create mode 100644 fs/fscache/object-list.c
 create mode 100644 kernel/slow-work-proc.c
 create mode 100644 kernel/slow-work.h

