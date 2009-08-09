Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZHIUbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZHIUbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZHIUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:31:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZHIUbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:31:07 -0400
Date: Sun, 9 Aug 2009 20:30:39 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, marcin.slusarz@gmail.com, mingo@elte.hu
In-Reply-To: <1249847649-11631-6-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-6-git-send-email-marcin.slusarz@gmail.com>
Subject: [tip:x86/cleanups] x86: Use printk_once()
Message-ID: <tip-9f51e24ee8b5a1595b6a5ac0c2be278a16488e75@git.kernel.org>
Git-Commit-ID: 9f51e24ee8b5a1595b6a5ac0c2be278a16488e75
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 20:30:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f51e24ee8b5a1595b6a5ac0c2be278a16488e75
Gitweb:     http://git.kernel.org/tip/9f51e24ee8b5a1595b6a5ac0c2be278a16488e75
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Sun, 9 Aug 2009 21:54:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 22:28:34 +0200

x86: Use printk_once()

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
LKML-Reference: <1249847649-11631-6-git-send-email-marcin.slusarz@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
