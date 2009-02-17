Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZBQILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZBQILq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZBQIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:10:48 -0500
Received: from sh.osrg.net ([192.16.179.4]:55116 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZBQIKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:10:43 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm 0/6] nilfs2 ioctl cleanups (change ioctl API)
Date: Tue, 17 Feb 2009 16:42:00 +0900
Message-Id: <1234856526-1947-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Feb 2009 17:10:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set takes some review comments and correct compatibility
problems on ioctl of the nilfs2 filesystem.

Due to improper design of the previous interface, it had arch
dependent problems such as variable sized fields or alignment issue of
structures.  This resolves them and eliminates compat code.

This will once break ioctl-API compatibility and require update of
userland tools.  However, I think it is better if I just straighten
things out and release new nilfs-utils.  The disk format has not
changed by this.

In addition to the related modifications, one or two changes that need
revision of the ioctl API are included together to take this occasion.

Summary of changes:

 * use fixed sized types and fix alignment issues for ioctl
   structures.
 * remove compat ioctl code.
 * use ->unlocked_ioctl instead of ->ioctl to avoid BKL.
 * remove TIMEDWAIT ioctl command which has been used to give a
   poll-like feature to userland cleaner program.
 * convert BUG_ON() and BUG() calls to proper error handlings or
   WARN_ON() calls; this will prevent ioctls from triggering the
   formers.
 * add an argument to nilfs_sustat ioctl structure to simplify
   management of state whether each segment (disk region) is
   reclaimable or not.

The corresponding userland package (nilfs-utils) is available from
git repos on the following site:

  http://www.nilfs.org/git/

Thanks to Pekka Enberg, Chris Mason and people giving us feedback.

Regards,
Ryusuke Konishi
---

 fs/nilfs2/btree.c         |   27 +--
 fs/nilfs2/cpfile.c        |   38 +++--
 fs/nilfs2/dat.c           |   15 +-
 fs/nilfs2/dir.c           |    4 +-
 fs/nilfs2/direct.c        |   13 +-
 fs/nilfs2/file.c          |    4 +-
 fs/nilfs2/inode.c         |   19 +--
 fs/nilfs2/ioctl.c         |  401 ++++++---------------------------------------
 fs/nilfs2/mdt.c           |    4 +-
 fs/nilfs2/nilfs.h         |    4 +-
 fs/nilfs2/page.c          |   10 +-
 fs/nilfs2/recovery.c      |   35 ++--
 fs/nilfs2/segment.c       |  122 ++++----------
 fs/nilfs2/sufile.c        |   33 +++--
 fs/nilfs2/super.c         |   12 +-
 fs/nilfs2/the_nilfs.c     |   19 --
 fs/nilfs2/the_nilfs.h     |   11 +-
 include/linux/nilfs2_fs.h |   96 ++---------
 18 files changed, 213 insertions(+), 654 deletions(-)


