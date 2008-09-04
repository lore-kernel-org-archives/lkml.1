Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYIDPEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYIDPEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYIDPER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:04:17 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36538 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbYIDPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:04:15 -0400
Subject: panic on boot with kernel/sysctl.c changes in 2.6.27-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 10:04:11 -0500
Message-Id: <1220540651.3276.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:

commit ae7edecc9b8810770a8e5cb9a466ea4bdcfa8401
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Jul 15 06:33:31 2008 -0400

    [PATCH] sysctl: keep track of tree relationships

Is causing a panic on boot with parisc.  The panic occurs when we try to
bring up the secondary CPUs via hotplug, so I think it's a general panic
that would be seen on any architecture.

This is what the boot shows:

Searching for devices...
Found devices:
1. Storm Peak Slow at 0xfffffffffe780000 [128] { 0, 0x0, 0x887, 0x00004 }
2. Storm Peak Slow at 0xfffffffffe781000 [129] { 0, 0x0, 0x887, 0x00004 }
3. Storm Peak Slow at 0xfffffffffe798000 [152] { 0, 0x0, 0x887, 0x00004 }
4. Storm Peak Slow at 0xfffffffffe799000 [153] { 0, 0x0, 0x887, 0x00004 }
5. Everest Mako Memory at 0xfffffffffed08000 [8] { 1, 0x0, 0x0af, 0x00009 }
6. Pluto BC McKinley Port at 0xfffffffffed00000 [0] { 12, 0x0, 0x880, 0x0000c }
7. Mercury PCI Bridge at 0xfffffffffed20000 [0/0] { 13, 0x0, 0x783, 0x0000a }
8. Mercury PCI Bridge at 0xfffffffffed22000 [0/1] { 13, 0x0, 0x783, 0x0000a }
9. Mercury PCI Bridge at 0xfffffffffed24000 [0/2] { 13, 0x0, 0x783, 0x0000a }
10. Mercury PCI Bridge at 0xfffffffffed26000 [0/3] { 13, 0x0, 0x783, 0x0000a }
11. Mercury PCI Bridge at 0xfffffffffed28000 [0/4] { 13, 0x0, 0x783, 0x0000a }
12. Mercury PCI Bridge at 0xfffffffffed2c000 [0/6] { 13, 0x0, 0x783, 0x0000a }
13. Mercury PCI Bridge at 0xfffffffffed2e000 [0/7] { 13, 0x0, 0x783, 0x0000a }
14. BMC IPMI Mgmt Ctlr at 0xfffffff0f05b0000 [16] { 15, 0x0, 0x004, 0x000c0 }
Releasing cpu 1 now, hpa=fffffffffe781000
FP[1] enabled: Rev 1 Model 20
------------[ cut here ]------------
Badness at kernel/sysctl.c:1929

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001000001111100001111 Not tainted
r00-03  0000000008041f0f 00000000405956e0 000000004015c4bc 000000007f410d58
r04-07  0000000040589ee0 000000004048d1e4 00000000404b0040 0000000000000001
r08-11  0000000000000002 0000000040467868 0000000000000000 0000000000000000
r12-15  00000000405c25d0 0000000000000001 0000000000000000 0000000000000000
r16-19  00000000405c2f00 00000000404e58c0 00000000405c2f00 00000000404c8758
r20-23  0000000000000005 000000007f469df0 0000000000000022 fffffffffffffff3
r24-27  0000000000000000 0000000000000022 00000000404c8788 0000000040589ee0
r28-31  0000000000000000 000000007f469e50 000000007f469e80 000000007f410d60
sr00-03  0000000000000000 0000000000000000 0000000000000000 0000000000000000
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 000000004015c538 000000004015c53c
 IIR: 03ffe01f    ISR: 0000000010240000  IOR: 00000001320c87a4
 CPU:        0   CR30: 000000007f468000 CR31: fffffff0f0e098e0
 ORIG_R28: 00000000404d1340
 IAOQ[0]: unregister_sysctl_table+0xb0/0x138
 IAOQ[1]: unregister_sysctl_table+0xb4/0x138
 RP(r2): unregister_sysctl_table+0x34/0x138
Backtrace:
 [<0000000040116384>] mutex_lock+0x14/0x20
 [<0000000040148930>] partition_sched_domains+0x88/0x3e8
 [<00000000401469fc>] wake_up_process+0x24/0x38
 [<0000000040122324>] print_one_device+0xbc/0x160
 [<00000000402e3d04>] next_device+0x14/0x30
 [<00000000402e3e10>] device_for_each_child+0x90/0xb8
 [<0000000040121dfc>] for_each_padev+0x34/0x48
 [<000000004012005c>] pdc_pat_cell_module+0xf4/0x178
 [<00000000401524d0>] printk+0x40/0x50
 [<0000000040175e64>] update_wall_time+0x26c/0x560
 [<000000004018bdd4>] __rcu_process_callbacks+0x19c/0x258
 [<000000004014313c>] enqueue_task_fair+0x5c/0x88
 [<000000004014313c>] enqueue_task_fair+0x5c/0x88
 [<0000000040141324>] __dequeue_entity+0x4c/0xb0
 [<00000000401c08dc>] cache_alloc_debugcheck_after+0x23c/0x2f0
 [<0000000040115f58>] __mutex_unlock_slowpath+0x70/0x168

