Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXFURzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXFURzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXFURzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:55:12 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4179 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXFURzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:55:10 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 13:55:10 EDT
Message-ID: <467AB953.9080106@xs4all.nl>
Date: Thu, 21 Jun 2007 19:45:55 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Folkert van Heusden <folkert@vanheusden.com>
Subject: 2.6.21.4: possible circular locking dependency detected 
X-Enigmail-Version: 0.95.1
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While copying a small file over to a windows box via cifs, once again I
got something like this:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.21.4 #8
-------------------------------------------------------
cp/3088 is trying to acquire lock:
 (sk_lock-AF_INET){--..}, at: [<c02c5c99>] tcp_sendmsg+0x16/0x9cc

but task is already holding lock:
 (&inode->i_alloc_sem){--..}, at: [<c0167e08>] notify_change+0xe8/0x2d0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&inode->i_alloc_sem){--..}:
       [<c012c0c8>] __lock_acquire+0x9e1/0xb85
       [<c012c2d4>] lock_acquire+0x68/0x82
       [<c0126503>] down_write+0x3a/0x53
       [<c0167e08>] notify_change+0xe8/0x2d0
       [<c0154dee>] do_truncate+0x53/0x6c
       [<c015d77c>] may_open+0x1ba/0x202
       [<c015f6e6>] open_namei+0x27f/0x5af
       [<c0154b53>] do_filp_open+0x26/0x3b
       [<c0154bab>] do_sys_open+0x43/0xc2
       [<c0154c62>] sys_open+0x1c/0x1e
       [<c01026a6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #2 (&sysfs_inode_imutex_key){--..}:
       [<c012c0c8>] __lock_acquire+0x9e1/0xb85
       [<c012c2d4>] lock_acquire+0x68/0x82
       [<c02f7c0a>] __mutex_lock_slowpath+0xdc/0x266
       [<c02f7db0>] mutex_lock+0x1c/0x1f
       [<c018c41d>] create_dir+0x20/0x196
       [<c018c5dd>] sysfs_create_dir+0x4a/0x64
       [<c01d2bd9>] kobject_shadow_add+0xd6/0x189
       [<c01d2c96>] kobject_add+0xa/0xc
       [<c0223ee5>] device_add+0xae/0x62b
       [<c02aaed3>] netdev_register_sysfs+0x5a/0x5f
       [<c02a102a>] register_netdevice+0x22c/0x2e4
       [<c02a2175>] register_netdev+0x40/0x4d
       [<c022c124>] rhine_init_one+0x492/0x64f
       [<c01e1ffd>] pci_device_probe+0x39/0x5b
       [<c0225e0b>] really_probe+0xbd/0x145
       [<c0225f28>] driver_probe_device+0x95/0xa1
       [<c022603d>] __driver_attach+0x6a/0xa1
       [<c0225401>] bus_for_each_dev+0x36/0x5b
       [<c0225c7f>] driver_attach+0x19/0x1b
       [<c02256e8>] bus_add_driver+0x6a/0x170
       [<c022624f>] driver_register+0x79/0x7e
       [<c01e2184>] __pci_register_driver+0x7b/0xa8
       [<c040a0de>] rhine_init+0x5d/0x5f
       [<c03f271c>] init+0x95/0x17a
       [<c01038e7>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (rtnl_mutex){--..}:
       [<c012c0c8>] __lock_acquire+0x9e1/0xb85
       [<c012c2d4>] lock_acquire+0x68/0x82
       [<c02f7c0a>] __mutex_lock_slowpath+0xdc/0x266
       [<c02f7db0>] mutex_lock+0x1c/0x1f
       [<c02a8913>] rtnl_lock+0xd/0xf
       [<c02e0e9d>] ip_mc_join_group+0x2c/0xc9
       [<c02c2573>] ip_setsockopt+0x64b/0x9a7
       [<c02d7d10>] udp_setsockopt+0x43/0x4a
       [<c029a01e>] sock_common_setsockopt+0x1e/0x24
       [<c02986e7>] sys_setsockopt+0x7b/0x97
       [<c0299d39>] sys_socketcall+0x1e8/0x241
       [<c01026a6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #0 (sk_lock-AF_INET){--..}:
       [<c012bfa9>] __lock_acquire+0x8c2/0xb85
       [<c012c2d4>] lock_acquire+0x68/0x82
       [<c029a747>] lock_sock_nested+0xba/0xc7
       [<c02c5c99>] tcp_sendmsg+0x16/0x9cc
       [<c02dd764>] inet_sendmsg+0x3e/0x49
       [<c0298b77>] sock_sendmsg+0xe7/0x104
       [<c0299dba>] kernel_sendmsg+0x28/0x37
       [<ded22eba>] smb_send+0x92/0x11c [cifs]
       [<ded230c3>] SendReceive+0x17f/0x3dc [cifs]
       [<ded12817>] CIFSSMBSetEOF+0x1e6/0x229 [cifs]
       [<ded1e4dd>] cifs_setattr+0x25d/0x900 [cifs]
       [<c0167e50>] notify_change+0x130/0x2d0
       [<c0154dee>] do_truncate+0x53/0x6c
       [<c015d77c>] may_open+0x1ba/0x202
       [<c015f6e6>] open_namei+0x27f/0x5af
       [<c0154b53>] do_filp_open+0x26/0x3b
       [<c0154bab>] do_sys_open+0x43/0xc2
       [<c0154c62>] sys_open+0x1c/0x1e
       [<c01026a6>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by cp/3088:
 #0:  (&inode->i_mutex){--..}, at: [<c02f7db0>] mutex_lock+0x1c/0x1f
 #1:  (&inode->i_alloc_sem){--..}, at: [<c0167e08>] notify_change+0xe8/0x2d0

stack backtrace:
 [<c0103c43>] show_trace_log_lvl+0x1a/0x2f
 [<c01042bc>] show_trace+0x12/0x14
 [<c0104359>] dump_stack+0x16/0x18
 [<c012a7e1>] print_circular_bug_tail+0x5f/0x68
 [<c012bfa9>] __lock_acquire+0x8c2/0xb85
 [<c012c2d4>] lock_acquire+0x68/0x82
 [<c029a747>] lock_sock_nested+0xba/0xc7
 [<c02c5c99>] tcp_sendmsg+0x16/0x9cc
 [<c02dd764>] inet_sendmsg+0x3e/0x49
 [<c0298b77>] sock_sendmsg+0xe7/0x104
 [<c0299dba>] kernel_sendmsg+0x28/0x37
 [<ded22eba>] smb_send+0x92/0x11c [cifs]
 [<ded230c3>] SendReceive+0x17f/0x3dc [cifs]
 [<ded12817>] CIFSSMBSetEOF+0x1e6/0x229 [cifs]
 [<ded1e4dd>] cifs_setattr+0x25d/0x900 [cifs]
 [<c0167e50>] notify_change+0x130/0x2d0
 [<c0154dee>] do_truncate+0x53/0x6c
 [<c015d77c>] may_open+0x1ba/0x202
 [<c015f6e6>] open_namei+0x27f/0x5af
 [<c0154b53>] do_filp_open+0x26/0x3b
 [<c0154bab>] do_sys_open+0x43/0xc2
 [<c0154c62>] sys_open+0x1c/0x1e
 [<c01026a6>] sysenter_past_esp+0x5f/0x99
 =======================
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
Clocksource tsc unstable (delta = 18746609409 ns)
Time: acpi_pm clocksource has been installed.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
pwc: Too many ISOC errors, bailing out.
 CIFS VFS: No response for cmd 50 mid 5023


How can this be fixed?
Afterwards nut (ups tool) is slightly upset.

Kind regards,
Udo
