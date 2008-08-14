Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbYHNNxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbYHNNxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYHNNxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:53:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36951 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbYHNNxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:53:34 -0400
Date: Thu, 14 Aug 2008 15:53:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] irq: sparse irqs, fix IRQ auto-probe crash
Message-ID: <20080814135308.GA15909@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com> <20080814132638.GA18743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814132638.GA18743@elte.hu>
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


find below a crash fix discovered by tip/master testing.

Robustness of sparse IRQs is looking pretty good otherwise at first 
glance.

	Ingo

------------------>
>From a4a5ec7bbaaaab5fcb86bd348b98bfbed7c6a3b7 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Aug 2008 15:48:50 +0200
Subject: [PATCH] irq: sparse irqs, fix IRQ auto-probe crash

fix:

[   10.631533] calling  yenta_socket_init+0x0/0x20
[   10.631533] Yenta: CardBus bridge found at 0000:15:00.0 [17aa:2012]
[   10.631533] Yenta: Using INTVAL to route CSC interrupts to PCI
[   10.631533] Yenta: Routing CardBus interrupts to PCI
[   10.631533] Yenta TI: socket 0000:15:00.0, mfunc 0x01d01002, devctl 0x64
[   10.731599] BUG: unable to handle kernel NULL pointer dereference at 00000040
[   10.731838] IP: [<c0c95b5f>] _spin_lock_irq+0xf/0x20
[   10.732221] *pde = 00000000
[   10.732741] Oops: 0002 [#1] SMP
[   10.733453]
[   10.734253] Pid: 1, comm: swapper Tainted: G        W (2.6.27-rc3-tip-00173-gd7eaa4f-dirty #1)
[   10.735188] EIP: 0060:[<c0c95b5f>] EFLAGS: 00010002 CPU: 0
[   10.735523] EIP is at _spin_lock_irq+0xf/0x20
[   10.735523] EAX: 00000040 EBX: 00000000 ECX: f6e04c90 EDX: 00000100
[   10.735523] ESI: 000000df EDI: f6e04c90 EBP: f7867df0 ESP: f7867df0
[   10.735523]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   10.735523] Process swapper (pid: 1, ti=f7867000 task=f7870000 task.ti=f7867000)
[   10.735523] Stack: f7867e04 c0155fbd 00000000 00000000 f6e04c90 f7867e5c c0c6e319 c0f6a074
[   10.735523]        f6e04c90 000017aa 00002012 c112b648 f791f240 c112b5e0 f7867e44 c010440b
[   10.735523]        f791f240 f791f29c c112b8ec f791f240 00000000 f7867e5c c048f893 03c0b648
[   10.735523] Call Trace:
[   10.735523]  [<c0155fbd>] ? probe_irq_on+0x3d/0x140
[   10.735523]  [<c0c6e319>] ? yenta_probe+0x529/0x640
[   10.735523]  [<c010440b>] ? mcount_call+0x5/0xa
[   10.735523]  [<c048f893>] ? pci_match_device+0xa3/0xb0
[   10.735523]  [<c048fc1e>] ? pci_device_probe+0x5e/0x80
[   10.735523]  [<c0515423>] ? driver_probe_device+0x83/0x180
[   10.735523]  [<c0515594>] ? __driver_attach+0x74/0x80
[   10.735523]  [<c0514b69>] ? bus_for_each_dev+0x49/0x70
[   10.735523]  [<c051528e>] ? driver_attach+0x1e/0x20
[   10.735523]  [<c0515520>] ? __driver_attach+0x0/0x80
[   10.735523]  [<c05150d3>] ? bus_add_driver+0x1a3/0x220
[   10.735523]  [<c048fb60>] ? pci_device_remove+0x0/0x40
[   10.735523]  [<c05157f4>] ? driver_register+0x54/0x130
[   10.735523]  [<c048fe2f>] ? __pci_register_driver+0x4f/0x90
[   10.735523]  [<c11e9419>] ? yenta_socket_init+0x19/0x20
[   10.735523]  [<c0101125>] ? do_one_initcall+0x35/0x160
[   10.735523]  [<c11e9400>] ? yenta_socket_init+0x0/0x20
[   10.735523]  [<c01391a6>] ? __queue_work+0x36/0x50
[   10.735523]  [<c013922d>] ? queue_work_on+0x3d/0x50
[   10.735523]  [<c11a2758>] ? kernel_init+0x148/0x210
[   10.735523]  [<c11a2610>] ? kernel_init+0x0/0x210
[   10.735523]  [<c01043f3>] ? kernel_thread_helper+0x7/0x10
[   10.735523]  =======================
[   10.735523] Code: 10 38 f2 74 06 f3 90 8a 10 eb f6 5d 89 c8 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 e8 a4 e8 46 ff fa ba 00 01 00 00 90 <66> 0f c1 10 38 f2 74 06 f3 90 8a 10 eb f6 5d c3 90 55 89 e5 53

as auto-probing wants to iterate over existing irqs.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/autoprobe.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 24e1a39..6b00382 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -40,6 +40,8 @@ unsigned long probe_irq_on(void)
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
 		desc = irq_desc(i);
+		if (!desc)
+			continue;
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -70,6 +72,8 @@ unsigned long probe_irq_on(void)
 	 */
 	for (i = nr_irqs-1; i > 0; i--) {
 		desc = irq_desc(i);
+		if (!desc)
+			continue;
 
 		spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
@@ -93,6 +97,8 @@ unsigned long probe_irq_on(void)
 		unsigned int status;
 
 		desc = irq_desc(i);
+		if (!desc)
+			continue;
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -134,6 +140,8 @@ unsigned int probe_irq_mask(unsigned long val)
 		struct irq_desc *desc = irq_desc(i);
 		unsigned int status;
 
+		if (!desc)
+			continue;
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
@@ -177,6 +185,8 @@ int probe_irq_off(unsigned long val)
 		struct irq_desc *desc = irq_desc(i);
 		unsigned int status;
 
+		if (!desc)
+			continue;
 		spin_lock_irq(&desc->lock);
 		status = desc->status;
 
