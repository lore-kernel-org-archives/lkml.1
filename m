Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYKNBYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYKNBYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbYKNBWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:22:09 -0500
Received: from cobra.newdream.net ([66.33.216.30]:38161 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYKNBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:21:38 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 00/19] ceph: Ceph distributed file system client
Date: Thu, 13 Nov 2008 16:55:59 -0800
Message-Id: <1226624178-3761-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch series for the client portion of the Ceph distributed 
file system (against v2.6.28-rc2).  Ceph releases have been announced 
here in the past, but no code has yet been posted for review.  My hope 
is for the client to eventually make it to mainline, but I have held off 
on posting anything until now because the network protocols and disk 
format are still changing, and the overall system is not ready for real 
usage (beyond testing and benchmarking).  However, the client itself is 
relatively complete and stable, and the earlier this is seen the better, 
so at Andrew's suggestion I'm sending this out now.  Please let me know 
what you think!

There are a few caveats attached to this patch series:

 * This is the client only.  The corresponding user space daemons need to
   be built in order to test it.  Instructions for getting a test setup
   running on a single node are at
        http://ceph.newdream.net/wiki/Small_test_cluster

 * There is some #ifdef kernel version compatibility cruft that will
   obviously be removed down the line.

 * Some of the IO error paths need a bit of work.  (Should pages be
   left dirty after a write error?  Should we try the write again?
   Etc.)

Any review or comments are appreciated.

Thanks-
sage


---

Ceph is a distributed file system designed for reliability,
scalability, and performance.  The storage system consists of some
(potentially large) number of storage servers (bricks, OSDs), a
smaller set of metadata server daemons, and a few monitor daemons for
managing cluster membership and state.  The storage daemons rely on
btrfs for storing data (and take advantage of btrfs' internal
transactions to keep the local data set in a consistent state).  This
makes the storage cluster simple to deploy, while providing
scalability not typically available from block-based cluster file
systems.

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
symmetric access by all clients to shared block devices, Ceph
separates data and metadata management into independent server
clusters, similar to Lustre.  Unlike Lustre, however, metadata and
object storage services run entirely as user space daemons.  The
storage daemon utilizes btrfs to store data objects, leveraging its
advanced features (transactions, checksumming, metadata replication,
etc.).  File data is striped across storage nodes in large chunks to
distribute workload and facilitate high throughputs. When storage
nodes fail, data is re-replicated in a distributed fashion by the
storage nodes themselves (with some minimal coordination from the
cluster monitor), making the system extremely efficient and scalable.

Metadata servers effectively form a large, consistent, distributed 
in-memory cache above the storage cluster that is scalable, dynamically 
redistributes metadata in response to workload changes, and can tolerate 
arbitrary (well, non-Byzantine) node failures.  The metadata server 
takes a somewhat unconventional approach to metadata storage to 
significantly improve performance for common workloads.  In particular, 
inodes with only a single link are embedded in directories, allowing 
entire directories of dentries and inodes to be loaded into its cache 
with a single I/O operation.  The contents of large directories can be 
fragmented and managed by independent metadata servers, allowing 
scalable concurrent access.

The system offers automatic data rebalancing/migration when scaling from 
a small cluster of just a few nodes to many hundreds, without requiring 
an administrator to carve the data set into static volumes or go through 
the tedious process of migrating data between servers.  When the file 
system approaches full, new storage nodes can be easily added and things 
will "just work."


A git tree containing just the client (and this patch series) is at
        git://ceph.newdream.net/linux-ceph-client.git

The source for the full system is at
        git://ceph.newdream.net/ceph.git

The Ceph home page is at
        http://ceph.newdream.net


[1] Snapshots
        http://marc.info/?l=linux-fsdevel&m=122341525709480&w=2
[2] Recursive accounting
        http://marc.info/?l=linux-fsdevel&m=121614651204667&w=2

---
 Documentation/filesystems/ceph.txt |  173 +++
 fs/Kconfig                         |   20 +
 fs/Makefile                        |    1 +
 fs/ceph/Makefile                   |   35 +
 fs/ceph/addr.c                     | 1010 ++++++++++++++++
 fs/ceph/caps.c                     | 1464 +++++++++++++++++++++++
 fs/ceph/ceph_debug.h               |  130 ++
 fs/ceph/ceph_fs.h                  | 1225 +++++++++++++++++++
 fs/ceph/ceph_tools.c               |  125 ++
 fs/ceph/ceph_tools.h               |   19 +
 fs/ceph/crush/crush.c              |  139 +++
 fs/ceph/crush/crush.h              |  176 +++
 fs/ceph/crush/hash.h               |   80 ++
 fs/ceph/crush/mapper.c             |  507 ++++++++
 fs/ceph/crush/mapper.h             |   19 +
 fs/ceph/decode.h                   |  151 +++
 fs/ceph/dir.c                      |  891 ++++++++++++++
 fs/ceph/export.c                   |  145 +++
 fs/ceph/file.c                     |  446 +++++++
 fs/ceph/inode.c                    | 2070 ++++++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                    |   72 ++
 fs/ceph/ioctl.h                    |   12 +
 fs/ceph/mds_client.c               | 2261 +++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h               |  255 ++++
 fs/ceph/mdsmap.c                   |  123 ++
 fs/ceph/mdsmap.h                   |   41 +
 fs/ceph/messenger.c                | 2304 ++++++++++++++++++++++++++++++++++++
 fs/ceph/messenger.h                |  269 +++++
 fs/ceph/mon_client.c               |  385 ++++++
 fs/ceph/mon_client.h               |  100 ++
 fs/ceph/osd_client.c               | 1125 ++++++++++++++++++
 fs/ceph/osd_client.h               |  135 +++
 fs/ceph/osdmap.c                   |  664 +++++++++++
 fs/ceph/osdmap.h                   |   82 ++
 fs/ceph/proc.c                     |  186 +++
 fs/ceph/snap.c                     |  753 ++++++++++++
 fs/ceph/super.c                    | 1165 ++++++++++++++++++
 fs/ceph/super.h                    |  687 +++++++++++
 fs/ceph/types.h                    |   20 +
 39 files changed, 19465 insertions(+), 0 deletions(-)
