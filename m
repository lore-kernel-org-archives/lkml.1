Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbXFUSAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbXFUSAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759755AbXFUSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:00:22 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4916 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759293AbXFUSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:00:20 -0400
Message-ID: <467ABCAD.7070304@xs4all.nl>
Date: Thu, 21 Jun 2007 20:00:13 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: 2.6.21.4: possible circular locking dependency detected
References: <467AB953.9080106@xs4all.nl>
In-Reply-To: <467AB953.9080106@xs4all.nl>
X-Enigmail-Version: 0.95.1
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:

> While copying a small file over to a windows box via cifs, once again I
> got something like this:

Again with 2.6.21.5:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21.5 #10
-------------------------------------------------------
cp/3480 is trying to acquire lock:
 (sk_lock-AF_INET){--..}, at: [<c02c5d45>] tcp_sendmsg+0x16/0x9cc

but task is already holding lock:
 (&inode->i_alloc_sem){--..}, at: [<c0167e28>] notify_change+0xe8/0x2d0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&inode->i_alloc_sem){--..}:
       [<c012c0e8>] __lock_acquire+0x9e1/0xb85
       [<c012c2f4>] lock_acquire+0x68/0x82
       [<c0126503>] down_write+0x3a/0x53
       [<c0167e28>] notify_change+0xe8/0x2d0
       [<c0154e0e>] do_truncate+0x53/0x6c
       [<c015d79c>] may_open+0x1ba/0x202
       [<c015f706>] open_namei+0x27f/0x5af
       [<c0154b73>] do_filp_open+0x26/0x3b
       [<c0154bcb>] do_sys_open+0x43/0xc2
       [<c0154c82>] sys_open+0x1c/0x1e
       [<c01026a6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #2 (&sysfs_inode_imutex_key){--..}:
       [<c012c0e8>] __lock_acquire+0x9e1/0xb85
       [<c012c2f4>] lock_acquire+0x68/0x82
       [<c02f7d70>] __mutex_lock_slowpath+0xdc/0x266
       [<c02f7f16>] mutex_lock+0x1c/0x1f
       [<c018c43d>] create_dir+0x20/0x196
       [<c018c5fd>] sysfs_create_dir+0x4a/0x64
       [<c01d2bf9>] kobject_shadow_add+0xd6/0x189
       [<c01d2cb6>] kobject_add+0xa/0xc
       [<c0223f21>] device_add+0xae/0x62b
       [<c02aaf6f>] netdev_register_sysfs+0x5a/0x5f
       [<c02a10ba>] register_netdevice+0x22c/0x2e4
       [<c02a220c>] register_netdev+0x40/0x4d
       [<c022c160>] rhine_init_one+0x492/0x64f
       [<c01e201d>] pci_device_probe+0x39/0x5b
       [<c0225e47>] really_probe+0xbd/0x145
       [<c0225f64>] driver_probe_device+0x95/0xa1
       [<c0226079>] __driver_attach+0x6a/0xa1
       [<c022543d>] bus_for_each_dev+0x36/0x5b
       [<c0225cbb>] driver_attach+0x19/0x1b
       [<c0225724>] bus_add_driver+0x6a/0x170
       [<c022628b>] driver_register+0x79/0x7e
       [<c01e21a4>] __pci_register_driver+0x7b/0xa8
       [<c040a0cf>] rhine_init+0x5d/0x5f
       [<c03f271c>] init+0x95/0x17a
       [<c01038e7>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (rtnl_mutex){--..}:
       [<c012c0e8>] __lock_acquire+0x9e1/0xb85
       [<c012c2f4>] lock_acquire+0x68/0x82
       [<c02f7d70>] __mutex_lock_slowpath+0xdc/0x266
       [<c02f7f16>] mutex_lock+0x1c/0x1f
       [<c02a89af>] rtnl_lock+0xd/0xf
       [<c02e0f5d>] ip_mc_join_group+0x2c/0xc9
       [<c02c261f>] ip_setsockopt+0x64b/0x9a7
       [<c02d7db8>] udp_setsockopt+0x43/0x4a
       [<c029a042>] sock_common_setsockopt+0x1e/0x24
       [<c029870b>] sys_setsockopt+0x7b/0x97
       [<c0299d5d>] sys_socketcall+0x1e8/0x241
       [<c01026a6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #0 (sk_lock-AF_INET){--..}:
       [<c012bfc9>] __lock_acquire+0x8c2/0xb85
       [<c012c2f4>] lock_acquire+0x68/0x82
       [<c029a76b>] lock_sock_nested+0xba/0xc7
       [<c02c5d45>] tcp_sendmsg+0x16/0x9cc
       [<c02dd824>] inet_sendmsg+0x3e/0x49
       [<c0298b9b>] sock_sendmsg+0xe7/0x104
       [<c0299dde>] kernel_sendmsg+0x28/0x37
       [<dec97eba>] smb_send+0x92/0x11c [cifs]
       [<dec980c3>] SendReceive+0x17f/0x3dc [cifs]
       [<dec87817>] CIFSSMBSetEOF+0x1e6/0x229 [cifs]
       [<dec934dd>] cifs_setattr+0x25d/0x900 [cifs]
       [<c0167e70>] notify_change+0x130/0x2d0
       [<c0154e0e>] do_truncate+0x53/0x6c
       [<c015d79c>] may_open+0x1ba/0x202
       [<c015f706>] open_namei+0x27f/0x5af
       [<c0154b73>] do_filp_open+0x26/0x3b
       [<c0154bcb>] do_sys_open+0x43/0xc2
       [<c0154c82>] sys_open+0x1c/0x1e
       [<c01026a6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by cp/3480:
 #0:  (&inode->i_mutex){--..}, at: [<c02f7f16>] mutex_lock+0x1c/0x1f
 #1:  (&inode->i_alloc_sem){--..}, at: [<c0167e28>] notify_change+0xe8/0x2d0

stack backtrace:
 [<c0103c43>] show_trace_log_lvl+0x1a/0x2f
 [<c01042bc>] show_trace+0x12/0x14
 [<c0104359>] dump_stack+0x16/0x18
 [<c012a801>] print_circular_bug_tail+0x5f/0x68
 [<c012bfc9>] __lock_acquire+0x8c2/0xb85
 [<c012c2f4>] lock_acquire+0x68/0x82
 [<c029a76b>] lock_sock_nested+0xba/0xc7
 [<c02c5d45>] tcp_sendmsg+0x16/0x9cc
 [<c02dd824>] inet_sendmsg+0x3e/0x49
 [<c0298b9b>] sock_sendmsg+0xe7/0x104
 [<c0299dde>] kernel_sendmsg+0x28/0x37
 [<dec97eba>] smb_send+0x92/0x11c [cifs]
 [<dec980c3>] SendReceive+0x17f/0x3dc [cifs]
 [<dec87817>] CIFSSMBSetEOF+0x1e6/0x229 [cifs]
 [<dec934dd>] cifs_setattr+0x25d/0x900 [cifs]
 [<c0167e70>] notify_change+0x130/0x2d0
 [<c0154e0e>] do_truncate+0x53/0x6c
 [<c015d79c>] may_open+0x1ba/0x202
 [<c015f706>] open_namei+0x27f/0x5af
 [<c0154b73>] do_filp_open+0x26/0x3b
 [<c0154bcb>] do_sys_open+0x43/0xc2
 [<c0154c82>] sys_open+0x1c/0x1e
 [<c01026a6>] sysenter_past_esp+0x5f/0x99
 =======================
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.

> How can this be fixed?
> Afterwards nut (ups tool) is slightly upset.

requiring reboot to fix. (restart of nut is no solution!)



Udo
