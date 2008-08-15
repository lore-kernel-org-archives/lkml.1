Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbYHOJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbYHOJgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYHOJgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:36:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYHOJgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:36:03 -0400
Date: Fri, 15 Aug 2008 11:35:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/07] dyn_array/nr_irqs/sparse_irq support v10 - fix
Message-ID: <20080815093546.GA9312@elte.hu>
References: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com> <20080815082735.GC4776@elte.hu> <86802c440808150134x5bf005fmdcb0f557422af365@mail.gmail.com> <20080815085120.GA18748@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815085120.GA18748@elte.hu>
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


btw., one new thing i got in testing due to irq/sparseirq is this new 
lockdep splat:

[    0.000000] Initializing CPU#0
[    0.000000] found new irq_desc for irq 0
[    0.000000] INFO: trying to register non-static key.
[    0.000000] the code is fine but needs lockdep annotation.
[    0.000000] turning off the locking correctness validator.
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc3-tip-00191-g98ccb89-dirty #1
[    0.000000]  [<c0153c22>] register_lock_class+0x3d2/0x400
[    0.000000]  [<c0104d87>] ? mcount_call+0x5/0xa
[    0.000000]  [<c0154f3a>] __lock_acquire+0x22a/0x5d0
[    0.000000]  [<c0104d87>] ? mcount_call+0x5/0xa
[    0.000000]  [<c0155351>] lock_acquire+0x71/0xa0
[    0.000000]  [<c016d61f>] ? set_irq_chip+0x3f/0x90
[    0.000000]  [<c070f148>] _spin_lock_irqsave+0x58/0x90
[    0.000000]  [<c016d61f>] ? set_irq_chip+0x3f/0x90
[    0.000000]  [<c016d61f>] set_irq_chip+0x3f/0x90
[    0.000000]  [<c016d7e0>] ? handle_level_irq+0x0/0xe0
[    0.000000]  [<c016da1a>] set_irq_chip_and_handler_name+0x1a/0x40
[    0.000000]  [<c0a396c1>] init_ISA_irqs+0x51/0xa0
[    0.000000]  [<c0a4a365>] pre_intr_init_hook+0x25/0x30
[    0.000000]  [<c0a39723>] native_init_IRQ+0x13/0x370
[    0.000000]  [<c015569c>] ? lock_release+0xcc/0x1d0
[    0.000000]  [<c0104d87>] ? mcount_call+0x5/0xa
[    0.000000]  [<c070dc22>] ? __mutex_unlock_slowpath+0x92/0x110
[    0.000000]  [<c070dcad>] ? mutex_unlock+0xd/0x10
[    0.000000]  [<c0135f62>] ? cpu_maps_update_done+0x12/0x20
[    0.000000]  [<c06c6743>] ? register_cpu_notifier+0x23/0x30
[    0.000000]  [<c011e8ae>] init_IRQ+0xe/0x10
[    0.000000]  [<c0a357a5>] start_kernel+0x1c5/0x340
[    0.000000]  [<c0a35280>] ? unknown_bootoption+0x0/0x210
[    0.000000]  [<c0a3506b>] i386_start_kernel+0x6b/0x80
[    0.000000]  =======================
[    0.000000] found new irq_desc for irq 1
[    0.000000] found new irq_desc for irq 2
[    0.000000] found new irq_desc for irq 3

this:

 static void init_one_irq_desc(struct irq_desc *desc)
 {
         memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 #ifdef CONFIG_TRACE_IRQFLAGS
         lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 #endif
 }

looks wrong - it should be unconditional (i've done that via the patch 
below). I dont remember why we made early_init_irq_lock_class() 
dependent on CONFIG_TRACE_IRQFLAGS before. Peter, do you have any 
memories?

	Ingo

--------------------------->
>From bba3b43f2383c2fd06c4befee45ef30d5cf59d32 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 15 Aug 2008 11:34:35 +0200
Subject: [PATCH] sparseirq: fix lockdep

-tip testing found this lockdep splat:

[    0.000000] Initializing CPU#0
[    0.000000] found new irq_desc for irq 0
[    0.000000] INFO: trying to register non-static key.
[    0.000000] the code is fine but needs lockdep annotation.
[    0.000000] turning off the locking correctness validator.
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.27-rc3-tip-00191-g98ccb89-dirty #1
[    0.000000]  [<c0153c22>] register_lock_class+0x3d2/0x400
[    0.000000]  [<c0104d87>] ? mcount_call+0x5/0xa
[    0.000000]  [<c0154f3a>] __lock_acquire+0x22a/0x5d0
[    0.000000]  [<c0104d87>] ? mcount_call+0x5/0xa
[    0.000000]  [<c0155351>] lock_acquire+0x71/0xa0
[    0.000000]  [<c016d61f>] ? set_irq_chip+0x3f/0x90
[    0.000000]  [<c070f148>] _spin_lock_irqsave+0x58/0x90
[    0.000000]  [<c016d61f>] ? set_irq_chip+0x3f/0x90
[    0.000000]  [<c016d61f>] set_irq_chip+0x3f/0x90
[    0.000000]  [<c016d7e0>] ? handle_level_irq+0x0/0xe0
[    0.000000]  [<c016da1a>] set_irq_chip_and_handler_name+0x1a/0x40
[    0.000000]  [<c0a396c1>] init_ISA_irqs+0x51/0xa0
[    0.000000]  [<c0a4a365>] pre_intr_init_hook+0x25/0x30
[    0.000000]  [<c0a39723>] native_init_IRQ+0x13/0x370
[    0.000000]  [<c015569c>] ? lock_release+0xcc/0x1d0
[    0.000000]  [<c0104d87>] ? mcount_call+0x5/0xa
[    0.000000]  [<c070dc22>] ? __mutex_unlock_slowpath+0x92/0x110
[    0.000000]  [<c070dcad>] ? mutex_unlock+0xd/0x10
[    0.000000]  [<c0135f62>] ? cpu_maps_update_done+0x12/0x20
[    0.000000]  [<c06c6743>] ? register_cpu_notifier+0x23/0x30
[    0.000000]  [<c011e8ae>] init_IRQ+0xe/0x10
[    0.000000]  [<c0a357a5>] start_kernel+0x1c5/0x340
[    0.000000]  [<c0a35280>] ? unknown_bootoption+0x0/0x210
[    0.000000]  [<c0a3506b>] i386_start_kernel+0x6b/0x80
[    0.000000]  =======================
[    0.000000] found new irq_desc for irq 1
[    0.000000] found new irq_desc for irq 2
[    0.000000] found new irq_desc for irq 3

this:

 static void init_one_irq_desc(struct irq_desc *desc)
 {
         memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 #ifdef CONFIG_TRACE_IRQFLAGS
         lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 #endif
 }

should be unconditional.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/handle.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index ce8774b..8cd0c68 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -75,9 +75,7 @@ static struct irq_desc irq_desc_init = {
 static void init_one_irq_desc(struct irq_desc *desc)
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
-#ifdef CONFIG_TRACE_IRQFLAGS
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-#endif
 }
 
 extern int after_bootmem;
