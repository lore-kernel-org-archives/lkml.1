Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbZK2NXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbZK2NXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 08:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZK2NXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 08:23:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:35418 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751301AbZK2NXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 08:23:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192EmkuyK52Wge52fsi0IJjxsQNu7vPBpMCAr+T7v
	uJzbWcND476lsZ
Subject: [patch]  f83f9ac causes tasks running at MAX_PRIO
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Williams <pwil3058@bigpond.net.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 29 Nov 2009 14:23:47 +0100
Message-Id: <1259501027.6268.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


top - 11:33:19 up 1 min, 21 users,  load average: 4.47, 1.44, 0.51
Tasks: 288 total,   1 running, 287 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.2%us,  0.5%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
  568 root      20   0     0    0    0 S    1  0.0   0:00.02 3 scsi_eh_1
 4724 root      40   0  358m  22m 4008 S    1  0.7   0:01.69 0 Xorg
 6064 root      40   0  8872 1316  852 R    1  0.0   0:00.07 3 top
    1 root      40   0  1064  388  324 S    0  0.0   0:01.30 2 init
    2 root      40   0     0    0    0 S    0  0.0   0:00.00 1 kthreadd
    3 root      RT   0     0    0    0 S    0  0.0   0:00.00 0 migration/0

WARN_ON(current->normal_prio == MAX_PRIO);

[    0.092016] ------------[ cut here ]------------
[    0.096008] WARNING: at kernel/sched.c:2591 sched_fork+0xe4/0x1ae()
[    0.100002] Hardware name: MS-7502
[    0.104002] Modules linked in:
[    0.108191] Pid: 0, comm: swapper Not tainted 2.6.32-tip-smpx #956
[    0.112002] Call Trace:
[    0.116004]  [<ffffffff810365ab>] ? sched_fork+0xe4/0x1ae
[    0.120004]  [<ffffffff81038eb8>] warn_slowpath_common+0x77/0xa4
[    0.124004]  [<ffffffff81038ef4>] warn_slowpath_null+0xf/0x11
[    0.128003]  [<ffffffff810365ab>] sched_fork+0xe4/0x1ae
[    0.132005]  [<ffffffff81059a9f>] ? monotonic_to_bootbased+0x26/0x34
[    0.136004]  [<ffffffff8103783b>] copy_process+0x4b9/0x10e4
[    0.140006]  [<ffffffff810bd38b>] ? __get_vm_area_node+0x175/0x1bf
[    0.144004]  [<ffffffff810385b2>] do_fork+0x14c/0x304
[    0.148005]  [<ffffffff810200dd>] ? __ioremap_caller+0x292/0x2fb
[    0.152005]  [<ffffffff812838b0>] ? acpi_os_map_memory+0x12/0x1b
[    0.156006]  [<ffffffff810038d2>] kernel_thread+0x82/0xe0
[    0.160006]  [<ffffffff8146c510>] ? kernel_init+0x0/0x1af
[    0.164004]  [<ffffffff81003930>] ? child_rip+0x0/0x20
[    0.168004]  [<ffffffff81281a48>] ? rest_init+0x1c/0x76
[    0.172003]  [<ffffffff8146cc54>] start_kernel+0x351/0x35c
[    0.176004]  [<ffffffff8146c29a>] x86_64_start_reservations+0xaa/0xae
[    0.180004]  [<ffffffff8146c37f>] x86_64_start_kernel+0xe1/0xe8
[    0.184007] ---[ end trace 4eaa2a86a8e2da22 ]---

sched: fix task priority bug.

f83f9ac removed a call to effective_prio() in wake_up_new_task(), which
leads to tasks running at MAX_PRIO.  That call set both the child's prio
and normal_prio fields to normal_prio(child).  Do the same fork time by
setting both to normal_prio(parent).

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Williams <pwil3058@bigpond.net.au>
LKML-Reference: <new-submission>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2609,7 +2609,7 @@ void sched_fork(struct task_struct *p, i
 	/*
 	 * Make sure we do not leak PI boosting priority to the child.
 	 */
-	p->prio = current->normal_prio;
+	p->prio = p->normal_prio = normal_prio(current);
 
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;


