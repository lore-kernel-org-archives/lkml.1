Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZINVdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZINVdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZINVdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:33:41 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57020 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZINVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QvDcaSI74cGvhnk6P6Wj0SRfc/0GdyQJ94gVS7bNN7nbNQ2j8M4OqEDOQwAU3CbIKM
         TxwbNtSXFy4yD3zaj1R/xISeWgHSfFm8Jf86DnXNIS3m/QlajICVD3U/6RgdOAEFmoSk
         qHRMXAHxW2YrA6H5WHj/Oe9g+b8wbrM2J0zj0=
MIME-Version: 1.0
In-Reply-To: <20090914203749.GF6045@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
	 <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere>
Date: Tue, 15 Sep 2009 01:33:42 +0400
Message-ID: <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
Subject: Re: [PATCH 0/4] kill-the-bkl/reiserfs: fix some lock dependency 
	inversions
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Alexander,
>
> It should be fixed now, still in the following tree:

Hi!
Another one, similar:
It is v2.6.31-3123-g99bc470 plus your 805031859(kill-the-bkl/reiserfs:
panic in case of lock imbalance), UP.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-03149-gdcc030a #1
-------------------------------------------------------
udevadm/716 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<c107249a>] might_fault+0x4a/0xa0

but task is already holding lock:
 (sysfs_mutex){+.+.+.}, at: [<c10cb9aa>] sysfs_readdir+0x5a/0x200

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (sysfs_mutex){+.+.+.}:
       [<c104e08e>] __lock_acquire+0xd0e/0x15c0
       [<c104e9ba>] lock_acquire+0x7a/0xa0
       [<c13402c6>] __mutex_lock_common+0x46/0x310
       [<c134066a>] mutex_lock_nested+0x3a/0x50
       [<c10cbcdc>] sysfs_addrm_start+0x2c/0xa0
       [<c10cca50>] create_dir+0x40/0x90
       [<c10ccacb>] sysfs_create_dir+0x2b/0x40
       [<c11bdd6b>] kobject_add_internal+0x9b/0x250
       [<c11be01d>] kobject_add_varg+0x2d/0x50
       [<c11be09c>] kobject_add+0x2c/0x60
       [<c1230984>] device_add+0xf4/0x4a0
       [<c10c98df>] add_partition+0x13f/0x230
       [<c10c9fdb>] rescan_partitions+0x24b/0x3c0
       [<c10aeb80>] __blkdev_get+0x140/0x320
       [<c10aed6a>] blkdev_get+0xa/0x10
       [<c10c9787>] register_disk+0x127/0x140
       [<c11b7ff0>] add_disk+0x80/0x140
       [<c12473a8>] sd_probe_async+0xf8/0x1b0
       [<c1042371>] async_thread+0xd1/0x220
       [<c103c6cc>] kthread+0x6c/0x80
       [<c100355f>] kernel_thread_helper+0x7/0x18

