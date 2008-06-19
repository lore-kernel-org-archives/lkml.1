Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbYFSMgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbYFSMgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758361AbYFSMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:33535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbYFSMfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:32 -0400
Message-Id: <20080619123313.778852888@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/10] sched: NULL pointer dereference while setting sched_rt_period_us
Content-Disposition: inline; filename=sched-rt-group-proc-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When CONFIG_RT_GROUP_SCHED and ÔªøCONFIG_CGROUP_SCHED are enabled, with:

 echo 10000 > /proc/sys/kernel/sched_rt_period_us

We get this:

 BUG: unable to handle kernel NULL pointer dereference at 0000008c
 [  947.682233] IP: [<c0216b72>] __rt_schedulable+0x12/0x160
 [  947.683123] *pde = 00000000=20
 [  947.683782] Oops: 0000 [#1] 
 [  947.684307] Modules linked in:
 [  947.684308] 
 [  947.684308] Pid: 2359, comm: bash Not tainted (2.6.26-rc6 #8)
 [  947.684308] EIP: 0060:[<c0216b72>] EFLAGS: 00000246 CPU: 0
 [  947.684308] EIP is at __rt_schedulable+0x12/0x160
 [  947.684308] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
 [  947.684308] ESI: c0521db4 EDI: 00000001 EBP: c6cc9f00 ESP: c6cc9ed0
 [  947.684308]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
 [  947.684308] Process bash (pid: 2359, ti∆cc8000 task«a54f00=20 task.ti∆cc8000)
 [  947.684308] Stack: c0222790 00000000 080f8c08 c0521db4 c6cc9f00 00000001 00000000 00000000 
 [  947.684308]        c6cc9f9c 00000000 c0521db4 00000001 c6cc9f28 c0216d40 00000000 00000000 
 [  947.684308]        c6cc9f9c 000f4240 000e7ef0 ffffffff c0521db4 c79dfb60 c6cc9f58 c02af2cc 
 [  947.684308] Call Trace:
 [  947.684308]  [<c0222790>] ? do_proc_dointvec_conv+0x0/0x50
 [  947.684308]  [<c0216d40>] ? sched_rt_handler+0x80/0x110
 [  947.684308]  [<c02af2cc>] ? proc_sys_call_handler+0x9c/0xb0
 [  947.684308]  [<c02af2fa>] ? proc_sys_write+0x1a/0x20
 [  947.684308]  [<c0273c36>] ? vfs_write+0x96/0x160
 [  947.684308]  [<c02af2e0>] ? proc_sys_write+0x0/0x20
 [  947.684308]  [<c027423d>] ? sys_write+0x3d/0x70
 [  947.684308]  [<c0202ef5>] ? sysenter_past_esp+0x6a/0x91
 [  947.684308]  =======================
 [  947.684308] Code: 24 04 e8 62 b1 0e 00 89 c7 89 f8 8b 5d f4 8b 75
 f8 8b 7d fc 89 ec 5d c3 90 55 89 e5 57 56 53 83 ec 24 89 45 ec 89 55 e4
 89 4d e8 <8b> b8 8c 00 00 00 85 ff 0f 84 c9 00 00 00 8b 57 24 39 55 e8
 8b 
 [  947.684308] EIP: [<c0216b72>] __rt_schedulable+0x12/0x160 SS:ESP  0068:c6cc9ed0

We think the following patch solves the issue.

Hope this is of some help.

Regards,
Dario Faggioli

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8348,7 +8348,7 @@ static unsigned long to_ratio(u64 period
 #ifdef CONFIG_CGROUP_SCHED
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
-	struct task_group *tgi, *parent = tg->parent;
+	struct task_group *tgi, *parent = tg ? tg->parent : NULL;
 	unsigned long total = 0;
 
 	if (!parent) {

-- 

