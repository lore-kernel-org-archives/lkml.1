Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZEHSfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZEHSfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZEHSf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:18303 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZEHSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kS3AcJfxBFruTfNCQ3vZgNRaKkR97fRbw1/PQr6HIzPOSIEYMXQe4cgeoYu6Icjbdz
         1PUBIqi4ow9NtqA+2b24vpFhQ8sIWQR78A5T0LVXe9ZFjcMRLz9M8gZ+h2H/uN2StXud
         4qfUuH9LGGqnRv1yt8PBSM0rgVEjuoBjRFyhI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 0/7] kill-the-bkl/reiserfs performances updates
Date: Fri,  8 May 2009 20:35:17 +0200
Message-Id: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, everyone,

This patchset is the result of some lock tracing and analysis.

After doing a dbench test on SMP (2 CPUS) with 100 procs during
about 300 secs, I get the following throughput:

With the bkl:
	40 MB/s
With the write lock before this patchset:
	31 MB/s
With the write lock after this patchset:
	36 MB/s

There is still some work to do but it's a good progress.
It seems to depend on the remaining disk space, sometimes I reach
almost the same performances, sometimes it's lower.

For those who want to test it against -rc4, you can pull on the tree
described below, it's a migration of the reiserfs work that was done
in Ingo's tip:core/kill-the-bkl + this patchset.

Thanks,
Frederic.

The following changes since commit e26767ea29f0eb3271e03ba5355c645e2b39939f:
  Frederic Weisbecker (1):
        kill-the-BKL/reiserfs: release the write lock on flush_commit_list()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-the-bkl

Frederic Weisbecker (7):
      kill-the-BKL/reiserfs: add reiserfs_cond_resched()
      kill-the-bkl/reiserfs: conditionaly release the write lock on fs_changed()
      kill-the-bkl/reiserfs: lock only once on reiserfs_get_block()
      kill-the-bkl/reiserfs: don't hold the write recursively in reiserfs_lookup()
      kill-the-bkl/reiserfs: reduce number of contentions in search_by_key()
      kill-the-bkl/reiserfs: factorize the locking in reiserfs_write_end()
      kill-the-bkl/reiserfs: use mutex_lock in reiserfs_mutex_lock_safe

 fs/reiserfs/inode.c         |   44 +++++++++++++++++++++++++-----------------
 fs/reiserfs/journal.c       |    8 ++----
 fs/reiserfs/namei.c         |   15 ++++++++++---
 fs/reiserfs/stree.c         |   12 ++++++++++-
 include/linux/reiserfs_fs.h |   17 +++++++++++++--
 5 files changed, 65 insertions(+), 31 deletions(-)
