Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYIIVD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYIIVD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 17:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYIIVDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 17:03:49 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:60779 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYIIVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 17:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GCGQgYkDacbfCaqYxiXczyN9ozIcgZbhObSN7mHnmo2e4hzrvNVKLt9xGULKsHh3Rg
         SO4C64dnOob/Yu9ZTbAwufBUMZ72L9F3WZoqNPp+je4KhOggYUP+EqbVqCCamnh28Zzz
         QbC+lL5/6SXg9W13FgYK+INJ+HKMlup7SWY8c=
Message-ID: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com>
Date: Tue, 9 Sep 2008 22:03:45 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I observed this locking violation [1] while gnome-panel was loading;
this was previously reported at
http://uwsg.iu.edu/hypermail/linux/kernel/0806.3/2881.html .

Let me know for more information/config/testing. Thanks!
  Daniel

--- [1]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc5-233c-debug #2
-------------------------------------------------------
gnome-panel/4944 is trying to acquire lock:
 (&mm->mmap_sem){----}, at: [<ffffffff806aa40f>] do_page_fault+0x12f/0xae0

but task is already holding lock:
 (&dev->ev_mutex){--..}, at: [<ffffffff80320ac3>] inotify_read+0xe3/0x200

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&dev->ev_mutex){--..}:
       [<ffffffff80271889>] __lock_acquire+0xd49/0x1190
       [<ffffffff80271d61>] lock_acquire+0x91/0xc0
       [<ffffffff806a5069>] __mutex_lock_common+0xb9/0x430
       [<ffffffff806a54bf>] mutex_lock_nested+0x3f/0x50
       [<ffffffff80321216>] inotify_dev_queue_event+0x46/0x1c0
       [<ffffffff803200e6>] inotify_inode_queue_event+0xc6/0x110
       [<ffffffff802f424c>] fsnotify_create+0x3c/0x70
       [<ffffffff802f4c5d>] vfs_create+0xbd/0xd0
       [<ffffffff802f7dfe>] do_filp_open+0x80e/0x910
       [<ffffffff802e82b0>] do_sys_open+0x80/0x110
       [<ffffffff802e8380>] sys_open+0x20/0x30
       [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&ih->mutex){--..}:
       [<ffffffff80271889>] __lock_acquire+0xd49/0x1190
       [<ffffffff80271d61>] lock_acquire+0x91/0xc0
       [<ffffffff806a5069>] __mutex_lock_common+0xb9/0x430
       [<ffffffff806a54bf>] mutex_lock_nested+0x3f/0x50
       [<ffffffff8031fe73>] inotify_find_update_watch+0x53/0xe0
       [<ffffffff80320d85>] sys_inotify_add_watch+0x115/0x1d0
       [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&inode->inotify_mutex){--..}:
       [<ffffffff80271889>] __lock_acquire+0xd49/0x1190
       [<ffffffff80271d61>] lock_acquire+0x91/0xc0
       [<ffffffff806a5069>] __mutex_lock_common+0xb9/0x430
       [<ffffffff806a54bf>] mutex_lock_nested+0x3f/0x50
       [<ffffffff80320070>] inotify_inode_queue_event+0x50/0x110
       [<ffffffff803206e1>] inotify_dentry_parent_queue_event+0x91/0xb0
       [<ffffffff802ebb7f>] __fput+0x7f/0x1f0
       [<ffffffff802ebd15>] fput+0x25/0x30
       [<ffffffff802c84ff>] remove_vma+0x4f/0x90
       [<ffffffff802ca359>] do_munmap+0x2e9/0x330
       [<ffffffff802ca3f5>] sys_munmap+0x55/0x80
       [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&mm->mmap_sem){----}:
       [<ffffffff80271950>] __lock_acquire+0xe10/0x1190
       [<ffffffff80271d61>] lock_acquire+0x91/0xc0
       [<ffffffff806a56eb>] down_read+0x4b/0x80
       [<ffffffff806aa40f>] do_page_fault+0x12f/0xae0
       [<ffffffff806a7bdd>] error_exit+0x0/0xa9
       [<ffffffff802eac08>] vfs_read+0xc8/0x170
       [<ffffffff802eadb5>] sys_read+0x55/0x90
       [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by gnome-panel/4944:
 #0:  (&dev->ev_mutex){--..}, at: [<ffffffff80320ac3>] inotify_read+0xe3/0x200

stack backtrace:
Pid: 4944, comm: gnome-panel Not tainted 2.6.27-rc5-233c-debug #2

Call Trace:
 [<ffffffff8026f807>] print_circular_bug_tail+0xa7/0xf0
 [<ffffffff80271950>] __lock_acquire+0xe10/0x1190
 [<ffffffff80271d61>] lock_acquire+0x91/0xc0
 [<ffffffff806aa40f>] ? do_page_fault+0x12f/0xae0
 [<ffffffff806a56eb>] down_read+0x4b/0x80
 [<ffffffff806aa40f>] ? do_page_fault+0x12f/0xae0
 [<ffffffff8025c51a>] ? search_exception_tables+0x2a/0x50
 [<ffffffff806aa40f>] do_page_fault+0x12f/0xae0
 [<ffffffff8026d951>] ? trace_hardirqs_off_caller+0x21/0xc0
 [<ffffffff80213fc0>] ? native_sched_clock+0x90/0xb0
 [<ffffffff80270e39>] ? __lock_acquire+0x2f9/0x1190
 [<ffffffff80270606>] ? mark_held_locks+0x56/0xa0
 [<ffffffff802708bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80270849>] ? trace_hardirqs_on_caller+0x149/0x1b0
 [<ffffffff806a7bdd>] error_exit+0x0/0xa9
 [<ffffffff80459acd>] ? copy_user_generic_string+0x2d/0x40
 [<ffffffff80320b5d>] ? inotify_read+0x17d/0x200
 [<ffffffff8025ee00>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802708bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff802eac08>] vfs_read+0xc8/0x170
 [<ffffffff802eadb5>] sys_read+0x55/0x90
 [<ffffffff8020c86b>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
