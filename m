Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYESHPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYESHPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYESHOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:14:52 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40827 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYESHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:14:51 -0400
To: opslynx@gmail.com
CC: linux-kernel@vger.kernel.org, mszeredi@suse.cz, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org
In-reply-to: <df47b87a0805171337h5da01cc4pd9df7d318afc47c2@mail.gmail.com>
	(opslynx@gmail.com)
Subject: Re: BISECTED REGRESSION: 2.6.26-rc2: FUSE changes break mount of ntfs-3g
References: <df47b87a0805171337h5da01cc4pd9df7d318afc47c2@mail.gmail.com>
Message-Id: <E1Jxza1-0007YO-KM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 May 2008 09:14:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Running a Linux ops-desktop 2.6.26-rc1 #7 SMP PREEMPT Sat May 17
> 19:33:36 EEST 2008 x86_64 GNU/Linux
> 
> When attempting to mount a ntfs-3g partition under 2.6.26-rc2, i got
> the following error:
> 
> fuse: mount failed: Cannot allocate memory
> 
> I also got the OOPS included below. I bisected the error to:
> 
> b6f2fcbcfca9db2bd7aa24940224fcd3bbdbb8aa is first bad commit
> commit b6f2fcbcfca9db2bd7aa24940224fcd3bbdbb8aa
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Wed Apr 30 00:54:34 2008 -0700
> 
>     mm: bdi: expose the BDI object in sysfs for FUSE
> 
>     Register FUSE's backing_dev_info under sysfs with the name
> "fuse-MAJOR:MINOR"
> 
>     Make the fuse control filesystem use s_dev instead of a fuse specific ID.
>     This makes it easier to match directories under
> /sys/fs/fuse/connections/ with
>     directories under /sys/class/bdi, and with actual mounts.
> 
>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks.  I've tried to reproduce this bug, but was unable to.

That patch looks OK to me, however there's something very weird going
on if sysfs_add_one() gets called with an already existing name.

Could you please post the full dmesg output?  That should include a
line like

  sysfs: duplicate filename 'foobar' can not be created

What are the exact commands that you perform (or contents of
/etc/fstab, etc. that might be relevant) to tirgger this bug?

Thanks,
Miklos


