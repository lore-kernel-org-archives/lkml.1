Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224Ab0ABB1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab0ABB1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 20:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183Ab0ABB1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 20:27:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51052 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0ABB1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 20:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CvWWC4eM/tzWfqyd5F7iw6lZoBTP9H+yedY0DKm9NsVA9bJEDxmwHFPLtvX5cYa5FG
         BWgG8XgD8TTtdU3OTq71LxeTDc9H2BO4tRP0h2c7a7PAx4zCCw0MUMGUkx5Gna8WmR74
         Ay6HnU24Ns0dwjMfcsvhmGWdvNENEYCtnWcjQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] reiserfs fixes
Date: Sat,  2 Jan 2010 02:27:16 +0100
Message-Id: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the reiserfs/kill-bkl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

These changes fix a lot of lock inversions, some of them were
triggering soft lockups very easily in xattrs operations.

As the reiserfs lock is a giant lock (in reiserfs scope),
these dependency inversions couldn't get smart fixes without a deep
locking rewrite.

That's why you'll mostly find dependency inversion fixes based on
such pattern:

reiserfs_write_unlock()
mutex_lock(random_lock)
reiserfs_write_lock()

This is not beautiful but at least that's better than the bkl.

Oh and I expect other lock inversions will get reported in
the future due to rare and then yet untested paths.

Thanks,
	Frederic
---

Frederic Weisbecker (13):
      reiserfs: Fix possible recursive lock
      reiserfs: Fix reiserfs lock and journal lock inversion dependency
      reiserfs: Fix reiserfs lock <-> inode mutex dependency inversion
      reiserfs: Fix remaining in-reclaim-fs <-> reclaim-fs-on locking inversion
      reiserfs: Fix reiserfs lock <-> i_xattr_sem dependency inversion
      reiserfs: Warn on lock relax if taken recursively
      reiserfs: Fix reiserfs lock <-> i_mutex dependency inversion on xattr
      reiserfs: Relax reiserfs lock while freeing the journal
      reiserfs: Relax lock before open xattr dir in reiserfs_xattr_set_handle()
      reiserfs: Fix unwanted recursive reiserfs lock in reiserfs_unlink()
      reiserfs: Fix journal mutex <-> inode mutex lock inversion
      reiserfs: Safely acquire i_mutex from reiserfs_for_each_xattr
      reiserfs: Safely acquire i_mutex from xattr_rmdir


 fs/reiserfs/bitmap.c        |    3 +++
 fs/reiserfs/inode.c         |    5 +++--
 fs/reiserfs/journal.c       |   18 ++++++++++++++----
 fs/reiserfs/lock.c          |    9 +++++++++
 fs/reiserfs/namei.c         |    7 ++++---
 fs/reiserfs/xattr.c         |   26 ++++++++++++++++++++------
 include/linux/reiserfs_fs.h |   26 ++++++++++++++++++++++++++
 7 files changed, 79 insertions(+), 15 deletions(-)