-> #2 (&bdev->bd_mutex){+.+.+.}:
       [<c104e08e>] __lock_acquire+0xd0e/0x15c0
       [<c104e9ba>] lock_acquire+0x7a/0xa0
       [<c13402c6>] __mutex_lock_common+0x46/0x310
       [<c134066a>] mutex_lock_nested+0x3a/0x50
       [<c10aea6a>] __blkdev_get+0x2a/0x320
       [<c10aed6a>] blkdev_get+0xa/0x10
       [<c10aeed1>] open_by_devnum+0x21/0x50
       [<c10fb577>] journal_init+0x1d7/0xa10
       [<c10e8463>] reiserfs_fill_super+0x313/0xdb0
       [<c108a898>] get_sb_bdev+0x108/0x150
       [<c10e6381>] get_super_block+0x21/0x30
       [<c1089910>] vfs_kern_mount+0x40/0xa0
       [<c10899c9>] do_kern_mount+0x39/0xd0
       [<c109f319>] do_mount+0x309/0x700
       [<c109f776>] sys_mount+0x66/0xa0
       [<c15fe886>] mount_block_root+0xc4/0x245
       [<c15fea60>] mount_root+0x59/0x5f
       [<c15feb77>] prepare_namespace+0x111/0x14b
       [<c15fe23d>] kernel_init+0xca/0xd6
       [<c100355f>] kernel_thread_helper+0x7/0x18

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c104e08e>] __lock_acquire+0xd0e/0x15c0
       [<c104e9ba>] lock_acquire+0x7a/0xa0
       [<c13402c6>] __mutex_lock_common+0x46/0x310
       [<c134066a>] mutex_lock_nested+0x3a/0x50
       [<c11012d8>] reiserfs_write_lock_once+0x28/0x50
       [<c10dd7cc>] reiserfs_get_block+0x5c/0x1440
       [<c10b0660>] do_mpage_readpage+0x120/0x4b0
       [<c10b0aef>] mpage_readpages+0x9f/0xe0
       [<c10dacb9>] reiserfs_readpages+0x19/0x20
       [<c1067dc5>] __do_page_cache_readahead+0x195/0x210
       [<c1067e61>] ra_submit+0x21/0x30
       [<c1062119>] filemap_fault+0x2e9/0x380
       [<c1074388>] __do_fault+0x38/0x3b0
       [<c1074fdd>] handle_mm_fault+0xcd/0x550
       [<c101af55>] do_page_fault+0xf5/0x240
       [<c13420d3>] error_code+0x63/0x68
       [<c10bcae4>] padzero+0x24/0x40
       [<c10bde9a>] load_elf_binary+0x61a/0x1450
       [<c108c0e0>] search_binary_handler+0x90/0x270
       [<c108e152>] do_execve+0x1d2/0x240
       [<c1001658>] sys_execve+0x28/0x60
       [<c1002d59>] syscall_call+0x7/0xb

-> #0 (&mm->mmap_sem){++++++}:
       [<c104e4a5>] __lock_acquire+0x1125/0x15c0
       [<c104e9ba>] lock_acquire+0x7a/0xa0
       [<c10724cb>] might_fault+0x7b/0xa0
       [<c11c4c86>] copy_to_user+0x36/0x130
       [<c10951f9>] filldir64+0xa9/0xf0
       [<c10cba4e>] sysfs_readdir+0xfe/0x200
       [<c1095485>] vfs_readdir+0x85/0xa0
       [<c1095504>] sys_getdents64+0x64/0xb0
       [<c1002cd8>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

2 locks held by udevadm/716:
 #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c1095452>] vfs_readdir+0x52/0xa0
 #1:  (sysfs_mutex){+.+.+.}, at: [<c10cb9aa>] sysfs_readdir+0x5a/0x200

stack backtrace:
Pid: 716, comm: udevadm Tainted: G        W  2.6.31-03149-gdcc030a #1
Call Trace:
 [<c133f41a>] ? printk+0x18/0x1e
 [<c104c110>] print_circular_bug+0xc0/0xd0
 [<c104e4a5>] __lock_acquire+0x1125/0x15c0
 [<c104e9ba>] lock_acquire+0x7a/0xa0
 [<c107249a>] ? might_fault+0x4a/0xa0
 [<c10724cb>] might_fault+0x7b/0xa0
 [<c107249a>] ? might_fault+0x4a/0xa0
 [<c11c4c86>] copy_to_user+0x36/0x130
 [<c10951f9>] filldir64+0xa9/0xf0
 [<c1095150>] ? filldir64+0x0/0xf0
 [<c10cba4e>] sysfs_readdir+0xfe/0x200
 [<c1095150>] ? filldir64+0x0/0xf0
 [<c1095150>] ? filldir64+0x0/0xf0
 [<c1095485>] vfs_readdir+0x85/0xa0
 [<c1095504>] sys_getdents64+0x64/0xb0
 [<c1002cd8>] sysenter_do_call+0x12/0x36
