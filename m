Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZHQKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZHQKei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757415AbZHQKef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:34:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44342 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbZHQKed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:34:33 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: zach.brown@oracle.com
Subject: [PATCH 0/3] Page based O_DIRECT and O_DIRECT loop
Date: Mon, 17 Aug 2009 12:34:31 +0200
Message-Id: <1250505274-17108-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.53.g3f55e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently it's not feasible to use loop for O_DIRECT workloads
that expect some sort of data integrity, since loop always
uses page cache IO. Some time ago, I posted a variant of loop
that used remapping to function like a proper disk, but that patch
was a bit fragile in that it relied loop maintaining a fs block
remapping tree. This time I wanted to take a different approach.

The first two patches in this series convert the O_DIRECT IO path
to be page based instead of passing down the iovecs. This is
basically a first version so don't expect too much of it, but it
does seem to work fine for me. Most O_DIRECT users were one-liner
conversions, NFS required a bit more effort (and that effort has, btw,
not been tested at all yet). At least the diffstat for the core bits
don't look too bad:

 fs/block_dev.c              |    5 
 fs/btrfs/inode.c            |    3 
 fs/direct-io.c              |  347 ++++++++++++++++--------------------
 fs/ext2/inode.c             |    8 
 fs/ext3/inode.c             |   13 -
 fs/ext4/inode.c             |   13 -
 fs/fat/inode.c              |   10 -
 fs/gfs2/aops.c              |    9 
 fs/hfs/inode.c              |    7 
 fs/hfsplus/inode.c          |    6 
 fs/jfs/inode.c              |    7 
 fs/nfs/direct.c             |  171 ++++++-----------
 fs/nfs/file.c               |    8 
 fs/nilfs2/inode.c           |    7 
 fs/ocfs2/aops.c             |    7 
 fs/reiserfs/inode.c         |    6 
 fs/xfs/linux-2.6/xfs_aops.c |   12 -
 include/linux/aio.h         |    3 
 include/linux/fs.h          |   61 ++++--
 include/linux/nfs_fs.h      |   10 -
 mm/filemap.c                |    9 
 21 files changed, 323 insertions(+), 399 deletions(-)

So just consider this an RFC, comments?

-- 
Jens Axboe

