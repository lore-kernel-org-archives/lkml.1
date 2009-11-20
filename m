Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZKTVyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZKTVyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZKTVyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:54:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbZKTVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:54:38 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/3] Fixes for FS-Cache and CacheFiles
To: wilhelm.meier@fh-kl.de, linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Fri, 20 Nov 2009 21:54:37 +0000
Message-ID: <20091120215437.15448.26909.stgit@warthog.procyon.org.uk>
In-Reply-To: <11689.1258704981@redhat.com>
References: <11689.1258704981@redhat.com>
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

David Howells (3):
      FS-Cache: Provide nop fscache_stat_d() if CONFIG_FSCACHE_STATS=n
      SLOW_WORK: Fix GFS2 to #include <linux/module.h> before using THIS_MODULE
      SLOW_WORK: Fix CIFS to pass THIS_MODULE to slow_work_register_user()


 fs/cifs/cifsfs.c      |    2 +-
 fs/fscache/internal.h |    1 +
 fs/gfs2/recovery.c    |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

