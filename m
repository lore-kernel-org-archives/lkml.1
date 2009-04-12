Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZDLQw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZDLQw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZDLQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:51:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43571 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZDLQvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Lr6Yy3v59d/I+aTaoVimz7P/1NS9fbcnOQo9nvv6c+PKByZiBV26FqgrP3PVZtzyGu
         8dhfbRqPEO9m2rzDuoUMQ3wYKSMkBBx8jwDsYxnAfN3w8yts1zGsmbymrPditRkH7Z8S
         5vyNoJEZw23hDIAyC5bsmcr/SLt8uLldcNtuw=
Message-Id: <20090412165058.277579847@openvz.org>
User-Agent: quilt/0.47-1
Date: Sun, 12 Apr 2009 20:47:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: xemul@openvz.org, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       macro@linux-mips.org, andi@firstfloor.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 1/4] x86: irq.c - tiny cleanup
References: <20090412164738.967602112@openvz.org>
Content-Disposition: inline; filename=x86-irq-cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

1) guard ack_bad_irq with printk_ratelimit since there is no
   guarantee we will not be flooded one day
2) use pr_emerg helper

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irq.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irq.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -24,7 +24,8 @@ void (*generic_interrupt_extension)(void
  */
 void ack_bad_irq(unsigned int irq)
 {
-	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
+	if (printk_ratelimit())
+		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
@@ -188,7 +189,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
 	sum += irq_stats(cpu)->irq_thermal_count;
 # ifdef CONFIG_X86_64
 	sum += irq_stats(cpu)->irq_threshold_count;
-#endif
+# endif
 #endif
 	return sum;
 }
@@ -229,8 +230,8 @@ unsigned int __irq_entry do_IRQ(struct p
 #endif
 
 		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
-			       __func__, smp_processor_id(), vector, irq);
+			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
+				__func__, smp_processor_id(), vector, irq);
 	}
 
 	irq_exit();

