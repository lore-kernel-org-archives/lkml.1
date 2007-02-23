Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbXBWGkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbXBWGkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 01:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXBWGkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 01:40:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbXBWGkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 01:40:35 -0500
Date: Fri, 23 Feb 2007 07:35:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: circular locking: /proc/sys/vm/drop_caches
Message-ID: <20070223063538.GA13679@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4996]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

i just got the lockdep warning below when doing:

  echo 3 > /proc/sys/vm/drop_caches

is this a known quirk in the drop_caches code?

	Ingo

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.20-syslet #434
-------------------------------------------------------
bash/12166 is trying to acquire lock:
 (&journal->j_list_lock){--..}, at: [<c01c82f5>] journal_try_to_free_buffers+0xd5/0x18f

but task is already holding lock:
 (inode_lock){--..}, at: [<c01947a3>] drop_pagecache+0x45/0xc8

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (inode_lock){--..}:
       [<c0144940>] __lock_acquire+0x984/0xa94
       [<c0144d6f>] lock_acquire+0x67/0x8c
       [<c0424a9f>] _spin_lock+0x35/0x42
       [<c0193ccb>] __mark_inode_dirty+0xe3/0x15e
       [<c016253b>] __set_page_dirty_nobuffers+0xb4/0xbf
       [<c0197361>] mark_buffer_dirty+0x1e/0x20
       [<c01c7af2>] __journal_temp_unlink_buffer+0x176/0x17d
       [<c01c7d23>] __journal_unfile_buffer+0xb/0x15
       [<c01c7d97>] __journal_refile_buffer+0x6a/0xe3
       [<c01cac34>] journal_commit_transaction+0xf46/0x11da
       [<c01cd32c>] kjournald+0xab/0x1e8
       [<c013b935>] kthread+0xb2/0xd7
       [<c0104e5f>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (&journal->j_list_lock){--..}:
       [<c014483b>] __lock_acquire+0x87f/0xa94
       [<c0144d6f>] lock_acquire+0x67/0x8c
       [<c0424a9f>] _spin_lock+0x35/0x42
       [<c01c82f5>] journal_try_to_free_buffers+0xd5/0x18f
       [<c01b944e>] ext3_releasepage+0x68/0x74
       [<c015d027>] try_to_release_page+0x33/0x44
       [<c016406e>] invalidate_mapping_pages+0x69/0xca
       [<c01640dc>] invalidate_inode_pages+0xd/0x11
       [<c01947bf>] drop_pagecache+0x61/0xc8
       [<c019485c>] drop_caches_sysctl_handler+0x36/0x4e
       [<c012efdc>] do_rw_proc+0xaf/0xf1
       [<c012f078>] proc_writesys+0x20/0x25
       [<c017b3de>] vfs_write+0xb1/0x165
       [<c017bbc6>] sys_write+0x3d/0x61
       [<c01041a8>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by bash/12166:
 #0:  (&type->s_umount_key#17){----}, at: [<c0194793>] drop_pagecache+0x35/0xc8
 #1:  (inode_lock){--..}, at: [<c01947a3>] drop_pagecache+0x45/0xc8

stack backtrace:
 [<c010510d>] show_trace_log_lvl+0x19/0x2e
 [<c0105206>] show_trace+0x12/0x14
 [<c010521c>] dump_stack+0x14/0x16
 [<c01433ff>] print_circular_bug_tail+0x5f/0x68
 [<c014483b>] __lock_acquire+0x87f/0xa94
 [<c0144d6f>] lock_acquire+0x67/0x8c
 [<c0424a9f>] _spin_lock+0x35/0x42
 [<c01c82f5>] journal_try_to_free_buffers+0xd5/0x18f
 [<c01b944e>] ext3_releasepage+0x68/0x74
 [<c015d027>] try_to_release_page+0x33/0x44
 [<c016406e>] invalidate_mapping_pages+0x69/0xca
 [<c01640dc>] invalidate_inode_pages+0xd/0x11
 [<c01947bf>] drop_pagecache+0x61/0xc8
 [<c019485c>] drop_caches_sysctl_handler+0x36/0x4e
 [<c012efdc>] do_rw_proc+0xaf/0xf1
 [<c012f078>] proc_writesys+0x20/0x25
 [<c017b3de>] vfs_write+0xb1/0x165
 [<c017bbc6>] sys_write+0x3d/0x61
 [<c01041a8>] syscall_call+0x7/0xb
 =======================
