Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZIQFGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZIQFGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZIQFGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:06:45 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60229 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZIQFGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=sJxayN4rYjGZY9aw1UXAgCNRuPM1uKl5ADgcOmSBVBtutuXWbBIiEQTpYU4Al/GbTn
         0t1VvzzlpDtbHuRSyep2Y27wtAk46kWNRmLv8tDC33C7EZy8dvvdpMGhWq3SiBr+AfJX
         cxXRPnXoLffCdaZwIXdLYFQrfg9MCiZqXyEac=
Date: Thu, 17 Sep 2009 07:06:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Jeff Mahoney <jeffm@suse.com>, Chris Mason <chris.mason@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH] kill-the-bkl/reiserfs: Fix induced mm->mmap_sem to
	sysfs_mutex dependency
Message-ID: <20090917050639.GA5060@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere> <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com> <20090916203747.GB5068@nowhere> <a4423d670909161637r67c933a0n2c142898ea493f22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4423d670909161637r67c933a0n2c142898ea493f22@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 03:37:22AM +0400, Alexander Beregalov wrote:
> 2009/9/17 Frederic Weisbecker <fweisbec@gmail.com>:
> > On Tue, Sep 15, 2009 at 01:33:42AM +0400, Alexander Beregalov wrote:
> >> > Hi Alexander,
> >> >
> >> > It should be fixed now, still in the following tree:
> >>
> >> Hi!
> >> Another one, similar:
> >> It is v2.6.31-3123-g99bc470 plus your 805031859(kill-the-bkl/reiserfs:
> >> panic in case of lock imbalance), UP.
> >
> >
> >
> > Although I can't reproduce it, I think I see how that can happen.
> >
> > On mount time, we have the following dependency:
> >
> > reiserfs_lock -> bdev_mutex -> sysfs_mutex
> >
> > which happens while calling journal_init_dev() because
> > we open the device there.
> >
> > But also in case of mmap on a reiserfs filesystem we
> > may call reiserfs_readpages(), holding the reiserfs lock
> > while already holding mm->mmap_sem
> >
> > The above dependency is then updated:
> >
> > mmap_sem
> >     |
> >     |
> >     ------- reiserfs_lock -> bdev_mutex -> sysfs_mutex
> >
> > And later, while doing a readdir() on a sysfs directory,
> > sysfs calls filldir, which might_fault, and then might grab
> > mmap_sem. filldir is called there while holding sys_mutex,
> > creating the new following dependency
> >
> > sysfs_mutex -> mmap_sem
> >
> > Hence the inversion.
> > It seems the deadlock can't ever happen, I even don't see
> > corner cases where it could happen.
> >
> > But still, this dependency should disappear.
> >
> > Could you please tell me if the following patch makes it shut down?
> >
> > Otherwise, I may need your config. I don't know why, but I suspect
> > the lock_acquire(mmap_sem) in might_fault doesn't trigger needed the lockdep
> > check, although I have the appropriate debug config, at least it seems.
> > But anyway, it should also happen in my box but it doesn't...
> >
> > Thanks!
> >
> > The patch:
> Yes, it is working!


Great, I've pushed the fix then, see the following patch.

Thanks a lot Alexander!

---
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 17 Sep 2009 05:31:37 +0200
Subject: [PATCH] kill-the-bkl/reiserfs: Fix induced mm->mmap_sem to sysfs_mutex dependency

Alexander Beregalov reported the following warning:

	=======================================================
	[ INFO: possible circular locking dependency detected ]
	2.6.31-03149-gdcc030a #1
	-------------------------------------------------------
	udevadm/716 is trying to acquire lock:
	 (&mm->mmap_sem){++++++}, at: [<c107249a>] might_fault+0x4a/0xa0

	but task is already holding lock:
	 (sysfs_mutex){+.+.+.}, at: [<c10cb9aa>] sysfs_readdir+0x5a/0x200

	which lock already depends on the new lock.

	the existing dependency chain (in reverse order) is:

	-> #3 (sysfs_mutex){+.+.+.}:
	       [...]

	-> #2 (&bdev->bd_mutex){+.+.+.}:
	       [...]

	-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
	       [...]

	-> #0 (&mm->mmap_sem){++++++}:
	       [...]

On reiserfs mount path, we take the reiserfs lock and while
initializing the journal, we open the device, taking the
bdev->bd_mutex. Then rescan_partition() may signal the change
to sysfs.

We have then the following dependency:

	reiserfs_lock -> bd_mutex -> sysfs_mutex

Later, while entering reiserfs_readpage() after a pagefault in an
mmaped reiserfs file, we are holding the mm->mmap_sem, and we are going
to take the reiserfs lock too.
We have then the following dependency:

	mm->mmap_sem -> reiserfs_lock

which, expanded with the previous dependency gives us:

	mm->mmap_sem -> reiserfs_lock -> bd_mutex -> sysfs_mutex

Now while entering the sysfs readdir path, we are holding the
sysfs_mutex. And when we copy a directory entry to the user buffer, we
might fault and then take the mm->mmap_sem lock. Which leads to the
circular locking dependency reported.

We can fix that by relaxing the reiserfs lock during the call to
journal_init_dev(), which is the place where we open the mounted
device.

This is fine to relax the lock here because we are in the begining of
the reiserfs mount path and there is nothing to protect at this time,
the journal is not intialized.
We just keep this lock around for paranoid reasons.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
---
 fs/reiserfs/journal.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index d23d6d7..04e3c42 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2801,11 +2801,27 @@ int journal_init(struct super_block *sb, const char *j_dev_name,
 		goto free_and_return;
 	}
 
+	/*
+	 * We need to unlock here to avoid creating the following
+	 * dependency:
+	 * reiserfs_lock -> sysfs_mutex
+	 * Because the reiserfs mmap path creates the following dependency:
+	 * mm->mmap -> reiserfs_lock, hence we have
+	 * mm->mmap -> reiserfs_lock ->sysfs_mutex
+	 * This would ends up in a circular dependency with sysfs readdir path
+	 * which does sysfs_mutex -> mm->mmap_sem
+	 * This is fine because the reiserfs lock is useless in mount path,
+	 * at least until we call journal_begin. We keep it for paranoid
+	 * reasons.
+	 */
+	reiserfs_write_unlock(sb);
 	if (journal_init_dev(sb, journal, j_dev_name) != 0) {
+		reiserfs_write_lock(sb);
 		reiserfs_warning(sb, "sh-462",
 				 "unable to initialize jornal device");
 		goto free_and_return;
 	}
+	reiserfs_write_lock(sb);
 
 	rs = SB_DISK_SUPER_BLOCK(sb);
 
-- 
1.6.2.3