------------[ cut here ]------------
kernel BUG at mm/slab.c:590!

     YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
PSW: 00001000000001001111110000001110 Tainted: G        W
r00-03  000000ff0804fc0e 0000000040591ee0 00000000401c0f24 000000007f410d58
r04-07  0000000040589ee0 000000004048d1e4 00000000404c8788 000000004015c548
r08-11  000000000800000f 0000000040467868 0000000000000000 0000000000000000
r12-15  00000000405c25d0 0000000000000001 0000000000000000 0000000000000000
r16-19  00000000405c2f00 00000000404e58c0 00000000405c2f00 00000000408e3000
r20-23  00000000004c8788 00000000000004c8 0000000000000022 fffffffffffffff3
r24-27  0000000000000000 00000000404c8788 00000000408f3bc0 0000000040589ee0
r28-31  0000000000000400 000000007f469ef0 000000007f469f20 0000000000000400
sr00-03  0000000000000000 0000000000000000 0000000000000000 0000000000000000
sr04-07  0000000000000000 0000000000000000 0000000000000000 0000000000000000

IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000401c1120 00000000401c1124
 IIR: 03ffe01f    ISR: 0000000000000000  IOR: 0000000000000000
 CPU:        0   CR30: 000000007f468000 CR31: fffffff0f0e098e0
 ORIG_R28: 000000007f46a0c0
 IAOQ[0]: kfree+0x238/0x258
 IAOQ[1]: kfree+0x23c/0x258
 RP(r2): kfree+0x3c/0x258
Backtrace:
 [<000000004015c548>] unregister_sysctl_table+0xc0/0x138
 [<0000000040116384>] mutex_lock+0x14/0x20
 [<0000000040148930>] partition_sched_domains+0x88/0x3e8
 [<00000000401469fc>] wake_up_process+0x24/0x38
 [<0000000040122324>] print_one_device+0xbc/0x160
 [<00000000402e3d04>] next_device+0x14/0x30
 [<00000000402e3e10>] device_for_each_child+0x90/0xb8
 [<0000000040121dfc>] for_each_padev+0x34/0x48
 [<000000004012005c>] pdc_pat_cell_module+0xf4/0x178
 [<00000000401524d0>] printk+0x40/0x50
 [<0000000040175e64>] update_wall_time+0x26c/0x560
 [<000000004018bdd4>] __rcu_process_callbacks+0x19c/0x258
 [<000000004014313c>] enqueue_task_fair+0x5c/0x88
 [<000000004014313c>] enqueue_task_fair+0x5c/0x88
 [<0000000040141324>] __dequeue_entity+0x4c/0xb0
 [<00000000401c08dc>] cache_alloc_debugcheck_after+0x23c/0x2f0

Backtrace:
 [<000000004011b6ec>] parisc_show_stack+0x9c/0xe8
 [<000000004011b74c>] show_stack+0x14/0x20
 [<000000004013fbc8>] update_curr+0x60/0xa0
 [<00000000402651bc>] report_bug+0xf4/0x150
 [<000000004015c548>] unregister_sysctl_table+0xc0/0x138
 [<00000000401c1120>] kfree+0x238/0x258
 [<00000000401c0f24>] kfree+0x3c/0x258
 [<000000004015c548>] unregister_sysctl_table+0xc0/0x138
 [<0000000040116384>] mutex_lock+0x14/0x20
 [<0000000040148930>] partition_sched_domains+0x88/0x3e8
 [<00000000401469fc>] wake_up_process+0x24/0x38
 [<0000000040122324>] print_one_device+0xbc/0x160
 [<00000000402e3d04>] next_device+0x14/0x30
 [<00000000402e3e10>] device_for_each_child+0x90/0xb8
 [<0000000040121dfc>] for_each_padev+0x34/0x48
 [<000000004012005c>] pdc_pat_cell_module+0xf4/0x178

Kernel panic - not syncing: Attempted to kill init!

The first is the WARN_ON(1) here in kernel/sysctl.c:

	if (!--header->parent->count) {
		WARN_ON(1);
		kfree(header->parent);
	}

And the BUG is because this code is trying to kfree sd_ctl_root (as the
parent) which is in static memory.

I've no idea what this code is trying to accomplish, but, since in
practice a lot of sysfs roots are in static memory, it's clearly bogus.
Even if we'd put sd_ctl_root in kmalloc'd memory, we don't want it
freed. The hotplug is merely trying to release all its current children
before adding new ones (which naturally takes the parent refcount to
zero). I suggest dumping this whole if clause.

James

---

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index fe47133..cbf0ebf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1925,10 +1925,8 @@ void unregister_sysctl_table(struct ctl_table_header * header)
 
 	spin_lock(&sysctl_lock);
 	start_unregistering(header);
-	if (!--header->parent->count) {
-		WARN_ON(1);
-		kfree(header->parent);
-	}
+	--header->parent->count;
+
 	if (!--header->count)
 		kfree(header);
 	spin_unlock(&sysctl_lock);


