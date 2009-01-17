Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZAQXTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZAQXTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760294AbZAQXT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:19:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763AbZAQXT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:19:27 -0500
Date: Sat, 17 Jan 2009 18:19:25 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: .29rc2 lockdep report. fb_mmap vs sys_mmap2
Message-ID: <20090117231925.GA28055@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two mmaps enter! Fight!


 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.29-0.41.rc2.fc11.i686 #1
 -------------------------------------------------------
 plymouthd/669 is trying to acquire lock:
 (&fb_info->lock){--..}, at: [<c055355c>] fb_mmap+0x87/0x156

 but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<c0406a5d>] sys_mmap2+0x44/0x7b

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&mm->mmap_sem){----}:
       [<c044fef3>] __lock_acquire+0x9af/0xb22
       [<c04500c1>] lock_acquire+0x5b/0x81
       [<c048e036>] might_fault+0x60/0x80
       [<c053dedc>] copy_to_user+0x2c/0xfc
       [<c05542cc>] fb_ioctl+0x247/0x338
       [<c04b0c9f>] vfs_ioctl+0x22/0x69
       [<c04b1214>] do_vfs_ioctl+0x46a/0x4a3
       [<c04b128d>] sys_ioctl+0x40/0x5a
       [<c0403b76>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

 -> #0 (&fb_info->lock){--..}:
       [<c044fdc8>] __lock_acquire+0x884/0xb22
       [<c04500c1>] lock_acquire+0x5b/0x81
       [<c06e1b98>] __mutex_lock_common+0xd5/0x329
       [<c06e1e84>] mutex_lock_nested+0x2e/0x36
       [<c055355c>] fb_mmap+0x87/0x156
       [<c0494620>] mmap_region+0x22b/0x43c
       [<c0494aa2>] do_mmap_pgoff+0x271/0x2d1
       [<c0406a73>] sys_mmap2+0x5a/0x7b
       [<c0403b76>] syscall_call+0x7/0xb
       [<ffffffff>] 0xffffffff

 other info that might help us debug this:

 1 lock held by plymouthd/669:
 #0:  (&mm->mmap_sem){----}, at: [<c0406a5d>] sys_mmap2+0x44/0x7b

 stack backtrace:
 Pid: 669, comm: plymouthd Not tainted 2.6.29-0.41.rc2.fc11.i686 #1
 Call Trace:
 [<c06e09b6>] ? printk+0xf/0x11
 [<c044f32d>] print_circular_bug_tail+0x5d/0x68
 [<c044fdc8>] __lock_acquire+0x884/0xb22
 [<c04500c1>] lock_acquire+0x5b/0x81
 [<c055355c>] ? fb_mmap+0x87/0x156
 [<c06e1b98>] __mutex_lock_common+0xd5/0x329
 [<c055355c>] ? fb_mmap+0x87/0x156
 [<c06e1e84>] mutex_lock_nested+0x2e/0x36
 [<c055355c>] ? fb_mmap+0x87/0x156
 [<c055355c>] fb_mmap+0x87/0x156
 [<c0494620>] mmap_region+0x22b/0x43c
 [<c0494aa2>] do_mmap_pgoff+0x271/0x2d1
 [<c0406a73>] sys_mmap2+0x5a/0x7b
 [<c0403b76>] syscall_call+0x7/0xb


-- 
http://www.codemonkey.org.uk
