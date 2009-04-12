Return-Path: <linux-kernel-owner+w=401wt.eu-S1752293AbZDLR61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbZDLR61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZDLR6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:39347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZDLR6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:58:15 -0400
Date: Sun, 12 Apr 2009 17:57:34 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090412165058.277579847@openvz.org>
References: <20090412165058.277579847@openvz.org>
Subject: [tip:x86/apic] x86: irq.c - tiny cleanup
Message-ID: <tip-edea7148a87c099e5d5d4838285cc27e459588b7@git.kernel.org>
Git-Commit-ID: edea7148a87c099e5d5d4838285cc27e459588b7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 17:57:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  edea7148a87c099e5d5d4838285cc27e459588b7
Gitweb:     http://git.kernel.org/tip/edea7148a87c099e5d5d4838285cc27e459588b7
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 12 Apr 2009 20:47:39 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 19:23:52 +0200

x86: irq.c - tiny cleanup

Impact: cleanup, robustization

 1) guard ack_bad_irq with printk_ratelimit since there is no
    guarantee we will not be flooded one day

 2) use pr_emerg() helper

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090412165058.277579847@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/irq.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3aaf7b9..6603492 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -24,7 +24,8 @@ void (*generic_interrupt_extension)(void) = NULL;
  */
 void ack_bad_irq(unsigned int irq)
 {
-	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
+	if (printk_ratelimit())
+		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
@@ -178,7 +179,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_thermal_count;
 # ifdef CONFIG_X86_64
 	sum += irq_stats(cpu)->irq_threshold_count;
-#endif
+# endif
 #endif
 	return sum;
 }
@@ -219,8 +220,8 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 #endif
 
 		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
-			       __func__, smp_processor_id(), vector, irq);
+			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
+				__func__, smp_processor_id(), vector, irq);
 	}
 
 	irq_exit();
