Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0CLANf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:13:35 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33786 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0CLANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:13:33 -0500
Subject: vfs-scalability: odd null pointer issue in link_path_walk
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Clark Williams <williams@redhat.com>,
       John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 16:13:25 -0800
Message-ID: <1268352805.3475.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Nick,
	So yesterday I came across an odd null pointer oops in link_path_walk:

BUG: unable to handle kernel NULL pointer dereference at
0000000000000030
IP: [<ffffffff81103d42>] link_path_walk+0xd12/0xda0
PGD 42b12e067 PUD 42cb2a067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/block/md0/dev
CPU 7 
Pid: 2993, comm: vgs Not tainted 2.6.33-rc8john #272 Server Blade/IBM eServer BladeCenter HS21 -[7995AC1]-
RIP: 0010:[<ffffffff81103d42>]  [<ffffffff81103d42>] link_path_walk+0xd12/0xda0
RSP: 0018:ffff88042a929b78  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88042ab41000 RCX: ffff88042ab41028
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88042aa0fcc0
RBP: ffff88042a929c28 R08: ffff88042aa0fcc0 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88042c6a40b0
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88042a929dc8
FS:  00007f6f8c481710(0000) GS:ffff8800283c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000030 CR3: 000000042b310000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vgs (pid: 2993, threadinfo ffff88042a928000, task ffff88042ab41000)
Stack:
 ffff88042ab41000 ffff88042ab41000 ffff88042ab41000 ffff88042ab41000
<0> 0000000100000000 ffff88042a929de8 ffff880400000000 0000000000000000
<0> ffff88042f6b5610 0000000000000000 0000000000000000 ffff88042f418920
Call Trace:
 [<ffffffff811006c2>] ? path_get+0x32/0x50
 [<ffffffff81103c50>] link_path_walk+0xc20/0xda0
 [<ffffffff811006c2>] ? path_get+0x32/0x50
 [<ffffffff81103f7c>] path_walk+0x5c/0xd0
 [<ffffffff811041de>] do_path_lookup+0x1ee/0x250
 [<ffffffff81103ff0>] ? do_path_lookup+0x0/0x250
 [<ffffffff81104ebb>] user_path_at+0x7b/0xb0
 [<ffffffff81112bb1>] ? vfsmount_read_unlock+0x31/0x60
 [<ffffffff81114788>] ? mntput_no_expire+0x48/0x190
 [<ffffffff810fb293>] ? cp_new_stat+0xe3/0xf0
 [<ffffffff810fb4ac>] vfs_fstatat+0x3c/0x80
 [<ffffffff810fb616>] vfs_stat+0x16/0x20
 [<ffffffff810fb63f>] sys_newstat+0x1f/0x50
 [<ffffffff81994a33>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff810025eb>] system_call_fastpath+0x16/0x1b
Code: ec e8 93 c8 ff ff 0f 1f 00 e9 46 ff ff ff 41 83 7f 34 04 66 0f 1f 44 00 00 0f 85 38 ff ff ff 4d 8b 67 08 49 8b 84 24 b8 00 00 00 <48> 8b 40 30 f6 40 09 40 0f 84 1e ff ff ff 49 8b 44 24 70 4c 89 
RIP  [<ffffffff81103d42>] link_path_walk+0xd12/0xda0
 RSP <ffff88042a929b78>
CR2: 0000000000000030
---[ end trace 0dd94d94b1b27094 ]---


I'd never seen it before in all my test runs, but it was triggering 100%
of the time, and it seems to be somehow connected to me adding an xfs
partition to the box (even if it wasn't mounted and more oddly, even
after i reformatted that partition as ext3).

Anyway, I bisected the change down to your fs-scale-pseudo patch and
reverting it does keep the issue from happening.

Not sure if you can think of a quick fix here, but I'm thinking I might
revert this patch from my version of your patchset for now.

thanks
-john

