Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbYHUS6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbYHUS6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYHUS6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:58:31 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:34073 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753156AbYHUS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:58:30 -0400
Date: Thu, 21 Aug 2008 22:58:28 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] genirq: fix irq_desc->depth handling with DEBUG_SHIRQ
Message-ID: <20080821185828.GA14070@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG_SHIRQ is selected, a spurious IRQ is issued before
the setup_irq() initializes the desc->depth. An IRQ handler may
call disable_irq_nosync(), but then setup_irq() will overwrite
desc->depth, and upon enable_irq() we'll catch this WARN:

------------[ cut here ]------------
Badness at kernel/irq/manage.c:180
NIP: c0061ab8 LR: c0061f10 CTR: 00000000
REGS: cf83be50 TRAP: 0700   Not tainted  (2.6.27-rc3-23450-g74919b0)
MSR: 00021032 <ME,IR,DR>  CR: 22042022  XER: 20000000
TASK = cf829100[5] 'events/0' THREAD: cf83a000
GPR00: c0061f10 cf83bf00 cf829100 c038e674 00000016 00000000 cf83bef8 00000038
GPR08: c0298910 00000000 c0310d28 cf83a000 00000c9c 1001a1a8 0fffe000 00800000
GPR16: ffffffff 00000000 007fff00 00000000 007ffeb0 c03320a0 c031095c c0310924
GPR24: cf8292ec cf807190 cf83a000 00009032 c038e6a4 c038e674 cf99b1cc c038e674
NIP [c0061ab8] __enable_irq+0x20/0x80
LR [c0061f10] enable_irq+0x50/0x70
Call Trace:
[cf83bf00] [c038e674] irq_desc+0x630/0x9000 (unreliable)
[cf83bf10] [c0061f10] enable_irq+0x50/0x70
[cf83bf30] [c01abe94] phy_change+0x68/0x108
[cf83bf50] [c0046394] run_workqueue+0xc4/0x16c
[cf83bf90] [c0046834] worker_thread+0x74/0xd4
[cf83bfd0] [c004ab7c] kthread+0x48/0x84
[cf83bff0] [c00135e0] kernel_thread+0x44/0x60
Instruction dump:
4e800020 3d20c031 38a94214 4bffffcc 9421fff0 7c0802a6 93e1000c 7c7f1b78
90010014 8123001c 2f890000 409e001c <0fe00000> 80010014 83e1000c 38210010

That trace corresponds to this line:
WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);

The patch fixes the problem by moving the SHIRQ code below the
setup_irq().

Unfortunately we can't easily move the SHIRQ code inside the
setup_irq(), since it grabs a spinlock, so to prvent a 'real'
IRQ from interfere us we should disable that IRQ.

p.s. The driver in question is drivers/net/phy/phy.c.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 kernel/irq/manage.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0314074..ba03259 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -629,26 +629,29 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	action->next = NULL;
 	action->dev_id = dev_id;
 
+	retval = setup_irq(irq, action);
+	if (retval)
+		kfree(action);
+
 #ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
 		 * to happen immediately, so let's make sure....
-		 * We do this before actually registering it, to make sure that
-		 * a 'real' IRQ doesn't run in parallel with our fake
+		 * We disable the irq to make sure that a 'real' IRQ doesn't
+		 * run in parallel with our fake.
 		 */
 		unsigned long flags;
 
+		disable_irq(irq);
 		local_irq_save(flags);
+
 		handler(irq, dev_id);
+
 		local_irq_restore(flags);
+		enable_irq(irq);
 	}
 #endif
-
-	retval = setup_irq(irq, action);
-	if (retval)
-		kfree(action);
-
 	return retval;
 }
 EXPORT_SYMBOL(request_irq);
-- 
1.5.6.3
