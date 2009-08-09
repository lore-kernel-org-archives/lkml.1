Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZHITyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZHITyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZHITyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:54:36 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:45798 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZHITye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N9/xQADYrptxR67u88FhXLz/hU4JPLSgEwArcTpkpLG7pIBdjOXEdkHr/65eWF4HFu
         i5Tgr7LcHihsi5YPypHH50PpdgZeXeehGp3zFZjmm6pQyeragkt5ff/R7LF86nUKrQ10
         J309x7cfb+cq5GzOzCuafp7Pmq8ZeJroI80to=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 05/14] x86: use printk_once
Date: Sun,  9 Aug 2009 21:54:00 +0200
Message-Id: <1249847649-11631-6-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/irq_32.c |    5 ++---
 arch/x86/kvm/x86.c       |    7 +------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 3b09634..7d35d0f 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -218,7 +218,6 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 void fixup_irqs(void)
 {
 	unsigned int irq;
-	static int warned;
 	struct irq_desc *desc;
 
 	for_each_irq_desc(irq, desc) {
@@ -236,8 +235,8 @@ void fixup_irqs(void)
 		}
 		if (desc->chip->set_affinity)
 			desc->chip->set_affinity(irq, affinity);
-		else if (desc->action && !(warned++))
-			printk("Cannot set affinity for irq %i\n", irq);
+		else if (desc->action)
+			printk_once("Cannot set affinity for irq %i\n", irq);
 	}
 
 #if 0
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe5474a..0572c90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2261,12 +2261,7 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 				     unsigned int bytes,
 				     struct kvm_vcpu *vcpu)
 {
-	static int reported;
-
-	if (!reported) {
-		reported = 1;
-		printk(KERN_WARNING "kvm: emulating exchange as write\n");
-	}
+	printk_once(KERN_WARNING "kvm: emulating exchange as write\n");
 #ifndef CONFIG_X86_64
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes == 8) {
-- 
1.6.3.3

