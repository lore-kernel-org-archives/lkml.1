Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYINTO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYINTO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYINTJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:09:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:50991 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbYINTJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:09:09 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/27] nilfs2: continuous snapshotting file system
Date: Mon, 15 Sep 2008 04:07:57 +0900
Message-Id: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new patch set for the nilfs2 file system.

The first submission is found at:

 http://marc.info/?l=linux-fsdevel&m=121920195516073

The old patch was not divided, and this time I divided it into 27
patches:

 The patch #1 adds a document to Documentation/filesystems/
 The patch #2 adds a header file of the disk format to include/linux/
 The patches #2-#26 adds nilfs2 source files to fs/nilfs2/
 and the patch #27 updates Makefile and Kconfig.

This patch set also includes some cleanups and improvements.  The main
changes from the previous patch are as follows:

 * Use the standard mm/ cache instead of uniquely implemented page
   cache to hold B-tree node buffers; the peculiar page cache was
   removed by this.

 * Integrate two similar allocators found in DAT and inode file.

 * Read requests for GC blocks are now submitted in parallel to
   mitigate GC overhead.

More than 2,000 lines are reduced by the cleanups.


The patch set is available from

 http://www.nilfs.org/pub/patch/nilfs2-2.6.27-rc6/

If you like a git tree:

 http://git.nilfs.org/nilfs2-2.6.git nilfs2
 ( gitweb: http://www.nilfs.org/git/?p=nilfs2-2.6.git )

The userland tools are included in the nilfs-utils package
which is available on

 http://www.nilfs.org/en/download.html


Example:
In this example, /dev/sdb1 is used as a nilfs2 partition.

- To use nilfs2 as a local file system, simply:

 # mkfs -t nilfs2 /dev/sdb1
 # mount -t nilfs2 /dev/sdb1 /dir

 This will also invoke the cleaner through the mount helper program
 (mount.nilfs2).

- Checkpoints and snapshots are managed by the following commands.
 Their manpages are included in the nilfs-utils package.

  lscp     list checkpoints or snapshots.
  mkcp     make a checkpoint or a snapshot.
  chcp     change an existing checkpoint to a snapshot or vice versa.
  rmcp     invalidate specified checkpoint(s).

 For example,

 # lscp /dev/sdb1

 will list checkpoints on the device.
 The block device argument is omissible if there is no other nilfs2
 partition.

 # chcp ss 2

 will change the past checkpoint No. 2 into snapshot.

 # mkcp -s

 will make a snapshot of the current state.

 # lscp -s

 will list snapshots

- To mount a snapshot, use the read-only option and cp= option.

 # mount -t nilfs2 -r -o cp=<cno> /dev/sdb1 /snap_dir

 where <cno> is the checkpoint number of the snapshot.
 Snapshots are mountable concurrently with the writable mount.



