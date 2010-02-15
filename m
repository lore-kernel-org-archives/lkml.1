Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0BOOta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 09:49:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0BOOt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 09:49:29 -0500
Date: Mon, 15 Feb 2010 15:49:39 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jack@suse.cz,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
Message-ID: <20100215144938.GD3434@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
> 
> On Friday 2010-02-12 16:45, Linus Torvalds wrote:
> >On Fri, 12 Feb 2010, Jens Axboe wrote:
> >> 
> >> This fixes it by using the passed in page writeback count, instead of
> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
> >> finish properly even when new pages are being dirted.
> >
> >This seems broken.
> 
> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
> While there is no sync/fsync to be seen in these traces, I can
> tell there's a livelock, without Dirty decreasing at all.
  I don't think this is directly connected with my / Jens' patch.
Similar traces happen even without the patch (see e.g.
http://bugzilla.kernel.org/show_bug.cgi?id=14830). But maybe the patch
makes it worse... So are you able to reproduce these warnings and
without the patch they did not happen?
  Where in the code is jbd2_journal_commit_transaction+0x218/0x15e0?
 
> INFO: task flush-8:0:354 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> flush-8:0     D 00000000005691a0  5560   354      2 0x28000000000
> Call Trace:
>  [0000000000568de4] start_this_handle+0x36c/0x520
>  [00000000005691a0] jbd2_journal_start+0xb4/0xe0
>  [000000000054f99c] ext4_journal_start_sb+0x54/0x9c
>  [0000000000540de0] ext4_da_writepages+0x1e0/0x460
>  [00000000004ab3e4] do_writepages+0x28/0x4c
>  [00000000004f825c] writeback_single_inode+0xf0/0x330
>  [00000000004f90a8] writeback_inodes_wb+0x4e4/0x600
>  [00000000004f9354] wb_writeback+0x190/0x20c
>  [00000000004f967c] wb_do_writeback+0x1d4/0x1f0
>  [00000000004f96c0] bdi_writeback_task+0x28/0xa0
>  [00000000004b71dc] bdi_start_fn+0x64/0xc8
>  [00000000004786f0] kthread+0x58/0x6c
>  [000000000042ae7c] kernel_thread+0x30/0x48
>  [0000000000478644] kthreadd+0xb8/0x10c
> 1 lock held by flush-8:0/354:
>  #0:  (&type->s_umount_key#18){......}, at: [<00000000004f8fc8>]
>  # writeback_inodes_wb+0x404/0x600
> INFO: task jbd2/sda6-8:588 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> jbd2/sda6-8   D 000000000056eea0  7272   588      2 0x18000000000
> Call Trace:
>  [000000000056976c] jbd2_journal_commit_transaction+0x218/0x15e0
>  [000000000056eea0] kjournald2+0x138/0x2fc
>  [00000000004786f0] kthread+0x58/0x6c
>  [000000000042ae7c] kernel_thread+0x30/0x48
>  [0000000000478644] kthreadd+0xb8/0x10c
> no locks held by jbd2/sda6-8/588.
> INFO: task rpmbuild:6580 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> rpmbuild      D 00000000005691a0    16  6580   6562 0x310061101000080
> Call Trace:
>  [0000000000568de4] start_this_handle+0x36c/0x520
>  [00000000005691a0] jbd2_journal_start+0xb4/0xe0
>  [000000000054f99c] ext4_journal_start_sb+0x54/0x9c
>  [000000000053dcd4] ext4_dirty_inode+0x8/0x3c
>  [00000000004f8888] __mark_inode_dirty+0x20/0x15c
>  [00000000004eeb34] file_update_time+0x104/0x124
>  [00000000004a50d4] __generic_file_aio_write+0x264/0x36c
>  [00000000004a5228] generic_file_aio_write+0x4c/0xa4
>  [00000000005390c0] ext4_file_write+0x94/0xa4
>  [00000000004dc12c] do_sync_write+0x84/0xd4
>  [00000000004dca78] vfs_write+0x70/0x12c
>  [00000000004dcbcc] SyS_write+0x2c/0x5c
>  [0000000000406214] linux_sparc_syscall32+0x34/0x40
> 1 lock held by rpmbuild/6580:
>  #0:  (&sb->s_type->i_mutex_key#9){......}, at: [<00000000004a5214>]
>  # generic_file_aio_write+0x38/0xa4
> etc.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
