Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbXJUHym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbXJUHym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbXJUHwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:33 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58774 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXJUHwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:32 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 8/17] arch/x86/kernel/vm86_32.c: irq handler cleanup
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075230.DC55E19041B@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:30 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit f57c82aa01f4387c8400acb43afa7fc580635e16
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:25:42 2007 -0400

    arch/x86/kernel/vm86_32.c: irq handler cleanup
    
    Obtain the data we want (irq number) via dev_id.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 arch/x86/kernel/vm86_32.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

f57c82aa01f4387c8400acb43afa7fc580635e16
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 157e4be..336618b 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -739,8 +739,9 @@ static int irqbits;
 	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
 	| (1 << SIGUNUSED) )
 	
-static irqreturn_t irq_handler(int intno, void *dev_id)
+static irqreturn_t irq_handler(int dummy, void *dev_id)
 {
+	int intno = (int)(unsigned long) dev_id;
 	int irq_bit;
 	unsigned long flags;
 
@@ -822,7 +823,8 @@ static int do_vm86_irq_handling(int subfunction, int irqnumber)
 			if (!((1 << sig) & ALLOWED_SIGS)) return -EPERM;
 			if (invalid_vm86_irq(irq)) return -EPERM;
 			if (vm86_irqs[irq].tsk) return -EPERM;
-			ret = request_irq(irq, &irq_handler, 0, VM86_IRQNAME, NULL);
+			ret = request_irq(irq, irq_handler, 0, VM86_IRQNAME,
+					  (void *)(unsigned long) irq);
 			if (ret) return ret;
 			vm86_irqs[irq].sig = sig;
 			vm86_irqs[irq].tsk = current;
