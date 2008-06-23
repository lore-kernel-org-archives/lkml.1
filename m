Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYFWKhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYFWKhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYFWKh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:37:29 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54869 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754250AbYFWKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:37:28 -0400
Date: Mon, 23 Jun 2008 16:07:00 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>, laijs@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix rcu vs hotplug race
Message-ID: <20080623103700.GA4043@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On running kernel compiles in parallel with cpu hotplug,

------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:118
native_smp_send_reschedule+0x21/0x36()
Modules linked in:
Pid: 27483, comm: cc1 Not tainted 2.6.26-rc7 #1
 [<c01217d9>] warn_on_slowpath+0x41/0x5d
 [<c01515b7>] ? generic_file_aio_read+0x10f/0x137
 [<c0151340>] ? file_read_actor+0x0/0xf7
 [<c013ae4c>] ? validate_chain+0xaa/0x29c
 [<c013c854>] ? __lock_acquire+0x612/0x666
 [<c013c854>] ? __lock_acquire+0x612/0x666
 [<c013ae4c>] ? validate_chain+0xaa/0x29c
 [<c01715d3>] ? file_kill+0x2d/0x30
 [<c013cbd7>] ? __lock_release+0x4b/0x51
 [<c01715d3>] ? file_kill+0x2d/0x30
 [<c0110355>] native_smp_send_reschedule+0x21/0x36
 [<c014fe8f>] force_quiescent_state+0x47/0x57
 [<c014fef0>] call_rcu+0x51/0x6d
 [<c01713b3>] __fput+0x130/0x158
 [<c0171231>] fput+0x17/0x19
 [<c016fd99>] filp_close+0x4d/0x57
 [<c016fdff>] sys_close+0x5c/0x97
 [<c0103861>] sysenter_past_esp+0x6a/0xb1
 =======================
---[ end trace aa35f3913ddf2d06 ]---

This is because a reschedule is sent to a CPU which is offline.
Just ensure that the CPU we send the smp_send_reschedule is actually
online.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 kernel/rcuclassic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc7/kernel/rcuclassic.c
===================================================================
--- linux-2.6.26-rc7.orig/kernel/rcuclassic.c
+++ linux-2.6.26-rc7/kernel/rcuclassic.c
@@ -93,7 +93,8 @@ static void force_quiescent_state(struct
 		cpumask = rcp->cpumask;
 		cpu_clear(rdp->cpu, cpumask);
 		for_each_cpu_mask(cpu, cpumask)
-			smp_send_reschedule(cpu);
+			if (cpu_online(cpu))
+				smp_send_reschedule(cpu);
 	}
 }
 #else
-- 
regards,
Dhaval
