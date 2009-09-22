Return-Path: <linux-kernel-owner+w=401wt.eu-S1756398AbZIVNzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398AbZIVNzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZIVNzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:55:43 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:41143 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZIVNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XoxiQ0YJ9Uwg9yP+dvv7/g9xbHgxpkGZLScJOtu+sXiR0zL3tGmB4Vgvkbq9btpCEy
         UKWpw00V+Y9eGAUZqJg3ABWscopQ2oVd9F43Eb/+frBuW319wIwHv1z8oWw22Kxs9ZmV
         lFddEm6Cl39KM5QRW2Qrg3Oj5NTqfklM4Ey9o=
MIME-Version: 1.0
In-Reply-To: <20090917050639.GA5060@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com>
	 <20090826201330.GA18761@orion> <20090914203749.GF6045@nowhere>
	 <a4423d670909141433g18659aay6e177b1302e5b4a0@mail.gmail.com>
	 <20090916203747.GB5068@nowhere>
	 <a4423d670909161637r67c933a0n2c142898ea493f22@mail.gmail.com>
	 <20090917050639.GA5060@nowhere>
Date: Tue, 22 Sep 2009 17:55:43 +0400
Message-ID: <a4423d670909220655j37cc49f8rcd29d8f154c5e6e6@mail.gmail.com>
Subject: Re: [PATCH] kill-the-bkl/reiserfs: Fix induced mm->mmap_sem to 
	sysfs_mutex dependency
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic.

Another very similar warning.
(smp 2*2core)
v2.6.31-7068-g43c1266 plus 193be0ee1 kill-the-bkl/reiserfs: Fix
induced mm->mmap_sem to sysfs_mutex dependency


[ INFO: possible circular locking dependency detected ]
2.6.31-07095-g25a3912 #4
-------------------------------------------------------
udevadm/790 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<c1098942>] might_fault+0x72/0xc0

but task is already holding lock:
 (sysfs_mutex){+.+.+.}, at: [<c110813c>] sysfs_readdir+0x7c/0x260

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (sysfs_mutex){+.+.+.}:
       [<c1069810>] __lock_acquire+0xc90/0x1290
       [<c1069eaa>] lock_acquire+0x9a/0xd0
       [<c13ff805>] __mutex_lock_common+0x65/0x440
       [<c13ffce0>] mutex_lock_nested+0x40/0x60
       [<c1108535>] sysfs_addrm_start+0x35/0xc0
       [<c11094d1>] create_dir+0x51/0xb0
       [<c1109566>] sysfs_create_dir+0x36/0x60
       [<c12356d7>] kobject_add_internal+0xa7/0x270
       [<c12359da>] kobject_add_varg+0x3a/0x70
       [<c1235a4e>] kobject_init_and_add+0x3e/0x60
       [<c10af62d>] sysfs_slab_add+0x7d/0x1e0
       [<c10af7ef>] sysfs_add_func+0x5f/0xa0
       [<c104d16e>] worker_thread+0x16e/0x270
       [<c1051fac>] kthread+0x7c/0x90
       [<c1003f5b>] kernel_thread_helper+0x7/0x7c

-> #4 (slub_lock){+++++.}:
       [<c1069810>] __lock_acquire+0xc90/0x1290
       [<c1069eaa>] lock_acquire+0x9a/0xd0
       [<c14000d2>] down_read+0x52/0xb0
       [<c15e2497>] slab_cpuup_callback+0x4a/0x196
       [<c140481d>] notifier_call_chain+0x4d/0x90
       [<c1058095>] __raw_notifier_call_chain+0x25/0x40
       [<c15e1c63>] cpu_up+0xdd/0x1a6
       [<c15b1403>] kernel_init+0xac/0x1a8
       [<c1003f5b>] kernel_thread_helper+0x7/0x7c

-> #3 (cpu_hotplug.lock){+.+.+.}:
       [<c1069810>] __lock_acquire+0xc90/0x1290
       [<c1069eaa>] lock_acquire+0x9a/0xd0
       [<c13ff805>] __mutex_lock_common+0x65/0x440
       [<c13ffce0>] mutex_lock_nested+0x40/0x60
       [<c15e1c24>] cpu_up+0x9e/0x1a6
       [<c15b1403>] kernel_init+0xac/0x1a8
       [<c1003f5b>] kernel_thread_helper+0x7/0x7c

