Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYCRL3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYCRL3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYCRL2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:28:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60046 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751853AbYCRL2w (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:28:52 -0400
Date: Tue, 18 Mar 2008 22:28:44 +1100
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: BUG: drop_pagecache_sb vs kjournald lockup
Message-ID: <20080318112843.GJ95344431@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-rc3, 4p ia64, ext3 root drive.

I was running an XFS stress test on one of the XFS partitions on
the machine (zero load on the root ext3 drive), when the system
locked up in kjournald with this on the console:

BUG: spinlock lockup on CPU#2, kjournald/2150, a000000100e022e0

Call Trace:
 [<a0000001000125e0>] show_stack+0x40/0xa0
                                sp=e00000384195fbf0 bsp=e000003841951010
 [<a000000100012670>] dump_stack+0x30/0x60
                                sp=e00000384195fdc0 bsp=e000003841950ff0
 [<a0000001004a5500>] _raw_spin_lock+0x200/0x260
                                sp=e00000384195fdc0 bsp=e000003841950fb8
 [<a000000100837360>] _spin_lock+0x20/0x40
                                sp=e00000384195fdc0 bsp=e000003841950f98
 [<a0000001001ab370>] __mark_inode_dirty+0x270/0x440
                                sp=e00000384195fdc0 bsp=e000003841950f58
 [<a0000001001b5930>] __set_page_dirty+0x330/0x360
                                sp=e00000384195fdc0 bsp=e000003841950f28
 [<a0000001001b5aa0>] mark_buffer_dirty+0x140/0x160
                                sp=e00000384195fdc0 bsp=e000003841950f00
 [<a0000001002a9100>] __journal_temp_unlink_buffer+0x3a0/0x3c0
                                sp=e00000384195fdc0 bsp=e000003841950ee0
 [<a0000001002a9690>] __journal_unfile_buffer+0x30/0x60
                                sp=e00000384195fdc0 bsp=e000003841950ec0
 [<a0000001002a97f0>] __journal_refile_buffer+0x130/0x2a0
                                sp=e00000384195fdc0 bsp=e000003841950e88
 [<a0000001002b0e70>] journal_commit_transaction+0x23b0/0x29c0
                                sp=e00000384195fdc0 bsp=e000003841950e18
 [<a0000001002b8f80>] kjournald+0x180/0x420
                                sp=e00000384195fe00 bsp=e000003841950db8
 [<a0000001000bf780>] kthread+0xa0/0x120
                                sp=e00000384195fe30 bsp=e000003841950d88
 [<a000000100010d10>] kernel_thread_helper+0x30/0x60
                                sp=e00000384195fe30 bsp=e000003841950d60
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e00000384195fe30 bsp=e000003841950d60


The system is stuck with all 4 CPUs spinning on locks:

[0]kdb> bta R
Stack traceback for pid 2592
0xe000003802950000     2592        1  1    0   R  0xe0000038029503a0 *syslogd
0xa0000001004a5470 _raw_spin_lock+0x170
0xa000000100837360 _spin_lock+0x20
0xa0000001002aaa20 do_get_write_access+0x960
0xa0000001002aad80 journal_get_write_access+0x40
0xa0000001002a2e50 __ext3_journal_get_write_access+0x30
0xa000000100285f60 ext3_reserve_inode_write+0x80
0xa000000100286050 ext3_mark_inode_dirty+0x50
0xa00000010028c990 ext3_dirty_inode+0xd0
0xa0000001001ab190 __mark_inode_dirty+0x90
0xa0000001001948c0 file_update_time+0x220
0xa000000100101000 __generic_file_aio_write_nolock+0x4e0
0xa000000100101340 generic_file_aio_write+0xe0
0xa000000100281a00 ext3_file_write+0x60
0xa000000100164030 do_sync_readv_writev+0x150
0xa000000100164fd0 do_readv_writev+0x130
0xa000000100165270 vfs_writev+0xd0
0xa000000100165310 sys_writev+0x70
0xa000000100009ca0 ia64_ret_from_syscall
0xa000000000010720 __kernel_syscall_via_break
Enter <q> to end, <cr> to continue:ÿ
Stack traceback for pid 4700
0xe00000b84aa10000     4700     2884  1    1   R  0xe00000b84aa103a0  sh
0xa0000001004a5460 _raw_spin_lock+0x160
0xa000000100837360 _spin_lock+0x20
0xa0000001002ae460 journal_try_to_free_buffers+0x200
0xa00000010028a730 ext3_releasepage+0xb0
0xa000000100101a90 try_to_release_page+0xf0
0xa0000001001139f0 __invalidate_mapping_pages+0x170
0xa0000001001ac3f0 drop_pagecache+0x110
0xa0000001001ac5d0 drop_caches_sysctl_handler+0x70
0xa0000001002089b0 proc_sys_write+0x110
0xa000000100165670 vfs_write+0x1b0
0xa000000100166110 sys_write+0x70
0xa000000100009ca0 ia64_ret_from_syscall
0xa000000000010720 __kernel_syscall_via_break
Enter <q> to end, <cr> to continue:ÿ
Stack traceback for pid 2150
0xe000003841950000     2150        2  1    2   R  0xe0000038419503a0  kjournald
0xa0000001004a5470 _raw_spin_lock+0x170
0xa000000100837360 _spin_lock+0x20
0xa0000001001ab370 __mark_inode_dirty+0x270
0xa0000001001b5930 __set_page_dirty+0x330
0xa0000001001b5aa0 mark_buffer_dirty+0x140
0xa0000001002a9100 __journal_temp_unlink_buffer+0x3a0
0xa0000001002a9690 __journal_unfile_buffer+0x30
0xa0000001002a97f0 __journal_refile_buffer+0x130
0xa0000001002b0e70 journal_commit_transaction+0x23b0
0xa0000001002b8f80 kjournald+0x180
0xa0000001000bf780 kthread+0xa0
0xa000000100010d10 kernel_thread_helper+0x30
0xa0000001000089c0 start_kernel_thread+0x20
Enter <q> to end, <cr> to continue:ÿ
Stack traceback for pid 2739
0xe00000b8222e0000     2739        1  1    3   R  0xe00000b8222e03a0  cron
0xa0000001004a5470 _raw_spin_lock+0x170
0xa000000100837360 _spin_lock+0x20
0xa0000001001931a0 ifind_fast+0x20
0xa0000001001936f0 iget_locked+0x70
0xa00000010028ca10 ext3_iget+0x30
0xa000000100293e30 ext3_lookup+0x130
0xa000000100176270 do_lookup+0x1b0
0xa00000010017afe0 __link_path_walk+0x1580
0xa00000010017bc20 link_path_walk+0xc0
0xa00000010017bdb0 path_walk+0x30
0xa00000010017c4d0 do_path_lookup+0x330
0xa00000010017d8c0 __user_walk_fd+0x60
0xa00000010016c410 vfs_stat_fd+0x30
0xa00000010016c950 sys_newstat+0x30
0xa000000100009ca0 ia64_ret_from_syscall
0xa000000000010720 __kernel_syscall_via_break
Enter <q> to end, <cr> to continue:ÿ

Looks like everything is backed up on the inode_lock.  Why? Looks
like drop_pagecache_sb() is doing something ..... suboptimal.

static void drop_pagecache_sb(struct super_block *sb)
{
        struct inode *inode;

        spin_lock(&inode_lock);
        list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
                if (inode->i_state & (I_FREEING|I_WILL_FREE))
                        continue;
                __invalidate_mapping_pages(inode->i_mapping, 0, -1, true);
        }
        spin_unlock(&inode_lock);
}

It holds the inode_lock for an amazingly long time, and calls a
function that ends up in ->release_page which can issue
transactions.

Given that transactions can then mark an inode dirty or the
kjournald might need to mark an inode dirty while holding
transaction locks, the implementation of drop_pagecache_sb seems to
be just a little dangerous....

Anyone know the reason why drop_pagecache_sb() uses such a brute-force
mechanism to free up clean page cache pages?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
