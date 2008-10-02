Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYJBIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYJBIvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYJBIvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:51:45 -0400
Received: from www.tglx.de ([62.245.132.106]:47537 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYJBIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:51:44 -0400
Date: Thu, 2 Oct 2008 10:50:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prakash Punnoor <prakash@punnoor.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc-7: BUG: scheduling while atomic:
 swapper/0/0x00000102
In-Reply-To: <200809281946.03346.prakash@punnoor.de>
Message-ID: <alpine.LFD.1.10.0810020958550.5549@apollo.tec.linutronix.de>
References: <200809281946.03346.prakash@punnoor.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008, Prakash Punnoor wrote:
> Hi,
> 
> I got this today:
> 
> Sep 28 14:36:15 graviton BUG: scheduling while atomic: swapper/0/0x00000102
> Sep 28 14:36:15 graviton Modules linked in:
> Sep 28 14:36:15 graviton CPU 0:
> Sep 28 14:36:15 graviton Modules linked in:
> Sep 28 14:36:15 graviton Pid: 0, comm: swapper Not tainted 2.6.27-rc7 #1
> Sep 28 14:36:15 graviton RIP: 0010:[<ffffffff8022ccba>]  [<ffffffff8022ccba>] 
> default_idle+0x3a/0x40
> Sep 28 14:36:15 graviton RSP: 0018:ffffffff807f9f70  EFLAGS: 00000246
> Sep 28 14:36:15 graviton RAX: ffffffff807f9fd8 RBX: ffffffff8082f3e0 RCX: 
> 0000000000000000
> Sep 28 14:36:15 graviton RDX: ffffffff8084eb20 RSI: 0000000000000092 RDI: 
> ffffffff8088a120
> Sep 28 14:36:15 graviton RBP: ffffffff80852700 R08: 0000000000000000 R09: 
> 0000000100294985
> Sep 28 14:36:15 graviton R10: 00000000ffffffff R11: ffffffff80237d80 R12: 
> ffffffff8025eeb7
> Sep 28 14:36:15 graviton R13: 000002bbd7672100 R14: ffffffff802749bd R15: 
> 0000000000000092
> Sep 28 14:36:15 graviton FS:  00007ffe25b04760(0000) GS:ffffffff807f1280(0000) 
> knlGS:0000000000000000
> Sep 28 14:36:15 graviton CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> Sep 28 14:36:15 graviton CR2: 0000000000000000 CR3: 00000000728b9000 CR4: 
> 00000000000006e0
> Sep 28 14:36:15 graviton DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
> 0000000000000000
> Sep 28 14:36:15 graviton DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
> 0000000000000400
> Sep 28 14:36:15 graviton
> Sep 28 14:36:15 graviton Call Trace:
> Sep 28 14:36:15 graviton [<ffffffff8022cd58>] ? c1e_idle+0x98/0xe0
> Sep 28 14:36:15 graviton [<ffffffff80222b9e>] ? cpu_idle+0x5e/0xf0
> Sep 28 14:36:15 graviton
> 
> 
> I guess I can work-around this when disabling c1e in BIOS, but didn't try that 
> so far. Any idea. Following the complete dmesg and attached the config

Won't help. :(

BUG: scheduling while atomic: swapper/0/0x00000102

0x00000102 is the preemption count. That means:

preemption count = 2 and softirq count = 1

So either the stacktrace is lying or something left the preemption
count in a buggy state. There is nothing in the log which helps to
decode this.

Can you please apply the debug patch below and try to reproduce ?

Thanks,

	tglx
---
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c506f26..0fc32b6 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -205,7 +205,18 @@ restart:
 
 	do {
 		if (pending & 1) {
+			int prev_count = preempt_count();
+
 			h->action(h);
+
+			if (prev_count != preempt_count()) {
+				printk(KERN_ERR "huh, entered sotfirq %ld %p"
+				       "with preempt_count %08x,"
+				       " exited with %08x?\n", h - softirq_vec,
+				       h->action, prev_count, preempt_count());
+				preempt_count() = prev_count;
+			}
+
 			rcu_bh_qsctr_inc(cpu);
 		}
 		h++;
