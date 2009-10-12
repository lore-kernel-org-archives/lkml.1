Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbZJLWZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbZJLWZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbZJLWZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:25:53 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:43572 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbZJLWZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jFHFONPTVGxPJ6/2fA670aPIQGxk1dQbtitpMZkGTHhag2g2mDeDP5LCYExO/2wAgf
         f2+ocMIQQ3hI+nX8pmPq1uZGOzlyRuIaZaRFKlYBNbuaA47tbhPiQINKm5z0ZhBRQl0O
         mJj7HxDCvjJhtTBHsXvBACg0CZeD0g1dvIPKM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH] kill-the-bkl/reiserfs: fix reiserfs lock to cpu_add_remove_lock dependency
Date: Tue, 13 Oct 2009 00:25:02 +0200
Message-Id: <1255386309-4992-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
References: <1255386309-4992-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While creating the reiserfs workqueue during the journal
initialization, we are holding the reiserfs lock, but
create_workqueue() also holds the cpu_add_remove_lock, creating
then the following dependency:

- reiserfs lock -> cpu_add_remove_lock

But we also have the following existing dependencies:

- mm->mmap_sem -> reiserfs lock
- cpu_add_remove_lock -> cpu_hotplug.lock -> slub_lock -> sysfs_mutex

The merged dependency chain then becomes:

- mm->mmap_sem -> reiserfs lock -> cpu_add_remove_lock ->
	cpu_hotplug.lock -> slub_lock -> sysfs_mutex

But when we fill a dir entry in sysfs_readir(), we are holding the
sysfs_mutex and we also might fault while copying the directory entry
to the user, leading to the following dependency:

- sysfs_mutex -> mm->mmap_sem

The end result is then a lock inversion between sysfs_mutex and
mm->mmap_sem, as reported in the following lockdep warning:

[ INFO: possible circular locking dependency detected ]
2.6.31-07095-g25a3912 #4
-------------------------------------------------------
udevadm/790 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<c1098942>] might_fault+0x72/0xc0

but task is already holding lock:
 (sysfs_mutex){+.+.+.}, at: [<c110813c>] sysfs_readdir+0x7c/0x260

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #5 (sysfs_mutex){+.+.+.}:
      [...]

-> #4 (slub_lock){+++++.}:
      [...]

-> #3 (cpu_hotplug.lock){+.+.+.}:
      [...]

-> #2 (cpu_add_remove_lock){+.+.+.}:
      [...]

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
      [...]

-> #0 (&mm->mmap_sem){++++++}:
      [...]

This can be fixed by relaxing the reiserfs lock while creating the
workqueue.
This is fine to relax the lock here, we just keep it around to pass
through reiserfs lock checks and for paranoid reasons.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiserfs/journal.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 04e3c42..2f8a7e7 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2933,8 +2933,11 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 	}
 
 	reiserfs_mounted_fs_count++;
-	if (reiserfs_mounted_fs_count <= 1)
+	if (reiserfs_mounted_fs_count <= 1) {
+		reiserfs_write_unlock(sb);
 		commit_wq = create_workqueue("reiserfs");
+		reiserfs_write_lock(sb);
+	}
 
 	INIT_DELAYED_WORK(&journal->j_work, flush_async_commits);
 	journal->j_work_sb = sb;
-- 
1.6.2.3

