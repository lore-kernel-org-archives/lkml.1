Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZFSWbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZFSWbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbZFSWa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:30:56 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44711 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFSWay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:30:54 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/21] ceph: Ceph distributed file system client v0.9
Date: Fri, 19 Jun 2009 15:31:21 -0700
Message-Id: <1245450702-31343-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series for v0.9 of the Ceph distributed file system
client (against v2.6.30).

Greg, the first patch in the series creates an fs/staging/ directory.
This is analogous to drivers/staging/ (not built by allyesconfig,
modpost will mark the module with 'staging', etc.), except you can
find it under the File Systems section (and it doesn't get hidden
along with drivers/ on UML).

If that looks reasonable, I would love to see this go into the staging
tree.  The remaining patches add Ceph at fs/staging/ceph.

Changes since v0.7 (the last lkml series):
 * Fixes to readdir (versus llseek())
 * Fixed problem with snapshots versus truncate()
 * Responds to memory pressure from the MDS, to avoid pinning
   to much memory on the server
 * CRUSH algorithm fixes, improvements
 * Protocol updates to match userspace
 * Bug fixes

The patchset is based on 2.6.30, and can be pulled from
    git://ceph.newdream.net/linux-ceph-client.git master

As always, questions, comments, and/or review are most welcome.

Thanks!
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

A standalone tree with just the client kenrel module is at
	git://ceph.newdream.net/ceph-client.git

The source for the full system is at
	git://ceph.newdream.net/ceph.git

The corresponding user space daemons need to be built in order to test
it.  Instructions for getting a test setup running are at
        http://ceph.newdream.net/wiki/

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
 fs/Kconfig                         |    2 +
 fs/Makefile                        |    1 +
 fs/staging/Kconfig                 |   48 +
 fs/staging/Makefile                |    6 +
 fs/staging/ceph/Kconfig            |   14 +
 fs/staging/ceph/Makefile           |   35 +
 fs/staging/ceph/addr.c             | 1101 +++++++++++++++
 fs/staging/ceph/caps.c             | 2499 +++++++++++++++++++++++++++++++++
 fs/staging/ceph/ceph_debug.h       |   86 ++
 fs/staging/ceph/ceph_fs.h          |  913 ++++++++++++
 fs/staging/ceph/ceph_ver.h         |    6 +
 fs/staging/ceph/crush/crush.c      |  140 ++
 fs/staging/ceph/crush/crush.h      |  188 +++
 fs/staging/ceph/crush/hash.h       |   90 ++
 fs/staging/ceph/crush/mapper.c     |  597 ++++++++
 fs/staging/ceph/crush/mapper.h     |   19 +
 fs/staging/ceph/debugfs.c          |  607 ++++++++
 fs/staging/ceph/decode.h           |  151 ++
 fs/staging/ceph/dir.c              | 1129 +++++++++++++++
 fs/staging/ceph/export.c           |  156 +++
 fs/staging/ceph/file.c             |  794 +++++++++++
 fs/staging/ceph/inode.c            | 2356 +++++++++++++++++++++++++++++++
 fs/staging/ceph/ioctl.c            |   65 +
 fs/staging/ceph/ioctl.h            |   12 +
 fs/staging/ceph/mds_client.c       | 2694 ++++++++++++++++++++++++++++++++++++
 fs/staging/ceph/mds_client.h       |  347 +++++
 fs/staging/ceph/mdsmap.c           |  132 ++
 fs/staging/ceph/mdsmap.h           |   45 +
 fs/staging/ceph/messenger.c        | 2394 ++++++++++++++++++++++++++++++++
 fs/staging/ceph/messenger.h        |  273 ++++
 fs/staging/ceph/mon_client.c       |  451 ++++++
 fs/staging/ceph/mon_client.h       |  135 ++
 fs/staging/ceph/msgr.h             |  155 +++
 fs/staging/ceph/osd_client.c       |  987 +++++++++++++
 fs/staging/ceph/osd_client.h       |  151 ++
 fs/staging/ceph/osdmap.c           |  703 ++++++++++
 fs/staging/ceph/osdmap.h           |   83 ++
 fs/staging/ceph/rados.h            |  398 ++++++
 fs/staging/ceph/snap.c             |  895 ++++++++++++
 fs/staging/ceph/super.c            | 1200 ++++++++++++++++
 fs/staging/ceph/super.h            |  946 +++++++++++++
 fs/staging/ceph/types.h            |   27 +
 fs/staging/fsstaging.c             |   19 +
 scripts/mod/modpost.c              |    4 +-
 45 files changed, 23228 insertions(+), 1 deletions(-)
