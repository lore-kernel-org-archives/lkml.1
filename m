Return-Path: <linux-kernel-owner+w=401wt.eu-S934370AbZLGL7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbZLGL7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934269AbZLGL7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:59:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40365 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934215AbZLGL7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:59:45 -0500
Date: Mon, 7 Dec 2009 12:59:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
Subject: NFS lockdep lock misordering mmap_sem<->i_mutex_key with
	2.6.32-git1
Message-ID: <20091207115949.GA7610@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While booting 2.6.32-git1 on a NFS root box I got the following
lockdep warning early at boot. I haven't looked at details.

-Andi

VFS: Mounted root (nfs filesystem) on device 0:15.
VFS: Mounted root (nfs filesystem) on device 0:15.
Freeing unused kernel memory: 2376k freed

=======================================================
[ INFO: possible circular locking dependency detected ]
-------------------------------------------------------
udevinfo/2551 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#5){+.+.+.}, at: [<ffffffff8118e0d3>] nfs_revalidate_mapping+0x7c/0xc5

but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff8100fc83>] sys_mmap+0x76/0xc7

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff81071d0b>] __lock_acquire+0x1435/0x1774
       [<ffffffff81072106>] lock_acquire+0xbc/0xd9
       [<ffffffff810baa14>] might_fault+0x84/0xa4
       [<ffffffff810ec340>] filldir+0x6a/0xcb
       [<ffffffff81189bad>] nfs_do_filldir+0x39d/0x4ac
       [<ffffffff8118a4e9>] nfs_readdir+0x82d/0x8ce
       [<ffffffff810ec4bf>] vfs_readdir+0x6c/0xa1
       [<ffffffff810ec632>] sys_getdents+0x7d/0xc9
       [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#5){+.+.+.}:
       [<ffffffff81071a30>] __lock_acquire+0x115a/0x1774
       [<ffffffff81072106>] lock_acquire+0xbc/0xd9
       [<ffffffff8149210d>] mutex_lock_nested+0x68/0x2d2
       [<ffffffff8118e0d3>] nfs_revalidate_mapping+0x7c/0xc5
       [<ffffffff8118bad9>] nfs_file_mmap+0x68/0x71
       [<ffffffff810c29c0>] mmap_region+0x311/0x50f
       [<ffffffff810c2f13>] do_mmap_pgoff+0x355/0x3b8
       [<ffffffff8100fca1>] sys_mmap+0x94/0xc7
       [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by udevinfo/2551:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8100fc83>] sys_mmap+0x76/0xc7

stack backtrace:
Pid: 2551, comm: udevinfo Not tainted 2.6.32-git1 #31
Call Trace:
 [<ffffffff81070388>] print_circular_bug+0xb3/0xc2
 [<ffffffff81071a30>] __lock_acquire+0x115a/0x1774
 [<ffffffff810a401d>] ? find_get_pages_tag+0x0/0x12a
 [<ffffffff81072106>] lock_acquire+0xbc/0xd9
 [<ffffffff8118e0d3>] ? nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff8149210d>] mutex_lock_nested+0x68/0x2d2
 [<ffffffff8118e0d3>] ? nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff8118e0d3>] ? nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff810c291d>] ? mmap_region+0x26e/0x50f
 [<ffffffff8118e0d3>] nfs_revalidate_mapping+0x7c/0xc5
 [<ffffffff8118bad9>] nfs_file_mmap+0x68/0x71
 [<ffffffff810c29c0>] mmap_region+0x311/0x50f
 [<ffffffff810c2f13>] do_mmap_pgoff+0x355/0x3b8
 [<ffffffff8100fca1>] sys_mmap+0x94/0xc7
 [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
