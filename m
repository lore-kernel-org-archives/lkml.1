Return-Path: <linux-kernel-owner+w=401wt.eu-S1161139AbXDVXob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbXDVXob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161143AbXDVXo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:44:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:53543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161139AbXDVXo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:44:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: jeffm@suse.com
Subject: reiserfs lockdep warning in 2.6.21-rc5
Date: Mon, 23 Apr 2007 01:44:22 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       reiserfs-dev@namesys.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704230144.22355.ak@suse.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21-rc5-git6 #44
-------------------------------------------------------
perl/7968 is trying to acquire lock:
 (&inode->i_mutex){--..}, at: [<ffffffff802ca7cd>] reiserfs_file_release+0x109/0x2cc

but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<ffffffff8026b36a>] sys_munmap+0x32/0x5a

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){----}:
       [<ffffffff8024ac22>] __lock_acquire+0x9e0/0xb79
       [<ffffffff8024b16b>] lock_acquire+0x48/0x63
       [<ffffffff80559743>] do_page_fault+0x3a4/0x7b2
       [<ffffffff8024652b>] down_read_trylock+0xe/0x3b
       [<ffffffff80246473>] down_read+0x21/0x2a
       [<ffffffff80559743>] do_page_fault+0x3a4/0x7b2
       [<ffffffff80249dc9>] trace_hardirqs_on+0x11c/0x140
       [<ffffffff805575a7>] _read_unlock_irq+0x2f/0x4a
       [<ffffffff8025ac71>] find_lock_page+0x91/0x9d
       [<ffffffff8025b5b7>] find_or_create_page+0x1e/0x75
       [<ffffffff805579ed>] error_exit+0x0/0x96
       [<ffffffff802bf3ca>] reiserfs_release_claimed_blocks+0x22/0x49
       [<ffffffff802c8341>] reiserfs_copy_from_user_to_file_region+0x7e/0xf3
       [<ffffffff802ca482>] reiserfs_file_write+0x15a1/0x1795
       [<ffffffff805574a4>] _spin_unlock_irqrestore+0x49/0x69
       [<ffffffff80556a9f>] trace_hardirqs_on_thunk+0x35/0x37
       [<ffffffff805574e8>] _spin_unlock_irq+0x24/0x4a
       [<ffffffff80249dc9>] trace_hardirqs_on+0x11c/0x140
       [<ffffffff805574f3>] _spin_unlock_irq+0x2f/0x4a
       [<ffffffff805546d9>] thread_return+0xee/0x135
       [<ffffffff8055759c>] _read_unlock_irq+0x24/0x4a
       [<ffffffff80249dc9>] trace_hardirqs_on+0x11c/0x140
       [<ffffffff805575a7>] _read_unlock_irq+0x2f/0x4a
       [<ffffffff8025aaad>] find_get_pages_tag+0x75/0x80
       [<ffffffff8028148e>] vfs_write+0xad/0x136
       [<ffffffff80281ab4>] sys_pwrite64+0x50/0x70
       [<ffffffff80220b42>] ia32_sysret+0x0/0xa
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&inode->i_mutex){--..}:
       [<ffffffff8024952d>] print_circular_bug_header+0xcc/0xd3
       [<ffffffff8024ab1e>] __lock_acquire+0x8dc/0xb79
       [<ffffffff8024b16b>] lock_acquire+0x48/0x63
       [<ffffffff802ca7cd>] reiserfs_file_release+0x109/0x2cc
       [<ffffffff80247d59>] debug_mutex_lock_common+0x16/0x23
       [<ffffffff805558aa>] __mutex_lock_slowpath+0xe1/0x293
       [<ffffffff802ca7cd>] reiserfs_file_release+0x109/0x2cc
       [<ffffffff80281d35>] __fput+0xa1/0x15e
       [<ffffffff8026a645>] remove_vma+0x35/0x5c
       [<ffffffff8026b316>] do_munmap+0x258/0x27a
       [<ffffffff80556873>] __down_write_nested+0x34/0x9e
       [<ffffffff8026b378>] sys_munmap+0x40/0x5a
       [<ffffffff8020945e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by perl/7968:
 #0:  (&mm->mmap_sem){----}, at: [<ffffffff8026b36a>] sys_munmap+0x32/0x5a

stack backtrace:
Call Trace:
 [<ffffffff802492ad>] print_circular_bug_tail+0x69/0x72
 [<ffffffff8024952d>] print_circular_bug_header+0xcc/0xd3
 [<ffffffff8024ab1e>] __lock_acquire+0x8dc/0xb79
 [<ffffffff8024b16b>] lock_acquire+0x48/0x63
 [<ffffffff802ca7cd>] reiserfs_file_release+0x109/0x2cc
 [<ffffffff80247d59>] debug_mutex_lock_common+0x16/0x23
 [<ffffffff805558aa>] __mutex_lock_slowpath+0xe1/0x293
 [<ffffffff802ca7cd>] reiserfs_file_release+0x109/0x2cc
 [<ffffffff80281d35>] __fput+0xa1/0x15e
 [<ffffffff8026a645>] remove_vma+0x35/0x5c
 [<ffffffff8026b316>] do_munmap+0x258/0x27a
 [<ffffffff80556873>] __down_write_nested+0x34/0x9e
 [<ffffffff8026b378>] sys_munmap+0x40/0x5a
 [<ffffffff8020945e>] system_call+0x7e/0x83
