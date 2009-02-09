Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZBILtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZBILtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZBILtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:49:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44614 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbZBILs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:48:59 -0500
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
From: Peter Zijlstra <peterz@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090209112321.GW28946@ZenIV.linux.org.uk>
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com>
	 <20090209112321.GW28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 12:48:51 +0100
Message-Id: <1234180131.5951.85.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 11:23 +0000, Al Viro wrote:
> On Thu, Jan 08, 2009 at 11:45:43AM +0800, Li Zefan wrote:
> > Hi Al Viro,
> > 
> > I hacked into the kernel with the patch below (I think It's ok for me
> > to comment out bdev->bd_mount_sem for testing):
> 
> > And ran 2 threads:
> > 	for ((; ;))  # thread 1
> > 	{
> > 		mount -t ext3 /dev/sda9 /mnt1
> > 		umount /mnt1
> > 	}
> > 
> > 	for ((; ;))  # thread 2
> > 	{
> > 		mount -t ext3 /dev/sda9 /mnt2
> > 		umount /mnt2
> > 	}
> > 
> > And I got the same lockdep warning immediately, so I think it's
> > VFS's issue.
> 
> It's a lockdep issue, actually.  It _is_ a false positive; we could get rid
> of that if we took destroy_super(s); just before grab_super(), but I really
> do not believe that there's any point.
> 
> Frankly, I'd rather see if there's any way to teach lockdep that this instance
> of lock is getting initialized into "one writer" state and that yes, we know
> that it's not visible to anyone, so doing that is safe, TYVM, even though
> we are under spinlock.  Then take that sucker to just before set().
> 
> In any case, I really do not believe that it might have anything to do with
> the WARN_ON() from another thread...
> 
> Comments?

It seems to me we can simply put the new s_umount instance in a
different subclass. Its a bit unusual to use _nested for the outer lock,
but lockdep doesn't particularly cares about subclass order.

If there's any issue with the callers of sget() assuming the s_umount
lock being of sublcass 0, then there is another annotation we can use to
fix that, but lets not bother with that if this is sufficient.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/super.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 645e540..34ddc86 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -82,7 +82,22 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		 * lock ordering than usbfs:
 		 */
 		lockdep_set_class(&s->s_lock, &type->s_lock_key);
-		down_write(&s->s_umount);
+		/*
+		 * sget() can have s_umount recursion.
+		 *
+		 * When it cannot find a suitable sb, it allocates a new
+		 * one (this one), and tries again to find a suitable old
+		 * one.
+		 *
+		 * In case that succeeds, it will acquire the s_umount
+		 * lock of the old one. Since these are clearly distrinct
+		 * locks, and this object isn't exposed yet, there's no
+		 * risk of deadlocks.
+		 *
+		 * Annotate this by putting this lock in a different
+		 * subclass.
+		 */
+		down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);
 		s->s_count = S_BIAS;
 		atomic_set(&s->s_active, 1);
 		mutex_init(&s->s_vfs_rename_mutex);


