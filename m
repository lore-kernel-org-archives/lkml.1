Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0BMM6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 07:58:24 -0500
Received: from borg.medozas.de ([188.40.89.202]:40102 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab0BMM6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 07:58:23 -0500
Date: Sat, 13 Feb 2010 13:58:19 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
Message-ID: <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-02-12 16:45, Linus Torvalds wrote:
>On Fri, 12 Feb 2010, Jens Axboe wrote:
>> 
>> This fixes it by using the passed in page writeback count, instead of
>> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
>> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
>> finish properly even when new pages are being dirted.
>
>This seems broken.

It seems so. Jens, Jan Kara, your patch does not entirely fix this.
While there is no sync/fsync to be seen in these traces, I can
tell there's a livelock, without Dirty decreasing at all.

INFO: task flush-8:0:354 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:0     D 00000000005691a0  5560   354      2 0x28000000000
Call Trace:
 [0000000000568de4] start_this_handle+0x36c/0x520
 [00000000005691a0] jbd2_journal_start+0xb4/0xe0
 [000000000054f99c] ext4_journal_start_sb+0x54/0x9c
 [0000000000540de0] ext4_da_writepages+0x1e0/0x460
 [00000000004ab3e4] do_writepages+0x28/0x4c
 [00000000004f825c] writeback_single_inode+0xf0/0x330
 [00000000004f90a8] writeback_inodes_wb+0x4e4/0x600
 [00000000004f9354] wb_writeback+0x190/0x20c
 [00000000004f967c] wb_do_writeback+0x1d4/0x1f0
 [00000000004f96c0] bdi_writeback_task+0x28/0xa0
 [00000000004b71dc] bdi_start_fn+0x64/0xc8
 [00000000004786f0] kthread+0x58/0x6c
 [000000000042ae7c] kernel_thread+0x30/0x48
 [0000000000478644] kthreadd+0xb8/0x10c
1 lock held by flush-8:0/354:
 #0:  (&type->s_umount_key#18){......}, at: [<00000000004f8fc8>]
 # writeback_inodes_wb+0x404/0x600
INFO: task jbd2/sda6-8:588 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/sda6-8   D 000000000056eea0  7272   588      2 0x18000000000
Call Trace:
 [000000000056976c] jbd2_journal_commit_transaction+0x218/0x15e0
 [000000000056eea0] kjournald2+0x138/0x2fc
 [00000000004786f0] kthread+0x58/0x6c
 [000000000042ae7c] kernel_thread+0x30/0x48
 [0000000000478644] kthreadd+0xb8/0x10c
no locks held by jbd2/sda6-8/588.
INFO: task rpmbuild:6580 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rpmbuild      D 00000000005691a0    16  6580   6562 0x310061101000080
Call Trace:
 [0000000000568de4] start_this_handle+0x36c/0x520
 [00000000005691a0] jbd2_journal_start+0xb4/0xe0
 [000000000054f99c] ext4_journal_start_sb+0x54/0x9c
 [000000000053dcd4] ext4_dirty_inode+0x8/0x3c
 [00000000004f8888] __mark_inode_dirty+0x20/0x15c
 [00000000004eeb34] file_update_time+0x104/0x124
 [00000000004a50d4] __generic_file_aio_write+0x264/0x36c
 [00000000004a5228] generic_file_aio_write+0x4c/0xa4
 [00000000005390c0] ext4_file_write+0x94/0xa4
 [00000000004dc12c] do_sync_write+0x84/0xd4
 [00000000004dca78] vfs_write+0x70/0x12c
 [00000000004dcbcc] SyS_write+0x2c/0x5c
 [0000000000406214] linux_sparc_syscall32+0x34/0x40
1 lock held by rpmbuild/6580:
 #0:  (&sb->s_type->i_mutex_key#9){......}, at: [<00000000004a5214>]
 # generic_file_aio_write+0x38/0xa4
etc.

>
>The whole point of MAX_WRITEBACK_PAGES was to make sure that we don't 
>generate a single IO bigger than a couple of MB. And then we have that 
>loop around things to do multiple chunks. Your change to use nr_pages 
>seems to make the whole looping totally pointless, and breaks that "don't 
>do huge hunks" logic.
>
>So I don't think that your patch is correct.
>
>That said, I _do_ believe you when you say it makes a difference, which 
>makes me think there is a bug there. I just don't think you fixed the 
>right bug, and your change just happens to do what you wanted by pure 
>random luck.
>
>The _real_ bug seems to bethe one you mentioned, but then ignored:
>
>> Instead of flushing everything older than the sync run, it will do 
>> chunks of normal MAX_WRITEBACK_PAGES writeback and restart over and 
>> over.
>
>and it would seem that the _logical_ way to fix it would be something like 
>the appended...
>
>Hmm? Even when you do a 'fdatasync()', it's not going to guarantee that 
>any _future_ data is written back, so the 'oldest_jif' thing would seem to 
>be sane regardless of sync mode.
>
>  NOTE NOTE NOTE! I do have to admit that this patch scares me, because 
>  there could be some bug in the 'older_than_this' logic that means that 
>  somebody sets it even if the inode is already dirty. So this patch makes 
>  conceptual sense to me, and I think it's the right thing to do, but I 
>  also suspect that we do not actually have a lot of test coverage of the 
>  whole 'older_than_this' logic, because it historically has been just a
>  small optimization for kupdated.
>
>  So this patch scares me, as it could break 'fdatasync' entirely. So 
>  somebody should really double-check the whole 'dirtied_when' logic, just 
>  to be safe. If anybody ever sets 'dirtied_when' to the current time even 
>  if the inode is already dirty (and has an earlier dirtied_when'), then 
>  that would open up 'fdatasync()' and friends up to not writing things 
>  back properly at all (because a newer write set 'dirtied_when' so that 
>  old writes get ignored and thought to be 'totally new')
>
>Comments? 
>
>		Linus
>
>---
> fs/fs-writeback.c |   15 ++++++++++-----
> 1 files changed, 10 insertions(+), 5 deletions(-)
>
>diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>index 1a7c42c..a0a8424 100644
>--- a/fs/fs-writeback.c
>+++ b/fs/fs-writeback.c
>@@ -738,11 +738,16 @@ static long wb_writeback(struct bdi_writeback *wb,
> 	long wrote = 0;
> 	struct inode *inode;
> 
>-	if (wbc.for_kupdate) {
>-		wbc.older_than_this = &oldest_jif;
>-		oldest_jif = jiffies -
>-				msecs_to_jiffies(dirty_expire_interval * 10);
>-	}
>+	/*
>+	 * We never write back data that was dirtied _after_ we
>+	 * started writeback. But kupdate doesn't even want to
>+	 * write back recently dirtied stuff, only older data.
>+	 */
>+	oldest_jif = jiffies-1;
>+	wbc.older_than_this = &oldest_jif;
>+	if (wbc.for_kupdate)
>+		oldest_jif -= msecs_to_jiffies(dirty_expire_interval * 10);
>+
> 	if (!wbc.range_cyclic) {
> 		wbc.range_start = 0;
> 		wbc.range_end = LLONG_MAX;
>

