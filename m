Return-Path: <linux-kernel-owner+w=401wt.eu-S1765195AbZDJTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765195AbZDJTZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbZDJTZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:25:24 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56531 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbZDJTZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=V0ToGzT6++s69txFN6/HTzEjvErN2xK5mMiq2Hb3zGLWmj2ropnY+q1gjI6MQJ4C5Z
         iUs1W3RMqoQh5791lmyaExMZvMUGjoQJMHjyhhyk825aRcA0w6fSSkMay3ojLqmKRqO8
         E2Po7LiH93eGqR5/E96FGV0uFa7AuYoVG0TYE=
Date: Fri, 10 Apr 2009 21:25:33 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: [PATCH] Fix inconsistent lock state in inotify
Message-ID: <20090410192533.GA24345@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
in current -git lockdep generates the following warning:

 =================================
 [ INFO: inconsistent lock state ]
 2.6.30-rc1-kgdb #182
 ---------------------------------
 inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
 kswapd0/419 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802c7036>] inotify_inode_is_dead+0x30/0x94
 {RECLAIM_FS-ON-W} state was registered at:
   [<ffffffff80259621>] mark_held_locks+0x4d/0x6b
   [<ffffffff802596e3>] lockdep_trace_alloc+0xa4/0xbd
   [<ffffffff8029ac2e>] __kmalloc+0x51/0xe6
   [<ffffffff802c7ea2>] kernel_event+0xa7/0x10e
   [<ffffffff802c7fdc>] inotify_dev_queue_event+0xd3/0x14b
   [<ffffffff802c6f56>] inotify_inode_queue_event+0xab/0xe0
   [<ffffffff802a6d83>] vfs_create+0xb1/0xc0
   [<ffffffff802a975a>] do_filp_open+0x240/0x842
   [<ffffffff8029cb1e>] do_sys_open+0x53/0xda
   [<ffffffff802d0a62>] compat_sys_open+0x15/0x17
   [<ffffffff80228e14>] sysenter_dispatch+0x7/0x30
   [<ffffffffffffffff>] 0xffffffffffffffff
 irq event stamp: 30075
 hardirqs last  enabled at (30075): [<ffffffff802712cf>] call_rcu+0x5d/0x6a
 hardirqs last disabled at (30074): [<ffffffff80271296>] call_rcu+0x24/0x6a
 softirqs last  enabled at (27584): [<ffffffff8023d151>] __do_softirq+0x115/0x124
 softirqs last disabled at (27573): [<ffffffff8020c13c>] call_softirq+0x1c/0x28
 
 other info that might help us debug this:
 2 locks held by kswapd0/419:
  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8027dd86>] shrink_slab+0x38/0x188
  #1:  (&type->s_umount_key#16){++++..}, at: [<ffffffff802ad8c9>] shrink_dcache_memory+0xb9/0x193
 
 stack backtrace:
 Pid: 419, comm: kswapd0 Not tainted 2.6.30-rc1-kgdb #182
 Call Trace:
  [<ffffffff8025906c>] print_usage_bug+0x1b6/0x1c7
  [<ffffffff80259c54>] ? check_usage_forwards+0x0/0xa1
  [<ffffffff8025938f>] mark_lock+0x312/0x557
  [<ffffffff8025ad03>] __lock_acquire+0x7b7/0x1668
  [<ffffffff802c7036>] ? inotify_inode_is_dead+0x30/0x94
  [<ffffffff8025bc09>] lock_acquire+0x55/0x71
  [<ffffffff802c7036>] ? inotify_inode_is_dead+0x30/0x94
  [<ffffffff80442ec8>] mutex_lock_nested+0x5a/0x2fa
  [<ffffffff802c7036>] ? inotify_inode_is_dead+0x30/0x94
  [<ffffffff80259621>] ? mark_held_locks+0x4d/0x6b
  [<ffffffff802712cf>] ? call_rcu+0x5d/0x6a
  [<ffffffff802c7036>] inotify_inode_is_dead+0x30/0x94
  [<ffffffff802ad3f1>] dentry_iput+0x82/0xc1
  [<ffffffff802ad4f9>] d_kill+0x24/0x45
  [<ffffffff802ad778>] __shrink_dcache_sb+0x25e/0x2f6
  [<ffffffff802ad901>] shrink_dcache_memory+0xf1/0x193
  [<ffffffff8027de2d>] shrink_slab+0xdf/0x188
  [<ffffffff8027e3be>] kswapd+0x4e8/0x6a3
  [<ffffffff80232d0c>] ? finish_task_switch+0x3b/0x10c
  [<ffffffff8027bec4>] ? isolate_pages_global+0x0/0x26f
  [<ffffffff8024becf>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff802598d6>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff80444a41>] ? _spin_unlock_irqrestore+0x4c/0x68
  [<ffffffff8027ded6>] ? kswapd+0x0/0x6a3
  [<ffffffff8027ded6>] ? kswapd+0x0/0x6a3
  [<ffffffff8024bb80>] kthread+0x49/0x76
  [<ffffffff8020c03a>] child_rip+0xa/0x20
  [<ffffffff8020ba00>] ? restore_args+0x0/0x30
  [<ffffffff8024bb37>] ? kthread+0x0/0x76
  [<ffffffff8020c030>] ? child_rip+0x0/0x20

The cause is a call to kmalloc with GFP_KERNEL; the following patch
changes the flag to GFP_NOFS, which is also consistent with an earlier
call to kmem_cache_alloc in the same function.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---

 fs/notify/inotify/inotify_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bed766e..1634319 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -220,7 +220,7 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
 				rem = 0;
 		}
 
-		kevent->name = kmalloc(len + rem, GFP_KERNEL);
+		kevent->name = kmalloc(len + rem, GFP_NOFS);
 		if (unlikely(!kevent->name)) {
 			kmem_cache_free(event_cachep, kevent);
 			return NULL;


Luca
-- 
"La teoria e` quando sappiamo come funzionano le cose ma non funzionano.
 La pratica e` quando le cose funzionano ma non sappiamo perche`.
 Abbiamo unito la teoria e la pratica: le cose non funzionano piu` e non
 sappiamo il perche`." -- A. Einstein
