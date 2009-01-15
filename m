Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZAOFvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZAOFvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZAOFv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:51:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758AbZAOFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:51:24 -0500
Date: Wed, 14 Jan 2009 21:51:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jody McIntyre <scjody@sun.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1: BUG: unable to handle kernel paging request at
 000077fed87bb6bf
Message-Id: <20090114215120.b0ad7c4b.akpm@linux-foundation.org>
In-Reply-To: <20090113214743.GE28831@clouds>
References: <20090113214743.GE28831@clouds>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 16:47:44 -0500 Jody McIntyre <scjody@sun.com> wrote:

> This bug occurs in 2.6.29-rc1 as well as the latest linux-2.6 git tree.
> I've tried bisecting but there are at least 3 unrelated oopses on my
> system since 2.6.28 that prevented me from isolating the problem.

Oh great.  This often happens because people commit buggy patches to
their git trees, fix the bug a week later with a spearate commit, then
the whole lot gets shipped into mainline verbatib, with known bisection
holes.  The consensus appears to be that this is acceptable.

> [   23.339994] BUG: unable to handle kernel paging request at 000077fed87bb6bf
> [   23.340983] IP: [<ffffffff8024e021>] wq_per_cpu+0x1e/0x24
> [   23.340983] PGD 0
> [   23.340983] Oops: 0000 [#1] SMP
> [   23.340983] last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/0000:01:00.0/0000:02:00.0/0000:03:00.0/0000:04:01.0/host1/target1:0:5/1:0:5:0/rev
> [   23.340983] CPU 0
> [   23.340983] Modules linked in: sg sd_mod crc_t10dif mptspi mptscsih mptbase scsi_transport_spi qla2xxx scsi_transport_fc floppy scsi_mod button parport_pc serio_raw parport rtc_cmos rtc_core rtc_lib i2c_i801 i2c_core ehci_hcd uhci_hcd pcspkr shpchp e1000e nfs lockd nfs_acl auth_rpcgss sunrpc
> [   23.340983] Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #1
> [   23.340983] RIP: 0010:[<ffffffff8024e021>]  [<ffffffff8024e021>] wq_per_cpu+0x1e/0x24
> [   23.340983] RSP: 0018:ffffffff808bbe78  EFLAGS: 00010246
> [   23.340983] RAX: 000077fed87bb6bf RBX: ffff88013dd32810 RCX: ffff88013dd32830
> [   23.340983] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880128d7ff80
> [   23.340983] RBP: ffffffff808bbe78 R08: 0000000000000010 R09: ffffffff808bbf20
> [   23.340983] R10: 0000000000000000 R11: ffffffff808bbf50 R12: 0000000000000100
> [   23.340983] R13: ffffffff8024e99a R14: ffffffff808bbec8 R15: ffffffff808ff398
> [   23.340983] FS:  0000000000000000(0000) GS:ffffffff808c4080(0000) knlGS:0000000000000000
> [   23.340983] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   23.340983] CR2: 000077fed87bb6bf CR3: 0000000000201000 CR4: 00000000000006e0
> [   23.340983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   23.340983] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   23.340983] Process swapper (pid: 0, threadinfo ffffffff80842000, task ffffffff8066a360)
> [   23.340983] Stack:
> [   23.340983]  ffffffff808bbe98 ffffffff8024e9c3 ffffffff80242ba0 ffffffff808fd780
> [   23.340983]  ffffffff808bbf08 ffffffff80247862 ffffffff808b6d80 ffffffff808fef98
> [   23.340983]  ffffffff808feb98 ffffffff808fe798 ffffffff808bbec8 ffffffff808bbec8
> [   23.340983] Call Trace:
> [   23.340983]  <IRQ> <0> [<ffffffff8024e9c3>] delayed_work_timer_fn+0x29/0x38
> [   23.340983]  [<ffffffff80242ba0>] ? set_normalized_timespec+0x9/0x38
> [   23.340983]  [<ffffffff80247862>] run_timer_softirq+0x15c/0x1cb
> [   23.340983]  [<ffffffff8024374e>] __do_softirq+0x86/0x145
> [   23.340983]  [<ffffffff8020d3bc>] call_softirq+0x1c/0x28
> [   23.340983]  [<ffffffff8020e3a1>] do_softirq+0x39/0x7b
> [   23.340983]  [<ffffffff802436c6>] irq_exit+0x44/0x46
> [   23.340983]  [<ffffffff805350c0>] smp_apic_timer_interrupt+0x99/0xb2
> [   23.340983]  [<ffffffff8020cdf3>] apic_timer_interrupt+0x13/0x20
> [   23.340983]  <EOI> <0>Code: d0 48 3b 48 40 c9 0f 94 c0 0f b6 c0 c3 55 48 89 e5 e8 f4 de fb ff 83 7f 20 00 74 06 8b 35 e8 fd 5e 00 48 8b 07 48 63 d6 48 f7 d0 <48> 8b 04 d0 c9 c3 55 48 89 e5 41 54 53 48 83 ec 10 e8 c9 de fb
> [   23.340983] RIP  [<ffffffff8024e021>] wq_per_cpu+0x1e/0x24
> [   23.340983]  RSP <ffffffff808bbe78>
> [   23.340983] CR2: 000077fed87bb6bf
> [   23.614640] ---[ end trace 59b682ce1b8e5668 ]---
> [   23.619417] Kernel panic - not syncing: Fatal exception in interrupt
> 
> .config is at
> http://downloads.lustre.org/people/scjody/lkml/config_2009-01-13
> 
> Bisect log is at
> http://downloads.lustre.org/people/scjody/lkml/bisect_2009-01-13-2
> 
> I marked anything that got further than 'Starting udev:' (where the
> above problem happened) as "good" but I'm now left with changes to ARM,
> regulator, and documentation, so something's wrong with my approach.
> 
> Suggestions?

It needs to be bisected :(

At a guess I'd say that some piece of code somewhere did
schedule_delayed_work(work) and then scribbled on *work before the
timer got to run.  It could be anywhere at all in your kernel.

Thomas's debugobjects code could perhaps be used to find the culprit,
but alas the workqueue code hasn't been taught to use that framework.

We could do something like this:

--- a/kernel/workqueue.c~a
+++ a/kernel/workqueue.c
@@ -196,9 +196,14 @@ EXPORT_SYMBOL_GPL(queue_work_on);
 
 static void delayed_work_timer_fn(unsigned long __data)
 {
-	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-	struct workqueue_struct *wq = cwq->wq;
+	struct delayed_work *dwork;
+	struct cpu_workqueue_struct *cwq;
+	struct workqueue_struct *wq;
+
+	dwork = (struct delayed_work *)__data;
+	printk("delayed_work_timer_fn: handling %p\n", dwork);
+	cwq = get_wq_data(&dwork->work);
+	wq = cwq->wq;
 
 	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
 }
@@ -214,6 +219,8 @@ static void delayed_work_timer_fn(unsign
 int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
+	printk("queue_delayed_work: queueing %p\n", dwork);
+	dump_stack();
 	if (delay == 0)
 		return queue_work(wq, &dwork->work);
 
_

It will print an object address and a call trace in
queue_delayed_work() and will print an object address in
delayed_work_timer_fn().

Hopefully when it oopses you'll see the bad object address which was
obtained by delayed_work_timer_fn().  Then, you can go back through the
trace and determine which callsite passed that object address to
queue_delayed_work().  Then we will have our culprit.

It'll possibly generate a lot of output, so logged netconsole might be
needed.

