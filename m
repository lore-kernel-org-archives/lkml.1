Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbZCaUso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbZCaUso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZCaUsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:48:35 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:55794 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZCaUse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:48:34 -0400
Subject: [GIT PULL] Btrfs updates for 2.6.30-rc
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 16:47:12 -0400
Message-Id: <1238532432.12564.27.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49D28156.0139:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Here is the first round of btrfs fixes for the next merge window.  The
majority of this code is to reduce btrfs stack usage by doing extent
tree updates at a different time.  It generally makes btrfs usable on 4k
stacks, although more stack reduction work will be done later on.

The second commit from the bottom adds extra ordering for renames and
truncates to bring back the ext3 flavor everyone has been missing.  I
tried pretty hard to keep performance impact low, most workloads will
never notice it (including those that fsync).

Linus, please pull the master branch from:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Chris Mason (18):
      Btrfs: don't preallocate metadata blocks during btrfs_search_slot
      Btrfs: do extent allocation and reference count updates in the background
      Btrfs: reduce stack usage in some crucial tree balancing functions
      Btrfs: try to cleanup delayed refs while freeing extents
      Btrfs: process the delayed reference queue in clusters
      Btrfs: reduce stalls during transaction commit
      Btrfs: reduce stack in cow_file_range
      Btrfs: Check for a blocking lock before taking the spin
      Btrfs: Only let very young transactions grow during commit
      Btrfs: leave btree locks spinning more often
      Btrfs: readahead checksums during btrfs_finish_ordered_io
      Btrfs: limit balancing work while flushing delayed refs
      Btrfs: Make sure i_nlink doesn't hit zero too soon during log replay
      Btrfs: tree logging unlink/rename fixes
      Btrfs: optimize fsyncs on old files
      Btrfs: make sure btrfs_update_delayed_ref doesn't increase ref_mod
      Btrfs: add extra flushing for renames and truncates
      Btrfs: try to free metadata pages when we free btree blocks

 fs/btrfs/Makefile       |    2
 fs/btrfs/btrfs_inode.h  |   31
 fs/btrfs/ctree.c        |  588 +++++++++-------
 fs/btrfs/ctree.h        |   69 +
 fs/btrfs/delayed-ref.c  |  669 +++++++++++++++++++
 fs/btrfs/delayed-ref.h  |  193 +++++
 fs/btrfs/dir-item.c     |    3
 fs/btrfs/disk-io.c      |   81 +-
 fs/btrfs/disk-io.h      |    1
 fs/btrfs/extent-tree.c  | 1674 +++++++++++++++---------------------------------
 fs/btrfs/extent_io.c    |   51 -
 fs/btrfs/extent_io.h    |    3
 fs/btrfs/file-item.c    |    7
 fs/btrfs/file.c         |   50 +
 fs/btrfs/inode-item.c   |    3
 fs/btrfs/inode.c        |  194 ++++-
 fs/btrfs/locking.c      |   21
 fs/btrfs/ordered-data.c |  118 +++
 fs/btrfs/ordered-data.h |    4
 fs/btrfs/transaction.c  |  151 +++-
 fs/btrfs/transaction.h  |    8
 fs/btrfs/tree-defrag.c  |    2
 fs/btrfs/tree-log.c     |  444 ++++++++++--
 fs/btrfs/tree-log.h     |   17
 24 files changed, 2762 insertions(+), 1622 deletions(-)

