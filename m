Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbXCZJY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbXCZJY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXCZJY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:24:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXCZJY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:24:26 -0400
Date: Mon, 26 Mar 2007 10:31:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc5
Message-ID: <20070326083146.GA11666@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> There's various fixes here, ranging from some architecture updates 
> (ia64, ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.

here's a new v2.6.20 -> v2.6.21 forcedeth.c regression:

in the last week or so i've been seeing sporadic under-load forcedeth.c 
crashes (see the full oops further below):

 eth1: too many iterations (6) in nv_nic_irq.
 Unable to handle kernel NULL pointer dereference at 0000000000000088 RIP: 
 [<ffffffff80404587>] nv_tx_done+0xf4/0x1cf

this is line 1906 of drivers/net/forcedeth.c:

    np->stats.tx_bytes += np->get_tx_ctx->skb->len;

struct sk_buff's len field is at offset 88, so np->get_tx_ctx->skb is 
NULL. That is an 'impossible' scenario for tx descriptors here - the tx 
ring descriptors are always set up with a valid skb (and a valid dma 
address), and their completion is serialized via np->lock.

these crashes are almost instant on the .21-rc5-rt kernel, but extremely 
sporadic on the upstream kernel and needed very high networking loads to 
trigger. Today i found a good way to trigger it almost instantly on 
upstream kernels too: apply the debug patch attached further below and 
do:

	echo 100 > /proc/sys/kernel/panic

that will inject 100 artificial 'too many iterations' failures and 
provokes a TX timeout - which TX timeout will crash. (i've used a 
dual-core Athlon64 system in this test)

my first quick guess was to extend np->priv locking to the whole of 
nv_start_xmit/nv_start_xmit_optimized - while that appeared to make the 
crash a bit less likely, it did not prevent it. So there must be some 
other, more fundamental problem be left as well. At first glance the SMP 
locking looks OK, so maybe the ring indices are messed up somehow and we 
got into a 'ring head bites the tail' scenario?

i can provide more info if needed.

	Ingo

-------------->
eth1: too many iterations (6) in nv_nic_irq.
Unable to handle kernel NULL pointer dereference at 0000000000000088 RIP: 
 [<ffffffff80404587>] nv_tx_done+0xf4/0x1cf
PGD 34d03067 PUD 34d02067 PMD 0 
Oops: 0000 [1] PREEMPT SMP 
CPU 1 
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.21-rc5 #8
RIP: 0010:[<ffffffff80404587>]  [<ffffffff80404587>] nv_tx_done+0xf4/0x1cf
RSP: 0018:ffff81003ff6be40  EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff810002e26700 RCX: 0000000000000001
RDX: 0000000000000042 RSI: 000000003ef00cbe RDI: ffff81003fbeb070
RBP: ffff81003ff6be60 R08: ffff810002e26a00 R09: 0000000000000003
R10: ffff81003ff4e100 R11: ffff810001e283f8 R12: 000000003ef00cbe
R13: ffff810002e26000 R14: ffff810002e28fc0 R15: 0000000000000000
FS:  00002b6cb57f1db0(0000) GS:ffff81003ff4ad40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000088 CR3: 0000000034c87000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff81003ff64000, task ffff81003ff4e100)
Stack:  ffff810002e26700 0000000000000032 ffffc2000001a000 ffff810002e26000
 ffff81003ff6bea0 ffffffff80406dae ffff810002e26700 ffff810002e26700
 ffff810002e26000 00000000000000ff ffffc2000001a000 ffffffff80749080
Call Trace:
 <IRQ>  [<ffffffff80406dae>] nv_nic_irq+0x76/0x261
 [<ffffffff8040961e>] nv_do_nic_poll+0x200/0x284
 [<ffffffff8040941e>] nv_do_nic_poll+0x0/0x284
 [<ffffffff80241995>] run_timer_softirq+0x167/0x1dd
 [<ffffffff8023de45>] __do_softirq+0x5b/0xc9
 [<ffffffff8020af0c>] call_softirq+0x1c/0x28
 [<ffffffff8020c2b4>] do_softirq+0x31/0x84
 [<ffffffff8023db16>] irq_exit+0x3f/0x50
 [<ffffffff802190c2>] smp_apic_timer_interrupt+0x49/0x5b
 [<ffffffff802087fb>] default_idle+0x0/0x44
 [<ffffffff8020a9b6>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020882a>] default_idle+0x2f/0x44
 [<ffffffff8020804c>] enter_idle+0x22/0x24
 [<ffffffff802088d0>] cpu_idle+0x91/0xd4
 [<ffffffff80218572>] start_secondary+0x2e3/0x2f5

---
 drivers/net/forcedeth.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux/drivers/net/forcedeth.c
===================================================================
--- linux.orig/drivers/net/forcedeth.c
+++ linux/drivers/net/forcedeth.c
@@ -2908,6 +2908,10 @@ static irqreturn_t nv_nic_irq(int foo, v
 			spin_unlock(&np->lock);
 			break;
 		}
+		if (panic_timeout > 0) {
+			panic_timeout--;
+			i = max_interrupt_work+1;
+		}
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
@@ -3026,6 +3030,10 @@ static irqreturn_t nv_nic_irq_optimized(
 			break;
 		}
 
+		if (panic_timeout > 0) {
+			panic_timeout--;
+			i = max_interrupt_work+1;
+		}
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
@@ -3076,6 +3084,10 @@ static irqreturn_t nv_nic_irq_tx(int foo
 			dprintk(KERN_DEBUG "%s: received irq with events 0x%x. Probably TX fail.\n",
 						dev->name, events);
 		}
+		if (panic_timeout > 0) {
+			panic_timeout--;
+			i = max_interrupt_work+1;
+		}
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
@@ -3191,6 +3203,10 @@ static irqreturn_t nv_nic_irq_rx(int foo
 			}
 		}
 
+		if (panic_timeout > 0) {
+			panic_timeout--;
+			i = max_interrupt_work+1;
+		}
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
@@ -3264,6 +3280,10 @@ static irqreturn_t nv_nic_irq_other(int 
 			printk(KERN_DEBUG "%s: received irq with unknown events 0x%x. Please report\n",
 						dev->name, events);
 		}
+		if (panic_timeout > 0) {
+			panic_timeout--;
+			i = max_interrupt_work+1;
+		}
 		if (unlikely(i > max_interrupt_work)) {
 			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