-> #2 (cpu_add_remove_lock){+.+.+.}:
       [<c1069810>] __lock_acquire+0xc90/0x1290
       [<c1069eaa>] lock_acquire+0x9a/0xd0
       [<c13ff805>] __mutex_lock_common+0x65/0x440
       [<c13ffce0>] mutex_lock_nested+0x40/0x60
       [<c103ad9d>] cpu_maps_update_begin+0x1d/0x40
       [<c104d9cc>] __create_workqueue_key+0x9c/0x210
       [<c113be94>] journal_init+0x9a4/0xa60
       [<c112735f>] reiserfs_fill_super+0x35f/0xdf0
       [<c10b8618>] get_sb_bdev+0x138/0x180
       [<c1124f0d>] get_super_block+0x2d/0x50
       [<c10b72f1>] vfs_kern_mount+0x51/0xc0
       [<c10b73ed>] do_kern_mount+0x4d/0x100
       [<c10d115a>] do_mount+0x21a/0x720
       [<c10d16ec>] sys_mount+0x8c/0xe0
       [<c15b1d19>] mount_block_root+0xcf/0x26b
       [<c15b1f19>] mount_root+0x64/0x7b
       [<c15b204c>] prepare_namespace+0x11c/0x167
       [<c15b14df>] kernel_init+0x188/0x1a8
       [<c1003f5b>] kernel_thread_helper+0x7/0x7c

-> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c1069810>] __lock_acquire+0xc90/0x1290
       [<c1069eaa>] lock_acquire+0x9a/0xd0
       [<c13ff805>] __mutex_lock_common+0x65/0x440
       [<c13ffce0>] mutex_lock_nested+0x40/0x60
       [<c1142282>] reiserfs_write_lock_once+0x32/0x70
       [<c111c1fb>] reiserfs_get_block+0x6b/0x1510
       [<c10e5e48>] do_mpage_readpage+0x168/0x510
       [<c10e631f>] mpage_readpages+0xaf/0x100
       [<c1118ef5>] reiserfs_readpages+0x25/0x40
       [<c108bc2d>] __do_page_cache_readahead+0x1fd/0x2a0
       [<c108bcfd>] ra_submit+0x2d/0x50
       [<c1083bf6>] filemap_fault+0x436/0x470
       [<c109af24>] __do_fault+0x54/0x410
       [<c109bdd1>] handle_mm_fault+0x1c1/0x680
       [<c14043e5>] do_page_fault+0x115/0x380
       [<c1401ff0>] error_code+0x78/0x80
       [<c10f45a7>] padzero+0x37/0x50
       [<c10f4d4d>] load_elf_binary+0x63d/0x1500
       [<c10bc461>] search_binary_handler+0x1a1/0x330
       [<c10bcb48>] do_execve+0x1f8/0x270
       [<c1001783>] sys_execve+0x33/0x80
       [<c10033dc>] syscall_call+0x7/0xb

-> #0 (&mm->mmap_sem){++++++}:
       [<c1069dc8>] __lock_acquire+0x1248/0x1290
       [<c1069eaa>] lock_acquire+0x9a/0xd0
       [<c1098973>] might_fault+0xa3/0xc0
       [<c123d611>] copy_to_user+0x41/0x130
       [<c10c4f9c>] filldir64+0xcc/0x120
       [<c11081ba>] sysfs_readdir+0xfa/0x260
       [<c10c525e>] vfs_readdir+0x9e/0xc0
       [<c10c52fa>] sys_getdents64+0x7a/0xe0
       [<c100334f>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

2 locks held by udevadm/790:
 #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c10c522a>] vfs_readdir+0x6a/0xc0
 #1:  (sysfs_mutex){+.+.+.}, at: [<c110813c>] sysfs_readdir+0x7c/0x260

stack backtrace:
Pid: 790, comm: udevadm Not tainted 2.6.31-07095-g25a3912 #4
Call Trace:
 [<c13fdd64>] ? printk+0x23/0x37
 [<c1067738>] print_circular_bug+0xe8/0x100
 [<c1069dc8>] __lock_acquire+0x1248/0x1290
 [<c1069eaa>] lock_acquire+0x9a/0xd0
 [<c1098942>] ? might_fault+0x72/0xc0
 [<c1098942>] ? might_fault+0x72/0xc0
 [<c1098973>] might_fault+0xa3/0xc0
 [<c1098942>] ? might_fault+0x72/0xc0
 [<c123d611>] copy_to_user+0x41/0x130
 [<c10c4f9c>] filldir64+0xcc/0x120
 [<c11081ba>] sysfs_readdir+0xfa/0x260
 [<c10c4ed0>] ? filldir64+0x0/0x120
 [<c10c525e>] vfs_readdir+0x9e/0xc0
 [<c10c4ed0>] ? filldir64+0x0/0x120
 [<c10c52fa>] sys_getdents64+0x7a/0xe0
 [<c100334f>] sysenter_do_call+0x12/0x36
