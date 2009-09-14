Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbZINUXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbZINUXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZINUIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53990 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbZINUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:17 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 05/72] Blackfin: checkpatch --file arch/blackfin/kernel/ipipe.c
Date: Mon, 14 Sep 2009 16:07:09 -0400
Message-Id: <1252958896-25150-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ipipe.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index b8d2203..a725677 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -30,10 +30,10 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/kthread.h>
-#include <asm/unistd.h>
+#include <linux/unistd.h>
+#include <linux/io.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 
 DEFINE_PER_CPU(struct pt_regs, __ipipe_tick_regs);
 
@@ -90,6 +90,7 @@ void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs)
 	struct ipipe_percpu_domain_data *p = ipipe_root_cpudom_ptr();
 	struct ipipe_domain *this_domain, *next_domain;
 	struct list_head *head, *pos;
+	struct ipipe_irqdesc *idesc;
 	int m_ack, s = -1;
 
 	/*
@@ -100,17 +101,20 @@ void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs)
 	 */
 	m_ack = (regs == NULL || irq == IRQ_SYSTMR || irq == IRQ_CORETMR);
 	this_domain = __ipipe_current_domain;
+	idesc = &this_domain->irqs[irq];
 
-	if (unlikely(test_bit(IPIPE_STICKY_FLAG, &this_domain->irqs[irq].control)))
+	if (unlikely(test_bit(IPIPE_STICKY_FLAG, &idesc->control)))
 		head = &this_domain->p_link;
 	else {
 		head = __ipipe_pipeline.next;
 		next_domain = list_entry(head, struct ipipe_domain, p_link);
-		if (likely(test_bit(IPIPE_WIRED_FLAG, &next_domain->irqs[irq].control))) {
-			if (!m_ack && next_domain->irqs[irq].acknowledge != NULL)
-				next_domain->irqs[irq].acknowledge(irq, irq_to_desc(irq));
+		idesc = &next_domain->irqs[irq];
+		if (likely(test_bit(IPIPE_WIRED_FLAG, &idesc->control))) {
+			if (!m_ack && idesc->acknowledge != NULL)
+				idesc->acknowledge(irq, irq_to_desc(irq));
 			if (test_bit(IPIPE_SYNCDEFER_FLAG, &p->status))
-				s = __test_and_set_bit(IPIPE_STALL_FLAG, &p->status);
+				s = __test_and_set_bit(IPIPE_STALL_FLAG,
+						       &p->status);
 			__ipipe_dispatch_wired(next_domain, irq);
 			goto out;
 		}
@@ -121,14 +125,15 @@ void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs)
 	pos = head;
 	while (pos != &__ipipe_pipeline) {
 		next_domain = list_entry(pos, struct ipipe_domain, p_link);
-		if (test_bit(IPIPE_HANDLE_FLAG, &next_domain->irqs[irq].control)) {
+		idesc = &next_domain->irqs[irq];
+		if (test_bit(IPIPE_HANDLE_FLAG, &idesc->control)) {
 			__ipipe_set_irq_pending(next_domain, irq);
-			if (!m_ack && next_domain->irqs[irq].acknowledge != NULL) {
-				next_domain->irqs[irq].acknowledge(irq, irq_to_desc(irq));
+			if (!m_ack && idesc->acknowledge != NULL) {
+				idesc->acknowledge(irq, irq_to_desc(irq));
 				m_ack = 1;
 			}
 		}
-		if (!test_bit(IPIPE_PASS_FLAG, &next_domain->irqs[irq].control))
+		if (!test_bit(IPIPE_PASS_FLAG, &idesc->control))
 			break;
 		pos = next_domain->p_link.next;
 	}
@@ -333,12 +338,9 @@ asmlinkage void __ipipe_sync_root(void)
 
 void ___ipipe_sync_pipeline(unsigned long syncmask)
 {
-	if (__ipipe_root_domain_p) {
-		if (test_bit(IPIPE_SYNCDEFER_FLAG, &ipipe_root_cpudom_var(status)))
-			return;
-	}
+	if (__ipipe_root_domain_p &&
+	    test_bit(IPIPE_SYNCDEFER_FLAG, &ipipe_root_cpudom_var(status)))
+		return;
 
 	__ipipe_sync_stage(syncmask);
 }
-
-EXPORT_SYMBOL(show_stack);
-- 
1.6.4.2

