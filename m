Return-Path: <linux-kernel-owner+w=401wt.eu-S1762025AbXK2Kjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025AbXK2Kjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXK2Kjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:39:32 -0500
Received: from styx.suse.cz ([82.119.242.94]:46449 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbXK2Kjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:39:31 -0500
Date: Thu, 29 Nov 2007 11:39:28 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: Lockdep warning with direct IO and mmap
Message-ID: <20071129103928.GC16558@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  when stress testing ext3, I've got the following lockdep warning:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc3-gbea03ae9 #21
-------------------------------------------------------
fsstress/23377 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<c017865e>] dio_get_page+0x4e/0x165

but task is already holding lock:
 (jbd_handle){--..}, at: [<c01c13f6>] journal_start+0xcb/0xf8

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (jbd_handle){--..}:
       [<c0130eff>] __lock_acquire+0xa12/0xbd9
       [<c01314a9>] lock_acquire+0x5f/0x78
       [<c01c1419>] journal_start+0xee/0xf8
       [<c01bc22a>] ext3_journal_start_sb+0x48/0x4a
       [<c01b79e5>] ext3_dirty_inode+0x27/0x6c
       [<c0170449>] __mark_inode_dirty+0x26/0x15d
       [<c0168cde>] touch_atime+0xa6/0xac
       [<c013b5d1>] generic_file_mmap+0x2d/0x42
       [<c014ae94>] mmap_region+0x1e6/0x3b4
       [<c014b333>] do_mmap_pgoff+0x1fb/0x253
       [<c0106721>] sys_mmap2+0x65/0x83
       [<c0102746>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){----}:
       [<c0130df3>] __lock_acquire+0x906/0xbd9
       [<c01314a9>] lock_acquire+0x5f/0x78
       [<c0128acf>] down_read+0x3a/0x4c
       [<c017865e>] dio_get_page+0x4e/0x165
       [<c0179105>] __blockdev_direct_IO+0x428/0xad4
       [<c01b7773>] ext3_direct_IO+0x102/0x17b
       [<c013c6ba>] generic_file_direct_IO+0xe5/0x111
       [<c013c73c>] generic_file_direct_write+0x56/0x112
       [<c013d054>] __generic_file_aio_write_nolock+0x322/0x452
       [<c013d1ea>] generic_file_aio_write+0x66/0xc3
       [<c01b38f7>] ext3_file_write+0x27/0x96
       [<c0157674>] do_sync_write+0xc5/0x102
       [<c0157da0>] vfs_write+0x90/0x10d
       [<c0158307>] sys_write+0x3d/0x61
       [<c01026be>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by fsstress/23377:
 #0:  (&sb->s_type->i_mutex_key#4){--..}, at: [<c013d1d3>] generic_file_aio_write+0x4f/0xc3
 #1:  (jbd_handle){--..}, at: [<c01c13f6>] journal_start+0xcb/0xf8

stack backtrace:
 [<c0103707>] show_trace_log_lvl+0x1a/0x2f
 [<c010409a>] show_trace+0x12/0x14
 [<c010418c>] dump_stack+0x16/0x18
 [<c012f5e1>] print_circular_bug_tail+0x5f/0x68
 [<c0130df3>] __lock_acquire+0x906/0xbd9
 [<c01314a9>] lock_acquire+0x5f/0x78
 [<c0128acf>] down_read+0x3a/0x4c
 [<c017865e>] dio_get_page+0x4e/0x165
 [<c0179105>] __blockdev_direct_IO+0x428/0xad4
 [<c01b7773>] ext3_direct_IO+0x102/0x17b
 [<c013c6ba>] generic_file_direct_IO+0xe5/0x111
 [<c013c73c>] generic_file_direct_write+0x56/0x112
 [<c013d054>] __generic_file_aio_write_nolock+0x322/0x452
 [<c013d1ea>] generic_file_aio_write+0x66/0xc3
 [<c01b38f7>] ext3_file_write+0x27/0x96
 [<c0157674>] do_sync_write+0xc5/0x102
 [<c0157da0>] vfs_write+0x90/0x10d
 [<c0158307>] sys_write+0x3d/0x61
 [<c01026be>] sysenter_past_esp+0x5f/0xa5
 =======================

  The warning seems to be correct - when doing mmap we start a transaction
under mmap_sem, while in direct IO we need to get mmap_sem when the
transaction is started. I could not find what's the right locking order. It
seems to be easier to avoid touch_atime() under mmap_sem but maybe there
are other places where we need to start transaction with mmap_sem so I'm
asking here...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
