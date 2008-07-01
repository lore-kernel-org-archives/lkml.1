Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYGAGQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYGAGQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYGAGQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:16:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33284 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYGAGQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:16:42 -0400
Date: Tue, 1 Jul 2008 08:16:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080701061600.GF14658@elte.hu>
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu> <20080626152728.GA24972@linux.vnet.ibm.com> <20080627044738.GC3419@in.ibm.com> <20080627051855.GD26167@in.ibm.com> <20080627054959.GB3309@linux.vnet.ibm.com> <20080627145845.GA9229@linux.vnet.ibm.com> <20080701053900.GB8205@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701053900.GB8205@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> So, it's the design of stop_machine() that's preventing someone from 
> updating the cpu_online_map while force_quiescent_state() is 
> performing the cpu_is_online() check. Becase we always call 
> force_quiescent_state() with irqs disabled :)

Paul, do you concur? I'll apply the commit in the form below to 
tip/core/urgent if Paul agrees.

	Ingo

----------------------------------->
Subject: cpu-hotplug + rcu: fix spurious warning
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date: Mon, 23 Jun 2008 16:07:00 +0530

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

It's the design of stop_machine() that's preventing someone from
updating the cpu_online_map while force_quiescent_state() is
performing the cpu_is_online() check. Becase we always call
force_quiescent_state() with irqs disabled :)

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: paulmck@linux.vnet.ibm.com
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/rcuclassic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: tip/kernel/rcuclassic.c
===================================================================
--- tip.orig/kernel/rcuclassic.c
+++ tip/kernel/rcuclassic.c
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
