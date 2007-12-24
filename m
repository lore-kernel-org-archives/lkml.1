Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbXLXMFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbXLXMFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 07:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXLXMFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 07:05:11 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:33331 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXLXMFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 07:05:09 -0500
Date: Mon, 24 Dec 2007 16:58:42 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@in.ibm.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Circular locking dependency
Message-ID: <20071224112842.GA8347@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just hit this on sched-devel. (not sure how to reproduce it yet, can't
try now. I believe i can hit it on mainline as well as there is nothing
scheduler specific).

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc6 #1
-------------------------------------------------------
bash/17982 is trying to acquire lock:
 (&journal->j_list_lock){--..}, at: [<c01f91a8>]
__journal_try_to_free_buffer+0x2a/0x8a

but task is already holding lock:
 (inode_lock){--..}, at: [<c019d402>] drop_pagecache_sb+0x12/0x74

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (inode_lock){--..}:
       [<c0142ead>] check_prev_add+0xb8/0x1ad
       [<c0142fff>] check_prevs_add+0x5d/0xcf
       [<c01432f7>] validate_chain+0x286/0x300
       [<c0144ec6>] __lock_acquire+0x67f/0x6ff
       [<c01454ee>] lock_acquire+0x71/0x8b
       [<c0428cf2>] _spin_lock+0x2b/0x38
       [<c019c4a0>] __mark_inode_dirty+0xd0/0x15b
       [<c01a0243>] __set_page_dirty+0x10c/0x11b
       [<c01a0a2f>] mark_buffer_dirty+0x9a/0xa1
       [<c01f910f>] __journal_temp_unlink_buffer+0xbf/0xc3
       [<c01f911e>] __journal_unfile_buffer+0xb/0x15
       [<c01f9758>] __journal_refile_buffer+0x3c/0x86
       [<c01fa4bf>] journal_commit_transaction+0x89c/0xa05
       [<c01fbe3d>] kjournald+0xab/0x1ff
       [<c013a36a>] kthread+0x37/0x59
       [<c0105b47>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (&journal->j_list_lock){--..}:
       [<c0142e23>] check_prev_add+0x2e/0x1ad
       [<c0142fff>] check_prevs_add+0x5d/0xcf
       [<c01432f7>] validate_chain+0x286/0x300
       [<c0144ec6>] __lock_acquire+0x67f/0x6ff
       [<c01454ee>] lock_acquire+0x71/0x8b
       [<c0428cf2>] _spin_lock+0x2b/0x38
       [<c01f91a8>] __journal_try_to_free_buffer+0x2a/0x8a
       [<c01f9269>] journal_try_to_free_buffers+0x61/0x9e
       [<c01ebd01>] ext3_releasepage+0x68/0x74
       [<c015f528>] try_to_release_page+0x33/0x47
       [<c0165570>] invalidate_complete_page+0x1e/0x35
       [<c01658c8>] __invalidate_mapping_pages+0x6b/0xc2
       [<c019d43c>] drop_pagecache_sb+0x4c/0x74
       [<c019d4ae>] drop_pagecache+0x4a/0x78
       [<c019d530>] drop_caches_sysctl_handler+0x36/0x4e
       [<c01b5d57>] proc_sys_write+0x6b/0x85
       [<c0183c05>] vfs_write+0x8c/0x10b
       [<c0183d22>] sys_write+0x3d/0x61
       [<c0104e36>] sysenter_past_esp+0x5f/0xa5
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by bash/17982:
 #0:  (&type->s_umount_key#15){----}, at: [<c019d4a1>]
drop_pagecache+0x3d/0x78
 #1:  (inode_lock){--..}, at: [<c019d402>] drop_pagecache_sb+0x12/0x74

stack backtrace:
Pid: 17982, comm: bash Not tainted 2.6.24-rc6 #1
 [<c0105c83>] show_trace_log_lvl+0x19/0x2e
 [<c0105caa>] show_trace+0x12/0x14
 [<c0105de6>] dump_stack+0x6c/0x72
 [<c0142700>] print_circular_bug_tail+0x5f/0x68
 [<c0142e23>] check_prev_add+0x2e/0x1ad
 [<c0142fff>] check_prevs_add+0x5d/0xcf
 [<c01432f7>] validate_chain+0x286/0x300
 [<c0144ec6>] __lock_acquire+0x67f/0x6ff
 [<c01454ee>] lock_acquire+0x71/0x8b
 [<c0428cf2>] _spin_lock+0x2b/0x38
 [<c01f91a8>] __journal_try_to_free_buffer+0x2a/0x8a
 [<c01f9269>] journal_try_to_free_buffers+0x61/0x9e
 [<c01ebd01>] ext3_releasepage+0x68/0x74
 [<c015f528>] try_to_release_page+0x33/0x47
 [<c0165570>] invalidate_complete_page+0x1e/0x35
 [<c01658c8>] __invalidate_mapping_pages+0x6b/0xc2
 [<c019d43c>] drop_pagecache_sb+0x4c/0x74
 [<c019d4ae>] drop_pagecache+0x4a/0x78
 [<c019d530>] drop_caches_sysctl_handler+0x36/0x4e
 [<c01b5d57>] proc_sys_write+0x6b/0x85
 [<c0183c05>] vfs_write+0x8c/0x10b
 [<c0183d22>] sys_write+0x3d/0x61
 [<c0104e36>] sysenter_past_esp+0x5f/0xa5
 =======================
[root@llm11 kernel]# 

Last thing I did was echo 1 > /proc/sys/vm/drop_cache

(Not sure whom to cc, hopefully others will know better, also no time to
debug further, sorry!)

-- 
regards,
Dhaval
