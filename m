Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYDNGyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYDNGyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 02:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYDNGyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 02:54:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbYDNGyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:54:12 -0400
Message-ID: <4802FF10.6030905@cn.fujitsu.com>
Date: Mon, 14 Apr 2008 14:52:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] memcg: fix oops in oom handling
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I used a test program to fork mass processes and immediately
move them to a cgroup where the memory limit is low enough to
trigger oom kill, I got oops:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000808
IP: [<ffffffff8045c47f>] _spin_lock_irqsave+0x8/0x18
PGD 4c95f067 PUD 4406c067 PMD 0
Oops: 0002 [1] SMP
CPU 2
Modules linked in:

Pid: 11973, comm: a.out Not tainted 2.6.25-rc7 #5
RIP: 0010:[<ffffffff8045c47f>]  [<ffffffff8045c47f>] _spin_lock_irqsave+0x8/0x18
RSP: 0018:ffff8100448c7c30  EFLAGS: 00010002
RAX: 0000000000000202 RBX: 0000000000000009 RCX: 000000000001c9f3
RDX: 0000000000000100 RSI: 0000000000000001 RDI: 0000000000000808
RBP: ffff81007e444080 R08: 0000000000000000 R09: ffff8100448c7900
R10: ffff81000105f480 R11: 00000100ffffffff R12: ffff810067c84140
R13: 0000000000000001 R14: ffff8100441d0018 R15: ffff81007da56200
FS:  00007f70eb1856f0(0000) GS:ffff81007fbad3c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000808 CR3: 000000004498a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process a.out (pid: 11973, threadinfo ffff8100448c6000, task ffff81007da533e0)
Stack:  ffffffff8023ef5a 00000000000000d0 ffffffff80548dc0 00000000000000d0
 ffff810067c84140 ffff81007e444080 ffffffff8026cef9 00000000000000d0
 ffff8100441d0000 00000000000000d0 ffff8100441d0000 ffff8100505445c0
Call Trace:
 [<ffffffff8023ef5a>] ? force_sig_info+0x25/0xb9
 [<ffffffff8026cef9>] ? oom_kill_task+0x77/0xe2
 [<ffffffff8026d696>] ? mem_cgroup_out_of_memory+0x55/0x67
 [<ffffffff802910ad>] ? mem_cgroup_charge_common+0xec/0x202
 [<ffffffff8027997b>] ? handle_mm_fault+0x24e/0x77f
 [<ffffffff8022c4af>] ? default_wake_function+0x0/0xe
 [<ffffffff8027a17a>] ? get_user_pages+0x2ce/0x3af
 [<ffffffff80290fee>] ? mem_cgroup_charge_common+0x2d/0x202
 [<ffffffff8027a441>] ? make_pages_present+0x8e/0xa4
 [<ffffffff8027d1ab>] ? mmap_region+0x373/0x429
 [<ffffffff8027d7eb>] ? do_mmap_pgoff+0x2ff/0x364
 [<ffffffff80210471>] ? sys_mmap+0xe5/0x111
 [<ffffffff8020bfc9>] ? tracesys+0xdc/0xe1

Code: 00 00 01 48 8b 3c 24 e9 46 d4 dd ff f0 ff 07 48 8b 3c 24 e9 3a d4 dd ff fe 07 48 8b 3c 24 e9 2f d4 dd ff 9c 58 fa ba 00 01 00 00 <f0> 66 0f c1 17 38 f2 74 06 f3 90 8a 17 eb f6 c3 fa b8 00 01 00
RIP  [<ffffffff8045c47f>] _spin_lock_irqsave+0x8/0x18
 RSP <ffff8100448c7c30>
CR2: 0000000000000808
---[ end trace c3702fa668021ea4 ]---

It's reproducable in a x86_64 box, but doesn't happen in x86_32.

This is because tsk->sighand is not guarded by RCU, so we have to
hold tasklist_lock, just as what out_of_memory() does.

Signed-off-by: Li Zefan <lizf@cn.fujitsu>
---
 mm/oom_kill.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f255eda..beb592f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -423,7 +423,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 	struct task_struct *p;
 
 	cgroup_lock();
-	rcu_read_lock();
+	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, mem);
 	if (PTR_ERR(p) == -1UL)
@@ -436,7 +436,7 @@ retry:
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
-	rcu_read_unlock();
+	read_unlock(&tasklist_lock);
 	cgroup_unlock();
 }
 #endif
-- 1.5.4.rc3 



