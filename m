Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZGOVX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZGOVX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZGOVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:21:10 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42877 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZGOVVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:21:06 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/20] ceph: Ceph distributed file system client v0.10
Date: Wed, 15 Jul 2009 14:24:30 -0700
Message-Id: <1247693090-27796-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v0.10 of the Ceph distributed file system client.

Changes since v0.9:
 - fixed unaligned memory access (thanks for heads up to Stefan Richter)
 - a few code cleanups
 - MDS reconnect and op replay bugfixes.  (The main milestone here is
   stable handling of MDS server failures and restarts, tested by
   running various workloads with the servers in restart loops.)

What would people like to see for this to be merged into fs/?

Thanks-
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

The corresponding user space daemons need to be built in order to test
it.  Instructions for getting a test setup running are at
        http://ceph.newdream.net/wiki/

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
 Documentation/filesystems/ceph.txt |  181 +++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/ceph/Kconfig                    |   14 +
 fs/ceph/Makefile                   |   35 +
 fs/ceph/addr.c                     | 1099 ++++++++++++++
 fs/ceph/caps.c                     | 2570 +++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h               |   86 ++
 fs/ceph/ceph_fs.h                  |  924 ++++++++++++
 fs/ceph/ceph_ver.h                 |    6 +
 fs/ceph/crush/crush.c              |  140 ++
 fs/ceph/crush/crush.h              |  188 +++
 fs/ceph/crush/hash.h               |   90 ++
 fs/ceph/crush/mapper.c             |  597 ++++++++
 fs/ceph/crush/mapper.h             |   19 +
 fs/ceph/debugfs.c                  |  604 ++++++++
 fs/ceph/decode.h                   |  136 ++
 fs/ceph/dir.c                      | 1129 +++++++++++++++
 fs/ceph/export.c                   |  155 ++
 fs/ceph/file.c                     |  794 +++++++++++
 fs/ceph/inode.c                    | 2357 ++++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                    |   65 +
 fs/ceph/ioctl.h                    |   12 +
 fs/ceph/mds_client.c               | 2775 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h               |  353 +++++
 fs/ceph/mdsmap.c                   |  132 ++
 fs/ceph/mdsmap.h                   |   45 +
 fs/ceph/messenger.c                | 2392 +++++++++++++++++++++++++++++++
 fs/ceph/messenger.h                |  273 ++++
 fs/ceph/mon_client.c               |  454 ++++++
 fs/ceph/mon_client.h               |  135 ++
 fs/ceph/msgr.h                     |  156 ++
 fs/ceph/osd_client.c               |  983 +++++++++++++
 fs/ceph/osd_client.h               |  151 ++
 fs/ceph/osdmap.c                   |  692 +++++++++
 fs/ceph/osdmap.h                   |   83 ++
 fs/ceph/rados.h                    |  419 ++++++
 fs/ceph/snap.c                     |  890 ++++++++++++
 fs/ceph/super.c                    | 1204 ++++++++++++++++
 fs/ceph/super.h                    |  952 ++++++++++++
 fs/ceph/types.h                    |   27 +
 41 files changed, 23319 insertions(+), 0 deletions(-)
