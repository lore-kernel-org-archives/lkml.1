Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZDUNZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZDUNZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZDUNZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:25:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:38697 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbZDUNZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:25:22 -0400
Date: Tue, 21 Apr 2009 15:25:18 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 0/13] Per-bdi writeback flusher threads #3
Message-ID: <20090421132518.GB1521@duck.suse.cz>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com> <1239335199.2567.784.camel@ymzhang> <20090410072109.GK5178@kernel.dk> <1239592683.2567.796.camel@ymzhang> <20090417130703.GZ4593@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20090417130703.GZ4593@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 17-04-09 15:07:03, Jens Axboe wrote:
> On Mon, Apr 13 2009, Zhang, Yanmin wrote:
> > On Fri, 2009-04-10 at 09:21 +0200, Jens Axboe wrote:
> > > On Fri, Apr 10 2009, Zhang, Yanmin wrote:
> > > > On Wed, 2009-04-08 at 14:00 +0200, Jens Axboe wrote:
> > > > > Hi,
> > > > >
> > > > > This is the third version of the patchset. Changes since v2:
> > > > Jens,
> > > >
> > > > The patchset forgets kernel/sysctl.c part, so the compilation link fails.
> > >
> > > Yep, noticed that as well. Not really great timing with adding more
> > > pdflush tunables...
> > When I run a fio testing with a partition on one of my machines, I hit below bug
> > checking. It's a ??? fio_mmap_randwrite_4k_preread testing. I'm not sure if it happens
> > after the testing and before the next testing, or just happens when the testing is
> > ongoing. When I see it, next testing stops at the beginning when mounting the partition.
> > 
> > ----------------------sys log--------------------
> > 
> > kernel BUG at fs/jbd/journal.c:1166!
> > invalid opcode: 0000 [#1] SMP
> > last sysfs file: /sys/block/sdb/stat
> > CPU 0
> > Modules linked in: igb
> > Pid: 18329, comm: umount Not tainted 2.6.30-rc1-bdiflusherv3 #1 X8DTN
> > RIP: 0010:[<ffffffff80344747>]  [<ffffffff80344747>] journal_destroy+0x108/0x1b4
> > RSP: 0018:ffff8800bd95fe08  EFLAGS: 00010286
> > RAX: 000000000000c7c7 RBX: ffff8800bc93dc00 RCX: 0000000000000000
> > RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff8800bc93dd64
> > RBP: ffff8800bc93dd64 R08: ffff8800bc93dc88 R09: 00000000bd95fcc0
> > R10: 0000000000000246 R11: 00000000fffffffb R12: ffff8800bd95fe08
> > R13: ffff8800bd95fe20 R14: ffff8800bc93dc98 R15: ffff8800bc93dcc8
> > FS:  00007f3f26c717d0(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 00007f3f263fe000 CR3: 00000000bc18e000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process umount (pid: 18329, threadinfo ffff8800bd95e000, task ffff8800bcdcdca0)
> > Stack:
> >  0000000000000000 ffff8800bcdcdca0 ffffffff8024ddaa ffff8800bd95fe20
> >  ffff8800bd95fe20 ffffffff802e53ac ffff8800bd95fe38 ffff8800bd0e3a00
> >  ffff8800a1ff2400 ffff8800bc93b000 ffff8800bb8cb400 0000000000000000
> > Call Trace:
> >  [<ffffffff8024ddaa>] ? autoremove_wake_function+0x0/0x2e
> >  [<ffffffff802e53ac>] ? mb_cache_shrink+0x22/0x9e
> >  [<ffffffff8032fbcc>] ? ext3_put_super+0x29/0x204
> >  [<ffffffff802ac7ab>] ? generic_shutdown_super+0x70/0xde
> >  [<ffffffff802ac83b>] ? kill_block_super+0x22/0x3a
> >  [<ffffffff802ac8fe>] ? deactivate_super+0x5f/0x77
> >  [<ffffffff802bf20a>] ? sys_umount+0x2da/0x309
> >  [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b
> > Code: ff 48 8d ab 64 01 00 00 eb 0b fe 45 00 48 89 df e8 cc e8 ff ff 48 89 ef e8 2f e8 3d 00 48 83 7b 60 00 75 e6 48 83 7b 50 00 74 04 <0f> 0b eb fe 48 83 7b 58 00 74 04 0f 0b eb fe fe 83 64 01 00 00
> > RIP  [<ffffffff80344747>] journal_destroy+0x108/0x1b4
> >  RSP <ffff8800bd95fe08>
> > ---[ end trace 14f5ccbafee46eb4 ]---
> 
> This is very strange, I have about zero idea why this would trigger. It
> seems to be this:
> 
>         J_ASSERT(journal->j_running_transaction == NULL);
> 
> in journal_destroy(), presumably complaining that we are trying to kill
> a journal that has a running transaction (yes, me read code good).
> Jan Kara is on the CC and he appears to have touched that file the most
> recently. Jan, any ideas on what might make this trigger?
  I've looked into this. What I think is happening:
we umount the filesystem
fsync_super(sb)
  __fsync_super(sb)
    sync_inode_sb(sb, 0) -> submits some inodes
    ...
    ext3_sync_fs() -> wait for transaction commit
    ...
    sync_inodes_sb(sb, 1) -> submits further IO which did not happen before
      -> transaction started
ext3_put_super()
  journal_destroy() -> BUG

  So obviously it has changed how sync_inodes_sb() work. Now the fact that
ext3 relies on all the IO being submitted during sync_inode_sb() is fragile
to say the least (although during umount not that much) - actually a
similar problem is in sys_sync() path... Attached patch should fix it -
it's not final since the sys_sync() path needs some more tweaking but it
should work at least for common filesystems ;).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--pWyiEgJYm5f9v55/
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Write-inodes-reliably-before-calling-write_su.patch"

>From 615ee076495ca9264ef09040f56eae54004e4c26 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 21 Apr 2009 14:24:01 +0200
Subject: [PATCH] vfs: Write inodes reliably before calling ->write_super() and ->sync_fs()

So far, __fsync_super() and do_sync() called sync_inodes(sb, 0), then called
->write_super(), ->sync_fs() and after that called sync_inodes(sb, 1). This
ordering makes it kind of hard for filesystems as sync_inodes(sb, 0) need not
submit all the IO (for example it skips inodes with I_SYNC set) so e.g. forcing
transaction to disk in ->sync_fs() is not really enough. Yes, it means sys_sync
has not been completely reliable on some filesystems (ext3, ext4, reiserfs,
ocfs2 and others are hit by this) when racing e.g. with background writeback. A
similar problem hits also other filesystems (e.g. ext2) because of
write_super() being called before the sync_inodes(sb, 1). Change the ordering
so that inodes are first reliably written out and write_super() and sync_fs()
are called only after that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c |    2 +-
 fs/sync.c  |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 786fe7d..4c12918 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -267,6 +267,7 @@ void __fsync_super(struct super_block *sb)
 {
 	sync_inodes_sb(sb, 0);
 	vfs_dq_sync(sb);
+	sync_inodes_sb(sb, 1);
 	lock_super(sb);
 	if (sb->s_dirt && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
@@ -274,7 +275,6 @@ void __fsync_super(struct super_block *sb)
 	if (sb->s_op->sync_fs)
 		sb->s_op->sync_fs(sb, 1);
 	sync_blockdev(sb->s_bdev);
-	sync_inodes_sb(sb, 1);
 }
 
 /*
diff --git a/fs/sync.c b/fs/sync.c
index 7abc65f..4de4c89 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -26,10 +26,15 @@ static void do_sync(unsigned long wait)
 	wakeup_pdflush(0);
 	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
 	vfs_dq_sync(NULL);
-	sync_supers();		/* Write the superblocks */
 	sync_filesystems(0);	/* Start syncing the filesystems */
+	/*
+	 * We have to reliably submit IO for all the inodes before writing
+	 * super blocks and calling sync_fs(). Otherwise superblock could miss
+	 * some updates or journal could still have uncommitted data.
+	 */
+	sync_inodes(wait);	
+	sync_supers();		/* Write the superblocks */
 	sync_filesystems(wait);	/* Waitingly sync the filesystems */
-	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
 	if (!wait)
 		printk("Emergency Sync complete\n");
 	if (unlikely(laptop_mode))
-- 
1.6.0.2


--pWyiEgJYm5f9v55/--
