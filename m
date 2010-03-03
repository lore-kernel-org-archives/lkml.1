Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0CCEAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 23:00:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:33746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0CCEAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 23:00:09 -0500
Message-ID: <4B8DE160.5070506@kernel.org>
Date: Wed, 03 Mar 2010 13:11:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Ed L. Cashin" <ecashin@coraid.com>, lkml <linux-kernel@vger.kernel.org>
CC: taeuber@bbaw.de
Subject: aoeblk_make_request() chokes on zero-length barriers
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 03 Mar 2010 04:00:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ed L. Cashin.

This is reported on openSUSE 11.2 by Lars Tauber on bnc581271[1] but
upstream code seems to have the same problem.  If a bio doesn't have
bi_io_vec, aoeblk_make_request() triggers BUG() but in recent kernels
the block layer will happily send down zero-length barrier bios w/o
bi_io_vec set.  These zero-length barriers are used to broadcast
flushes to RAID members and should be translated into FLUSH[_EXT].

[10285.958008] ------------[ cut here ]------------
[10285.958030] kernel BUG at /usr/src/packages/BUILD/kernel-xen-2.6.31.12/linux-2.6.31/drivers/block/aoe/aoeblk.c:177!
[10285.958064] invalid opcode: 0000 [#1] SMP 
[10285.958083] last sysfs file: /sys/devices/virtual/block/dm-0/range
[10285.958095] CPU 2 
[10285.958104] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_physdev iptable_filter ip_tables x_tables nls_utf8 netbk blkbk blkback_pagemap blktap xenbus_be nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp llc fuse loop dm_mod aoe tg3 bnx2 i2c_piix4 sg pcspkr shpchp container i2c_core pci_hotplug button mptctl raid456 raid6_pq async_xor async_memcpy async_tx xor raid0 ohci_hcd ehci_hcd xenblk cdrom xennet edd raid1 fan processor mptsas mptscsih mptbase scsi_transport_sas thermal thermal_sys hwmon
[10285.958279] Pid: 3888, comm: kdmflush Not tainted 2.6.31.12-0.1-xen #1 PRIMERGY BX630 S2               
[10285.958296] RIP: e030:[<ffffffffa01ea976>]  [<ffffffffa01ea976>] aoeblk_make_request+0x256/0x280 [aoe]
[10285.958330] RSP: e02b:ffff8807a3949ad0  EFLAGS: 00010246
[10285.958341] RAX: 000000000000002c RBX: ffff8807a395df00 RCX: 000000000003ffff
[10285.958353] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff80801490
[10285.958366] RBP: ffff8807a3949b20 R08: 0000000000000033 R09: 0000000000010643
[10285.958378] R10: 0000000000000005 R11: 0000000000000000 R12: ffff8807a4b0c600
[10285.958390] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000009800810
[10285.958414] FS:  00007fbfb5ca4790(0000) GS:ffffc90000020000(0000) knlGS:0000000000000000
[10285.958429] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[10285.958440] CR2: 00007fff8852f0a0 CR3: 00000007de18a000 CR4: 0000000000000660
[10285.958455] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[10285.958468] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[10285.958481] Process kdmflush (pid: 3888, threadinfo ffff8807a3948000, task ffff8806c11cc440)
[10285.958495] Stack:
[10285.958501]  ffff8806c11cc440 ffff8807a395df00 0000000000000000 0000000000000000
[10285.958519] <0> 0000000000000000 000000007e5388d1 ffff8807a395df00 ffff8807da980e58
[10285.958539] <0> 0000000000000000 0000000000000000 ffff8807a3949be0 ffffffff802223bb
[10285.958562] Call Trace:
[10285.958605]  [<ffffffff802223bb>] generic_make_request+0x19b/0x4c0
[10285.958646]  [<ffffffffa01fa215>] __map_bio+0xd5/0x160 [dm_mod]
[10285.958687]  [<ffffffffa01fa34b>] __clone_and_map_empty_barrier+0xab/0xf0 [dm_mod]
[10285.958725]  [<ffffffffa01fa6af>] __clone_and_map+0x31f/0x330 [dm_mod]
[10285.958761]  [<ffffffffa01fbdb7>] __split_and_process_bio+0x117/0x1a0 [dm_mod]
[10285.958801]  [<ffffffffa01fbe9f>] dm_flush+0x5f/0x90 [dm_mod]
[10285.958838]  [<ffffffffa01fbf08>] process_barrier+0x38/0x150 [dm_mod]
[10285.958876]  [<ffffffffa01fc07b>] dm_wq_work+0x5b/0x170 [dm_mod]
[10285.958909]  [<ffffffff80069303>] run_workqueue+0x83/0x230
[10285.958930]  [<ffffffff80069564>] worker_thread+0xb4/0x140
[10285.958947]  [<ffffffff8006f9d6>] kthread+0xb6/0xc0
[10285.958967]  [<ffffffff8000d38a>] child_rip+0xa/0x20
[10285.958981] Code: e8 1e a0 31 c0 e8 0c 13 28 e0 48 8b 7d b8 be f4 ff ff ff
e8 8d 1f f6 df e9 5e ff ff ff 48 c7 c7 b0 e5 1e a0 31 c0 e8 eb 12 28 e0 <0f> 0b
eb fe 48 c7 c7 a8 e8 1e a0 31 c0 e8 d9 12 28 e0 0f 0b eb 
[10285.959107] RIP  [<ffffffffa01ea976>] aoeblk_make_request+0x256/0x280 [aoe]
[10285.959128]  RSP <ffff8807a3949ad0>
[10285.960116] ---[ end trace be65f4e90431af85 ]---

Thanks.

-- 
tejun

[1] https://bugzilla.novell.com/show_bug.cgi?id=581271
