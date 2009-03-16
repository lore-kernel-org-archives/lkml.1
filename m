Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbZCPMek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbZCPMek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZCPMe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:34:29 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:37292 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZCPMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=iPFAZVJUnnX8sdRaMO0iEYv1UqbiNnlmPGK5paPmSsFEMuyM6ke5uc/XMDAdUi6fSY
         qfTqjfhxSmxYMCoTMFeGmULNmAIzcOzbPu46evdQ4Y7cAlsKfcM0uvne8USZk3QjTO7z
         tkyYNjpkz9wPdyA+IWIufoBOrAIEjkw8q89H4=
MIME-Version: 1.0
Date: Mon, 16 Mar 2009 15:34:24 +0300
Message-ID: <a4423d670903160534s3a6775d4w2c2892bfd166d61a@mail.gmail.com>
Subject: next-20090316: Inotify: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       john@johnmccutchan.com, rlove@rlove.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[ INFO: inconsistent lock state ]
2.6.29-rc8-next-20090316 #5
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/318 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802eb7f0>]
inotify_inode_is_dead+0x30/0xb0
{RECLAIM_FS-ON-W} state was registered at:
  [<ffffffff8026df29>] mark_held_locks+0x69/0x90
  [<ffffffff8026df91>] lockdep_trace_alloc+0x41/0xb0
  [<ffffffff802b6b56>] __kmalloc+0x46/0x150
  [<ffffffff802ec697>] kernel_event+0x97/0x130
  [<ffffffff802ec7d7>] inotify_dev_queue_event+0xa7/0x1b0
  [<ffffffff802eb6de>] inotify_inode_queue_event+0xbe/0x100
  [<ffffffff802c5a35>] vfs_mkdir+0xb5/0xd0
  [<ffffffff802c7d46>] sys_mkdirat+0x106/0x120
  [<ffffffff802c7d73>] sys_mkdir+0x13/0x20
  [<ffffffff8020b61b>] system_call_fastpath+0x16/0x1b
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 93167
hardirqs last  enabled at (93167): [<ffffffff8062e345>]
_spin_unlock_irqrestore+0x65/0x80
hardirqs last disabled at (93166): [<ffffffff80283de2>] call_rcu+0x32/0x90
softirqs last  enabled at (87738): [<ffffffff80249d49>] __do_softirq+0x139/0x150
softirqs last disabled at (87733): [<ffffffff8020c7bc>] call_softirq+0x1c/0x30

other info that might help us debug this:
2 locks held by kswapd0/318:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff80294452>] shrink_slab+0x32/0x1c0
 #1:  (&type->s_umount_key#19){++++..}, at: [<ffffffff802cd32f>]
shrink_dcache_memory+0x11f/0x1e0

stack backtrace:
Pid: 318, comm: kswapd0 Not tainted 2.6.29-rc8-next-20090316 #5
Call Trace:
 [<ffffffff8026ce6d>] print_usage_bug+0x17d/0x190
 [<ffffffff8026ddd2>] mark_lock+0x332/0x420
 [<ffffffff8026cfe0>] ? check_usage_forwards+0x0/0xc0
 [<ffffffff8026ef7d>] __lock_acquire+0x3fd/0x1290
 [<ffffffff8026fea1>] lock_acquire+0x91/0xc0
 [<ffffffff802eb7f0>] ? inotify_inode_is_dead+0x30/0xb0
 [<ffffffff8062bcd9>] __mutex_lock_common+0x59/0x4d0
 [<ffffffff802eb7f0>] ? inotify_inode_is_dead+0x30/0xb0
 [<ffffffff8026ee4a>] ? __lock_acquire+0x2ca/0x1290
 [<ffffffff802eb7f0>] ? inotify_inode_is_dead+0x30/0xb0
 [<ffffffff8026b05a>] ? get_lock_stats+0x2a/0x60
 [<ffffffff8062c22a>] mutex_lock_nested+0x3a/0x50
 [<ffffffff802eb7f0>] inotify_inode_is_dead+0x30/0xb0
 [<ffffffff802ccd3c>] dentry_iput+0xbc/0xe0
 [<ffffffff802cce4e>] d_kill+0x2e/0x60
 [<ffffffff802cd10a>] __shrink_dcache_sb+0x28a/0x390
 [<ffffffff802cd36a>] shrink_dcache_memory+0x15a/0x1e0
 [<ffffffff8029457c>] shrink_slab+0x15c/0x1c0
 [<ffffffff8029652a>] kswapd+0x56a/0x6b0
 [<ffffffff80238326>] ? finish_task_switch+0x46/0x110
 [<ffffffff80293960>] ? isolate_pages_global+0x0/0x270
 [<ffffffff8025b7a0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8026e2ad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8062e322>] ? _spin_unlock_irqrestore+0x42/0x80
 [<ffffffff80295fc0>] ? kswapd+0x0/0x6b0
 [<ffffffff80295fc0>] ? kswapd+0x0/0x6b0
 [<ffffffff8025b3c6>] kthread+0x56/0x90
 [<ffffffff8020c6ba>] child_rip+0xa/0x20
 [<ffffffff8020c080>] ? restore_args+0x0/0x30
 [<ffffffff8025b370>] ? kthread+0x0/0x90
 [<ffffffff8020c6b0>] ? child_rip+0x0/0x20