> 
> :040000 040000 f993fbf0716b58bfcf12dd27abbb25c43ab78326
> 176a10dec86edc841fc44db6ad4011377a9efe02 M	fs
> 
> 
> OOPS:
> 
> WARNING: at fs/sysfs/dir.c:425 sysfs_add_one+0xa3/0xc0()
> Modules linked in:
> Pid: 7545, comm: mount.ntfs Not tainted 2.6.26-rc1 #7
> 
> Call Trace:
>  [<ffffffff80250ce4>] warn_on_slowpath+0x64/0xa0
>  [<ffffffff80251e1e>] printk+0x4e/0x60
>  [<ffffffff802c2e93>] find_inode+0x43/0x70
>  [<ffffffff802f9cf0>] sysfs_ilookup_test+0x0/0x10
>  [<ffffffff802c3014>] ifind+0x64/0xc0
>  [<ffffffff802f9f99>] sysfs_find_dirent+0x29/0x40
>  [<ffffffff802fa053>] sysfs_add_one+0xa3/0xc0
>  [<ffffffff802fa670>] create_dir+0x60/0xb0
>  [<ffffffff802fa6f1>] sysfs_create_dir+0x31/0x50
>  [<ffffffff8037b4d2>] kobject_get+0x12/0x20
>  [<ffffffff8037b632>] kobject_add_internal+0xe2/0x1c0
>  [<ffffffff8037bc14>] kobject_add+0x54/0x80
>  [<ffffffff80314efa>] search_by_key+0x14a/0xe10
>  [<ffffffff802869be>] free_pages_bulk+0xde/0x300
>  [<ffffffff8037b4d2>] kobject_get+0x12/0x20
>  [<ffffffff803ed807>] get_device+0x17/0x30
>  [<ffffffff803edf6a>] device_add+0xba/0x5c0
>  [<ffffffff8037b273>] kobject_init+0x33/0x90
>  [<ffffffff803ee578>] device_create+0xe8/0x140
>  [<ffffffff8038080c>] vsnprintf+0x45c/0x700
>  [<ffffffff80382da1>] kvasprintf+0x71/0x90
>  [<ffffffff8028f375>] bdi_register+0x95/0x120
>  [<ffffffff802ab854>] percpu_populate+0x44/0x60
>  [<ffffffff802aa054>] __kmalloc+0xa4/0x100
>  [<ffffffff802ab9e7>] __percpu_alloc_mask+0x77/0xb0
>  [<ffffffff8038d86c>] percpu_counter_init+0x6c/0x80
>  [<ffffffff8028f227>] bdi_init+0x77/0xc0
>  [<ffffffff8035300a>] fuse_fill_super+0x23a/0x640
>  [<ffffffff805a14c1>] __down_write_nested+0xa1/0xc0
>  [<ffffffff8037f35e>] strlcpy+0x4e/0x80
>  [<ffffffff802b0664>] get_sb_bdev+0x144/0x180
>  [<ffffffff80352dd0>] fuse_fill_super+0x0/0x640
>  [<ffffffff802b0396>] vfs_kern_mount+0x56/0xc0
>  [<ffffffff802b0463>] do_kern_mount+0x53/0x110
>  [<ffffffff802c892b>] do_new_mount+0x9b/0xe0
>  [<ffffffff802c8b56>] do_mount+0x1e6/0x220
>  [<ffffffff8026a1a6>] down+0x16/0x50
>  [<ffffffff802c8c2b>] sys_mount+0x9b/0x100
>  [<ffffffff8022442b>] system_call_after_swapgs+0x7b/0x80
> 
> ---[ end trace 1f3b5efdffae7d27 ]---
> kobject_add_internal failed for 253:3 with -EEXIST, don't try to
> register things with the same name in the same directory.
> Pid: 7545, comm: mount.ntfs Tainted: G        W 2.6.26-rc1 #7
> 
> Call Trace:
>  [<ffffffff8037b6c3>] kobject_add_internal+0x173/0x1c0
>  [<ffffffff8037bc14>] kobject_add+0x54/0x80
>  [<ffffffff80314efa>] search_by_key+0x14a/0xe10
>  [<ffffffff802869be>] free_pages_bulk+0xde/0x300
>  [<ffffffff8037b4d2>] kobject_get+0x12/0x20
>  [<ffffffff803ed807>] get_device+0x17/0x30
>  [<ffffffff803edf6a>] device_add+0xba/0x5c0
>  [<ffffffff8037b273>] kobject_init+0x33/0x90
>  [<ffffffff803ee578>] device_create+0xe8/0x140
>  [<ffffffff8038080c>] vsnprintf+0x45c/0x700
>  [<ffffffff80382da1>] kvasprintf+0x71/0x90
>  [<ffffffff8028f375>] bdi_register+0x95/0x120
>  [<ffffffff802ab854>] percpu_populate+0x44/0x60
>  [<ffffffff802aa054>] __kmalloc+0xa4/0x100
>  [<ffffffff802ab9e7>] __percpu_alloc_mask+0x77/0xb0
>  [<ffffffff8038d86c>] percpu_counter_init+0x6c/0x80
>  [<ffffffff8028f227>] bdi_init+0x77/0xc0
>  [<ffffffff8035300a>] fuse_fill_super+0x23a/0x640
>  [<ffffffff805a14c1>] __down_write_nested+0xa1/0xc0
>  [<ffffffff8037f35e>] strlcpy+0x4e/0x80
>  [<ffffffff802b0664>] get_sb_bdev+0x144/0x180
>  [<ffffffff80352dd0>] fuse_fill_super+0x0/0x640
>  [<ffffffff802b0396>] vfs_kern_mount+0x56/0xc0
>  [<ffffffff802b0463>] do_kern_mount+0x53/0x110
>  [<ffffffff802c892b>] do_new_mount+0x9b/0xe0
>  [<ffffffff802c8b56>] do_mount+0x1e6/0x220
>  [<ffffffff8026a1a6>] down+0x16/0x50
>  [<ffffffff802c8c2b>] sys_mount+0x9b/0x100
>  [<ffffffff8022442b>] system_call_after_swapgs+0x7b/0x80
> 
> 
> If any further info is required, let me know. I'm willing to test any
> patches as well.
