Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZJESND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZJESND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZJESND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:13:03 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:63355 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZJESM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N3g7iZz4xRH6+UZk62UOgZCECnlSscUBdvn9NX7M9DLa1nX9ChuSjpSLHugISk0k4I
         itJdqJH92WQ099ZfZJ48m0XZ4a6l3fM51cyFewKDhV2SUq7D7tUspiDj2DJcV0VHGYb6
         BV4c3ikPGGB2nC+ZovN2rHX7gvOc8TMQPfUYE=
Date: Mon, 5 Oct 2009 20:12:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, Chris Mason <chris.mason@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH] kill-the-bkl/reiserfs: fix reiserfs lock to
	cpu_add_remove_lock dependency
Message-ID: <20091005181218.GB5218@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere> <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com> <20090916203747.GB5068@nowhere> <a4423d670909161637r67c933a0n2c142898ea493f22@mail.gmail.com> <20090917050639.GA5060@nowhere> <a4423d670909220655j37cc49f8rcd29d8f154c5e6e6@mail.gmail.com> <20090929074640.GA5233@nowhere> <a4423d670909290322u4c1dd886tf55a2ea4a4a0977@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670909290322u4c1dd886tf55a2ea4a4a0977@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 02:22:42PM +0400, Alexander Beregalov wrote:
> 2009/9/29 Frederic Weisbecker <fweisbec@gmail.com>:
> > Yeah indeed, it's about the same kind of thing.
> > Could you please test the following patch?
> 
> Thanks, the warning has gone away.


Thanks a lot Alexander, your tests and reports are very precious!

I've pushed the commit below, as usual it can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

---
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 5 Oct 2009 16:31:37 +0200
Subject: [PATCH] kill-the-bkl/reiserfs: fix reiserfs lock to cpu_add_remove_lock dependency

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



