Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbYJGVZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbYJGVZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYJGVYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:24:35 -0400
Received: from cobra.newdream.net ([66.33.216.30]:60715 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbYJGVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:24:34 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 17:24:33 EDT
Date: Tue, 7 Oct 2008 14:05:57 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Ceph distributed file system v0.4 (snapshot support)
Message-ID: <Pine.LNX.4.64.0810011131520.19745@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ceph is a distributed file system designed for performance, reliability, 
and scalability.  Basic features include:

 * POSIX semantics
 * Seamless scaling from 1 to many thousands of nodes, petabytes of storage
 * No single point of failure
 * N-way replication of data across storage nodes
 * Fast recovery from node failures
 * Automatic rebalancing of data on node addition/removal
 * Easy deployment: most FS components are userspace daemons

New in this release:

 * Flexible snapshots (create snapshots of _any_ subdirectory)
 * Recursive accounting for size, ctime, file counts
 * Lots of client bug fixes and improvements, including asynchronous 
writepages, additional crc protection of network messages, sendpage 
(zero-copy writes where supported).

The main new item in this release is the snapshot support.  Unlike 
snapshots in most other file systems, Ceph snapshots are not 
volume-wide; they can be created on a per-subdirectory (tree) basis.  That 
is, you can do something like

 $ cd /ceph
 $ mkdir foo/.snap/foo_snap
 $ ls foo/.snap
 foo_snap
 $ mkdir foo/bar/.snap/bar_snap
 $ ls foo/bar/.snap
 _1223284321_foo_snap    # parents' snaps are preceeded by parent's ino #
 bar_snap

A read-only view of the subdirectory's content at the time of snapshot 
creation is available from the virtual .snap/$snapname directory.  
Snapshots include accurate recursive accounting statistics (like rsize, 
which reflects the total size of all files nested beneath a directory, and 
is reported by default as a directory's st_size).  For example,

 $ cd test
 $ tar jxf something.tar.bz2 &
 $ mkdir .snap/1
 $ mkdir .snap/2
 $ killall %1
 $ ls -al .snap
 total 0
 drwxr-xr-x 1 root root       0 Jan  1  1970 .   # virtual ".snap" dir
 drwxr-xr-x 1 root root 3590037 Oct  7 20:36 ..  # the "live" dir is biggest
 drwxr-xr-x 1 root root 1220238 Oct  7 20:36 1 
 drwxr-xr-x 1 root root 2366114 Oct  7 20:36 2

Snapshot removal is as simple as

 $ rmdir foo/.snap/foo_snap

The kernel client has stabilized significantly in the last few months.  
The next release will focus on improving the failure recovery behavior of 
the storage cloud (mainly, throttling recovery and snap removal versus 
client workloads), responding intelligently to partial failures (EIO on 
individual file objects), coping with ENOSPC conditions, and general 
stability improvements.

More information at

	http://ceph.newdream.net/

Source at

	git clone git://ceph.newdream.net/ceph.git

Thanks-
sage

