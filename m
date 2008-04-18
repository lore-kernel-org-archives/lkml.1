Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbYDRX1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbYDRX1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYDRXXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:23:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57005 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbYDRXXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:23:19 -0400
Message-Id: <ff3fae70ff950602df4271d8f4a6e36a85421e58.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/15] [X86] standard vm86 irq handler
Date: Fri, 18 Apr 2008 19:23:03 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefer 'void *dev_id' argument for passing data from request_irq() to
each per-irq handler invocation.

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/x86/kernel/vm86_32.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 38f566f..e610c08 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -735,9 +735,9 @@ static int irqbits;
 	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
 	| (1 << SIGUNUSED))
 
-static irqreturn_t irq_handler(int intno, void *dev_id)
+static irqreturn_t irq_handler(int dummy, void *dev_id)
 {
-	int irq_bit;
+	int irq_bit, intno = (int)(unsigned long) dev_id;
 	unsigned long flags;
 
 	spin_lock_irqsave(&irqbits_lock, flags);
@@ -818,7 +818,8 @@ static int do_vm86_irq_handling(int subfunction, int irqnumber)
 			if (!((1 << sig) & ALLOWED_SIGS)) return -EPERM;
 			if (invalid_vm86_irq(irq)) return -EPERM;
 			if (vm86_irqs[irq].tsk) return -EPERM;
-			ret = request_irq(irq, &irq_handler, 0, VM86_IRQNAME, NULL);
+			ret = request_irq(irq, irq_handler, 0, VM86_IRQNAME,
+					  (void *)(unsigned long) irq);
 			if (ret) return ret;
 			vm86_irqs[irq].sig = sig;
 			vm86_irqs[irq].tsk = current;
-- 
1.5.4.1

