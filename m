Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZKMJzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZKMJzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbZKMJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:55:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:10409 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbZKMJzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ePqjYN2KigneMHXGgxPdbYssvSu+xruVfoibC0/2be1OdKWOKA2yATY8TVstUMazGj
         r5BaapvGp3WCZDBxXhtphHtygdRR+hazJPImomPC45BUAwEaeaXpcG+kvaDY8y7M5nyn
         txAQNAG/R6xrmEpgT0yuj6S70YG5R3iZiLaUs=
MIME-Version: 1.0
Date: Fri, 13 Nov 2009 10:55:12 +0100
Message-ID: <c4e36d110911130155o4c7471b0qd382a01842631154@mail.gmail.com>
Subject: INFO: possible circular locking dependency 2.6.32-rc6 drm
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: airlied@redhat.com, yakui.zhao@intel.com, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


I've got this weird INFO trace.  I've not quite sure what happened at
this moment on my machine - as I've discovered this trace just later
in the log. But I might have been running Xorg :1 through valgrind
while using  Xorg :0 - and maybe Xorg :1 crashed at this moment ?

Machine is T61, 4GB, intel graphics,  Xorg 7.1, intel driver 2.9.1


 =======================================================
[ INFO: possible circular locking dependency detected ]
2.6.32-rc6-00167-ge75f911 #37
-------------------------------------------------------
memcheck-amd64-/3741 is trying to acquire lock:
 (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffffa0303c9f>]
drm_fb_release+0x2f/0xa0 [drm]

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff81112568>] sys_munmap+0x48/0x80

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff810904c3>] __lock_acquire+0xe23/0x1490
       [<ffffffff81090bcb>] lock_acquire+0x9b/0x140
       [<ffffffff81109197>] might_fault+0xa7/0xd0
       [<ffffffffa0304812>] drm_mode_getresources+0x1a2/0x620 [drm]
       [<ffffffffa02f9f76>] drm_ioctl+0x176/0x390 [drm]
       [<ffffffff811442bc>] vfs_ioctl+0x7c/0xa0
       [<ffffffff81144404>] do_vfs_ioctl+0x84/0x590
       [<ffffffff81144991>] sys_ioctl+0x81/0xa0
       [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b

-> #0 (&dev->mode_config.mutex){+.+.+.}:
       [<ffffffff81090aad>] __lock_acquire+0x140d/0x1490
       [<ffffffff81090bcb>] lock_acquire+0x9b/0x140
       [<ffffffff8141f8ce>] __mutex_lock_common+0x5e/0x4b0
       [<ffffffff8141fe03>] mutex_lock_nested+0x43/0x50
       [<ffffffffa0303c9f>] drm_fb_release+0x2f/0xa0 [drm]
       [<ffffffffa02fa6bf>] drm_release+0x51f/0x5d0 [drm]
       [<ffffffff811335b3>] __fput+0x103/0x220
       [<ffffffff811336f5>] fput+0x25/0x30
       [<ffffffff81110a91>] remove_vma+0x51/0x80
       [<ffffffff81112497>] do_munmap+0x2c7/0x350
       [<ffffffff81112576>] sys_munmap+0x56/0x80
       [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by memcheck-amd64-/3741:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81112568>] sys_munmap+0x48/0x80

stack backtrace:
Pid: 3741, comm: memcheck-amd64- Not tainted 2.6.32-rc6-00167-ge75f911 #37
Call Trace:
 [<ffffffff8108dd09>] print_circular_bug+0xe9/0xf0
 [<ffffffff81090aad>] __lock_acquire+0x140d/0x1490
 [<ffffffff8112b02d>] ? __delete_object+0x7d/0xb0
 [<ffffffff81090bcb>] lock_acquire+0x9b/0x140
 [<ffffffffa0303c9f>] ? drm_fb_release+0x2f/0xa0 [drm]
 [<ffffffff8108024f>] ? cpu_clock+0x4f/0x60
 [<ffffffff8141f8ce>] __mutex_lock_common+0x5e/0x4b0
 [<ffffffffa0303c9f>] ? drm_fb_release+0x2f/0xa0 [drm]
 [<ffffffffa0303c9f>] ? drm_fb_release+0x2f/0xa0 [drm]
 [<ffffffff8108eb57>] ? mark_held_locks+0x67/0x90
 [<ffffffff8141f7e5>] ? __mutex_unlock_slowpath+0xf5/0x170
 [<ffffffff8108ee25>] ? trace_hardirqs_on_caller+0x145/0x190
 [<ffffffff8141fe03>] mutex_lock_nested+0x43/0x50
 [<ffffffffa0303c9f>] drm_fb_release+0x2f/0xa0 [drm]
 [<ffffffffa02fa6bf>] drm_release+0x51f/0x5d0 [drm]
 [<ffffffff811335b3>] __fput+0x103/0x220
 [<ffffffff811336f5>] fput+0x25/0x30
 [<ffffffff81110a91>] remove_vma+0x51/0x80
 [<ffffffff81112497>] do_munmap+0x2c7/0x350
 [<ffffffff81112576>] sys_munmap+0x56/0x80
 [<ffffffff8100c11b>] system_call_fastpath+0x16/0x1b

Zdenek
