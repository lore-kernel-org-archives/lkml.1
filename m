Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZCIWko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZCIWko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZCIWkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:40:23 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50056 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZCIWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:40:21 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/20] ceph: Ceph distributed file system client
Date: Mon,  9 Mar 2009 15:40:19 -0700
Message-Id: <1236638439-6753-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series for v0.7 of the Ceph distributed file system
client (against v2.6.29-rc7).

Changes since v0.6:
 * Improved (faster) truncate strategy
 * Moved proc items to sysfs
 * Bug fixes, performance improvements

Changes since v0.5:
 * Asynchronous commit of metadata operations to server

Please consider for inclusion in mm and/or staging trees.  Review
and/or comments are most welcome.

Thanks,
sage


---

Ceph is a distributed file system designed for reliability, scalability, 
and performance.  The storage system consists of some (potentially 
large) number of storage servers (bricks), a smaller set of metadata 
server daemons, and a few monitor daemons for managing cluster 
membership and state.  The storage daemons rely on btrfs for storing 
data (and take advantage of btrfs' internal transactions to keep the 
local data set in a consistent state).  This makes the storage cluster 
simple to deploy, while providing scalability not currently available 
from block-based Linux cluster file systems.

Additionaly, Ceph brings a few new things to Linux.  Directory 
granularity snapshots allow users to create a read-only snapshot of any 
directory (and its nested contents) with 'mkdir .snap/my_snapshot' [1]. 
Deletion is similarly trivial ('rmdir .snap/old_snapshot').  Ceph also 
maintains recursive accounting statistics on the number of nested files, 
directories, and file sizes for each directory, making it much easier 
for an administrator to manage usage [2].

Basic features include:

 * Strong data and metadata consistency between clients
 * High availability and reliability.  No single points of failure.
 * N-way replication of all data across storage nodes
 * Scalability from 1 to potentially many thousands of nodes
 * Fast recovery from node failures
 * Automatic rebalancing of data on node addition/removal
 * Easy deployment: most FS components are userspace daemons

In contrast to cluster filesystems like GFS2 and OCFS2 that rely on 
symmetric access by all clients to shared block devices, Ceph separates 
data and metadata management into independent server clusters, similar 
to Lustre.  Unlike Lustre, however, metadata and storage nodes run 
entirely as user space daemons.  The storage daemon utilizes btrfs to 
store data objects, leveraging its advanced features (transactions, 
checksumming, metadata replication, etc.).  File data is striped across 
storage nodes in large chunks to distribute workload and facilitate high 
throughputs. When storage nodes fail, data is re-replicated in a 
distributed fashion by the storage nodes themselves (with some minimal 
coordination from the cluster monitor), making the system extremely 
efficient and scalable.

Metadata servers effectively form a large, consistent, distributed
in-memory cache above the storage cluster that is scalable,
dynamically redistributes metadata in response to workload changes,
and can tolerate arbitrary (well, non-Byzantine) node failures.  The
metadata server embeds inodes with only a single link inside the
directories that contain them, allowing entire directories of dentries
and inodes to be loaded into its cache with a single I/O operation.
Hard links are supported via an auxiliary table facilitating inode
lookup by number.  The contents of large directories can be fragmented
and managed by independent metadata servers, allowing scalable
concurrent access.

The system offers automatic data rebalancing/migration when scaling from 
a small cluster of just a few nodes to many hundreds, without requiring 
an administrator to carve the data set into static volumes or go through 
the tedious process of migrating data between servers.  When the file 
system approaches full, new storage nodes can be easily added and things 
will "just work."

A git tree containing just the client (and this patch series) is at
	git://ceph.newdream.net/linux-ceph-client.git

A few caveats:
  * The corresponding user space daemons need to be built in order to test
    it.  Instructions for getting a test setup running are at
        http://ceph.newdream.net/wiki/
  * There is some #ifdef kernel version compatibility cruft that will
    obviously be removed down the line.

The source for the full system is at
	git://ceph.newdream.net/ceph.git

Debian packages are available from
	http://ceph.newdream.net/debian

The Ceph home page is at
	http://ceph.newdream.net

[1] Snapshots
        http://marc.info/?l=linux-fsdevel&m=122341525709480&w=2
[2] Recursive accounting
        http://marc.info/?l=linux-fsdevel&m=121614651204667&w=2

---
 Documentation/filesystems/ceph.txt |  175 +++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/ceph/Kconfig                    |   20 +
 fs/ceph/Makefile                   |   35 +
 fs/ceph/addr.c                     | 1027 ++++++++++++++++
 fs/ceph/bookkeeper.c               |  117 ++
 fs/ceph/bookkeeper.h               |   19 +
 fs/ceph/caps.c                     | 1900 ++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h               |  103 ++
 fs/ceph/ceph_fs.h                  | 1355 ++++++++++++++++++++
 fs/ceph/ceph_ver.h                 |    6 +
 fs/ceph/crush/crush.c              |  139 +++
 fs/ceph/crush/crush.h              |  179 +++
 fs/ceph/crush/hash.h               |   80 ++
 fs/ceph/crush/mapper.c             |  536 ++++++++
 fs/ceph/crush/mapper.h             |   19 +
 fs/ceph/decode.h                   |  151 +++
 fs/ceph/dir.c                      |  837 +++++++++++++
 fs/ceph/export.c                   |  143 +++
 fs/ceph/file.c                     |  432 +++++++
 fs/ceph/inode.c                    | 2090 +++++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                    |   62 +
 fs/ceph/ioctl.h                    |   12 +
 fs/ceph/mds_client.c               | 2391 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h               |  314 +++++
 fs/ceph/mdsmap.c                   |  118 ++
 fs/ceph/mdsmap.h                   |   94 ++
 fs/ceph/messenger.c                | 2389 +++++++++++++++++++++++++++++++++++
 fs/ceph/messenger.h                |  267 ++++
 fs/ceph/mon_client.c               |  450 +++++++
 fs/ceph/mon_client.h               |  109 ++
 fs/ceph/osd_client.c               | 1173 ++++++++++++++++++
 fs/ceph/osd_client.h               |  142 +++
 fs/ceph/osdmap.c                   |  641 ++++++++++
 fs/ceph/osdmap.h                   |  106 ++
 fs/ceph/snap.c                     |  883 +++++++++++++
 fs/ceph/super.c                    | 1120 +++++++++++++++++
 fs/ceph/super.h                    |  813 ++++++++++++
 fs/ceph/sysfs.c                    |  465 +++++++
 fs/ceph/types.h                    |   20 +
 41 files changed, 20934 insertions(+), 0 deletions(-)
