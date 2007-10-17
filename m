Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbXJQJF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbXJQJF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJQJFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:05:15 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:32816 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXJQJFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:05:13 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: possible circular lock dependency in reiserfs
Date: Wed, 17 Oct 2007 11:05:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171105.13889.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following report in syslog:

Oct 17 10:56:35 oenone kernel: =============================================
Oct 17 10:56:35 oenone kernel: [ INFO: possible recursive locking detected ]
Oct 17 10:56:35 oenone kernel: 2.6.23-default #1
Oct 17 10:56:35 oenone kernel: ---------------------------------------------
Oct 17 10:56:35 oenone kernel: beagled/4092 is trying to acquire lock:
Oct 17 10:56:35 oenone kernel:  (&inode->i_mutex){--..}, at: [<ffffffff88090081>] reiserfs_xattr_set+0xf3/0x30e [reiserfs]
Oct 17 10:56:35 oenone kernel:
Oct 17 10:56:35 oenone kernel: but task is already holding lock:
Oct 17 10:56:35 oenone kernel:  (&inode->i_mutex){--..}, at: [<ffffffff802adef5>] vfs_setxattr+0x4d/0x1e0
Oct 17 10:56:35 oenone kernel:
Oct 17 10:56:35 oenone kernel: other info that might help us debug this:
Oct 17 10:56:35 oenone kernel: 3 locks held by beagled/4092:
Oct 17 10:56:35 oenone kernel:  #0:  (&inode->i_mutex){--..}, at: [<ffffffff802adef5>] vfs_setxattr+0x4d/0x1e0
Oct 17 10:56:35 oenone kernel:  #1:  (&REISERFS_I(inode)->xattr_sem){----}, at: [<ffffffff8808fb56>] reiserfs_setxattr+0x6b/0x11f [reiserfs]
Oct 17 10:56:35 oenone kernel:  #2:  (&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<ffffffff8808fb89>] reiserfs_setxattr+0x9e/0x11f [reiserfs]
Oct 17 10:56:35 oenone kernel:
Oct 17 10:56:35 oenone kernel: stack backtrace:
Oct 17 10:56:35 oenone kernel:
Oct 17 10:56:35 oenone kernel: Call Trace:
Oct 17 10:56:35 oenone kernel:  [<ffffffff80250528>] __lock_acquire+0x1b7/0xcaf
Oct 17 10:56:35 oenone kernel:  [<ffffffff8025140d>] lock_acquire+0x51/0x6c
Oct 17 10:56:35 oenone kernel:  [<ffffffff88090081>] :reiserfs:reiserfs_xattr_set+0xf3/0x30e
Oct 17 10:56:35 oenone kernel:  [<ffffffff8024ddd1>] debug_mutex_lock_common+0x16/0x23
Oct 17 10:56:35 oenone kernel:  [<ffffffff8044b824>] __mutex_lock_slowpath+0xe1/0x277
Oct 17 10:56:35 oenone kernel:  [<ffffffff88090081>] :reiserfs:reiserfs_xattr_set+0xf3/0x30e
Oct 17 10:56:35 oenone kernel:  [<ffffffff8024feec>] trace_hardirqs_on+0x115/0x139
Oct 17 10:56:35 oenone kernel:  [<ffffffff8044d1f4>] _spin_unlock_irq+0x24/0x27
Oct 17 10:56:35 oenone kernel:  [<ffffffff8044c85a>] __down_write_nested+0x34/0x9e
Oct 17 10:56:35 oenone kernel:  [<ffffffff8808fbb2>] :reiserfs:reiserfs_setxattr+0xc7/0x11f
Oct 17 10:56:35 oenone kernel:  [<ffffffff802adf56>] vfs_setxattr+0xae/0x1e0
Oct 17 10:56:35 oenone kernel:  [<ffffffff802ae148>] setxattr+0xc0/0xdd
Oct 17 10:56:35 oenone kernel:  [<ffffffff8028f376>] kmem_cache_free+0x1c4/0x1d6
Oct 17 10:56:35 oenone kernel:  [<ffffffff8024feec>] trace_hardirqs_on+0x115/0x139
Oct 17 10:56:35 oenone kernel:  [<ffffffff8029dae5>] do_path_lookup+0x1ae/0x22c
Oct 17 10:56:35 oenone kernel:  [<ffffffff8029e340>] __user_walk_fd+0x41/0x4c
Oct 17 10:56:35 oenone kernel:  [<ffffffff802ae1ae>] sys_lsetxattr+0x49/0x6a
Oct 17 10:56:35 oenone kernel:  [<ffffffff8020bdfa>] tracesys+0x71/0xe1
Oct 17 10:56:35 oenone kernel:  [<ffffffff8020be65>] tracesys+0xdc/0xe1
Oct 17 10:56:35 oenone kernel:
